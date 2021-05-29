# Ch15. Command-line Mode

In the last three chapters, you learned how to use the search commands (`/`, `?`), substitute command (`:s`), global command (`:g`), and external command (`!`). These are examples of command-line mode commands.

In this chapter, you will learn various tips and tricks for the command-line mode.

## Entering and Exiting the Command-line Mode

The command-line mode is a mode in itself, just like normal mode, insert mode, and visual mode. When you are in this mode, the cursor goes to the bottom of the screen where you can type in different commands.

There are 4 different commands you can use to enter the command-line mode:
- Search patterns (`/`, `?`)
- Command-line commands (`:`)
- External commands (`!`)

You can enter the command-line mode from the normal mode or the visual mode.

To leave the command-line mode, you can use `<Esc>`, `Ctrl-C, or Ctrl-[`.

*Other literatures might refer the "Command-line command" as "Ex command" and the "External command" as "filter command" or "bang operator".*

## Repeating the Previous Command

You can repeat the previous command-line command or external command with `@:`.

If you just ran `:s/foo/bar/g`, running `@:` repeats that substitution. If you just ran `:.!tr '[a-z]' '[A-Z]'`, running `@:` repeats the last external command translation filter.

## Command-line Mode Shortcuts

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

This also allows you to search through the previous commands, edit them and rerun them by pressing `<Enter>` in "command-line editing normal mode".

## Register and Autocomplete

While in the command-line mode, you can insert texts from Vim register with `Ctrl-R` the same way as the insert mode. If you have the string "foo" saved in the register a, you can insert it by running `Ctrl-R a`. Everything that you can get from the register in the insert mode, you can do the same from the command-line mode.

In addition, you can also get the word under the cursor with `Ctrl-R Ctrl-W` (`Ctrl-R Ctrl-A` for the WORD under cursor). To get the line under the cursor, use `Ctrl-R Ctrl-L`. To get the filename under the cursor, use `Ctrl-R Ctrl-F`.

You can also autocomplete existing commands. To autocomplete the `echo` command, while in the command-line mode, type "ec", then press `<Tab>`. You should see on the bottom left Vim commands starting with "ec" (example: `echo echoerr echohl echomsg econ`). To go to the next option, press either `<Tab>` or `Ctrl-N`. To go the previous option, press either `<Shift-Tab>` or `Ctrl-P`.

Some command-line commands accept file names as arguments. One example is `edit`. You can autocomplete here too. After typing the command, `:e ` (don't forget the space), press `<Tab>`. Vim will list all the relevant file names that you can choose from so you don't have to type it from scratch.

## History Window and Command-line Window

You can view the histoy of command-line commands and search terms (this requires the `+cmdline_hist` feature).

To open the command-line history, run `:his :`. You should see something like the following:

```
## Cmd history
2  e file1.txt
3  g/foo/d
4  s/foo/bar/g
```

Vim lists the history of all the `:` commands you run. By default, Vim stores the last 50 commands. To change the amount of the entries that Vim remembers to 100, you run `set history=100`.

A more useful use of the command-line history is through the command-line window,`q:`. This will open a searchable, editable history window. Suppose you have these expressions in the history when you press `q:`:

```
51  s/verylongsubstitutionpattern/pancake/g
52  his :
53  wq
```

If your current task is to do `s/verylongsubstitutionpattern/donut/g`, instead of typing the command from scratch, why don't you reuse `s/verylongsubstitutionpattern/pancake/g`? After all, the only thing that's different is the word substitute, "donut" vs "pancake". Everything else is the same.

After you ran `q:`, find that `s/verylongsubstitutionpattern/pancake/g` in the history (you can use the Vim navigation in this environment) and edit it directly! Change "pancake" to "donut" inside the history window, then press `<Enter>`. Boom! Vim executes `s/verylongsubstitutionpattern/donut/g` for you. Super convenient!

Similarly, to view the search history, run `:his /` or `:his ?`. To open the search history window where you can search and edit past history, run `q/` or `q?`.

To quit this window, press `Ctrl-C`, `Ctrl-W C`, or type `:quit`.

## More Command-line Commands

Vim has hundreds of built-in commands. To see all the commands Vim have, check out `:h ex-cmd-index` or `:h :index`.

## Learn Command-line Mode the Smart Way

Compared to the other three modes, the command-line mode is like the Swiss Army knife of text editing. You can edit text, modify files, and execute commands, just to name a few. This chapter is a collection of odds and ends of the command-line mode. It also brings Vim modes into closure. Now that you know how to use the normal, insert, visual, and command-line mode you can edit text with Vim faster than ever.

It's time to move away from Vim modes and learn how to do an even faster navigation with Vim tags.
