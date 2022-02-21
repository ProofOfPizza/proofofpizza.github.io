---
header:
  overlay_image: /assets/images/alley1.jpg
title: "Terminal file managers and my vifm setup"
categories:
  - tech
tags:
  - linux
  - automation
  - vifm
  - vim
  - file-managers
  - dotfiles
  - bash
---
Another blog about some nice tools and tricks to make life easier. This time let's look at terminal managers, why would we use them ? And I'll dive into my setup of choice with Vifm. It was supposed to go in the AutomaticAlley series but it became a bit more elaborate so I'll just put it out on it's own.

This is another very opionated blog, and I feel that that is what it should be when it comes to these type of tools. If you use your laptop for anything more than just plain browsing and reading emails, I think you should have a terminal file manager. That is, somehow there exist people who do things like programming, sys admin or devops stuff and they do not touch the command line / terminal. This is crazy to me, I would not know how, and even less why ...
 There are many discussions on this topic such as [this one on reddit][reddit]. Some comments include:

 >In my experience, people who rely on Git plugins in their IDE will often never truly understand what the plugin is doing under the hood. It provides an abstraction for you so you don't have the understand the details. That is, until you run into some situation where the plugin can't do what you want, or it's not obvious how to do it via the plugin. This will happen eventually.
 ><cite>/u/bears-repeating</cite>

 >This. The CLI changes far less often than GUI tools, is the same across any system and also works over ssh
 ><cite>/u/CharacterUse</cite>

 Some people comment that they prefer the UI / plugins, mostly for comfort or out out laziness:
 >UI because laziness. I know how to git on command line but for must use cases a UI is much more convenient.
 ><cite>/u/YMK1234</cite>

 And this sums up the basic distrust of UI's that I absolutely feel. As said, it is opinionated:
 >I use the CLI. It's the way I learned git and the one that feels most comfortable to me. I am always wary of a UI doing something other than what I intended.
 ><cite>/u/MrSloppyPants</cite>

 And obviously these discussions are repeated for many other things we use as techs like docker, editing configs, checking logs etc. For all of these we know that once we need to be on remote servers through SSH for instance, we're thrown back on the command line.

 Another very strong argument is that whatever you do on the cli can be automated. You're writing scripts? Pipelines ? Just automate the commands you already know and love.

 So I say: Why not make the command line the default, and in order to do that, take time to learn and configure it so it does exactly what we want. Because it seems to me that those are the two points that stand in the way for most people.
 1. The time and energy to configure stuff
 2. The time to learn things

And yes it is a matter of taste, but I personally enjoy figuring out things and then making sure I can navigate and use my system quickly and with easy (please no mousing and clicking... eeeeuw!).

One of the most important tools for that is the file manager. If you use a terminal file manager it works seamlessly with the terminal. Jump in, navigate, jump out. And most decent file managers do much much more, quickly create files, move or copy files, split into multiple panes to make that even easier, navigate using short cuts, opening files with predefined specific tools etc etc.

Also, most of us use keyboard shortcuts, right ? Why not leverage that idea into everything we can find? Apparently it helps us be more productive in our favorite tools, why would it not do the same everywhere else ?

I have so far used two of them: [Ranger][ranger] and [Vifm][vifm]. Both of them use Vi key bindings, which as a Vim user I like. I used Ranger first, and it was great, but then I found Vifm which is even more Vim-like, and I tried it, and stayed.

## 'Nuff with the banter, show us the setup!
Okay okay, I have tortured you enough with my opinions. If you were not interested you probably never made it here, if you were interested in Vifm, you probably did not need any convincing. So thanks for indulging me. Now let's get to the nerdy stuff!

If you're spending your time on the command line, I strongly suggest looking into a terminal emulator you want like [URXVT][urxvt], [Konsole][konsole] or my current favorite [Alacritty][alacritty]. Then choose a shell you like: good ol' [bash][bash], my current love [zsh][zsh], or the new [fish][fish] on the block. And while you are at it: Setup a decent font. You'll spend hours looking to find tiny mistakes in files etc, so make it easy on the eyes!

Good, that out of the way let's get to Vifm. Installing it is easy on mac or linux. On windows ? Who knows ? You probably need a few more things first, and ten it should not be too hard.

