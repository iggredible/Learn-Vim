# Ch21. Vimrc

In the previous chapters, you learned how to use Vim text editor. This is great, but not the whole thing. To use Vim more effectively, you will need to learn how to configure it. The best place to start is your vimrc. TBC
In the previous chapters, you learned how to use Vim. In this chapter, you will learn how to orgnize and configure vimrc. 

## How Vim Finds Vimrc

The conventional wisdom for vimrc is to add a `.vimrc` dotfile in the root directory `~/.vimrc` (it might be different depending on your OS).

Behind the scene, Vim looks at multiple places for a vimrc file. Here are the places that Vim checks:
- `$VIMINIT`
- `$HOME/.vimrc`
- `$HOME/.vim/vimrc`
- `$EXINIT`
- `$HOME/.exrc`
- `$VIMRUNTIME/default.vim`

When you start Vim, it will check the above six locations in that order for a vimrc file. The first found vimrc file will be used and the rest is ignored. 

First Vim will look for a `$VIMINIT`. If there is nothing there, Vim will check for `$HOME/.vimrc`. If there is nothing there, Vim will check for `$HOME/.vim/vimrc`. If Vim finds it, it will stop looking and use `$HOME/.vim/vimrc`. 

The first location, `$VIMINIT`, is an environment variable. By default it is undefined. If you want to use `~/dotfiles/testvimrc` as your `$VIMINIT` value, you can create an environment variable containing the path of that vimrc. After you run `export VIMINIT='let $MYVIMRC="$HOME/dotfiles/testvimrc" | source $MYVIMRC'`, Vim will now use `~/dotfiles/testvimrc` as your vimrc file.

The second location, `$HOME/.vimrc`, is the conventional path for many Vim users. `$HOME` in many cases is your root directory (`~`). If you have a `~/.vimrc` file, Vim will use this as your vimrc file.

