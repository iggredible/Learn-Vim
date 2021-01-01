---
title: "Tags"
metaTitle: "Tags"
metaDescription: "How to use tags to jump to any definition?"
---

One useful feature in text editing is being able to go to any definition quickly. In this chapter, you will learn how to use Vim tags to do that.

## Tag Overview

Suppose someone handed you a new codebase:

```
one = One.new
one.donut
```

`One`? `donut`? Well, these might have been obvious to the developers writing the code way back then, but now those developers are no longer here and it is up to you to understand these obscure lines of codes. One way to help understand this is to follow the source code where `One` and `donut` are defined.

You can search for them with either `fzf` or `grep`, but it is faster to use tags.

Think of tags like an address book:

```
Name    Address
Iggy1   1234 Cool St, 11111
Iggy2   9876 Awesome Ave, 2222
```

Instead of having a name-address pair, tags store definitions paired with addresses.

Let's assume that you have these two Ruby files inside the same directory:

```
## one.rb
class One
  def initialize
    puts "Initialized"
  end

  def donut
    puts "Bar"
  end
end
```

and

```
## two.rb
require './one'

one = One.new
one.donut
```

To jump to a definition, you can use `Ctrl-]` in the normal mode. Inside `two.rb`, go to the line where `one.donut` is and move the cursor over `donut`. Press `Ctrl-]`.

Whoops, Vim could not find the tag file. You need to generate the tag file first.

## Tag Generator

Modern Vim does not come with tag generator, so you will have to download an external tag generator. There are several options to choose:

- ctags = C only. Available almost everywhere.
- exuberant ctags = One of the most popular ones. Has many language support.
- universal ctags = Similar to exuberant ctags, but newer.
- etags = For Emacs. Hmm...
- JTags = Java
- ptags.py = Python
- ptags = Perl
- gnatxref = Ada

