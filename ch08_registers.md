# Registers

Learning Vim registers is like learning algebra for the first time. You don't think you need them until you learn them.

You've probably used Vim registers when you yanked or deleted a text then pasted it with `p` or `P`. However, did you know that Vim has 10 different types of registers? 

In this chapter, I will go over all Vim register types and how to use them efficiently.

# The Ten Register Types

Here are the 10 register types Vim has:

1. The unnamed register (`""`).
2. The numbered registers (`"0-9`).
3. The small delete register (`"-`).
4. The named registers (`"a-z`).
5. The read-only registers (`":`, `".`,and `"%`).
6. The alternate buffer register (`"#`).
7. The expression register (`"=`).
8. The selection registers (`"*` and `"+`).
9. The black hole register (`"_`).
10. The last search pattern register (`"/`).


# Register Operators

Here are some operators that store values to registers:
```
y    Yank (copy)
c    Delete text and start insert mode
d    Delete text
```

There are more operators (like `s` or `x`), but these are the common ones. The rule of thumb is, if an operator removes texts, it probably saves the texts to registers.

To put (paste) texts from registers, you can use:

```
p    Put the text after the cursor
P    Put the text before the cursor
```

Both `p` and `P` accept a count and a register symbol as arguments. For example, to put the recently yanked text ten times, do `10p`. To put the text from register "a", do `"ap`. To put the text from register "a" ten times, do `10"ap`.

The general syntax to get the content from a specific register is `"x`, where `x` is the register symbol.


# Calling Registers from Insert Mode

Everything you learn in this chapter can also be executed in insert mode. To get the text from register "a", normally you do `"ap`. But if you are in insert mode, run `Ctrl-r a`. The syntax to call registers from insert mode is:
```
Ctrl-r x
```
Where `x` is the register symbol. Now that you know how to store and retrieve registers, let's dive in!


#  The Unnamed Register (`""`)

To get the text from the unnamed register, do `""p`. It stores the last text you yanked, changed, or deleted. If you do another yank, change, or deletion, Vim will automatically replace the text. The unnamed register is like a computer's standard copy / paste operation.

By default, `p` (or `P`) is connected to the unnamed register (from now on I will refer to the unnamed register with `p` instead of `""p`).

# The Numbered Registers (`"0-9`)

Numbered registers automatically fill themselves up in ascending order. There are 2 different numbered registers: the yanked register (`0`) and the numbered registers (`1-9`). Let's discuss the yanked register first.

## The Yanked Register (`"0`)

If you yank an entire line of text (`yy`), Vim actually saves that text in two registers:

1. The unnamed register (`p`).
2. The yanked register (`"0p`).

When you yank a different text, Vim will replace both the yanked register and the unnamed register. Any other operations will not be stored in register 0. This can be used to your advantage, because unless you do another yank, the yanked text will always be there, no matter how many changes and deletions you do.

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

One last tip, while in insert mode, you can quickly paste the text you just yanked using `Ctrl-r 0`. 

## The Numbered Registers (`"1-9`)

When you change or delete a text that is at least one line long, that text will be stored in the numbered registers 1-9 sorted by the most recent.

For example, if you have these lines:
```
line three
line two
line one
```

With your cursor on "line three", delete them one by one with `dd`. Once all lines are deleted, register 1 should contain "line one" (the most recent text), register two "line two" (the second most recent text), and register three "line three" (the latest deleted text). To get the content from register one, "line one", do `"1p`.


The numbered registers are automatically incremented when using the dot command. If your numbered register one (`"1`) contains "line one", register two (`"2`) "line two", and register three (`"3`) "line three", you can paste them sequentially with this trick:
- Do `"1P` to paste the content from the numbered register one.
- Do `.` to paste the content from the numbered register two (`"2`).
- Do `.` to paste the content from the numbered register three (`"3`).

During each sequential dot command call, Vim automatically increments the numbered registers. This trick works with any numbered register. If you started with `"5P`,  `.`  would do `"6P`, `.` again would do `"7P`, and so on. 