The third, `$HOME/.vim/vimrc`, is located inside the `~/.vim` directory. You might have the `~/.vim` directory already for your plugins, custom scripts, or View files. Note that there is no dot in vimrc file name (`$HOME/.vim/.vimrc` won't work, but `$HOME/.vim/vimrc` will).

The fourth, `$EXINIT` works similar to `$VIMINIT`. 

The fifth, `$HOME/.exrc` works similar to `$HOME/.vimrc`.

The sixth, `$VIMRUNTIME/defaults.vim` is the default vimrc that comes with your Vim build. In my case, I have Vim 8.2 installed using Homebrew, so my path is (`/usr/local/share/vim/vim82`). If Vim does not find any of the previous six vimrc files, it will use this file.

For the remaining of this chapter, I am assuming that the vimrc uses the `~/.vimrc` path. 

## What To Put In My Vimrc?

A question I asked when I started was, "What should I put in my vimrc?"

The answer is, "anything you want". The temptation to copy-paste other people's vimrc is real, but you should resist it. If you insist to use someone else's vimrc, make sure that you know what it does, why and how s/he uses it, and most importantly, if it is relevant to you. Just because someone uses it doesn't mean you'll use it too.

## Basic Vimrc Content

In the nutshell, a vimrc is a collection of:
- Plugins
- Settings
- Custom Functions
- Custom Commands
- Mappings

There are other things not mentioned above, but in general, this covers most use cases.

### Plugins

In the previous chapters, I have mentioned different plugins, like [fzf.vim](https://github.com/junegunn/fzf.vim), [vim-mundo](https://github.com/simnalamburt/vim-mundo), and [vim-fugitive](https://github.com/tpope/vim-fugitive).

Ten years ago, managing plugins was a nightmare. However, with the rise of modern plugin managers, installing plugins can now be done in seconds. I am currently using [vim-plug](https://github.com/junegunn/vim-plug) as my plugin manager, so I will use it in this section. The concept should be similar with other popular plugin managers. I would strongly recommend you to check out different ones, such as:
- [vundle.vim](https://github.com/VundleVim/Vundle.vim)
- [vim-pathogen](https://github.com/tpope/vim-pathogen)
- [dein.vim](https://github.com/Shougo/dein.vim)

There are more plugin managers than the ones listed above, feel free to look around. To install vim-plug, if you have a Unix machine, run:

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

To add new plugins, drop your plugin names (`Plug 'github-username/repository-name'`) between the `call plug#begin()` and the `call plug#end()` lines. So if you want to install `emmet-vim` and `nerdtree`, put the following snippet down in your vimrc:

```
call plug#begin('~/.vim/plugged')
  Plug 'mattn/emmet-vim'
  Plug 'preservim/nerdtree'
call plug#end()
```

Save the changes, source it (`:source %`), and run `:PlugInstall` to install them.

In the future if you need to remove unused plugins, you just need to remove the plugin names from the `call` block, save and source, and run the `:PlugClean` command to remove it from your machine.

Vim 8 has its own built-in package managers. You can check out `:h packages` for more information. In the next chapter, I will show you how to use it.

### Settings

It is common to see a lot of `set` options in any vimrc. If you run the set command from the command-line mode, it is not permanent. You will lose it when you close Vim. For example, instead of running `:set relativenumber number` from the Command-line mode each time you run Vim, you could just put these inside vimrc:

```
set relativenumber number
```

Some settings require you to pass it a value, like `set tabstop=2`. Check out the help page for each setting to learn what kind of values it accepts.

You can also use a `let` instead of `set` (make sure to prepend it with `&`). With `let`, you can use an expression as a value. For example, to set the `'dictionary'` option to a path only if the path exists:

```
let s:english_dict = "/usr/share/dict/words"

if filereadable(s:english_dict)
  let &dictionary=s:english_dict
endif
```

You will learn about Vimscript assignments and conditionals in later chapters. 

For a list of all possible options in Vim, check out `:h E355`.

### Custom Functions

Vimrc is a good place for custom functions. You will learn how to write your own Vimscript functions in a later chapter.

### Custom Commands

You can create a custom Command-line command  with `command`.

To create a basic command `GimmeDate` to display today's date:

```
:command! GimmeDate echo call("strftime", ["%F"])
```

When you run `:GimmeDate`, Vim will display a date like "2021-01-1".

To create a basic command with an input, you can use `<args>`. If you want to pass to `GimmeDate` a specific time/date format:

```
:command! GimmeDate echo call("strftime", [<args>])

:GimmeDate "%F"
" 2020-01-01

:GimmeDate "%H:%M"
" 11:30
```

If you want to restrict the number of arguments, you can pass it `-nargs` flag. Use `-nargs=0` to pass no argument, `-nargs=1` to pass one argument, `-nargs=+` to pass at least one argument, `-nargs=*` to pass any number of arguments, and `-nargs=?` to pass 0 or one arguments. If you want to pass nth argument, use `-nargs=n` (where `n` is any integer).

`<args>` has two variants: `<f-args>` and `<q-args>`. The former is used to pass arguments to Vimscript functions. The latter is used to automatically convert user input to strings.

Using `args`:

```
:command! -nargs=1 Hello echo "Hello " . <args>
:Hello "Iggy"
" returns 'Hello Iggy'

:Hello Iggy
" Undefined variable error
```

Using `q-args`:

```
:command! -nargs=1 Hello echo "Hello " . <q-args>
:Hello Iggy
" returns 'Hello Iggy'
```

Using `f-args`:

```
:function! PrintHello(person1, person2)
:  echo "Hello " . a:person1 . " and " . a:person2
:endfunction

:command! -nargs=* Hello call PrintHello(<f-args>)

:Hello Iggy1 Iggy2
" returns "Hello Iggy1 and Iggy2"
```

The functions above will make a lot more sense once you get to the Vimscript functions chapter. 

To learn more about command and args, check out `:h command` and `:args`.

### Maps

If you find yourself repeatedly performing the same complex task, it is a good indicator that you should create a mapping for that task.

For example, I have these two mappings in my vimrc:

```
nnoremap <silent> <C-f> :GFiles<CR>

nnoremap <Leader>tn :call ToggleNumber()<CR>
```

On the first one, I map `Ctrl-F` to [fzf.vim](https://github.com/junegunn/fzf.vim) plugin's `:Gfiles` command (quickly search for Git files). On the second one, I map `<Leader>tn` to call a custom function `ToggleNumber` (toggles `norelativenumber` and `relativenumber` options). The `Ctrl-F` mapping overwrites Vim's native page scroll. Your mapping will overwrite Vim controls if they collide. Because I almost never used that feature, I decided that it is safe to overwrite it.

By the way, I personally like to use `<Space>` as the leader key instead of Vim's default. To change your leader key, add this in your vimrc:

```
let mapleader = "\<space>"
```

The `nnoremap` command used above can be broken down into three parts:
- `map` is the map command.
- `n` represents the normal mode.
- `nore` means non-recursive.

At minimum, you could have used `nmap` instead of `nnoremap` (`nmap <silent> <C-f> :Gfiles<CR>`). However, it is a good practice to use the non-recursive variant to avoid potential infinite loop.

Here's what could happen if you don't map non-recursively. Suppose you want to add a mapping to `B` to add a semi-colon at the end of the line, then go back one WORD (recall that `B` n Vim is a normal-mode navigation key to go backward one WORD).

```
nmap B A;<esc>B
```

When you press `B`... oh no! Vim adds `;` uncontrollably (interrupt it with `Ctrl-C`). Why did that happen? Because in the mapping `A;<esc>B`, the `B` does not refer to Vim's native `B` function (go back one WORD), but it refers to the mapped function. What you have is actually this:

```
A;<esc>A;<esc>A;<esc>A;esc>...
```

To solve this problem, you need to add a non-recursive map:

```
nnoremap B A;<esc>B
```

Now try calling `B` again. This time it successfully adds a `;` at the end of the line and go back one WORD. The `B` in this mapping represents Vim's original `B` functionality.

Vim has different maps for different modes. If you want to create a map for insert mode to exit insert mode when you press `jk`:

```
inoremap jk <esc>
```

The other map modes are: `map` (Normal, Visual, Select, and Operator-pending), `vmap` (Visual and Select), `smap` (Select), `xmap` (Visual), `omap` (Operator-pending), `map!` (Insert and Command-line), `lmap` (Insert, Command-line, Lang-arg), `cmap` (Command-line), and `tmap` (terminal-job). I won't cover them in detail. To learn more, check out `:h map.txt`.

Create a map that's most intuitive, consistent, and easy-to-remember.

## Organizing Vimrc

Over time, your vimrc will grow large and become convoluted. There are two ways to keep your vimrc to look clean:
- Split your vimrc into several files.
- Fold your vimrc file.

### Splitting Your Vimrc

You can split your vimrc to multiple files using Vim's `source` command. This command reads command-line commands from the given file argument.

Let's create a file inside the `~/.vim` directory and name it `/settings` (`~/.vim/settings`). The name itself is arbitrary and you can name it whatever you like.

You are going to split it into four components:
- Third-party plugins (`~/.vim/settings/plugins.vim`).
- General settings (`~/.vim/settings/configs.vim`).
- Custom functions (`~/.vim/settings/functions.vim`).
- Key mappings (`~/.vim/settings/mappings.vim`) .

Inside `~/.vimrc`:

```
source $HOME/.vim/settings/plugins.vim
source $HOME/.vim/settings/configs.vim
source $HOME/.vim/settings/functions.vim
source $HOME/.vim/settings/mappings.vim
```

Inside `~/.vim/settings/plugins.vim`:

```
call plug#begin('~/.vim/plugged')
  Plug 'mattn/emmet-vim'
  Plug 'preservim/nerdtree'
call plug#end()
```

Inside `~/.vim/settings/configs.vim`:

```
set nocompatible
set relativenumber
set number
```

Inside `~/.vim/settings/functions.vim`:

```
function! ToggleNumber()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc
```

Inside `~/.vim/settings/mappings.vim`:

```
inoremap jk <esc>
nnoremap <silent> <C-f> :GFiles<CR>
nnoremap <Leader>tn :call ToggleNumber()<CR>
```

Your vimrc should works as usual, but now it is only four lines long!

With this setup, you easily know where to go. If you need to add more mappings, add them to the `/mappings.vim` file. In the future, you can always add more directories as your vimrc grows. For example, if you need to create a setting for your colorschemes, you can add a `~/.vim/settings/themes.vim`.

### Keeping One Vimrc File

If you prefer to keep one vimrc file to keep it portable, you can use the marker folds to keep it organized. Add this at the top of your vimrc:

```
" setup folds {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}
```

Vim can detect what kind of filetype the current buffer has (`:set filetype?`). If it is a `vim` filetype, you can use a marker fold method. Recall that a marker fold uses `{{{` and `}}}` to indicate the starting and ending folds.

Add `{{{` and `}}}` folds to the rest of your vimrc (don't forget to comment them with `"`):

```
" setup folds {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" plugins {{{
call plug#begin('~/.vim/plugged')
  Plug 'mattn/emmet-vim'
  Plug 'preservim/nerdtree'
call plug#end()
" }}}

" configs {{{
set nocompatible
set relativenumber
set number
" }}}

" functions {{{
function! ToggleNumber()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc
" }}}

" mappings {{{
inoremap jk <esc>
nnoremap <silent> <C-f> :GFiles<CR>
nnoremap <Leader>tn :call ToggleNumber()<CR>
" }}}
```

Your vimrc should look like this:

```
+-- 6 lines: setup folds -----

+-- 6 lines: plugins ---------

+-- 5 lines: configs ---------

+-- 9 ilnes: functions -------

+-- 5 lines: mappings --------
```

## Running Vim With Or Without Vimrc And Plugins

If you need to run Vim without both vimrc and plugins, run:

```
vim -u NONE
```

If you need to launch Vim without vimrc but with plugins, run:

```
vim -u NORC
```

If you need to run Vim with vimrc but without plugins, run:

```
vim --noplugin
```

If you need to run Vim with a *different* vimrc, say `~/.vimrc-backup`, run:

```
vim -u ~/.vimrc-backup
```

## Configure Vimrc The Smart Way

Vimrc is an important component of Vim customization. A good way to start building your vimrc is by reading other people's vimrcs and gradually build it over time. The best vimrc is not the one that developer X uses, but the one that is tailored exactly to fit your thinking framework and editing style.
