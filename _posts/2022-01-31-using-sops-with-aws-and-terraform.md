---
header:
  overlay_image: /assets/images/header-keys.jpg
title: "Setup SOPS with AWS KMS and Terraform to encrypt your secrets in git"
categories:
  - tech
  - tutorial
tags:
  - security
  - devops
  - sops
  - programming
  - terraform
  - AWS
  - infrastructure-as-code
  - encryption
  - configuration-management
---
In this post we'll explore Mozilla SOPS to manage configuration secrets.

There are a number of things to take into consideration, and there are different possible solutions each with their own advantages and problems. Some things however are important and should be possible in any solution:

- secrets should never be stored in plain text in git (duh!).
- it should be possible to specify who has access to which secrets. For instance some members may have access only to dev secrets while others have access to all secrets.
- access to the secrets should be revocable quickly and easily.

Basically there are two different approaches:

1. Keep the secrets in an external system like [Hashicorp Vault][haschicorp-vault], [Azure Key Vault][azure-vault] or [AWS SecretsManager][aws-secretsmanager] and find a way to inject them at runtime. Preferably the agent running the app has some rights based on identity for this. This means we need to setup identity management as well as a vault to keep the secrets. This adds overhead and some risks because it is not always directly clear what the potential risks are. But the advantage is that we can rotate secrets easily, and also by identity management assign or revoke access as the situation demands.
2. Keep the secrets encrypted in git. For this we need to manage access to the encryption key(s). The obvious advantage is that we do not need an external vault, and this may drive development speed and reduces complexity somewhat on that end. The disadvantage is that the deployment secrets are now coupled to the code in git, and in case secrets need to be rotated it involves a new deployment. If you have some gitops and automated pipelines in place this might not be a big problem, but in some situations this is a more serious issue. It also means that `git bisect` will no longer reliably return an answer.

In this blog post we'll look at the second scenario. Not because it is inherently better, but because there are valid usecases for it and there is a really nice solution in the form of [Mozilla SOPS][sops]. SOPS supports encrypting files as binaries, but apart from that it also has the great feature of encrypting only the values of config files as long as they are in the correct formats, being json, yaml, .env or .ini.

I've made a demo project on git to explore how we can set up this solution using terraform to provision the AWS users and keys, and then we configure and use SOPS to encrypt/decrypt a few example configuration secrets.

## Let's set up the repo and initialize terraform!

There is a git repo here: [ProofOfPizza][git]. There are some prerequisites to be able to follow along:

1. You need to have a valid [AWS account][aws-account].
2. You need to have the [AWS cli installed][aws-cli] and
3. You need to have [credentials configured][aws-configure] (usually in `~/.aws/credentials`) for a user (preferably NOT the root user but an IAM user with sufficient rights).
4. You need to have terraform installed.
5. To follow along please do not `clone` the repo but `fork` it.

To install the repo simply go to the [repo][git] in your browser and click `fork`. You are then taken to your own github account and will there see your fork of the repo. Then you just click on `code` and copy the link. In your terminal type `git clone <link>` where <link> should be replaced by the link you just copied.

Then run `cd terraform && terraform init`. This should get you the providers and initialize the terraform project. If you run into issues here please verify your terraform version with `terraform --version`. In the file `providers.tf` the required version is specified: `required_version = "~> 1.1.0"`. Match this with your version if necessary.

We also see this block specifying the aws provider:
{% include code-header.html %}
```
provider "aws" {
  region  = "eu-central-1"
}
```
If you want you can specify any [aws region][aws-region] you want. If you have MFA set up for your user then you have some additional steps to get a token and set up a profile for that user. (I should write another quick post about that). Also if you have multiple users configured in aws-cli you can specify the profile you want to use. You can do this by adding `profile = my_profile`

## Deeper look into the terraform code to create the AWS users and keys

Now to use SOPS we need an encryption key. SOPS is compatible with many backends, but for now we will stick to one. However, SOPS supports using multiple backends simultaneously out of the box. We will create keys in [AWS Key Management Service (KMS)][aws-kms]. This key can be rotated automatically, and with a policy we can specify which users have which rights to it. This way we can also easily revoke the rights if a team member leaves the project for instance.
So for this example we will need three users:

