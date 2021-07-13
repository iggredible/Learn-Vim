# Ch28. Write a Plugin: Creating a Titlecase Operator

When you start to get good at Vim, you may want to write your own plugins. I recently wrote my first Vim plugin, [totitle-vim](https://github.com/iggredible/totitle-vim). It is a titlecase operator plugin, akin to Vim's uppercase `gU`, lowercase `gu`, and togglecase `g~` operators.

In this chapter, I will present the breakdown of the `totitle-vim` plugin. I hope to shed some light on the process and maybe inspire you to create your own unique plugin!

## The Problem

I use Vim to write my articles, including this very guide.

One main issue was to create a proper title case for the headings. One way to automate this is to capitalize each word in the header with `g/^#/ s/\<./\u\0/g`. For MVP, this command was good enough, but it is still not as good as having an actual title case. The words "The" and "Of" in "Capitalize The First Letter Of Each Word" should be capitalized. Without a proper capitalization, the sentence looks slightly off.

At first, I wasn't planning to write a plugin. Also it turns out that there is a titlecase plugin already: [vim-titlecase](https://github.com/christoomey/vim-titlecase). However, there were a few things that didn't function quite the way I wanted them to. The main one was the blockwise visual mode behavior. If I have the phrase:

```
test title one
test title two
test title three
```

If I use a block visual highlight on the "tle":

```
test ti[tle] one
test ti[tle] two
test ti[tle] three
```

If I press `gt`, the plugin won't capitalize it. I find it inconsistent with the behaviors of `gu`, `gU`, and `g~`. So I decided to work off from that titlecase plugin repo and use that to a titlecase plugin myself that is consistent with `gu`, `gU`, and `g~`!. Again, the vim-titlecase plugin itself is an excellent plugin and worthy to be used on its own (the truth is, maybe deep down I just wanted to write my own Vim plugin. I can't really see the blockwise titlecasing feature to be used that often in real life other than edge cases).

### Planning for the Plugin

Before writing the first line of code, I need to decide what the titlecase rules are. I found a neat table of different capitalization rules from the [titlecaseconverter site](https://titlecaseconverter.com/rules/). Did you know that there are at least 8 different capitalization rules in English language? *Gasp!*

In the end, I used the common denominators from that list to come up with a good enough basic rule for the plugin. Plus I doubt people will complain, "Hey man, you're using AMA, why aren't you using APA?". Here are the basic rules:
- First word is always uppercased.
- Some adverbs, conjunctions, and prepositions are lowercased.
- If the input word is totally uppercased, then don't do anything (it could be an abbreviation).

As for which words are lowercased, different rules have different lists. I decided to stick with `a an and at but by en for in nor of off on or out per so the to up yet vs via`.

### Planning for the User Interface

I want the plugin to be an operator to complement Vim's existing case operators: `gu`, `gU`, and `g~`. Being an operator, it must accept either a motion or a text object (`gtw` should titlecase the next word, `gtiw` should titlecase the inner word, `gt$` should titlecase the words from the current location until the end of the line, `gtt` should titlecase the current line, `gti(` should titlecase the words inside parentheses, etc). I also want it to be mapped to `gt` for easy mnemonics. Moreover, it should also work with all visual modes: `v`, `V`, and `Ctrl-V`. I should be able to highlight it in *any* visual mode, press `gt`, then all the highlighted texts will be titlecased.

## Vim Runtime

The first thing you see when you look at the repo is that it has two directories: `plugin/` and `doc/`. When you start Vim, it looks for special files and directories inside the `~/.vim` directory and runs all script files inside that directory. For more, review the Vim Runtime chapter.

The plugin utilizes two Vim runtime directories: `doc/` and `plugin/`. `doc/` is a place to put the help documentation (so you can search for keywords later, like `:h totitle`). I'll go over how to create a help page later. For now, let's focus on `plugin/`. The `plugin/` directory is executed once when Vim boots up. There is one file inside this directory: `totitle.vim`. The naming doesn't matter (I could've named it `whatever.vim` and it would still work). All the code responsible for the plugin to work is inside this file.

## Mappings

Let's go through the code! 

At the start of the file, you have:

```
if !exists('g:totitle_default_keys')
  let g:totitle_default_keys = 1
endif
```

When you start Vim, `g:totitle_default_keys` won't exist yet, so `!exists(...)` returns true. In that case, define `g:totitle_default_keys` to equal 1. In Vim, 0 is falsy and non-zero is truthy (use 1 to indicate truthy).

Let's jump to the bottom of the file. You'll see this:

```
if g:totitle_default_keys
  nnoremap <expr> gt ToTitle()
  xnoremap <expr> gt ToTitle()
  nnoremap <expr> gtt ToTitle() .. '_'
endif
```

