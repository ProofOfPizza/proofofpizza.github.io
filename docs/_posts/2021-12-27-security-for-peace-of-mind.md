---
title: "Security for peace of mind"
categories:
  - tech
tags:
  - security
  - privacy
  - passwords
---



So this should be a friendly reminder [for you and for me and ... ][mj] to think about the risks associated with your passwords, and login methods. Of course we all know that strong passwords, MFA (multi factor authentication) are important. We're reminded everywhere right ? Right. Except many times we do not. Are you like I was until some time back: messing around with a small set of passwords, maybe have some super secret algorithm that appends a '#' after awhile... Reusing passwords for different sites ? And 2FA ? Sometimes, because you are forced to (hello workplace!)... Or maybe like me a bit later: using many more passwords, mostly based on the same ideas, but because there are too many writing them down in a text file?

Well then this reminder is for you. Now I get it, sometimes it seems to be so irrelevant... why would you need an account for a cooking site in the first place??
I used to think "Well, chances of me getting hacked are very small. I am not an interesting target." And for may things this is true: I am not. However, my passwords could still be included in some greater hack such as "bank XXX was hacked", "facebook passwords hacked" etc. And in some cases I AM a very interesting target. If I were a hacker, I would go looking for people doing tutorials, and courses on these sites. They will many times want to get on with their learning, and disregard security measures (Ever find yourself thinking: "Just for now, I'll fix it later" or "I will delete the account as soon as I am done" ?). Or cooking sites and so on, because those would probably be easier to hack then the heavily secured banks and government websites, but chances are that out of 1000 leaked logins there will be a few people that used the same passwords for other sites. Which can be very very risky and costly!

So here is that reminder again: use long, difficult, randomly generated passwords. Never repeat them, ever. And do not store them in a plain text file. This seems like a huge hassle, and very difficult. But we're in luck: smart people have made password managers for this. Setting on up like [keepass][keepass] or [last pass][lastpass] is pretty easy. Most of them support Windows MacOS Linux as well as mobile platforms. They will solve ALL of these problems:
1. You only ever need to remember ONE password (make it a good one!)
2. Logging in is as easy as a simple copy paste, or it will even auto fill it for you!
3. Your passwords are stored with encryption
3. It will generate long and strong passwords for you

> Hello recently my AWS account was hijacked for a half a day. They managed to rack over 10000 in charges. I haven't used my AWS account in years[..]
>
> <cite>/u/VampDz<cite>

> I had a rarely used AWS account, where out of nowhere I receive an email with a bill of around $25,000
>
> <cite>/u/TabulateRasin<cite>

Now then, everyone happy and all is good ? Alllllmost!
I kept running into posts on Reddit and other places, such as [this][lost] and [this][also-lost] and finally [this][last-post]. People tell time and again things like "I had a rarely used AWS account, where out of nowhere I receive an email with a bill of around $25,000"

Now this made me very uncomfortable. I too had done some online courses for which I opened an AWS account (and others like it). I had not set up MFA, but I was smart enough to use a Keepass generated strong password. But was that smart enough ? These posts made me believe "not so much". And who wants to wake up after the holidays and find a friendly email with an unfriendly bill ? I certainly do not. So I took these steps:

1. deleted any account I am not actively using in this category. (Cloud providers, paid services). Every account I don't have can not be hacked!
2. install 2FA on all accounts I do keep.

> Having an AWS account without a strong password and MFA is like driving drunk. You should be expected to be held accountable.
>
> <cite>/u/TangerineDream82<cite>

I used to think "Well, chances of me getting hacked are very small. I am not an interesting target." And for may things this is true: I am not. However, my passwords could still be included in some greater hack such as "bank XXX was hacked", "facebook passwords hacked" etc. And in some cases I AM a very interesting target. If I were a hacker, I would go looking for people doing tutorials, and courses on these sites. They will many times want to get on with their learning, and disregard security measures (Ever find yourself thinking: "Just for now, I'll fix it later" or "I will delete the account as soon as I am done" ?).

Let me conclude with this: The risks are not equal everywhere, be smart about it. And do yourself a favour and take an hour Monday morning to set up a password manager and 2FA for the important accounts. It may save you from serious debts, legal issues or loss of employment. And now, once you have started thinking about this, it will bring back the comfort of a good night's rest and ease of mind!

For anyone involved with creating users, and roles in AWS: please have a look at this simple solution written up by [Radish Logic][radish] to enforce MFA for IAM users!

Enjoy the rest of the holidays, and have a great, safe and secure 2022!

[mj]: https://youtu.be/BWf-eARnf6U?t=172
[last-pass]: https://www.lastpass.com/
[keepass]: https://keepass.info/
[lost]: https://www.reddit.com/r/aws/comments/ro670s/i_woke_up_to_a_bill_of_2557536_usd/?utm_source=share&utm_medium=web2x&context=3
[also-lost]:   https://www.reddit.com/r/aws/comments/rhte00/aws_account_hacked_aws_wants_me_to_pay_bill/?utm_source=share&utm_medium=web2x&context=3
[last-post]: https://www.reddit.com/r/aws/comments/rocp33/mods_can_we_get_a_sticky_post_telling_anyone_that/?utm_source=share&utm_medium=web2x&context=3
[radish]: https://www.radishlogic.com/aws/require-multi-factor-authentication-mfa-for-iam-user-in-aws/
