# Ch28. Vimscript 함수

함수는 새로운 언어를 배우는 세 번째 요소인 추상화 수단입니다.

이전 챕터에서는 Vimscript 네이티브 함수(`len()`, `filter()`, `map()` 등)와 사용자 정의 함수가 실제로 어떻게 작동하는지 보았습니다. 이번 챕터에서는 함수가 어떻게 작동하는지 더 깊이 배우게 됩니다.

## 함수 구문 규칙

핵심적으로 Vimscript 함수는 다음과 같은 구문을 가집니다:

```
function {FunctionName}()
  {do-something}
endfunction
```

함수 정의는 대문자로 시작해야 합니다. `function` 키워드로 시작하여 `endfunction`으로 끝납니다. 아래는 유효한 함수입니다:

```
function! Tasty()
  echo "Tasty"
endfunction
```

다음은 대문자로 시작하지 않기 때문에 유효하지 않은 함수입니다.

```
function tasty()
  echo "Tasty"
endfunction
```

함수 앞에 스크립트 변수(`s:`)를 붙이면 소문자로 사용할 수 있습니다. `function s:tasty()`는 유효한 이름입니다. Vim이 대문자 이름을 사용하도록 요구하는 이유는 Vim의 내장 함수(모두 소문자)와 혼동되는 것을 방지하기 위함입니다.

함수 이름은 숫자로 시작할 수 없습니다. `1Tasty()`는 유효한 함수 이름이 아니지만 `Tasty1()`은 유효합니다. 함수는 `_` 이외의 영숫자가 아닌 문자를 포함할 수 없습니다. `Tasty-food()`, `Tasty&food()`, `Tasty.food()`는 유효한 함수 이름이 아닙니다. `Tasty_food()`는 *유효합니다*.

같은 이름으로 두 개의 함수를 정의하면 Vim은 `Tasty` 함수가 이미 존재한다는 오류를 발생시킵니다. 같은 이름의 이전 함수를 덮어쓰려면 `function` 키워드 뒤에 `!`를 추가하세요.

```
function! Tasty()
  echo "Tasty"
endfunction
```

## 사용 가능한 함수 목록 보기

Vim의 모든 내장 및 사용자 정의 함수를 보려면 `:function` 명령어를 실행할 수 있습니다. `Tasty` 함수의 내용을 보려면 `:function Tasty`를 실행할 수 있습니다.

Vim의 검색 탐색(`/pattern`)과 유사하게 `:function /pattern`으로 패턴이 있는 함수를 검색할 수도 있습니다. "map"이라는 구문을 포함하는 모든 함수를 검색하려면 `:function /map`을 실행하세요. 외부 플러그인을 사용하는 경우 Vim은 해당 플러그인에 정의된 함수를 표시합니다.

함수가 어디서 유래했는지 보려면 `:verbose` 명령어를 `:function` 명령어와 함께 사용할 수 있습니다. "map"이라는 단어를 포함하는 모든 함수가 어디서 유래했는지 보려면 다음을 실행하세요:

```
:verbose function /map
```

실행했을 때 여러 결과를 얻었습니다. 이것은 `fzf#vim#maps` autoload 함수(복습하자면, 23장 참조)가 `~/.vim/plugged/fzf.vim/autoload/fzf/vim.vim` 파일의 1263번째 줄에 작성되었음을 알려줍니다. 이것은 디버깅에 유용합니다.

```
function fzf#vim#maps(mode, ...)
        Last set from ~/.vim/plugged/fzf.vim/autoload/fzf/vim.vim line 1263
```

## 함수 제거하기

기존 함수를 제거하려면 `:delfunction {Function_name}`을 사용하세요. `Tasty`를 삭제하려면 `:delfunction Tasty`를 실행하세요.

## 함수 반환 값

함수가 값을 반환하려면 명시적인 `return` 값을 전달해야 합니다. 그렇지 않으면 Vim은 자동으로 0이라는 암시적 값을 반환합니다.

```
function! Tasty()
  echo "Tasty"
endfunction
```

빈 `return`도 0 값과 같습니다.

```
function! Tasty()
  echo "Tasty"
  return
endfunction
```