1. A test user with rights to the test key to use sops on the test secrets
2. A prod users with rights to the prod key to use sops on both prod and test secrets
3. A KMS key admin user who has rights to update the keys if necessary. AWS will not allow us to create a key without someone attached to it that could perform these actions.

The terraform code's layout is pretty straightforward:

- `providers.tf` defines the AWS provider
- `outputs` describes all the outputs that our terraform operations will provide. We can later see them in the console using the `terraform output` command.
- `main.tf` contains the definitions for the resources. It uses the terraform `for_each` syntax to loop over value definitions to reduce code duplication.
- `locals.tf` contains those value definitions. The values for the three users and the two keys we create are found here.
- `policies/*.json` are policy documents for the users. Here the allowed actions and resources are specified. To avoid circular dependencies the users have rights on all keys `*` and then the keys have only specific users assigned to them. Otherwise we would have to first create the keys, which would require us to first create the users, which would require us to first create the keys ... well you get the point... or actually, that point never gets fully made :)
- `key-policy.tpl` leverages the `.tpl` terraform template format. It is basically a json file with interpolations. We use the terraform `jsonencode` function to interpolate more complex values than just strings. In this case lists of users:
{% include code-header.html %}
      "Principal": {
    "AWS": ${jsonencode(key_users)}
    },

If you want to learn more about all the options you can set for keys, and what they mean you can read more in the [AWS docs][aws-kms-docs].
    To learn more about how to specify these settings in terraform read the docs for [iam_users][terraform-iam-users-docs] and [kms_keys][terraform-kms-docs] in terraform.

## Terraform apply and creating the aws resources

The KMS keys have a policy that defines who has which rights on them, this also goes for the actions create, update and delete key. For this reason we should add the IAM user that we use for terraform to the KMS keys. Otherwise terraform will be unable to manage them! In `locals.tf` we see:

{% include code-header.html %}
```
locals {
  my_aws_user = "arn:aws:iam::12345678999:user/iam_user_name"
}
```
You will have to replace it with your user's ARN. You can get it from the cli by running `aws sts get-caller-identity`.

Once you feel ready, we can run a speculative plan by running `terraform plan`.
If it all looks good to you you can run `terraform apply` and when asked type `yes` to confirm. After a few moments terraform will inform you of what resources have been created.

## Setup profiles for AWS cli

Now we can use these users to test SOPS, but for this we need to setup the aws cli because SOPS relies on the users being present in the aws cli configuration. AWS cli credentials are kept in a file at `~/.aws/credentials`. You can edit it with your preferred text editor and add the following sections:
{% include code-header.html %}
```
[KMS_ADMIN]
aws_access_key_id=AKIAZKL66TFJJ3EX6UVA
aws_secret_access_key=Qg1QYQMccamGSJww48G1lrst45ziTj5/GrZBgWyc

[KMS_TEST_USER]
aws_access_key_id=AKIAZKL66TFJHY2VOR4D
aws_secret_access_key=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

[KMS_PROD_USER]
aws_access_key_id=AKIAZKL66TFJAW7AGEVG
aws_secret_access_key=JRcWCkG8CuTV4XbluAgB0aCO/WuPKMGZ72QfiHRd
```

These keys will need to be replaced with theones we just created obviously.
Run `terraform output` to display our created resources. You will notice that for the access_keys we specified `sensitive = true` in `outputs.tf`. This ensures it does not get displayed in the console by default. If you want to display it anyway you have to specify the resource: `terraform output access_keys`. Here we can find all the necessary details in the fields `id` and `secret` for the respective users.

To test if our profiles are working we can for instance run `aws sts get-caller-identity --profile KMS_ADMIN`. Any command in the aws cli can be run using a profile in this manner.
If this all works we are now ready to finally use SOPS and see the magic!

## Deeper look into the SOPS configuration