This is where the main `gt` mapping is defined. In this case, by the time you get to the `if` conditionals at the bottom of the file, `if g:totitle_default_keys` would return 1 (truthy), so Vim performs the following maps:
- `nnoremap <expr> gt ToTitle()` maps the normal mode *operator*. This lets you run operator + motion/text-object like `gtw` to titlecase the next word or `gtiw` to titlecase the inner word. I will go over the details of how the operator mapping works later.
- `xnoremap <expr> gt ToTitle()` maps the visual mode operators. This lets you to titlecase the texts that are visually highlighted.
- `nnoremap <expr> gtt ToTitle() .. '_'` maps the normal mode linewise operator (analogous to `guu` and `gUU`). You may wonder what `.. '_'` does at the end. `..` is Vim's string interpolation operator. `_` is used as a motion with an operator. If you look in `:help _`, it says that the underscore is used to count 1 line downward. It performs an operator on the current line (try it with other operators, try running `gU_` or `d_`, notice that it does the same as `gUU` or `dd`).
- Finally, the `<expr>` argument allows you to specify the count, so you can do `3gtw` to togglecase the next 3 words.

What if you don't want to use the default `gt` mapping? Afterall, you are overriding Vim's default `gt` (tab next) mapping. What if you want to use `gz` instead of `gt`? Remember earlier how you went through the trouble of checking `if !exists('g:totitle_default_keys')` and `if g:totitle_default_keys`? If you put `let g:totitle_default_keys = 0` in your vimrc, then `g:totitle_default_keys` would already exist when the plugin is run (codes in your vimrc are executed before the `plugin/` runtime files), so `!exists('g:totitle_default_keys')` returns false. Furthermore, `if g:totitle_default_keys` would be falsy (because it would have the value of 0), so it also won't perform the `gt` mapping! This effectively lets you define your own custom mapping in Vimrc.

To define your own titlecase mapping to `gz`, add this in your vimrc:

```
let g:totitle_default_keys = 0

nnoremap <expr> gz ToTitle()
xnoremap <expr> gz ToTitle()
nnoremap <expr> gzz ToTitle() .. '_'
```

Easy peasy.

## The ToTitle Function

The `ToTitle()` function is easily the longest function in this file.

