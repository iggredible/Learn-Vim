# Ch13. the Global Command

So far you have learned how to repeat the last change with the dot command (`.`), to replay actions with macros (`q`), and to store texts in the registers (`"`).

In this chapter, you will learn how to repeat a command-line command with the global command.

## Global Command Overview

Vim's global command is used to run a command-line command on multiple lines simultaneously.

By the way, you may have heard of the term "Ex Commands" before. In this guide, I refer them as command-line commands. Both Ex commands and command-line commands are the same. They are the commands that start with a colon (`:`). The substitute command in the last chapter was an example of an Ex command. They are called Ex because they originally came from the Ex text editor. I will continue to refer to them as command-line commands in this guide. For a full list of Ex commands, check out `:h ex-cmd-index`.

The global command has the following syntax:

```
:g/pattern/command
```

The `pattern` matches all lines containing that pattern, similar to the pattern in the substitute command. The `command` can be any command-line command. The global command works by executing `command` against each line that matches the `pattern`.

If you have the following expressions:

```
const one = 1;
console.log("one: ", one);

const two = 2;
console.log("two: ", two);

const three = 3;
console.log("three: ", three);
```

To remove all lines containing "console", you can run:

```
:g/console/d
```

Result:

```
const one = 1;

const two = 2;

const three = 3;
```

The global command executes the delete command (`d`) on all lines that match the "console" pattern.

When running the `g` command, Vim  makes two scans across the file. On the first run, it scans each line and marks the line that matches the `/console/` pattern. Once all the matching lines are marked, it goes for the second time and executes the `d` command on the marked lines.

If you want to delete all lines containing "const" instead, run:

```
:g/const/d
```

Result:

```
console.log("one: ", one);

console.log("two: ", two);

console.log("three: ", three);
```

## Inverse Match

To run the global command on non-matching lines, you can run:

```
:g!/pattern/command
```

or

```
:v/pattern/command
```

If you run `:v/console/d`, it will delete all lines *not* containing "console".

## Pattern

The global command uses the same pattern system as the substitute command, so this section will serve as a refresher.  Feel free to skip to the next section or read along!

If you have these expressions:

```
const one = 1;
console.log("one: ", one);

const two = 2;
console.log("two: ", two);

const three = 3;
console.log("three: ", three);
```

To delete the lines containing either "one" or "two", run:

```
:g/one\|two/d
```

To delete the lines containing any single digits, run either:

```
:g/[0-9]/d
```

or

```
:g/\d/d
```

If you have the expression:

```
const oneMillion = 1000000;
const oneThousand = 1000;
const one = 1;
```

To match the lines containing between three to six zeroes, run:

```
:g/0\{3,6\}/d
```

## Passing a Range

You can pass a range before the `g` command. Here are some ways you can do it:
- `:1,5g/console/d`  matches the string "console" between lines 1 and 5 and deletes them.
- `:,5g/console/d` if there is no address before the comma, then it starts from the current line. It looks for the string "console" between the current line and line 5 and deletes them.
- `:3,g/console/d` if there is no address after the comma, then it ends at the current line. It looks for the string "console" between line 3 and the current line and deletes them.
- `:3g/console/d` if you only pass one address without a comma, it executes the command only on line 3. It looks on line 3 and deletes it if has the string "console".

In addition to numbers, you can also use these symbols as range:
- `.` means the current line. A range of `.,3` means between the current line and line 3.
- `$` means the last line in the file. `3,$` range means between line 3 and the last line.
- `+n` means n lines after the current line. You can use it with `.` or without. `3,+1` or `3,.+1` means between line 3 and the line after the current line.

If you don't give it any range, by default it affects the entire file. This is actually not the norm. Most of Vim's command-line commands run on only the current line if you don't pass it any range. The two notable exceptions are the global (`:g`) and the save (`:w`) commands.

## Normal Command

You can run a normal command with the global command with `:normal` command-line command.

If you have this text:
```
const one = 1
console.log("one: ", one)

const two = 2
console.log("two: ", two)

const three = 3
console.log("three: ", three)
```

To add a ";" to the end of each line, run:

```
:g/./normal A;
```

Let's break it down:
- `:g` is the global command.
- `/./` is a pattern for "non-empty lines". It matches the lines with at least one character, so it matches the lines with "const" and "console" and it does not match empty lines.
- `normal A;` runs the `:normal` command-line command. `A;` is the normal mode command to insert a ";" at the end of the line.

