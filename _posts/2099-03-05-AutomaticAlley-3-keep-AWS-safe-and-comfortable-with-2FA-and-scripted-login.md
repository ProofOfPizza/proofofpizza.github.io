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
  - aws
  - devops
  - security
  - IAM
  - AWS
  - passwords
---
And here is the third in the series "AutomaticAlley" where I share some tips, tricks, bits and bites to make day to day life easier. Especially for us nerds on the command line. In this episode we'll have a look at enforcing AWS IAM users to setup 2FA and then how to make that bearable by scripting the login.

As I have [said before]:[post_mfa] 2FA (or MFA in general) is of crucial importance when working with cloud providers such as AWS, GCP, or Azure. A simple risk analysis says that:
```
Risk = probability * impact
Risk = really quite possible though not immediately likely * selling your house and living in debt for the rest of your days = worth the trouble of using 2FA
```

See? Math is easy!

Now then how do we force our IAM users (being your colleagues) to use 2FA ?



[blog]: https://dev.to/matrixersp/how-to-use-fzf-with-ripgrep-to-selectively-ignore-vcs-files-4e27
