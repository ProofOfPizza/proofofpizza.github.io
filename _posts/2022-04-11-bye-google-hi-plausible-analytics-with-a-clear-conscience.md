---
header:
  overlay_image: /assets/images/plausible.jpeg
title: "Bye G***le, Hi Plausible - Analytics with a clear conscience"
categories:
  - tech
  - opinion
tags:
  - analitics
  - data
  - gdpr
---
So you have a web page, or maybe even a bunch of pages, and you are interested to optimize them, either for better user experience, more sales revenue, or you just want to know if anyone reads your blog that you spend all these hours on. Well technology is here to save you! If you dive in this topic the first second third and fourth thing (do I keep counting?) you will find is G\*\*\*gle Analytics. It is free, and installation is easy and it will give you all the data _you might ever need._ But what does "free" mean? And why not look at what you need first, and then see if you can get just that? In this blog we explore an alternative, [Plausibe analytics][plausible], why and how we at [InQuisitive][inquisitive] transitioned.

>If you are not paying for it, you're not the customer; you're the product being sold.
><cite>blue_beetle</cite>

This is a famous quote by now, but in this context it is actually worse. How much worse? Well that depends on your success. Because your site is free to visit for anyone, and you have G\*\*\*le Analytics for free, but who is the product here? Not just you, all the people who visit your site in good faith. Every friend, customer, family member you show it to, your colleagues that you send a link etc. They are all products, you give away their data, so that all of us, including all those people who never even went to your site are being targeted with ever growing precision: manipulating our buying decisions, voting decisions, deciding on the information that reaches us so we'll form our opinions aligned with the Big Buyers interests... Is it that bad ? Yes it is!

You should understand that this incredible power lies not in specific data you provide, it lies in the immense amounts of data that organisations such as G\*\*\*le or F\*\*\*book (or Meta!) have of us. Their algorithms find patterns, and using those patterns they're able to predict so many things about us that in many ways, they know us better then we know ourselves or our loved ones. Our freedoms are at stake, and even though we can not fix this problem by ourselves, we can choose to not be an accomplice in giving them away... for free!

>There is, simply, no way, to ignore privacy. Because a citizenry’s freedoms are interdependent, to surrender your own privacy is really to surrender everyone’s. You might choose to give it up out of convenience, or under the popular pretext that privacy is only required by those who have something to hide. But saying that you don’t need or want privacy because you have nothing to hide is to assume that no one should have, or could have to hide anything – including their immigration status, unemployment history, financial history, and health records. You’re assuming that no one, including yourself, might object to revealing to anyone information about their religious beliefs, political affiliations and sexual activities, as casually as some choose to reveal their movie and music tastes and reading preferences. Ultimately, saying that you don’t care about privacy because you have nothing to hide is no different from saying you don’t care about freedom of speech because you have nothing to say. Or that you don’t care about freedom of the press because you don’t like to read. Or that you don’t care about freedom of religion because you don’t believe in God. Or that you don’t care about the freedom to peaceably assemble because you’re a lazy, antisocial agoraphobe. Just because this or that freedom might not have meaning to you today doesn’t mean that that it doesn’t or won’t have meaning tomorrow, to you, or to your neighbor – or to the crowds of principled dissidents I was following on my phone who were protesting halfway across the planet, hoping to gain just a fraction of the freedom that my country was busily dismantling.
><cite>Edward Snowden</cite>

## How does that work ?
You installed G\*\*\*gle Analytics on your website. Now every time someone comes to your site, navigates, loads a widget, clicks on a link etc a call is made to G\*\*\*gle to inform them. This is how they get their data, and how they get you to work for them... for free! Well not entirely: they give you some insights into that data of course. Obviously, as said before, data is much more valuable if it exists in greater quantities so the same data is probably more worth to them than to you.

A simple [search][search] on the internet shows us that G\*\*\*le is retrieving so much data it is hard to understand, there are countless plugins and other software to link it to just to make sense of it! But why ? Well, because it was never designed for you or your purpose of it.

## Are there alternatives ?
Yes there are! There are lots of them actually, just none as famous and big as G\*\*\*le Analytics, and therefore you have to seek them out. To name but a few, we have:
1. [Matomo][matomo]
2. [Open Web Anaytics][owa]
3. [Countly][countly]
4. [AWStats][aws]
5. [Plausible][plausible]

This is just a small list, there are many more. These five are all open source. So you see there is plenty to choose from! For a comparison you can for instance see sites like [rigorous themes][rt].

