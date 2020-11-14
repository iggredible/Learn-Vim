# Ch 19. Compile

Compiling is an important subject for many languages. In this chapter, you will learn how to compile from Vim. In addition, you will look at ways to take advantage of Vim's `:make` command.

## Compile From the Command Line

You can use the bang operator (`!`) to compile. If you need to compile your `.cpp` file with `g++`, run:

```
:!g++ hello.cpp -o hello
```

However, having to manually type the filename and the output filename each time is error-prone and tedious. A makefile is the way to go.

## Makefile

In this section, I will briefly go over makefile basics. If you already know how to use a makefile, feel free to jump to the next section. In the current directory, create a file named `makefile`. Put this inside:

```
all:
	echo "Hello all"
```

Run the `make` command from the terminal:

```
make
```

You will see:

```
echo "Hello all"
Hello all
```

The terminal outputs the echo command itself and its output. You can have multiple "targets" in a makefile. Let's add a few:

```
all:
	echo "Hello all"
foo:
	echo "Hello foo"
list_pls: 
	ls
```

Now you can run the `make` command with different targets:

```
make foo
## returns "Hello foo"

make list_pls
## returns the ls command
```

The `make` command outputs the actual command in addition to the output. To suppress the output of the actual command, append `@` before that command, for example:

```
all:
  @echo "Hello all"
```

Now when you run `make`, you only see "Hello all" and not `echo "Hello all"`.

## `:make`

Vim has a `:make` command to run a makefile. When you run it, Vim looks for a makefile in the current directory to execute.

If you haven't already, create a file named `makefile` in the current directory and put these inside:

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

Vim executes it the same way as when you're running it from the terminal. The `:make` command accepts parameter just like the terminal `make` command. Run:

```
:make foo

:make list_pls
```

The `:make` command uses Vim's `quickfix` to store any error if you run a bad command. Let's run a nonexisting target:

```
:make dontexist
```

You should see an error running that command. To view that error, run the `quickfix` command `:copen` to view the ``quickfix`` window:

```
|| make: *** No rule to make target `dontexist'.  Stop.
```

## Compile With `make`

Let's use the makefile to compile a basic `.cpp` program. First, let's create a `hello.cpp` file:

```
## nclude <iostream>

int main() {
    std::cout << "Hello!\\n";
    return 0;
}
```

Update your `makefile` to build and run a `.cpp` file:

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

## `makeprg`

When you run `:make`, Vim actually runs whatever command that is set under the `makeprg` option. If you run `:set makeprg?`, you'll see:

```
makeprg=make
```

The default `:make` command is the `make` external command. To change the `:make` command to execute `g++ <your-file-name>` each time you run it, run:

```
:set makeprg=g++\\ %
```

The `\\` is to escape the space after `g++` (you need to escape the escape). The `%` symbol in Vim represents the current file. The command `g++\\ %` is equivalent to running `g++ hello.cpp`.

Go to `./hello.cpp` then run `:make`. Vim compiles `hello.cpp` and creates `a.out` because you didn't specify the output. Let's refactor it so it will name the compiled output with the name of the original file minus the extension. Run:

```
:set makeprg=g++\\ %\\ -o\\ %<
```

The breakdown:

- `g++\\ %` is the same as above. It is equivalent to running `g++ <your-file>`.
- `-o` is the output option.
- `%<` in Vim represents the current file name without an extension (`hello.cpp` becomes `hello`).

When you run `:make` from inside `./hello.cpp`, it is compiled into `./hello`. To quickly execute `./hello` from inside `./hello.cpp`, run `:!./%<`. Again, this is the same as running `:!./<current-file-name-minus-the-extension>`.

For more, check out `:h :compiler` and `:h write-compiler-plugin`.

## Auto-Compile On Save

You can further make life easier by automating compilation. Recall that you can use Vim's `autocommand` to automate actions based on certain events. To automatically compile `.cpp` files on each save:

```
:autocmd BufWritePost *.cpp make
```

Each time you save inside a `.cpp` file, Vim executes the `make` command.

## Switching Compiler

Vim has a `:compiler` command to quickly switch compilers. Your Vim build probably comes with several pre-built compiler configurations. To check what compilers you have, run:

```
:e $VIMRUNTIME/compilers/<tab>
```

You should see a list of compilers for different programming languages.

To use the `:compiler` command, suppose you have a ruby file, `hello.rb`, and inside it has:

```
puts "Hello ruby"
```

Recall that if you run `:make`, Vim executes whatever command is assigned to `makeprg` (default is `make`). If you run:

```
:compiler ruby
```

Vim runs the `$VIMRUNTIME/compiler/ruby.vim` script and changes the `makeprg` to use the `ruby` command. Now if you run `:set makeprg?`, it should say `makeprg=ruby` (this depends on what is inside your `$VIMRUNTIME/compiler/ruby.vim` file or if you have another custom ruby compilers. Yours might be different). The `:compiler <your-lang>` command allows you to switch to different compilers  quickly. This is useful if your project uses multiple languages.

You don't have to use the `:compiler` and `makeprg` to compile a program. You can run a test script, lint a file, send a signal, or anything you want. 

You can also create your own custom compilers. Let's create two simple compilers and call them `foo` and `bar` compilers. In your `~/.vim` directory, if there isn't already, add a `/compiler` directory (`~/.vim/compiler`). Inside, create two files: `~/.vim/compiler/foo.vim` and `~/.vim/compiler/bar.vim`. Inside the `foo.vim`, add:

```
if exists("current_compiler")
  finish
