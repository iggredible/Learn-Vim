---
title: "Starting Vim"
metaTitle: "Starting Vim"
metaDescription: "Learn different ways to start Vim from the terminal."
---

In this chapter, you will learn different ways to start Vim from the terminal. I was using Vim 8.2 when writing this book. If you use Neovim or an older version of Vim, you should be (mostly) fine, but be aware that some commands might not be available.

## Installing

I will not go through the detailed instruction how to install Vim in your specific machine. The good news is, most Unix-based computers should come with Vim installed. If not, most distros should have a way to install Vim.

For download informations, check out Vim's official download website or Vim's official github repository:
- [Vim website](https://www.vim.org/download.php)
- [Vim github](https://github.com/vim/vim)

## The Vim Command

Now that you have Vim installed, run this from the terminal:

```bash
vim
```

You should see an intro screen. This is the where you will be working on your file. Unlike most text editors and IDEs, Vim is a modal editor. If you want to type "hello", you need to switch to Insert mode with `i`. Press `ihello<Esc>` to insert the text "hello".

## Exiting Vim

There are several ways to exit Vim. The most common one is to type:

```
:quit
```

You can type `:q` for short. That command is a Command-line mode command (another one of Vim modes). If you type `:` in Normal mode, the cursor will move to the bottom of the screen where you can type some commands. You will learn about the Command-line mode later in chapter 15. If you are in Insert mode, typing `:` will literally produce the character ":" on the screen. In this case, you need to switch back to Normal mode. Type `<Esc>` to switch to Normal mode. By the way, you can also return to Normal mode from Command-line mode by pressing `<Esc>`. You will notice that you can "escape" out of several Vim modes back to Normal mode by pressing `<Esc>`.

To save your changes, type:

```
:write
```

You can also type `:w` for short. If this is a new file, you need to give it a name before you can save it. Let's name it `file.txt`. Run:

```
:w file.txt
```

To save and quit, you can combine the `:w` and `:q` commands:

```
:wq
```

To quit without saving any changes, add `!` after `:q` to force quit:

```
:q!
```

There are other ways to exit Vim, but these are the ones you will use daily.

## Help

Throughout the book, I will refer you to various Vim help pages. You can access the help page by typing the following Command-line command:

```
:help
```

`:h` for short. You can also pass the `:h` command the subject you want to learn as an argument. For example, to learn more about different ways to quit Vim, you can type:

```
:h write-quit
```

How do I know to search for `write-quit`? I actually don't. I just type `:h`, type "quit", then press `<tab>`. Vim displays relevant keyword options to choose from. If you ever need to look for a functionality ("I wish Vim can do this..."), just type `:h` and try pressing `<tab>` against the different keywords.

## Opening a File

From the terminal, to open `hello1.txt` file, run:

```bash
vim hello1.txt
```

You can also open multiple files at once:

```bash
vim hello1.txt hello2.txt hello3.txt
```

Vim opens `hello1.txt`, `hello2.txt`, and `hello3.txt` in separate buffers. You will learn more about buffers in the next chapter.

## Arguments

You can pass the `vim` terminal command with different flags and options.

To check the current Vim version, run:

```bash
vim --version
```

This flag tells you the Vim version and all available features marked with either `+` or `-` Some of these features in this guide require certain features to be available. For example, you will explore Vim's command-line history in chapter 15 with the `:history` command. Your Vim needs to have `+cmdline_history` feature for the command to work.

This may sound like a lot of work, but the popular Vim downloads should have all the necessary features included in the build. In my Mac, the Vim version that I installed from `brew install vim` has all the key features I need.

Alternatively, to see the version information from *inside* Vim, you can also run this command:

```
:version
```

Later on, you will probably start adding plugins to Vim. If you ever need to run Vim without any plugins, you can pass the `noplugin` flag:

```
vim --noplugin
```

If you want to open the file `hello.txt` and immediately execute a command, you can pass the `vim` command the `+{cmd}` option.

In Vim, you can substitute text with the `:s` command (short for `:substitute`). If you want to open `hello.txt` and substitute all "foo" with "bar", run:

```bash
vim +%s/foo/bar/g hello.txt
```

These commands can also be stacked:

```bash
vim +%s/foo/bar/g +%s/bar/baz/g +%s/baz/donut/g hello.txt
```

Vim will first replace all instances of "foo" with "bar", then replace "bar" with "baz", then replace "baz" with "donut" (you willl learn about substitution in chapter 12).

You can also pass the `c` flag followed by the command instead of the `+` syntax:

```bash
vim -c %s/foo/bar/g hello.txt
vim -c %s/foo/bar/g -c %s/bar/baz/g -c %s/baz/donut/g hello.txt
```

Throughout this book you will learn various Command-line commands. These commands can all be executed on start.

## Opening Multiple Windows

You can launch Vim on split windows, horizontal and vertical, with `o` and `O`, respectively.

To open Vim with two horizontal windows, run:

```bash
vim -o
```

To open Vim with 5 horizontal windows, run:

```bash
vim -o5
```

To open Vim with 5 horizontal windows and fill up the first two with `hello1.txt` and `hello2.txt`, run:

```bash
vim -o5 hello1.txt hello2.txt
```

Retrospectively, to open Vim with two vertical windows, 5 vertical windows, and 5 vertical windows with 2 files:

```bash
vim -O
vim -O5
vim -O5 hello1.txt hello2.txt
```

## Suspending

If you need to suspend Vim while in the middle of editing, you can press `Ctrl-z`. Alternatively, you can also run either the `:stop` or `:suspend` command.

To return to the suspended Vim, run `fg` from the terminal.

## Starting Vim The Smart Way

You can pass the `vim` command with different options and flags, just like any terminal commands. One of the options is the command-line command (`+{cmd}` or `c cmd`). As you learn more command-line commands throughout this book, see if you can apply it on start. Also being a terminal command, you can combine `vim` with many other terminal commands. For example, you can redirect the output of the `ls` command to be edited in Vim with `ls -l | vim -`.

To learn more about the different options you can pass from the terminal, check out `man vim`. To learn more about Vim modes and commands, check out `:help`.

