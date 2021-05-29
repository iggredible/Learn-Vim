# Ch19. Compile

Compiling is an important subject for many languages. In this chapter, you will learn how to compile from Vim. You will also look at ways to take advantage of Vim's `:make` command.

## Compile From the Command Line

You can use the bang operator (`!`) to compile. If you need to compile your `.cpp` file with `g++`, run:

```
:!g++ hello.cpp -o hello
```

However, having to manually type the filename and the output filename each time is error-prone and tedious. A makefile is the way to go.

## The Make Command

Vim has a `:make` command to run a makefile. When you run it, Vim looks for a makefile in the current directory to execute.

Create a file named `makefile` in the current directory and put these inside:

```
all:
	echo "Hello all"
foo:
	echo "Hello foo"
list_pls:
	ls
```

Run this from Vim:

```
:make
```

Vim executes it the same way as when you're running it from the terminal. The `:make` command accepts parameter just like the terminal make command. Run:

```
:make foo
" Outputs "Hello foo"

:make list_pls
" Outputs the ls command result
```

The `:make` command uses Vim's quickfix to store any error if you run a bad command. Let's run a nonexisting target:

```
:make dontexist
```

You should see an error running that command. To view that error, run the quickfix command `:copen` to view the quickfix window:

```
|| make: *** No rule to make target `dontexist'.  Stop.
```

## Compiling With Make

Let's use the makefile to compile a basic `.cpp` program. First, let's create a `hello.cpp` file:

```
#include <iostream>

int main() {
    std::cout << "Hello!\\n";
    return 0;
}
```

Update your makefile to build and run a `.cpp` file:

```
all:
	echo "build, run"
build:
	g++ hello.cpp -o hello
run:
	./hello
```

Now run:

```
:make build
```

The `g++` compiles `./hello.cpp` and creates `./hello`. Then run:

```
:make run
```

You should see `"Hello!"` printed on the terminal.

## Different Make Program

When you run `:make`, Vim actually runs whatever command that is set under the `makeprg` option. If you run `:set makeprg?`, you'll see:

```
makeprg=make
```

The default `:make` command is the `make` external command. To change the `:make` command to execute `g++ {your-file-name}` each time you run it, run:

```
:set makeprg=g++\ %
```

The `\` is to escape the space after `g++`. The `%` symbol in Vim represents the current file. The command `g++\\ %` is equivalent to running `g++ hello.cpp`.

Go to `./hello.cpp` then run `:make`. Vim compiles `hello.cpp` and creates `a.out` because you didn't specify the output. Let's refactor it so it will name the compiled output with the name of the original file minus the extension. Run or add this to vimrc:

```
set makeprg=g++\ %\ -o\ %<
```

The breakdown:
- `g++\ %` is the same as above. It is equivalent to running `g++ <your-file>`.
- `-o` is the output option.
- `%<` in Vim represents the current file name without an extension (`hello.cpp` becomes `hello`).

When you run `:make` from inside `./hello.cpp`, it is compiled into `./hello`. To quickly execute `./hello` from inside `./hello.cpp`, run `:!./%<`. Again, this is the same as running `:!./{current-file-name-minus-the-extension}`.

For more, check out `:h :compiler` and `:h write-compiler-plugin`.

## Auto-compile on Save

You can make life even easier by automating compilation. Recall that you can use Vim's `autocmd` to trigger automatic actions based on certain events. To automatically compile `.cpp` files on each save add this on your vimrc:

```
autocmd BufWritePost *.cpp make
```

Each time you save inside a `.cpp` file, Vim executes the `make` command.

## Switching Compiler

Vim has a `:compiler` command to quickly switch compilers. Your Vim build probably comes with several pre-built compiler configurations. To check what compilers you have, run:

```
:e $VIMRUNTIME/compiler/<Tab>
```

You should see a list of compilers for different programming languages.

To use the `:compiler` command, suppose you have a ruby file, `hello.rb` and inside it has:

```
puts "Hello ruby"
```

Recall that if you run `:make`, Vim executes whatever command is assigned to `makeprg` (default is `make`). If you run:

```
:compiler ruby
```

Vim runs the `$VIMRUNTIME/compiler/ruby.vim` script and changes the `makeprg` to use the `ruby` command. Now if you run `:set makeprg?`, it should say `makeprg=ruby` (this depends on what is inside your `$VIMRUNTIME/compiler/ruby.vim` file or if you have another custom ruby compilers. Yours might be different). The `:compiler {your-lang}` command allows you to switch to different compilers  quickly. This is useful if your project uses multiple languages.

You don't have to use the `:compiler` and `makeprg` to compile a program. You can run a test script, lint a file, send a signal, or anything you want.

## Creating a Custom Compiler

Let's create a simple Typescript compiler. Install Typescript (`npm install -g typescript`) to your machine. You should now have the `tsc` command. If you haven't played with typescript before, `tsc` compiles a Typescript file into a Javascript file. Suppose that you have a file, `hello.ts`:

```
const hello = "hello";
console.log(hello);
```

If you run `tsc hello.ts`, it will compile into `hello.js`. However, if you have the following expressions inside `hello.ts`:

```
const hello = "hello";
hello = "hello again";
console.log(hello);
```

This will throw an error because you can't mutate a `const` variable. Running `tsc hello.ts` will throw an error:

```
hello.ts:2:1 - error TS2588: Cannot assign to 'person' because it is a constant.