## Where to go from here ?
I started looking into this, because I was interested to know if anyone reads my blogs. As simple as that. If there were only people from the Netherlands looking I might consider changing the language to Dutch. And as a privacy geek I wanted to know what possibilities exist that might enable me to get some insights into my visitors, without selling it all out to the big guys, and without me feeling guilty for becoming just like them!
After some research into ease of use, easy of install, data provided, price, documentation and type of project/company, I settled on Plausible.

_"Plausible Analytics is an open-source project dedicated to making web analytics more privacy-friendly."_ it says on their [about][about] page. I like that! And just reading through the site and the documentation was a fresh breeze. So I signed up for the 30 days trial, to see if I could indeed get it working, and to see if I would find it worth while. It turns out that configuration for my jekyll site was almost to easy to mention. I had to add two lines to my `_config.yaml`:
```
analytics:
  provider: "custom"
```

And then include a small, one line script that Plausible provided for me in the folder `_includes`. That. Was. It.

I looked into the statistics and immediately understood what I was looking and found directly what it was I was looking for. I could see how many people visit my pages. If I want I can send a url with a small query parameter so that I can easily recognise from where the people came, and which actions I take, such as sharing it on LinkedIn, or directly with my colleagues, or referencing it in StackOverflow answers, result in people actually reading my work.

I was very satisfied, and decided that this would be a good step, not just for me and my blog but also for the company I work with, [InQuisitive][inquisitive].

_Please note that while I am very enthusiastic about their product I am in no way affiliated to Plausible._


## Price and possibilities
I choose to go for the easiest way, the hosted version where I do not have to manage any servers and they promise to keep my data in Europe, and all in accordance with the [GDPR][gdpr]. This is important because we see countries moving towards stricter interpretations and enforcements when it comes to data protection. Cases in Austria and France had led to the [EU declaring G\*\*\*le Analytics illegal][illegal].

The software itself is free and open source, so if you want, or need to you can host it all yourself and keep the data in house. They made script for you make it easy to install and run everything, and if you see a possible improvement, just make a PR! But I really think for the money you do not need to, a basic subscription is as low as 9 Euros per month. But if you do and you use it heavily, by all means please consider their suggestion:
>If you're self-hosting Plausible, sponsoring us is a great way to give back to the community and to contribute to the long-term sustainability of the project. Thank you for supporting independent creators of Free Open Source Software!


## Introducing it in our company's websites
Next I called my colleague Maxime who works as the chief marketeer in our office. I said "Hey Maxime, remember those ideas we all wrote down about wanting to do some good with this company? Well I may have an idea to put our money where our mouth is, and I'd like to discuss it with you". So we set up a meeting and I asked her a bunch of questions like, what are we using now for our analytics? What are the data points you actually look at and use? Do you get all the info you need? Is it cluttered with stuff you do not actually want to collect?

Then I proceeded to show my screen and show her what Plausible looked like for my site, and asked if that might work for her. She liked the idea (duh, nobody wants to be part of ...), and said she would look into it. We agreed she'd read up on it, and if she wanted to proceed with a trial next to the existing analytics, we'd meet up and I'd help her set it up. Except, she did not.

I waited, and waited a bit more. And then I saw a message "Hey, just wanted to let you know that I managed to get it working for both our sites with the Plausible plugin [for Wordpress]. Looking good!" Now that was nice, no need for any techie to assist, just fiddle around a bit and you have it working!

## Conclusions

We at [InQuisitive][inquisitive] now have all our sites set up with Plausible, and G\*\*\*le is out. It may not seem much but the important thing is that it is _something._ A step in the right direction, in the direction we want to go. Where we are autonomous to choose what we do, instead of walking on some big data bully's leash. Also remember that just "your little bit of data" is not the problem, but all those little bits make up a really big problem. So take control, keep yourself, your company and the people around you safe. Or at least: refuse to be part of the threat.
It's fun, it's really not that hard, so spend a day on it!

>A well spent day brings happy sleep.
><cite>Leonardo da Vinci</cite>

[plausible]: https://plausible.io/
[inquisitive]: https://inquisitive.nl?ref=proofofpizza
[search]: https://duckduckgo.com/?q=how+to+make+sense+of+data+in+G\*\*\*gle+Analytics&t=brave&ia=web
[matomo]: https://matomo.org/
[aws]: https://awstats.sourceforge.io/
[countly]: https://count.ly/
[owa]: https://www.openwebanalytics.com/
[rt]: https://rigorousthemes.com/blog/open-source-google-analytics-alternatives/
[about]: https://plausible.io/about
[gdpr]: https://en.wikipedia.org/wiki/General_Data_Protection_Regulation
[illegal]: https://techstory.in/eu-declares-google-analytics-illegal-heres-why/
