# Ch06. Insert Mode

Insert mode is the default mode of many text editors. In this mode, what you type is what you get.

However, that does not mean there isn't much to learn. Vim's insert mode contains many useful features. In this chapter, you will learn how to use these insert mode features in Vim to improve your typing efficiency.

## Ways to Go to Insert Mode

There are many ways to get into insert mode from the normal mode. Here are some of them:

```
i    Insert text before the cursor
I    Insert text before the first non-blank character of the line
a    Append text after the cursor
A    Append text at the end of line
o    Starts a new line below the cursor and insert text
O    Starts a new line above the cursor and insert text
s    Delete the character under the cursor and insert text
S    Delete the current line and insert text
gi   Insert text in same position where the last insert mode was stopped
gI   Insert text at the start of line (column 1)
```

Notice the lowercase / uppercase pattern. For each lowercase command, there is an uppercase counterpart. If you are new, don't worry if you don't remember the whole list above. Start with `i` and `o`. They should be enough to get you started. Gradually learn more over time.

## Different Ways to Exit Insert Mode

There are a few different ways to return to the normal mode while in the insert mode:

```
<Esc>     Exits insert mode and go to normal mode
Ctrl-[    Exits insert mode and go to normal mode
Ctrl-C    Like Ctrl-[ and <Esc>, but does not check for abbreviation
```

I find `<Esc>` key too far to reach, so I map my computer `<Caps-Lock>` to behave like `<Esc>`. If you search for Bill Joy's ADM-3A keyboard (Vi creator), you will see that the `<Esc>` key is not located on far top left like modern keyboards, but to the left of `q` key. This is why I think it makes sense to map  `<Caps lock>` to `<Esc>`.

Another common convention I have seen Vim users do is mapping `<Esc>` to `jj` or `jk` in insert mode. If you prefer this option add this one of those lines (or both) in your vimrc file.

```
inoremap jj <Esc>
inoremap jk <Esc>
```

## Repeating Insert Mode

You can pass a count parameter before entering insert mode. For example:

```
10i
```

If you type "hello world!" and exit insert mode, Vim will repeat the text 10 times. This will work with any insert mode method (ex: `10I`, `11a`, `12o`).

## Deleting Chunks in Insert Mode

When you make a typing mistake, it can be cumbersome to type `<Backspace>` repeatedly. It may make more sense to go to normal mode and delete your mistake. You can also delete several characters at a time while in insert mode.

```
Ctrl-h    Delete one character
Ctrl-w    Delete one word
Ctrl-u    Delete the entire line
```

## Insert From Register

Vim registers can store texts for future use. To insert a text from any named register while in insert mode, type `Ctrl-R` plus the register symbol. There are many symbols you can use, but for this section, let's cover only the named registers (a-z).

To see it in action, first you need to yank a word to register a. Move your cursor on any word. Then type:

```
"ayiw
```

- `"a` tells Vim that the target of your next action will go to register a.
- `yiw` yanks inner word. Review the chapter on Vim grammar for a refresher.

Register a now contains the word you just yanked. While in insert mode, to paste the text stored in register a:

```
Ctrl-R a
```

There are multiple types of registers in Vim. I will cover them in greater detail in a later chapter.

## Scrolling

Did you know that you can scroll while inside insert mode? While in insert mode, if you go to `Ctrl-X` sub-mode, you can do additional operations. Scrolling is one of them.

```
Ctrl-X Ctrl-Y    Scroll up
Ctrl-X Ctrl-E    Scroll down
```

## Autocompletion

As mentioned above, if you press `Ctrl-X` from insert mode, Vim will enter a sub-mode. You can do text autocompletion while in this insert mode sub-mode. Although it is not as good as [intellisense](https://code.visualstudio.com/docs/editor/intellisense) or any other Language Server Protocol (LSP), but for something that is available right out of the box, it is a very capable feature.

Here are some useful autocomplete commands to get started:

```
Ctrl-X Ctrl-L	   Insert a whole line
Ctrl-X Ctrl-N	   Insert a text from current file
Ctrl-X Ctrl-I	   Insert a text from included files
Ctrl-X Ctrl-F	   Insert a file name
```

When you trigger autocompletion, Vim will display a pop-up window. To navigate up and down the pop-up window, use `Ctrl-N` and `Ctrl-P`.

Vim also has two autocompletion shortcuts that don't involve the `Ctrl-X` sub-mode:

```
Ctrl-N             Find the next word match
Ctrl-P             Find the previous word match
```

In general, Vim looks at the text in all available buffers for autocompletion source. If you have an open buffer with a line that says "Chocolate donuts are the best":
- When you type "Choco" and do `Ctrl-X Ctrl-L`, it will match and print the entire line.
- When you type "Choco" and do `Ctrl-P`, it will match and print the word "Chocolate".

Autocomplete is a vast topic in Vim. This is just the tip of the iceberg. To learn more, check out `:h ins-completion`.

## Executing a Normal Mode Command

Did you know Vim can execute a normal mode command while in insert mode?

While in insert mode, if you press `Ctrl-O`, you'll be in insert-normal sub-mode. If you look at the mode indicator on bottom left, normally you will see `-- INSERT --`, but pressing `Ctrl-O`  changes it to `-- (insert) --`. In this mode, you can do *one* normal mode command. Some things you can do:

**Centering and jumping**

```
Ctrl-O zz       Center window
Ctrl-O H/M/L    Jump to top/middle/bottom window
Ctrl-O 'a       Jump to mark a
```

**Repeating text**

```
Ctrl-O 100ihello    Insert "hello" 100 times
```

**Executing terminal commands**

```
Ctrl-O !! curl https://google.com    Run curl
Ctrl-O !! pwd                        Run pwd
```

**Deleting faster**

```
Ctrl-O dtz    Delete from current location till the letter "z"
Ctrl-O D      Delete from current location to the end of the line
```

## Learn Insert Mode the Smart Way

If you are like me and you come from another text editor, it can be tempting to stay in insert mode. However, staying in insert mode when you're not entering a text is an anti-pattern. Develop a habit to go to normal mode when your fingers aren't typing new text.

When you need to insert a text, first ask yourself if that text already exists. If it does, try to yank or move that text instead of typing it. If you have to use insert mode, see if you can autocomplete that text whenever possible. Avoid typing the same word more than once if you can.
