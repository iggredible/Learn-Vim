# Ch07. the Dot Command

In general, you should try to avoid redoing what you just did whenever possible. In this chapter, you will learn how to use the dot command to easily redo the previous change. It is a versatile command for reducing simple repetitions.

## Usage

Just like its name, you can use the dot command by pressing the dot key (`.`).

For example, if you want to replace all "let" with "const" in the following expressions:

```
let one = "1";
let two = "2";
let three = "3";
```

- Search with `/let` to go to the match.
- Change with `cwconst<Esc>` to replace "let" with "const".
- Navigate with `n` to find the next match using the previous search.
- Repeat what you just did with the dot command (`.`).
- Continue pressing `n . n .` until you replace every word.

Here the dot command repeated the `cwconst<Esc>` sequence. It saved you from typing eight keystrokes in exchange for just one.

## What Is a Change?

If you look at the definition of the dot command (`:h .`), it says that the dot command repeats the last change. What is a change?

Any time you update (add, modify, or delete) the content of the current buffer, you are making a change. The exceptions are updates done by command-line commands (the commands starting with `:`) do not count as a change.

In the first example, `cwconst<Esc>` was the change. Now suppose you have this text:

```
pancake, potatoes, fruit-juice,
```

To delete the text from the start of the line to the next occurrence of a comma, first delete to the comma, then repeat twice it with `df,..`. 

Let's try another example:

```
pancake, potatoes, fruit-juice,
```

This time, your task is to delete the comma, not the breakfast items. With the cursor at the beginning of the line, go to the first comma, delete it, then repeat two more times with `f,x..` Easy, right? Wait a minute, it didn't work! Why?

A change excludes motions because it does not update buffer content. The command `f,x` consisted of two actions: the command `f,` to move the cursor to "," and `x` to delete a character. Only the latter, `x`, caused a change. Contrast that with `df,` from the earlier example. In it, `f,` is a directive to the delete operator `d`, not a motion to move the cursor. The `f,` in `df,` and `f,x` have two very different roles.

Let's finish the last task. After you run `f,` then `x`, go to the next comma with `;` to repeat the latest `f`. Finally, use `.` to delete the character under the cursor. Repeat `; . ; .` until everything is deleted. The full command is `f,x;.;.`.

Let's try another one:

```
pancake
potatoes
fruit-juice
```

Let's add a comma at the end of each line. Starting at the first line, do `A,<Esc>j`. By now, you realize that `j` does not cause a change. The change here is only `A,`. You can move and repeat the change with `j . j .`. The full command is `A,<Esc>j.j.`.

Every action from the moment you press the insert command operator (`A`) until you exit the insert command (`<Esc>`) is considered as a change.

## Multi-line Repeat

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

Your goal is to delete all lines except the "foo" line. First, delete the first three lines with `d2j`, then to the line below the "foo" line. On the next line, use the dot command twice. The full command is `d2jj..`.

Here the change was `d2j`. In this context, `2j` was not a motion, but a part of the delete operator.

Let's look at another example:

```
zlet zzone = "1";
zlet zztwo = "2";
zlet zzthree = "3";
let four = "4";
```

Let's remove all the z's. Starting from the first character on the first line, visually select only the first z from the first three lines with blockwise visual mode (`Ctrl-Vjj`). If you're not familiar with blockwise visual mode, I will cover them in a later chapter. Once you have the three z's visually selected, delete them with the delete operator (`d`). Then move to the next word (`w`) to the next z. Repeat the change two more times (`..`). The full command is `Ctrl-vjjdw..`.

When you deleted a column of three z's (`Ctrl-vjjd`), it was counted as a change. Visual mode operation can be used to target multiple lines as part of a change.

## Including a Motion in a Change

Let's revisit the first example in this chapter. Recall that the command `/letcwconst<Esc>` followed by `n . n .`  replaced all "let" with "const" in the following expressions:

```
let one = "1";
let two = "2";
let three = "3";
```

There is a faster way to accomplish this. After you searched `/let`, run `cgnconst<Esc>` then `. .`.

`gn` is a motion that searches forward for the last search pattern (in this case, `/let`) and automatically does a visual highlight. To replace the next occurrence, you no longer have to move and repeat the change ( `n . n .`), but only repeat (`. .`). You do not have to use search motions anymore because searching the next match is now part of the change!

When you are editing, always be on the lookout for motions that can do several things at once like `gn` whenever possible.

## Learn the Dot Command the Smart Way

The dot command's power comes from exchanging several keystrokes for one. It is probably not a profitable exchange to use the dot command for single key operations like `x`. If your last change requires a complex operation like `cgnconst<Esc>`, the dot command reduces nine keypresses into one, a very profitable trade-off.

When editing, think about repeatability. For example, if I need to remove the next three words, is it more economical to use `d3w` or to do `dw` then `.` two times? Will you be deleting a word again? If so, then it makes sense to use `dw` and repeat it several times instead of `d3w` because `dw` is more reusable than `d3w`. 

The dot command is a versatile command for automating single changes. In a later chapter, you will learn how to automate more complex actions with Vim macros. But first, let's learn about registers to store and retrieve text.

## Link
- Prev [Ch06. Insert Mode](./ch06_insert_mode.md)
- Next [Ch08. Registers](./ch08_registers.md)