Once you have it, just run `vifm` and tadaa, it opens up. And it is probably quite ugly. So time to tweak your theme! Choose a nice one [here][themes] and let's get going. I currently use `zenburn_1`. We locate the file `.vifmrc`. It is most likely in `~/vifm/.vifmrc`. As with most of these terminal things, all important settings are in the rc-file. It has a section about color schemes:
{% include code-header.html %}
```
" Selected color scheme
colorscheme zenburn_1
```

Reopen Vifm and check it out! Beautiful! Alright up next let's navigate a bit. Use whatever you want: Arrow keys, hjkl-vi keys, or even, and we'll see this more: hit `:` and just type `cd some-directory`. So easy! So now quit vifm, annnnd so sad! We are back at the home directory!

That is useless right ? No worries we can fix it. Unfortunately I did not find any native way to do that (let me know if you do!) so my solution was to write a simple function and an alias in  my `.zshrc`. So open up your `.zshrc` or `.bashrc` , depending on your choice and add:
{% include code-header.html %}
```
alias r = "vicd ./"

vicd()
{
  local dst="$(command ~/.vifm/scripts/vifm -- choose-dir -"$@")"
  if [ -z "$dst" ]; then
    echo 'Directory picking cancelled/failed'
    return 1
  fi
  cd "$dst"
}
```
This function stores the last directory you where at and on closing vifm directs you right there. The alias, `r`, well yeah, that is because I got used to it from my time using Ranger, and I did not want to change it, but you might use another alias obviously.
Save it and reload your shell, either by closing and reopening the terminal or by running `zsh`. I will just use `zsh` from now on, if you use another shell, just replace that.

Now let's type in our alias `r` and enter. Navigate to your prettiest directory and quit. And tadaa, you exit to the terminal exactly where you were. Great improvement right ?
Another way to achieve this is by using the command `:shell`, which would make it easier to automate, but then you startup a lot of shells inside of each other and that gets messy!

By the way, if you are lazy like me: check out the bottom of the `vifmrc`:
{% include code-header.html %}
```
" Sample mappings
" quit on q
nnoremap q :q<cr>
```

Nice! Just a `q` and as you see, the `nnoremap` is just like vim, key mappings, so we can leverage that for some quick navigation as well! In my case for instance:

{% include code-header.html %}
```
nnoremap nx  :cd ~/.config/nixpkgs<cr>
nnoremap gd  :cd ~/Downloads<cr>
```
And by the way, to make life quick 'n' easy I have similar mappings in `.zshrc`:

{% include code-header.html %}
```
alias gd = "cd ~/Downloads && r"
alias gh = "cd ~ && r"
alias nx = "~/.config/nixpkgs"
alias nxr = "nx && r"
```
This way navigating in Vifm, and on the command line itself, jumping in and out of Vifm happens fast and intuitively. You would have to make some aliases that make sense for you of course, keys you hit quickly and things that require no effort to remember.

## Copying, renaming, creating files and other such fun stuff!
Now let's have a look at some other basic things you might want to do.
To copy a file: navigate, hit `yy` to copy to clipboard, navigate and `p` to paste. As expected.
To delete ? Use `dd` (and `p` somewhere else for moving it of course)
Rename? Hit `cc`, or `A` and see!
And for making selections to perform these things? `V`.

In general on the [Vifm][vifm] site under "What users are saying..." it is said best:
>“Thank you for this great Vifm tool whose slogan could be: "If you don't know how to do it, don't look at the docs, just think how you would do it in vi.""
><cite>Carlos Pita</cite>

## Multiple panes
Something that I had to get used to for a bit, but resulted to be incredibly useful were the dual panes.
Just hit `ctrl-w v` to open the second pane, and `crtl-w o` to close it. (Just like...). Vifm will remember your last choice in this.
If you have two panes switch between them with `space`. Now imagine if I want to copy a few things from `Downloads` to `~/.config/nixpkgs/scripts`:
I hit `r` anywhere. Then `gd`, some ups or downs to get to my file, `yy`, `space`, `nx`, navigate, `p`, `space` ... rinse and repeat. Now to read this, is cumbersome. But to do this, once you have a feel for these shortcuts (and if you are a Vim user this costs you exactly zero effort) is really really quick and intuitive. No menus, no mouse, no clicking, chosing options from secondary menus nothing. And then you want to edit the file? Just hit enter and go.