```
 function! ToTitle(type = '')
  if a:type ==# ''
    set opfunc=ToTitle
    return 'g@'
  endif

  " invoke this when calling the ToTitle() function
  if a:type != 'block' && a:type != 'line' && a:type != 'char'
    let l:words = a:type
    let l:wordsArr = trim(l:words)->split('\s\+')
    call map(l:wordsArr, 's:capitalize(v:val)')
    return l:wordsArr->join(' ')
  endif

  " save the current settings
  let l:sel_save = &selection
  let l:reg_save = getreginfo('"')
  let l:cb_save = &clipboard
  let l:visual_marks_save = [getpos("'<"), getpos("'>")]

  try
    set clipboard= selection=inclusive
    let l:commands = #{line: "'[V']y", char: "`[v`]y", block: "`[\<c-v>`]y"}

    silent exe 'noautocmd keepjumps normal! ' .. get(l:commands, a:type, '')
    let l:selected_phrase = getreg('"')
    let l:WORD_PATTERN = '\<\k*\>'
    let l:UPCASE_REPLACEMENT = '\=s:capitalize(submatch(0))'

    let l:startLine = line("'<")
    let l:startCol = virtcol(".")

    " when user calls a block operation
    if a:type ==# "block"
      sil! keepj norm! gv"ad
      keepj $
      keepj pu_

      let l:lastLine = line("$")

      sil! keepj norm "ap

      let l:curLine = line(".")

      sil! keepj norm! VGg@
      exe "keepj norm! 0\<c-v>G$h\"ad"
      exe "keepj " . l:startLine
      exe "sil! keepj norm! " . l:startCol . "\<bar>\"aP"
      exe "keepj " . l:lastLine
      sil! keepj norm! "_dG
      exe "keepj " . l:startLine
      exe "sil! keepj norm! " . l:startCol . "\<bar>"

    " when user calls a char or line operation
    else
      let l:titlecased = substitute(@@, l:WORD_PATTERN, l:UPCASE_REPLACEMENT, 'g')
      let l:titlecased = s:capitalizeFirstWord(l:titlecased)
      call setreg('"', l:titlecased)
      let l:subcommands = #{line: "'[V']p", char: "`[v`]p", block: "`[\<c-v>`]p"}
      silent execute "noautocmd keepjumps normal! " .. get(l:subcommands, a:type, "")
      exe "keepj " . l:startLine
      exe "sil! keepj norm! " . l:startCol . "\<bar>"
    endif
  finally

    " restore the settings
    call setreg('"', l:reg_save)
    call setpos("'<", l:visual_marks_save[0])
    call setpos("'>", l:visual_marks_save[1])
    let &clipboard = l:cb_save
    let &selection = l:sel_save
  endtry
  return
endfunction
```

This is very long, so let's break it apart. 

*I could refactor this into smaller sections, but for the sake of completing this chapter, I just left it as is.*

## The Operator Function

Here is the first part of the code:

```
if a:type ==# ''
  set opfunc=ToTitle
  return 'g@'
endif
```

What the heck is `opfunc`? Why is it returning `g@`?

Vim has a special operator, the operator function, `g@`. This operator lets you to use *any* function assigned to the `opfunc` option. If I have the function `Foo()` assigned to `opfunc`, then when I run `g@w`, I am running `Foo()` on the next word. If I run `g@i(`, then I'm running `Foo()` on the inner parentheses. This operator function is critical to create your own Vim operator.

The following line assigns the `opfunc` to the `ToTitle` function.

```
set opfunc=ToTitle
```

The next line is literally returning `g@`:

```
return g@
```

So exactly how do these two lines work and why is it returning `g@`?

Let's assume that you have the following map:

```
nnoremap <expr> gt ToTitle()`
```

Then you press `gtw` (titlecase the next word). The first time you run `gtw`, Vim calls the `ToTitle()` method. But right now `opfunc` is still blank. You are also not passing any argument to `ToTitle()`, so it will have `a:type` value of `''`. This causes the conditional expression to check the argument `a:type`, `if a:type ==# ''`, to be truthy. Inside, you assign `opfunc` to the `ToTitle` function with `set opfunc=ToTitle`. Now `opfunc` is assigned to `ToTitle`. Finally, after you assigned `opfunc` to the `ToTitle` function, you return `g@`. I will explain why it returns `g@` below.

You are not done yet. Remember, you just pressed `gtw`. Pressing `gt` did all of the things above, but you still have `w` to process. By returning `g@`, at this point, you now technically have `g@w` (this is why you have `return g@`). Since `g@` is the function operator, you are passing to it the `w` motion. So Vim, upon receiving `g@w`, calls the `ToTitle` *one more time* (don't worry, you won't end up with an infinite loop as you will see in a little bit).

To recap, by pressing `gtw`, Vim checks if `opfunc` is empty or not. If it is empty, then Vim will assign it with `ToTitle`. Then it returns `g@`, essentially calling the `ToTitle` again one more time so you can now use it as an operator. This is the trickiest part of creating a custom operator and you did it! Next, you need to build the logic for `ToTitle()` to actually titlecase the input.

## Processing the Input

You now have `gt` functioning as an operator that executes `ToTitle()`. But what do you do next? How do you actually titlecase the text?

Whenever you run any operator in Vim, there are three different action motion types: character, line, and block. `g@w` (word) is an example of a character operation. `g@j` (one line below) is an example of a line operation. Block operation is rare, but typically when you do `Ctrl-V` (visual block) operation, it will be counted as a block operation. Operations that target a few characters forward / backward are generally considered character operations (`b`, `e`, `w`, `ge`, etc). Operations that target a few lines downward / upward are generally considered line operations (`j`, `k`). Operations that target columns forward, backward, upward, or downward are generally considered block operations (they are usually either a columnar forced-motion or a blockwise visual mode; for more: `:h forced-motion`).

This means, if you press `g@w`, `g@` will pass a literal string `"char"` as an argument to `ToTitle()`. If you do `g@j`, `g@` will pass a literal string `"line"` as an argument to `ToTitle()`. This string is what will be passed into the `ToTitle` function as the `type` argument.

## Creating Your Own Custom Function Operator

Let's pause and play with `g@` by writing a dummy function:

```
function! Test(some_arg)
  echom a:some_arg 
endfunction
```

Now assign that function to `opfunc` by running:

```
:set opfunc=Test
```

The `g@` operator will execute `Test(some_arg)` and passes it with either `"char"`, `"line"`, or `"block"` depending on what operation you do. Run different operations like `g@iw` (inner word), `g@j` (one line below), `g@$` (to the end of the line), etc. See what different values are being echoed. To test the block operation, you can use Vim's forced motion for block operations: `g@Ctrl-Vj` (block operation one column below).

You can also use it with the visual mode. Use the various visual highlights like `v`, `V`, and `Ctrl-V` then press `g@` (be warned, it will flash the output echo really quickly, so you need to have a quick eye - but the echo is definitely there. Also, since you are using `echom`, you can check the recorded echo messages with `:messages`).

Pretty cool, isn't it? The things you can program with Vim! Why didn't they teach this at school? Let's continue with our plugin.

## ToTitle As a Function

Moving on to the next few lines:

```
if a:type != 'block' && a:type != 'line' && a:type != 'char'
  let l:words = a:type
  let l:wordsArr = trim(l:words)->split('\s\+')
  call map(l:wordsArr, 's:capitalize(v:val)')
  return l:wordsArr->join(' ')
endif
```

This line actually has nothing to do with `ToTitle()` behavior an operator, but to enable it into a callable TitleCase function (yes, I know that I am violating the Single Responsibility Principle). The motivation is, Vim has native `toupper()` and `tolower()` functions that will uppercase and lowercase any given string. Ex: `:echo toupper('hello')` returns `'HELLO'` and `:echo tolower('HELLO')` returns `'hello'`. I want this plugin to have the ability to run `ToTitle` so you can do `:echo ToTitle('once upon a time')` and get a `'Once Upon a Time'` return value.

By now, you know that when you are calling `ToTitle(type)` with `g@`, the `type` argument will have a value of either `'block'`, `'line'`, or `'char`'. If the argument is neither `'block'` nor `'line'` nor `'char'`, you can safely assume that `ToTitle()` is being called outside of `g@`. In that case, you split them by whitespaces (`\s\+`) with:

```
let l:wordsArr = trim(l:words)->split('\s\+')
```

Then capitalize each element:


```
call map(l:wordsArr, 's:capitalize(v:val)')
```

Before joining them back together:

```
l:wordsArr->join(' ')
```


The `capitalize()` function will be covered later.

## Temporary Variables

The next few lines:

```
let l:sel_save = &selection
let l:reg_save = getreginfo('"')
let l:cb_save = &clipboard
let l:visual_marks_save = [getpos("'<"), getpos("'>")]
```

These lines preserve various current states into temporary variables. Later in this you will use visual modes, marks, and registers. Doing these will tamper with the a few states. Since you don't want to revise the history, you need to save them into temporary variables so you can restore the states later.

## Capitalizing the Selections

The next lines are important:

```
try
  set clipboard= selection=inclusive
  let l:commands = #{line: "'[V']y", char: "`[v`]y", block: "`[\<c-v>`]y"}

  silent exe 'noautocmd keepjumps normal! ' .. get(l:commands, a:type, '')
  let l:selected_phrase = getreg('"')
  let l:WORD_PATTERN = '\<\k*\>'
  let l:UPCASE_REPLACEMENT = '\=s:capitalize(submatch(0))'

  let l:startLine = line("'<")
  let l:startCol = virtcol(".")

```
Let's go through them in small chunks. This line:

```
set clipboard= selection=inclusive
```

You first set the `selection` option to be inclusive and the `clipboard` to be empty. The selection attribute is typically used with the visual mode and there are three possible values: `old`, `inclusive`, and `exclusive`. Setting it to be inclusive means that the last character of the selection is included. I won't cover them here, but the point is that choosing it to be inclusive makes it behave consistently in visual mode. By default Vim sets it to inclusive, but you set it here anyway just in case one of your plugins sets it to a different value. Check out `:h 'clipboard'` and `:h 'selection'` if you're curious what they really do.

Next you have this weird-looking hash followed by an execute command:

```
let l:commands = #{line: "'[V']y", char: "`[v`]y", block: "`[\<c-v>`]y"}
silent exe 'noautocmd keepjumps normal! ' .. get(l:commands, a:type, '')
```

First, the `#{}` syntax is Vim's dictionary data type. The local variable `l:commands` is a hash with 'lines', 'char', and 'block' as its keys. The command `silent exe '...'` executes whatever command inside the string silently (otherwise it will display notifications to the bottom of your screen). 

Second, the executed commands are `'noautocmd keepjumps normal! ' .. get(l:commands, a:type, '')`. The first one, `noautocmd`, will execute the subsequent command without triggering any autocommand. The second one, `keepjumps`, is to not record the cursor movement while moving. In Vim, certain motions are automatically recorded in the change list, the jump list, and the mark list. This prevents that. The point of having `noautocmd` and `keepjumps` is to prevent side effects. Finally, the `normal` command executes the strings as normal commands. The `..` is Vim's string interpolation syntax. `get()` is a getter method that accepts either a list, blob, or dictionary. In this case, you are passing it the dictionary `l:commands`. The key is `a:type`. You learned earlier that `a:type` is either one of the three string values: 'char', 'line', or 'block'. So if `a:type` is 'line', you will be executing `"noautocmd keepjumps normal! '[V']y"` (for more, check out `:h silent`, `:h :exe`, `:h :noautocmd`, `:h :keepjumps`, `:h :normal`, and `:h get()`).

Let's go over what `'[V']y` does. First assume that you have this body of text:

```
the second breakfast
is better than the first breakfast
```
Assume that your cursor is on the first line. Then you press `g@j` (run the operator function, `g@`, one line below, with `j`). `'[` moves the cursor to the start of the previously changed or yanked text. Although you technically didn't change or yank any text with `g@j`, Vim remembers the locations of the start and the end motions of the `g@` command with `'[` and `']` (for more, check out `:h g@`). In your case, pressing `'[` moves your cursor to the first line because that's where you started when you ran `g@`. `V` is a linewise visual mode command. Finally, `']` moves your cursor to the end of the previous changed or yanked text, but in this case, it moves your cursor to the end of your last `g@` operation. Finally, `y` yanks the selected text. 

What you just did was yanking the same body of text you performed `g@` on.

If you look at the other two commands in here:

```
let l:commands = #{line: "'[V']y", char: "`[v`]y", block: "`[\<c-v>`]y"}
```

They all perform similar actions, except instead of using linewise actions, you would be using characterwise or blockwise actions. I'm going to sound redundant, but in any three cases you are effectively yanking the same body of text you performed `g@` on.

Let's look at the next line:

```
let l:selected_phrase = getreg('"')
```

This line gets the content of the unnamed register (`"`) and stores it inside the variable `l:selected_phrase`.  Wait a minute... didn't you just yank a body of text? The unnamed register currently contains the text that you had just yanked. This is how this plugin is able to get the copy of the text.

The next line is a regular expression pattern:

```
let l:WORD_PATTERN = '\<\k*\>'
```

`\<` and `\>` are word boundary patterns. The character following `\<` matches the beginning of a word and the character preceding `\>` matches the end of a word. `\k` is the keyword pattern. You can check what characters Vim accepts as keywords with `:set iskeyword?`. Recall that the `w` motion in Vim moves your cursor word-wise. Vim comes with a pre-conceied notion of what a "keyword" is (you can even edit them by altering the `iskeyword` option). Check out `:h /\<`, `:h /\>`, and `:h /\k`, and `:h 'iskeyword'` for more. Finally, `*` means zero or more of the subsequent pattern.

In the big picture, `'\<\k*\>'` matches a word. If you have a string:

```
one two three
```

Matching it against the pattern will give you three matches: "one", "two", and "three".

Finally, you have another pattern:

```
let l:UPCASE_REPLACEMENT = '\=s:capitalize(submatch(0))'
```

Recall that Vim's substitute command can be used with an expression with `\={your-expression}`. For example, if you want to uppercase the string "donut" in the current line, you can use Vim's `toupper()` function. You can achieve this by running `:%s/donut/\=toupper(submatch(0))/g`. `submatch(0)` is a special expression used in the substitute command. It returns the whole matched text.

The next two lines:

```
let l:startLine = line("'<")
let l:startCol = virtcol(".")
```

The `line()` expression returns a line number. Here you pass it with the mark `'<`, representing the first line of the last selected visual area. Recall that you used visual mode to yank the text. `'<` returns the line number of the beginning of that visual area selection. The `virtcol()` expression returns a column number of the current cursor. You will be moving your cursor all over the place in a little bit, so you need to store your cursor location so you can return here later.

Take a break here and review everything so far. Make sure you are still following along. When you're ready, let's continue.

## Handling a Block Operation

Let's go through this section:

```
if a:type ==# "block"
  sil! keepj norm! gv"ad
  keepj $
  keepj pu_

  let l:lastLine = line("$")

  sil! keepj norm "ap

  let l:curLine = line(".")

  sil! keepj norm! VGg@
  exe "keepj norm! 0\<c-v>G$h\"ad" 
  exe "keepj " . l:startLine
  exe "sil! keepj norm! " . l:startCol . "\<bar>\"aP"
  exe "keepj " . l:lastLine
  sil! keepj norm! "_dG
  exe "keepj " . l:startLine
  exe "sil! keepj norm! " . l:startCol . "\<bar>"
```

It's time to actually capitalize your text. Recall that you have the `a:type` to be either 'char', 'line', or 'block'. In most cases, you'll probably be getting 'char' and 'line'. But occasionally you may get a block. It is rare, but it must be addressed nonetheless. Unfortunately, handling a block is not as straight-forward as handling char and line. It will take a little extra effort, but it is doable.

Before you start, let's take an example of how you might get a block. Assume that you have this text:

```
pancake for breakfast
pancake for lunch
pancake for dinner
```

Assume that your cursor is on "c" on "pancake" on the first line. You then use the visual block (`Ctrl-V`) to select down and forward to select the "cake" in all three lines:

```
pan[cake] for breakfast
pan[cake] for lunch
pan[cake] for dinner
```

When you press `gt`, you want to get:

```
panCake for breakfast
panCake for lunch
panCake for dinner

```
Here are your basic assumptions: when you highlight the three "cakes" in "pancakes", you are telling Vim that you have three lines of words that you want to highlight. These words are "cake", "cake", and "cake". You expect to get "Cake", "Cake", and "Cake".

Let's move on to the implementation details. The next few lines have:

```
sil! keepj norm! gv"ad
keepj $
keepj pu_
let l:lastLine = line("$")
sil! keepj norm "ap
let l:curLine = line(".")
```

The first line:

```
sil! keepj norm! gv"ad
```

Recall that `sil!` runs silently and `keepj` keeps the jump history when moving. You then execute the normal command `gv"ad`. `gv` selects the last visually highlighted text (in the pancakes example, it will re-highlight all three 'cakes'). `"ad` deletes the visually highlighted texts and stores them in register a. As a result, you now have:

```
pan for breakfast
pan for lunch
pan for dinner
```

Now you have 3 *blocks* (not lines) of 'cakes' stored in the register a. This distinction is important. Yanking a text with linewise visual mode is different from yanking a text with blockwise visual mode. Keep this in mind because you will see this again later.

Next you have:

```
keepj $
keepj pu_
```

`$` moves you to the last line in your file. `pu_` inserts one line below where your cursor is. You want to run them with `keepj` so you don't alter the jump history.

Then you store the line number of your last line (`line("$")`) in the local variable `lastLine`.

```
let l:lastLine = line("$")
```

Then paste the content from the register with `norm "ap`.

```
sil! keepj norm "ap
```

Keep in mind that this is happening on the new line you created below the last line of the file - you are currently at the bottom of the file. Pasting give you these *block* texts:

```
cake
cake
cake
```

Next, you store the location of the current line where your cursor is.

```
let l:curLine = line(".")
```

Now let's go the next few lines:

```
sil! keepj norm! VGg@
exe "keepj norm! 0\<c-v>G$h\"ad"
exe "keepj " . l:startLine
exe "sil! keepj norm! " . l:startCol . "\<bar>\"aP"
exe "keepj " . l:lastLine
sil! keepj norm! "_dG
exe "keepj " . l:startLine
exe "sil! keepj norm! " . l:startCol . "\<bar>"
```

This line:

```
sil! keepj norm! VGg@
```

`VG` visually highlights them with line visual mode from the current line to the end of the file. So here you are highlighting the three blocks of 'cake' texts with linewise highlight (recall the block vs line distinction). Note that the first time you pasted the three "cake" texts, you were pasting them as blocks. Now you are highlighting them as lines. They may look the same from the outside, but internally, Vim knows the difference between pasting blocks of texts and pasting lines of texts.

```
cake
cake
cake
```

`g@` is the function operator, so you are essentially doing a recursive call to itself. But why? What does this accomplish?

You are making a recursive call to `g@` and passing it with all 3 lines (after running it with `V`, you now have lines, not blocks) of 'cake' texts so it will be handled by the other part of the code (you will go over this later). The result of running `g@` is three lines of properly titlecased texts:

```
Cake
Cake
Cake
```

The next line:

```
exe "keepj norm! 0\<c-v>G$h\"ad"
```

This runs the normal mode command to go to the beginning of the line (`0`), use the block visual highlight to go to the last line and last character on that line (`<c-v>G$`). The `h` is to adjust the cursor (when doing `$` Vim moves one extra line to the right). Finally, you delete the highlighted text and store it in the register a (`"ad`).

The next line:

```
exe "keepj " . l:startLine
```

You move your cursor back to where the `startLine` was.

Next:

```
exe "sil! keepj norm! " . l:startCol . "\<bar>\"aP"
```

Being in the `startLine` location, you now jump to the column marked by `startCol`. `\<bar>\` is the bar `|` motion. The bar motion in Vim moves your cursor to the nth column (let's say the `startCol` was 4. Running `4|` will make your cursor jump to the column position of 4). Recall that you `startCol` was the location where you stored the column position of the text you wanted to titlecase. Finally, `"aP` pastes the texts stored in the register a. This puts the text back to where it was deleted before.

Let's look at the next 4 lines:

```
exe "keepj " . l:lastLine
sil! keepj norm! "_dG
exe "keepj " . l:startLine
exe "sil! keepj norm! " . l:startCol . "\<bar>"
```

`exe "keepj " . l:lastLine` moves your cursor back to the `lastLine` location from earlier. `sil! keepj norm! "_dG` deletes the extra space(s) that were created using the blackhole register (`"_dG`) so your unnamed register stays clean. `exe "keepj " . l:startLine` moves your cursor back to `startLine`. Finally, `exe "sil! keepj norm! " . l:startCol . "\<bar>"` moves your cursor to the `startCol` column.

These are all the actions you could've done manually in Vim. However, the benefit of turning these actions into reusable functions is that they will save you from running 30+ lines of instructions every single time you need to titlecase anything. The take home here is, anything that you can do manually in Vim, you can turn it into a reusable function, hence a plugin!

Here is what it would look like.

Given some text:

```
pancake for breakfast
pancake for lunch
pancake for dinner

... some text
```

First, you visually highlight it blockwise:

```
pan[cake] for breakfast
pan[cake] for lunch
pan[cake] for dinner

... some text
```

Then you delete it and store that text in register a:

```
pan for breakfast
pan for lunch
pan for dinner

... some text
```

Then you paste it at the bottom of the file:

```
pan for breakfast
pan for lunch
pan for dinner

... some text
cake
cake
cake
```

Then you capitalize it:

```
pan for breakfast
pan for lunch
pan for dinner

... some text
Cake
Cake
Cake
```

Finally, you put the capitalized text back:

```
panCake for breakfast
panCake for lunch
panCake for dinner

... some text
```

## Handling Line and Char Operations

You are not done yet. You've only addressed the edge case when you run `gt` on block texts. You still need to handle the 'line' and 'char' operations. Let's look at the `else` code to see how tthis is done.

Here are the codes:

```
if a:type ==# "block"
  # ... 
else
  let l:titlecased = substitute(@@, l:WORD_PATTERN, l:UPCASE_REPLACEMENT, 'g')
  let l:titlecased = s:capitalizeFirstWord(l:titlecased)
  call setreg('"', l:titlecased)
  let l:subcommands = #{line: "'[V']p", char: "`[v`]p", block: "`[\<c-v>`]p"}
  silent execute "noautocmd keepjumps normal! " .. get(l:subcommands, a:type, "")
  exe "keepj " . l:startLine
  exe "sil! keepj norm! " . l:startCol . "\<bar>"
endif
```

Let's go through them linewise. The secret sauce of this plugin is actually on this line:

```
let l:titlecased = substitute(@@, l:WORD_PATTERN, l:UPCASE_REPLACEMENT, 'g')
```

`@@` contains the text from the unnamed register to be titlecased. `l:WORD_PATTERN` is the individual keyword match. `l:UPCASE_REPLACEMENT` is the call to the `capitalize()` command (which you will see later). The `'g'` is the global flag that instructs the substitute command to substitute all given words, not just the first word.

The next line:

```
let l:titlecased = s:capitalizeFirstWord(l:titlecased)
```

This guarantees that the first word will always be capitalized. If you have a phrase like "an apple a day keeps the doctor away", since the first word, "an", is a special word, your substitute command won't capitalize it. You need a a method that always capitalizes the first character no matter what. This function does just that (you will see this function detail later). The result of these capitalization methods is stored in the local variable `l:titlecased`.

The next line:

```
call setreg('"', l:titlecased)
```

This puts the capitalized string into the unnamed register (`"`).

Next, the following two lines:

```
let l:subcommands = #{line: "'[V']p", char: "`[v`]p", block: "`[\<c-v>`]p"}
silent execute "noautocmd keepjumps normal! " .. get(l:subcommands, a:type, "")
```

Hey, that looks familiar! You have seen a similar pattern before with `l:commands`. Instead of yank, here you use paste (`p`). Check out the previous section where I went over the `l:commands` for a refresher.

Finally, these two lines:

```
exe "keepj " . l:startLine
exe "sil! keepj norm! " . l:startCol . "\<bar>"
```

You are moving your cursor back to the line and column where you started. That's it!

Let's recap. The above substitute method is smart enough to capitalize the given texts and skip the special words (more on this later). After you have a titlecased string, you store them in the unnamed register. Then you visually highlight the exact same text you operated `g@` on before, then paste from the unnamed register (this effectively replaces the non-titlecased texts with the titlecased version. Finally, you move your cursor back to where you started.

## Cleanups

You are technically done. The texts are now titlecased. All that is left to do is to restore the registers and settings.

```
call setreg('"', l:reg_save)
call setpos("'<", l:visual_marks_save[0])
call setpos("'>", l:visual_marks_save[1])
let &clipboard = l:cb_save
let &selection = l:sel_save
```

These restore:
- the unnamed register.
- the `<` and `>` marks.
- the `'clipboard'` and `'selection'` options.

Phew, you are done. That was a long function. I could have made the function shorter by breaking it apart into smaller ones, but for now, that will have to suffice. Now let's briefly go over the capitalize functions.

## The Capitalize Function

In this section, let's go over the `s:capitalize()` function. This is what the function looks like:

```
function! s:capitalize(string)
    if(toupper(a:string) ==# a:string && a:string != 'A')
        return a:string
    endif

    let l:str = tolower(a:string)
    let l:exclusions = '^\(a\|an\|and\|at\|but\|by\|en\|for\|in\|nor\|of\|off\|on\|or\|out\|per\|so\|the\|to\|up\|yet\|v\.?\|vs\.?\|via\)$'
    if (match(l:str, l:exclusions) >= 0) || (index(s:local_exclusion_list, l:str) >= 0)
      return l:str
    endif

    return toupper(l:str[0]) . l:str[1:]
endfunction
```

Recall that the argument for the `capitalize()` function, `a:string`, is the individual word passed by the `g@` operator. So if I am running `gt` on the text "pancake for breakfast", `ToTitle`  will call `capitalize(string)` *three* times, once for "pancake", once for "for", and once for "breakfast".

The first part of the function is:

```
if(toupper(a:string) ==# a:string && a:string != 'A')
  return a:string
endif
```

The first condition (`toupper(a:string) ==# a:string`) checks whether the uppercased version of the argument is the same as the string and whether the string itself is "A". If these are true, then return that string. This is based on the assumption that if a given word is already totally uppercased, then it is an abbreviation. For example, the word "CEO" would otherwise be converted into "Ceo". Hmm, your CEO won't be happy. So it's best to leave any fully uppercased word alone. The second condition, `a:string != 'A'`, addresses an edge case for a capitalized "A" character. If `a:string` is already a capitalized "A", it would have accidentally passed the `toupper(a:string) ==# a:string` test. Because "a" is an indefinite article in English, it needs to be lowercased.

The next part forces the string to be lowercased:

```
let l:str = tolower(a:string)
```


The next part is a regex of a list of all word exclusions. I got them from https://titlecaseconverter.com/rules/ :

```
let l:exclusions = '^\(a\|an\|and\|at\|but\|by\|en\|for\|in\|nor\|of\|off\|on\|or\|out\|per\|so\|the\|to\|up\|yet\|v\.?\|vs\.?\|via\)$'
```

The next part:

```
if (match(l:str, l:exclusions) >= 0) || (index(s:local_exclusion_list, l:str) >= 0)
  return l:str
endif
```

First, check if your string is a part of the excluded word list (`l:exclusions`). If it is, don't capitalize it. Then check if your string is a part of the local exclusion list (`s:local_exclusion_list`). This exclusion list is a custom list that the user can add in vimrc (in case the user has additional requirements for special words).

The last part returns the capitalized version of the word. The first character is uppercased while the rest remains as is.

```
return toupper(l:str[0]) . l:str[1:]
```

Let's go over the second capitalize function. The function looks like this:

```
function! s:capitalizeFirstWord(string)
  if (a:string =~ "\n")
    let l:lineArr = trim(a:string)->split('\n')
    let l:lineArr = map(l:lineArr, 'toupper(v:val[0]) . v:val[1:]')
    return l:lineArr->join("\n")
  endif
  return toupper(a:string[0]) . a:string[1:]
endfunction
```

This function was created to handle an edge case if you have a sentence that starts with an excluded word, like "an apple a day keeps the doctor away". Based on English language's capitalization rules, all first words in a sentence, regardless if it is a special word or not, must be capitalized. With your `substitute()` command alone, the "an" in your sentence would be lowercased. You need to force the first character to be uppercased.

In this `capitalizeFirstWord` function, the `a:string` argument is not an individual word like `a:string` inside the `capitalize` function, but instead the whole text. So if you have "pancake for breakfast", `a:string`'s value is "pancake for breakfast".it only runs `capitalizeFirstWord` once for the whole text. 

One scenario you need to watch out for is if you have a multi-line string like `"an apple a day\nkeeps the doctor away"`. You want to uppercase the first character of all lines. If you don't have newlines, then simply uppercase the first character.

```
return toupper(a:string[0]) . a:string[1:]
```

If you have newlines, you need to capitalize all the first characters in each line, so you split them into an array separated by newlines:

```
let l:lineArr = trim(a:string)->split('\n')
```

Then you map each element in the array and capitalize the first word of each element:

```
let l:lineArr = map(l:lineArr, 'toupper(v:val[0]) . v:val[1:]')
```

Finally, you put the array elements together:

```
return l:lineArr->join("\n")
```

And you are done!

## Docs

The second directory in the repository is the `docs/` directory. It is good to provide the plugin with a thorough documentation. In this section, I'll briefly go over how to make your own plugin docs.

The `docs/` directory is one of Vim's special runtime paths. Vim reads all the files inside the `docs/` so when you search for a special keyword and that keyword is found in one of the files in the `docs/` directory, it will display it in the help page. Here you have a `totitle.txt`. I name it that way because that's the plugin name, but you can name it anything you want.

A Vim docs file is a txt file at heart. The difference between a regular txt file and a Vim help file is that the latter uses special "help" syntaxes. But first, you need to tell Vim to treat it not as a text file type, but as a `help` file type. To tell Vim to interpret this `totitle.txt` as a *help* file, run `:set ft=help` (`:h 'filetype'` for more). By the way, if you want to tell Vim to interpret this `totitle.txt` as a *regular* txt file, run `:set ft=txt`.

### The Help File Special Syntax

To make a keyword discoverable, surround that keyword with asterisks. To make the keyword `totitle` discoverable when user searches for `:h totitle`, write it as `*totitle*` in the help file.

For example, I have these lines on top of my table of contents:

```
TABLE OF CONTENTS                                     *totitle*  *totitle-toc*

// more TOC stuff
```

Note that I used two keywords: `*totitle*` and `*totitle-toc*` to mark the table of contents section. You can use as many keywords as you want. This means that whenever you search for either `:h totitle` or `:h totitle-toc`, Vim takes you to this location. 

Here is another example, somewhere down the file:

```
2. Usage                                                       *totitle-usage*

// usage
```

If you search for `:h totitle-usage`, Vim takes you to this section. 

You can also use internal links to refer to another section in the help file by surrounding a keyword with the bar syntax `|`. In the TOC section, you see keywords surrounded by the bars, like `|totitle-intro|`, `|totitle-usage|`, etc.

```
TABLE OF CONTENTS                                     *totitle*  *totitle-toc*

    1. Intro ........................... |totitle-intro|
    2. Usage ........................... |totitle-usage|
    3. Words to capitalize ............. |totitle-words|
    4. Operator ........................ |totitle-operator|
    5. Key-binding ..................... |totitle-keybinding|
    6. Bugs ............................ |totitle-bug-report|
    7. Contributing .................... |totitle-contributing|
    8. Credits ......................... |totitle-credits|

```
This lets you jump to the definition. If you put your cursor somewhere on `|totitle-intro|` and press `Ctrl-]`, Vim will jump to the definition of that word. In this case, it will jump to the `*totitle-intro*` location. This is how you can link to different keywords in a help doc.

There is not a right or wrong way to write a doc file in Vim. If you look at different plugins by different authors, many of them use different formats. The point is to make an easy-to-understand help doc for your users.

Finally, if you are writing your own plugin locally at first and you want to test the documentation page, simply adding a txt file inside the `~/.vim/docs/` won't automatically make your keywords searchable. You need to instruct Vim to add your doc page. Run the helptags command: `:helptags ~/.vim/doc` to create new tag files. Now you can start searching for your keywords.

## Conclusion

You made it to the end! This chapter is the amalgamation of all the Vimscript chapters. Here you are finally putting to practice what you've learned so far. Hopefully having read this, you understood not only how to create Vim plugins, but also encouraged you to write your own plugin. 

Whenever you find yourself repeating the same sequence of actions multiple times, you should try to create your own! It was said that you shouldn't reinvent the wheel. However, I think it can be beneficial to reinvent the wheel for the sake of learning. Read other people's plugins. Recreate them. Learn from them. Write your own! Who knows, maybe you will write the next awesome, super-popular plugin after reading this. Maybe you will be the next legendary Tim Pope. When that happens, let me know! 