위 함수를 사용하여 `:echo Tasty()`를 실행하면 Vim이 "Tasty"를 표시한 후 암시적 반환 값인 0을 반환합니다. `Tasty()`가 "Tasty" 값을 반환하게 하려면 다음과 같이 할 수 있습니다:

```
function! Tasty()
  return "Tasty"
endfunction
```

이제 `:echo Tasty()`를 실행하면 "Tasty" 문자열을 반환합니다.

표현식 내에서 함수를 사용할 수 있습니다. Vim은 해당 함수의 반환 값을 사용합니다. `:echo Tasty() . " Food!"` 표현식은 "Tasty Food!"를 출력합니다.

## 형식 인수

`Tasty` 함수에 형식 인수 `food`를 전달하려면 다음과 같이 할 수 있습니다:

```
function! Tasty(food)
  return "Tasty " . a:food
endfunction

echo Tasty("pastry")
" "Tasty pastry"를 반환합니다
```

`a:`는 지난 챕터에서 언급된 변수 범위 중 하나입니다. 이것은 형식 매개변수 변수입니다. 함수에서 형식 매개변수 값을 얻는 Vim의 방법입니다. 이것이 없으면 Vim은 오류를 발생시킵니다:

```
function! Tasty(food)
  return "Tasty " . food
endfunction

echo Tasty("pasta")
" "undefined variable name" 오류를 반환합니다
```

## 함수 지역 변수

이전 챕터에서 배우지 않은 다른 변수인 함수 지역 변수(`l:`)에 대해 알아보겠습니다.

함수를 작성할 때 내부에 변수를 정의할 수 있습니다:

```
function! Yummy()
  let location = "tummy"
  return "Yummy in my " . location
endfunction

echo Yummy()
" "Yummy in my tummy"를 반환합니다
```

이 컨텍스트에서 `location` 변수는 `l:location`과 동일합니다. 함수에서 변수를 정의하면 해당 변수는 해당 함수에 *지역적*입니다. 사용자가 `location`을 보면 전역 변수로 쉽게 착각할 수 있습니다. 저는 장황한 것을 선호하므로, 이것이 함수 변수임을 나타내기 위해 `l:`을 붙이는 것을 선호합니다.

`l:count`를 사용하는 또 다른 이유는 Vim에 일반 변수처럼 보이는 별칭을 가진 특수 변수가 있기 때문입니다. `v:count`가 한 예입니다. `count`라는 별칭을 가지고 있습니다. Vim에서 `count`를 호출하는 것은 `v:count`를 호출하는 것과 같습니다. 이러한 특수 변수 중 하나를 실수로 호출하기 쉽습니다.

```
function! Calories()
  let count = "count"
  return "I do not " . count . " my calories"
endfunction

echo Calories()
" 오류를 발생시킵니다
```

위의 실행은 `let count = "Count"`가 암시적으로 Vim의 특수 변수 `v:count`를 재정의하려고 시도하기 때문에 오류를 발생시킵니다. 특수 변수(`v:`)는 읽기 전용이라는 것을 기억하세요. 변경할 수 없습니다. 이 문제를 해결하려면 `l:count`를 사용하세요:

```
function! Calories()
  let l:count = "count"
  return "I do not " . l:count . " my calories"
endfunction

echo Calories()
" "I do not count my calories"를 반환합니다
```

## 함수 호출하기

Vim에는 함수를 호출하는 `:call` 명령어가 있습니다.

```
function! Tasty(food)
  return "Tasty " . a:food
endfunction

call Tasty("gravy")
```

`call` 명령어는 반환 값을 출력하지 않습니다. `echo`로 호출해 봅시다.

```
echo call Tasty("gravy")
```

이런, 오류가 발생합니다. 위의 `call` 명령어는 커맨드 라인 명령어(`:call`)입니다. 위의 `echo` 명령어 또한 커맨드 라인 명령어(`:echo`)입니다. 다른 커맨드 라イン 명령어로 커맨드 라인 명령어를 호출할 수 없습니다. 다른 종류의 `call` 명령어를 시도해 봅시다:

```
echo call("Tasty", ["gravy"])
" "Tasty gravy"를 반환합니다
```

혼동을 없애기 위해, 방금 두 가지 다른 `call` 명령어를 사용했습니다: `:call` 커맨드 라인 명령어와 `call()` 함수입니다. `call()` 함수는 첫 번째 인수로 함수 이름(문자열)을 받고 두 번째 인수로 형식 매개변수(리스트)를 받습니다.