That is... if you set up the correct programs to open files...
## Setting up default programs to open your files
Again we open `.vifmrc`. Find the section on opening files, and adjust to your liking. I for instance have:
{% include code-header.html %}
```
filetype *.wav,*.mp3,*.flac,*.m4a,*.wma,*.ape,*.ac3,*.og[agx],*.spx,*.opus,*.aiff
        \ vlc %f

filextype *.pdf
        \ evince %c
```
Everything that is not matched against any definitions will be opened with your default Vim. If you would like to use something else, like VI or even something else completely like codium you can edit this line in `.vifmrc`:
{% include code-header.html %}
```
set vicmd=vi
```

## File Preview
Another nice thing to have in a file manager are file previews. This is also possible, and configurable to suit your wishes in Vifm. To start: Open Vifm, and make sure you have two panes. Then hitting the `w` key will toggle the preview. Nice right ? I agree!
So anything that is previewable (if only that were a word!) in Vim should be immediately working now.

But for some files it is a bit more involved to get the previews working nicely. And luckily others have done some work for us, and we need only extend it a bit.
For images we find [here in the docs][docs_preview] a suggestion to use [Ueberzug][ueberzug]. The link to the [reddit][thread] shows some scripts that the author of Ueberzug, _/u/seebye_ wrote. It also has a link to youtube to a video by [DistroTube][distrotube] that give a little more explanation, and where in the comments of that video, we find a variation of those scripts to support videos as well. I then took that and extended it to be able to preview pdfs as well.
Here is how to do it:

Create two files in `.vifm/scripts` (by the way, finding things in Vifm is just like finding them in Vim right, so use the `/` as you would!):
1. vifmimg
2. vifmrun

Both will contain bash scripts:
`vifmimg`
{% include code-header.html %}
```
#!/usr/bin/env bash
readonly ID_PREVIEW="preview"

if [ -e "$FIFO_UEBERZUG" ]; then
    if [[ "$1" == "draw" ]]; then
        declare -p -A cmd=([action]=add [identifier]="$ID_PREVIEW"
                           [x]="$2" [y]="$3" [width]="$4" [height]="$5" \
                           [path]="${PWD}/$6") \
            > "$FIFO_UEBERZUG"
    elif [[ "$1" == "videopreview" ]]; then
        [[ ! -f "/tmp/$6.png" ]] && ffmpegthumbnailer -i "${PWD}/$6" -o "/tmp/$6.png" -s 0 -q 10
        declare -p -A cmd=([action]=add [identifier]="$ID_PREVIEW"
                           [x]="$2" [y]="$3" [width]="$4" [height]="$5" \
                           [path]="/tmp/$6.png") \
            > "$FIFO_UEBERZUG"
    elif [[ "$1" == "pdfpreview" ]]; then
        [[ ! -f "/tmp/$6.jpg" ]] && pdftoppm -singlefile -jpeg  "${PWD}/$6" "/tmp/$6"
        declare -p -A cmd=([action]=add [identifier]="$ID_PREVIEW"
                           [x]="$2" [y]="$3" [width]="$4" [height]="$5" \
                           [path]="/tmp/$6.jpg") \
            > "$FIFO_UEBERZUG"
    elif [[ "$1" == "clear" ]]; then
        declare -p -A cmd=([action]=remove [identifier]="$ID_PREVIEW") \
            > "$FIFO_UEBERZUG"
    fi
fi
```

This basically says, if you have Ueberzug ready and you call this script with an argument of `draw` then draw the preview of a image file (`$6`) with the dimensions given in the rest of the arguments (`$2` ... `$5`). If the argument is `pdfpreview` or `videopreview` then make an image of that, and draw that. If the argument is `clear` then clear up the screen.

`vifmrun`
{% include code-header.html %}
```
#!/usr/bin/env bash
export FIFO_UEBERZUG="/tmp/vifm-ueberzug-${PPID}"

function cleanup {
    rm "$FIFO_UEBERZUG" 2>/dev/null
    pkill -P $$ 2>/dev/null
}

rm "$FIFO_UEBERZUG" 2>/dev/null
mkfifo "$FIFO_UEBERZUG"
trap cleanup EXIT
tail --follow "$FIFO_UEBERZUG" | ueberzug layer --silent --parser bash &

vifm --choose-dir - "$@"
cleanup
```

This file basically runs Vifm with Ueberzug prepared. I adapted it in this line: `vifm --choose-dir - "$@"` to be able to work with our `vicd()` function. So that means we need to make two more small changes. But before that:
Save these files and make them executable by running:
{% include code-header.html %}
```
chmod +x vifmrun
chmod +x vifmimg
```

