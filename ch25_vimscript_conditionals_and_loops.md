# Ch25. Vimscript Conditionals And Loops

After learning what the basic data types are, the next step is to learn how to combine them together to start writing a basic program. A basic program consists of conditionals and loops.

In this chapter, you will learn how to use Vimscript data types to write conditionals and loops.

## Relational Operators

Vimscript relational operators are similar to many programming languages:

```
a == b		equal to
a != b		not equal to
a >  b		greater than
a >= b		greater than or equal to
a <  b		less than
a <= b		less than or equal to
```

For example:

```
:echo 5 == 5
:echo 5 != 5
:echo 10 > 5
:echo 10 >= 5
:echo 10 < 5
:echo 5 <= 5
```

Recall that strings are coerced into numbers in an arithmetic expression. Here Vim also coerces strings into numbers in an equality expression. "5foo" is coerced into 5 (truthy):

```
:echo 5 == "5foo"
" returns true
```

Also recall that if you start a string with a non-numerical character like "foo5", the string is converted into number 0 (falsy).

```
echo 5 == "foo5"
" returns false
```

### String Logic Operators

Vim has more relational operators for comparing strings:

```
a =~ b
a !~ b
```

For examples:

```
let str = "hearty breakfast"

echo str =~ "hearty"
" returns true

echo str =~ "dinner"
" returns false

echo str !~ "dinner"
" returns true
```

The `=~` operator performs a regex match against the given string. In the example above, `str =~ "hearty"` returns true because `str` *contains* the "hearty" pattern. You can always use `==` and `!=`, but using them will compare the expression against the entire string. `=~` and `!~` are more flexible choices.

```
echo str == "hearty"
" returns false

echo str == "hearty breakfast"
" returns true
```

Let's try this one. Note the uppercase "H":

```
echo str =~ "Hearty"
" true
```

It returns true even though "Hearty" is capitalized. Interesting... It turns out that my Vim setting is set to ignore case (`set ignorecase`), so when Vim checks for equality, it uses my Vim setting and ignores the case. If I were to turn off ignore case (`set noignorecase`), the comparison now returns false.

```
set noignorecase
echo str =~ "Hearty"
" returns false because case matters

set ignorecase
echo str =~ "Hearty"
" returns true because case doesn't matter
```

If you are writing a plugin for others, this is a tricky situation. Does the user use `ignorecase` or `noignorecase`? You definitely do *not* want to force your users to change their ignore case option. So what do you do?

Luckily, Vim has an operator that can *always* ignore or match case. To always match case, add a `#` at the end.

```
set ignorecase
echo str =~# "hearty"
" returns true

echo str =~# "HearTY"
" returns false

set noignorecase
echo str =~# "hearty"
" true

echo str =~# "HearTY"
" false

echo str !~# "HearTY"
" true
```

To always ignore case when comparing, append it with `?`:

```
set ignorecase
echo str =~? "hearty"
" true

echo str =~? "HearTY"
" true

set noignorecase
echo str =~? "hearty"
" true

echo str =~? "HearTY"
" true

echo str !~? "HearTY"
" false
```

I prefer to use `#` to always match the case and be on the safe side.

## If

Now that you have seen Vim's equality expressions, let's touch a fundamental conditional operator, the `if` statement.

At minimum, the syntax is:

```
if {clause}
  {some expression}
endif
```

You can extend the case analysis with `elseif` and `else`.

```
if {predicate1}
  {expression1}
elseif {predicate2}
  {expression2}
elseif {predicate3}
  {expression3}
else
  {expression4}
endif
```

