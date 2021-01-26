# Ch27. Vimscript Functions

Functions are means of abstraction, the third element in learning a new language.

In the previous chapters, you have seen Vimscript native functions (`len()`, `filter()`, `map()`, etc.) and custom functions in action. In this chapter, you will go deeper to learn how functions work.

## Function Syntax Rules

At the core, a Vimscript function has the following syntax:

```
function {FunctionName}()
  {do-something}
endfunction
```

A function definition must start with a capital letter. It starts with the `function` keyword and ends with `endfunction`. Below is a valid function:

```
function! Tasty()
  echo "Tasty"
endfunction
```

The following is not a valid function because it does not start with a capital letter.

```
function tasty()
  echo "Tasty"
endfunction
```

If you prepend a function with the script variable (`s:`), you can use it with a lower case. `function s:tasty()` is a valid name. The reason why Vim requires you to use an uppercase name is to prevent confusion with Vim's built-in functions (all lowercase).

A function name cannot start with a number. `1Tasty()` is not a valid function name, but `Tasty1()` is. A function also cannot contain non-alphanumeric characters besides `_`. `Tasty-food()`, `Tasty&food()`, and `Tasty.food()` are not valid function names. `Tasty_food()` *is*.

If you define two functions with the same name, Vim will throw an error complaining that the function `Tasty` already exists. To overwrite the previous function with the same name, add a `!` after the `function` keyword.

```
function! Tasty()
  echo "Tasty"
endfunction
```

## Listing Available Functions

To see all the built-in and custom functions in Vim, you can run `:function` command. To look at the content of the `Tasty` function, you can run `:function Tasty`.

You can also search for functions with pattern with `:function /pattern`, similar to Vim's search navigation (`/pattern`). To search for all function containing the phrase "map", run `:function /map`. If you use external plugins, Vim will display the functions defined in those plugins.

If you want to look at where a function originates, you can use the `:verbose` command with the `:function` command. To look at where all the functions containing teh word "map" are originated, run:

```
:verbose function /map
```

When I ran it, I got a number of results. This one tells me that the function `fzf#vim#maps` autoload function (to recap, refer to Ch. 23) is written inside `~/.vim/plugged/fzf.vim/autoload/fzf/vim.vim` file, on line 1263. This is useful for debugging.

```
function fzf#vim#maps(mode, ...)
        Last set from ~/.vim/plugged/fzf.vim/autoload/fzf/vim.vim line 1263
```

## Removing A Function

To remove an existing function, use `:delfunction {function-name}`. To delete `Tasty`, run `:delfunction Tasty`.

## Function Return Value

For a function to return a value, you need to pass it an explicit `return` value. Otherwise, Vim automatically returns an implicit value of 0.

```
function! Tasty()
  echo "Tasty"
endfunction
```

An empty `return` is also equivalent to a 0 value.

```
function! Tasty()
  echo "Tasty"
  return
endfunction
```

If you run `:echo Tasty()` using the function above, after Vim displays "Tasty", it returns 0, the implicit return value. To make `Tasty()` to return "Tasty" value, you can do this:

```
function! Tasty()
  return "Tasty"
endfunction
```

Now when you run `:echo Tasty()`, it returns "Tasty" string.

You can use a function inside an expression. Vim will use the return value of that function. The expression `:echo Tasty() . " Food!"` outputs "Tasty Food!"

## Formal Arguments

To pass a formal argument `food` to your `Tasty` function, you can do this:

```
function! Tasty(food)
  return "Tasty " . a:food
endfunction

echo Tasty("pastry")
" returns "Tasty pastry"
```

`a:` is one of the variable scopes mentioned in the last chapter. It is the formal parameter variable. It is Vim's way to get a formal parameter value in a function. Without it, Vim will throw an error:

```
function! Tasty(food)
  return "Tasty " . food
endfunction

echo Tasty("pasta")
" returns "undefined variable name" error
```

## Function Local Variable

Let's address the other variable you didn't learn on the previous chapter: the function local variable (`l:`).

