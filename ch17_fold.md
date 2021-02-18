# Ch17. Fold

When you read a file, often there are many irrelevant texts that hinder you from understanding what that file does. To hide the unnecessary noise, use Vim fold.

In this chapter, you will learn different ways to fold a file.

## Manual Fold

Imagine that you are folding a sheet of paper to cover some text. The actual text does not go away, it is still there. Vim fold works the same way. It folds a range of text, hiding it from display without actually deleting it.

The fold operator is `z` (when a paper is folded, it is shaped like the letter z).

Suppose you have this text:

```
Fold me
Hold me
```

Type `zfj`. Vim folds both lines into one. You should see something like this:

```
+-- 2 lines: Fold me -----
```

Here is the breakdown:
- `zf` `zf` is the fold operator.
- `j` is the motion for the fold operator.

You can open a folded text with `zo`. To close the fold, use `zc`.

Fold is an operator, so it follows the grammar rule (`verb + noun`). You can pass the fold operator with a motion or text object. To fold an inner paragraph, run `zfip`. To fold to the end of a file, run `zfG`. To fold the texts between `{` and `}`, run `zfa{`.

You can fold from the visual mode. Highlight the area you want to fold (`v`, `V`, or `Ctrl-v`), then run `zf`.

You can execute a fold from the command-line mode with the `:fold` command. To fold the current line and the line after it, run:

```
:,+1fold
```

`,+1` is the range. If you don't pass parameters to the range, it defaults to the current line. `+1` is the range indicator for the next line. To fold the lines 5 to 10, run `:5,10fold`. To fold from the current line to the end of the line, run `:,$fold`.

There are many other fold and unfold commands. I find them too many to remember when starting out. The most useful ones are:
- `zR` to open all folds.
- `zM` to close all folds.
- `za` toggle a fold.

You can run `zR` and `zM` on any line, but `za` only works when you are on a folded / unfolded line. To learn more folding commands, check out `:h fold-commands`.

## Different Fold Methods

The section above covers Vim's manual fold. There are six different folding methods in Vim:
1. Manual
2. Indent
3. Expression
4. Syntax
5. Diff
6. Marker

To see which folding method you are currently using, run `:set foldmethod?`. By default, Vim uses the `manual` method.

In the rest of the chapter, you will learn the other five folding methods. Let's get started with the indent fold.

## Indent Fold

To use an indent fold, change the `'foldmethod'` to indent:

```
:set foldmethod=indent
```

Suppose that you have the text:

```
One
  Two
  Two again
```

If you run `:set foldmethod=indent`, you will see:

```
One
+-- 2 lines: Two -----
```

With indent fold, Vim looks at how many spaces each line has at the beginning and compares it with the `'shiftwidth'` option to determine its foldability. `'shiftwidth'` returns the number of spaces required for each step of the indent. If you run:

```
:set shiftwidth?
```

Vim's default `'shiftwidth'` value is 2. On the text above, there are two spaces between the start of the line and the text "Two" and "Two again". When Vim sees the number of spaces and that the `'shiftwidth'` value is 2, Vim considers that line to have an indent fold level of one.

Suppose this time you only one space between the start of the line and the text:

```
One
 Two
 Two again
```

Right now if you run `:set foldmethod=indent`, Vim does not fold the indented line because there isn't sufficient space on each line. One space is not considered an indentation. However, if you change the `'shiftwidth'` to 1:

```
:set shiftwidth=1
```

The text is now foldable. It is now considered an indentation. 

Restore the `shiftwidth` back to 2 and the spaces between the texts to two again. In addition, add two additional texts:

```
One
  Two
  Two again
    Three
    Three again
```

Run fold (`zM`), you will see:

```
One
+-- 4 lines: Two -----
```

Unfold the folded lines (`zR`), then put your cursor on "Three" and toggle the text's folding state (`za`):

```
One
  Two
  Two again
+-- 2 lines: Three -----
```

What's this? A fold within a fold?

Nested folds are valid. The text "Two" and "Two again" have fold level of one. The text "Three" and "Three again" have fold level of two. If you have a foldable text with a higher fold level within a foldable text, you will have multiple fold layers.

## Marker Fold

To use a marker fold, run:

```
:set foldmethod=marker
```

Suppose you have the text:

```
Hello

{{{
world
vim
}}}
```

Run `zM`, you will see:

```
hello

+-- 4 lines: -----
```

Vim sees `{{{` and `}}}` as fold indicators and folds the texts between them. With the marker fold, Vim looks for special markers, defined by `'foldmarker'` option, to mark folding areas. To see what markers Vim uses, run:

```
:set foldmarker?
```

By default, Vim uses `{{{` and `}}}` as indicators. If you want to change the indicator to another texts, like "coffee1" and "coffee2":

```
:set foldmarker=coffee1,coffee2
```

If you have the text:

```
hello

coffee1
world
vim
coffee2
```

Now Vim uses `coffee1` and `coffee2` as the new folding markers. As a side note, an indicator must be a literal string and cannot be a regex.

## Syntax Fold

