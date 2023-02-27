# Ch00. Read This First

## Why This Guide Was Written

There are many places to learn Vim: the `vimtutor` is a great place to start and the `:help` manual has all the references you will ever need.

However, the average user needs something more than `vimtutor` and less than the `:help` manual. This guide attempts to bridge that gap by highlighting only the key features to learn the most useful parts of Vim in the least time possible.

Chances are you won't need all 100% of Vim features. You probably only need to know about 20% of them to become a powerful Vimmer. This guide will show you which Vim features you will find most useful.

This is an opinionated guide. It covers techniques that I often use when using Vim. The chapters are sequenced based on what I think would make the most logical sense for a beginner to learn Vim.

This guide is examples-heavy. When learning a new skill, examples are indispensable, having numerous examples will solidify these concepts more effectively.

Some of you may wonder why do you need to learn Vimscript? In my first year of using Vim, I was content with just knowing how to use Vim. Time passed and I started needing Vimscript more and more to write custom commands for my specific editing needs. As you are mastering Vim, you will sooner or later need to learn Vimscript. So why not sooner? Vimscript is a small language. You can learn its basics in just four chapters of this guide.

You can go far using Vim without knowing any Vimscript, but knowing it will help you excel even farther.

This guide is written for both beginner and advanced Vimmers. It starts out with broad and simple concepts and ends with specific and advanced concepts. If you're an advanced user already, I would encourage you to read this guide from start to finish anyway, because you will learn something new!

## How to Transition to Vim From Using a Different Text Editor

Learning Vim is a satisfying experience, albeit hard. There are two main approaches to learn Vim:

1. Cold turkey
2. Gradual

Going cold turkey means to stop using whatever editor / IDE you were using and to use Vim exclusively starting now. The downside of this method is you will have a serious productivity loss during the first week or two. If you're a full-time programmer, this method may not be feasible. That's why for most people, I believe the best way to transition to Vim is to use it gradually.

To gradually use Vim, during the first two weeks, spend an hour a day using Vim as your editor while the rest of the time you can use other editors. Many modern editors come with Vim plugins. When I first started, I used VSCode's popular Vim plugin for an hour per day. I gradually increased the time with the Vim plugin until I finally used it all day. Keep in mind that these plugins can only emulate a fraction of Vim features. To experience the full power of Vim like Vimscript, Command-line (Ex) Commands, and external commands integration, you will need to use Vim itself.

There were two pivotal moments that made me start to use Vim 100%: when I grasped that Vim has a grammar-like structure (see chapter 4) and the [fzf.vim](https://github.com/junegunn/fzf.vim) plugin (see chapter 3).

The first, when I realized Vim's grammar-like structure, was the defining moment that I finally understood what these Vim users were talking about. I didn't need to learn hundreds of unique commands. I only had to learn a small handful of commands and I could chain in a very intuitive way to do many things.

The second, the ability to quickly run a fuzzy file-search was the IDE feature that I used most. When I learned how to do that in Vim, I gained a major speed boost and never looked back ever since.

Everyone programs differently. Upon introspection, you will find that there are one or two features from your favorite editor / IDE that you use all the time. Maybe it was fuzzy-search, jump-to-definition, or quick compilation. Whatever they may be, identify them quickly and learn how to implement those in Vim (chances are Vim can probably do them too). Your editing speed will receive a huge boost.

Once you can edit at 50% of the original speed, it's time to go full-time Vim.

## How to Read This Guide

This is a practical guide. To become good in Vim you need to develop your muscle memory, not head knowledge.

You don't learn how to ride a bike by reading a guide about how to ride a bike. You need to actually ride a bike.

You need to type every command referred in this guide. Not only that, but you need to repeat them several times and try different combinations. Look up what other features the command you just learned has. The `:help` command and search engines are your best friends. Your goal is not to know everything about a command, but to be able to execute that command naturally and instinctively.

As much as I try to fashion this guide to be linear, some concepts in this guide have to be presented out-of-order. For example in chapter 1, I mention the substitute command (`:s`), even though it won't be covered until chapter 12. To remedy this, whenever a new concept that has not been covered yet is mentioned early, I will provide a quick how-to guide without a detailed explanation. So please bear with me :).

## More Help

Here's one extra tip to use the help manual: suppose you want to learn more about what `Ctrl-P` does in insert mode. If you merely search for `:h CTRL-P`, you will be directed to normal mode's `Ctrl-P`. This is not the `Ctrl-P` help that you're looking for. In this case, search instead for `:h i_CTRL-P`. The appended `i_` represents the insert mode. Pay attention to which mode it belongs to.

## Syntax

Most of the command or code-related phrases are in code-case (`like this`).

Strings are surrounded by a pair of double-quotes ("like this").

Vim commands can be abbreviated. For example, `:join` can be abbreviated as `:j`. Throughout the guide, I will be mixing the shorthand and the longhand descriptions. For commands that are not frequently used in this guide, I will use the longhand version. For commands that are frequently used, I will use the shorthand version. I apologize for the inconsistencies. In general, whenever you spot a new command, always check it on `:help` to see its abbreviations.

## Vimrc

At various points in the guide, I will refer to vimrc options. If you're new to Vim, a vimrc is like a config file.

Vimrc won't be covered until chapter 21. For the sake of clarity, I will show briefly here how to set it up.

Suppose you need to set the number options (`set number`). If you don't have a vimrc already, create one. It is usually placed in your home directory and named `.vimrc`. Depending on your OS, the location may differ. In macOS, I have it on `~/.vimrc`. To see where you should put yours, check out `:h vimrc`.

Inside it, add `set number`. Save it (`:w`), then source it (`:source %`). You should now see line numbers displayed on the left side.

Alternatively, if you don't want to a make permanent setting change, you can always run the `set` command inline, by running `:set number`. The downside of this approach is that this setting is temporary. When you close Vim, the option disappears.

Since we are learning about Vim and not Vi, a setting that you must have is the `nocompatible` option. Add `set nocompatible` in your vimrc. Many Vim-specific features are disabled when it is running on `compatible` option.

In general, whenever a passage mentions a vimrc option, just add that option into vimrc, save it, and source it.

## Future, Errors, Questions

Expect more updates in the future. If you find any errors or have any questions, please feel free to reach out.

I also have planned a few more upcoming chapters, so stay tuned!

## I Want More Vim Tricks

To learn more about Vim, please follow [@learnvim](https://twitter.com/learnvim).

## Thank Yous

This guide wouldn't be possible without Bram Moleenar for creating Vim, my wife who had been very patient and supportive throughout the journey, all the [contributors](https://github.com/iggredible/Learn-Vim/graphs/contributors) of the learn-vim project, the Vim community, and many, many others that weren't mentioned.

Thank you. You all help make text editing fun :)


## Link
- Next [Ch01. Starting Vim](./ch01_starting_vim.md)
