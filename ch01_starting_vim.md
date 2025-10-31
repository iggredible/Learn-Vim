# Ch01. Starting Vim

In this chapter, you will learn different ways to start Vim from the terminal. I was using Vim 8.2 when writing this guide. If you use Neovim or an older version of Vim, you should be mostly fine, but be aware that some commands might not be available.

## Installing

I won't go through the detailed instructions on how to install Vim on a specific machine. The good news is that most Unix-based computers should come with Vim installed already. If not, most distros should have some instructions on how to install Vim.

To download more information about the Vim installation process, check out the official download website or the official github repository:
- [Vim website](https://www.vim.org/download.php)
- [Vim github](https://github.com/vim/vim)

## The Vim Command

Now that you have Vim installed, run this from the terminal:

```bash
vim
```

You should see an intro screen. This is where you will be working on your new file. Unlike most text editors and IDEs, Vim is a modal editor. If you want to type "hello", you need to switch to insert mode with `i`. Input `ihello<Esc>` to insert the text, "hello".

## Exiting Vim

There are several ways to exit Vim. The most common one is to type:

```
:quit
```

You can type `:q` for short. This command is a command for command-line mode (another one of Vim modes). If you type `:` in normal mode, the cursor will move to the bottom of the screen, where you can type some commands. You will learn about command-line mode later in chapter 15. If you are in insert mode, typing `:` will literally produce the character ":" on the screen. In this case, you need to switch back to normal mode. Type `<Esc>` to switch to normal mode. By the way, you can also return to normal mode from command-line mode by pressing `<Esc>`. You will notice that you can "escape" out of several Vim modes back to normal mode by pressing `<Esc>`.

## Saving a File

To save your changes, type:

```
:write
```

You can also type `:w` for short. If this is a new file, you will need to give it a name before you can save it. Let's name it `file.txt`. Run:

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

There are other ways to exit Vim, but these are the ones you will use on a daily basis.

## Help

Throughout this guide, I will refer you to various Vim help pages. You can go to the help page by typing `:help {some-command}` (`:h` for short). You can pass to the `:h` command a topic or a command name as an argument. For example, to learn about different ways to quit Vim, type:

```
:h write-quit
```

How did I know to search for "write-quit"? I actually didn't. I just typed `:h`, then "quit", then `<Tab>`. Vim displayed relevant keywords to choose from. If you ever need to look up something ("I wish Vim can do this..."), just type `:h` and try inputting some keywords, then press `<Tab>`.

## Opening a File

To open a file (`hello1.txt`) on Vim from the terminal, run:

```bash
vim hello1.txt
```

You can also open multiple files at once:

```bash
vim hello1.txt hello2.txt hello3.txt
```

Vim opens `hello1.txt`, `hello2.txt`, and `hello3.txt` in separate buffers. You will learn about buffers in the next chapter.

## Arguments

You can pass the `vim` terminal command with different flags and options.

To check the current Vim version, run:

```bash
vim --version
```

This tells you the current Vim version and all available features, which will be prefixed by either `+` or `-`. Some features in this guide require certain features to be available. For example, you will explore Vim's command-line history in a later chapter using the `:history` command. Your installation of Vim needs to have the `+cmdline_history` feature for the command to work. There is a good chance that your installation of Vim has all the necessary features, especially if it came from a popular download source.

Many things you do from the terminal can also be done from inside Vim. To see the version from *inside* Vim, you can run this: 

```
:version
```

If you want to open the file `hello.txt` and immediately execute a Vim command, you can pass to the `vim` command the `+{cmd}` option.

In Vim, you can substitute strings with the `:s` command (short for `:substitute`). If you want to open `hello.txt` and substitute all instances of "pancake" with "bagel", run:

```bash
vim +%s/pancake/bagel/g hello.txt
```

These Vim commands can be stacked:

```bash
vim +%s/pancake/bagel/g +%s/bagel/egg/g +%s/egg/donut/g hello.txt
```

Vim will:
1. Replace all instances of "pancake" with "bagel"
2. Then it will replace "bagel" with "egg"
3. Then it will replace "egg" with "donut"
You will learn substitution in a later chapter.

You can also pass the `-c` option followed by a Vim command, instead of using the `+` syntax:

```bash
vim -c %s/pancake/bagel/g hello.txt
vim -c %s/pancake/bagel/g -c %s/bagel/egg/g -c %s/egg/donut/g hello.txt
```

## Opening Multiple Windows

You can launch Vim on split horizontal and vertical windows using the `-o` and `-O` options, respectively.

To open Vim with 2 horizontal windows, run:

```bash
vim -o2
```

To open Vim with 5 horizontal windows, run:

```bash
vim -o5
```

To open Vim with 5 horizontal windows and fill up the first two with `hello1.txt` and `hello2.txt`, run:

```bash
vim -o5 hello1.txt hello2.txt
```

To open Vim with 2 vertical windows, 5 vertical windows, and 5 vertical windows with two files, `hello1.txt` and `hello2.txt`:

```bash
vim -O2
vim -O5
vim -O5 hello1.txt hello2.txt
```

## Suspending

If you need to suspend Vim while in the middle of editing, you can press `Ctrl-z`. You can also run either the `:stop` or `:suspend` command. To return to the suspended Vim, run `fg` from the terminal.

## Starting Vim the Smart Way

The `vim` command can take many different options, just like any other terminal command. Two options allow you to pass a Vim command-line mode command as a parameter: `+{cmd}` and `-c cmd`. As you learn more commands throughout this guide, see if you can execute them when starting Vim. Also, being a terminal command, `vim` can be combined with many other terminal commands. For example, you can redirect the output of the `ls` command to be edited in Vim with `ls -l | vim -`.

To learn more about `vim` command in the terminal, check out `man vim`. To learn more about the Vim editor, continue reading this guide and use the `:help` command.

## Link
- Prev [Ch00. Read This First](./ch00_read_this_first.md)
- Next [Ch02. Buffers, Windows, and Tabs](./ch02_buffers_windows_tabs.md)
