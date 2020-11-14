# Ch 09. Macros

When editing files, you may find yourself repeating the same actions. Wouldn't it be nice if you can do those actions once and replay them whenever you need it?  With Vim macros, you can record actions and store them inside Vim registers.

In this chapter, you will learn how to use macros to automate mundane tasks (plus it looks cool to watch your file edit itself).

## Basic Macros

Here is the basic syntax of a Vim macro:

```
qa                     Start recording a macro in register a
q (while recording)    Stop recording macro
```

You can use any lowercase letters (a-z) to store macros. Here is how you can execute a macro:

```
@a    Execute macro from register a
@@    Execute the last executed macros
```

Suppose you have this text and you want to uppercase everything in each line:

```
hello
vim
macros
are
awesome
```

With your cursor at the start of the line "hello", run:
```
qa0gU$jq
```

Here is the breakdown of the command above:

- `qa` starts recording a macro in the "a" register.
- `0` goes to beginning of the line.
- `gU$` uppercases the text from your current location to the end of the line.
- `j` goes down one line.
- `q` stops recording.

To replay that macro, run `@a`. Just like many other Vim commands, you can pass a count argument to macros. For example, you can run `3@a` to execute "a" macro three times. You can run `3@@` to execute the last executed macro three times.

## Safety Guard

Macro execution automatically ends when it encounters an error. Suppose you have this text:

```
a. chocolate donut
b. mochi donut
c. powdered sugar donut
d. plain donut
```

If you want to uppercase the first word on each line, this macro should work:

```
qa0W~jq
```

Here's the breakdown of the command above:
- `qa` starts recording a macro in the "a" register.
- `0` goes to the beginning of the line.
- `W` goes to the next WORD.
- `~` toggles the case of the character under the cursor.
- `j` goes down one line.
- `q` stops recording.


I like to overcount my macro calls, so I usually would call it ninety-nine times (`99@a`). With this command, Vim does not actually run this macro ninety-nine times. When Vim reaches the last line and runs `j` action, it finds no more lines to go down to, sees an error, and stops the macro execution. 

The fact that macro execution stops upon the first error encounter is a good feature, otherwise Vim will continue to execute this macro ninety-nine times even though it already reaches the end of the line.

## Command Line Macro

Running `@a` in normal mode is not the only way you can execute macros in Vim. You can also run `:normal @a` command line. `:normal` allows the user to execute any normal mode command given as argument. By passing it `@a`, it is the same as running `@a` from normal mode.

The `:normal` command accepts range as arguments. You can use this to run macro in select ranges. If you want to execute your "a" macro between lines 2 and 3, you can run `:2,3 normal @a`. I will go over command line commands in a later chapter.

## Executing A Macro Across Multiple Files

Suppose you have multiple `.txt` files, each containing different lists. Moreover, you need to uppercase the first word only on lines containing the word "donut". How can we execute macros across multiple files on select lines? 

First file:
```
## savory.Txt
a. cheddar jalapeno donut
b. mac n cheese donut
c. fried dumpling
```

Second file:
```
## sweet.Txt
a. chocolate donut
b. chocolate pancake
c. powdered sugar donut
```

Third file:
```
## plain.Txt
a. wheat bread
b. plain donut
```
Here is how you can do it:
- `:args *.txt` to find all `.txt` files in your current directory.
- `:argdo g/donut/normal @a` executes the global command `g/donut/normal @a` on each file inside `:args`.
- `:argdo update` executes `update` command to save each file inside `:args` when the buffer has been modified.

If you are not familiar with the global command `:g/donut/normal @a`, it executes the command you give (`normal @a`) on lines that match the pattern (`/donut/`). I will go over the global command in a later chapter.

## Recursive Macro

You can recursively execute a macro by calling the same macro register while recording that macro. Suppose you have this list again and you need to toggle the case of the first word:

```
a. chocolate donut
b. mochi donut
c. powdered sugar donut
d. plain donut

```
To do it recursively, run:
```
qaqqa0W~j@aq
```

Here is the breakdown of the steps:
- `qaq` records an empty macro "a". It is necessary to record an empty macro in the same register name because when you execute the "a" macro later, you don't want that register to contain anything.
- `qa` starts recording on register "a".
- `0` goes to the first character in the current line.
- `W` goes to the next WORD.
- `~` toggles the case of the character under the cursor.
- `j` goes down one line.
- `@a` executes macro "a". When recording this, `@a` should be empty because you had just called `qaq`.
- `q` stops recording.

Now you can just run `@a` and watch Vim execute the macro recursively. 

How does the macro know when to stop? When the macro is on the last line, it tries to run `j`, finds no extra line to go to, and stops the macro execution.

## Appending A Macro

If you need to add more actions to an existing macro, instead of redoing it, you can append actions to it. In the register chapter, you learned that you can append a named register by using its uppercased symbol. To append actions to a macro in register "a", use register "A". Suppose in addition to toggling the case of the first word, you also want to add a dot at the end of the line. 

Assume you have the following actions stored as a macro in register "a":

```
0W~
```
This is how you can do it:
```
qAA.<esc>q
```
The breakdown:
- `qA` starts recording the macro in register "A".
- `A.<esc>` inserts a dot (".") at the end of the line (`A`), then exits insert mode (`<esc>`).
- `q` stops recording macro.

Now when you execute `@a`, it goes to the first character in the line (`0`), goes to the next WORD (`W`), toggles the case of the character under the cursor (`~`), goes to insert mode at the end of the line (`A`), writes a dot ("."), and exits insert mode (`<esc>`).

