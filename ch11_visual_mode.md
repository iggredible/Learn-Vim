# Ch11. Visual Mode

Highlighting and applying changes to a body of text is a common feature in many text editors and word processors. Vim can do this using visual mode. In this chapter, you will learn how to use the visual mode to manipulate texts efficiently.

## The Three Types of Visual Modes

Vim has three different visual modes. They are:

```
v         Character-wise visual mode
V         Line-wise visual mode
Ctrl-V    Block-wise visual mode
```

If you have the text:

```
one
two
three
```

Character-wise visual mode works with individual characters. Press `v` on the first character. Then go down to the next line with `j`. It highlights all texts from "one" up to your cursor location. If you press `gU`, Vim uppercases the highlighted characters.

Line-wise visual mode works with lines. Press `V` and watch Vim selects the entire line your cursor is on. Just like character-wise visual mode, if you run `gU`, Vim uppercases the highlighted characters.

Block-wise visual mode works with rows and columns. It gives you more freedom of movement than the other two modes. If you press `Ctrl-V`, Vim highlights the character under the cursor just like character-wise visual mode, except instead of highlighting each character until the end of the line before going down to the next line, it goes to the next line with minimal highlighting. Try moving around with `h/j/k/l` and watch the cursor moves.

On the bottom left of your Vim window, you will see either `-- VISUAL --`, `-- VISUAL LINE --`, or `-- VISUAL BLOCK --` displayed to indicate which visual mode you are in.

While you are inside a visual mode, you can switch to another visual mode by pressing either `v`, `V`, or `Ctrl-V`. For example, if you are in line-wise visual mode and you want to switch to block-wise visual mode, run `Ctrl-V`. Try it!

There are three ways to exit the visual mode: `<Esc>`, `Ctrl-C`, and the same key as your current visual mode. What the latter means is if you are currently in the line-wise visual mode (`V`), you can exit it by pressing `V` again. If you are in the character-wise visual mode, you can exit it by pressing `v`.

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

This time let's start from the line "two". Press `v` to go to the character-wise visual mode (here the square brackets `[]` represents the character highlights):

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

Assume from this position, you want to add the line "one" too. If you press `k`, to your dismay, the highlight moves away from the line "three". 

```
one
[t]wo
three
```

Is there a way to freely expand visual selection to go to any direction you want? Definitely. Let's back up a little bit to where you have the line "two" and "three" highlighted.

```
one
[two
t]hree    <-- cursor
```

Visual highlight follows the cursor movement. If you want to expand it upward to line "one", you need to move the cursor up to the line "two". Right now the cursor is on the line "three". You can toggle the cursor location with either `o` or `O`.

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

With `o` or `O` in visual mode, the cursor jumps from the beginning to the end of the highlighted block, allowing you to expand the highlight area.

## Visual Mode Grammar

The visual mode shares many operations with normal mode.

For example, if you have the following text and you want to delete the first two lines from visual mode:

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

Pressing `d` will delete the selection, similar to normal mode. Notice the grammar rule from normal mode, verb + noun, does not apply. The same verb is still there (`d`), but there is no noun in visual mode. The grammar rule in visual mode is noun + verb, where noun is the highlighted text. Select the text block first, then the command follows.

In normal mode, there are some commands that do not require a motion, like `x` to delete a single character under the cursor and `r` to replace the character under the cursor (`rx` replaces the character under the cursor with "x"). In visual mode, these commands are now being applied to the entire highlighted text instead of a single character. Back at the highlighted text:

```
[one
two]
three
```

Running `x` deletes all highlighted texts.

You can use this behavior to quickly create a header in markdown text. Suppose you need to quickly turn the following text into a first-level markdown header ("==="):

```
Chapter One
```

First, copy the text with `yy`, then paste it with `p`:

```
Chapter One
Chapter One
```

Now go to the second line, select it with line-wise visual mode:

```
Chapter One
[Chapter One]
```

A first-level header is a series of "=" below a text. Run `r=`, voila! This saves you from typing "=" manually.

```
Chapter One
===========
```

To learn more about operators in visual mode, check out `:h visual-operators`.

## Visual Mode and Command-line Commands

You can selectively apply command-line commands on a highlighted text block. If you have these statements and you want to substitute "const" with "let" only on the first two lines:

```
const one = "one";
const two = "two";
const three = "three";
```

Highlight the first two lines with *any* visual mode and run the substitute command `:s/const/let/g`:

```
let one = "one";
let two = "two";
const three = "three";
```

Notice I said you can do this with *any* visual mode. You do not have to highlight the entire line to run the command on that line. As long as you select at least a character on each line, the command is applied.

## Adding Text on Multiple Lines

You can add text on multiple lines in Vim using the block-wise visual mode. If you need to add a semicolon at the end of each line:

```
const one = "one"
const two = "two"
const three = "three"
```

With your cursor on the first line:
- Run block-wise visual mode and go down two lines (`Ctrl-V jj`).
- Highlight to the end of the line (`$`).
- Append (`A`) then type ";".
- Exit visual mode (`<Esc>`).

