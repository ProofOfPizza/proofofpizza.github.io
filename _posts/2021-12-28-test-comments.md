---
title: "Test comments"
categories:
  - tech
tags:
  - infrastructure
  - infrastructure-as-code
  - terraform
---

So after working with terraform you feel confident. Now what ? Well you set up a [terraform cloud][tf-cloud] account, put your terraform code in git and import it there in a workspace with VCS control.
Now you can push changes to git, create a PR, have your colleagues review it and when you merge it terraform will magically run a plan and ask you to approve. Off you go!

But while testing it from your local system there was this great command: `terraform taint <some resource>`. And sometimes, we might still want to use it. For instance I wanted to test a new version of an image for a ECS container on AWS. Normally I would change the project code,
run a PR and have a Jenkins pipeline build and push an image with a new tag and then use that from terraform cloud. But for quick testing on a branch, I just wanted to be able to build an push the image myself,
use the same tag and refresh the ECS task. That's what `terraform taint` is for!

Where is the taint button in the UI for terraform cloud ?


<div style="width:100%;height:0;padding-bottom:46%;position:relative;pointer-events:none"><iframe src="https://giphy.com/embed/26n6WywJyh39n1pBu" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div>

\
I have searched, and searched... and asked my friend [DuckDuckGo][ddg] but no: It is not there. So now what ?

There is a solution: You link your local workspace to the remote one on terraform cloud. Mind you, this is not necessary for anything, except this. No need to run terraform plan or apply, all that now happens magically after pushing to git. In fact if you are like me and don't like your things installed globally: you have a git repo with terraform code, but not even terraform installed there!
But yes, if you need to taint resources, you will have to make terraform is available in that directory, and you will have to link it.
Who knows, maybe terraform will add a taint button at some point, but for now this is what we have.

Here is how: make sure your `terraform backend is set correctly` for example:
```
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "inquisitive-infra"

    workspaces {
      name = "tf-our-great-project"
    }
  }

  required_version = "~> 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

```

And then simply run `terraform init`. This will import the state from terraform cloud to you local machine and import all providers etc as usual. Now you can run `terraform taint <some resource>` and this will take a few seconds to acquire a state lock on terraform cloud. And there you go: Trigger a plan manually from terraform cloud console, and you'll see your resource is tainted and needs to be replaced.

[tf-cloud]: https://app.terraform.io/
[ddg]: https://duckduckgo.com/?q=taint+button+in+terraform+cloud&t=brave&ia=web
[where]: https://media.giphy.com/media/26n6WywJyh39n1pBu/giphy.gif
