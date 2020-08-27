# Opening and Searching Files

The goal of this chapter is to introduce you to opening and searching files in Vim. Being able to search quickly is a great way to jump-start your Vim productivity. One reason it took me a long time to get onboard with Vim is because I didn't know how to find things quickly like many popular text editors. 

This chapter is divided into two parts. In the first part, I will show you how to open and search files without plugins. In the second part, I will show you how to open and search files with [FZF.vim](https://github.com/junegunn/fzf.vim) plugin. Feel free to jump to whichever section you need to learn.  However, I highly recommend you to go through everything. With that said, let's get started!

# Opening and Editing Files with `:edit`
`:edit` is the simplest way to open a file in Vim. 

```
:edit file.txt
```
- If `file.txt` exists, it opens `file.txt` buffer.
- If `file.txt` doesn't exist, it creates a new buffer for `file.txt`.


Autocomplete (`tab`) works with `:edit`. For example, if your file is inside a [Rails](https://rubyonrails.org/) controller directory `./app/controllers/users_controllers.rb`, you can use `tab` to expand the terms quickly:
```
:edit a<tab>c<tab>u<tab>
```

`:edit` accepts wildcards arguments. `*` matches any file in the current directory. If you are only looking for files with `.yml` extension in the current directory, you can run:

```
:edit *.yml<tab>
```
After pressing tab, Vim will give you a list of all `.yml` files in the current directory to choose from.

You can use `**` to search recursively. If you want to look for all `*.md` files in your project, but you are not sure in which directories, you can do this:
```
:edit **/*.md<tab>
```
`:edit` can be used to run `netrw`, Vim's built-in file manager (I will cover this later in this chapter). To do that, give  `:edit` a directory argument instead of file. For example:
```
:edit .
:edit test/unit/
```
`:edit` also accepts an Ex command as an argument (I will cover more on Ex commands in later chapter) when followed by `+`. Here are some examples:

- To go to line number 5 (`:5`): `:edit +5 /test/unit/helper.spec.js`
- To go to the first line containing `"const"` (`/const`): `:edit +/const /test/unit/helper.spec.js`
- To delete all empty lines (`:g/^$/d`): `:edit +g/^$/d test/unit/helper.spec.js`

# Searching Files with `:find`
You can find files with `:find`. For example:

```
:find package.json
:find app/controllers/users_controller.rb
```

Autocomplete also works with `:find`:

```
:find p<tab>                to find package.json
:find a<tab>c<tab>u<tab>    to find app/controllers/users_controller.rb
```

You may notice that `:find` syntax and behavior look like `:edit`'s. The difference is that `:find` finds file in `path`, `:edit` doesn't.

Let's learn a little bit about this `path`. Once you learn how to modify your paths, `:find` can become a powerful searching tool. To check what your paths are, do:
```
:set path?
```

By default, yours probably look like this:

```
path=.,/usr/include,,
```

Here are what they mean:
- `.` means to search relative to the directory of the current file
- `,` means to search in the current directory
- `/usr/include` is a [directory](https://askubuntu.com/questions/191611/what-is-the-use-of-usr-include-directory).

The take-home here is that you can modify your own paths. Let's assume this is your project structure:
```
▾ app/
  ▸ assets/
  ▾ controllers/
      application_controller.rb
      comments_controller.rb
      users_controller.rb
  ...
```

If you want to go to `users_controller.rb` from root directory, you have to go through several directories (and pressing a considerable amount of tabs). Sometimes you only care about `controllers/` directory, so you want to search immediately inside that directory without going through `app/` and `controllers/` each time you find a file. `path` can shorten that journey.

You can add the `controllers/` directory to `path` with:

```
:set path+=app/controllers/
```

Now that your path is updated, when you type `:find u<tab>`, Vim will also search for `app/controllers/` directory for files starting with "u".

If you have a nested `controllers/` directory, like `app/controllers/account/users_controller.rb`, Vim won't find `users_controllers`. You need to instead add  `:set path+=app/controllers/**`  so autocomplete will find `users_controller.rb`.

You might be thinking to add the entire project directories so when you press `tab`, Vim will search everywhere for that file, like this:
```
:set path+=$PWD/**
```

`$PWD` is the current working directory. If you try to add your entire project to `path` so all files are reachable upon a `tab` press, although this may work for a small project, doing this may slow down your search significantly if you have many files in your project. I recommend adding only the `path` of your most visited files / directories.

Updating `path` takes only a few seconds and doing this will save you a lot of time. 

# Searching in Files with `:grep`

If you need to find in files, you can use grep. Vim has two ways of doing that:
- Internal grep (`:vim`. Yes, it is spelled `:vim`. It is short for `:vimgrep`).
- External grep (`:grep`).

Let's go through internal grep first. `:vim` has the following syntax:

```
:vim /pattern/ file
```

- `/pattern/` is a regex pattern of your search term.
- `file` is the file(s) argument. Just like `:find`, you can pass it `*` and `**` wildcards.

For example, to look for all occurrences of "foo" string inside all ruby files (`.rb`) inside `app/controllers/` directory:

```
:vim /foo/ app/controllers/**/*.rb
```
 
After running that command, you will be redirected to the first result. Vim's `vim` search command uses `quickfix` operation. To see all search results, run `:copen`. This opens a `quickfix` window. Here are some useful quickfix commands to get you productive immediately:

```
:copen        Open the quickfix window
:cclose       Close the quickfix window
:cnext        Go to the next error
:cprevious    Go to the previous error
:colder       Go to the older error list
:cnewer       Go to the newer error list
```

I won't cover quickfix too deep here. To learn more about quickfix, check out `:h quickfix`.

You may notice that running internal grep (`:vim`) can get slow if you have a large number of matches. This is because it reads them into memory. Vim loads each matching files as if they are being edited.

Let's talk about external grep. By default, it uses `grep` terminal command. To search for "foo" inside a ruby file inside `app/controllers/` directory, you can do this:

```
:grep "foo" app/controllers/**/*.rb
```

Just like `:vim`, `:grep` accepts `*` and `**` wildcards. It also displays all matches using `quickfix`.

Vim uses `grepprg` variable to determine which external program to run when running `:grep` so you don't have to always use the terminal `grep` command. Later in this article, I will show you how to change default the external command.

# Browsing Files with `netrw`

`netrw` is Vim's built-in file explorer. It is useful to see a project's structural hierarchy. To run `netrw`, you need these two settings in your `.vimrc`:

```
set nocp
filetype plugin on
```

I will only cover the basic use of `netrw` here, but it should be enough to get you started. You can start `netrw` when you launch Vim and passing it a directory instead of a file. For example:

```
vim .
vim src/client/
vim app/controllers/
```

To launch `netrw` from inside Vim, you can use `:edit` and pass it a directory instead of a filename:

```
:edit .
:edit src/client/
:edit app/controllers/
```

There are other ways to launch `netrw` window without passing a directory:

```
:Explore     Starts netrw on current file
:Sexplore    Not kidding. Starts netrw on split top half of the screen
:Vexplore    Starts netrw on split left half of the screen
```

You can navigate `netrw` with Vim motions (I will cover these on chapter 5). If you need to create, delete, and rename file/directory, here is a list of useful `netrw` commands:

```
%    Create a new file
d    Create a new directory
R    Rename a file or directory
D    Delete a file or directory
```

`:h netrw` is very comprehensive. Check it out if you have time.

If you find `netrw` too bland and need more flavor, [vim-vinegar](https://github.com/tpope/vim-vinegar) is a good plugin to improve `netrw`. If you're looking for a different file explorer, [NERDTree](https://github.com/preservim/nerdtree) is a good alternative. Check them out!

# FZF

Now that you've learned how to open and search files in Vim with built-in tools, it's time to use plugins to level up your search game.

One thing that modern text editors got right that Vim didn't is how easy it is to find files and to find in files . In this second half of the chapter, I will show you how to use [FZF.vim](https://github.com/junegunn/fzf.vim) to make searching in Vim easy and powerful.

# Setup

But first, make sure you have [FZF](https://github.com/junegunn/fzf) and [ripgrep](https://github.com/BurntSushi/ripgrep) download. Follow the instruction on their github repo. The commands `fzf` and `rg` should now be available after successful installs.

Ripgrep is a search tool much like grep (hence the name). It is generally faster than grep and has many useful features. FZF is a general-purpose command-line fuzzy finder. You can use it with any commands, including ripgrep. Together, they make a powerful search tool combination.

FZF does not use ripgrep by default, so we need to tell FZF to use ripgrep with `FZF_DEFAULT_COMMAND` variable. In my `.zshrc` (`.bashrc` if you use bash), I have these:
```
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m'
fi
```


Pay attention to `-m` in `FZF_DEFAULT_OPTS`. This option allows us to make multiple selections with `tab` or `shift-tab`. You don't have to have this line to make FZF work with Vim, but I think it is a useful option to have. It will come in handy when you want to perform search and replace in multiple files which I'll cover in just a little bit. `FZF` accepts more options, to learn more, check out [fzf's repo](https://github.com/junegunn/fzf#usage) or `man fzf`. At minimum you should have `export FZF_DEFAULT_COMMAND='rg'`.

After installing FZF and ripgrep, let's set up FZF plugin. I am using [vim-plug](https://github.com/junegunn/vim-plug) plugin manager in this example, but you can use any plugin managers.

Add these inside your `.vimrc` plugins. You need to use [FZF.vim](https://github.com/junegunn/fzf.vim) plugin (created by the same FZF author).
```
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
```

For more info about this plugin, you can check out [FZF.vim repo](https://github.com/junegunn/fzf/blob/master/README-VIM.md).

# FZF Syntax

To be able to use FZF efficiently, you should learn some basic FZF syntax. Fortunately, the list is short:

- `^` is a prefix exact match. To search for a phrase starting with "welcome": `^welcome`.
- `$` is a suffix exact match. To search for a phrase ending with "my friends": `friends$`.
- `'` is an exact match. To search for the phrase "welcome my friends": `'welcome my friends`.
- `|` is an "or" match. To search for either "friends" or "foes": `friends | foes`.
- `!` is an inverse match. To search for phrase containing "welcome" and not "friends": `welcome !friends`

You can mix and match these options. For example, `^hello | ^welcome friends$` will search for the phrase starting with either "welcome" or "hello" and ending with "friends".

# Finding Files

To search for files inside Vim using FZF.vim plugin, you can use the `:Files` method. Run `:Files` from Vim and you will be prompted with FZF search prompt.

<p align="center">
  <img alt="Finding files in FZF" width="900" height="auto" src="./img/fzf-files.gif">
</p>


Since you will be using this command frequently, it is good to have this mapped. I map mine with `Ctrl-f`. In my `.vimrc`, I have this:

```
nnoremap <silent> <C-f> :Files<CR>
```

# Finding in Files
To search inside files, you can use the `:Rg` command. 

<p align="center">
  <img alt="FInding in Files in FZF" width="900" height="auto" src="./img/fzf-in-files.gif">
</p>


Again, since you will probably use this frequently, let's map it. I map mine with `<Leader>f`.

```
nnoremap <silent> <Leader>f :Rg<CR>
``` 

# Other Searches

FZF.vim provides many other search commands. I won't go through each one of them here, but you can check them out [here](https://github.com/junegunn/fzf.vim#commands).

Here's what my FZF mappings look like. Feel free to borrow from mine to create your own powerful set of mappings!
```
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <Leader>f :Rg<CR>
nnoremap <silent> <Leader>/ :BLines<CR>
nnoremap <silent> <Leader>' :Marks<CR>
nnoremap <silent> <Leader>g :Commits<CR>
nnoremap <silent> <Leader>H :Helptags<CR>
nnoremap <silent> <Leader>hh :History<CR>
nnoremap <silent> <Leader>h: :History:<CR>
nnoremap <silent> <Leader>h/ :History/<CR> 
```

# Replacing `grep` with `rg`

As I mentioned earlier, Vim has two ways to search in files: `:vim` and `:grep`. `:grep` uses external search tool that you can reassign using `grepprg` keyword. I will show you how to configure Vim to use ripgrep instead of terminal grep when running the `:grep` command.

Now let's setup `grepprg` so `:grep` uses ripgrep. Add this in your `vimrc`. 
```
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
```
Feel free to modify some of the options above! For more information what the options above mean, check out `man rg`.

After you update `grepprg`, now when you run `:grep`, it will actually run `rg --vimgrep --smart-case --follow` instead of running `grep`.  If you want to search for "foo" using ripgrep, you can now run a more succinct command `:grep "foo"` instead of `:grep "foo" . -R` (in addition,  ripgrep searches faster than grep).

Just like the old `:grep`, this new `:grep` still uses quickfix to display results.

You might wonder, "Well, this is nice but I never used `:grep` in Vim, plus can't I just use `:Rg` to find phrases in files? When will I ever need to use `:grep`?

That is a very good question. You may need to use `:grep` in Vim to do search and replace in multiple files, which I will cover next.

# Search and Replace in Multiple Files

Modern text editors like VSCode make it very easy to search and replace a string across multiple files. In my early Vim days, when I had to search and replace a string in multiple files, I would use [Atom](https://atom.io/) because I couldn't do it easily in Vim. In this section, I will show you two different methods to easily do that in Vim.

The first method is to replace *all* matching phrases in your project. You will need to use `:grep`. If you want to replace all instances of "pizza" with "donut", here's what you do:

```
:grep "pizza"
:cfdo %s/pizza/donut/g | update
```

That's it? Yup! Let me break down the steps:

1. `:grep pizza` uses ripgrep to succinctly search for all instances of "pizza" (by the way, this would still work even if you didn't reassign `grepprg` to use ripgrep. You would have to do `:grep "pizza" . -R` instead of `:grep "pizza"`). I prefer ripgrep for this task because of its concise syntax.
2. `:cfdo` executes any command you pass to all files in your quickfix list. In this case, your command is the substitution command `%s/pizza/donut/g`. The pipe (`|`) is a chain operator. You need to run `update` to save each file after you substitute it. I will cover substitute command in depth in later chapter.

The second method is to search and replace in select files. With this method, you can manually choose which files you want to perform select and replace on. Here is what you do:

1. Clear your buffers first. It is imperative that your buffer list contains only the files you need. You can clear it with `%bd | e# | bd#` (or restart Vim).
2. Run `:Files`.
3. Select all files you want to perform search and replace on. To select multiple files, use `tab` / `shift+tab`. This is only possible if you have `-m` option in `FZF_DEFAULT_OPTS` (refer to earlier FZF setup section for the `-m` option).
4. Run `:bufdo %s/pizza/donut/g | update`. The command `:bufdo %s/pizza/donut/g | update` looks similar to the earlier `:cfdo %s/pizza/donut/g | update` command. That's because they are. The difference is instead of substituting all quickfix entries (`:cfdo`), you are substituting all buffer entries (`:bufdo`).

# Learn Search the Smart Way

Searching is the bread-and-butter of text editing. Learning how to search well in Vim will help your text editing workflow. 

FZF.vim is a game-changer. I can't imagine using Vim without it.  I think it is very important to have a good search tool when starting Vim. I've seen people struggling to transition to Vim because it is missing critical features modern text editors have, like a powerful and easy search. I was one. I hope this chapter addresses one of the issues and help to make the transition to Vim easier. To improve your searching prowess even more, I suggest to check out [fzf repo](https://github.com/junegunn/fzf).

You also just saw Vim's extensibility in action - the ability to extend search functionality with a plugin and / or an external program. In the future, keep in mind of what other features you wish to extend in Vim. Chances are, someone has created a plugin or there is a program for it already. 

Next, let's talk about a very important topic in Vim: grammar.