When writing a function, you can define a variable inside:

```
function! Yummy()
  let location = "tummy"
  return "Yummy in my " . location
endfunction

echo Yummy()
" returns "Yummy in my tummy"
```

In this context, the variable `location` is the same as `l:location`. When you define a variable in a function, that variable is *local* to that function. When a user sees `location`, it could easily be mistaken as a global variable. I prefer to be more verbose than not, so I prefer to put `l:` to indicate that this is a function variable.

Another reason to use `l:count` is that Vim has special variables with aliases that look like regular variables. `v:count` is one example. It has an alias of `count`. In Vim, calling `count` is the same as calling `v:count`. It is easy to accidentally call one of those special variables.

```
function! Calories()
  let count = "count"
  return "I do not " . count . " my calories"
endfunction

echo Calories()
" throws an error
```

The execution above throws an error because `let count = "Count"` implicitly attempts to redefine Vim's special variable `v:count`. Recall that special variables (`v:`) are read-only. You cannot mutate it. To fix it, use `l:count`:

```
function! Calories()
  let l:count = "count"
  return "I do not " . l:count . " my calories"
endfunction

echo Calories()
" returns "I do not count my calories"
```

## Calling A Function

Vim has a `:call` command to call a function.

```
function! Tasty(food)
  return "Tasty " . a:food
endfunction

call Tasty("gravy")
```

The `call` command does not output the return value. Let's call it with `echo`.

```
echo call Tasty("gravy")
```

Woops, you get an error. The `call` command above is a command-line command (`:call`). The `echo` command above is also a command-line command (`:echo`). You cannot call a command-line command with another command-line command. Let's try a different flavor of the `call` command:

```
echo call("Tasty", ["gravy"])
" returns "Tasty gravy"
```

To clear any confusion, you have just used two different `call` commands: the `:call` command-line command and the `call()` function. The `call()` function accepts as its first argument the function name (string) and its second argument the formal parameters (list).

## Default Argument

You can provide a function parameter with a default value with `=`. If you call `Breakfast` with only one argument, the `beverage` argument will use the "milk" default value.

```
function! Breakfast(meal, beverage = "Milk")
  return "I had " . a:meal . " and " . a:beverage . " for breakfast"
endfunction

echo Breakfast("Hash Browns")
" returns hash browns and milk

echo Breakfast("Cereal", "Orange Juice")
" returns Cereal and Orange Juice
```

## Variable Arguments

You can pass a variable argument with three-dots (`...`). Variable argument is useful when you don't know how many variables a user will give.

