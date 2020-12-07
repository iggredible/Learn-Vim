# Ch 05. Moving In A File

In the beginning, moving with a keyboard will feel awkward and incredibly slow, but don't give up! Once you get used to it, you can go anywhere in a file faster than a mouse.

In this chapter, you will learn essential motions and how to use them efficiently. Keep in mind that this is **not** the entire motion that Vim has. The goal here is to introduce useful motions to become productive quickly. If you need to learn more, check out `:h motion.txt`.

## Character Navigation

The most basic motion unit is moving one character left, down, up, and right.

```
h   Left
j   Down
k   Up
l   Right
```

You can also move with directional arrows. If you are just starting, feel free to use any method you're most comfortable with.

I prefer `hjkl` because my right hand can stay in home row. Doing this gives me shorter reach to surrounding keys.
To get used to it, I actually disabled the arrow buttons when starting out by adding these in `~/.vimrc`:

```
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
```

There are also plugins to help break this bad habit. One of them is [vim-hardtime](https://github.com/takac/vim-hardtime).
To my surprise, it only took a few days to get used to using  `hjkl`.

*By the way, if you wonder why Vim uses `hjkl` to move, this is because Lear-Siegler ADM-3A terminal where Bill Joy wrote Vi, didn't have arrow keys and used `hjkl` as left/down/up/right.*

If I want to go somewhere close by, like moving from one part of a word to another part of the same word, I would use `h` or `l`. If I want to go up or down a few lines within displayed window, I would use `j` or `k`. If I want to go somewhere farther, I would use a different motion.

## Relative Numbering

I think it is helpful to have `number` and `relativenumber` set. You can do it by having this on `.vimrc`:

```
set relativenumber number
```

This displays my current line number and relative line numbers.

Why is this useful? This allows me to quickly see how many lines I am away from my target. With this, I can easily see that my target is 12 lines below me so I can do `12j`. Otherwise, if I'm on line 69 and my target is on line 81, I have to do mental calculation (81 - 69 = 12). That takes too much mental resources. The less I have to think about where I need to go, the better.

This is 100% personal preference. Experiment with `relativenumber` / `norelativenumber`, `number` / `nonumber` and use whatever you find most useful!

## Count Your Move

Let's talk about "count" argument. Motions accept a preceding numerical argument. I mentioned above that you can go down 12 lines with `12j`. The 12 in `12j` is the count number.

The syntax to use count with your motion is:

```
[count] + motion
```

You can apply this to all motions. If you want to move 9 characters to the right, instead of pressing `l` 9 times, you can do `9l`. As you learn more motions, try to give them count argument.

## Word Navigation

Let's move to a larger motion unit: *word*. You can move to the beginning of the next word (`w`), to the end of the next word (`e`), to the beginning of the previous word (`b`), and to the end of the previous word (`ge`).

In addition, there is *WORD*, distinct from word. You can move to the beginning of the next WORD (`W`), to the end of the next WORD (`E`), to the beginning of the previous WORD (`B`), and to the end of the previous WORD (`gE`). To make it easy to remember, WORD uses the same letters as word, except they are uppercased.

```
w     Move forward to the beginning of the next word
W     Move forward to the beginning of the next WORD
e     Move forward one word to the end of the next word
E     Move forward one word to the end of the next WORD
b     Move backward to beginning of the previous word
B     Move backward to beginning of the previous WORD
ge    Move backward to end of the previous word
gE    Move backward to end of the previous WORD
```

So what are the similarities and differences between a word and a WORD? Both word and WORD are separated by non-blank characters. A word is a sequence of characters containing only `a-zA-Z0-9_`. A WORD is a sequence of all characters except white space (a white space means either space, tab, and EOL). To learn more, check out `:h word` and `:h WORD`.

For example, suppose you have:
```
const hello = "world";
```

With your cursor at the start of the line, to go to the end of the line with `l`, it will take you 21 key presses. Using `w`, it will take 6. Using `W`, it will only take 4. Both word and WORD are good options to travel short distance.

However, you can get from "c" to ";" in one keystroke with current line navigation.

## Current Line Navigation

When editing, you often need to navigate horizontally in a line. To jump to the first character in current line, use `0`. To go to the last character in the current line, use `$`. Additionally, you can use `^` to go to the first non-blank character in the current line and `g_` to go to the last non-blank character in the current line. If you want to go to the column `n` in the current line, you can use `n|`.

```
0     Go to the first character in the current line
^     Go to the first nonblank char in the current line
g_    Go to the last non-blank char in the current line
$     Go to the last char in the current line
n|    Go the column n in the current line
```

You can also perform a current line search with `f` and `t`. The difference between `f` and `t` is that `f` takes you to the first letter of the match and `t` takes you till (right before) the first letter of the match. So if you want to search for and land on "h", use `fh`. If you want to search for first "h" and land right before the match, use `th`. If you want to go to the *next* occurrence of the last current line search, use `;`. To go to the previous occurrence of the last current line match, use `,`.

To search backwards for "h", use `Fh`. To keep searching for "h" in the same direction, use `;`. Notice that `;` does not always search forward. `;`  repeats the last search direction. If you used `F`, `;` will search backward while `,` searches forward. If you used `f`, `;` will search forward and `,` backward.

```
f    Search forward for a match in the same line
F    Search backward for a match in the same line
t    Search forward for a match in the same line, stopping before match
T    Search backward for a match in the same line, stopping before match
;    Repeat the last search in the same line
,    Repeat the last search in the same line backwards
```

Back at the previous example:

```
const hello = "world";
```

With your cursor at the start of the line, you can go to the last character in current line (";") with one key press: `$`. If you want to go to "w" in "world", you can use `fw`. A good tip to go anywhere in a line is to look for least-common-letters like "j", "x", "z" near your target.

## Sentence And Paragraph Navigation

Next two navigation units are sentence and paragraph.

Let's talk about what a sentence is first.  A sentence ends with either `. ! ?` followed by an end-of-line, a space, or a tab.  You can jump to the next sentence with `)` and the previous sentence with `(`.
```
(    Jump to the previous sentence
)    Jump to the next sentence
```

Let's look at some examples. Which phrases do you think are sentences and which aren't? Try navigating with `(` and `)` in Vim!

```
I am a sentence. I am another sentence because I end with a period. I am still a sentence when ending with an exclamation point! What about question mark? I am not quite a sentence because of the hyphen - and neither semicolon ; nor colon :

There is an empty line above me.
```
By the way, if you're having a problem with Vim not counting a sentence for phrases separated by `.` followed by a single line, you might be in `'compatible'` mode. Running `:set nocompatible` will fix it. In Vi, a sentence is a `.` followed by **two** spaces. You should have `nocompatible` set at all times.

Next, let's talk about what a paragraph is. A paragraph begins after each empty line and also at each set of a paragraph macro specified by the pairs of characters in paragraphs option.

```
{    Jump to the previous paragraph
}    Jump to the next paragraph

```

If you're not sure what a paragraph macro is, do not worry. The important thing is that a paragraph begins and ends after an empty line. This should be true most of the time.

Let's look at this example. Try navigating around with `}` and `{` (also, play around with sentence navigations `( )` to move around too!)

```
Hello. How are you? I am great, thanks!
Vim is awesome.
It may not easy to learn it at first...- but we are in this together. Good luck!

Hello again.

Try to move around with ), (, }, and {. Feel how they work.
You got this.
```

Check out `:h sentence` and `:h paragraph` to learn more.

## Match Navigation

Programmers often edit files containing codes. It may contain many parentheses, braces, and brackets and it can get confusing to know which parentheses you're inside of.
Many programming languages use parentheses, braces, and brackets and you can get lost in them. If you're inside one of them, you can jump to the other pair (if it exists) with `%`. You can also use this to find out whether you have matching parentheses, braces, and brackets.

```
%    Navigate to another match, usually works for (), [], {}
```

Let's look at a Scheme code example because it uses parentheses extensively. Move around with `%` inside different parentheses.
```
(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else
          (+ (fib (- n 1)) (fib (- n 2)))
        )))
```
I personally like to complement `%` using visual indicators plugins like [vim-rainbow](https://github.com/frazrepo/vim-rainbow).  For more, check out `:h %`.

## Line Number Navigation

You can jump to line number `n` with `nG`. For example, if you want to jump to line 7, use `7G`. To jump to the first line, use either `1G` or `gg`. To jump to the last line, use  `G`.

Often you don't know exactly which line you are targeting, but you know it's approximately at 70% of the whole file. In this case, you can do `70%`. To jump halfway through the file, you can do `50%`.

```
gg    Go to the first line
G     Go to the last line
nG    Go to line n
n%    Go to n% in file
```

By the way, if you want to see total lines in a file, you can use `Ctrl-g`.

## Window Navigation

To quickly go to the top, middle, or bottom of your *window*, you can use `H`, `M`, and `L`.

You can also pass a count to `H` and `L`. If you use `10H`, you will go to 10 lines below the top of window. If you use `3L`, you will go to 3 lines above the last line of window.
```
H     Go to top of screen
M     Go to medium screen
L     Go to bottom of screen
nH    Go n line from top
nL    Go n line from bottom
```

## Scrolling

To scroll, you have 3 speed increments: full-screen (`Ctrl-f/Ctrl-b`), half-screen (`Ctrl-d/Ctrl-u`), and line (`Ctrl-e/Ctrl-y`).

```
Ctrl-e    Scroll down a line
Ctrl-d    Scroll down half screen
Ctrl-f    Scroll down whole screen
Ctrl-y    Scroll up a line
Ctrl-u    Scroll up half screen
Ctrl-b    Scroll up whole screen
```
You can also scroll relatively to the current line:
```
zt    Bring the current line near the top of your screen
zh    Bring the current line to the middle (half) of your screen
zb    Bring the current line near the bottom of your screen
```

## Search Navigation

Very often you know that a phrase exists inside a file. You can use search navigation to very quickly reach your target. To search for a phrase, you can use `/` to search forward and `?` to search backward. To repeat the last search you can use `n`. To repeat the last search going opposite direction, you can use `N`.

```
/    Search forward for a match
?    Search backward for a match
n    Repeat last search (same direction of previous search)
N    Repeat last search (opposite direction of previous search)
```

Suppose you have this text:

```
let one = 1;
let two = 2;
one = "01";
one = "one";
let onetwo = 12;
```

If you are searching for "let", you can do `/let`. To quickly search for "let" again, you can just do `n`. To search for "let" again in opposite direction, you can do `N`. If you used `?let` to search, it will search for it backwards. If you use `n`, it will also search backwards, the same direction as `?let` (`N` will search for "let" forwards now).

You can enable search highlight with `:set hlsearch`. Now when you search for `/let`, it will highlight *all* matching phrases in the file. In addition, you can set incremental search with `:set incsearch`. This will highlight the pattern as you're still typing it. By default, your matching phrases will remain highlighted until you search for another phrase. This can quickly turn into an annoyance. To disable highlight, you can run `:nohlsearch`. Because I use this no-highlight feature frequently, I created a mapping:

```
nnoremap <esc><esc> :noh<return><esc>
```

You can quickly search for the text under the cursor with `*` to search forward and `#` to search backward. If your cursor is on the string "one", pressing `*` will be the same as if you had done `/\<one\>`.

Both `\<` and `\>` in `/\<one\>` mean whole word search. It does not match "one" if it is a part of a bigger word. It will match for the word "one" but not "onetwo".  If your cursor is over "one" and you want to search forward to match whole or partial words like "one" and "onetwo", you need to use `g*` instead of `*`.

```
*     Search for whole word under cursor forward
##     Search for whole word under cursor backward
g*    Search for word under cursor forward
g#    Search for word under cursor backward

```
## Marking Position

You can use marks to save your current position and return to this position later. It's like a bookmark for text editing. You can set a mark with `mx`, where `x` can be any alphabetical letter `a-zA-Z`. There are two ways to return to mark: exact (line and column) with `` `x`` and linewise (`'x`).

```
ma    Mark position with mark "a"
`a    Jump to line and column "a"
'a    Jump to line "a"
```

There is a difference between marking with lowercase letters (a-z) and uppercase letters (A-Z). Lowercase alphabets are local marks and uppercase alphabets are global marks (sometimes known as file marks).

Let's talk about local marks. Each buffer can have its own set of local marks. If I have two files opened, I can set a mark "a" (`ma`)  in the first file and another mark "a" (`ma)` in the second file.

Unlike local marks where you can have a set of marks in each buffer, you only get one set of global marks. If you set `mA` inside `myFile.txt`, the next time you set `mA` in a different file, it will overwrite the "A" mark. One advantage of global marks is you can jump to any global mark even if you are inside a completely different project. Global marks can travel across files.

To view all marks, use `:marks`. You may notice from the marks list there are more marks other than `a-zA-Z`. Some of them are:

```
''    Jump back to the last line in current buffer before jump
``    Jump back to the last position in current buffer before jump
`[    Jump to beginning of previously changed / yanked text
`]    Jump to the ending of previously changed / yanked text
`<    Jump to the beginning of last visual selection
`>    Jump to the ending of last visual selection
`0    Jump back to the last edited file when exiting vim
```

There are more marks than the ones listed above. I won't cover them here because I think they are rarely used, but if you're curious, check out `:h marks`.

## Jump

Lastly, let's talk about jumps in Vim. In Vim, you can "jump" to a different file or different part of a file with certain motions. Not all motions count as a jump, though. Going down with `j` does not count as a jump, even if you go 10 steps down with `10j`. Going to line 10 with `10G` counts as a jump.

Here are the commands Vim consider as "jump" commands:

```
'       Go to the marked line
`       Go to the marked position
G       Go to the line
/       Search forward
?       Search backward
n       Repeat the last search, same direction
N       Repeat the last search, opposite direction
%       Find match
(       Go to the last sentence
)       Go to the next sentence
{       Go to the last paragraph
}       Go to the next paragraph
L       Go to the the last line of displayed window
M       Go to the middle line of displayed window
H       Go to the top line of displayed window
[[      Go to the previous section
]]      Go to the next section
:s      Substitute
:tag    Jump to tag definition
```

I don't recommend memorizing this list. A good rule of thumb is, any motion that moves farther than a word and current line navigation is probably a jump. Vim keeps track of where you've been when you move around and you can see this list inside `:jumps`. For more, check out `:h jump-motions`.

Why are jumps useful? Because you can navigate the jump list with `Ctrl-o` to move up the jump list and `Ctrl-i` to move down the jump list. You can jump across different files, which I will discuss more in the next part.

## Learn Navigation The Smart Way

If you are new to Vim, this is a lot to learn. I do not expect anyone to remember everything immediately. It takes time before you can execute them without thinking.

I think the best way to get started is to memorize a few essential motions. I recommend starting out with `h, j, k, l, w, b, G, /, ?, n`. It should not take long to learn 10 motions and be comfortable with them.


To get better at navigation, I can offer two suggestions:

1. Watch for repeated actions. If you find yourself doing `l` repeatedly, look for a motion that will take you forward faster. You will find that you can use `w` to move between words. If you catch yourself repeatedly doing `w`, look if there is a motion that will take you to the end of the line immediately. You will find that you can use `$`. If you can describe your need verbally, there is a good chance Vim has a way to do it.
2. Whenever you learn a new move, spend a considerable amount of time until you can do it without thinking.

Finally, you do not need to know every single Vim command to be productive. Most Vim users don't. I don't. Learn the commands that will help you accomplish your task at that moment.

Take your time. Navigation skill is a very important skill in Vim. Learn one small thing every day and learn it well.