We can easily just encrypt and decrypt files in place specifying the kms key in the command line.... but why would we ? The real use is for projects where we work together and want to store our configs in git and so on. So let's just get directly to a more realistic configuration.
SOPS looks recursively in our directory path for a file called `.sops.yaml`. In this file we can precisely specify which files or paths we want to encrypt, and with which keys. For this project our configuration looks like this:
{% include code-header.html %}
```
creation_rules:
    - path_regex: .*config/test/.*
    kms: arn:aws:kms:eu-central-1:640753212234:key/f9024130-ba9c-458d-ba4a-ca05b06f6f2c
    aws_profile: KMS_TEST_USER

    - path_regex: .*config/prod/.*
    kms: arn:aws:kms:eu-central-1:640753212234:key/02b01f77-35ac-4f24-a23c-87684b6cc01b
    aws_profile: KMS_PROD_USER
```

What does this mean ? It means that any files matching the regex `.*config/test/.*` meaning all files inside `config/test` in this case, will be encrypted using the key `arn:aws:kms:eu-central-1:640753212234:key/f9024130-ba9c-458d-ba4a-ca05b06f6f2c`. And thus only those with access to that key can and see and edit those files.

We suppose for instance that you just joined the team, and got your keys. If you look into the files you will see that for any JSON, YAML, .env file the values are encrypted, and for instance the ssh keys are encrypted as binaries.
    You can decrypt any file in place using `sops -d -i filename`, -d for decrypt and -i for in-place. But then you would have to remember to encrypt them later, and who wants to do that ? So the developers of sops made it easy for us. We just run: `sops filename` and it will decrypt it in memory and open it in our default editor (the one specified in the `$EDITOR` environment variable). Now we see the file in cleartext, we can edit and save it, and when we exit the file it gets reencrypted and saved to the file. How awesome is that !?

Now we assumed we came in the team just fresh, but we got both the prod and test keys. In a real situation we might be developers with only access to the test env. To simulate this edit `~/.aws/credentials` and change a profile name:
{% include code-header.html %}
```
[KMS_PROD_USER_XXX]
aws_access_key_id=AKIAZKL66TFJAW7AGEVG
aws_secret_access_key=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
```

Now go into `config/test` and run `sops default.yaml`. No problem, right? Now try the same in `config/prod`. You will probably see something like:

```
Failed to get the data key required to decrypt the SOPS file.

Group 0: FAILED
arn:aws:kms:eu-central-1:640753212234:key/02b01d66-35ac-4f24-a23c-87684b6cc01b: FAILED
- | Error decrypting key: NoCredentialProviders: no valid
| providers in chain. Deprecated.
| 	For verbose messaging see
| aws.Config.CredentialsChainVerboseErrors
```

Pretty neat right ?

## Git diff


Now let's assume you were hired to actually do something. And you need to add a property, so you run `sops some.env.json` in `config/test`. You add an application url:
{% include code-header.html %}
```
{
  "database": {
    "server": "important-test-sql.database.net",
    "catalog": "important-test-sqldb-application-api",
    "username": "application-test-api-username",
    "password": "application-test-api-password"
  },
  "applicationUrl": "app.test-env.awesome-stuff.com"
}
```

After saving and quitting would like to see what has changed in your files compared to the way things were. And so you run `git diff`. But yeah.... Not quite as informative as you would like it to be ?

```
[...]
"username": "ENC[AES256_GCM,data:XYqrySLKWxIJifFP3vB3T7XZM9vjN6KUxTItO6s=,iv:D4Qd4KvAmApEpqjaAStF9IPR7H4HoiPzdOomh1HpYCo=,tag:3ApMYz4t41ni5qeBXv6XMw==,type:str]",
"password": "ENC[AES256_GCM,data:1vGBvFRCjhTIbbnmolmmjBh1d+eCP5E5Wa8zwG8=,iv:tuoLwKlDRV5wley3CWllgwz03MU619Y9DVeyzRGOxr4=,tag:XiMK5P2/0nEbI+rMnAIaBQ==,type:str]"
},
+       "applicationUrl": "ENC[AES256_GCM,data:f7ce62NuwHVAchtTRSi8slaawvnXSiks5EtfSLg1,iv:UKMRt8XAncqF+qrQmBOxFOCM15XwEMl5jsUchH9dOAY=,tag:+lNZEhXa6+0L7TRvzYNHjQ==,type:str]",
[...]
```

