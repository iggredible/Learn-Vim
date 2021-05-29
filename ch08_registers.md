# Ch08. Registers

Learning Vim registers is like learning algebra for the first time. You didn't think you need it until you needed it.

You've probably used Vim registers when you yanked or deleted a text then pasted it with `p` or `P`. However, did you know that Vim has 10 different types of registers? Used correctly, Vim registers can save you from repetitive typing.

In this chapter, I will go over all Vim register types and how to use them efficiently.

## The Ten Register Types

Here are the 10 Vim register types:

1. The unnamed register (`""`).
2. The numbered registers (`"0-9`).
3. The small delete register (`"-`).
4. The named registers (`"a-z`).
5. The read-only registers (`":`, `".`,and `"%`).
6. The alternate file register (`"#`).
7. The expression register (`"=`).
8. The selection registers (`"*` and `"+`).
9. The black hole register (`"_`).
10. The last search pattern register (`"/`).


## Register Operators

To use registers, you need to first store them with operators. Here are some operators that store values to registers:

```
y    Yank (copy)
c    Delete text and start insert mode
d    Delete text
```

There are more operators (like `s` or `x`), but the above are the useful ones. The rule of thumb is, if an operator can remove a text, it probably stores the text to registers.

To paste a text from registers, you can use:

```
p    Paste the text after the cursor
P    Paste the text before the cursor
```

Both `p` and `P` accept a count and a register symbol as arguments. For example, to paste ten times, do `10p`. To paste the text from register a, do `"ap`. To paste the text from register a ten times, do `10"ap`. By the way, the `p` actually technically stands for "put", not "paste", but I figure paste is a more conventional word.

The general syntax to get the content from a specific register is `"a`, where `a` is the register symbol.

## Calling Registers From Insert Mode

Everything you learn in this chapter can also be executed in insert mode. To get the text from register a, normally you do `"ap`. But if you are in insert mode, run `Ctrl-R a`. The syntax to call registers from insert mode is:

```
Ctrl-R a
```

Where `a` is the register symbol. Now that you know how to store and retrieve registers, let's dive in!


## The Unnamed Register

To get the text from the unnamed register, do `""p`. It stores the last text you yanked, changed, or deleted. If you do another yank, change, or delete, Vim will automatically replace the old text. The unnamed register is like a computer's standard copy / paste operation.

By default, `p` (or `P`) is connected to the unnamed register (from now on I will refer to the unnamed register with `p` instead of `""p`).

## The Numbered Registers

Numbered registers automatically fill themselves up in ascending order. There are 2 different numbered registers: the yanked register (`0`) and the numbered registers (`1-9`). Let's discuss the yanked register first.

### The Yanked Register

If you yank an entire line of text (`yy`), Vim actually saves that text in two registers:

1. The unnamed register (`p`).
2. The yanked register (`"0p`).

When you yank a different text, Vim will update both the yanked register and the unnamed register. Any other operations (like delete) will not be stored in register 0. This can be used to your advantage, because unless you do another yank, the yanked text will always be there, no matter how many changes and deletions you do.

For example, if you:
1. Yank a line (`yy`)
2. Delete a line (`dd`)
3. Delete another line (`dd`)

The yanked register will have the text from step one.

If you:
1. Yank a line (`yy`)
2. Delete a line (`dd`)
3. Yank another line (`yy`)

The yanked register will have the text from step three.

One last tip, while in insert mode, you can quickly paste the text you just yanked using `Ctrl-R 0`.

### The Non-zero Numbered Registers

When you change or delete a text that is at least one line long, that text will be stored in the numbered registers 1-9 sorted by the most recent.

For example, if you have these lines:

```
line three
line two
line one
```

With your cursor on "line three", delete them one by one with `dd`. Once all lines are deleted, register 1 should contain "line one" (most recent), register two "line two" (second most recent), and register three "line three" (oldest). To get the content from register one, do `"1p`.

