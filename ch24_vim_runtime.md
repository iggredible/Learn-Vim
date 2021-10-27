# Ch24. Vim Runtime

In the previous chapters, I mentioned that Vim automatically looks for special paths like `pack/` (Ch. 22) and `compiler/` (Ch. 19) inside the `~/.vim/` directory. These are examples of Vim runtime paths.

Vim has more runtime paths than these two. In this chapter, you will learn a high-level overview of these runtime paths. The goal of this chapter is to show you when they are called. Knowing this will allow you to understand and customize Vim further.

## Runtime Path

In a Unix machine, one of your Vim runtime paths is `$HOME/.vim/` (if you have a different OS like Windows, your path might be different). To see what the runtime paths for different OS are, check out `:h 'runtimepath'`. In this chapter, I will use `~/.vim/` as the default runtime path.

## Plugin Scripts

Vim has a plugin runtime path that executes any scripts in this directory once each time Vim starts. Do not confuse the name "plugin" with Vim external plugins (like NERDTree, fzf.vim, etc).

Go to `~/.vim/` directory and create a `plugin/` directory. Create two files: `donut.vim` and `chocolate.vim`.

Inside `~/.vim/plugin/donut.vim`:

```
echo "donut!"
```

Inside `~/.vim/plugin/chocolate.vim`:

```
echo "chocolate!"
```

Now close Vim. The next time you start Vim, you will see both `"donut!"` and `"chocolate!"` echoed. The plugin runtime path can be used for initializations scripts.

## Filetype Detection

Before you start, to ensure that these detections work, make sure that your vimrc contains at least the following line:

```
filetype plugin indent on
```

Check out `:h filetype-overview` for more context. Essentially this turns on Vim's filetype detection.

When you open a new file, Vim usually knows what kind of file it is. If you have a file `hello.rb`, running `:set filetype?` returns the correct response `filetype=ruby`.

Vim knows how to detect "common" file types (Ruby, Python, Javascript, etc). But what if you have a custom file? You need to teach Vim to detect it and assign it with the correct file type.

There are two methods of detection: using file name and file content.

### File Name Detection

File name detection detects a file type using the name of that file. When you open the `hello.rb` file, Vim knows it is a Ruby file from the `.rb` extension.

There are two ways you can do file name detection: using `ftdetect/` runtime directory and using `filetype.vim` runtime file. Let's explore both.

#### `ftdetect/`

Let's create an obscure (yet tasty) file, `hello.chocodonut`. When you open it and you run `:set filetype?`, since it is not a common file name extension Vim doesn't know what to make of it. It returns `filetype=`.

You need to instruct Vim to set all files ending with `.chocodonut` as a "chocodonut" file type. Create a directory named `ftdetect/` in the runtime root (`~/.vim/`). Inside, create a file and name it `chocodonut.vim` (`~/.vim/ftdetect/chocodonut.vim`). Inside this file, add:

```
autocmd BufNewFile,BufRead *.chocodonut set filetype=chocodonut
```

`BufNewFile` and `BufRead` are triggered whenever you create a new buffer and open a new buffer. `*.chocodonut` means that this event will only be triggered if the opened buffer has a `.chocodonut` filename extension. Finally, `set filetype=chocodonut` command sets the file type to be a chocodonut type.

Restart Vim. Now open `hello.chocodonut` file and run `:set filetype?`. It returns `filetype=chocodonut`.

Scrumptious! You can put as many files as you want inside `ftdetect/`. In the future, you can maybe add `ftdetect/strawberrydonut.vim`, `ftdetect/plaindonut.vim`, etc., if you ever decide to expand your donut file types.

There are actually two ways to set a file type in Vim. One is what you just used `set filetype=chocodonut`. The other way is to run `setfiletype chocodonut`. The former command `set filetype=chocodonut` will *always* set the file type to chocodonut type, while the latter command `setfiletype chocodonut` will only set the file type if no file type was set yet.

#### Filetype File

The second file detection method requires you to create a `filetype.vim` in the root directory (`~/.vim/filetype.vim`). Add this inside:

```
autocmd BufNewFile,BufRead *.plaindonut set filetype=plaindonut
```

Create a `hello.plaindonut` file. When you open it and run `:set filetype?`, Vim displays the correct custom file type `filetype=plaindonut`.

Holy pastry, it works! By the way, if you play around with `filetype.vim`, you may notice that this file is being run multiple times when you open `hello.plaindonut`. To prevent this, you can add a guard so the main script is run only once. Update the `filetype.vim`:

```
if exists("did_load_filetypes")
  finish
endif

augroup donutfiletypedetection
  autocmd! BufRead,BufNewFile *.plaindonut setfiletype plaindonut
augroup END
```

`finish` is a Vim command to stop running the rest of the script. The `"did_load_filetypes"` expression is *not* a built-in Vim function. It is actually a global variable from inside `$VIMRUNTIME/filetype.vim`. If you're curious, run `:e $VIMRUNTIME/filetype.vim`. You will find these lines inside:

```
if exists("did_load_filetypes")
  finish
endif

let did_load_filetypes = 1
```

When Vim calls this file, it defines `did_load_filetypes` variable and sets is to 1. 1 is truthy in Vim. You should read the rest of the `filetype.vim` too. See if you can understand what it does when Vim calls it.

### File Type Script

Let's learn how to detect and assign a file type based on the file content.

Suppose you have a collection of files without an agreeable extension. The only thing these files have in common is that they all start with the word "donutify" on the first line. You want to assign these files to a `donut` file type. Create new files named `sugardonut`, `glazeddonut`, and `frieddonut` (without extension). Inside each file, add this line:

```
donutify
```

When you run the `:set filetype?` from inside `sugardonut`, Vim doesn't know what file type to assign this file with. It returns `filetype=`.

In the runtime root path, add a `scripts.vim` file (`~/.vim/scripts.vim`). Inside it, add these:

```
if did_filetype()
  finish
endif

if getline(1) =~ '^\\<donutify\\>'
  setfiletype donut
endif
```

The function `getline(1)` returns the text on the first line. It checks if the first line starts with the word "donutify". The function `did_filetype()` is a Vim built-in function. It will return true when a file type related event is triggered at least once. It is used as a guard to stop re-running file type event.

Open the `sugardonut` file and run `:set filetype?`, Vim now returns `filetype=donut`. If you open another donut files (`glazeddonut` and `frieddonut`), Vim also identifies their file types as `donut` types.

Note that `scripts.vim` is only run when Vim opens a file with an unknown file type. If Vim opens a file with a known file type, `scripts.vim` won't run.

## File Type Plugin

What if you want Vim to run chocodonut-specific scripts when you open a chocodonut file and to not run those scripts when opening plaindonut file?

You can do this with file type plugin runtime path (`~/.vim/ftplugin/`). Vim looks inside this directory for a file with the same name as the file type you just opened. Create a `chocodonut.vim` (`~/.vim/ftplugin/chocodonut.vim`):

```
echo "Calling from chocodonut ftplugin"
```

Create another ftplugin file, `plaindonut.vim` (`~/.vim/ftplugin/plaindonut.vim`):

```
echo "Calling from plaindonut ftplugin"
```

Now each time you open a chocodonut file type, Vim runs the scripts from `~/.vim/ftplugin/chocodonut.vim`. Each time you open a plaindonut file type, Vim runs the scripts from `~/.vim/ftplugin/plaindonut.vim`.

One warning: these files are run each time a buffer file type is set (`set filetype=chocodonut` for example). If you open 3 different chocodonut files, the scripts will be run a *total* of three times.

## Indent Files

Vim has an indent runtime path that works similar to ftplugin, where Vim looks for a file named the same as the opened file type. The purpose of these indent runtime paths is to store indent-related codes. If you have the file `~/.vim/indent/chocodonut.vim`, it will be executed only when you open a chocodonut file type. You can store indent-related codes for chocodonut files here.

## Colors

Vim has a colors runtime path (`~/.vim/colors/`) to store color schemes. Any file that goes inside the directory will be displayed in the `:color` command-line command.

If you have a `~/.vim/colors/beautifulprettycolors.vim` file, when you run `:color` and press Tab, you will see `beautifulprettycolors` as one of the color options. If you prefer to add your own color scheme, this is the place to go.

