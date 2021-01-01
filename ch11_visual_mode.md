---
title: "Visual Mode"
metaTitle: "Visual Mode"
metaDescription: "Mastering the visual mode."
---

With visual editors (like LibreOffice Writer, Microsoft Word) you probably know that you can highlight a block of text and apply changes to it. Vim can too, with visual mode. Vim has three different visual modes to use. In this chapter, you will learn how to use each visual mode to manipulate blocks of texts efficiently.

## The Three Types Of Visual Modes
The three modes are:

```
v         Character-wise visual mode
V         Line-wise visual mode
Ctrl-v    Block-wise visual mode
```

If you have the text:
```
one
two
three
```

Character-wise visual mode is used to select individual characters. Press `v` on the first character on the first line. Then go down to the next line with `j`. It highlights all texts from "one" up to your cursor location. Now if you press `gU`, Vim uppercases the highlighted characters.

Line-wise visual mode works with line units. Press `V` and watch Vim selects the entire line your cursor is on. Just like character-wise visual mode, if you run `gU`, Vim uppercases the highlighted characters.

Block-wise visual mode works with rows and columns. It gives you more freedom to move around than the other two modes. Press `Ctrl-v`. Vim highlights the character under the cursor just like character-wise visual mode, except instead of highlighting each character until the end of the line before going to the next line, it can go to the next line without highlighting the entire character on the current line. Try moving around with `h/j/k/l` and watch the cursor movements.

On the bottom left of your Vim window, you will see either `-- VISUAL --`, `-- VISUAL LINE --`, or `-- VISUAL BLOCK --` displayed to indicate which visual mode you are in.

While you are inside a visual mode, you can switch to another visual mode by pressing either `v`, `V`, or `Ctrl-v`. For example, if you are in line-wise visual mode and you want to switch to block-wise visual mode, run `Ctrl-v`. Try it!

There are three ways to exit the visual mode: `esc`, `Ctrl-c`, and the same key as your current visual mode.

What the latter one means is if you are currently in the line-wise visual mode (`V`), you can exit it by pressing `V` again. If you are in the character-wise visual mode, you can exit it by pressing `v`. If you are in the block-wise visual mode, press `Ctrl-v`.

There is actually one more way to enter the visual mode:
```
gv    Go to the previous visual mode
```

It will start the same visual mode on the same highlighted text block as you did last time.

## Visual Mode Navigation

While in a visual mode, you can expand the highlighted text block with Vim motions.

Let's use the same text you used earlier:

```
one
two
three
```

This time let's start from the line "two". Press `v` to go to the character-wise visual mode:

```
one
[t]wo
three
```

Press `j` and Vim will highlight all the text from the line "two" down to the first character of the line "three".

```
one
[two
t]hree
```

Suppose you just realized that you also need to highlight the line "one" too, so you press `k`. To your dismay, it now excludes "three". Pressing `k` actually reduces the highlight, not expands it.

```
one
[t]wo
three
```

Is there a way to freely expand visual selection to go to any direction you want?

The answer is yes.  Let's back up a little bit to where you have the line "two" and "three" highlighted.

```
one
[two
t]hree    <-- cursor
```

Visual highlight follows the cursor movement. If you want to expand it upward to line "one", you need to move the cursor up when the cursor is on the letter "two", not "three". Right now your cursor is on the line "three". To move it, toggle the cursor location with either `o` or `O`.

```
one
[two     <-- cursor
t]hree
```

Now when you press `k`, it no longer reduces the selection, but expands it upward.

```
[one
two
t]hree
```

With `o` or `O` in visual mode, the cursor jumps from the beginning to the end of the highlighted block, keeping the block highlighted while letting you expand the highlighted block.

## Visual Mode Grammar

Visual mode is one of Vim's modes. Being a mode means that the same key may work differently than in another mode. Luckily, visual mode shares many common keys with normal mode.

For example, if you have the text:

```
one
two
three
```

Highlight the lines "one" and "two" with the line-wise visual mode (`V`):
```
[one
two]
three
```

Pressing `d` will delete the selection, similar to normal mode. Notice the grammar rule from normal mode, verb + noun, does not apply. The same verb is still there (`d`), but there is no noun in visual mode. The grammar rule in visual mode is noun + verb, where noun is the highlighted text. Select the text block first, then operate.

In normal mode, there are some commands that do not require a motion, like `x` to delete a single character under the cursor and `rx` to replace the character under the cursor with "x". In visual mode, these commands are now being applied to the entire highlighted text instead of a single character. Back at the highlighted text:
```
[one
two]
three
```

Running `x` deletes all highlighted texts.

You can use this behavior to quickly create a header in markdown text. Suppose you have a text in a markdown file:
```
Chapter One
```

You need to quickly turn this header into a header. First you copy the text with `yy`, then paste it with `p`:
```
Chapter One
Chapter One
```

Now go to the second line, select it with line-wise visual mode:
```
Chapter One
[Chapter One]
```

In markdown you can create a header by adding  a series of `=` below a text, so you will replace the entire highlighted text by running `r=`:

```
Chapter One
===========
```

To learn more about operators in visual mode, check out `:h visual-operators`.


## Visual Mode And Ex Commands

You can selectively apply Ex commands on a highlighted text block. If you have these expressions:

```
const one = "one";
const two = "two";
const three = "three";
```