If you look at Vim tutorials online, many will recommend [exuberant ctags](http://ctags.sourceforge.net/). It supports [41 programming languages](http://ctags.sourceforge.net/languages.html). I used it and it worked great. However, because it has not been maintained since 2009, Universal ctags would be a better choice. It works similar to exuberant ctags and is currently being maintained.

I won't go into details on how to install the universal ctags. Check out the [universal ctags](https://github.com/universal-ctags/ctags) repository for more instructions. Once you have the universal ctags installed, run `ctags --version`. It should show:

```
Universal Ctags 0.0.0(b43eb39), Copyright (C) 2015 Universal Ctags Team
Universal Ctags is derived from Exuberant Ctags.
Exuberant Ctags 5.8, Copyright (C) 1996-2009 Darren Hiebert
```

Make sure that you see "`Universal Ctags`".

Next, let's generate a basic tag file. Run:

```
ctags -R .
```

The `R` option tells `ctags` to run a recursive scan from your current location (`.`). You should see a `tags` file in your current directory. Inside you will see something like this:

```
!_TAG_FILE_FORMAT	2	/extended format; --format=1 will not append ;" to lines/
!_TAG_FILE_SORTED	1	/0=unsorted, 1=sorted, 2=foldcase/
!_TAG_OUTPUT_FILESEP	slash	/slash or backslash/
!_TAG_OUTPUT_MODE	u-ctags	/u-ctags or e-ctags/
!_TAG_PATTERN_LENGTH_LIMIT	96	/0 for no limit/
!_TAG_PROGRAM_AUTHOR	Universal Ctags Team	//
!_TAG_PROGRAM_NAME	Universal Ctags	/Derived from Exuberant Ctags/
!_TAG_PROGRAM_URL	<https://ctags.io/>	/official site/
!_TAG_PROGRAM_VERSION	0.0.0	/b43eb39/
One	one.rb	/^class One$/;"	c
donut	one.rb	/^  def donut$/;"	f	class:One
initialize	one.rb	/^  def initialize$/;"	f	class:One
```

Yours might look a little different depending on your Vim setting and the ctags generator. A tag file is composed of two parts: the tag metadata and the tag list. These metadata (`!TAG_FILE...`) are usually controlled by the ctags generator. I won't discuss it here, but feel free to check the documentation!

Now go to `two.rb`, put the cursor on `donut`, and type `Ctrl-]`. Vim will take you to the file `one.rb` on the line where `def donut` is. Success! But how did Vim do this?

## Tags Anatomy

Let's look at the `donut` tag item:

```
donut	one.rb	/^  def donut$/;"	f	class:One
```

The above tag item is composed of four components: a `tagname`, a `tagfile`, a `tagaddress`, and tag options.

- `donut` is the `tagname`. When your cursor is on "donut", Vim searches the tag file for a line that has the "donut" string.
- `one.rb` is the `tagfile`. Vim looks for a file `one.rb`.
- `/^ def donut$/` is the `tagaddress`. `/.../` is a pattern indicator. `^` is a pattern for the first element on a line. It is followed by two spaces , then the string `def donut`. Finally, `$` is a pattern for the last element on a line.
- `f class:One` is the tag option that tells Vim that the function `donut` is a function (`f`) and is part of the `One` class.

Let's look at another item in the tag list:

```
One	one.rb	/^class One$/;"	c
```

This line works the same way as the `donut` pattern:

- `One` is the `tagname`. Note that with tags, the first scan is case sensitive. If you have `One` and `one` on the list, Vim will prioritize `One` over `one`.
- `one.rb` is the `tagfile`. Vim looks for a file `one.rb`.
- `/^class One$/` is the `tagaddress` pattern. Vim looks for a line that starts with (`^`) `class` and ends with (`$`) `One`.
- `c` is one of the possible tag options. Since `One` is a ruby class and not a procedure, it marks it with a `c`.

Depending on which tag generator you use, the content of your tag file may look different. At minimum, a tag file must have either one of these formats:

```
1.  {tagname} {TAB} {tagfile} {TAB} {tagaddress}
2.  {tagname} {TAB} {tagfile} {TAB} {tagaddress} {term} {field} ..
```

## The Tag File

You have learned that a new file, `tags`, is created after running `ctags -R .`. How does Vim know where to look for the tag file?

If you run `:set tags?`, you might see `tags=./tags,tags` (depending on your Vim settings, it might be different). Here Vim looks for all tags in the path of the current file in the case of `./tags` and the current directory (your project root) in the case of `tags`.

Also in the case of `./tags`, Vim will first look for a tag file inside the path of your current file regardless how nested it is, then it will look for a tag file of the current directory (project root). Vim stops after it finds the first match.

If your `'tags'` file had said `tags=./tags,tags,/user/iggy/mytags/tags`, then Vim will also look at the `/user/iggy/mytags` directory for a tag file after Vim finishes searching `./tags` and `tags` directory. You don't have to store your tag file inside your project, you can keep them separate.

To add to a tag file location, just run:

```
:set tags+=path/to/my/tags/file
```

## Generating Tags For A Large Project.

If you tried to run ctags in a large project, it may take a long time because Vim also looks inside every nested directories. If you are a Javascript developer, you know that `node_modules` can be very large. Imagine if you have a five sub-projects and each contains its own `node_modules` directory. If you run `ctags -R .`, ctags will try to scan through all 5 `node_modules`. You probably don't need to run ctags on `node_modules`.

To run ctags excluding the `node_modules`, run:

```
 ctags -R --exclude=node_modules .
```

This time it should take less than a second. By the way, you can use the `exclude` option multiple times:

```
ctags -R --exclude=.git --exclude=vendor --exclude=node_modules --exclude=db --exclude=log .
```

## Tags Navigation

You can get good milage using only `Ctrl-]`, but let's learn a few more tricks. The tag jump key `Ctrl-]` has an command-line mode alternative: `:tag my-tag`. If you run:

```
:tag donut
```

Vim will jump to the `donut` method, just like doing `Ctrl-]` on "donut" string. You can autocomplete the argument too, with `<Tab>`:

```
:tag d<Tab>
```

Vim lists all tags that starts with "d". In this case, "donut".

In a real project, you may encounter multiple methods with the same name. Let's update the two files. Inside `one.rb`:

```
## one.rb
class One
  def initialize
    puts "Initialized"
  end

  def donut
    puts "one donut"
  end

  def pancake
    puts "one pancake"
  end
end
```

And `two.rb`:

```
## two.rb
require './one.rb'

def pancake
  "Two pancakes"
end

one = One.new
one.donut
puts pancake
```

If you are coding along, don't forget to run `ctags -R .` again since you now have several new procedures. You have two instances of the `pancake` procedure. If you are inside `two.rb` and you pressed `Ctrl-]`, what would happen?

Vim will jump to `def pancake` inside `two.rb`, not the `def pancake` inside `one.rb`. This is because Vim sees the `pancake` procedure inside `two.rb` as having a higher priority than the other `pancake` procedure.

## Tag Priority

Not all tags are equal. Some tags have higher priorities. If Vim is presented with duplicate item names, Vim checks the priority of the keyword. The order is:

1. A fully matched static tag in the current file.
2. A fully matched global tag in the current file.
3. A fully matched global tag in a different file.
4. A fully matched static tag in another file.
5. A case-insensitively matched static tag in the current file.
6. A case-insensitively matched global tag in the current file.
7. A case-insensitively matched global tag in the a different file.
8. A case-insensitively matched static tag in the current file.

According to the priority list, Vim prioritizes the exact match found on the same file. That's why Vim chooses the `pancake` procedure inside `two.rb` over the `pancake` procedure inside `one.rb`. There are some exceptions to the priority list above depending on your `'tagcase'`, `'ignorecase'`, and `'smartcase'` settings, but I will not discuss them here. If you are interested, check out `:h tag-priority`.

## Selective Tag Jumps

It would be nice if you can choose which tag items to jump to instead of always going to the highest priority tag item. Maybe you actually need to jump to the `pancake` method in `one.rb` and not the one in `two.rb`. To do that, you can use `:tselect`. Run:

```
:tselect pancake
```

You will see, on the bottom of the screen:

```
## pri kind tag               file
1 F C f    pancake           two.rb
             def pancake
2 F   f    pancake           one.rb
             class:One
             def pancake
```

If you type `2` then `<Return>`, Vim will jump to the procedure in `one.rb`. If you type `1` then `<Return>`, Vim will jump to the procedure in `two.rb`.

Pay attention to the `pri` column. You have `F C` on the first match and `F` on the second match. This is what Vim uses to determine the tag priotity. `F C` means a fully-matched (`F`) global tag in the current (`C`) file. `F` means only a fully-matched (`F`) global tag. `F C` always have a higher priority than `F`.

If you run `:tselect donut`, Vim also prompts you to select which tag item to jump to, even though there is only one option to choose from. Is there a way for Vim to prompt the tag list only if there are multiple matches and to jump immediately if there is only one tag found?

Of course! Vim has a `:tjump` method. Run:

```
:tjump donut
```

Vim will immediately jump to the `donut` procedure in `one.rb`, much like running `:tag donut`. Now run:

```
:tjump pancake
```

Vim will prompt you tag options to choose from, much like running `:tselect pancake`. With `tjump` You get the best of both methods.

Vim has a normal mode key for `tjump`: `g Ctrl-]`. I personally like `g Ctrl-]` better than `Ctrl-]`.

## Autocompletion With Tags

Tags can assist autocompletions. Recall from chapter 6, Insert Mode, that you can use `Ctrl-x` sub-mode to do various autocompletions. One autocompletion sub-mode that I did not mention was `Ctrl-]`. If you do `Ctrl-x Ctrl-]` while in the insert mode, Vim will use the tag file for autocompletion.

If you go into the insert mode and type `Ctrl-x Ctrl-]`, you will see:

```
One
donut
initialize
pancake
```

## Tag Stack

Vim keeps a list of all the tags you have jumped to and from in a tag stack. You can see this stack with `:tags`. If you had first tag-jumped to `pancake`, followed by `donut`, and run `:tags`, you will see:

```
  # TO tag         FROM line  in file/text
  1  1 pancake            10  ch16_tags/two.rb
  2  1 donut               9  ch16_tags/two.rb
>
```

Note the `>` symbol above. It shows your current position in the stack. To "pop" the stack to go back to one previous stack, you can run `:pop`. Try it, then run `:tags` again:

```
  # TO tag         FROM line  in file/text
  1  1 pancake            10  puts pancake
> 2  1 donut               9  one.donut

```

Note that the `>` symbol is now on line two, where the `donut` is. `pop` one more time, then run `:tags` again:

```
  # TO tag         FROM line  in file/text
> 1  1 pancake            10  puts pancake
  2  1 donut               9  one.donut
```

In normal mode, you can run `Ctrl-t` to achieve the same effect as `:pop`.

## Automatic Tag Generation

One of the biggest drawbacks of Vim tags is that each time you make a significant change, you have to regenerate the tag file. If you recently renamed the `pancake` procedure to the `waffle` procedure, the tag file did not know that the `pancake` procedure had been renamed. It still stored `pancake` in the list of tags. You have to run `ctags -R .` to create an updated tag file. Recreating a new tag file can be cumbersome.

Luckily there are several methods you can employ to generate tags automatically. My goal in this section is not to create a foolproof process, but to suggest some ideas so you can expand them.

## Generate A Tag On Save

Vim has an autocommand (`autocmd`) method to execute any command on an event trigger. You can use this to generate tags on each save. Run:

```
:autocmd BufWritePost *.rb silent !ctags -R .
```

Breakdown:

- `autocmd` is Vim's autocommand method. It accepts an event name, file pattern, and a command.
- `BufWritePost` is an event for saving a buffer. Each time you save a file, you trigger a `BufWritePost` event.
- `.rb` is a file pattern for ruby (`rb`) files.
- `silent` is actually part of the command you are passing. Without this, Vim will display `press ENTER or type command to continue` each time you trigger the autocommand.
- `!ctags -R .` is the command to execute. Recall that `!cmd` from inside Vim executes terminal command.

Now each time you save from inside a ruby file, Vim will run `ctags -R .`.

Add a new procedure in `two.rb`:

```
def waffle
  "Two waffles"
end
```

Save the file. If you check the tag file, you will see `waffle` as part of the tags. Success!

## Using Plugins

There are several plugins to generate ctags automatically:

- [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)
- [vim-tags](https://github.com/szw/vim-tags)
- [vim-easytags](https://github.com/xolox/vim-easytags)
- [vim-autotag](https://github.com/craigemery/vim-autotag)

I use vim-gutentags. If you use a Vim plugin manager ([vim-plug](https://github.com/junegunn/vim-plug), [vundle](https://github.com/VundleVim/Vundle.vim), [dein.vim](https://github.com/Shougo/dein.vim), etc), just install the plugin and it will work right ouf of the box!

## Ctags And Git Hooks

Tim Pope, author of many great Vim plugins, wrote a blog suggesting to use git hooks. [Check it out](https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html).

## Learn Tags The Smart Way

A tag is useful once configured properly. If you are like me and you forget things easily, tags can help you visualize a project.

Suppose you are faced with a new codebase and you want to understand what `functionFood` does, you can easily read it by jumping to its definition. Inside it, you learn that it also calls `functionBreakfast`. You follow it and you learn that it calls `functionPancake`. Your function call graph looks something like this:

```
functionFood -> functionBreakfast -> functionPancake
```

This gives you insight that this code flow is related to having a pancake for breakfast.

To learn more about tags, check out `:h tags`. Now that you know how to use tags, let's explore a different feature: folding.
