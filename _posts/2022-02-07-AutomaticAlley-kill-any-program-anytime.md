---
header:
  overlay_image: /assets/images/alley1.jpg
title: "#AutomaticAlley - Kill any program anytime with ease"
categories:
  - tech
  - AutomaticAlley
tags:
  - automatic-alley
  - linux
  - automation
  - bash
  - scripting
---
This is the first in a series to come, doubtfully dubbed #AutomaticAlley. It's where I will share small bits and bites of scripts and other tiny tricks to automate away boring and error prone stuff. The things we keep doing all the time, the things that annoy us that we need to to automate especially if we want to keep working on the command line a sane practice.

In today's episode: How to kill any program anytime with ease. For this we create a simple shell alias that kills any program that looks like the one that is bothering us. No need to go to activity screens or whatnot. In fact for those of us using tiling window managers or who otherwise generally live on the command line we just stay in our homes!

We use the `pkill` command for this. It is based on the loved `grep` command that finds anything by regex or name. Then from the manual (`man pkill`) we learn:
```
pgrep looks through the currently running processes and lists the process IDs which match the selection criteria to stdout.
[..]
pkill will send the specified signal (by default SIGTERM) to each process instead of listing them on stdout.
```
So we learn that `pkill` is based on `pgrep` which is a command that will list processes that are running currently. Now we need to be sure that the one we want is easily matched, and we do not want to have to remember exact spelling of even type all of it. After all we want to be as lazy as we can!

## Let's use pgrep to get the right matches
By the way: If you are using a mac and pkill or pgrep are not available you can install [proctools][proctools]: `brew install proctools`

Let's ask the system what we have: `pkill --help`. We find:
```
-i, --ignore-case         match case insensitively
```
Yes! We'll take it. We're not particular about case!
So let's try it! We run spotify. And then type:
{% include code-header.html %}
```
pgrep -i spotify
```
or
{% include code-header.html %}
```
pgrep -i SpoTify
```
or
{% include code-header.html %}
```
pgrep -i spoti
```
or
{% include code-header.html %}
```
pgrep -i otif
```
Looks good right ? It matches all! But wait... when we run some selenium tests for instance we need to run the selenium server. Usually in a repo where we use it we run `npx selenium-standalone install && npx selenium-standalone start` or similar,generally automated away in a nice `npm <selenium-command>` in package.json.
Now these have a tendency to clog up the system, or hang in zombie state somehow. So lets see if we could `pgrep` and thus `pkill` it.
{% include code-header.html %}
```
pgrep -i selenium
```
Nothing! Nothing1? Unfortunately it does not work. So lets see what else we have:
```
-f, --full                use full process name to match
```
That sounds good. Full whatever is probably more than what we had! And indeed:
{% include code-header.html %}
```
pgrep -i -f selenium
```
And yes there we have something! If we would like to compare it, the `-a` option will display the full command line:
{% include code-header.html %}
```
pgrep -i -f -a selenium
pgrep -i -f -a spotify
```
So now lets kill 'em!
{% include code-header.html %}
```
pkill -i -f selenium
pkill -i -f spotify
```
And if you feel like it is too silent now, and you like more feedback, `pkill -h` tells us:
```
-e, --echo                display what is killed
```
So now we have:
{% include code-header.html %}
```
pkill -i -f -e selenium
```

## Let's now make it easier! Simple is good!
Who wants to remember all of that, or look it up everytime? Not us smart (lazy) kids!
So now, depending on your shell we have something like a `.zshrc` or `.bashrc` usually in our home directory.
In it we want to make an alias, so we add a line it:
{% include code-header.html %}
```
alias dieSpotify='pkill -i -f -e spotify'
```
Save it and reload the shell, or open a new terminal. Then just run `dieSpotify`. And yes!
But wait... do we have to do that for each program we might ever want to kill ? That is crazy!
And of course the answer is no, we automated it, now we parametrize it! We can pass an argument to the alias. So we change the line into:
{% include code-header.html %}
```
die='pkill -i $1 -f -e'
```
The `$1` part here refers to the argument we pass so now we can kill everything at our convenience. Go Rambo!
{% include code-header.html %}
```
die spoti
die chrom
die KeePass
[..etc..]
```
One time effort, but now hanging programs, or programs that clog up the system with processes that do not get closed properly etc. Bam... Kill them with ease and comfort :)

Was it useful ? You have a better plan ? Let me know in the comments!

[proctools]: https://unix.stackexchange.com/questions/225/pgrep-and-pkill-alternatives-on-mac-os-x