For example, the plugin [vim-signify](https://github.com/mhinz/vim-signify) uses a different installation method depending on your Vim settings. Below is the installation instruction from their `readme`, using the `if` statement:

```
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif
```

## Ternary Expression

Vim has a ternary expression for a one-liner case analysis:

```
{predicate} ? expressiontrue : expressionfalse
```

For example:

```
echo 1 ? "I am true" : "I am false"
```

Since 1 is truthy, Vim echoes "I am true". Suppose you want to conditionally set the `background` to dark if you are using Vim past a certain hour. Add this to vimrc:

```
let &background = strftime("%H") < 18 ? "light" : "dark"
```

`&background` is the `'background'` option in Vim. `strftime("%H")` returns the current time in hours. If it is not yet 6 PM, use a light background. Otherwise, use a dark background.

## Or

The logical "or" (`||`) works like many programming languages.

```
{Falsy expression}  || {Falsy expression}   false
{Falsy expression}  || {Truthy expression}  true
{Truthy expression} || {Falsy expression}   true
{Truthy expression} || {Truthy expression}  true
```

Vim evaluates the expression and return either 1 (truthy) or 0 (falsy).

```
echo 5 || 0
" returns 1

echo 5 || 5
" returns 1

echo 0 || 0
" returns 0

echo "foo5" || "foo5"
" returns 0

echo "5foo" || "foo5"
" returns 1
```

If the current expression evaluates to truthy, the subsequent expression won't be evaluated.

```
let one_dozen = 12

echo one_dozen || two_dozen
" returns 1

echo two_dozen || one_dozen
" returns error
```

Note that `two_dozen` is never defined. The expression `one_dozen || two_dozen` doesn't throw any error because `one_dozen` is evaluated first found to be truthy, so Vim doesn't evaluate `two_dozen`.

## And

The logical "and" (`&&`) is the complement of the logical or.

```
{Falsy Expression}  && {Falsy Expression}   false
{Falsy expression}  && {Truthy expression}  false
{Truthy Expression} && {Falsy Expression}   false
{Truthy expression} && {Truthy expression}  true
```

For example:

```
echo 0 && 0
" returns 0

echo 0 && 10
" returns 0
```

Unlike "or", "and" will evaluate the subsequent expression after it reaches the first falsy expression. It will continue to evaluate the subsequent truthy expressions until the end or when it sees the first falsy expression.

```
let one_dozen = 12
echo one_dozen && 10
" returns 1

echo one_dozen && v:false
" returns 0

echo one_dozen && two_dozen
" returns error

echo exists("one_dozen") && one_dozen == 12
" returns 1
```

## For

The `for` loop is commonly used with the list data type.

```
let breakfasts = ["pancakes", "waffles", "eggs"]

for breakfast in breakfasts
  echo breakfast
endfor
```

It works with nested list:

```
let meals = [["breakfast", "pancakes"], ["lunch", "fish"], ["dinner", "pasta"]]

for [meal_type, food] in meals
  echo "I am having " . food . " for " . meal_type
endfor
```

You can technically use the `for` loop with a dictionary using the `keys()` method.

```
let beverages = #{breakfast: "milk", lunch: "orange juice", dinner: "water"}
for beverage_type in keys(beverages)
  echo "I am drinking " . beverages[beverage_type] . " for " . beverage_type
endfor
```

## While

Another common loop is the `while` loop.

```
let counter = 1
while counter < 5
  echo "Counter is: " . counter
  let counter += 1
endwhile
```

To get the content of the current line to the last line:

```
let current_line = line(".")
let last_line = line("$")

while current_line <= last_line
  echo getline(current_line)
  let current_line += 1
endwhile
```

## Error Handling

Often your program doesn't run the way you expect it to. As a result, it throws you for a loop (pun intended). What you need is a proper error handling.

### Break

When you use `break` inside a `while` or `for` loop, it stops the loop.

To get the texts from the start of the file to the current line, but stop when you see the word "donut":

```
let line = 0
let last_line = line("$")
let total_word = ""

while line <= last_line
  let line += 1
  let line_text = getline(line)
  if line_text =~# "donut"
    break
  endif
  echo line_text
  let total_word .= line_text . " "
endwhile

echo total_word
```

If you have the text:

```
one
two
three
donut
four
five
```

Running the above `while` loop gives "one two three" and not the rest of the text because the loop breaks once it matches "donut".

### Continue

The `continue` method is similar to `break`, where it is invoked during a loop. The difference is that instead of breaking out of the loop, it just skips that current iteration.

Suppose you have the same text but instead of `break`, you use `continue`:

```
let line = 0
let last_line = line("$")
let total_word = ""

while line <= last_line
  let line += 1
  let line_text = getline(line)
  if line_text =~# "donut"
    continue
  endif
  echo line_text
  let total_word .= line_text . " "
endwhile

echo total_word
```

This time it returns `one two three four five`. It skips the line with the word "donut", but the loop continues.

### Try, Finally, And Catch

Vim has a `try`, `finally`, and `catch` to handle errors. To simulate an error, you can use the `throw` command.

```
try
  echo "Try"
  throw "Nope"
endtry
```

Run this. Vim will complain with `"Exception not caught: Nope` error.

Now add a catch block:

```
try
  echo "Try"
  throw "Nope"
catch
  echo "Caught it"
endtry
```

Now there is no longer any error. You should see "Try" and "Caught it" displayed.

Let's remove the `catch` and add a `finally`:

```
try
  echo "Try"
  throw "Nope"
  echo "You won't see me"
finally
  echo "Finally"
endtry
```

Run this. Now Vim displays the error and "Finally".

Let's put all of them together:

```
try
  echo "Try"
  throw "Nope"
catch
  echo "Caught it"
finally
  echo "Finally"
endtry
```

This time Vim displays both "Caught it" and "Finally". No error is displayed because Vim caught it.

Errors come from different places. Another source of error is calling a nonexistent function, like `Nope()` below:

```
try
  echo "Try"
  call Nope()
catch
  echo "Caught it"
finally
  echo "Finally"
endtry
```

The difference between `catch` and `finally` is that `finally` is always run, error or not,  where a catch is only run when your code gets an error.

You can catch specific error with `:catch`. According to `:h :catch`:

```
catch /^Vim:Interrupt$/.             " catch interrupts (CTRL-C)
catch /^Vim\\%((\\a\\+)\\)\\=:E/.    " catch all Vim errors
catch /^Vim\\%((\\a\\+)\\)\\=:/.     " catch errors and interrupts
catch /^Vim(write):/.                " catch all errors in :write
catch /^Vim\\%((\\a\\+)\\)\\=:E123:/ " catch error E123
catch /my-exception/.                " catch user exception
catch /.*/                           " catch everything
catch.                               " same as /.*/
```

Inside a `try` block, an interrupt is considered a catchable error.

```
try
  catch /^Vim:Interrupt$/
  sleep 100
endtry
```

In your vimrc, if you use a custom colorscheme, like [gruvbox](https://github.com/morhetz/gruvbox), and you accidentally delete the colorscheme directory but still have the line `colorscheme gruvbox` in your vimrc, Vim will throw an error when you `source` it. To fix this, I added this in my vimrc:

```
try
  colorscheme gruvbox
catch
  colorscheme default
endtry
```

Now if you `source` vimrc without `gruvbox` directory, Vim will use the `colorscheme default`.

## Learn conditionals the smart way

In the previous chapter, you learned about Vim basic data types. In this chapter, you learned how to combine them to write basic programs using conditionals and loops. These are the building blocks of programming.

Next, let's learn about variable scopes.