`:call`과 `call()`에 대해 더 배우려면 `:h call()`과 `:h :call`을 확인하세요.

## 기본 인수

`=`를 사용하여 함수 매개변수에 기본값을 제공할 수 있습니다. `Breakfast`를 하나의 인수로만 호출하면 `beverage` 인수는 "milk" 기본값을 사용합니다.

```
function! Breakfast(meal, beverage = "Milk")
  return "I had " . a:meal . " and " . a:beverage . " for breakfast"
endfunction

echo Breakfast("Hash Browns")
" I had hash browns and milk for breakfast를 반환합니다

echo Breakfast("Cereal", "Orange Juice")
" I had Cereal and Orange Juice for breakfast를 반환합니다
```

## 가변 인수

세 개의 점(`...`)으로 가변 인수를 전달할 수 있습니다. 가변 인수는 사용자가 몇 개의 변수를 줄지 모를 때 유용합니다.

무한 리필 뷔페를 만들고 있다고 가정해 봅시다(고객이 얼마나 많은 음식을 먹을지 절대 모릅니다):

```
function! Buffet(...)
  return a:1
endfunction
```

`echo Buffet("Noodles")`를 실행하면 "Noodles"를 출력합니다. Vim은 `a:1`을 사용하여 `...`에 전달된 *첫 번째* 인수를 출력하며, 최대 20개까지 가능합니다(`a:1`은 첫 번째 인수, `a:2`는 두 번째 인수 등). `echo Buffet("Noodles", "Sushi")`를 실행하면 여전히 "Noodles"만 표시됩니다. 업데이트해 봅시다:

```
function! Buffet(...)
  return a:1 . " " . a:2
endfunction

echo Buffet("Noodles", "Sushi")
" "Noodles Sushi"를 반환합니다
```

이 방법의 문제점은 이제 `echo Buffet("Noodles")`(변수 하나만으로)를 실행하면 Vim이 정의되지 않은 변수 `a:2`가 있다고 불평한다는 것입니다. 사용자가 제공한 것을 정확하게 표시할 만큼 유연하게 만들려면 어떻게 해야 할까요?

다행히도 Vim에는 `...`에 전달된 인수 *수*를 표시하는 특수 변수 `a:0`이 있습니다.

```
function! Buffet(...)
  return a:0
endfunction

echo Buffet("Noodles")
" 1을 반환합니다

echo Buffet("Noodles", "Sushi")
" 2를 반환합니다

echo Buffet("Noodles", "Sushi", "Ice cream", "Tofu", "Mochi")
" 5를 반환합니다
```

이것으로 인수 길이를 사용하여 반복할 수 있습니다.

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

중괄호 `a:{l:food_counter}`는 문자열 보간이며, `food_counter` 카운터 값을 사용하여 형식 매개변수 인수 `a:1`, `a:2`, `a:3` 등을 호출합니다.

```
echo Buffet("Noodles")
" "Noodles"를 반환합니다

echo Buffet("Noodles", "Sushi", "Ice cream", "Tofu", "Mochi")
" 전달한 모든 것을 반환합니다: "Noodles Sushi Ice cream Tofu Mochi"
```

가변 인수에는 또 다른 특수 변수인 `a:000`이 있습니다. 모든 가변 인수의 값을 리스트 형식으로 가지고 있습니다.

```
function! Buffet(...)
  return a:000
endfunction

echo Buffet("Noodles")
" ["Noodles"]를 반환합니다

echo Buffet("Noodles", "Sushi", "Ice cream", "Tofu", "Mochi")
" ["Noodles", "Sushi", "Ice cream", "Tofu", "Mochi"]를 반환합니다
```

`for` 루프를 사용하도록 함수를 리팩토링해 봅시다:

```
function! Buffet(...)
  let l:foods = ""
  for food_item in a:000
    let l:foods .= food_item . " "
  endfor
  return l:foods
endfunction

echo Buffet("Noodles", "Sushi", "Ice cream", "Tofu", "Mochi")
" Noodles Sushi Ice cream Tofu Mochi를 반환합니다
```

## 범위 (Range)

