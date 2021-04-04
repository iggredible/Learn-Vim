# Ch12. Search And Substitute

This chapter covers two separate but related concepts: search and substitute. Often when editing, you need to search multiple texts based on their least common denominator patterns. By learning how to use regular expressions in search and substitute instead of literal strings, you will be able to target any text quickly.

As a side note, in this chapter, I will use `/` when talking about search. Everything you can do with `/` can also be done with `?`.

## Smart Case Sensitivity

It can be tricky trying to match the case of the search term. If you are searching for the text "Learn Vim", you can easily mistype the case of one letter and get a false search result. Wouldn't it be easier and safer if you can match any case? This is where the option `ignorecase` shines. Just add `set ignorecase` in your vimrc and all your search terms become case insensitive. Now you don't have to do `/Learn Vim` anymore, `/learn vim` will work.

However, there are times when you need to search for a case specific phrase. One way to do that is to turn off `ignorecase` option by running `set noignorecase`, but that is a lot of work to turn on and off each time you need to search for a case sensitive phrase.

To avoid toggling `ignorecase`, Vim has a `smartcase` option to search for case insensitive string if the search pattern *contains at least one uppercase character*. You can combine both `ignorecase` and `smartcase` to perform a case insensitive search when you enter all lowercase characters and a case sensitive search when you enter one or more uppercase characters.

Inside your vimrc, add:

```
set ignorecase smartcase
```

If you have these texts:

```
hello
HELLO
Hello
```

- `/hello` matches "hello", "HELLO", and "Hello".
- `/HELLO` matches only "HELLO".
- `/Hello` matches only "Hello".

There is one downside. What if you need to search for only a lowercase string? When you do `/hello`, Vim now does case insensitive search. You can use `\C` pattern anywhere in your search term to tell Vim that the subsequent search term will be case sensitive. If you do `/\Chello`, it will strictly match "hello", not "HELLO" or "Hello".

## First And Last Character In A Line

You can use `^` to match the first character in a line and `$` to match the last character in a line.

If you have this text:

```
hello hello
```

You can target the first "hello" with `/^hello`. The character that follows `^` must be the first character in a line. To target the last "hello", run `/hello$`. The character before `$` must be the last character in a line.

If you have this text:

```
hello hello friend
```

Running `/hello$` will not match anything because "friend" is the last term in that line, not "hello".

## Repeating Search

You can repeat the previous search with `//`. If you have just searched for `/hello`, running `//` is equivalent to running `/hello`. This shortcut can save you some keystrokes especially if you just searched for a long string. Also recall that you can use `n` and `N` to repeat the last search with the same direction and opposite direction, respectively.

What if you want to quickly recall *n* last search term? You can quickly traverse the search history by first pressing `/`, then press `up`/`down` arrow keys (or `Ctrl-N`/`Ctrl-P`) until you find the search term you need. To see all your search history, you can run `:history /`.

When you reach the end of a file while searching, Vim throws an error: `"Search hit the BOTTOM without match for: {your-search}"`. Sometimes this can be a good safeguard from oversearching, but other times you want to cycle the search back to the top again. You can use the `set wrapscan` option to make Vim to search back at the top of the file when you reach the end of the file. To turn this feature off, do `set nowrapscan`.

## Searching For Alternative Words

It is common to search for multiple words at once. If you need to search for *either* "hello vim" or "hola vim", but not "salve vim" or "bonjour vim", you can use the `|` pattern.

Given this text:

```
hello vim
hola vim
salve vim
bonjour vim
```

