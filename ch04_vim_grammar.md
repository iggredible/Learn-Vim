# Ch04. Vim Grammar

It is easy to get intimidated by the complexity of Vim commands. If you see a Vim user doing `gUfV` or `1GdG`, you may not immediately know what these commands do. In this chapter, I will break down the general structure of Vim commands into a simple grammar rule.

This is the most important chapter in the entire guide. Once you understand the underlying grammatical structure, you will be able to "speak" to Vim. By the way, when I say *Vim language* in this chapter, I am not talking about Vimscript language (Vim's built-in programming language, you will learn that in later chapters).

## How to Learn a Language

I am not a native English speaker. I learned English when I was 13 when I moved to the US. There are three things you need to do to learn to speak a new language:

1. Learn grammar rules.
2. Increase vocabulary.
3. Practice, practice, practice.

Likewise, to speak Vim language, you need to learn the grammar rules, increase vocabulary, and practice until you can run the commands without thinking.

## Grammar Rule

There is only one grammar rule in Vim language:

```
verb + noun
```

That's it!

This is like saying these English phrases:

- *"Eat (verb) a donut (noun)"*
- *"Kick (verb) a ball (noun)"*
- *"Learn (verb) the Vim editor (noun)"*

Now you need to build up your vocabulary with basic Vim verbs and nouns.

## Nouns (Motions)

Nouns are Vim motions. Motions are used to move around in Vim. Below is a list of some of Vim motions:

```
h    Left
j    Down
k    Up
l    Right
w    Move forward to the beginning of the next word
}    Jump to the next paragraph
$    Go to the end of the line
```

You will learn more about motions in the next chapter, so don't worry too much if you don't understand some of them.

## Verbs (Operators)

According to `:h operator`, Vim has 16 operators. However, in my experience, learning these 3 operators is enough for 80% of my editing needs:

```
y    Yank text (copy)
d    Delete text and save to register
c    Delete text, save to register, and start insert mode
```

Btw, after you yank a text, you can paste it with `p` (after the cursor) or `P` (before the cursor).

## Verb and Noun

Now that you know basic nouns and verbs, let's apply the grammar rule, verb + noun! Suppose you have this expression:

```javascript
const learn = "vim";
```

- To yank everything from your current location to the end of the line: `y$`.
- To delete from your current location to the beginning of the next word: `dw`.
- To change from your current location to the end of the current paragraph, say `c}`.

Motions also accept count number as arguments (I will discuss this in the next chapter). If you need to go up 3 lines, instead of pressing `k` 3 times, you can do `3k`. Count works with Vim grammar.
- To yank two characters to the left: `y2h`.
- To delete the next two words: `d2w`.
- To change the next two lines: `c2j`.

Right now, you may have to think long and hard to execute even a simple command. You're not alone. When I first started, I had similar struggles but I got faster in time. So will you. Repetition, repetition, repetition.

As a side note, linewise operations (operations affecting the entire line) are common operations in text editing. In general, by typing an operator command twice, Vim performs a linewise operation for that action. For example, `dd`, `yy`, and `cc` perform **deletion**, **yank**, and **change** on the entire line. Try this with other operators!

This is really cool. I am seeing a pattern here. But I am not quite done yet. Vim has one more type of noun: text objects.

## More Nouns (Text Objects)

Imagine you are somewhere inside a pair of parentheses like `(hello Vim)` and you need to delete the entire phrase inside the parentheses. How can you quickly do it? Is there a way to delete the "group" you are inside of?

The answer is yes. Texts often come structured. They often contain parentheses, quotes, brackets, braces, and more. Vim has a way to capture this structure with text objects.

Text objects are used with operators. There are two types of text objects: inner and outer text objects.

```
i + object    Inner text object
a + object    Outer text object
```

Inner text object selects the object inside *without* the white space or the surrounding objects. Outer text object selects the object inside *including* the white space or the surrounding objects. Generally, an outer text object always selects more text than an inner text object. If your cursor is somewhere inside the parentheses in the expression `(hello Vim)`:
- To delete the text inside the parentheses without deleting the parentheses: `di(`.
- To delete the parentheses and the text inside: `da(`.

Let's look at a different example. Suppose you have this Javascript function and your cursor is on the "H" in "Hello":

```javascript
const hello = function() {
  console.log("Hello Vim");
  return true;
}
```

- To delete the entire "Hello Vim": `di(`.
- To delete the content of function (surrounded by `{}`): `di{`.
- To delete the "Hello" string: `diw`.

Text objects are powerful because you can target different objects from one location. You can delete the objects inside the parentheses, the function block, or the current word. Mnemonically, when you see `di(`, `di{`, and `diw`, you get a pretty good idea which text objects they represent: a pair of parentheses, a pair of braces, and a word.

Let's look at one last example. Suppose you have these HTML tags:

```html
<div>
  <h1>Header1</h1>
  <p>Paragraph1</p>
  <p>Paragraph2</p>
</div>
```

If your cursor is on "Header1" text:
- To delete "Header1": `dit`.
- To delete `<h1>Header1</h1>`: `dat`.

If your cursor is on "div":
- To delete `h1` and both `p` lines: `dit`.
- To delete everything: `dat`.
- To delete "div": `di<`.

Below is a list of common text objects:

```
w         A word
p         A paragraph
s         A sentence
( or )    A pair of ( )
{ or }    A pair of { }
[ or ]    A pair of [ ]
< or >    A pair of < >
t         XML tags
"         A pair of " "
'         A Pair of ' '
`         A pair of ` `
```

To learn more, check out `:h text-objects`.

## Composability and Grammar

Vim grammar is subset of Vim's composability feature. Let's discuss composability in Vim and why this is a great feature to have in a text editor.

Composability means having a set of general commands that can be combined (composed) to perform more complex commands. Just like in programming where you can create more complex abstractions from simpler abstractions, in Vim you can execute complex commands from simpler commands. Vim grammar is the manifestation of Vim's composable nature.

The true power of Vim's composability shines when it integrates with external programs. Vim has a filter operator (`!`) to use external programs as filters for our texts. Suppose you have this messy text below and you want to tabularize it:

```
Id|Name|Cuteness
01|Puppy|Very
02|Kitten|Ok
03|Bunny|Ok
```

This cannot be easily done with Vim commands, but you can get it done quickly with `column` terminal command (assuming your terminal has `column` command). With your cursor on "Id", run `!}column -t -s "|"`. Voila! Now you have this pretty tabular data with just one quick command.

```
Id  Name    Cuteness
01  Puppy   Very
02  Kitten  Ok
03  Bunny   Ok
```

Let's break down the command. The verb was `!` (filter operator) and the noun was `}` (go to next paragraph). The filter operator `!` accepted another argument, a terminal command, so I gave it `column -t -s "|"`. I won't go through how `column` worked, but in effect, it tabularized the text.

Suppose you want to not only tabularize your text, but to display only the rows with "Ok". You know that `awk` can do the job easily. You can do this instead:

```
!}column -t -s "|" | awk 'NR > 1 && /Ok/ {print $0}'
```

Result:

```
02  Kitten  Ok
03  Bunny   Ok
```

Great! The external command operator can also use pipe (`|`).

This is the power of Vim's composability. The more you know your operators, motions, and terminal commands, your ability to compose complex actions is *multiplied*.

Suppose you only know four motions, `w, $, }, G` and only one operator, `d`. You can do 8 actions: *move* 4 different ways (`w, $, }, G`) and *delete* 4 different targets (`dw, d$, d}, dG`). Then one day you learn about the uppercase (`gU`) operator. You have added not just one new ability to your Vim tool belt, but *four*: `gUw, gU$, gU}, gUG`. This makes at 12 tools in your Vim tool belt. Each new knowledge is a multiplier to your current abilities. If you know 10 motions and 5 operators, you have 60 moves (50 operations + 10 motions) in your arsenal. Vim has a line-number motion (`nG`) that gives you `n` motions, where `n` is how many lines you have in your file (to go to line 5, run `5G`). The search motion (`/`) practically gives you near unlimited number motions because you can search for anything. External command operator (`!`) gives you as many filtering tools as the number of terminal commands you know. Using a composable tool like Vim, everything you know can be linked together to do operations with increasing complexity. The more you know, the more powerful you become.

This composable behavior echoes Unix philosophy: *do one thing well*. An operator has one job: do Y. A motion has one job: go to X. By combining an operator with a motion, you predictably get YX: do Y on X.

Motions and operators are extendable. You can create custom motions and operators to add to your Vim toolbelt. The [`vim-textobj-user`](https://github.com/kana/vim-textobj-user) plugin allows you to create your own text objects. It also contains a [list](https://github.com/kana/vim-textobj-user/wiki) of user-made custom text objects.

## Learn Vim Grammar the Smart Way

You just learned about Vim grammar's rule: `verb + noun`. One of my biggest Vim "AHA!" moment was when I had just learned about the uppercase (`gU`) operator and wanted to uppercase the current word, I *instinctively* ran `gUiw` and it worked! The word was uppercased. At that moment, I finally began to understand Vim. My hope is that you will have your own "AHA!" moment soon, if not already.

The goal of this chapter is to show you the `verb + noun` pattern in Vim so you will approach learning Vim like learning a new language instead of memorizing every command combination.

Learn the pattern and understand the implications. That's the smart way to learn.

## Link
- Prev [Ch03. Searching Files](./ch03_searching_files.md)
- Next [Ch05. Moving in a File](./ch05_moving_in_file.md)
