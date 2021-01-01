---
title: "Vim Packages"
metaTitle: "Vim Packages"
metaDescription: "Vim Packages"
---

The previous chapter talked about using external plugin managers to install plugins. However, starting at version 8, Vim comes with its own built-in plugin manager called *packages*. In this chapter, you will learn how to use Vim packages to install plugins.

To see if your Vim build has the ability to use packages, run `:version` and look for `+packages` attribute. Alternatively, you can also run `:echo has('packages')`. If it returns 1, then it has a packages ability.

## Pack

You should have a `~/.vim/` directory in the root path (check the previous chapter for a refresher). Inside, create a directory called `pack` (`~/.vim/pack/)`. Vim automatically knows to search inside this directory for packages.

## Two Types Of Loading

Vim package has two loading mechanisms: automatic and manual loading.

### Automatic Loading

To load plugins automatically when Vim starts, you need to put them in the `start/` directory. The path looks like this:

```
~/.vim/pack/*/start/
```

Now you may ask, "What is the `*` between `pack/` and `start/`?" `*` is arbitrary and can be anything you want. let's name it `packdemo/`:

```
~/.vim/pack/packdemo/start/
```

Keep in mind that if you skip it and decide to do something like this:

```
~/.vim/pack/start/
```

The package system won't work. It is imperative to put a name between `pack/` and `start/`. For this demo, let's try to install the [NERDTree](https://github.com/preservim/nerdtree) plugin. Go all the way to the `start/` directory (`cd ~/.vim/pack/packdemo/start/`) and clone the NERDTree repository:

```
git clone https://github.com/preservim/nerdtree.git
```

That's it! You are all set. The next time you start Vim, you can immediately execute NERDTree commands like `:NERDTreeToggle`.

You can clone as many plugin repositories as you want inside the `~/.vim/pack/*/start/` path. Vim will automatically load each one. If you remove the cloned repository (`rm -rf nerdtree/`), that plugin will not be available anymore.

### Manual Loading

To load plugins manually when Vim starts, you need to put them in the `opt/` directory. Similar to automatic loading, the path looks like this:

```
~/.vim/pack/*/opt/
```

Let's use the same `packdemo/` directory from earlier:

```
~/.vim/pack/packdemo/opt/
```

This time, let's install the [killersheep](https://github.com/vim/killersheep) game (this requires Vim 8.2). Go to the `opt/` directory (`cd ~/.vim/pack/packdemo/opt/`) and clone the repository:

```
git clone https://github.com/vim/killersheep.git
```

Start Vim. The command to execute the game is `:KillKillKill`. Try running it. Vim will complain that it is not a valid editor command. You need to *manually* load the plugin first. Let's do that:

```
:packadd killersheep
```

Now try running the command again `:KillKillKill`. The command should work now.

You may wonder, "Why would I ever want to manually load packages? Wouldn't it be better to automatically load everything?"

Great question. Sometimes there are plugins that you won't use all the time, like that KillerSheep game. You probably don't need to load 10 different games and slow down Vim startup time. However, once in a while, when you are bored, you might want to play a few games. Manually-loaded plugins are useful for nonessential plugins.

You can also use manual plugins to conditionally add plugins. Maybe you use both Neovim and Vim and there are plugins optimized for Neovim. You can add something like this in your vimrc:

```
if has('nvim')
  packadd! neovim-only-plugin
else
  packadd! generic-vim-plugin
endif
```

## Organizing packages

Recall that the requirement to use Vim's package system is to have either:

```
~/.vim/pack/*/start/
```

or

```
~/.vim/pack/*/opt/
```

The fact that `*` can be *any* name can be used to organize your packages. Suppose you want to group your plugins based on categories (colors, syntax, and games):

```
~/.vim/pack/colors/
~/.vim/pack/syntax/
~/.vim/pack/games/
```

You can still use `start/` and `opt/` inside each of the directories.

```
~/.vim/pack/colors/start/
~/.vim/pack/colors/opt/

~/.vim/pack/syntax/start/
~/.vim/pack/syntax/opt/

~/.vim/pack/games/start/
~/.vim/pack/games/opt/
```

## Adding Packages The Smart Way

You may wonder if Vim package will make popular plugin managers like vim-pathogen, vundle.vim, dein.vim, and vim-plug obsolete.

The answer is, as always, "it depends."

I still use vim-plug because it makes it easy to add, remove or update plugins. If you use many plugins, it may be more convenient to use plugin managers because it is easy to update many simultaneously. Some plugin managers also support asynchronous API installation.

If you are a minimalist and only use a few plugins, try out Vim packages. If you use many plugins, you may want to consider using a plugin manager.
