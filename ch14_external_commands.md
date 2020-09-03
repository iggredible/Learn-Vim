# External Commands

Inside the Unix system, you will find many small, hyper-specialized commands where each does one thing well. You can chain these commands  to work together to solve a complex problem. Wouldn't it be great if you can use these commands from inside Vim?

In this chapter, you will learn how extend Vim to work seamlessly with external commands.

# The Bang Command

Vim has a bang (`!`) command that can do three things:

1. Read the STDOUT of an external command into the current buffer.
2. Write the content of your buffer as the STDIN to an external command.
3. Execute an external command from inside Vim.


# Reading the STDOUT of a Command Into Vim

The syntax to read the STDOUT of an external command into the current buffer is:

```
:r !{cmd}
```

`:r` is Vim's read command. If you use it without `!`, you can use it to get the content of a file. If you have a file `file1.txt` in the current directory and you run:

```
:r file1.txt
```

Vim will put the content of `file1.txt` into the current buffer.

If you run the `:r` command followed by a `!` and an external command, the output of that commmand will be inserted into the current buffer. To get the result of the `ls` command, run:

```
:r !ls
```

It returns something like:

```
file1.txt
file2.txt
file3.txt
```

You can read the data from the `curl` command:

```
:r !curl -s 'https://jsonplaceholder.typicode.com/todos/1'
```

The `r` command also accepts an address:

```
:10r !cat file1.txt
```

Now the STDOUT from running `cat file.txt` will be inserted after line 10.

# Writing the Buffer Content Into an External Command

In addition to saving a file, you can also use the write command (`:w`) to pass the text in the current buffer as the STDIN for an external command. The syntax is:

```
:w !cmd
```

If you have these expressions:

```
console.log("Hello Vim");
console.log("Vim is awesome");
```

Make sure you have [node](https://nodejs.org/en/) installed in your machine, then run:

```
:w !node
```

Vim will use `node` to execute the Javascript expressions to print "Hello Vim" and "Vim is awesome". 

When using the `:w` command, Vim uses all texts in the current buffer, similar to the global command (most command-line commands, if you don't pass it a range, only executes the command against the current line). If you pass `:w` a specific address:

```
:2w !node
```

Vim only uses the text from the second line into the `node` interpreter.

There is a subtle but significant difference between `:w !node` and `:w! node`. With `:w !node`, you are "writing" the text in the current buffer into the external command `node`. With `:w! node`, you are force-saving a file and naming the file "node".

# Executing an External Command

You can execute an external command from inside Vim with the bang command. The syntax is:

```
:!cmd
```

To see the content of the current directory in the long format, run:

```
:!ls -ls
```

To kill a process that is running on PID 3456, you can run:

```
:!kill -9 3456
```

You can run any external command without leaving Vim so you can stay focused on your task.

# Filtering Texts

If you give `!` a range, it can be used to filter texts. Suppose you have this:

```
hello vim
hello vim
```

Let's uppercase the current line using the `tr` (translate) command. Run:

```
:.!tr '[:lower:]' '[:upper:]'
```

The result:

```
HELLO VIM
hello vim
```

The breakdown:
- `.!` executes the filter command on the current line.
- `!tr '[:lower:]' '[:upper:]'` calls the `tr` command to replace all lowercase characters with uppercase ones.

It is imperative to pass a range to run the external command as a filter. If you try running the command above without the `.` (`:!tr '[:lower:]' '[:upper:]'`), you will see an error.

Let's assume that you need to remove the second column on both lines with the `awk` command:

```
:%!awk "{print $1}"
```

The result:

```
hello
hello
```

The breakdown:
- `:%!` executes the filter command on all lines (`%`).
- `awk "{print $1}"` prints only the first column of the match. In this case, the word "hello". 

You can chain multiple commands with the chain operator (`|`) just like in the terminal. Let's say you have a file with these delicious breakfast items:

```
name price
chocolate pancake 10
buttermilk pancake 9
blueberry pancake 12
```

If you need to sort them based on the price and display only the menu with an even spacing, you can run:

```
:%!awk 'NR > 1' | sort -nk 3 | column -t
```

The result:
```
buttermilk pancake 9
chocolate pancake 10
blueberry pancake 12
```

The breakdown:
- `:%!` applies the filter to all lines (`%`).
- `awk 'NR > 1'` displays the texts only from row number two onwards.
- `|` chains the next command.
- `sort -nk 3` sorts numerically (`n`) using the values from column 3 (`k 3`).
- `column -t` organizes the text with even spacing.

# Normal mode command

Vim has a filter operator (`!`) in the normal mode. If you have the following greetings:

```
hello vim
hola vim
bonjour vim
salve vim
```

To uppercase the current line and the line below, you can run:
```
!jtr '[a-z]' '[A-Z]'
```

The breakdown:
- `!j` runs the normal command filter operator (`!`) targetting the current line and the line below it. Recall that because it is a normal mode operator, the grammar rule `verb + noun` applies. 
- `tr '[a-z]' '[A-Z]'` replaces the lowercase letters with the uppercase letters.

The filter normal command only works on motions / text objects that are at least one line or longer. If you had tried running `!iwtr '[a-z]' '[A-Z]'` (execute `tr` on inner word), you will find that it applies the `tr` command on the entire line, not the word your cursor is on.

# Learn External Commands the Smart Way

Vim is not an IDE. It is a lightweight modal editor that is highly extensible by design. Because of this extensibility, you have easy access to any external command in your system. With this, Vim is one step closer from becoming an IDE. Someone said that the Unix system is the first IDE ever.

The bang command is as useful as how many external commands you know. Don't worry if your external command knowledge is limited. I still have a lot to learn too. Take this as a motivation for continuous learning. Whenever you need to filter a text, look if there is an external command that can solve your problem. Don't worry about mastering everything about a particular command. Just learn the ones you need to complete the current task.
