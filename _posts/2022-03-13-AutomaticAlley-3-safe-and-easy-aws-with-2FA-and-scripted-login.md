---
header:
  overlay_image: /assets/images/alley1.jpg
title: "#AutomaticAlley #3 - Safe and easy AWS with 2FA and scripted login"
categories:
  - tech
  - AutomaticAlley
tags:
  - automatic-alley
  - linux
  - automation
  - bash
  - scripting
  - devops
  - security
  - IAM
  - AWS
  - passwords
---
And here is the third in the series "AutomaticAlley" where I share some tips, tricks, bits and bites to make day to day life easier. Especially for us nerds on the command line. In this episode we'll have a look at enforcing AWS IAM users to setup 2FA and then how to make that bearable by scripting the login. This writing is sort an extension of my [earlier blog post][blog].

As I have [said before][blog] 2FA (or MFA in general) is of crucial importance when working with cloud providers such as AWS, GCP, or Azure. A simple risk analysis says that:
```
Risk = probability * impact
Risk = really quite possible though not immediately likely * selling your house and living in debt for the rest of your days = worth the trouble of using 2FA
```

See? Math is easy!

Now then how do we make sure our IAM users (being your colleagues) to use 2FA ? We setup a policy for that! IAM let's us create users or roles, and attach policies to them which describe exactly:
1. What the `effect` is: `allow` or `deny`
2. What `action` we are talking about
3. What the relevant resources are for that action
4. Which version of the language syntax rules.

There are more options, such as `conditions` to make even more fine grained rules for you users. Specifying `Sid` can help you document and make for easier understanding. All of this is just in plan `json` structure so for most of us reading this, and even remotely interested in setting this up, quite readable. If you find it hard, there is always the option to specify it in the AWS Console. (In fact in that case I would recommend selecting `json`, the copy paste this document, click on `Policy Summary`.)

## The policy to deny everything if no MFA is present