endif
let current_compiler = "foo"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=echo\\ \\"Hello\\ foo\\"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: nowrap sw=2 sts=2 ts=8:
```

If most of these sound like gibberish, don't worry. Most of these lines are boilerplates that I got from `$VIMRUNTIME/compiler/<some-language>.vim`. The important line is:

```
CompilerSet makeprg=echo\\ \\"Hello\\ foo\\"
```

This line defines the `makeprg` when you call `:compiler foo`. With this, the makeprg will run an `echo "Hello foo"` command. Since the spaces and double quotes are special characters, you need to escape them.

Inside `bar.vim`, add:

```
if exists("current_compiler")
  finish
endif
let current_compiler = "bar"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=cp\\ %\\ %<

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: nowrap sw=2 sts=2 ts=8:
```

For the `bar` compiler, the `makeprg` is set to run a `cp % %<` command. It copies the current file and name it with the same name minus the extension. If you're running it from `hello.txt`, it will create the file `hello`. 

Let's switch to the `foo` compiler:

```
:compiler foo
```

Then run:

```
:make
```

You should see the echo output:

```
Hello foo
```

Let's quickly switch it to the `bar` compiler. Run:

```
:compiler bar
```

Then run:

```
:make
```

You should see the copy of the current file you're in *without* the extension. If you need to define your own compilers (or set of commands), you can use the `:compiler` method to quickly switch compilers.

## Async Compiler

Sometimes compiling can take a long time. You don't want to be staring at a frozen Vim while waiting for your compilation process to finish. Wouldn't it be nice if you can compile asynchronously so you can still use Vim during compilation?

Luckily there are plugins to run async processes. The two big ones are:

- [vim-dispatch](https://github.com/tpope/vim-dispatch)
- [asyncrun.vim](https://github.com/skywind3000/asyncrun.vim)

In this chapter, I will go over vim-dispatch, but I would strongly encourage you to try all of them out there.

*Vim and NeoVim actually supports async jobs, but they are beyond the scope of this chapter. If you're curious, check out `:h job-channel-overview.txt`.*

## Plugin: Vim-dispatch

Vim-dispatch has several commands, but the two main ones are `:Make` and `:Dispatch` commands.

## `:Make`

Vim-dispatch's `:Make` command is similar to Vim's `:make`, but it runs asynchronously. If you are in a Javascript project and you need to run `npm t`, you might attempt to set your makeprg to be:

```
:set makeprg=npm\\ t
```

If you run:

```
:make
```

Vim will execute `npm t`. Meanwhile, you are just staring at the frozen screen while your Javascript test runs. With vim-dispatch, you can just run:

```
:Make
```

Vim will run `npm t` asynchronously. This way, while `npm t` is running on a background process, you can edit your text with Vim. Neat!

## `:Dispatch`

The `:Dispatch` command works like the `:compiler` and the `:!` command.

Assume that you are inside a ruby spec file and you need to run a test. Run:

```
:Dispatch rspec %
```

Vim will asynchronously run the `rspec` command against the current file (`%`).

## Automating Dispatch

Vim-dispatch has `b:dispatch` buffer variable that you can configure to evaluate specific command. You can leverage it with `autocmd`. If you add this in your vimrc:

```
autocmd BufEnter *_spec.rb let b:dispatch = 'bundle exec rspec %'
```

Now each time you enter a file (`BufEnter`) that ends with `_spec.rb`, running `:Dispatch` automatically executes `bundle exec rspec <your-current-ruby-spec-file>`. 

## Learn Compile The Smart Way

In this chapter, you learned that you can use the `make` and `compiler` commands to run *any* process from inside Vim asynchronously to complement your programming workflow. Vim's ability to extend itself with other programs makes it powerful.