Now let's edit `.zshrc` and make sure we have:
{% include code-header.html %}
````
vicd()
{
  local dst="$(command ~/.vifm/scripts/vifmrun "$@")"
  if [ -z "$dst" ]; then
    echo 'Directory picking cancelled/failed'
    return 1
  fi
  cd "$dst"
}
````
This way we call the `vimrun` script with that same argument, whenever we call`vicd()` which again is whenever we call `r` or whatever your personal alias was.

Finally we adapt the sections in `vifmrc`:
{% include code-header.html %}
```
fileviewer *.pdf
           \ vifmimg pdfpreview %px %py %pw %ph %c
           \ %pc
           \ vifmimg clear

fileviewer *.bmp,*.jpg,*.jpeg,*.png,*.gif,*.xpm
           \ vifmimg draw %px %py %pw %ph %c
           \ %pc
           \ ~/.vifm/scripts/vifmimg clear

           fileviewer *.avi,*.mp4,*.wmv,*.dat,*.3gp,*.ogv,*.mkv,*.mpg,*.mpeg,*.vob,
        \*.fl[icv],*.m2v,*.mov,*.webm,*.ts,*.mts,*.m4v,*.r[am],*.qt,*.divx
        \ vifmimg videopreview %px %py %pw %ph %c
        \ %pc
        \ vifmimg clear
```

The `fileviewer` sections are for the previews, where the `filetype` and `filextype` are for actually opening the files.
Lets try it out! And boom there you go, previews of PDF, images and videos all working nicely!

## Bonus: add Vifm to Vim!
Sounds like inception right ? Well kind of, but then in an awesome way. I have tried things like [nerd tree][nerd_tree] and never really got the hang of it, but now we can use Vifm, exactly as we configured it with all it's magic directly in Vim.
For this we use a plugin called [Floaterm][floaterm]. It spins up a floating terminal window, and we can tell it what we want to do with it. And what do we want? V.I.F.M ! Vifm! (Ah imagine the dance that goes with that!). In our `vimrc` (mind you not `vifmrc` this time of course!). We add configuration for it:
{% include code-header.html %}
```
"Floaterm
let g:floaterm_opener = 'edit'
vnoremap <leader>m :FloatermNew --autoclose=2 vifm<CR>
nnoremap <leader>m :FloatermNew --autoclose=2 vifm<CR>
```
I use `space+m` to open the vifm window and set it to `edit` meaning if I choose to open a file it just opens it in a new buffer in Vim with out splitting into two panes which is the default. Obviously you might have to add something to load the plugin and maybe use a different configuration, but all of that can be found on [Floatterm's][floaterm] page.

Now if we put all of that together we can get something like this. Pretty sweet right ? Let me know what you think, and if you have suggestions I am always ready to ear them!

{% capture fig_img %}
![Gif demo of vifm setup]({{ "/assets/images/vifm.gif" | relative_url }})
{% endcapture %}
<figure>
  {{ fig_img | markdownify | remove: "<p>" | remove: "</p>" }}
  <figcaption>{{ fig_caption | markdownify | remove: "<p>" | remove: "</p>" }}</figcaption>
</figure>

[reddit]: https://www.reddit.com/r/AskProgramming/comments/ov7yu4/do_you_use_git_from_command_line_or_from_gui/
[ranger]: https://github.com/ranger/ranger
[urxvt]: http://software.schmorp.de/pkg/rxvt-unicode.html
[konsole]: https://konsole.kde.org/
[alacritty]: https://alacritty.org/
[bash]: https://www.gnu.org/software/bash/
[zsh]: https://ohmyz.sh/
[fish]: https://fishshell.com/
[vifm]: https://vifm.info/
[themes]: https://vifm.info/colorschemes.shtml
[docs_preview]: https://wiki.vifm.info/index.php?title=How_to_preview_images
[ueberzug]: https://github.com/seebye/ueberzug
[thread]: https://www.reddit.com/r/linux/comments/aviu08/ueberzug_v1810_released/ehfj0s4/
[distrotube]: https://www.youtube.com/watch?v=qgxsduCO1pE
[nerd_tree]: https://github.com/preservim/nerdtree
[floaterm]: https://github.com/voldikss/vim-floaterm
