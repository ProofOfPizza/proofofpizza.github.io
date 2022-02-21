---
header:
  overlay_image: /assets/images/alley1.jpg
title: "#AutomaticAlley #2 - FZF and Ripgrep: fuzzy find files infuriatingly fast!"
categories:
  - tech
  - AutomaticAlley
tags:
  - automatic-alley
  - linux
  - automation
  - bash
  - scripting
  - fzf
  - ripgrep
  - fuzzy-finder
  - vim
---
E voila: the second in the series, doubtfully dubbed #AutomaticAlley. It's where I share small bits and bites of scripts and other tiny tricks to automate away boring and error prone stuff. The things we keep doing all the time, the things that annoy us that we need to to automate especially if we want to keep working on the command line a sane practice. Today let's have a look at FZF and Ripgrep to fuzzily find files!

>"If you just remembered where you put it, you wouldn't have to look for it!"
><cite>Every mom ever</cite>

Now that would be nice, but it is simply not feasible, and we have accepted this a long time ago.
What can we do ? Well we'll just find our file, and then open it! Let's try this the good ol' bash way:
To find something with a lot of matches: open the terminal in your home directory `~/` and run:
{% include code-header.html %}
```
find . | grep bash
```

Or something with few or no matches:
{% include code-header.html %}
```
find . | grep bashIsGreatButNotTooFast
```

It takes a while, and if you have bad luck you're trying to find something in "one of those sytem directory thingies"  ... was it /sys ? /run? /etc ? Yah one of those right? So you try:
{% include code-header.html %}
```
cd /
find . | grep bash
```

Now you really need to be patient!

## Enter FZF the Fuzzy finder and Ripgrep!
Some of us are not that patient, so they did something about it and wrote [FZF][fzf]. It is a command line fuzzy finder. That means it will find what you are looking for, even if you do not exactly know what you're looking for!

To install it there are a bunch of options, so choose whatever fits you best! If you use Vim I definitely recommend installing the Vim plugin as well. Because as they in the [README][readme]:

>## Why you should use fzf on Vim
>Because you can and you love fzf.

Then let us also install [Ripgrep][ripgrep]. This will enable us to search content inside files.
Again an easy process, just use whatever package manager you use for your system.

Now Ripgrep and FZF work awesomely together so lets tweak some settings here.
There are a lot of options, and it has many things you might want. What I wanted was:
1. A sensible default to search and find files
2. A way to find files by searching for content
3. The search results displayed in a nice way
4. A way to quickly find some file and open it in Vim
5. Ability to use FZF in Vim to find files
6. Ability to find stuff inside files in Vim

Number 2 I almost do not use, because I generally have an idea of where to look, and I generally look for stuff when I am working on a project. For instance I will have a code file open in Vim and then think, "Wait, where did I set that variable?" And then go for option 6.

For this I added to my `.zshrc` (if you use bash or fish use the appropriate rc file):
{% include code-header.html %}
```
export FZF_DEFAULT_OPTS="-m"
FZF_DEFAULT_OPTS+=" --color='light'"
FZF_DEFAULT_OPTS+=" --bind 'ctrl-/:toggle-preview'"
FZF_DEFAULT_OPTS+=" --preview 'head -500 {}' --height 80%"
FZF_DEFAULT_OPTS+=" --preview-window=up:40%:hidden"
FZF_DEFAULT_OPTS+=" --height=80%"
FZF_DEFAULT_OPTS+=" --layout=reverse"
FZF_DEFAULT_OPTS+=" --border"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
```
So a bunch of default options for the preview screen, actually those are for the use in Vim.
And a sensible default. Use ripgrep, look for hidden files as well, follow symbolic links and do not ignore vcs files.

I also add a few custom aliases:
{% include code-header.html %}
```
fzfi = "rg --files --hidden --follow --no-ignore-vcs -g '!{node_modules,.git}' | fzf"
o = "x=$(fzfi); if [[ ! -z $x ]]; then vim $x; fi"
nx = "~/.config/nixpkgs"
nxo = "nx && o"
```