## Executing a Macro

You can also execute a macro with the global command. A macro can be executed with the `normal` command. If you have the expressions:

```
const one = 1
console.log("one: ", one);

const two = 2
console.log("two: ", two);

const three = 3
console.log("three: ", three);
```

Notice that the lines with "const" do not have semi-colons. Let's create a macro to add a comma to the end of those lines in the register a:

```
qaA;<Esc>q
```

If you need a refresher, check out the chapter on macro. Now run:

```
:g/const/normal @a
```

Now all lines with "const" will have a ";" at the end.

```
const one = 1;
console.log("one: ", one);

const two = 2;
console.log("two: ", two);

const three = 3;
console.log("three: ", three);
```

If you followed this step-by-step, you will have two semi-colons on the first line. To avoid that, run the global command on line two onward, `:2,$g/const/normal @a`.

## Recursive Global Command

The global command itself is a type of a command-line command, so you can technically run the global command inside a global command.

Given the following expressions, if you want to delete the second `console.log` statement:

```
const one = 1;
console.log("one: ", one);

const two = 2;
console.log("two: ", two);

const three = 3;
console.log("three: ", three);
```

If you run:

```
:g/console/g/two/d
```

First, `g` will look for the lines containing the pattern "console" and will find 3 matches. Then the second `g` will look for the line containing the pattern "two" from those three matches. Finally, it will delete that match.

You can also combine `g` with `v` to find positive and negative patterns. For example:

```
:g/console/v/two/d
```

Instead of looking for the line containing the pattern "two", it will look for the lines *not* containing the pattern "two".

## Changing the Delimiter

You can change the global command's delimiter like the substitute command. The rules are the same: you can use any single byte character except for alphabets, numbers, `"`, `|`, and `\`.

To delete the lines containing "console":

```
:g@console@d
```

If you are using the substitute command with the global command, you can have two different delimiters:

```
g@one@s+const+let+g
```

Here the global command will look for all lines containing "one". The substitute command will substitute, from those matches, the string "const" with "let".

## The Default Command

What happens if you don't specify any command-line command in the global command?

The global command will use the print (`:p`) command to print the current line's text. If you run:

```
:g/console
```

It will print at the bottom of the screen all the lines containing "console".

By the way, here is one interesting fact. Because the default command used by the global command is `p`, this makes the `g` syntax to be:

```
:g/re/p
```

- `g` = the global command
- `re` = the regex pattern
- `p` = the print command

It spells *"grep"*, the same `grep` from the command line. This is **not** a coincidence. The `g/re/p` command originally came from the Ed Editor, one of the original line text editors. The `grep` command got its name from Ed.

Your computer probably still has the Ed editor. Run `ed` from the terminal (hint: to quit, type `q`).

## Reversing the Entire Buffer

To reverse the entire file, run:

```
:g/^/m 0
```

`^` is a pattern for the beginning of a line. Use `^` to match all lines, including empty lines.

If you need to reverse only a few lines, pass it a range. To reverse the lines between line five to line ten, run:

```
:5,10g/^/m 0
```

To learn more about the move command, check out `:h :move`.

## Aggregating All Todos

When coding, sometimes I would write TODOs in the file I'm editing:

```
const one = 1;
console.log("one: ", one);
// TODO: feed the puppy

const two = 2;
// TODO: feed the puppy automatically
console.log("two: ", two);

const three = 3;
console.log("three: ", three);
// TODO: create a startup selling an automatic puppy feeder
```

It can be hard to keep track of all the created TODOs. Vim has a `:t` (copy) method to copy all matches to an address. To learn more about the copy method, check out `:h :copy`.

To copy all TODOs to the end of the file for easier introspection, run:

```
:g/TODO/t $
```

Result:

```
const one = 1;
console.log("one: ", one);
// TODO: feed the puppy

const two = 2;
// TODO: feed the puppy automatically
console.log("two: ", two);

const three = 3;
console.log("three: ", three);
// TODO: create a startup selling an automatic puppy feeder

// TODO: feed the puppy
// TODO: feed the puppy automatically
// TODO: create a startup selling an automatic puppy feeder
```

Now I can review all the TODOs I created, find a time to do them or delegate them to someone else, and continue to work on my next task.

If instead of copying them you want to move all the TODOs to the end, use the move command, `:m`:

```
:g/TODO/m $
```

Result:

```
const one = 1;
console.log("one: ", one);

const two = 2;
console.log("two: ", two);

const three = 3;
console.log("three: ", three);

// TODO: feed the puppy
// TODO: feed the puppy automatically
// TODO: create a startup selling an automatic puppy feeder
```

## Black Hole Delete

Recall from the register chapter that deleted texts are stored inside the numbered registers (granted they are sufficiently large ). Whenever you run `:g/console/d`, Vim stores the deleted lines in the numbered registers. If you delete many lines, you can quickly fill up all the numbered registers. To avoid this, you can always use the black hole register (`"_`) to *not* store your deleted lines into the registers. Run:

```
:g/console/d_
```

By passing `_` after `d`, Vim won't use up your scratch registers.

## Reduce Multiple Empty Lines to One Empty Line

If you have a text with multiple empty lines:

```
const one = 1;
console.log("one: ", one);


const two = 2;
console.log("two: ", two);





const three = 3;
console.log("three: ", three);
```

You can quickly reduce the empty lines into one empty line with:

```
:g/^$/,/./-1j
```

Result:

```
const one = 1;
console.log("one: ", one);

const two = 2;
console.log("two: ", two);

const three = 3;
console.log("three: ", three);
```

Normally the global command accepts the following form: `:g/pattern/command`. However, you can also run the global command with the following form: `:g/pattern1/,/pattern2/command`. With this, Vim will apply the `command` within `pattern1` and `pattern2`.

With that in mind, let's break down the command `:g/^$/,/./-1j` according to `:g/pattern1/,/pattern2/command`:
- `/pattern1/` is `/^$/`. It represents an empty line (a line with zero character).
- `/pattern2/` is `/./` with `-1` line modifier. `/./` represents a non-empty line (a line with at least one character). The `-1` means the line above that.
- `command` is `j`, the join command (`:j`). In this context, this global command joins all the given lines.

By the way, if you want to reduce multiple empty lines to no lines, run this instead:

```
:g/^$/,/./j
```

A simpler alternative:

```
:g/^$/-j
```

Your text is now reduced to:

```
const one = 1;
console.log("one: ", one);
const two = 2;
console.log("two: ", two);
const three = 3;
console.log("three: ", three);
```

## Advanced Sort

Vim has a `:sort` command to sort the lines within a range. For example:

```
d
b
a
e
c
```

You can sort them by running `:sort`. If you give it a range, it will sort only the lines within that range. For example, `:3,5sort` only sorts lines three and five.

If you have the following expressions:

```
const arrayB = [
  "i",
  "g",
  "h",
  "b",
  "f",
  "d",
  "e",
  "c",
  "a",
]

const arrayA = [
  "h",
  "b",
  "f",
  "d",
  "e",
  "a",
  "c",
]
```

If you need to sort the elements inside the arrays, but not the arrays themselves, you can run this:

```
:g/\[/+1,/\]/-1sort
```

Result:

```
const arrayB = [
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
]

const arrayA = [
  "a"
  "b",
  "c",
  "d",
  "e",
  "f",
  "h",
]
```

This is great! But the command looks complicated. Let's break it down. This command also follows the form `:g/pattern1/,/pattern2/command`.

- `:g` is the global command pattern.
- `/\[/+1` is the first pattern. It matches a literal left square bracket "[". The `+1` refers to the line below it.
- `/\]/-1` is the second pattern. It matches a literal right square bracket "]". The `-1` refers to the line above it.
- `/\[/+1,/\]/-1` then refers to any lines between "[" and "]".
- `sort` is a command-line command to sort.

## Learn the Global Command the Smart Way

The global command executes the command-line command against all matching lines. With it, you only need to run a command once and Vim will do the rest for you. To become proficient at the global command, two things are required: a good vocabulary of command-line commands and a knowledge of regular expressions. As you spend more time using Vim, you will naturally learn more command-line commands. A regular expression knowledge will require a more active approach. But once you become comfortable with regular expressions, you will be ahead of many.

Some of the examples here are complicated. Do not be intimidated. Really take your time to understand them. Learn to read the patterns. Do not give up.

Whenever you need to run multiple commands, pause and see if you can use the `g` command. Identify the best command for the job and write a pattern to target as many things at once.

Now that you know how powerful the global command is, let's learn how to use the external commands to increase your tool arsenals.

## Link
- Prev [Ch12. Search and Substitute](./ch12_search_and_substitute.md)
- Next [Ch14. External Commands](./ch14_external_commands.md)