In our case the policy would like:
{% include code-header.html %}
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowViewAccountInfo",
            "Effect": "Allow",
            "Action": [
                "iam:ListUsers",
                "iam:ListMFADevices",
                "iam:GetAccountPasswordPolicy",
                "iam:GetAccountSummary"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowChangeOwnPasswordsOnFirstLogin",
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword",
                "iam:GetUser"
            ],
            "Resource": "arn:aws:iam::*:user/${aws:username}"
        },
        {
            "Sid": "AllowChangeOwnPasswordsAfterMFAEnabled",
            "Effect": "Allow",
            "Action": [
                "iam:GetLoginProfile",
                "iam:UpdateLoginProfile"
            ],
            "Resource": "arn:aws:iam::*:user/${aws:username}"
        },
        {
            "Sid": "AllowManageOwnVirtualMFADevice",
            "Effect": "Allow",
            "Action": [
                "iam:CreateVirtualMFADevice",
                "iam:DeleteVirtualMFADevice"
            ],
            "Resource": "arn:aws:iam::*:mfa/${aws:username}"
        },
        {
            "Sid": "AllowManageOwnUserMFA",
            "Effect": "Allow",
            "Action": [
                "iam:DeactivateMFADevice",
                "iam:EnableMFADevice",
                "iam:ListMFADevices",
                "iam:ResyncMFADevice"
            ],
            "Resource": "arn:aws:iam::*:user/${aws:username}"
        },
        {
            "Sid": "DenyAllExceptListedIfNoMFA",
            "Effect": "Deny",
            "NotAction": [
                "iam:ListUsers",
                "iam:ListMFADevices",
                "iam:ChangePassword",
                "iam:GetUser",
                "iam:CreateVirtualMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:DeactivateMFADevice",
                "iam:EnableMFADevice",
                "iam:ListMFADevices",
                "iam:ResyncMFADevice"
            ],
            "Resource": "*",
            "Condition": {
                "BoolIfExists": {
                    "aws:MultiFactorAuthPresent": "false"
                }
            }
        }
    ],
    "Id": "MFA Required IAM Policy"
}
```
Shall we do quick run through of this document? First we describe rights to see account info: we `allow` some list and read access to users, devices, and policies. We specify this for `"Resource": "arn:aws:iam::*:user/${aws:username}"`. This is an `ARN` or `Amazon Resource Name`, a way to identify well, Amazon resources. It is made up of several components, usually something like `arn:aws:<the service>:<the account number>:<resource-type>`. In this case it is simply within service `iam`, for any (`*`) account you have access to, the current user. In short you can do all this, as long as it is about your current user.

Then the following blocks are somewhat similar: We allow the user to change their password on first login, after setting up MFA, and of course we allow the user to setup MFA and use it. If you understood the structure of the first block these blocks are sort of self-evident.

Now the spice in the salsa here is found in the last block `DenyAllExceptListedIfNoMFA`. Contrary to the other statements this one has effect `Deny`. Then it has another negation: `NotAction`, which means that _we deny not the following actions_ or _we deny all but the following actions_ or in even more plain english: _we allow ONLY the following actions_. Then we list those actions: all basic actions that will allow our user to to nothing important except setup their MFA.

The last part to point your attention to is the `Condition` block. It basically says: "All the above, is only valid under this condition: 'If the user has no MFA present'"

Pretty neat right ? If you want to play along: just create a user in IAM, and attach this policy to them. Then either login into the console, or make sure you create access keys and log in on the cli. You will find it nice and boring! Nothing to do, except set up you MFA! But once you do, well... then who knows? Meaning: You should also specify more policies for the user. Normally we would do this in a separate document, because you can attach multiple policies to a user. This way you can reuse this policy for all your users, or those in certain groups. And at the same time, specify specific access to users based on what they need to be doing in AWS.

## Login on the cli

The AWS cli is a very useful and powerful tool. It gives you direct access to the AWS api: you can list and look at resources, create update and delete them. As such it should be clear why it is important to be careful with your credentials!

Running a simple command such as `aws ec2 describe-instances` will be successful only if you can be authenticated (you are who you say you are) and you have sufficient authorization (you are allowed to do what you want to do). How does this work on the cli ?

There are multiple options:
1. Provide your credentials in the command line with the command every time. (Who even does this ?)
2. Make use of the [environment or shell variables][ask_ubuntu] `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and if using MFA `AWS_SESSION_TOKEN`
3. Use the credentials stored in the default credential file: `~/.aws/credentials`.

This is also the order in which the possibilities are evaluated. The last option is easiest to setup using the `aws configure` [command][aws_configure].

Lets have a look at that file. If you open it in your favorite editor you should see something like:
```
[default]
aws_access_key_id=AKIAXXXXXXXXXXXXXXXX
aws_secret_access_key=someunreadablemumbojumboxxxxxxxxxxxxxxx
```

Almost nothing to explain there: it shows the credentials and `[default]` tells us this is the default `profile`. We can set up different profiles and name them as we want. For instance if we have a different user that has read only rights. To use that user we would add a part to `~/.aws/credentials`:
```
[default]
aws_access_key_id=AKIAXXXXXXXXXXXXXXXX
aws_secret_access_key=someunreadablemumbojumboxxxxxxxxxxxxxxx

[readonly]
aws_access_key_id=AKIAYYYYYYYYYYYYYYYY
aws_secret_access_key=someotherunreadablemumbojumboxxxxxxxxxx
```

## But what about MFA ?

But if you have been impatient, curious or both and you set up the policy as described above and you tried to run the command `aws ec2 describe-instances` you probably found:
```
An error occurred (UnauthorizedOperation) when calling the DescribeInstances operation: You are not authorized to perform this operation.
```

***Note: This assumes you have your credentials set up in the credentials file. Otherwise you will not even be authenticated!***