Nope... Not very useful. But we're in luck because even this has been thought of! We create a file `.gitattributes` in the root of our project and in it we write:
{% include code-header.html %}
```
config/** diff=sopsdiffer
```

This tells git that for every file matching the path `config/**`, meaning any file under this directory, we use `sopsdiffer` when we run `git diff`. But what is sopsdiffer? It is just an arbitrary name that could be anything, but we can give it some meaning by running `git config diff.sopsdiffer.textconv "sops -d"`. This command adds a bit to our git config file found in `.git.config`. It now has a part:
{% include code-header.html %}
```
[diff "sopsdiffer"]
textconv = sops -d --config /dev/null
```

If we now run `git diff` we find something a lot more satisfying:

```
[...]
"catalog": "important-test-sqldb-application-api",
"username": "application-test-api-username",
"password": "application-test-api-password"
-       }
+       },
+       "applicationUrl": "app.test-env.awesome-stuff.com"
[...]
```

Sops gets called every time we call `git diff` before displaying it in the console. Didn't I tell you? Awesome stuff!. This should work for most IDE's because they all call `git diff` under the hood. Unfortunately it only partly works if you use vscode as your IDE and try diffing in there. If you want to read more about why it fails, or want to help working out a solution you can track the issue [here][vscode-diff].

## Revoking access to KMS keys

Now let's say you did an awsesome job and are now ready to leave the team on to greater things! Now we need to revoke your access to the KMS keys. With our terraform set up this is a simple two step that can be run by the key_admin user we created:

1. Edit `locals.tf` and from the line 46:

```
policy = templatefile("./policies/key-policy.tpl", {key_users = [aws_iam_user.user["test"].arn, aws_iam_user.user["prod"].arn], key_admins = [aws_iam_user.user["key_admin"].arn, local.my_aws_user]})
```

We remove the test user so it becomes:
{% include code-header.html %}
```
policy = templatefile("./policies/key-policy.tpl", {key_users = [aws_iam_user.user["prod"].arn], key_admins = [aws_iam_user.user["key_admin"].arn, local.my_aws_user]})
```

2. Edit `providers.tf` and `profile = KMS_ADMIN`
3. We run `terraform apply`.

And there, our test user now no longer can decrypt our configurations! Mind you, for now, he still has a user and everything in the cli set up. But our secrets are safe.
Within 2 minutes, everything is safe again. Of course you know up front someone will leave the team, but say a lost laptop could be a more sudden event in which case you need to be able to mitigate these risks quickly!
Obviously if the person not just switched teams but left the company entirely, then we would also remove the user.

## Conclusion and cleanup

Don't forget to clean up properly. DO NOT JUST THROW AWAY THE FOLDER. This will bring you a headache in the AWS console. Instead just:

1. edit `providers.tf` again and remove the profile so we run the cleanup as our own IAM user.
2. run `terraform plan -destroy` and confirm. This will clean up all the resources in AWS.
3. Edit your `~/.aws/credentials` and remove the now redundant profiles.

That's it!
This concludes this write up and example on how to use SOPS for encrypting and decrypting secrets in our configs (and other files), and how to manage all the required resources in AWS with terraform.
I hope you liked it, and please leave any comments or suggestions in the comment section or reach out to me.


[haschicorp-vault]: https://www.hashicorp.com/products/vault
[azure-vault]: https://azure.microsoft.com/en-us/services/key-vault/#product-overview
[aws-secretsmanager]: https://aws.amazon.com/secrets-manager/
[sops]: https://github.com/mozilla/sops
[git]: https://github.com/ProofOfPizza/example-sops-terraform-aws
[aws-account]: https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/
[aws-cli]: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
[aws-configure]: https://docs.aws.amazon.com/cli/latest/reference/configure/
[aws-region]: https://aws.amazon.com/about-aws/global-infrastructure/regions_az/
[aws-kms-docs]: https://docs.aws.amazon.com/service-authorization/latest/reference/list_awskeymanagementservice.html
[terraform-iam-users-docs]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user
[terraform-kms-docs]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key

[vscode-diff]: https://github.com/mozilla/sops/issues/959
[aws-kms]: https://aws.amazon.com/kms/
