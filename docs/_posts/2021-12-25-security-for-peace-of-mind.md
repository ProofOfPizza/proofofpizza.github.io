---
title: "Security for peace of mind"
categories:
  - tech
tags:
  - security
  - privacy
  - passwords
---

Strong passwords, unique passwords per site / app, 2 factor authentication, we all know it is good right? And important.
However, not as important as the comfort of logging in easily... or is it ?

For a long time I myself used just a few passwords, around 5. One for social media stuff, one for email accounts, on REALLY GOOD one for banking stuff.
And because I was aware of the importance of it, I would once in awhile change them, by adding a number, or random '#' at the end or beginning. So I had a few variations to check, but still could log in easily.

Good solution ? Well, not so much obviously. First of all: remembering one REALLY REALLY GOOD password is much easier than remembering ten ALMOST REALLY good ones. So yes: I could make my life easier.
Second: having 150 different REALLY REALLY GOOD passwords, a unique one for each and every site, email, shopping app, calendar-get-together thingy, etc is of course much nicer. (It also showed me hoe many places actually have part of my data...).

However, I postponed making this happen for years and years... why ? Because I thought it would be "a hassle to set up", "what if I lose the main password or the file, then I lose EVERYTHING", "it is probably not REALLY actually EASY or BETTER" and a bunch more reasons, all the way down to some vague "No reason, just didn't until now, and won't right now".

Until I did... I looked into a few options like [last pass][last-pass] and [keepass][keepass]. Decided that for me being open source is important, and went with keepass. Took one hour to figure out how it works and set up some initial first passwords for sites I found important, and made the plan that I would change any new site I logged into as it came up to a secure new password when it came along. That way over some time all of it would be improved without me having to spend an entire day in brain dead work.

Then there is the matter of the encrypted db-file with all the passwords. Surely I would want to keep it places.. but where ? I have a Nextcloud set up (I should write about that some other time!) and that is where I keep it. That way it is always in sync, and even if my computer and phones etc crash I can still recover it easily.

Btw, I did not bother until years later but: setting it up for my phone was actually very easy too.

> Hello recently my AWS account was hijacked for a half a day. They managed to rack over 10000 in charges. I haven't used my AWS account in years[..]
>
> <cite>/u/VampDz<cite>

> I had a rarely used AWS account, where out of nowhere I receive an email with a bill of around $25,000
>
> <cite>/u/TabulateRasin<cite>

Now then, evryone happy all is good ? Alllllmost!
I kept running into posts on reddit and other places, such as [this][lost] and [this][also-lost] and finally [this][last-post]. People tell time and again things like "I had a rarely used AWS account, where out of nowhere I receive an email with a bill of around $25,000"

Now this made me very uncomfortable. I too had done some online courses for which I opened an AWS account (and others like it). I had not set up 2FA, but I was smart enough to use a keepass generated VERY STRONG password. But was that smart enough ? These posts made me believe "not so much". And who wants to wake up after the holidays and find a friendly email with an unfriendly bill ? I certainly do not. So I took these steps:

1. deleted any account I am not actively using in this category. (Cloud providers, paid services).
2. install 2FA on all accounts I do keep.

> Having an AWS account without a strong password and MFA is like driving drunk. You should be expected to be held accountable.
>
> <cite>/u/TangerineDream82<cite>

I used to think "Well, chances of me getting hacked are very small. I am not an interesting target." And for may things this is true: I am not. However, my passwords could still be included in some greater hack such as "bank XXX was hacked", "facebook passwords hacked" etc. And in some cases I AM a very interesting target. If I were a hacker, I would go looking for people doing tutorials, and courses on these sites. They will many times want to get on with their learning, and disregard security measures (Ever find yourself thinking: "Just for now, I'll fix it later" or "I will delete the account as soon as I am done" ?).

Let me conclude with this: The risks are not equal everywhere, be smart about it. And do yourself a favour and take an hour Monday morning to set up a password manager and 2FA for the important accounts. It may save you from serious debts, legal issues or loss of employment. And now, once you have started thinking about this, it will bring back the comfort of a good night's rest and ease of mind!

Enjoy the rest of the holidays, and have a great, safe and secure 2022!

[last-pass]: https://www.lastpass.com/
[keepass]: https://keepass.info/
[lost]: https://www.reddit.com/r/aws/comments/ro670s/i_woke_up_to_a_bill_of_2557536_usd/?utm_source=share&utm_medium=web2x&context=3
[also-lost]:   https://www.reddit.com/r/aws/comments/rhte00/aws_account_hacked_aws_wants_me_to_pay_bill/?utm_source=share&utm_medium=web2x&context=3
[last-post]: https://www.reddit.com/r/aws/comments/rocp33/mods_can_we_get_a_sticky_post_telling_anyone_that/?utm_source=share&utm_medium=web2x&context=3