To match both "hello" and  "hola", you can do `/hello\|hola`. You have to escape (`\`) the or (`|`) operator, otherwise Vim will literally search for the string "|".

If you don't want to type `\|` every time, you can use the `magic` syntax (`\v`) at the start of the search: `/\vhello|hola`. I will not cover `magic` in this guide, but with `\v`, you don't have to escape special characters anymore. To learn more about `\v`, feel free to check out `:h \v`.

## Setting The Start And End Of A Match

Maybe you need to search for a text that is a part of a compound word. If you have these texts:

```
11vim22
vim22
11vim
vim
```

If you need to select "vim" but only when it starts with "11" and ends with "22", you can use `\zs` (starting match) and `\ze` (ending match) operators. Run:

```
/11\zsvim\ze22
```

Vim still has to match the entire pattern "11vim22", but only highlights the pattern sandwiched between `\zs` and `\ze`. Another example:

```
foobar
foobaz
```

If you need to match the "foo" in "foobaz" but not in "foobar", run:

```
/foo\zebaz
```

## Searching Character Ranges

All your search terms up to this point have been a literal word search. In real life, you may have to use a general pattern to find your text. The most basic pattern is the character range, `[ ]`.

If you need to search for any digit, you probably don't want to type `/0\|1\|2\|3\|4\|5\|6\|7\|8\|9\|0` every single time. Instead, use `/[0-9]` to match for a single digit. The `0-9` expression represents a range of numbers 0-9 that Vim will try to match, so if you are looking for digits between 1 to 5 instead, use `/[1-5]`.

Digits are not the only data types Vim can look up. You can also do `/[a-z]` to search for lowercase alphas and `/[A-Z]` to search for uppercase alphas.

You can combine these ranges together. If you need to search for digits 0-9 and both lowercase and uppercase alphas from "a" to "f" (like a hex), you can do `/[0-9a-fA-F]`.

To do a negative search, you can add `^` inside the character range brackets. To search for a non-digit, run `/[^0-9]`. Vim will match any character as long as it is not a digit. Beware that the caret (`^`) inside the range brackets is different from the beginning-of-a-line caret (ex: `/^hello`). If a caret is outside of a pair of brackets and is the first character in the search term, it means "the first character in a line". If a caret is inside a pair of brackets and it is the first character inside the brackets, it means a negative search operator. `/^abc` matches the first "abc" in a line and `/[^abc]` matches any character except for an "a", "b", or "c".

## Searching For Repeating Characters

If you need to search for double digits in this text:

```
1aa
11a
111
```

You can use `/[0-9][0-9]` to match a two-digit character, but this method is unscalable. What if you need to match twenty digits? Typing `[0-9]` twenty times is not a fun experience. That's why you need a `count` argument.

You can pass `count` to your search. It has the following syntax:

```
{n,m}
```

By the way, these `count` braces need to be escaped when you use them in Vim. The `count` operator is placed after a single character you want to increment.

Here are the four different variations of the `count` syntax:
- `{n}` is an exact match. `/[0-9]\{2\}`  matches the two digit numbers: "11" and the "11" in "111".
- `{n,m}` is a range match. `/[0-9]\{2,3\}` matches between 2 and 3 digit numbers: "11"  and "111".
- `{,m}` is an up-to match. `/[0-9]\{,3\}` matches up to 3 digit numbers: "1", "11", and "111".
- `{n,}` is an at-least match. `/[0-9]\{2,\}` matches at least a 2 or more digit numbers: "11" and "111".

The count arguments `\{0,\}` (zero or more) and `\{1,\}` (one or more) are common search patterns and Vim has special operators for them: `*` and `+` (`+` needs to be escaped while `*` works fine without the escape). If you do `/[0-9]*`, it is the same as `/[0-9]\{0,\}`. It searches for zero or more digits. It will match "", "1", "123". By the way, it will also match non-digits like "a", because there is technically zero digit in the letter "a". Think carefully before using `*`. If you do `/[0-9]\+`, it is the same as `/[0-9]\{1,\}`. It searches for one or more digits. It will match "1" and "12".

## Predefined Character Ranges

Vim has predefined ranges for common characters like digits and alphas. I will not go through every single one here, but you can find the full list inside `:h /character-classes`. Here are the useful ones:

```
\d    Digit [0-9]
\D    Non-digit [^0-9]
\s    Whitespace character (space and tab)
\S    Non-whitespace character (everything except space and tab)
\w    Word character [0-9A-Za-z_]
\l    Lowercase alphas [a-z]
\u    Uppercase character [A-Z]
```

You can use them like you would use character ranges. To search for any single digit, instead of using `/[0-9]`, you can use `/\d` for a more concise syntax.

## Search Example: Capturing A Text Between A Pair Of Similar Characters

If you want to search for a phrase surrounded by a pair of double quotes:

```
"Vim is awesome!"
```

Run this:

```
/"[^"]\+"
```

Let's break it down:
- `"` is a literal double quote. It matches the first double quote.
- `[^"]` means any character except for a double quote. It matches any alphanumeric and whitespace character as long as it is not a double quote.
- `\+` means one or more. Since it is preceded by `[^"]`, Vim looks for one or more character that is not a double quote.
- `"` is a literal double quote. It matches the closing double quote.

