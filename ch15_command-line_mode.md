# Ch 15. Command-Line Mode

In the last three chapters, you learned how to use the search commands (`/`, `?`), substitute command (`:s`), global command (`:g`), and external command (`!`). These are examples of command-line mode commands.

In this chapter, you will learn various tips and tricks for the command-line mode.

## Entering And Exiting The Command-Line Mode
The command-line mode is a mode in itself, just like normal mode, insert mode, and visual mode. When you are in this mode, the cursor goes to the bottom of the screen where you can type in different commands.

There are 4 different commands you can use to enter the command-line mode:
- Search patterns (`/`, `?`)
- Command-line commands (`:`)
- External commands (`!`)

You can enter the command-line mode from the normal mode or the visual mode. 

To leave the command-line mode, you can use `<esc>`, `Ctrl-C, or Ctrl-[`.

*Sometimes other literatures might refer the "Command-line command" as "Ex command" and the "External command" as "filter command" or "bang operator".*

## Repeating The Previous Command
You can repeat the previous command-line command or external command with `@:`. 

If you just ran `:s/foo/bar/g`, running `@:` repeats that substitution.

If you just ran `:.!tr '[a-z]' '[A-Z]'`, running `@:` repeats the last external command translation filter.

## Command-Line Mode Shortcuts

While in the command-line mode, you can move to the left or to the right, one character at a time, with the `Left` or `Right` arrow.

If you need to move word-wise, use `Shift-Left` or `Shift-Right` (in some OS, you might have to use `Ctrl` instead of `Shift`).

To go to the start of the line, use `Ctrl-B`. To go to the end of the line, use `Ctrl-E`.

Similar to the insert mode, inside the command-line mode, you have three ways to delete characters:

```
Ctrl-H    Delete one character
Ctrl-W    Delete one word
Ctrl-U    Delete the entire line
```
Finally, if you want to edit the command like you would a normal textfile use `Ctrl-F`.

This also allows you to search through the previous commands, edit them and rerun them by pressing `Enter` in "command-line editing normal mode".

## Register And Autocomplete

When programming, whenever possible, do not repeat if you can autocomplete it. This mindset will not only save you time but reduces the chances of typing the wrong characters.

You can insert texts from Vim register with `Ctrl-R` (the same way as the insert mode). If you have the string "foo" saved in the register "a" (`"a`), you can insert it by running `Ctrl-R a`. Everything that you can get from the register in the insert mode, you can do the same from the command-line mode.

You can also autocomplete commands. To autocomplete the `echo` command, while in the command-line mode, type "ec", then press `<Tab>`. You should see on the bottom left Vim commands starting with "ec" (example: `echo echoerr echohl echomsg econ`). To go to the next option, press either `<Tab>` or `Ctrl-N`. To go the previous option, press either `<Shift-Tab>` or `Ctrl-P`.

Some command-line commands accept file names as arguments. One example is `edit`. After typing the command, `:e ` (don't forget the space), press `<Tab>`. Vim will list all the relevant file names.

## History Window

You can view the histoy of command-line commands and search terms (make sure that your Vim build has `+cmdline_hist` when you run `vim --version`).

To open the command-line history, run `:his :`:

```
##  cmd History
2  e file1.txt
3  g/foo/d
4  s/foo/bar/g
```

Vim lists the history of all the `:` commands you run. By default, Vim stores the last 50 commands. To change the amount of the entries that Vim remembers to 100, you can run `:set history=100`.

When you are in the command-line mode, you can traverse this history list by pressing `Up` and `Down` button. Suppose you had the command-line command history that looks like:
```
51  s/foo/bar/g
52  s/foo/baz/g
53  s/foo//g
```

If you press `:` then press `Up` once, you'll see `:s/foo//g`. Press `Up` one more time to see `:s/foo/baz/g`. Vim goes up the history list. 

Similarly, to view the search history, run `:his /`. You can also traverse the history stack by pressing `Up` or `Down` after running the history command `/`.

Vim is smart enough to distinguish different histories. If you press `Up` or `Down` after pressing `:`, Vim automatically the command history. If you press `Up` or `Down` after pressing `/`, Vim automatically searches the search history.

## Command-Line Window

The history window displays the list of previously used command-line commands, but you can't execute the command from the history window. To execute a command while browsing, use the *command-line window*. There are three different command-line windows:

```
q:    Command-line window
q/    Forward search window
q?    Backward search window
```

Run `q:` to launch the command-line window for command-line commands. Vim will launch a new window at the bottom of the screen. You can traverse upward with the `Up` or `Ctrl-P` keys and traverse downward with the `Down` or `Ctrl-N` keys. If you press `<Return>`, Vim executes that command. To quit the command-line window, either press `Ctrl-C`, `Ctrl-W C`, or type `:quit`.

Similarly, to launch the command-line window for search, run `q/` to search forward and `q?` to search backward.

## Learn Command-Line Mode The Smart Way

Compared to the other three modes, the command-line mode is like the Swiss Army knife of text editing. You can edit text, modify files, and execute commands, just to name a few.  This chapter is a collection of odds and ends of the command-line mode. It also brings Vim modes into closure. Now that you know how to use the normal, insert, visual, and command-line mode you can edit text with Vim faster than ever.

It's time to move away from Vim modes and learn how to do a faster navigation with Vim tags.