This tells us we were in fact authenticated, but we were not allowed to perform this operation. Makes sense, we explicitly denied all that!
But maybe you were smart and actually set up MFA. For instance using your phone and an authenticator app. Now you want to login but how ??

Not to worry, this is how: From the above options we ignore option 1. simply because that is insane.
Options 2 and 3 are somewhat more doable.

To login we normally need our username, password and MFA token. That temporary token you get from your authenticator app. To login using the cli we use the access_key, the secrets_access_key and the session_token.
And we can get the session_token using the command `aws sts get-session-token`. It takes a number of arguments:
1. The ARN of your MFA device. You can find it by running `aws iam list-mfa-devices`
2. Token code. You find this in your authenticator app.
3. Duration in seconds. You should set this to a sane value. We'll get to this later on.

So the final command could be:
{% include code-header.html %}
```
aws sts get-session-token --serial-number arn:aws:iam::111222333444:mfa/My_User --token-code 192952 --duration-seconds 72000
```
The answer will look something like:
```
Credentials:
  AccessKeyId: ASIAXXXXXXXXXXXXXXXX
  Expiration: '2022-03-14T07:07:36+00:00'
  SecretAccessKey: /19dlJorSomeothing+like_this4tFdicOkBJ1I
  SessionToken: IQoJb3JpZ2luX2VjEMv//////////wEaDGV1LWNlbnRyYWwtMSJIMEYCIQDUiP18GiJROFi19/TSRJBVG1ZYmpBCNEcZOmEUPEyXEQIhAPtHSOWW27fpk5fGyttOoHx1KKshS4LjbAEKb62hWWK1Ku8BCEQQARoMNjQwNzUzMjQ0NDk4IgzYyM9Lhvtb097v57oqzAHKmj784kousxlPGZIHt6Rkn5fN+FYMhQUquk+g7dauTngCIskvOxvgUjTUSIit6Fg8r2EcGMIKD+vdKNwdkchZkfvgxypioVmb1t70NTMrqgPoMjexBqiGVq9SxUKofxnhBKe5lphfseqpXUKk/QEXHqUVqrZ2P9XCeMyf/clT+Q4npL1NhMLsXXeS5fvoYMlCfZcXkTvfau3WEwlDVGEZQQiUP+yF9j4wdhtZX3saGMVUrqwUO6mEJphxnKavVoNAxljmtrM/cj2bBcYw+KC3kQY6lwEUWU3FDrG+R0IIjrV4lNP9E9Fx6JODMGktCoIgpfTewoHhli0IBEhrHU7U7900ACNAtMIsjT2ezFK2kNmhyH2p+OUORC56eeLVEv53+QHgjLNdbpUITHobFTrwjjmH+LAxzTdZh89BrNRyWsiOaFLRsJuCqpKliAJyuHldrRoA1DXRAojB37ihrZTz1h0ShML8sYE1OjaX
```

Great! ... But how do we now use that ?

## Environment Variables
As we saw, the second option was to use environment variables.
Setting them on the command line is easy! Just run:
```
export AWS_ACCESS_KEY_ID=ASIAXXXXXXXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=/19dlJorSomeothing+like_this4tFdicOkBJ1I
export AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEMv//////////wEaDGV1LWNlbnRyYWwtMSJIMEYCIQDUiP18GiJROFi19/TSRJBVG1ZYmpBCNEcZOmEUPEyXEQIhAPtHSOWW27fpk5fGyttOoHx1KKshS4LjbAEKb62hWWK1Ku8BCEQQARoMNjQwNzUzMjQ0NDk4IgzYyM9Lhvtb097v57oqzAHKmj784kousxlPGZIHt6Rkn5fN+FYMhQUquk+g7dauTngCIskvOxvgUjTUSIit6Fg8r2EcGMIKD+vdKNwdkchZkfvgxypioVmb1t70NTMrqgPoMjexBqiGVq9SxUKofxnhBKe5lphfseqpXUKk/QEXHqUVqrZ2P9XCeMyf/clT+Q4npL1NhMLsXXeS5fvoYMlCfZcXkTvfau3WEwlDVGEZQQiUP+yF9j4wdhtZX3saGMVUrqwUO6mEJphxnKavVoNAxljmtrM/cj2bBcYw+KC3kQY6lwEUWU3FDrG+R0IIjrV4lNP9E9Fx6JODMGktCoIgpfTewoHhli0IBEhrHU7U7900ACNAtMIsjT2ezFK2kNmhyH2p+OUORC56eeLVEv53+QHgjLNdbpUITHobFTrwjjmH+LAxzTdZh89BrNRyWsiOaFLRsJuCqpKliAJyuHldrRoA1DXRAojB37ihrZTz1h0ShML8sYE1OjaX
```

