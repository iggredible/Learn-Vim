# Ch02. Buffers, Windows, and Tabs

If you used a modern text editor before, you are probably familiar with windows and tabs. Vim uses three display abstractions instead of two: buffers, windows, and tabs. In this chapter, I will explain what buffers, windows, and tabs are and how they work in Vim.

Before you start, make sure you have the `set hidden` option in vimrc. Without it, whenever you switch buffers and your current buffer is not saved, Vim will prompt you to save the file (you don't want that if you want to move quickly). I haven't covered vimrc yet. If you don't have a vimrc, create one. It is usually placed in your home directory and is named `.vimrc`. I have mine on `~/.vimrc`. To see where you should create your vimrc, check out `:h vimrc`. Inside it, add:

```
set hidden
```

Save it, then source it (run `:source %` from inside the vimrc).

## Buffers

What is a *buffer*?

A buffer is an in-memory space where you can write and edit some text. When you open a file in Vim, the data is bound to a buffer. When you open 3 files in Vim, you have 3 buffers.

Have two empty files, `file1.js` and `file2.js` available (if possible, create them with Vim). Run this in the terminal:

```bash
vim file1.js
```

What you are seeing is `file1.js` *buffer*. Whenever you open a new file, Vim creates a new buffer.

Exit Vim. This time, open two new files:

```bash
vim file1.js file2.js
```

Vim currently displays `file1.js` buffer, but it actually creates two buffers: `file1.js` buffer and `file2.js` buffer. Run `:buffers` to see all the buffers (alternatively, you can use `:ls` or `:files` too). You should see *both* `file1.js` and `file2.js` listed. Running `vim file1 file2 file3 ... filen` creates n amount of buffers. Each time you open a new file, Vim create a new buffer for that file.

There are several ways you can traverse buffers:
- `:bnext` to go to the next buffer (`:bprevious` to go to the previous buffer).
- `:buffer` + filename. Vim can autocomplete filename with `<Tab>`.
- `:buffer` + `n`, where `n` is the buffer number. For example, typing `:buffer 2` will take you to buffer #2.
- Jump to the older position in the jump list with `Ctrl-O` and to the newer position with `Ctrl-I`. These are not buffer specific methods, but they can be used to jump between different buffers. I will explain jumps in further details in Chapter 5.
- Go to the previously edited buffer with `Ctrl-^`.

Once Vim creates a buffer, it will remain in your buffers list. To remove it, you can type `:bdelete`. It can also accept a buffer number as a parameter (`:bdelete 3` to delete buffer #3) or a filename (`:bdelete` then use `<Tab>` to autocomplete).

The hardest thing for me when learning about buffers was visualizing how they worked because my mind was used to windows from when using a mainstream text editor. A good analogy is a deck of playing cards. If I have 2 buffers, I have a stack of 2 cards. The card on top is the only card I see, but I know there are cards below it. If I see `file1.js` buffer displayed then the `file1.js` card is on the top of the deck. I can't see the other card, `file2.js` here, but it's there. If I switch buffers to `file2.js`, that `file2.js` card is now on the top of the deck and `file1.js` card is below it.

If you haven't used Vim before, this is a new concept. Take your time to understand it.

## Exiting Vim

By the way, if you have multiple buffers opened, you can close all of them with quit-all:

```
:qall
```

If you want to close without saving your changes, just add `!` at the end:

```
:qall!
```

To save and quit all, run:

```
:wqall
```

## Windows

A window is a viewport on a buffer. If you're coming from a mainstream editor, this concept may be familiar to you. Most text editors have the ability to display multiple windows. In Vim, you can also have multiple windows.

Let's open `file1.js` from the terminal again:

```bash
vim file1.js
```

Earlier I wrote that you're looking at `file1.js` buffer. While that was correct, that statement was incomplete. You are looking at the `file1.js` buffer, displayed through **a window**. A window is how you are viewing a buffer through.

Don't quit Vim yet. Run:

```
:split file2.js
```

Now you are looking at two buffers through **two windows**. The top window displays `file2.js` buffer. The bottom window displays `file1.js` buffer.

If you want to navigate between windows, use these shortcuts:

```
Ctrl-W h    Moves the cursor to the left window
Ctrl-W j    Moves the cursor to the window below
Ctrl-W k    Moves the cursor to the window upper
Ctrl-W l    Moves the cursor to the right window
```

Now run:

```
:vsplit file3.js
```

You are now seeing three windows displaying three buffers. One window displays `file3.js` buffer, another window displays `file2.js` buffer, and another window displays `file1.js` buffer.

You can have multiple windows displaying the same buffer. While you're on the top left window, type:

```
:buffer file2.js
```

Now both two windows are displaying `file2.js` buffer. If you start typing on a `file2.js` window, you will see that both windows that display `file2.js` buffers are being updated in real-time.

To close the current window, you can run `Ctrl-W C` or type `:quit`. When you close a window, the buffer will still be there (run `:buffers` to confirm this).

Here are some useful normal-mode window commands:

```
Ctrl-W V    Opens a new vertical split
Ctrl-W S    Opens a new horizontal split
Ctrl-W C    Closes a window
Ctrl-W O    Makes the current window the only one on screen and closes other windows
```

And here is a list of useful window command-line commands:

```
:vsplit filename    Split window vertically
:split filename     Split window horizontally
:new filename       Create new window
```

Take your time to understand them. For more information, check out `:h window`.

## Tabs

A tab is a collection of windows. Think of it like a layout for windows. In most modern text editors (and modern internet browsers), a tab means an open file / page and when you close it, that file / page goes away. In Vim, a tab does not represent an opened file. When you close a tab in Vim, you are not closing a file. You are only closing the layout. The files opened in that layout are still not closed, they are still opened in their buffers.

Let's see Vim tabs in action. Open `file1.js`:

```bash
vim file1.js
```

To open `file2.js` in a new tab:

```
:tabnew file2.js
```

You can also let Vim autocomplete the file you want to open in a *new tab* by pressing `<Tab>` (no pun intended).

Below is a list of useful tab navigations:

```
:tabnew file.txt    Open file.txt in a new tab
:tabclose           Close the current tab
:tabnext            Go to next tab
:tabprevious        Go to previous tab
:tablast            Go to last tab
:tabfirst           Go to first tab
```

You can also run `gt` to go to next tab page (you can go to previous tab with `gT`). You can pass count as argument to `gt`, where count is tab number. To go to the third tab, do `3gt`.

One advantage of having multiple tabs is you can have different window arrangements in different tabs. Maybe you want your first tab to have 3 vertical windows and second tab to have a mixed horizontal and vertical windows layout. Tab is the perfect tool for the job!

To start Vim with multiple tabs, you can do this from the terminal:

```bash
vim -p file1.js file2.js file3.js
```

## Moving in 3D

Moving between windows is like traveling two-dimensionally along the X-Y axis in Cartesian coordinates. You can move to the top, right, bottom, and left window with `Ctrl-W H/J/K/L`.

Moving between buffers is like traveling across the Z axis in Cartesian coordinates. Imagine your buffer files lining up across the Z axis. You can traverse the Z axis one buffer at a time with `:bnext` and `:bprevious`. You can jump to any coordinate in Z axis with `:buffer filename/buffernumber`.

You can move in *three-dimensional space* by combining window and buffer movements. You can move to the top, right, bottom, or left window (X-Y navigations) with window movements. Since each window contains buffers, you can move forward and backward (Z navigations) with buffer movements.

## Using Buffers, Windows, and Tabs the Smart Way

You have learned what buffers, windows, and tabs are and how they work in Vim. Now that you understand them better, you can use them in your own workflow.

Everyone has a different workflow, here is mine for example:
- First, I use buffers to store all the required files for the current task. Vim can handle many opened buffers before it starts slowing down. Plus having many buffers opened won't crowd my screen. I am only seeing one buffer (assuming I only have one window) at any time, allowing me to focus on one screen. When I need to go somewhere, I can quickly fly to any open buffer anytime.
- I use multiple windows to view multiple buffers at once, usually when diffing files, reading docs, or following a code flow. I try to keep the number of windows opened to no more than three because my screen will get crowded (I use a small laptop). When I am done, I close any extra windows. Fewer windows means less distractions.
- Instead of tabs, I use [tmux](https://github.com/tmux/tmux/wiki) windows. I usually use multiple tmux windows at once. For example, one tmux window for client-side codes and another for backend codes.

My workflow may look different from yours based on your editing style and that's fine. Experiment around to discover your own flow, suiting your coding style.