Small deletions like a word deletion (`dw`) or word change (`cw`) do not get stored in the numbered registers. They are stored in the small delete register (`"-`), which I will discuss next.

# The Small Delete Register (`"-`)

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

`"-p` gives you the deleted word from step three. Likewise, `"1p` gives you the deleted line from step two. Unfortunately, there is no way to retrieve the deleted word from step one because the small delete register only stores one item. However, if you want to preserve the text from step one, you can do it with the named registers.

# The Named Register (`"a-z`)

The named registers are Vim's most versatile register. It can store yanked, changed, and deleted texts into registers a-z. Unlike the previous 3 register types you've seen which automatically stores texts into registers, you have to explicitly tell Vim to use the named register, giving you full control.

To yank a word into register "a", you can do it with `"ayiw`.
- `"a` tells vim that the next action (delete / change / yank) will be stored in register "a".
- `yiw` yanks the word.

To get the text from register "a", run `"ap`. You can use all twenty-six alphabetical characters to store twenty-six different texts with named registers.

Sometimes you may want to add to your existing named register. In this case, you can append your text instead of starting all over. To do that, you can use the uppercase version of that register. For example, suppose you have the word "Hello " already stored in register "a". If you want to add "world" into register "a", you can find the text "world" and yank it using "A" register (`"Ayiw`).

# The Read-Only Registers (`":`, `".`, `"%`)

Vim has three read-only registers: `.`, `:`, and `%`. They are pretty simple to use:
```
.    Stores the last inserted text
:    Stores the last executed command-line
%    Stores the name of current file
```

If you write "Hello Vim", running `".p` will print out the text "Hello Vim". If you want to get the name of current file, run `"%p`. If you run `:s/foo/bar/g` command, running `":p` will print out the literal text "s/foo/bar/g".

# The Alternate File Register (`"#`)

In Vim, `#` usually represents the alternate file. An alternative file is the last file you opened. To insert the name of the alternate file, you can use `"#p`.

# The Expression Register (`"=`)

Vim has an expression register, `"=`, to evaluate expressions. Expression is a vast topic in Vim, so I will only cover the basics here. I will address expressions in greater details in the later chapters.

You can evaluate mathematical expressions `1 + 1` with:

```
"=1+1<Enter>p
```

Here, you are telling Vim that you are using the expression register with `"=`. Your expression is (`1 + 1`). Then you need to type `p` to get the result. As mentioned earlier, you can also access the register from insert mode. To evaluate mathematical expression from insert mode, you can do:

```
Ctrl-r =1+1
```

You can get the values from any register using the expression register with `@`. If you wish to get the text from register "a":

```
"=@a
```
Then press `<enter>`, then `p`. Similarly, to get values from register "a" while in insert mode:

```
Ctrl-r =@a
```

You can also evaluate Vim scripts with the expression register. If you define a variable `i` by running `:let i = 1`, you can get it with `"=i`, press return, then `p`. To get it while in insert mode, run `Ctrl-r=i`.

Suppose you have a function: 
```
function! HelloFunc()
	return "Hello Vim Script!"
endfunction
```

You can retrieve its value by calling it. To call it from normal mode, you can do: `"=HelloFunc()`, press return, then `p`. From insert mode `Ctrl-r =HelloFunc()`.

# The Selection registers (`"*`, `"+`)

Don't you sometimes wish that you can copy a text from external programs and paste it locally in Vim, and vice versa? With Vim's selection registers, you can. Vim has two selection registers: `quotestar` (`"*`) and `quoteplus` (`"+`). You can use them to access copied text from external programs.

If you are on an external program (like Chrome browser) and you copy a block of text with `Ctrl-c` (or `Cmd-c`, depending on your OS), normally you wouldn't be able to use `p` to paste the text in Vim. However, both Vim's `"+` and `"*` are connected to your clipboard, so you can actually paste the text with  `"+p` or `"*p`. Conversely, if you yank a word from Vim with `"+yiw` or `"*yiw`, you can paste that text in the external program with `Ctrl-v` (or `Cmd-v`). Note that this only works if your Vim program comes with `+clipboard` option. Check it out by running `vim --version` from the terminal. If you see a `-clipboard`, you have to install a Vim build with clipboard support on.

