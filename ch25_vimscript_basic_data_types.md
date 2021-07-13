# Ch24. Vimscript Basic Data Types

In the next few chapters, you will learn about Vimscript, Vim's built-in programming language.

When learning a new language, there are three basic elements to look for:
- Primitives
- Means of Combination
- Means of Abstraction

In this chapter, you will learn Vim's primitive data types.

## Data Types

Vim has 10 different data types:
- Number
- Float
- String
- List
- Dictionary
- Special
- Funcref
- Job
- Channel
- Blob

I will cover the first six data types here. In Ch. 27, you will learn about Funcref. For more about Vim data types, check out `:h variables`.

## Following Along With Ex Mode

Vim technically does not have a built-in REPL, but it has a mode, Ex mode, that can be used like one. You can go to the Ex mode with `Q` or `gQ`. The Ex mode is like an extended command-line mode (it's like typing command-line mode commands non-stop). To quit the Ex mode, type `:visual`.

You can use either `:echo` or `:echom` on this chapter and the subsequent Vimscript chapters to code along. They are like `console.log` in JS or `print` in Python. The `:echo` command prints the evaluated expression you give. The `:echom` command does the same, but in addition, it stores the result in the message history.

```viml
:echom "hello echo message"
```

You can view the message history with:

```
:messages
```

To clear your message history, run:

```
:messages clear
```

## Number

Vim has 4 different number types: decimal, hexadecimal, binary, and octal. By the way, when I say number data type, often this means an integer data type. In this guide, I will use the terms number and integer interchangeably.

### Decimal

You should be familiar with the decimal system. Vim accepts positive and negative decimals. 1, -1, 10, etc. In Vimscript programming, you will probably be using the decimal type most of the time.

### Hexadecimal

Hexadecimals start with `0x` or `0X`. Mnemonic: He**x**adecimal.

### Binary

Binaries start with `0b` or `0B`. Mnemonic: **B**inary.

### Octal

Octals start with `0`, `0o`, and `0O`. Mnemonic: **O**ctal.

### Printing Numbers

If you `echo` either a hexadecimal, a binary, or an octal number, Vim automatically converts them to decimals.

```viml
:echo 42
" returns 42

:echo 052
" returns 42

:echo 0b101010
" returns 42

:echo 0x2A
" returns 42
```

### Truthy and Falsy

In Vim, a 0 value is falsy and all non-0 values are truthy.

The following will not echo anything.

```viml
:if 0
:  echo "Nope"
:endif
```

However, this will:

```viml
:if 1
:  echo "Yes"
:endif
```

Any values other than 0 is truthy, including negative numbers. 100 is truthy. -1 is truthy.

### Number Arithmetic

Numbers can be used to run arithmetic expressions:

```viml
:echo 3 + 1
" returns 4

: echo 5 - 3
" returns 2

:echo 2 * 2
" returns 4

:echo 4 / 2
" returns 2
```

When dividing a number with a remainder, Vim drops the remainder.

```viml
:echo 5 / 2
" returns 2 instead of 2.5
```

To get a more accurate result, you need to use a float number.

## Float

Floats are numbers with trailing decimals. There are two ways to represent floating numbers: dot point notation (like 31.4) and exponent (3.14e01). Similar to numbers, you can use positive and negative signs:

```viml
:echo +123.4
" returns 123.4

:echo -1.234e2
" returns -123.4

:echo 0.25
" returns 0.25

:echo 2.5e-1
" returns 0.25
```

You need to give a float a dot and trailing digits. `25e-2` (no dot) and `1234.` (has a dot, but no trailing digits) are both invalid float numbers.

### Float Arithmetic

When doing an arithmetic expression between a number and a float, Vim coerces the result to a float.

```viml
:echo 5 / 2.0
" returns 2.5
```

Float and float arithmetic gives you another float.

```
:echo 1.0 + 1.0
" returns 2.0
```

## String

Strings are characters surrounded by either double-quotes (`""`) or single-quotes (`''`). "Hello", "123", and '123.4' are examples of strings.

### String Concatenation

To concatenate a string in Vim, use the `.` operator.

```viml
:echo "Hello" . " world"
" returns "Hello world"
```

### String Arithmetic

When you run arithmetic operators (`+ - * /`) with a number and a string, Vim coerces the string into a number.

```viml
:echo "12 donuts" + 3
" returns 15
```

When Vim sees "12 donuts", it extracts the 12 from the string and converts it into the number 12. Then it performs addition, returning 15. For this string-to-number coercion to work, the number character needs to be the *first character* in the string.

The following won't work because 12 is not the first character in the string:

```viml
:echo "donuts 12" + 3
" returns 3
```

This also won't work because an empty space is the first character of the string:

```viml
:echo " 12 donuts" + 3
" returns 3
```

This coercion works even with two strings:

```
:echo "12 donuts" + "6 pastries"
" returns 18
```

This works with any arithmetic operator, not only `+`:

```viml
:echo "12 donuts" * "5 boxes"
" returns 60

:echo "12 donuts" - 5
" returns 7

:echo "12 donuts" / "3 people"
" returns 4
```

A neat trick to force a string-to-number conversion is to just add 0 or multiply by 1:

```viml
:echo "12" + 0
" returns 12

:echo "12" * 1
" returns 12
```

When arithmetic is done against a float in a string, Vim treats it like an integer, not a float:

```
:echo "12.0 donuts" + 12
" returns 24, not 24.0
```

### Number and String Concatenation

You can coerce a number into a string with a dot operator (`.`):

```viml
:echo 12 . "donuts"
" returns "12donuts"
```

The coercion only works with number data type, not float. This won't work:

```
:echo 12.0 . "donuts"
" does not return "12.0donuts" but throws an error
```

### String Conditionals

Recall that 0 is falsy and all non-0 numbers are truthy. This is also true when using string as conditionals.

In the following if statement, Vim coerces "12donuts" into 12, which is truthy:

```viml
:if "12donuts"
:  echo "Yum"
:endif
" returns "Yum"
```

On the other hand, this is falsy:

```viml
:if "donuts12"
:  echo "Nope"
:endif
" rerturns nothing
```

Vim coerces "donuts12" into 0, because the first character is not a number.

### Double vs Single Quotes

Double quotes behave differently than single quotes. Single quotes display characters literally while double quotes accept special characters.

What are special characters? Check out the newline and double-quotes display:

```viml
:echo "hello\nworld"
" returns
" hello
" world

:echo "hello \"world\""
" returns "hello "world""
```

Compare that with single-quotes:

```
:echo 'hello\nworld'
" returns 'hello\nworld'

:echo 'hello \"world\"'
" returns 'hello \"world\"'
```

Special characters are special string characters that when escaped, behave differently. `\n` acts like a newline. `\"` behaves like a literal `"`. For a list of other special characters, check out `:h expr-quote`.

### String Procedures

Let's look at some built-in string procedures.

You can get the length of a string with `strlen()`.

```
:echo strlen("choco")
" returns 5
```

You can convert string to a number with `str2nr()`:

```
:echo str2nr("12donuts")
" returns 12

:echo str2nr("donuts12")
" returns 0
```

Similar to the string-to-number coercion earlier, if the number is not the first character, Vim won't catch it.

The good news is that Vim has a method that transforms a string to a float, `str2float()`:

```
:echo str2float("12.5donuts")
" returns 12.5
```

You can substitute a pattern in a string with the `substitute()` method:

```
:echo substitute("sweet", "e", "o", "g")
" returns "swoot"
```

The last parameter, "g", is the global flag. With it, Vim will substitute all matching occurrences. Without it, Vim will only substitute the first match.

```
:echo substitute("sweet", "e", "o", "")
" returns "swoet"
```

The substitute command can be combined with `getline()`. Recall that the function `getline()` gets the text on the given line number. Suppose you have the text "chocolate donut" on line 5. You can use the procedure:

```
:echo substitute(getline(5), "chocolate", "glazed", "g")
" returns glazed donut
```

There are many other string procedures. Check out `:h string-functions`.

## List

A Vimscript list is like an Array in Javascript or List in Python. It is an *ordered* sequence of items. You can mix-and-match the content with different data types:

```
[1,2,3]
['a', 'b', 'c']
[1,'a', 3.14]
[1,2,[3,4]]
```

### Sublists

Vim list is zero-indexed. You can access a particular item in a list with `[n]`, where n is the index.

```
:echo ["a", "sweet", "dessert"][0]
" returns "a"

:echo ["a", "sweet", "dessert"][2]
" returns "dessert"
```

If you go over the maximum index number, Vim will throw an error saying that the index is out of range:

```
:echo ["a", "sweet", "dessert"][999]
" returns an error
```

When you go below zero, Vim will start the index from the last element. Going past the minimum index number will also throw you an error:

```
:echo ["a", "sweet", "dessert"][-1]
" returns "dessert"

:echo ["a", "sweet", "dessert"][-3]
" returns "a"

:echo ["a", "sweet", "dessert"][-999]
" returns an error
```

You can "slice" several elements from a list with `[n:m]`, where `n` is the starting index and `m` is the ending index.

```
:echo ["chocolate", "glazed", "plain", "strawberry", "lemon", "sugar", "cream"][2:4]
" returns ["plain", "strawberry", "lemon"]
```

If you don't pass `m` (`[n:]`), Vim will return the rest of the elements starting from the nth element. If you don't pass `n` (`[:m]`), Vim will return the first element up to the mth element.

```
:echo ["chocolate", "glazed", "plain", "strawberry", "lemon", "sugar", "cream"][2:]
" returns ['plain', 'strawberry', 'lemon', 'sugar', 'cream']

:echo ["chocolate", "glazed", "plain", "strawberry", "lemon", "sugar", "cream"][:4]
" returns ['chocolate', 'glazed', 'plain', 'strawberry', 'lemon']
```

You can pass an index that exceeds the maximum items when slicing an array.

```viml
:echo ["chocolate", "glazed", "plain", "strawberry", "lemon", "sugar", "cream"][2:999]
" returns ['plain', 'strawberry', 'lemon', 'sugar', 'cream']
```

### Slicing String

You can slice and target strings just like lists:

```viml
:echo "choco"[0]
" returns "c"

:echo "choco"[1:3]
" returns "hoc"

:echo "choco"[:3]
" returns choc

:echo "choco"[1:]
" returns hoco
```

### List Arithmetic

You can use `+` to concatenate and mutate a list:

```viml
:let sweetList = ["chocolate", "strawberry"]
:let sweetList += ["sugar"]
:echo sweetList
" returns ["chocolate", "strawberry", "sugar"]
```

### List Functions

Let's explore Vim's built-in list functions.

To get the length of a list, use `len()`:

```
:echo len(["chocolate", "strawberry"])
" returns 2
```

To prepend  an element to a list, you can use `insert()`:

```
:let sweetList = ["chocolate", "strawberry"]
:call insert(sweetList, "glazed")

:echo sweetList
" returns ["glazed", "chocolate", "strawberry"]
```

You can also pass `insert()` the index where you want to prepend the element to. If you want to prepend an item before the second element (index 1):

```
:let sweeterList = ["glazed", "chocolate", "strawberry"]
:call insert(sweeterList, "cream", 1)

:echo sweeterList
" returns ['glazed', 'cream', 'chocolate', 'strawberry']
```

To remove a list item, use `remove()`. It accepts a list and the element index you want to remove.

```
:let sweeterList = ["glazed", "chocolate", "strawberry"]
:call remove(sweeterList, 1)

:echo sweeterList
" returns ['glazed', 'strawberry']
```

You can use `map()` and `filter()` on a list. To filter out element containing the phrase "choco":

```
:let sweeterList = ["glazed", "chocolate", "strawberry"]
:call filter(sweeterList, 'v:val !~ "choco"')
:echo sweeterList
" returns ["glazed", "strawberry"]

:let sweetestList = ["chocolate", "glazed", "sugar"]
:call map(sweetestList, 'v:val . " donut"')
:echo sweetestList
" returns ['chocolate donut', 'glazed donut', 'sugar donut']
```

The `v:val` variable is a Vim special variable. It is available when iterating a list or a dictionary using `map()` or `filter()`. It represents each iterated item.

For more, check out `:h list-functions`.

### List Unpacking

You can unpack a list and assign variables to the list items:

```
:let favoriteFlavor = ["chocolate", "glazed", "plain"]
:let [flavor1, flavor2, flavor3] = favoriteFlavor

:echo flavor1
" returns "chocolate"

:echo flavor2
" returns "glazed"
```

To assign the rest of list items, you can use `;` followed with a variable name:

```
:let favoriteFruits = ["apple", "banana", "lemon", "blueberry", "raspberry"]
:let [fruit1, fruit2; restFruits] = favoriteFruits

:echo fruit1
" returns "apple"

:echo restFruits
" returns ['lemon', 'blueberry', 'raspberry']
```

### Modifying List

You can modify a list item directly:

```
:let favoriteFlavor = ["chocolate", "glazed", "plain"]
:let favoriteFlavor[0] = "sugar"
:echo favoriteFlavor
" returns ['sugar', 'glazed', 'plain']
```

You can mutate multiple list items directly:

```
:let favoriteFlavor = ["chocolate", "glazed", "plain"]
:let favoriteFlavor[2:] = ["strawberry", "chocolate"]
:echo favoriteFlavor
" returns ['chocolate', 'glazed', 'strawberry', 'chocolate']
```

## Dictionary

A Vimscript dictionary is an associative, unordered list. A non-empty dictionary consists of at least a key-value pair.

```
{"breakfast": "waffles", "lunch": "pancakes"}
{"meal": ["breakfast", "second breakfast", "third breakfast"]}
{"dinner": 1, "dessert": 2}
```

A Vim dictionary data object uses string for key. If you try to use a number, Vim will coerce it into a string.

```
:let breakfastNo = {1: "7am", 2: "9am", "11ses": "11am"}

:echo breakfastNo
" returns {'1': '7am', '2': '9am', '11ses': '11am'}
```

If you are too lazy to put quotes around each key, you can use the `#{}` notation:

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}