Suppose you are creating an all-you-can-eat buffet (you'll never know how much food your customer will eat):

```
function! Buffet(...)
  return a:1
endfunction
```

If you run `echo Buffet("Noodles")`, it will output "Noodles". Vim uses `a:1` to print the *first* argument passed to `...`, up to 20 (`a:1` is the first argument, `a:2` is the second argument, etc). If you run `echo Buffet("Noodles", "Sushi")`, it will still display just "Noodles", let's update it:

```
function! Buffet(...)
  return a:1 . " " . a:2
endfunction

echo Buffet("Noodles", "Sushi")
" Returns "Noodles Sushi"
```

The problem with this approach is if you now run `echo Buffet("Noodles")` (with only one variable), Vim complains that it has an undefined variable `a:2`. How can you make it flexible enough to display exactly what the user gives?

Luckily, Vim has a special variable `a:0` to display the *length* of the argument passed into `...`.

```
function! Buffet(...)
  return a:0
endfunction

echo Buffet("Noodles")
" returns 1

echo Buffet("Noodles", "Sushi")
" returns 2

echo Buffet("Noodles", "Sushi", "Ice cream", "Tofu", "Mochi")
" returns 5
```

With this, you can iterate using the length of the argument.

```
function! Buffet(...)
  let l:food_counter = 1
  let l:foods = ""
  while l:food_counter <= a:0
    let l:foods .= a:{l:food_counter} . " "
    let l:food_counter += 1
  endwhile
  return l:foods
endfunction
```

The curly braces `a:{l:food_counter}` is a string interpolation, it uses the value of `food_counter` counter to call the formal parameter arguments `a:1`, `a:2`, `a:3`, etc.

```
echo Buffet("Noodles")
" returns "Noodles"

echo Buffet("Noodles", "Sushi", "Ice cream", "Tofu", "Mochi")
" returns everything you passed: "Noodles Sushi Ice cream Tofu Mochi"
```

The variable argument has one more special variable: `a:000`. It has the value of all variable arguments in a list format.

```
function! Buffet(...)
  return a:000
endfunction

echo Buffet("Noodles")
" returns ["Noodles"]

echo Buffet("Noodles", "Sushi", "Ice cream", "Tofu", "Mochi")
" returns ["Noodles", "Sushi", "Ice cream", "Tofu", "Mochi"]
```

Let's refactor the function to use a `for` loop:

```
function! Buffet(...)
  let l:foods = ""
  for food_item in a:000
    let l:foods .= food_item . " "
  endfor
  return l:foods
endfunction

echo Buffet("Noodles", "Sushi", "Ice cream", "Tofu", "Mochi")
" returns Noodles Sushi Ice cream Tofu Mochi
```

## Range

You can define a *ranged* Vimscript function by adding a `range` keyword at the end of the function definition. A ranged function has two special variables available: `a:firstline` and `a:lastline`.

```
function! Breakfast() range
  echo a:firstline
  echo a:lastline
endfunction
```

If you are on line 100 and you run `call Breakfast()`, it will display 100 for both `firstline` and `lastline`. If you visually highlight (`v`, `V`, or `Ctrl-V`) lines 101 to 105 and run `call Breakfast()`, `firstline` displays 101 and `lastline` displays 105. `firstline` and `lastline` displays the minimum and maximum range where the function is called.

You can also use `:call` and passing it a range. If you run `:11,20call Breakfast()`, it will display 11 for `firstline` and 20 for `lastline`.

You might ask, "That's nice that Vimscript function accepts range, but can't I get the line number with `line(".")`? Won't it do the same thing?"

Good question. If this is what you mean:

```
function! Breakfast()
  echo line(".")
endfunction
```

Calling `:11,20call Breakfast()` executes the `Breakfast` function 10 times (one for each line in the range). Compare that if you had passed the `range` argument:

```
function! Breakfast() range
  echo line(".")
endfunction
```

Calling `11,20call Breakfast()` executes the `Breakfast` function *once*.

If you pass a `range` keyword and you pass a numerical range (like `11,20`) on `call`, Vim only executes that function once. If you don't pass a `range` keyword and you pass a numerical range (like `11,20`) on `call`, Vim executes that function N times depending on the range (in this case, N = 10).

## Dictionary

You can add a function as a dictionary item by adding a `dict` keyword when defining a function.

If you have a function `SecondBreakfast` that returns whatever `breakfast` item you have:

```
function! SecondBreakfast() dict
  return self.breakfast
endfunction
```

Let's add this function to the `meals` dictionary:

```
let meals = {"breakfast": "pancakes", "second_breakfast": function("SecondBreakfast"), "lunch": "pasta"}

echo meals.second_breakfast()
" returns "pancakes"
```

With `dict` keyword, the key variable `self` refers to the dictionary where the function is stored (in this case, the `meals` dictionary). The expression `self.breakfast` is equal to `meals.breakfast`.

An alternative way to add a function into a dictionary object to use a namespace.

```
function! meals.second_lunch()
  return self.lunch
endfunction

echo meals.second_lunch()
" returns "pasta"
```

With namespace, you do not have to use the `dict` keyword.

## Funcref

A funcref is a reference to a function. It is one of Vimscript's basic data types mentioned in Ch. 24.

The expression `function("SecondBreakfast")` above is an example of funcref. Vim has a built-in function `function()` that returns a funcref when you pass it a function name (string).

```
function! Breakfast(item)
  return "I am having " . a:item . " for breakfast"
endfunction

let Breakfastify = Breakfast
" returns error

let Breakfastify = function("Breakfast")

echo Breakfastify("oatmeal")
" returns "I am having oatmeal for breakfast"

echo Breakfastify("pancake")
" returns "I am having pancake for breakfast"
```

In Vim, if you want to assign a function to a variable, you can't just run assign it directly like `let MyVar = MyFunc`. You need to use the `function()` function, like `let MyFar = function("MyFunc")`.

You can use funcref with maps and filters. Note that maps and filters will pass an index as the first argument and the iterated value as the second argument.

```
function! Breakfast(index, item)
  return "I am having " . a:item . " for breakfast"
endfunction

let breakfast_items = ["pancakes", "hash browns", "waffles"]
let first_meals = map(breakfast_items, function("Breakfast"))

for meal in first_meals
  echo meal
endfor
```

## Lambda

A better way to use functions in maps and filters is to use lambda expression (sometimes known as unnamed function). For example:

```
let Plus = {x,y -> x + y}
echo Plus(1,2)
" returns 3

let Tasty = { -> 'tasty'}
echo Tasty()
" returns "tasty"
```

You can call a function from insisde a lambda expression:

```
function! Lunch(item)
  return "I am having " . a:item . " for lunch"
endfunction

let lunch_items = ["sushi", "ramen", "sashimi"]

let day_meals = map(lunch_items, {index, item -> Lunch(item)})

for meal in day_meals
  echo meal
endfor
```

If you don't want to call the function from inside lambda, you can refactor it:

```
let day_meals = map(lunch_items, {index, item -> "I am having " . item . " for lunch"})
```

## Method Chaining

You can chain several Vimscript functions and lambda expressions sequentially with `->`. Keep in mind that `->` must be followed by a method name *without space.*

```
Source->Method1()->Method2()->...->MethodN()
```

To convert a float to a number using method chaining:

```
echo 3.14->float2nr()
" returns 3
```

Let's do a more complicated example. Suppose that you need to capitalize the first letter of each item on a list, then sort the list, then join the list to form a string.

```
function! Capitalizer(word)
  return substitute(a:word, "\^\.", "\\u&", "g")
endfunction

function! CapitalizeList(word_list)
  return map(a:word_list, {index, word -> Capitalizer(word)})
endfunction

let dinner_items = ["bruschetta", "antipasto", "calzone"]

echo dinner_items->CapitalizeList()->sort()->join(", ")
" returns "Antipasto, Bruschetta, Calzone"
```

With method chaining, the sequence is more easily read and understood. I can just glance at `dinner_items->CapitalizeList()->sort()->join(", ")` and know exactly what is going on.

## Closure

When you define a variable inside a function, that variable exists within that function boundaries. This is called a lexical scope.

```
function! Lunch()
  let appetizer = "shrimp"

  function! SecondLunch()
    return appetizer
  endfunction

  return funcref("SecondLunch")
endfunction
```

`appetizer` is defined inside the `Lunch` function, which returns `SecondLunch` funcref. Notice that `SecondLunch` uses the `appetizer`, but in Vimscript, it doesn't have access to that variable. If you try to run `echo Lunch()()`, Vim will throw an undefined variable error.

To fix this issue, use the `closure` keyword. Let's refactor:

```
function! Lunch()
  let appetizer = "shrimp"

  function! SecondLunch() closure
    return appetizer
  endfunction

  return funcref("SecondLunch")
endfunction
```

Now if you run `echo Lunch()()`, Vim will return "shrimp".

## Learn Vimscript Functions The Smart Way

In this chapter, you learned the anatomy of Vim function. You learned how to use different special keywords `range`, `dict`, and `closure` to modify function behavior. You also learned how to use lambda and to chain multiple functions together. Functions are important tools for creating complex abstractions.

This concludes this Vim guide. However, your Vim journey doesn't end here. In fact, it actually starts now. You should have sufficient knowledge to go on your own or even create your own plugins.

Happy Vimming, friends!