You may wonder if `"*` and `"+` do the same thing, why does Vim have two different registers? Some machines use X11 window system. This system has 3 types of selections: primary, secondary, and clipboard. If your machine uses X11, Vim uses X11's *primary* selection with the `quotestar` (`"*`) register and X11's *clipboard* selection with the `quoteplus` (`"+`) register. This is only applicable if you have `xterm_clipboard` option available in your Vim build (`+xterm_clipboard` in `vim --version`). If your Vim doesn't have `xterm_clipboard`, it's not a big deal. It just means that both `quotestar` and `quoteplus` are interchangeable.

I find doing `=*p` or `=+p` to be cumbersome. To make Vim to paste copied text from the external program with just `p`, you can add this in your `vimrc`:

```
set clipboard=unnamed
 ```

Now when I copy a text from an external program, I can paste it with the unnamed register, `p`. I can also copy a text from Vim and paste it to an external program with `Ctrl-v`. If you have `+xterm_clipboard` on, you may want to use both `unnamed` and `unnamedplus` clipboard options.

# The Black Hole Register (`"_`)

Everytime you delete or change a text, that text is stored in Vim register automatically. Sometimes you just don't want to save anything into the register. How can you do that?

You can use the black hole register (`"_`). To delete a line and not have Vim store the deleted line into any register, use `"_dd`. It’s the `/dev/null` of registers. 

# The Last Search Pattern Register (`"/`)

To paste your last search (`/` or `?`) query, you can use the last search pattern register (`"/`). To paste the last search term, use `"/p`.


# Viewing the Registers

To view all your registers, use the `:register` command. To view only registers "a", "1", and "-", use `:register a 1 -`.

There is a plugin called [vim-peekaboo](https://github.com/junegunn/vim-peekaboo) that lets you to peek into the contents of the registers when you hit `"` or `@` in normal mode and `Ctrl-r` in insert mode. I find this plugin very useful because most times, I can't remember the content in my registers. Give it a try!

# Executing a Register

The named registers are not just for storing texts. They can also be used to execute macros with `@`. I will go over macros in the next chapter. If you store the text "Hello Vim" in register "a", and you later record a macro in the same register (`qa{macro-commands}q`), that macro will overwrite your "Hello Vim" text stored earlier (you can execute the macro stored in register "a" with `@a`).

# Clearing a Register

Technically, there is no need to clear any register because the next register you store under the same name will overwrite it. However, you can quickly clear any named register by recording an empty macro. For example, if you run `qaq`, Vim will record an empty macro in the register "a". Another alternative is to run the command `:call setreg('a', '')` where "a" is the register "a". One more way to clear register is to set the content of "a" register to an empty string with the expression `:let @a = ''`.

# Putting the Content of a Register

You can use the `:put` command to paste the content of any one register. For example, if you run `:put a`, Vim will print the content of register "a". This behaves much like `"ap`, with the difference that the normal mode command `p` prints the register content after the cursor and the command `:put` prints the register content at newline.

# Learning Registers the Smart Way

You made it to the end. Congratulations! That was a lot to take. If you are feeling overwhelmed by the sheer information, you are not alone. I was too, when I first started learning about Vim registers.

I don't think you should memorize everything right away. To become productive, you can start by using only these 3 registers: 
1. The unnamed register (`""`).
2. The named registers (`"a-z`).
3. The numbered registers (`"0-9`).

Since the unnamed register defaults to `p` or `P`, you only have to learn two registers: the named registers and the numbered registers. Gradually learn more when you need it. Take your time. 

The average human has a limited short-term memory capacity, about seven items at once. That is why in my everyday editing, I only use about three to seven named registers. There is no way I can remember all twenty-six in my head. I normally start with register "a", then "b", ascending the alphabetical order. Try it and experiment around to see what technique works best for you.

Vim registers are powerful. Used strategically, it can save you from typing countless repeated texts. But now, it's time to learn about macros.