:echo mealPlans
" returns {'lunch': 'pancakes', 'breakfast': 'waffles', 'dinner': 'donuts'}
```

The only requirement for using the `#{}` syntax is that each key must be either:

- ASCII character.
- Digit.
- An underscore (`_`).
- A hyphen (`-`).

Just like list, you can use any data type as values.

```
:let mealPlan = {"breakfast": ["pancake", "waffle", "hash brown"], "lunch": WhatsForLunch(), "dinner": {"appetizer": "gruel", "entree": "more gruel"}}
```

### Accessing Dictionary

To access a value from a dictionary, you can call the key with either the square brackets (`['key']`) or the dot notation (`.key`).

```
:let meal = {"breakfast": "gruel omelettes", "lunch": "gruel sandwiches", "dinner": "more gruel"}

:let breakfast = meal['breakfast']
:let lunch = meal.lunch

:echo breakfast
" returns "gruel omelettes"

:echo lunch
" returns "gruel sandwiches"
```

### Modifying Dictionary

You can modify or even add a dictionary content:

```
:let meal = {"breakfast": "gruel omelettes", "lunch": "gruel sandwiches"}

:let meal.breakfast = "breakfast tacos"
:let meal["lunch"] = "tacos al pastor"
:let meal["dinner"] = "quesadillas"

:echo meal
" returns {'lunch': 'tacos al pastor', 'breakfast': 'breakfast tacos', 'dinner': 'quesadillas'}
```