2 person = "hello again";
  ~~~~~~


Found 1 error.
```

To create a simple Typescript compiler, in your `~/.vim/` directory, add a `compiler` directory (`~/.vim/compiler/`), then create a `typescript.vim` file (`~/.vim/compiler/typescript.vim`). Put this inside:

```
CompilerSet makeprg=tsc
CompilerSet errorformat=%f:\ %m
```

The first line sets the `makeprg` to run the `tsc` command. The second line sets the error format to display the file (`%f`), followed by a literal colon (`:`) and an escaped space (`\ `), followed by the error message (`%m`). To learn more about the error formatting, check out `:h errorformat`.

You should also read some of the pre-made compilers to see how others do it. Check out `:e $VIMRUNTIME/compiler/<some-language>.vim`.

Because some plugins may interfere with the Typescript file, let's open the `hello.ts` without any plugin, using the `--noplugin` flag:

```
vim --noplugin hello.ts
```

Check the `makeprg`:

```
:set makeprg?
```

It should say the default `make` program. To use the new Typescript compiler, run:

```
:compiler typescript
```

When you run `:set makeprg?`, it should say `tsc` now. Let's put it to the test. Run:

```
:make %
```

Recall that `%` means the current file. Watch your Typescript compiler work as expected! To see the list of error(s), run `:copen`.

## Async Compiler

Sometimes compiling can take a long time. You don't want to be staring at a frozen Vim while waiting for your compilation process to finish. Wouldn't it be nice if you can compile asynchronously so you can still use Vim during compilation?

Luckily there are plugins to run async processes. The two big ones are:

- [vim-dispatch](https://github.com/tpope/vim-dispatch)
- [asyncrun.vim](https://github.com/skywind3000/asyncrun.vim)

In the remaining of this chapter, I will go over vim-dispatch, but I would strongly encourage you to try all of them out there.

*Vim and NeoVim actually supports async jobs, but they are beyond the scope of this chapter. If you're curious, check out `:h job-channel-overview.txt`.*

## Plugin: Vim-dispatch

Vim-dispatch has several commands, but the two main ones are `:Make` and `:Dispatch` commands.

### Async Make

Vim-dispatch's `:Make` command is similar to Vim's `:make`, but it runs asynchronously. If you are in a Javascript project and you need to run `npm t`, you might attempt to set your makeprg to be:

```
:set makeprg=npm\\ t
```

If you run:

```
:make
```

Vim will execute `npm t`, but you will be staring at the frozen screen while your JavaScript test runs. With vim-dispatch, you can just run:

```
:Make
```

Vim will run `npm t` asynchronously. This way, while `npm t` is running on a background process, you can continue doing whatever you were doing. Awesome!

### Async Dispatch

The `:Dispatch` command is like the `:compiler` and the `:!` command. It can run any external command asynchronously in Vim.

Assume that you are inside a ruby spec file and you need to run a test. Run:

```
:Dispatch bundle exec rspec %
```

Vim will asynchronously run the `rspec` command against the current file (`%`).

### Automating Dispatch

Vim-dispatch has `b:dispatch` buffer variable that you can configure to evaluate specific command automatically. You can leverage it with `autocmd`. If you add this in your vimrc:

```
autocmd BufEnter *_spec.rb let b:dispatch = 'bundle exec rspec %'
```

Now each time you enter a file (`BufEnter`) that ends with `_spec.rb`, running `:Dispatch` automatically executes `bundle exec rspec {your-current-ruby-spec-file}`.

## Learn Compile the Smart Way

In this chapter, you learned that you can use the `make` and `compiler` commands to run *any* process from inside Vim asynchronously to complement your programming workflow. Vim's ability to extend itself with other programs makes it powerful.