An alias `fzfi` to use the default FZF command except that it does not search in `node_modules` or `.git` directories. Generally I am not looking for files there, because they are generated or managed for me, so I do not not need to edit those. Then `o` to look for a file using `fzfi`, and if I find it, open it with Vim. Finally an example `nxo` (there are many more examples, for each directory I commonly use and want to go quicly to edit files) it refers to `nx` which changes to my directory of nix configurations, and then runs `o`.

## Configs in Vim
Now for the ones interested in using Vim, I added these configs in `.vimrc`:
```
    "search
    nnoremap <C-g> :GFiles?<CR>
    nnoremap <C-h> :History<CR>
    nnoremap <C-l> :Rg<CR>
    nnoremap <C-b> :BLines<CR>
    nnoremap <C-p> :All<CR>
    nnoremap <leader>b :Buffers<CR>
    "set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
    let g:fzf_preview_window = ['up:50%:hidden', 'ctrl-/']
    command! -bang -nargs=*  All
      \ call fzf#run(fzf#wrap({'source': 'rg --files --hidden --no-ignore-vcs --glob "!{node_modules/*,.git/*}"', 'options': '--expect=ctrl-t,ctrl-x,ctrl-v --multi --reverse' }))

    "============ copied from source: https://github.com/junegunn/fzf.vim/blob/master/plugin/fzf.vim =========
    "============ can possibly be removed  after update ======================================================
    command! -bang -nargs=* Rg
      \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>),
      \ 1, s:p(), <bang>0)

    command! -bang -nargs=* History
      \ call s:history(<q-args>, s:p(), <bang>0)'])

    command! -bar -bang -nargs=? -complete=buffer Buffers
      \ call fzf#vim#buffers(<q-args>, s:p({ "placeholder": "{1}" }), <bang>0)

    function! s:p(...)
      let preview_args = get(g:, 'fzf_preview_window', ['right', 'ctrl-/'])
      if empty(preview_args)
        return { 'options': ['--preview-window', 'hidden'] }
      endif

      " For backward-compatiblity
      if type(preview_args) == type("")
        let preview_args = [preview_args]
      endif
      return call('fzf#vim#with_preview', extend(copy(a:000), preview_args))
    endfunction

    function! s:history(arg, extra, bang)
      let bang = a:bang || a:arg[len(a:arg)-1] == '!'
      if a:arg[0] == ':'
        call fzf#vim#command_history(bang)
      elseif a:arg[0] == '/'
        call fzf#vim#search_history(bang)
      else
        call fzf#vim#history(a:extra, bang)
      endif
    endfunction

    "=========================================================================================================
    "=========================================================================================================
```

As you can see most of this is copied from the [docs][docs]. I also found some useful ideas in [this blog][blog].
Basically in here I chose some key shortcuts that made sense to me, like `ctrl-p` to search files, `ctrl-l` to search contents (lines) etc. Also if looking for contents (content`ctrl-l`) then we can toggle the preview with `ctrl-/`

All in all with this you can now do all of those five things summed up above, and you get number three for free! Have a look and let me know what you think!
{% capture fig_img %}
![Gif demo of FZF and Ripgrep]({{ "/assets/images/fzf.gif" | relative_url }})
{% endcapture %}
<figure>
  {{ fig_img | markdownify | remove: "<p>" | remove: "</p>" }}
  <figcaption>{{ fig_caption | markdownify | remove: "<p>" | remove: "</p>" }}</figcaption>
</figure>

[fzf]: https://github.com/junegunn/fzf
[ripgrep]: https://github.com/BurntSushi/ripgrep
[readme]: https://github.com/junegunn/fzf.vim/
[docs]: https://github.com/junegunn/fzf.vim/blob/master/plugin/fzf.vim
[blog]: https://dev.to/matrixersp/how-to-use-fzf-with-ripgrep-to-selectively-ignore-vcs-files-4e27