You need to substitute only the first two lines of "const" with "let". Highlight the first two lines with *any* visual mode and run the substitute command `:s/const/let/g`:
```
let one = "one";
let two = "two";
const three = "three";
```
Notice I said you can do this with *any* visual mode. You do not have to highlight the entire line to run Ex command on that line. As long as you select at least a character on each line, the Ex command will be applied.

## Editing Across Multiple Lines

You can edit text across multiple lines in Vim using the block-wise visual mode. If you need to add a semicolon at the end of each line:

```
const one = "one"
const two = "two"
const three = "three"
```

With your cursor on the first line:
- Run block-wise visual mode and go down two lines (`Ctrl-v jj`).
- Highlight to the end of the line (`$`).
- Append (`A`) then type ";".
- Exit visual mode (`esc`).

You should see the appended ";" on each line. By the way, while in block-wise visual mode, to enter the insert mode, you can use either `A` to enter the text after the cursor or `I` to enter the text before the cursor. Do not confuse them with `A` and `I` from normal mode.

Alternatively, you can also use the `:normal` command:

- Highlight all 3 lines (`vjj`).
- Type `:normal! A;`.

Remember, `:normal` command executes normal mode commands. You can instruct it to run `A;` to append text ";" at the end of the line.

## Incrementing Numbers

Vim has `Ctrl-x` and `Ctrl-a` commands to decrement and increment numbers. When used with visual mode, you can increment numbers across multiple lines.

If you have these HTML elements:
```
<div id="app-1"></div>
<div id="app-1"></div>
<div id="app-1"></div>
<div id="app-1"></div>
<div id="app-1"></div>
```

It is a bad practice to have several ids having the same name, so let's increment them to make them unique:
- Move your cursor to the *second* "1".
- Start block-wise visual mode and go down 3 lines (`Ctrl-v 3j`). This highlights the remaining  "1"s.
- Run `g Ctrl-a`.

You should see this result:
```
<div id="app-1"></div>
<div id="app-2"></div>
<div id="app-3"></div>
<div id="app-4"></div>
<div id="app-5"></div>
```

`g Ctrl-a` increments numbers on multiple lines. `Ctrl-x/Ctrl-a` can increment letters too. If you run:

```
:set nrformats+=alpha
```

The `nrformats` option instructs Vim which bases are considered as "numbers" for `Ctrl-a` and `Ctrl-x` to increment and decrement. By adding `alpha`, an alphabetical character is now considered as a number. If you have the following HTML elements:
```
<div id="app-a"></div>
<div id="app-a"></div>
<div id="app-a"></div>
<div id="app-a"></div>
<div id="app-a"></div>
```

Put your cursor on the second "app-a". Use the same technique as above (`Ctrl-v 3j` then `g Ctrl-a`) to increment the ids.
```
<div id="app-a"></div>
<div id="app-b"></div>
<div id="app-c"></div>
<div id="app-d"></div>
<div id="app-e"></div>
```
## Selecting The Last Visual Mode Area

You learned that `gv` can quickly highlight the last visual mode highlight. You can also go to the location of the start and the end of the last visual mode with these two special marks:

```
`<    Go to the last place of the previous visual mode highlight
`>    Go to the first place of the previous visual mode highlight
```

I want you to observe something. Earlier, I mentioned that you can selectively execute Ex commands on a highlighted text, like `:s/const/let/g`. When you did that, you should see this:
```
:`<,`>s/const/let/g
```

You were actually executing `s/const/let/g` command using marks as range. You can always edit these marks anytime you wish. If instead you needed to substitute from the start of the highlighted text to the end of the file, you just change the command line to:
```
:`<,$s/const/let/g
```

## Entering Visual Mode From Insert Mode

You can also enter visual mode from the insert mode. To go to character-wise visual mode while you are in insert mode:

```
Ctrl-o v
```

Recall that running `Ctrl-o` while in the insert mode lets you to execute a normal mode command. While in this normal-mode-command-pending mode, run `v` to enter character-wise visual mode. Notice that on the bottom left of the screen, it says `--(insert) VISUAL--`. This trick works with any visual mode operator: `v`, `V`, and `Ctrl-v`.

## Select Mode

Vim has a mode similar to visual mode called the *select mode*. Like visual mode, it also has three different modes:
```
gh         Character-wise select mode
gH         Line-wise select mode
gCtrl-h    Block-wise select mode
```

Select mode emulates a regular editor's text highlighting behavior closer than Vim's visual mode does.

In a regular editor, after you highlight a text block and type a letter, say the letter "y", it will delete the highlighted text and insert the letter "y".

If you highlight a line of text with line-wise select mode (`gH`) and type "y", it will delete the highlighted text and insert the letter "y", much like the regular text editor.

Contrast this behavior with visual mode: if you  highlight a line of text with line-wise visual mode (`V`) and type "y", the highlighted text will not be deleted and replaced by the literal letter "y". It will only be yanked and stored in the yanked register `"0`.

I personally never used select mode, but it's good to know that it exists.

## Learn Visual Mode The Smart Way

The visual mode is Vim's representation of the text highlighting procedure.

If you find yourself using visual mode operation far more often than normal mode operations, be careful. I think this is an anti-pattern. It takes more keystrokes to run a visual mode operation than its normal mode counterpart. If you need to delete an inner word, why use four keystrokes, `viwd` (visually highlight an inner word then delete), if you can accomplish it with just three keystrokes (`diw`)? The latter is more direct and concise. Of course, there will be times when visual modes are appropriate, but in general, favor a more direct approach.