함수 정의 끝에 `range` 키워드를 추가하여 *범위가 지정된* Vimscript 함수를 정의할 수 있습니다. 범위가 지정된 함수에는 `a:firstline`과 `a:lastline`이라는 두 개의 특수 변수를 사용할 수 있습니다.

```
function! Breakfast() range
  echo a:firstline
  echo a:lastline
endfunction
```

100번 줄에 있고 `call Breakfast()`를 실행하면 `firstline`과 `lastline` 모두에 대해 100을 표시합니다. 101번 줄부터 105번 줄까지 시각적으로 강조 표시하고(`v`, `V` 또는 `Ctrl-V`) `call Breakfast()`를 실행하면 `firstline`은 101을 표시하고 `lastline`은 105를 표시합니다. `firstline`과 `lastline`은 함수가 호출된 최소 및 최대 범위를 표시합니다.

`:call`을 사용하고 범위를 전달할 수도 있습니다. `:11,20call Breakfast()`를 실행하면 `firstline`에 11, `lastline`에 20이 표시됩니다.

"Vimscript 함수가 범위를 허용하는 것은 좋지만, `line(".")`으로 줄 번호를 얻을 수 없나요? 같은 일을 하지 않을까요?"라고 물을 수 있습니다.

좋은 질문입니다. 이것이 의미하는 바라면:

```
function! Breakfast()
  echo line(".")
endfunction
```

`:11,20call Breakfast()`를 호출하면 `Breakfast` 함수가 10번 실행됩니다(범위의 각 줄에 대해 한 번). `range` 인수를 전달했다면 비교해 보세요:

```
function! Breakfast() range
  echo line(".")
endfunction
```

`11,20call Breakfast()`를 호출하면 `Breakfast` 함수가 *한 번* 실행됩니다.

`range` 키워드를 전달하고 `call`에 숫자 범위(예: `11,20`)를 전달하면 Vim은 해당 함수를 한 번만 실행합니다. `range` 키워드를 전달하지 않고 `call`에 숫자 범위(예: `11,20`)를 전달하면 Vim은 범위에 따라 해당 함수를 N번 실행합니다(이 경우 N = 10).

## 딕셔너리 (Dictionary)

함수를 정의할 때 `dict` 키워드를 추가하여 함수를 딕셔너리 항목으로 추가할 수 있습니다.

가지고 있는 `breakfast` 항목이 무엇이든 반환하는 `SecondBreakfast` 함수가 있는 경우:

```
function! SecondBreakfast() dict
  return self.breakfast
endfunction
```

이 함수를 `meals` 딕셔너리에 추가해 봅시다:

```
let meals = {"breakfast": "pancakes", "second_breakfast": function("SecondBreakfast"), "lunch": "pasta"}

echo meals.second_breakfast()
" "pancakes"를 반환합니다
```

`dict` 키워드를 사용하면 키 변수 `self`는 함수가 저장된 딕셔너리(이 경우 `meals` 딕셔너리)를 참조합니다. `self.breakfast` 표현식은 `meals.breakfast`와 같습니다.

함수를 딕셔너리 객체에 추가하는 다른 방법은 네임스페이스를 사용하는 것입니다.

```
function! meals.second_lunch()
  return self.lunch
endfunction

echo meals.second_lunch()
" "pasta"를 반환합니다
```

네임스페이스를 사용하면 `dict` 키워드를 사용할 필요가 없습니다.

## 함수 참조 (Funcref)

funcref는 함수에 대한 참조입니다. 24장에서 언급된 Vimscript의 기본 데이터 타입 중 하나입니다.

위의 `function("SecondBreakfast")` 표현식은 funcref의 예입니다. Vim에는 함수 이름(문자열)을 전달하면 funcref를 반환하는 내장 함수 `function()`이 있습니다.

```
function! Breakfast(item)
  return "I am having " . a:item . " for breakfast"
endfunction

let Breakfastify = Breakfast
" 오류를 반환합니다

let Breakfastify = function("Breakfast")

echo Breakfastify("oatmeal")
" "I am having oatmeal for breakfast"를 반환합니다

echo Breakfastify("pancake")
" "I am having pancake for breakfast"를 반환합니다
```

