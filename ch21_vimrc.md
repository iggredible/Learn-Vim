# Ch 21. Configuring Vimrc

In the previous chapters, you learned how to use Vim. From now on, you will learn how to customize Vim to fit your coding style.

In this chapter, you will learn how to configure and organize vimrc.

## How Vim Finds Vimrc

The conventional wisdom to configure vimrc is to add a `.vimrc` dotfile in the root directory of your computer (`~/.vimrc`).

Behind the scene, Vim looks at multiple places for a vimrc file, not only the root directory. Here are the places that Vim checks:

- `$VIMINIT`
- `$HOME/.vimrc`
- `$HOME/.vim/vimrc`
- `EXINIT`
- `$HOME/.exrc`
- `$HOME/.vim/exrc`
- `$VIMRUNTIME/default.vim`

When you start Vim, it will check the above seven locations in that order for a "vimrc" file (in this chapter, I will refer to the runtime command file Vim uses at start-time as vimrc, regardless what the file is actually named). The first vimrc file found will be used and the rest is ignored. First Vim will look for `$VIMINIT`. If there is nothing there, Vim checks for `$HOME/.vimrc`. If there is nothing there, Vim checks for `$HOME/.vim/vimrc`. If Vim finds it, it will stop looking and use `$HOME/.vim/vimrc`. Let's break down what each path means.

The first, `$VIMINIT`, is an environment variable. By default it is undefined. If you want to use `~/dotfiles/hellovim` as your `$VIMINIT` value, you can define it as follows:

1. Create a `~/.dotfiles/hellovim` and inside it have:

```
set nocompatible
set relativenumber number
```

2. In the terminal, run `export VIMINIT='let $MYVIMRC="$HOME/dotfiles/hellovim" | source $MYVIMRC'`

Now when you run Vim from the terminal, it will use `~/dotfiles/hellovim` as a vimrc file.

The second, `$HOME/.vimrc`, is the conventional path for many Vim users. `$HOME` in most cases is your root directory (`~`). If you drop the vimrc in this path, `~/.vimrc`, Vim will use this file.