And that is it! Now if you run `aws ec2 describe-instances` you should get a pretty answer that shows you all your ec2 machines and their properties.

## The credentials file

The other option is to tweak the credentials file. We can add a profile `[MFA]` there and list the data we got from the `aws sts get-session-token`:
{% include code-header.html %}
```
[default]
aws_access_key_id=AKIAXXXXXXXXXXXXXXXX
aws_secret_access_key=someunreadablemumbojumboxxxxxxxxxxxxxxx

[MFA]
aws_access_key_id=ASIAXXXXXXXXXXXXXXXX
aws_ecret_access_key=/19dlJorSomeothing+like_this4tFdicOkBJ1I
aws_session_token=IQoJb3JpZ2luX2VjEMv//////////wEaDGV1LWNlbnRyYWwtMSJIMEYCIQDUiP18GiJROFi19/TSRJBVG1ZYmpBCNEcZOmEUPEyXEQIhAPtHSOWW27fpk5fGyttOoHx1KKshS4LjbAEKb62hWWK1Ku8BCEQQARoMNjQwNzUzMjQ0NDk4IgzYyM9Lhvtb097v57oqzAHKmj784kousxlPGZIHt6Rkn5fN+FYMhQUquk+g7dauTngCIskvOxvgUjTUSIit6Fg8r2EcGMIKD+vdKNwdkchZkfvgxypioVmb1t70NTMrqgPoMjexBqiGVq9SxUKofxnhBKe5lphfseqpXUKk/QEXHqUVqrZ2P9XCeMyf/clT+Q4npL1NhMLsXXeS5fvoYMlCfZcXkTvfau3WEwlDVGEZQQiUP+yF9j4wdhtZX3saGMVUrqwUO6mEJphxnKavVoNAxljmtrM/cj2bBcYw+KC3kQY6lwEUWU3FDrG+R0IIjrV4lNP9E9Fx6JODMGktCoIgpfTewoHhli0IBEhrHU7U7900ACNAtMIsjT2ezFK2kNmhyH2p+OUORC56eeLVEv53+QHgjLNdbpUITHobFTrwjjmH+LAxzTdZh89BrNRyWsiOaFLRsJuCqpKliAJyuHldrRoA1DXRAojB37ihrZTz1h0ShML8sYE1OjaX
```
To use this profile we have to specify it in the commands we use. So now it becomes:
{% include code-header.html %}
```
aws ec2 describe-instances --profile MFA
```
And again: works like a charm! We can use this with any aws cli command, and we will have to if we want to use this profile.

## The problem
Now then, what is the problem  with this ? Well... Do you know anyone who wants to do this all the time ? Each time you open up a new terminal get the credentials and set all the environment variables?
Or time and time again editing the `~/.aws/credentials` file copy pasting stuff ? Well I don't. So the results will be:
1. People start complaining. And with people I mean us too!
2. People will try to minimize the effort by putting the `duration` as long as possible, effectively reducing security.
3. If the above happens enough and pressure gets high enough you may be forced to undo this whole exercise and return to a situation with no enforced MFA. A very [dangerous situation][blog] indeed!

