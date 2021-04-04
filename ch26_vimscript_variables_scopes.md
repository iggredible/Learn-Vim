# Ch26. Vimscript Variables And Scopes

Before diving into Vimscript functions, let's learn about the different sources and scopes of Vim variables.

## Mutable And Immutable Variables

You can assign a value to a variable in Vim with `let`:

```
let pancake = "pancake"
```

Later you can call that variable any time.

```
echo pancake
" returns "pancake"
```

`let` is mutable, meaning you can change the value at any time in the future.

```
let pancake = "pancake"
let pancake = "not waffles"

echo pancake
" returns "not waffles"
```

Notice that when you want to change the value of a set variable, you still need to use `let`.

```
let beverage = "milk"

beverage = "orange juice"
" throws an error
```

You can define an immutable variable with `const`. Being immutable, once a variable value is assigned, you cannot reassign it with a different value.

```
const waffle = "waffle"
const waffle = "pancake"
" throws an error
```

## Variable Sources

There are three sources for variables: environment variable, option variable, and register variable.

### Environment Variable

Vim can access your terminal environment variable. For example, if you have the `SHELL` environment variable available in your terminal, you can access it from Vim with:

```
echo $SHELL
" returns $SHELL value. In my case, it returns /bin/bash
```

### Option Variable

You can access Vim options with `&` (these are the settings you access with `set`).

For example, to see what background Vim uses, you can run:

```
echo &background
" returns either "light" or "dark"
```

Alternatively, you can always run `set background?` to see the value of the `background` option.

### Register Variable

You can access Vim registers (Ch. 08) with `@`.

Suppose the value "chocolate" is already saved in register a. To access it, you can use `@a`. You can also update it with `let`.

```
echo @a
" returns chocolate

let @a .= " donut"

echo @a
" returns "chocolate donut"
```

Now when you paste from register `a` (`"ap`), it will return "chocolate donut". The operator `.=` concatenates two strings. The expression `let @a .= " donut"` is the same as `let @a = @a . " donut"`

## Variable Scopes

There are 9 different variable scopes in Vim. You can recognize them from their prepended letter:

```
g:           Global variable
{nothing}    Global variable
b:           Buffer-local variable
w:           Window-local variable
t:           Tab-local variable
s:           Sourced Vimscript variable
l:           Function local variable
a:           Function formal parameter variable
v:           Built-in Vim variable
```

### Global variable

When you are declaring a "regular" variable:

```
let pancake = "pancake"
```

`pancake` is actually a global variable. When you define a global variable, you can call them from anywhere.

Prepending `g:` to a variable also creates a global variable.

```
let g:waffle = "waffle"
```

In this case both `pancake` and `g:waffle` have the same scope. You can call each of them with or without `g:`.

```
echo pancake
" returns "pancake"

echo g:pancake
"returns "pancake"

echo waffle
" returns "waffle"

echo g:waffle
" returns "waffle"
```

### Buffer Variable

A variable preceded with `b:` is a buffer variable. A buffer variable is a variable that is local to the current buffer (Ch. 02). If you have multiple buffers open, each buffer will have their own separate list of buffer variables.

In buffer 1:

```
const b:donut = "chocolate donut"
```

In buffer 2:

```
const b:donut = "blueberry donut"
```

If you run `echo b:donut` from buffer 1, it will return "chocolate donut". If you run it from buffer 2, it will return "blueberry donut".

On the side note, Vim has a *special* buffer variable `b:changedtick` that keeps track of all the changes done to the current buffer.

1. Run `echo b:changedtick` and note the number it returns..
2. Make changes in Vim.
3. Run `echo b:changedtick` again and note the number it now returns.

### Window Variable

A variable preceded with `w:` is a window variable. It exists only in that window.

In window 1:

```
const w:donut = "chocolate donut"
```

In window 2:

```
const w:donut = "raspberry donut"
```

On each window, you can call `echo w:donut` to get unique values.

### Tab Variable

A variable preceded with `t:` is a tab variable. It exists only in that tab.

In tab 1:

```
const t:donut = "chocolate donut"
```

In tab 2:

```
const t:donut = "blackberry donut"
```

On each tab, you can call `echo t:donut` to get unique values.

### Script variable

A variable preceded with `s:` is a script variable. These variables can only be accessed from inside that script.

If you have an arbitrary file `dozen.vim` and inside it you have:

```
let s:dozen = 12

function Consume()
  let s:dozen -= 1
  echo s:dozen " is left"
endfunction
```

Source the file with `:source dozen.vim`. Now call the `Consume` function:

```
:call Consume()
" returns "11 is left"

:call Consume()
" returns "10 is left"

:echo s:dozen
" Undefined variable error
```

When you call `Consume`, you see it decrements the `s:dozen` value as expected. When you try to get `s:dozen` value directly, Vim won't find it because you are out of scope. `s:dozen` is only accessible from inside `dozen.vim`.

Each time you source the `dozen.vim` file, it resets the `s:dozen` counter. If you are in the middle of decrementing `s:dozen` value and you run `:source dozen.vim`, the counter resets back to 12. This can be a problem for unsuspecting users. To fix this issue, refactor the code:

```
if !exists("s:dozen")
  let s:dozen = 12
endif

function Consume()
  let s:dozen -= 1
  echo s:dozen
endfunction
```

Now when you source `dozen.vim` while in the middle of decrementing, Vim reads `!exists("s:dozen")`, finds that it is true, and doesn't reset the value back to 12.

### Function Local And Function Formal Parameter variable

Both the function local variable (`l:`) and the function formal variable (`a:`) will be covered in the next chapter.

### Built-in Vim Variables

A variable prepended with `v:` is a special built-in Vim variable. You cannot define these variables. You have seen some of them already.
- `v:version` tells you what Vim version you are using.
- `v:key` contains the current item value when iterating through a dictionary.
- `v:val` contains the current item value when running a `map()` or `filter()` operation.
- `v:true`, `v:false`, `v:null`, and `v:none` are special data types.

There are other variables. For a list of Vim built-in variables, check out `:h vim-variable` or `:h v:`.

## Using Vim Variable Scopes The Smart Way

Being able to quickly access environment, option, and register variables give you a broad flexibility to customize your editor and terminal environment. You also learned that Vim has 9 different variable scopes, each existing under a certain constraints. You can take advantage of these unique variable types to decouple your program.

You made it this far. You learned about data types, means of combinations, and variable scopes. Only one thing is left: functions.