The third, `$HOME/.vim/vimrc`, is located inside the `~/.vim` directory. You might have the `~/.vim` directory already for your plugins, custom scripts, or View files. Note that there is no dot in `vimrc` file name (`$HOME/.vim/.vimrc` doesn't work, but `$HOME/.vim/vimrc` does).

The fourth, `$EXINIT` is similar to `$VIMINIT`. The fifth and sixth, `$HOME/.exrc` and `$HOME/.vim/exrc` are also similar to `$HOME/.vimrc` and `$HOME/.vim/exrc`.

The seventh, `$VIMRUNTIME/defaults.vim` is the default vimrc that comes with your Vim build. In my case, I have Vim 8.2 installed, so my path is (`/usr/local/share/vim/vim82`). If Vim does not find any of the previous six vimrc file, it will use this file.

## Installing Plugins

For the remaining of this chapter, I am assuming that the vimrc follows the `~/.vimrc` path. Regardless where you actually put your vimrc, you should be able to follow along.

In the previous chapters, I have ocassionally mentioned different plugins, like [fzf.vim](https://github.com/junegunn/fzf.vim), [vim-mundo](https://github.com/simnalamburt/vim-mundo), and [vim-fugitive](https://github.com/tpope/vim-fugitive).

Let's talk about different ways to install plugins. Ten years ago, managing plugins was a nightmare. However, with the emergence of modern plugin managers, installing plugins can now be done within seconds. I am currently using [vim-plug](https://github.com/junegunn/vim-plug) as my plugin manager, so I will use it in this section. The concept should be similar with other popular plugin managers. I would strongly recommend you to check out different ones, such as:

- [vundle.vim](https://github.com/VundleVim/Vundle.vim)
- [vim-pathogen](https://github.com/tpope/vim-pathogen)
- [dein.vim](https://github.com/Shougo/dein.vim)

There are more plugin managers than the ones listed above. To install vim-plug, if you have a Unix machine, run:

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

Vim 8 has its own built-in package managers. You can check out `:h packages` for more information. In a later chapter, I will show you how to use it.

## Modifying vimrc

A vimrc is nothing but a collection of command-line commands. For example, to display `number` and `relativenumber` settings, you can run `:set relativenumber number` command from the current buffer. But this command is not permanent, you will lose it when you close Vim. You need to add them to your vimrc:

```
set relativenumber
set number
```

Alternatively, you can also put them in one line:

```
set relativenumber number
```

Both do the same thing. It comes down to your personal preference.

It is common to put mappings in your vimrc. I personally like to use `<space>` as the leader key instead of Vim's default. To change your leader key to a backslash, you can add this in your vimrc:

```
let mapleader = "\<space>"
```

I find myself opening, editing, and sourcing vimrc quite often in the middle of a programming session. Having to manually find vimrc can take a lot of effort, so I add this in my vimrc:

```
nnoremap <Leader>ve :vsplit $MYVIMRC<CR>
nnoremap <Leader>vs :source $MYVIMRC<CR>
```

Recall that `nnoremap` adds a non-recursive Normal-mode mapping. Vim has the environment variable `$MYVIMRC` to store the path of your vimrc. I can quickly open my vimrc file with `<leader>ve` ("vimrc edit" mnemonic) and source it with `<leader>vs` ("vimrc source" mnemonic).

## Organizing Vimrc

Over time, your vimrc will grow large and start to become convoluted. There are two ways to keep your vimrc to look clean:

- Split your vimrc into several files.
- Fold your vimrc file based on categories.

### Splitting Your Vimrc

You can split your vimrc to multiple files using Vim's `source` command. This command reads command-line commands from the given file argument.

Let's create a file inside the `~/.vim` directory and name it `/settings` (`~/.vim/settings`). The name itself is arbitrary and you can name it whatever you like.

You are going to split it into three components:

- Third-party plugins (`~/.vim/settings/plugins.vim`).
- General settings (`~/.vim/settings/configs.vim`).
- Key mappings (`~/.vim/settings/mappings.vim`) .

Inside `~/.vimrc`:

```
source $HOME/.vim/settings/plugins.vim
source $HOME/.vim/settings/configs.vim
source $HOME/.vim/settings/mapppings.vim
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
set relativenumber
set number
```

Inside `~/.vim/mappings.vim`:

```
nnoremap <Leader>vs :source $MYVIMRC<CR>
nnoremap <Leader>ve :vsplit $MYVIMRC<CR>
```

Your vimrc should works as usual, but now it is only three lines long!

With this setup, you easily know where to go. If you need to add more mappings, simple head to the `/mappings.vim` file. In the future, you can always add more directories as your vimrc grows. For example, if you have many custom functions, you can store them inside `/functions.vim`.

### Keeping One Vimrc File

You may prefer to keep one vimrc file to keep it portable but your vimrc file is growing uncontrollably large. How do you manage this?

You use marker folds. Add this at the top of your vimrc:

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

" mappings {{{
nnoremap <Leader>vs :source $MYVIMRC<CR>
nnoremap <Leader>ve :vsplit $MYVIMRC<CR>
" }}}
```

Your vimrc should look like this:

```
+-- 6 lines: setup folds -----

+-- 6 lines: plugins ---------

+-- 5 lines: configs ---------

+-- 4 lines: mappings --------
```

## Running vim without vimrc

If you need to run Vim without any vimrc, run this from the terminal:

```
vim -u NONE
```

If you need to run Vim with a *different* vimrc, say `~/.vimrc-extra`, run this from the terminal:

```
vim -u ~/.vimrc-extra
```

The `u` flag overwrites all the seven vimrc paths mentioned earlier.

## Configuring Vimrc The Smart Way

In the beginning, there is a strong temptation to copy other people's vimrc. Resist it. By copying other people's vimrc, you might not always know what you're copying. It doesn't matter if other developer has over 1000 lines of vimrc while yours only have 10. As long as you get the job done, that's all that matters.

Vimrc is an important component of Vim customization. It should be tailored to fit your thinking framework and editing style.

Whenever you find that you are doing the same thing repeatedly, it is a good indication that you need a new mapping or function in your vimrc. To do that, you will need to learn how to create your own Vimscript functions and that's what the rest of this book is for.