## The solution
Of course the solution is what it always is for these type of manual nuisances: automate them into oblivion!

So without further ado let get our hands dirty and `bash` away (Sorry for that, could not resist!).
Find a good location to store bash scripts, and create a new file `aws-set-auth.sh`. In it we write:
{% include code-header.html %}
```
#/bin/bash

TOKEN=${1}
if [[ -z $TOKEN ]]
then
  echo "please provide a session token"
  exit 1
fi
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
CREDS=$(aws sts get-session-token --serial-number arn:aws:iam::640753244498:mfa/Chai_inQuisitive --token-code $TOKEN --duration-seconds 14400 --output json | jq .Credentials )
if [[ -z $CREDS ]]
then
  echo "Invalid token. Access Denied"
  exit 1
fi
AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r .AccessKeyId)
AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r .SecretAccessKey)
AWS_SESSION_TOKEN=$(echo $CREDS | jq -r .SessionToken)
echo "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> tmp.env
echo "export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> tmp.env
echo "export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> tmp.env
echo "creds are set in ENVIRONMENT VARS"

CRED_FILE_NAME=~/.aws/credentials
OUTPUT_FILE=()
readarray -t CRED_FILE < "${CRED_FILE_NAME}"
for LINE in "${CRED_FILE[@]}"
do
  OUTPUT_FILE+=( "${LINE}" )
  if [[ "${#OUTPUT_FILE[@]}" >1 && "${OUTPUT_FILE[-2]}" = "[MFA]" ]]
  then
    unset OUTPUT_FILE[-1]
  fi
  if [[ "${OUTPUT_FILE[-1]}" = "[MFA]" && -z $LINE ]]
  then
    OUTPUT_FILE+=( "aws_access_key_id=${AWS_ACCESS_KEY_ID}" )
    OUTPUT_FILE+=( "aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}" )
    OUTPUT_FILE+=( "aws_session_token=${AWS_SESSION_TOKEN}" )
    OUTPUT_FILE+=( "${LINE}" )
  fi
done

printf "%s\n" "${OUTPUT_FILE[@]}" > "${CRED_FILE_NAME}"
echo "profile [MFA] updated ~./aws/credentials as profile"

```

Okay, so let's have a look at what we have here. The first line just tells us we want this file to be interpreted as a bash file.
`TOKEN=${1}` means store the first command line argument (after the script name!) in a variable `TOKEN`.

Then we check if that argument was given and if not we tell the user to provide it and we exit.
If all is good we proceed to the next part where we `unset` the environment variables.

The next line is what we have seen before: Getting the credentials. In this case we `pipe` them into [jq][jq] to parse them and store the result in a variable `CREDS`. This means that you need to have [jq][jq] installed on your machine. If you don't it will not work. But you probably should anyway because it is one of the most useful and crucial tools we have on the command line.

Then we do another check to see if all went well, if not, we tell the user and exit. Just like before.

After this we will use the credentials in the ways we read about before: exporting them as environment variables and editing the `~/.aws/credentials` file.
There is a bit of weird magic here. We first simply export the environment variables as we did before. Nothing strange about that, we know how that works. But then we also write these `export` instructions themselves to a temporary file. We will use these later! Just read on for now!

The last bit is probably the most difficult to read if you are not very familiar with bash scripting. In general what it does is this:
1. Create an empty output file
2. Read the credentials file
3. Go over it line by line and
  - Add the line to the output file
  - Check if the previous line was `[MFA]`. So we identify the part that we need to change.
  - If so add the credentials.
4. Overwrite the credentials file with the output file.

***Note: If you carefully followed this part you see why this script can handle any number of profiles in your credentials file but also why the [MFA] profile MUST be the last one there! There are probably ways to improve. There always are. But to balance complexity with usability brought me to this point if you want to improve on it: go right ahead!***