You should see the appended ";" on each line now. Pretty cool! There are two ways to enter the insert mode from block-wise visual mode: `A` to enter the text after the cursor or `I` to enter the text before the cursor. Do not confuse them with `A` (append text at the end of the line) and `I` (insert text before the first non-blank line) from normal mode.

Alternatively, you can also use the `:normal` command to add text on multiple lines:
- Highlight all 3 lines (`vjj`).
- Type `:normal! A;`.

Remember, `:normal` command executes normal mode commands. You can instruct it to run `A;` to append text ";" at the end of the line.

## Incrementing Numbers

Vim has `Ctrl-X` and `Ctrl-A` commands to decrement and increment numbers. When used with visual mode, you can increment numbers across multiple lines.

If you have these HTML elements:

```
<div id="app-1"></div>
<div id="app-1"></div>
<div id="app-1"></div>
<div id="app-1"></div>
<div id="app-1"></div>
```

It is a bad practice to have several ids having the same name, so let's increment them to make them unique:
- Move your cursor to the "1" on the second line.
- Start block-wise visual mode and go down 3 lines (`Ctrl-V 3j`). This highlights the remaining  "1"s. Now all "1" should be highlighted (except the first line).
- Run `g Ctrl-A`.

You should see this result:

```
<div id="app-1"></div>
<div id="app-2"></div>
<div id="app-3"></div>
<div id="app-4"></div>
<div id="app-5"></div>
```

`g Ctrl-A` increments numbers on multiple lines. `Ctrl-X/Ctrl-A` can increment letters too, with the number formats option:

```
set nrformats+=alpha
```

The `nrformats` option instructs Vim which bases are considered as "numbers" for `Ctrl-A` and `Ctrl-X` to increment and decrement. By adding `alpha`, an alphabetical character is now considered as a number. If you have the following HTML elements:

```
<div id="app-a"></div>
<div id="app-a"></div>
<div id="app-a"></div>
<div id="app-a"></div>
<div id="app-a"></div>
```

Put your cursor on the second "app-a". Use the same technique as above (`Ctrl-V 3j` then `g Ctrl-A`) to increment the ids.

```
<div id="app-a"></div>
<div id="app-b"></div>
<div id="app-c"></div>
<div id="app-d"></div>
<div id="app-e"></div>
```

## Selecting the Last Visual Mode Area

Earlier in this chapter I mentioned that `gv` can quickly highlight the last visual mode highlight. You can also go to the location of the start and the end of the last visual mode with these two special marks:

```
`<    Go to the first place of the previous visual mode highlight
`>    Go to the last place of the previous visual mode highlight
```

Earlier, I also mentioned that you can selectively execute command-line commands on a highlighted text, like `:s/const/let/g`. When you did that, you'd see this below:

```
:`<,`>s/const/let/g
```

You were actually executing a *ranged* `s/const/let/g` command (with the two marks as the addresses). Interesting!

You can always edit these marks anytime you wish. If instead you needed to substitute from the start of the highlighted text to the end of the file, you just change the command to:

```
:`<,$s/const/let/g
```

## Entering Visual Mode From Insert Mode

You can also enter visual mode from the insert mode. To go to character-wise visual mode while you are in insert mode:

```
Ctrl-O v
```

Recall that running `Ctrl-O` while in the insert mode lets you to execute a normal mode command. While in this normal-mode-command-pending mode, run `v` to enter character-wise visual mode. Notice that on the bottom left of the screen, it says `--(insert) VISUAL--`. This trick works with any visual mode operator: `v`, `V`, and `Ctrl-V`.

## Select Mode

Vim has a mode similar to visual mode called the select mode. Like the visual mode, it also has three different modes:

```
gh         Character-wise select mode
gH         Line-wise select mode
gCtrl-h    Block-wise select mode
```

Select mode emulates a regular editor's text highlighting behavior closer than Vim's visual mode does.

In a regular editor, after you highlight a text block and type a letter, say the letter "y", it will delete the highlighted text and insert the letter "y". If you highlight a line with line-wise select mode (`gH`) and type "y", it will delete the highlighted text and insert the letter "y".

Contrast this select mode with visual mode: if you highlight a line of text with line-wise visual mode (`V`) and type "y", the highlighted text will not be deleted and replaced by the literal letter "y", it will be yanked. You can't execute normal mode commands on highlighted text in select mode.

I personally never used select mode, but it's good to know that it exists.

## Learn Visual Mode the Smart Way

The visual mode is Vim's representation of the text highlighting procedure.

If you find yourself using visual mode operation far more often than normal mode operations, be careful. This is an anti-pattern. It takes more keystrokes to run a visual mode operation than its normal mode counterpart. For example, if you need to delete an inner word, why use four keystrokes, `viwd` (visually highlight an inner word then delete), if you can accomplish it with just three keystrokes (`diw`)? The latter is more direct and concise. Of course, there will be times when visual modes are appropriate, but in general, favor a more direct approach.
