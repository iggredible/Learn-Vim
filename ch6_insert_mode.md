# Insert Mode

Insert mode is the default mode of many text editors. In this mode, what you type is what you get.

In this chapter, you will learn how to use features in Vim insert mode to improve your typing efficiency. 

# Ways to go to Insert Mode

There are many ways to get into insert mode from the normal mode. Here are some of them:
```
i    Insert text before the cursor
I    Insert text before the first non-blank character of the line.
a    Append text after the cursor
A    Append text at the end of line
o    Starts a new line below the cursor and insert text
O    Starts a new line above the cursor and insert text
gi   Insert text in same position where the last insert mode was stopped in current buffer
gI   Insert text at the start of line (column 1)
```

Notice the lowercase / uppercase pattern. For every lowercase command, there is an uppercase counterpart. If you are new, don't worry if you don't remember the whole list above. Start with `i` and `a`. They should be enough to get you started. Slowly add more command into your memory.

# Different Ways to Exit Insert Mode

There is a few different ways to return to the normal mode while in the insert mode:
```
<esc>     Exits insert mode and go to normal mode
Ctrl-[    Exits insert mode and go to normal mode
Ctrl-c    Like Ctrl-[ and <esc>, but does not check for abbreviation
```

I find `esc` key too far to reach, so I map my computer `caps lock` to behave like `esc`. If you search for Bill Joy's ADM-3A keyboard (Vi creator), you will see that `esc` key is not located on far top left like modern keyboards, but to the left of `q` key. This is why I think it makes sense to map  `caps lock` to `esc`. 

Another common convention I have seen Vim users do is to map `esc` to `jj` or `jk` in insert mode.

```
inoremap jj <esc>
inoremap jk <esc>
```
# Repeating Insert Mode

You can pass a count parameter before entering insert mode. For example:
```
10i
```

If you type "hello world!" and exit insert mode, Vim will repeat the text 10 times. This will work with any insert mode method (ex: `10I`, `11a`, `12o`).

# Deleting Chunks in Insert Mode

When you make a typing mistake, it can be cumbersome to type `backspace` repeatedly. It may make more sense to go to normal mode and delete (`d`) your mistake. Alternatively, you can delete one or more characters at a time while in insert mode:

```
Ctrl-h    Delete one character
Ctrl-w    Delete one word
Ctrl-u    Delete the entire line
```

By the way, these shortcuts also work in command-line mode and Ex mode (I will cover command-line and Ex mode in later chapters).

# Insert From Register

Registers are like in-memory scratchpads that store and retrieve texts. To insert a text from any named register while in insert mode, type `Ctrl-r` plus the register symbol. There are many symbols you can use, but for this section, just know that you can use named registers (a-z).

To see it in action, first you need to yank a word to register a. You can do this with:
```
"ayiw
```
- `"a` tells Vim that the target of your next action will go to register a.
- `yiw` yanks inner word. Review the chapter on Vim grammar.

Register "a" now contains the word you just yanked. While in insert mode, to paste the text stored in register "a":

```
Ctrl-r a
```

There are multiple types of registers in Vim. I will cover them in greater detail in the next chapter.

# Scrolling

Did you know that you can scroll while inside insert mode? While in insert mode, if you go to `Ctrl-x` sub-mode, you can do additional operations. Scrolling is one of them.

```
Ctrl-x Ctrl-y    Scroll up
Ctrl-x Ctrl-e    Scroll down
```

# Autocompletion

Vim has a built-in autocompletion mechanism using `Ctrl-x` sub-mode (like scrolling). Although it is not as good as [intellisense](https://code.visualstudio.com/docs/editor/intellisense) or any other Language Server Protocol (LSP), but for something that is available right out-of-the-box, it is a very capable feature.

Here are some useful autocomplete commands to get started:
```
Ctrl-x Ctrl-l	   Insert a whole line
Ctrl-x Ctrl-n	   Insert a text from current file
Ctrl-x Ctrl-i	   Insert a text from included files
Ctrl-x Ctrl-f	   Insert a file name
```

When you trigger autocompletion, Vim will display a pop-up window. To navigate up and down the pop-up window, use `Ctrl-n` and `Ctrl-p`.

Vim also has two autocompletions that don't use `Ctrl-x` sub-mode:

```
Ctrl-n             Find the next word match
Ctrl-p             Find the previous word match
```

In general, Vim looks at the text in all available buffers for autocompletion source. If you have an open buffer with a line that says "Chocolate donuts are the best":
- When you type "Choco" and do `Ctrl-x Ctrl-l`, it will match and print the entire line.
- When you type "Choco" and do `Ctrl-p`, it will match and print the word "Chocolate".

Autocomplete is a vast topic in Vim. This is just the tip of the iceberg. To learn more, check out `:h ins-completion`.

# Executing a Normal Mode Command

Did you know Vim can execute a normal mode command while inside insert mode?

While in insert mode, if you press `Ctrl-o`, you'll be in `insert-normal` sub-mode. If you look at the mode indicator on bottom left, normally you will see `-- INSERT --`, but pressing `Ctrl-o`  changes it to `-- (insert) --`. In this mode, you can do *one* normal mode command. Some things you can do:

**Centering and jumping**
```
Ctrl-o zz       Center window
Ctrl-o H/M/L    Jump to top/middle/bottom window
Ctrl-o 'a       Jump to mark 'a'
```

**Repeating text**
```
Ctrl-o 100ihello    Insert "hello" 100 times
```

**Executing terminal commands**
```
Ctrl-o !! curl https://google.com    Run curl
Ctrl-o !! pwd                        Run pwd
```

**Deleting faster**
```
Ctrl-o dtz    Delete from current location till the letter "z"
Ctrl-o D      Delete from current location to the end of the line
```

# Learn Insert Mode the Smart Way

If you are like me and you come from another text editor, it can be tempting to stay in insert mode. However, staying in insert mode when you're not entering a text is an anti-pattern. Develop a habit to go to normal mode when your fingers aren't typing new texts.

When you need to insert a text, first ask yourself if that text already exists. If it does, try to yank or move that text instead of typing it. Should you have to enter insert mode, see if you can autocomplete that text as much as possible. Avoid typing the same word more than once if you can.