When Vim sees the first `"`, it begins the pattern capture. The moment it sees the second double quote in a line, it matches the second `"` pattern and stops the pattern capture. Meanwhile, all non-double-quote characters inbetween are captured by the `[^"]\+` pattern, in this case, the phrase `Vim is awesome!`. This is a common pattern to capture a phrase surrounded by a pair of similar delimiters.

- To capture a phrase surrounded by single quotes, you can use `/'[^']\+'`.
- To capture a phrase surrounded by zeroes, you can use `/0[^0]\+0`.

## Search Example: Capturing A Phone Number

If you want to match a US phone number separated by a hyphen (`-`), like `123-456-7890`, you can use:

```
/\d\{3\}-\d\{3\}-\d\{4\}
```

US Phone number consists of a set of three digit number, followed by another three digits, and finally by four digits. Let's break it down:
- `\d\{3\}` matches a digit repeated exactly three times
- `-` is a literal hyphen

You can avoid typing escapes with `\v`:

```
/\v\d{3}-\d{3}-\d{4}
```

This pattern is also useful to capture any repeating digits, such as IP addresses and zip codes.

That covers the search part of this chapter. Now let's move to substitution.

## Basic Substitution

Vim's substitute command is a useful command to quickly find and replace any pattern. The substitution syntax is:

```
:s/{old-pattern}/{new-pattern}/
```

Let's start with a basic usage. If you have this text:

```
vim is good
```

Let's substitute "good" with "awesome" because Vim is awesome. Run `:s/good/awesome/`. You should see:

```
vim is awesome
```

## Repeating The Last Substitution

You can repeat the last substitute command with either the normal command `&` or by running `:s`. If you have just run `:s/good/awesome/`, running either `&` or `:s` will repeat it.

Also, earlier in this chapter I mentioned that you can use `//` to repeat the previous search pattern.  This trick works with the substitution command. If `/good` was done recently and you leave the first substitute pattern argument blank, like in `:s//awesome/`, it works the same as running `:s/good/awesome/`.

## Substitution Range

Just like many Ex commands, you can pass a range argument into the substitute command. The syntax is:

```
:[range]s/old/new/
```

If you have these expressions:

```
let one = 1;
let two = 2;
let three = 3;
let four = 4;
let five = 5;
```

To substitute the "let" into "const" on lines three to five, you can do:

```
:3,5s/let/const/
```

Here are some range variations you can pass:

- `:,3/let/const/` - if nothing is given before the comma, it represents the current line. Substitute from current line to line 3.
- `:1,s/let/const/` - if nothing is given after the comma, it also represents the current line. Substitute from line 1 to current line.
- `:3s/let/const/` - if only one value is given as range (no comma), it does substitution on that line only.

In Vim, `%` usually means the entire file. If you run `:%s/let/const/`, it will do substitution on all lines. Keep in mind of this range syntax. Many command-line commands that you will learn in the upcoming chapters will follow this form.

## Pattern Matching

The next few sections will cover basic regular expressions. A strong pattern knowledge is essential to master the substitute command.

If you have the following expressions:

```
let one = 1;
let two = 2;
let three = 3;
let four = 4;
let five = 5;
```

To add a pair of double quotes around the digits:

```
:%s/\d/"\0"/
```