Syntax fold is determined by syntax language highlighting. If you use a language syntax plugin like [vim-polyglot](https://github.com/sheerun/vim-polyglot), the syntax fold will work right out of the box. Just change the fold method to syntax:

```
:set foldmethod=syntax
```

Let's assume you are editing a JavaScript file and you have vim-polyglot installed. If you have an array like the following:

```
const nums = [
  one,
  two,
  three,
  four
]
```

It will be folded with a syntax fold. When you define a syntax highlighting for a particular language (typically inside the `syntax/` directory), you can add a `fold` attribute to make it foldable. Below is a snippet from vim-polyglot JavaScript syntax file. Notice the `fold` keyword at the end.

```
syntax region  jsBracket                      matchgroup=jsBrackets            start=/\[/ end=/\]/ contains=@jsExpression,jsSpreadExpression extend fold
```

This guide won't cover the `syntax` feature. If you're curious, check out `:h syntax.txt`.

## Expression Fold

Expression fold allows you to define an expression to match for a fold. After you define the fold expressions, Vim scans each line for the value of `'foldexpr'`. This is the variable that you have to configure to return the appropriate value. If the `'foldexpr'` returns 0, then the line is not folded. If it returns 1, then that line has a fold level of 1. If it returns 2, then that line has a fold level of 2. There are more values other than integers, but I won't go over them. If you are curious, check out `:h fold-expr`.

First, let's change the foldmethod:

```
:set foldmethod=expr
```

Suppose you have a list of breakfast foods and you want to fold all breakfast items starting with "p":

```
donut
pancake
pop-tarts
protein bar
salmon
scrambled eggs
```

Next, change the `foldexpr` to capture the expressions starting with "p":

```
:set foldexpr=getline(v:lnum)[0]==\\"p\\"
```

The expression above looks complicated. Let's break it down:
- `:set foldexpr` sets up the `'foldexpr'` option to accept a custom expression.
- `getline()` is a Vimscript function that returns the content of any given line. If you run `:echo getline(5)`, it will return the content of line 5.
- `v:lnum` is Vim's special variable for the `'foldexpr'` expression. Vim scans each line and at that moment stores each line's number in `v:lnum` variable. On line 5, `v:lnum` has value of 5. On line 10, `v:lnum` has value of 10.
- `[0]` in the context of `getline(v:lnum)[0]` is the first character of each line. When Vim scans a line, `getline(v:lnum)` returns the content of each line. `getline(v:lnum)[0]` returns the first character of each line. On the first line of our list, "donut", `getline(v:lnum)[0]` returns "d". On the second line of our list, "pancake", `getline(v:lnum)[0]` returns "p".
- `==\\"p\\"` is the second half of the equality expression. It checks if the expression you just evaluated is equal to "p". If it is true, it returns 1. If it is false, it returns 0. In Vim, 1 is truthy and 0 is falsy. So on the lines that start with an "p", it returns 1. Recall if a `'foldexpr'` has a value of 1, then it has a fold level of 1.

After running this expression, you should see:

```
donut
+-- 3 lines: pancake -----
salmon
scrambled eggs
```

## Diff Fold

Vim can do a diff procedure to compare two or more files.

If you have `file1.txt`:

```
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
```

And `file2.txt`:

```
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
emacs is ok
```

Run `vimdiff file1.txt file2.txt`:

```
+-- 3 lines: vim is awesome -----
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
[vim is awesome] / [emacs is ok]
```

Vim automatically folds some of the identical lines. When you are running the `vimdiff` command, Vim automatically uses `foldmethod=diff`. If you run `:set foldmethod?`, it will return `diff`.

## Persisting Fold

You loses all fold information when you close the Vim session. If you have this file, `count.txt`:

```
one
two
three
four
five
```

Then do a manual fold from line "three" down (`:3,$fold`):

```
one
two
+-- 3 lines: three ---
```

When you exit Vim and reopen `count.txt`, the folds are no longer there!

To preserve the folds, after folding, run:

```
:mkview
```

Then when you open up `count.txt`, run:

```
:loadview
```

Your folds are restored. However, you have to manually run `mkview` and `loadview`. I know that one of these days, I will forget to run `mkview` before closing the file and I will lose all the folds. How can we automate this process?

To automatically run `mkview` when you close a `.txt` file and run `loadview` when you open a `.txt` file, add this in your vimrc:

```
autocmd BufWinLeave *.txt mkview
autocmd BufWinEnter *.txt silent loadview
```

Recall that `autocmd` is used to execute a command on an event trigger. The two events here are:
- `BufWinLeave` for when you remove a buffer from a window.
- `BufWinEnter` for when you load a buffer in a window.

Now after you fold inside a `.txt` file and exit Vim, the next time you open that file, your fold information will be restored.

By default, Vim saves the fold information when running `mkview` inside `~/.vim/view` for the Unix system. For more information, check out `:h 'viewdir'`.

## Learn Fold The Smart Way

When I first started Vim, I neglected ot learn fold because I didn't think it was useful. However, the longer I code, the more useful I find folding is. Strategically placed folds can give you a better overview of the text structure, like a book's table of content.

When you learn fold, start with the manual fold because that can be used on-the-go. Then gradually learn different tricks to do indent and marker folds. Finally, learn how to do syntax and expression folds. You can even use the latter two to write your own Vim plugins.