## Amending A Macro

Appending is great technique to add new actions at the end of your existing macros, but what if you need to add new actions in the middle of it? In this section, I will show you how to amend a macro.

Suppose between uppercasing the first word and adding a period at the end of the line, you need to add the word "deep fried" right before the word "donut" *(because the only thing better than regular donuts are deep fried donuts)*.

I will reuse the text from earlier section:
```
a. chocolate donut
b. mochi donut
c. powdered sugar donut
d. plain donut
```

First, let's call the existing macro (assume you have kept the macro from the previous section in register "a") with `:put a`:

```
0W~A.^[
```

What is this `^[`? Didn't you do `0W~A.<esc>`? `^[` is Vim's *internal code* representation of `<esc>`. With certain special keys, Vim prints the representation of those keys in the form of internal codes. Some common keys that have internal code representations are `<esc>`, `<backspace>`, and `<enter>`. There are more special keys, but they are not within the scope of this chapter.

Back to the macro, right after the toggle case operator (`~`), let's add the instructions to go to the end of the line (`$`), go back one word (`b`), go to the insert mode (`i`), type "deep fried " (don't forget the space after "fried "), and exit insert mode (`<esc>`).

Here is what you will end up with:

```
0W~$bideep fried <esc>A.^[
```

There is a small problem. Vim does not understand `<esc>`. You will have to write the internal code representation for the `<esc>` you just added. While in insert mode, you press `Ctrl-v` followed by `<esc>`. Vim will print `^[`.` Ctrl-v` is an insert mode operator to insert the next non-digit character *literally*. Your macro code should look like this now:

```
0W~$bideep fried ^[A.^[
```

To add the amended instruction into register "a", you can do it the same way as adding a new entry into a named register. At the start of the line, run `"ay$`. This tells Vim that you're using the named register "a" (`"a`) to store the yanked text from the current position to the end of the line (`y$`).

Now when you execute `@a`, your macro will toggle the case of the first word, add "deep fried " before "donut", and add a "." at the end of the line.

An alternative way to amend a macro is to use a command line expression. Do `:let @a="`, then do `Ctrl-r Ctrl-r a`, this will literally paste the content of register "a". Finally, don't forget to close the double quotes (`"`). If you need to insert special characters using internal codes while editing a command line expression, you can use `Ctrl-v`.

## Macro Redundancy

You can easily duplicate macros from one register to another. For example, to duplicate a macro in register "a" to register "z", you can do `:let @z = @a`. `@a` represents the content of register "a". Now if you run `@z`, it does the exact same actions as `@a`.

I find creating a redundancy useful on my most frequently used macros. In my workflow, I usually record macros in the first seven alphabetical letters (a-g) and I often replace them without much thought. If I move the useful macros towards the end of the alphabets, I can preserve them without worrying that I might accidentally replace them.

## Series Vs Parallel Macro

Vim can execute macros in series and parallel. Suppose you have this text:

```
import { FUNC1 } from "library1";
import { FUNC2 } from "library2";
import { FUNC3 } from "library3";
import { FUNC4 } from "library4";
import { FUNC5 } from "library5";
```

If you want to record a macro to lowercase all the uppercased "FUNC", this macro should work:

```
qa0f{gui{jq
```

Here is the breakdown:
- `qa` starts recording in register "a".
- `0` goes to first line.
- `f{` finds the first instance of "{".
- `gui{` lowercases (`gu`) the text inside the bracket text-object (`i{`).
- `j` goes down one line.
- `q` stops macro recording.

Now you can run `99@a` to execute it on the remaining lines. However, what if you have this import expression inside your file?

```
import { FUNC1 } from "library1";
import { FUNC2 } from "library2";
import { FUNC3 } from "library3";
import foo from "bar";
import { FUNC4 } from "library4";
import { FUNC5 } from "library5";
```

Running `99@a`, only executes the macro three times. It does not execute the macro on last two lines because the execution fails to run `f{` on the "foo" line. This is expected when running the macro in series. You can always go to the next line where "FUNC4" is and replay that macro again. But what if you want to get everything done in one go? You can run the macro in parallel.

Recall from earlier section that macros can be executed using the  command line command `:normal` (ex: `:3,5 normal @a` to execute macro "a" on lines 3-5). If you run `:1,$ normal @a`, you will see that the macro is being executed on all lines except the "foo" line. It works!

Although internally Vim does not actually run the macros in parallel, outwardly, it behaves like such. Vim executes `@a` *independently* on each line from the first line to the last line (`1,$`). Since Vim executes these macros independently, each line does not know that one of the macro executions had failed on the "foo" line.

## Learn Macros The Smart Way

Many things you do in editing are repetitive. To get better at editing, get into the habit of detecting repetitive actions. Use macros (or dot command) so you don't have to perform the same action twice. Almost everything that you can do in Vim can be done with macros.

In the beginning, I find it very awkward to write macros, but don't give up. With enough practice, you will get into the habit of automating everything.

You might find it helpful to use mnemonics to help remember your macros. If you have a macro that creates a function, use the "f" register (`qf`). If you have a macro for numerical operations, the "n" register may be a good fit (`qn`). Name it with the *first named register* that comes to your mind when you think of that operation. I also find that "q" register makes a good default macro register because `qq` does not require much brain power to use. Lastly, I like to increment my macros in alphabetical orders, like `qa`, then `qb`, then `qc`, and so on. Find a method that works best for you.