The result:

```
let one = "1";
let two = "2";
let three = "3";
let four = "4";
let five = "5";
```

Let's break down the command:
- `:%s` targets the entire file to perform substitution.
- `\d` is Vim's predefined range for digits (similar to using `[0-9]`).
- `"\0"` here the double quotes are literal double quotes. `\0` is a special character representing "the whole matched pattern". The matched pattern here is a single digit number, `\d`.

Alternatively, `&` also represents the whole matched pattern like `\0`. `:s/\d/"&"/` would have also worked.

Let's consider another example. Given these expressions and you need to swap all the "let" with the variable names.

```
one let = "1";
two let = "2";
three let = "3";
four let = "4";
five let = "5";
```

To do that, run:

```
:%s/\(\w\+\) \(\w\+\)/\2 \1/
```

The command above contains too many backslashes and is hard to read. In this case it is more convenient to use the `\v` operator:

```
:%s/\v(\w+) (\w+)/\2 \1/
```

The result:

```
let one = "1";
let two = "2";
let three = "3";
let four = "4";
let five = "5";
```

Great! Let's break down that command:
- `:%s` targets all the lines in the file to perform substitution.
- `(\w+) (\w+)` is a group match. `\w` is one of Vim's predefined ranges for a word character (`[0-9A-Za-z_]`). The `( )` surrounding it captures a word character match in a group. Notice the space between the two groupings. `(\w+) (\w+)` captures two groups. The first group captures "one" and the second group captures "two".
- `\2 \1` returns the captured group in a reversed order. `\2` contains the captured string "let" and `\1` the string "one". Having `\2 \1` returns the string "let one".

Recall that `\0` represents the entire matched pattern. You can break the matched string into smaller groups with `( )`. Each group is represented by `\1`, `\2`, `\3`, etc.

Let's do one more example to solidify this group match concept. If you have these numbers:

```
123
456
789
```

To reverse the order, run:

```
:%s/\v(\d)(\d)(\d)/\3\2\1/
```

The result is:

```
321
654
987
```

Each `(\d)` matches each digit and creates a group. On the first line, the first `(\d)` has a value of 1, the second `(\d)` has a value of 2, and the third `(\d)` has a value of 3. They are stored in the variables `\1`, `\2`, and `\3`. In the second half of your substitution, the new pattern `\3\2\1` results in the "321" value on line one.

If you had run this instead:

```
:%s/\v(\d\d)(\d)/\2\1/
```
You would have gotten a different result:

```
312
645
978
```

This is because you now only have two groups. The first group, captured by `(\d\d)`, is stored within `\1` and has the value of 12. The second group, captured by `(\d)`, is stored inside `\2` and has the value of 3. `\2\1` then, returns 312.

## Substitution Flags

If you have the sentence:

```
chocolate pancake, strawberry pancake, blueberry pancake
```

To substitute all the pancakes into donuts, you cannot just run:

```
:s/pancake/donut
```

The command above will only substitute the first match, giving you:

```
chocolate donut, strawberry pancake, blueberry pancake
```

There are two ways to solve this. You can either run the substitute command twice more or you can pass it a global (`g`) flag to substitute all of the matches in a line.

Let's talk about the global flag. Run:

```
:s/pancake/donut/g
```

Vim substitutes all pancakes with donuts in one swift command. The global command is one of the several flags the substitute command accepts. You pass flags at the end of the substitute command. Here is a list of useful flags:

```
&    Reuse the flags from the previous substitute command.
g    Replace all matches in the line.
c    Ask for substitution confirmation.
e    Prevent error message from displaying when substitution fails.
i    Perform case insensitive substitution.
I    Perform case sensitive substitution.
```

There are more flags that I do not list above. To read about all the flags, check out `:h s_flags`.

By the way, the repeat-substitution commands (`&` and `:s`) do not retain the flags. Running `&` will only repeat `:s/pancake/donut/` without `g`. To quickly repeat the last substitute command with all the flags, run `:&&`.

## Changing The Delimiter