### Dictionary Functions

Let's explore some of Vim's built-in functions to handle dictionaries.

To check the length of a dictionary, use `len()`.

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}

:echo len(meaPlans)
" returns 3
```

To see if a dictionary contains a specific key, use `has_key()`.

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}

:echo has_key(mealPlans, "breakfast")
" returns 1

:echo has_key(mealPlans, "dessert")
" returns 0
```

To see if a dictionary has any item, use `empty()`. The `empty()` procedure works with all data types: list, dictionary, string, number, float, etc.

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}
:let noMealPlan = {}

:echo empty(noMealPlan)
" returns 1

:echo empty(mealPlans)
" returns 0
```

To remove an entry from a dictionary, use `remove()`.

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}

:echo "removing breakfast: " . remove(mealPlans, "breakfast")
" returns "removing breakfast: 'waffles'""

:echo mealPlans
" returns {'lunch': 'pancakes', 'dinner': 'donuts'}
```

To convert a dictionary into a list of lists, use `items()`:

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}

:echo items(mealPlans)
" returns [['lunch', 'pancakes'], ['breakfast', 'waffles'], ['dinner', 'donuts']]
```

`filter()` and `map()` are also available.

```
:let breakfastNo = {1: "7am", 2: "9am", "11ses": "11am"}
:call filter(breakfastNo, 'v:key > 1')