Vim에서 함수를 변수에 할당하려면 `let MyVar = MyFunc`처럼 직접 할당할 수 없습니다. `let MyVar = function("MyFunc")`처럼 `function()` 함수를 사용해야 합니다.

맵과 필터와 함께 funcref를 사용할 수 있습니다. 맵과 필터는 첫 번째 인수로 인덱스를, 두 번째 인수로 반복된 값을 전달한다는 점에 유의하세요.

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

## 람다 (Lambda)

맵과 필터에서 함수를 사용하는 더 좋은 방법은 람다 표현식(이름 없는 함수라고도 함)을 사용하는 것입니다. 예를 들어:

```
let Plus = {x,y -> x + y}
echo Plus(1,2)
" 3을 반환합니다

let Tasty = { -> 'tasty'}
echo Tasty()
" "tasty"를 반환합니다
```

람다 표현식 내부에서 함수를 호출할 수 있습니다:

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

람다 내부에서 함수를 호출하고 싶지 않다면 다음과 같이 리팩토링할 수 있습니다:

```
let day_meals = map(lunch_items, {index, item -> "I am having " . item . " for lunch"})
```

## 메서드 체이닝

`->`를 사용하여 여러 Vimscript 함수와 람다 표현식을 순차적으로 연결할 수 있습니다. `->` 뒤에는 *공백 없이* 메서드 이름이 와야 한다는 점을 명심하세요.

```
Source->Method1()->Method2()->...->MethodN()
```

메서드 체이닝을 사용하여 부동소수점을 숫자로 변환하려면:

```
echo 3.14->float2nr()
" 3을 반환합니다
```

더 복잡한 예를 들어보겠습니다. 리스트의 각 항목의 첫 글자를 대문자로 만들고, 리스트를 정렬한 다음, 리스트를 결합하여 문자열을 만들어야 한다고 가정해 봅시다.

```
function! Capitalizer(word)
  return substitute(a:word, "\^\.", "\\u&", "g")
endfunction

function! CapitalizeList(word_list)
  return map(a:word_list, {index, word -> Capitalizer(word)})
endfunction

let dinner_items = ["bruschetta", "antipasto", "calzone"]

echo dinner_items->CapitalizeList()->sort()->join(", ")
" "Antipasto, Bruschetta, Calzone"을 반환합니다
```

메서드 체이닝을 사용하면 순서를 더 쉽게 읽고 이해할 수 있습니다. `dinner_items->CapitalizeList()->sort()->join(", ")`을 훑어보기만 해도 무슨 일이 일어나고 있는지 정확히 알 수 있습니다.

## 클로저 (Closure)

함수 내부에 변수를 정의하면 해당 변수는 해당 함수 경계 내에 존재합니다. 이것을 어휘적 범위(lexical scope)라고 합니다.

```
function! Lunch()
  let appetizer = "shrimp"

  function! SecondLunch()
    return appetizer
  endfunction

  return funcref("SecondLunch")
endfunction
```

`appetizer`는 `Lunch` 함수 내부에 정의되어 있으며, 이 함수는 `SecondLunch` funcref를 반환합니다. `SecondLunch`가 `appetizer`를 사용하지만 Vimscript에서는 해당 변수에 접근할 수 없다는 점에 유의하세요. `echo Lunch()()`를 실행하려고 하면 Vim은 정의되지 않은 변수 오류를 발생시킵니다.

이 문제를 해결하려면 `closure` 키워드를 사용하세요. 리팩토링해 봅시다:

```
function! Lunch()
  let appetizer = "shrimp"

  function! SecondLunch() closure
    return appetizer
  endfunction

  return funcref("SecondLunch")
endfunction
```

이제 `echo Lunch()()`를 실행하면 Vim은 "shrimp"를 반환합니다.

## 똑똑하게 Vimscript 함수 배우기

이번 챕터에서는 Vim 함수의 구조에 대해 배웠습니다. `range`, `dict`, `closure`와 같은 다양한 특수 키워드를 사용하여 함수 동작을 수정하는 방법을 배웠습니다. 또한 람다를 사용하고 여러 함수를 함께 연결하는 방법도 배웠습니다. 함수는 복잡한 추상화를 만드는 데 중요한 도구입니다.

다음으로, 배운 모든 것을 종합하여 자신만의 플러그인을 만들어 봅시다.