If you need to replace a URL with a long path:

```
https://mysite.com/a/b/c/d/e
```

To substitute it with the word "hello", run:

```
:s/https:\/\/mysite.com\/a\/b\/c\/d\/e/hello/
```

However, it is hard to tell which forward slashes (`/`) are part of the substitution pattern and which ones are the delimiters. You can change the delimiter with any single-byte characters (except for alphabets, numbers, or `"`, `|`, and `\`). Let's replace them with `+`. The substitution command above then can be rewritten as:

```
:s+https:\/\/mysite.com\/a\/b\/c\/d\/e+hello+
```

It is now easier to see where the delimiters are.

## Special Replace

You can also modify the case of the text you are substituting. Given the following expressions and your task is to uppercase the variables "one", "two", "three", etc.

```
let one = "1";
let two = "2";
let three = "3";
let four = "4";
let five = "5";
```

Run:

```
:%s/\v(\w+) (\w+)/\1 \U\2/
```

You will get:

```
let ONE = "1";
let TWO = "2";
let THREE = "3";
let FOUR = "4";
let FIVE = "5";
```

The breakdown:
- `(\w+) (\w+)` captures the first two matched groups, such as "let" and "one".
- `\1` returns the value of the first group, "let".
- `\U\2` uppercases (`\U`) the second group (`\2`).

The trick of this command is the expression `\U\2`. `\U` instructs the following character to be uppercased.

Let's do one more example. Suppose you are writing a Vim guide and you need to capitalize the first letter of each word in a line.

```
vim is the greatest text editor in the whole galaxy
```

You can run:

```
:s/\<./\U&/g
```

The result:

```
Vim Is The Greatest Text Editor In The Whole Galaxy
```

Here is the breakdowns:
- `:s` substitutes the current line.
- `\<.` is comprised of two parts: `\<` to match the start of a word and `.` to match any character. `\<` operator makes the following character to be the first character of a word. Since `.` is the next character, it will match the first character of any word.
- `\U&`  uppercases the subsequent symbol, `&`. Recall that `&` (or `\0`) represents the whole match. It matches the first character of any word.
- `g` the global flag. Without it, this command only substitutes the first match. You need to substitute every match on this line.

To learn more of substitution's special replace symbols like `\U`, check out `:h sub-replace-special`.

## Alternative Patterns

Sometimes you need to match multiple patterns simultaneously. If you have the following greetings:

```
hello vim
hola vim
salve vim
bonjour vim
```

You need to substitute the word "vim" with "friend" but only on the lines containing the word "hello" or "hola". Recall from earlier this chapter, you can use `|` for multiple alternative patterns.

```
:%s/\v(hello|hola) vim/\1 friend/g
```

The result:

```
hello friend
hola friend
salve vim
bonjour vim
```

Here is the breakdown:
- `%s` runs the substitute command on each line in a file.
- `(hello|hola)` matches *either* "hello" or "hola" and consider it as a group.
- `vim` is the literal word "vim".
- `\1` is the first group, which is either the text "hello" or "hola".
- `friend` is the literal word "friend".

## Substituting The Start And The End Of A Pattern

Recall that you can use `\zs` and `\ze` to define the start and the end of a match. This technique works in substitution too. If you have:

```
chocolate pancake
strawberry sweetcake
blueberry hotcake
```

To substitute the "cake" in "hotcake" with "dog" to get a "hotdog":

```
:%s/hot\zscake/dog/g
```

Result:

```
chocolate pancake
strawberry sweetcake
blueberry hotdog
```

## Greedy And Non-Greedy

You can substitute the nth match in a line with this trick:

```
One Mississippi, two Mississippi, three Mississippi, four Mississippi, five Mississippi.
```

To substitute the third "Mississippi" with "Arkansas", run:

```
:s/\v(.{-}\zsMississippi){3}/Arkansas/g
```

The breakdown:
- `:s/` the substitute command.
- `\v` is the magic keyword so you don't have to escape special keywords.
- `.` matches any single character.
- `{-}` performs non-greedy match of 0 or more of the preceding atom.
- `\zsMississippi` makes "Mississippi" the start of the match.
- `(...){3}` looks for the third match.

You have seen the `{3}` syntax earlier in this chapter. In this case, `{3}` will match exactly the third match. The new trick here is `{-}`. It is a non-greedy match. It finds the shortest match of the given pattern. In this case, `(.{-}Mississippi)` matches the least amount of "Mississippi" preceded by any character. Contrast this with `(.*Mississippi)` where it finds the longest match of the given pattern.

If you use `(.{-}Mississippi)`, you get five matches: "One Mississippi", "Two Mississippi", etc. If you use `(.*Mississippi)`, you get one match: the last "Mississippi". `*` is a greedy matcher and `{-}` is a non-greedy matcher. To learn more check out `:h /\{-` and `:h non-greedy`.

Let's do a simpler example. If you have the string:

```
abc1de1
```

You can match "abc1de1" (greedy) with:

```
/a.*1
```

You can match "abc1" (non-greedy) with:

```
/a.\{-}1
```

So if you need to uppercase the longest match (greedy), run:

```
:s/a.*1/\U&/g
```

To get:

```
ABC1DEFG1
```

If you need to uppercase the shortest match (non-greedy), run:

```
:s/a.\{-}1/\U&/g
```

To get:

```
ABC1defg1
```

If you're new to greedy vs non-greedy concept, it can get hard to wrap your head around it. Experiment around with different combinations until you understand it.

## Substituting Across Multiple Files

Finally, let's learn how to substitute phrases across multiple files. For this section, assume that you have two files: `food.txt` and `animal.txt`.

Inside `food.txt`:

```
corndog
hotdog
chilidog
```

Inside `animal.txt`:

```
large dog
medium dog
small dog
```

Assume your directory structure looks like this:

```
- food.txt
- animal.txt
```

First, capture both `food.txt` and `animal.txt` inside `:args`. Recall from earlier chapters that `:args` can be used to create a list of file names. There are several ways to do this from inside Vim, one of them is by running this from inside Vim:

```
:args *.txt                  captures all txt files in current location
```

To test it, when you run `:args`, you should see:

```
[food.txt] animal.txt
```

Now that all the relevant files are stored inside the argument list, you can perform a multi-file substitution with the `:argdo` command. Run:

```
:argdo %s/dog/chicken/
```

This performs substitution against the all files inside the `:args` list. Finally, save the changed files with:

```
:argdo update
```

`:args` and `:argdo` are  useful tools to apply command line commands across multiple files. Try it with other commands!

## Substituting Across Multiple Files With Macros

Alternatively, you can also run the substitute command across multiple files with macros. Run:

```
:args *.txt
qq
:%s/dog/chicken/g
:wnext
q
99@q
```

The breakdown:
- `:args *.txt` adds all text files into the `:args` list.
- `qq` starts the macro in the "q" register.
- `:%s/dog/chicken/g` substitutes "dog" with "chicken" on all lines in the current file.
- `:wnext` saves the file then go to the next file on the `args` list.
- `q` stops the macro recording.
- `99@q` executes the macro ninety-nine times. Vim will stop the macro execution after it encounters the first error, so Vim won't actually execute the macro ninety-nine times.

## Learning Search And Substitution The Smart Way

The ability to do search well is a necessary skill in editing. Mastering the search lets you to utilize the flexibility of regular expressions to search for any pattern in a file. Take your time to learn these. To get better with regular expression you need to be actively using regular expressions. I once read a book about regular expression without actually doing it and I forgot almost everything I read afterwards. Active coding is the best way to master any skill.

A good way to improve your pattern matching skill is whenever you need to search for a pattern (like "hello 123"), instead of querying for the literal search term (`/hello 123`), try to come up with a pattern for it (something like `/\v(\l+) (\d+)`). Many of these regular expression concepts are also applicable in general programming, not only when using Vim.

Now that you learned about advanced search and substitution in Vim, let's learn one of the most versatile commands, the global command.
