# Ch 07. The Dot Command

When editing a text, as much as you can, avoid redoing what you just did. In this chapter, you will learn how to use the dot command to easily replay the previous change. It is the simplest and most versatile command to reduce repetitions.

## Usage

Just like its name, you can use the dot command by pressing the dot key (`.`). 

For example, if you want to replace all "let" with "const" in the following expressions:
```
let one = "1";
let two = "2";
let three = "3";
```

First, use `/let` to go to the match. Second, use  `cwconst<esc>` to replace "let" with "const" . Third, use  `n` to find the next match using the previous search. Finally, repeat what you just did with the dot command (`.`). Continue doing `n . n .` until you replace every word.

In this case, the dot command repeated the `cwconst<esc>` sequence. It saved you from typing eight keystrokes in exchange for just one.

## What is a Change?

If you look at the definition of the dot command (`:h .`), it says that the dot command repeats the last change. What is a change?

Any time you update (add, modify, or delete) the content of the current buffer using any *normal-mode* commands, you are making a change. The exceptions are updates done by command-line commands (the commands starting with `:`) do not count as a change.

In the first example, you saw that `cwconst<esc>` was the change. Now suppose you have this sentence:

```
pancake, potatoes, fruit-juice,
```

Let's delete the text from the start of the line to the next occurrence of a comma. You can accomplish this with `df,`. Repeat with `.` two more times until you delete all the words.

Let's try another example:
```
pancake, potatoes, fruit-juice,
```

This time, you only need to delete the comma, not the word preceding it. Go to the first comma using `f,`. Delete the character under the cursor with `x`. Repeat with `.` two more times. Easy, right? Wait, it didn't work! Why?

In Vim, changes exclude motions because they do not update buffer content. When running `f,x`, you have two different actions: the command `f,`  moves the cursor and  `x` updates the buffer. Only the latter caused a change. Contrast that with `df,` from the earlier example. In it, `f,` instructs the delete operator where to delete. It is a part of the whole delete operator, `df,`.

Let's finish the last task. After you run `f,` followed by `x`, go to the next comma with `;` to repeat the latest `f`. Then use `.` to delete the character under the cursor. Repeat `; . ; .` until everything is deleted. The full command is `f,x;.;.`.

Let's try another one:

```
pancake
potatoes
fruit-juice
```

Lets add a comma at the end of each line. Starting at the first line, do `A,<esc>j`. By now, you realize that `j` does not cause a change. The change here is only `A,`. You can move and repeat the change with `j . j .`. The full command is `A,<esc>j.j.`.

Every action from the moment you press the insert command operator (`A`) until you exit the insert command (`<esc>`) is considered as a change. Vim allows you to control not only what texts to add, but *where* to add them. You can either add them before the cursor (`i`), after the cursor (`a`), on a newline below (`o`), on a newline above (`O`), at the end of current line (`A`), or at the start of current line (`I`). For a refresher, check out the [Insert Mode](./ch6_insert_mode.md) chapter.

## Repeat on Multiple Lines

Suppose you have this text:
```
let one = "1";
let two = "2";
let three = "3";
const foo = "bar';
let four = "4";
let five = "5";
let six = "6";
let seven = "7";
let eight = "8";
let nine = "9";
```
Your goal is to delete all lines except the "foo" line. First, delete the first three lines with `d2j`. Then go over past the "foo" line. On the next line, use the dot command twice. The full command is `d2jj..`.

Here the change was `d2j`. `2j` was not a motion, but a part of the delete operator.

Let's look at another example:
```
zlet zzone = "1";
zlet zztwo = "2";
zlet zzthree = "3";
let four = "4";
```

Let's remove all the z's. First, visually select the only the first z from the first three lines with blockwise-visual mode (`Ctrl-vjj`). If you're not familiar with blockwise visual mode, I will cover them in a later chapter. Once you have the three z's visually selected, delete them with the delete operator (`d`). Then move to the next word (`w`) to the next z. Repeat the change two more times (`..`). The full command is `Ctrl-vjjdw..`.

When you deleted a column of three z's (`Ctrl-vjjd`), it was counted as a change. Visual mode selection can be used to target multiple lines as part of a change.

## Including a Motion in a Change

Let's revisit the first example in this chapter. Recall that the command `/letcwconst<esc>` followed by `n . n .`  replaced all "let" with "const" in the following expressions:
```
let one = "1";
let two = "2";
let three = "3";
```
There is a faster way to accomplish this. When deleting, instead of using the `w` as a noun, use `gn`.

`gn` is a motion that searches forward for the last search pattern (in this case, `/let`) and automatically does a visual mode selection on the match. To replace the next occurrence, you no longer have to move and repeat the change ( `n . n .`), but only repeat (`. .`). You do not have to move anymore because searching the next match is now part of the change!

When you are editing, always be on the lookout for a motion that can do several things at once like `gn` whenever possible.

## Learn the Dot Command the Smart Way

The dot command's power comes from exchanging several keystrokes for one. It is probably not a profitable exchange to use the dot command for one-keyed-operations like `x`. If your last change requires a complex operation like `cgnconst<esc>`, the dot command reduces nine keypresses into one, a very good trade-off.

When editing, ask if the action you are about to do is repeatable. For example, if I need to remove the next three words, is it more economical to use `d3w` or to do `dw` then `.` two times? Will you be deleting a word again? If so, then it makes sense to use `dw` and repeat it several times instead of `d3w` because `dw` is more reusable than `d3w`. Keep a "change-driven" mindset while editing.

The dot command is an easy and versatile command to start automating simple tasks. In the later chapter, you will learn how to automate more complex actions with Vim macros. But first, let's learn about registers to store and retrieve text.