If you want to check out the color schemes other people made, a good place to visit is [vimcolors](https://vimcolors.com/).

## Syntax Highlighting

Vim has a syntax runtime path (`~/.vim/syntax/`) to define syntax highlighting.

Suppose you have a `hello.chocodonut` file, inside it you have the following expressions:

```
(donut "tasty")
(donut "savory")
```

Although Vim now knows the correct file type, all texts have the same color. Let's add a syntax highlighting rule to highlight the "donut" keyword. Create a new chocodonut syntax file, `~/.vim/syntax/chocodonut.vim`. Inside it add:

```
syntax keyword donutKeyword donut

highlight link donutKeyword Keyword
```

Now reopen `hello.chocodonut` file. The `donut` keywords are now highlighted.

This chapter won't go over syntax highlighting in depth. It is a vast topic. If you are curious, check out `:h syntax.txt`.

The [vim-polyglot](https://github.com/sheerun/vim-polyglot) plugin is a great plugin that provides highlights for many popular programming languages.

## Documentation

If you create a plugin, you will have to create your own documentation. You use the doc runtime path for that.

Let's create a basic documentation for chocodonut and plaindonut keywords. Create a `donut.txt` (`~/.vim/doc/donut.txt`). Inside, add these texts:

```
*chocodonut* Delicious chocolate donut

*plaindonut* No choco goodness but still delicious nonetheless
```

If you try to search for `chocodonut` and `plaindonut` (`:h chocodonut` and `:h plaindonut`), you won't find anything.

First, you need to run `:helptags` to generate new help entries. Run `:helptags ~/.vim/doc/`

Now if you run `:h chocodonut` and `:h plaindonut`, you will find these new help entries. Notice that the file is now read-only and has a "help" file type.

## Lazy Loading Scripts

All of the runtime paths that you learned in this chapter were run automatically. If you want to manually load a script, use the autoload runtime path.

Create an autoload directory (`~/.vim/autoload/`). Inside that directory, create a new file and name it `tasty.vim` (`~/.vim/autoload/tasty.vim`). Inside it:

```
echo "tasty.vim global"

function tasty#donut()
  echo "tasty#donut"
endfunction
```

Note that the function name is `tasty#donut`, not `donut()`. The pound sign (`#`) is required when using the autoload feature. The function naming convention for the autoload feature is:

```
function fileName#functionName()
  ...
endfunction
```

In this case, the file name is `tasty.vim` and the function name is (technically) `donut`.

To invoke a function, you need the `call` command. Let's call that function with `:call tasty#donut()`.

The first time you call the function, you should see *both* echo messages ("tasty.vim global" and "tasty#donut"). The subsequent calls to` tasty#donut` function will only display "testy#donut" echo.

When you open a file in Vim, unlike the previous runtime paths, autoload scripts aren't loaded automatically. Only when you explicitly call `tasty#donut()`, Vim looks for the `tasty.vim` file and loads everything inside it, including the `tasty#donut()` function. Autoload is the perfect mechanism for functions that use extensive resources but you don't use often.

You can add as many nested directories with autoload as you want. If you have the runtime path `~/.vim/autoload/one/two/three/tasty.vim`, you can call the function with `:call one#two#three#tasty#donut()`.

## After Scripts

Vim has an after runtime path (`~/.vim/after/`) that mirrors the structure of `~/.vim/`. Anything in this path is executed last, so developers usually use these paths for script overrides.

For example, if you want to overwrite the scripts from `plugin/chocolate.vim`, you can create `~/.vim/after/plugin/chocolate.vim` to put the override scripts. Vim will run the `~/.vim/after/plugin/chocolate.vim` *after* `~/.vim/plugin/chocolate.vim`.

## $VIMRUNTIME

Vim has an environment variable `$VIMRUNTIME` for default scripts and support files. You can check it out by running `:e $VIMRUNTIME`.

The structure should look familiar. It contains many runtime paths you learned in this chapter.

Recall in Chapter 21, you learned that when you open Vim, it looks for a vimrc files in seven different locations. I said that the last location Vim checks is `$VIMRUNTIME/default.vim`. If Vim fails to find any uservimrc files, Vim uses a `default.vim` as vimrc.

Have you ever tried running Vim without syntax plugin like vim-polyglot and yet your file is still syntatically highlighted? That is because when Vim fails to find a syntax file from the runtime path, Vim looks for a syntax file from `$VIMRUNTIME` syntax directory.

To learn more, check out `:h $VIMRUNTIME`.

## Runtimepath Option

To check your runtimepath, run `:set runtimepath?`

If you use Vim-Plug or popular external plugin managers, it should display a list of directories. For example, mine shows:

```
runtimepath=~/.vim,~/.vim/plugged/vim-signify,~/.vim/plugged/base16-vim,~/.vim/plugged/fzf.vim,~/.vim/plugged/fzf,~/.vim/plugged/vim-gutentags,~/.vim/plugged/tcomment_vim,~/.vim/plugged/emmet-vim,~/.vim/plugged/vim-fugitive,~/.vim/plugged/vim-sensible,~/.vim/plugged/lightline.vim, ...
```

One of the things plugin managers does is adding each plugin into the runtime path. Each runtime path can have its own directory structure similar to `~/.vim/`.

If you have a directory `~/box/of/donuts/` and you want to add that directory to your runtime path, you can add this to your vimrc:

```
set rtp+=$HOME/box/of/donuts/
```

If inside `~/box/of/donuts/`, you have a plugin directory (`~/box/of/donuts/plugin/hello.vim`) and a ftplugin (`~/box/of/donuts/ftplugin/chocodonut.vim`), Vim will run all scripts from `plugin/hello.vim` when you open Vim. Vim will also run `ftplugin/chocodonut.vim` when you open a chocodonut file.

Try this yourself: create an arbitrary path and add it to your runtimepath. Add some of the runtime paths you learned from this chapter. Make sure they work as expected.

## Learn Runtime the Smart Way

Take your time reading it and play around with these runtime paths. To see how runtime paths are being used in the wild, go to the repository of one of your favorite Vim plugins and study its directory structure. You should be able to understand most of them now. Try to follow along and discern the big picture. Now that you understand Vim directory structure, you're ready to learn Vimscript.