:echo breakfastNo
" returns {'2': '9am', '11ses': '11am'}
```

Since a dictionary contains key-value pairs, Vim provides `v:key` special variable that works similar to `v:val`. When iterating through a dictionary, `v:key` will hold the value of the current iterated key. 

If you have a `mealPlans` dictionary, you can map it using `v:key`.

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}
:call map(mealPlans, 'v:key . " and milk"')

:echo mealPlans
" returns {'lunch': 'lunch and milk', 'breakfast': 'breakfast and milk', 'dinner': 'dinner and milk'}
```

Similarly, you can map it using `v:val`:

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}
:call map(mealPlans, 'v:val . " and milk"')

:echo mealPlans
" returns {'lunch': 'pancakes and milk', 'breakfast': 'waffles and milk', 'dinner': 'donuts and milk'}
```

To see more dictionary functions, check out `:h dict-functions`.

## Special Primitives

Vim has special primitives:

- `v:false`
- `v:true`
- `v:none`
- `v:null`

By the way, `v:` is Vim's built-in variable. They will be covered more in a later chapter.

In my experience, you won't use these special primitives often. If you need a truthy / falsy value, you can just use 0 (falsy) and non-0 (truthy). If you need an empty string, just use `""`. But it is still good to know, so let's quickly go over them.

### True

This is equivalent to `true`. It is equivalent to a number with value of non-0 . When decoding json with `json_encode()`, it is interpreted as "true".

```
:echo json_encode({"test": v:true})
" returns {"test": true}
```

### False

This is equivalent to `false`. It is equivalent to a number with value of 0. When decoding json with `json_encode()`, it is interpreted as "false".

```
:echo json_encode({"test": v:false})
" returns {"test": false}
```

### None

It is equivalent to an empty string. When decoding json with `json_encode()`, it is interpreted as an empty item (`null`).

```
:echo json_encode({"test": v:none})
" returns {"test": null}
```

### Null

Similar to `v:none`.

```
:echo json_encode({"test": v:null})
" returns {"test": null}
```

## Learn Data Types the Smart Way

In this chapter, you learned about Vimscript's basic data types: number, float, string, list, dictionary, and special. Learning these is the first step to start Vimscript programming.

In the next chapter, you will learn how to combine them for writing expressions like equalities, conditionals, and loops.