As a side note, these numbered registers are automatically incremented when using the dot command. If your numbered register one (`"1`) contains "line one", register two (`"2`) "line two", and register three (`"3`) "line three", you can paste them sequentially with this trick:
- Do `"1P` to paste the content from the numbered register one ("1).
- Do `.` to paste the content from the numbered register two ("2).
- Do `.` to paste the content from the numbered register three ("3).

This trick works with any numbered register. If you started with `"5P`,  `.`  would do `"6P`, `.` again would do `"7P`, and so on.

Small deletions like a word deletion (`dw`) or word change (`cw`) do not get stored in the numbered registers. They are stored in the small delete register (`"-`), which I will discuss next.

## The Small Delete Register

Changes or deletions less than one line are not stored in the numbered registers 0-9, but in the small delete register (`"-`).

For example:
1. Delete a word (`diw`)
2. Delete a line (`dd`)
3. Delete a line (`dd`)

`"-p` gives you the deleted word from step one.

Another example:
1. I delete a word (`diw`)
2. I delete a line (`dd`)
3. I delete a word (`diw`)

`"-p` gives you the deleted word from step three. `"1p` gives you the deleted line from step two. Unfortunately, there is no way to retrieve the deleted word from step one because the small delete register only stores one item. However, if you want to preserve the text from step one, you can do it with the named registers.

## The Named Register

The named registers are Vim's most versatile register. It can store yanked, changed, and deleted texts into registers a-z. Unlike the previous 3 register types you've seen which automatically stores texts into registers, you have to explicitly tell Vim to use the named register, giving you full control.

To yank a word into register a, you can do it with `"ayiw`.
- `"a` tells Vim that the next action (delete / change / yank) will be stored in register a.
- `yiw` yanks the word.

To get the text from register a, run `"ap`. You can use all twenty-six alphabetical characters to store twenty-six different texts with named registers.

Sometimes you may want to add to your existing named register. In this case, you can append your text instead of starting all over. To do that, you can use the uppercase version of that register. For example, suppose you have the word "Hello " already stored in register a. If you want to add "world" into register a, you can find the text "world" and yank it using A register (`"Ayiw`).

## The Read-only Registers

Vim has three read-only registers: `.`, `:`, and `%`. They are pretty simple to use:

```
.    Stores the last inserted text
:    Stores the last executed command-line
%    Stores the name of current file
```

If the last text you wrote was "Hello Vim", running `".p` will print out the text "Hello Vim". If you want to get the name of current file, run `"%p`. If you run `:s/foo/bar/g` command, running `":p` will print out the literal text "s/foo/bar/g".

## The Alternate File Register

In Vim, `#` usually represents the alternate file. An alternative file is the last file you opened. To insert the name of the alternate file, you can use `"#p`.

## The Expression Register

Vim has an expression register, `"=`, to evaluate expressions.

To evaluate mathematical expressions `1 + 1`, run:

```
"=1+1<Enter>p
```

Here, you are telling Vim that you are using the expression register with `"=`. Your expression is (`1 + 1`). You need to type `p` to get the result. As mentioned earlier, you can also access the register from insert mode. To evaluate mathematical expression from insert mode, you can do:

```
Ctrl-R =1+1
```

You can also get the values from any register via the expression register when appended with `@`. If you wish to get the text from register a:

```
"=@a
```

Then press `<Enter>`, then `p`. Similarly, to get values from register a while in insert mode:

```
Ctrl-r =@a
```

Expression is a vast topic in Vim, so I will only cover the basics here. I will address expressions in more details in later Vimscript chapters.

## The Selection Registers

Don't you sometimes wish that you can copy a text from external programs and paste it locally in Vim, and vice versa? With Vim's selection registers, you can. Vim has two selection registers: `quotestar` (`"*`) and `quoteplus` (`"+`). You can use them to access copied text from external programs.

If you are on an external program (like Chrome browser) and you copy a block of text with `Ctrl-C` (or `Cmd-C`, depending on your OS), normally you wouldn't be able to use `p` to paste the text in Vim. However, both Vim's `"+` and `"*` are connected to your clipboard, so you can actually paste the text with  `"+p` or `"*p`. Conversely, if you yank a word from Vim with `"+yiw` or `"*yiw`, you can paste that text in the external program with `Ctrl-V` (or `Cmd-V`). Note that this only works if your Vim program comes with the `+clipboard` option (to check it, run `:version`).

You may wonder if `"*` and `"+` do the same thing, why does Vim have two different registers? Some machines use X11 window system. This system has 3 types of selections: primary, secondary, and clipboard. If your machine uses X11, Vim uses X11's *primary* selection with the `quotestar` (`"*`) register and X11's *clipboard* selection with the `quoteplus` (`"+`) register. This is only applicable if you have `+xterm_clipboard` option available in your Vim build. If your Vim doesn't have `xterm_clipboard`, it's not a big deal. It just means that both `quotestar` and `quoteplus` are interchangeable (mine doesn't either).

I find doing `=*p` or `=+p` to be cumbersome. To make Vim to paste copied text from the external program with just `p`, you can add this in your vimrc:

```
set clipboard=unnamed
 ```

Now when I copy a text from an external program, I can paste it with the unnamed register, `p`. I can also copy a text from Vim and paste it to an external program. If you have `+xterm_clipboard` on, you may want to use both `unnamed` and `unnamedplus` clipboard options.

## The Black Hole Register

Each time you delete or change a text, that text is stored in Vim register automatically. There will be times when you don't want to save anything into the register. How can you do that?

You can use the black hole register (`"_`). To delete a line and not have Vim store the deleted line into any register, use `"_dd`.

The black hole register is like the `/dev/null` of registers.

## The Last Search Pattern Register

To paste your last search (`/` or `?`), you can use the last search pattern register (`"/`). To paste the last search term, use `"/p`.

## Viewing the Registers

To view all your registers, use the `:register` command. To view only registers "a, "1, and "-, use `:register a 1 -`.

There is a plugin called [vim-peekaboo](https://github.com/junegunn/vim-peekaboo) that lets you to peek into the contents of the registers when you hit `"` or `@` in normal mode and `Ctrl-R` in insert mode. I find this plugin very useful because most times, I can't remember the content in my registers. Give it a try!

## Executing a Register

The named registers are not just for storing texts. They can also execute macros with `@`. I will go over macros in the next chapter.

Keep in mind since macros are stored inside Vim registers, you can accidentally overwrite the stored text with macros. If you store the text "Hello Vim" in register a and you later record a macro in the same register (`qa{macro-sequence}q`), that macro will overwrite your "Hello Vim" text stored earlier.

## Clearing a Register

Technically, there is no need to clear any register because the next text that you store under the same register name will overwrite it. However, you can quickly clear any named register by recording an empty macro. For example, if you run `qaq`, Vim will record an empty macro in the register a.

Another alternative is to run the command `:call setreg('a', 'hello register a')` where a is the register a and "hello register a" is the text that you want to store.

One more way to clear register is to set the content of "a register to an empty string with the expression `:let @a = ''`.

## Putting the Content of a Register

You can use the `:put` command to paste the content of any one register. For example, if you run `:put a`, Vim will print the content of register a below the current line. This behaves much like `"ap`, with the difference that the normal mode command `p` prints the register content after the cursor and the command `:put` prints the register content at newline.

Since `:put` is a command-line command, you can pass it an address. `:10put a` will paste text from register a to below line 10.

One cool trick to pass `:put` with the black hole register (`"_`). Since the black hole register does not store any text, `:put _` will insert a blank line instead. You can combine this with the global command to insert multiple blank lines. For example, to insert blank lines below all lines that contain the text "end", run `:g/end/put _`. You will learn about the global command later.

## Learning Registers the Smart Way

You made it to the end. Congratulations! If you are feeling overwhelmed by the sheer information, you are not alone. When I first started learning about Vim registers, there were way too much information to take at once.

I don't think you should memorize all the registers immediately. To become productive, you can start by using only these 3 registers:
1. The unnamed register (`""`).
2. The named registers (`"a-z`).
3. The numbered registers (`"0-9`).

Since the unnamed register defaults to `p` and `P`, you only have to learn two registers: the named registers and the numbered registers. Gradually learn more registers when you need them. Take your time.

The average human has a limited short-term memory capacity, about 5 - 7 items at once. That is why in my everyday editing, I only use about 5 -  7 named registers. There is no way I can remember all twenty-six in my head. I normally start with register a, then b, ascending the alphabetical order. Try it and experiment around to see what technique works best for you.

Vim registers are powerful. Used strategically, it can save you from typing countless repeating texts. Next, let's learn about macros.