***Also please note that I have set the duration to 14400 seconds which is `60 sec * 60 minutes * 4 hours`. For me 4 hours sounded reasonable. If you need it to be stricter, just turn it down to 1 hour or whatever meets your needs.***

## Using the script
So we are now ready to use the script. We run:
{% include code-header.html %}
```
bash path-to-script-directory/aws-set-auth.sh <token>
```
Where we replace `<token>` with the token we get from the authenticator app. It will print out:
```
creds are set in ENVIRONMENT VARS
profile [MFA] updated ~./aws/credentials as profile
```

So nice! Right? But can we make it even easier? Sure! Because first of all this command is slightly longer then a lazy person likes, and more importantly if we have to look for that script and the path every time... well... Eeeuw!
<div style="width:100%;height:0;padding-bottom:56%;position:relative;pointer-events:none;"><iframe src="https://giphy.com/embed/hshZwZemt0r28" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div>

## Wrap it all in one simple command
Bash, zsh or fish whatever our shell of choice is, will allow us to call this script. This enables us to use a single, easy command wherever we are on the command line (provided that in that location we have access to the aws cli and jq of course, but most people would have those installed globally).

The normal and quick way to do such things is: Create an `alias` instruction in the `.bashrc` (or `.zshrc` or `.fishrc`) file. Something like:
`alias authaws="bash ~/script-directory/aws-set-auth.sh"`

Doing this will give you no problems or errors. The only downside is that the script actually does not really work. Sad! The reason is somewhat technical in that bash will start a new session, execute the script there, set all the environment variables, and then finish the script and kill the session. Then returning to where you were it will happily say all was well. But you are left without proper environment variables set of course!

To get around this we adapt [this solution][bash_variables]:
1. In our `aws-set-auth.sh` script we write export instruction to a temporary file `tmp.env`
2. In `.bashrc` we write a function that calls the script, we use the command `source` to execute the `tmp.env` file and then remove that file

In our `.bashrc` this looks like:
{% include code-header.html %}
```
alias authaws='_authaws(){bash ~/.config/nixpkgs/scripts/aws-set-auth.sh "$1" && . ./tmp.env && rm ./tmp.env;}; _authaws'
```

This looks a bit like tricky magic but it isn't. Inside the `alias` _authaws_ we define a function `_authaws()` which executes our script and uses the `.` instruction to source the file (see the [mentioned answer on stack exchange][bash_variables]). Then in the end it actually calls that function.

So now if you followed along you can just run:
{% include code-header.html %}
```
authaws <token>
```
And we can do this in any directory, wherever we are. If it runs out, after the specified time, just rerun it and *boom*, that is it! Easy as eating chocolate and safe as milk!

## Final thoughts
There is always a conflict of interests when it comes to easy of use or comfort on the one hand and security and or privacy on the other. This can lead to very ugly situations.

Some of you may recall a famous incident with a company named [digiNotar][digiNotar] that was doing great and went bankrupt in a month. This was NOT because they had not thought about security, or because they had no security measures in place. In fact they had very tight security in place. But it was just... so annoying! So they decided to make life easier with an extra cable and some settings...

This was not all that was wrong but the bottom line of the story is: Security measures are only useful when people follow them, and the chances of people following them are increased greatly if it is made _easy_ for them. Therefore automation in some cases is not just to speed up things, make them easier or less error-prone, in some cases it actually _increases security_.

If you have any suggestions, comments or improvements reach out! Have a nice week!


[blog]: https://dev.to/matrixersp/how-to-use-fzf-with-ripgrep-to-selectively-ignore-vcs-files-4e27
[ask_ubuntu]: https://help.ubuntu.com/community/EnvironmentVariables
[aws_configure]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html
[bash_variables]: https://askubuntu.com/a/53179
[jq]: https://stedolan.github.io/jq/
[digiNotar]: https://en.wikipedia.org/wiki/DigiNotar
