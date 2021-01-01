---
title: "Fold"
metaTitle: "Fold"
metaDescription: "Fold"
---

When you read a file, often there are many irrelevant text that hinders you from understanding what that file does. To hide this unnecessary information, you can use Vim fold.

In this chapter, you will learn how to use different folding methods.

## Manual Fold

Imagine that you are folding a sheet of paper to cover some text. The actual text does not go away, it is still there. Vim fold works the same way. It *folds* a range of text, hiding it from display without actually deleting it.

The fold operator is `z`. When you fold a paper, the fold looks like the letter "z" too.

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

Vim fold follows the grammar rule. You can pass the fold operator with a motion or text object. To fold an outer paragraph, run `zfap`. To fold to the end of a file, run `zfG`. To fold the texts between `{` and `}`, run `zfa{`.

You can fold from the visual mode. Highlight the area you want to fold (`v`, `V`, or `Ctrl-v`), then run `zf`.

A Vim operator is not complete without the command-line mode version. You can execute a fold from the command-line mode with the `:fold` command. To fold the current line and the line after it, run:

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

Vim's default `'shiftwidth'` value is 2. On the text above, there are two spaces between the start of the line and the text "Two" and "Two again". When Vim sees the number of spaces *and* that the `'shiftwidth'` value is 2, Vim considers that line to have an indent fold level of one.

Suppose this time you only one space between the start of the line and the text:

```
One
 Two
 Two again
```

Right now if you run `:set foldmethod=indent`, Vim does not fold the indented line because there isn't sufficient space on each line. However, if you change the `'shiftwidth'` to 1:

```
:set shiftwidth=1
```

The text is now foldable. Restore the shiftwidth back to two and the spaces between the texts to two again. In addition, add:

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

You can have nested folds. The text "Two" and "Two again" have fold level of one. The text "Three" and "Three again" have fold level of two. If you have a foldable text with a higher fold level within a foldable text, you can have multiple fold layers.

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

By default, Vim uses `{{{` and `}}}` as indicators. If you want to change the indicator to another texts, like "foo1" and "foo2":

```
:set foldmarker=foo1,foo2
```

If you have the text:

```
hello

foo1
world
vim
foo2
```

Now Vim uses `foo1` and `foo2` as the new folding markers. As a side note, an indicator must be a literal string and cannot be a regex.

## Syntax Fold

Vim has a syntax system to customize the text syntax (highlight, weight, color, etc). This chapter won't discuss how the syntax system works, but you can use this to indicate which text to fold. To use a syntax fold, run:

```
:set foldmethod=syntax
```

Suppose you have this text and you want to fold everything between the square brackets:

```
[
  "one",
  "two",
  "three"
]
```

You need to define the proper syntax definition to capture the characters between the square brackets:

```
:syn region testFold start="\\[" end="\\]" transparent fold
```

You should see:

```
+-- 5 lines: [ -----
```

Here is the breakdown:
- `:syn` is the syntax command.
- `region` constructs a syntax region that can span several lines. For more info, check out `:h syntax.txt`
- `start="\\[" end="\\]"` defines the starting and ending of a region. You have to escape (`\\`) the square-brackets because they are considered special characters.
- `transparent` to prevent highlights.
- `fold` increases the fold level when the syntax matches the starting and ending characters.

## Expression Fold

Expression folding allows you to define an expression to match for a fold. After you define the fold expressions, Vim scans each line for the value of `'foldexpr'`. This is the variable that you have to configure to return the appropriate value. If the `'foldexpr'` returns 0, then the line is not folded. If it returns 1, then that line has a fold level of 1. If it returns 2, then that line has a fold level of 2. There are more values other than integers, but I won't go over them. If you are curious, check out `:h fold-expr`.

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

The expression above looks intimidating. Let's break it down:

- `:set foldexpr` sets up the `'foldexpr'` option to accept a custom expression.
- `getline()` is a Vimscript function that returns the content of any given line. If you run `:echo getline(5)`, it will return the content of line 5.
- `v:lnum` is Vim's special variable for the `'foldexpr'` expression. Vim scans each line and at that moment stores each line's number in `v:lnum` variable.
- `[0]` in the context of `getline(v:lnum)[0]` is the first character of each line. When Vim scans a line, `getline(v:lnum)` returns the content of each line. `getline(v:lnum)[0]` returns the first character of each line. On the first line of our list, "donut", `getline(v:lnum)[0]` returns "d". On the second line of our list, "pancake", `getline(v:lnum)[0]` returns "p".
- `==\\"s\\"` is the second half of an equality expression. It checks if the expression you just evaluated is equal to "s". If it is true, it returns 1. If it is false, it returns 0. In Vim, 1 is truthy and 0 is falsy. So on the lines that start with an "s", it returns 1. Recall at the beginning of this section, if a `'foldexpr'` has a value of 1, then it has a fold level of 1.

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

Your folds are restored. However, you have to manually run `mkview` and `loadview`. I know that one of these days, I will forget to run `mkview` before closing the file and I will lose all the folds. Wouldn't it be nice if you can automate this?

Definitely! To automatically run `mkview` when you close a `.txt` file and run `loadview` when you open a `.txt` file, add this in your vimrc:

```
autocmd BufWinLeave *.txt mkview
autocmd BufWinEnter *.txt silent loadview
```

You have seen the `autocommand` from the previous chapter. It is used to execute a command on an event trigger. There are two events to accomplish this:

- `BufWinLeave` for when you remove a buffer from a window.
- `BufWinEnter` for when you load a buffer in a window.

Now after you fold inside a `.txt` file and exit Vim, the next time you open that file, your fold information will be restored.

By default, Vim saves the fold information when running `mkview` inside `~/.vim/view` for the Unix system. For more information, check out `:h 'viewdir'`.

## Learn Fold The Smart Way

When I first started Vim, I would skip learning Vim fold because I didn't think it was useful. However, the longer I code, the more useful I find folding is. Strategically placed folds can give you a better overview of the text structure, like a book's *table of content*.

When you learn fold, start with the manual fold because that can be used on-the-go. Then gradually learn different tricks to do indent and marker folds. Finally, learn how to do syntax and expression folds. You can even use the latter two to write your own Vim plugins.

Now that you know how to do fold, let's learn something different: version control with git.
