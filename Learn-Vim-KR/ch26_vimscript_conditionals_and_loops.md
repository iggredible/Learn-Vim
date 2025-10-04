# Ch26. Vimscript 조건문과 반복문

기본 데이터 타입이 무엇인지 배운 후, 다음 단계는 그것들을 조합하여 기본 프로그램을 작성하는 방법을 배우는 것입니다. 기본 프로그램은 조건문과 반복문으로 구성됩니다.

이번 챕터에서는 Vimscript 데이터 타입을 사용하여 조건문과 반복문을 작성하는 방법을 배우게 됩니다.

## 관계 연산자

Vimscript 관계 연산자는 많은 프로그래밍 언어와 유사합니다:

```
a == b		같다
a != b		같지 않다
a >  b		크다
a >= b		크거나 같다
a <  b		작다
a <= b		작거나 같다
```

예를 들어:

```
:echo 5 == 5
:echo 5 != 5
:echo 10 > 5
:echo 10 >= 5
:echo 10 < 5
:echo 5 <= 5
```

산술 표현식에서 문자열이 숫자로 강제 변환된다는 것을 기억하세요. 여기서 Vim은 등식 표현식에서도 문자열을 숫자로 강제 변환합니다. "5foo"는 5로 강제 변환됩니다(참).

```
:echo 5 == "5foo"
" 참을 반환합니다
```

또한 "foo5"와 같이 숫자가 아닌 문자로 문자열을 시작하면 문자열이 숫자 0으로 변환된다는 것을 기억하세요(거짓).

```
echo 5 == "foo5"
" 거짓을 반환합니다
```

### 문자열 논리 연산자

Vim에는 문자열 비교를 위한 더 많은 관계 연산자가 있습니다:

```
a =~ b
a !~ b
```

예를 들어:

```
let str = "hearty breakfast"

echo str =~ "hearty"
" 참을 반환합니다

echo str =~ "dinner"
" 거짓을 반환합니다

echo str !~ "dinner"
" 참을 반환합니다
```

`=~` 연산자는 주어진 문자열에 대해 정규식 일치를 수행합니다. 위 예에서 `str =~ "hearty"`는 `str`이 "hearty" 패턴을 *포함*하기 때문에 참을 반환합니다. 항상 `==`와 `!=`를 사용할 수 있지만, 이것들을 사용하면 표현식을 전체 문자열과 비교합니다. `=~`와 `!~`는 더 유연한 선택입니다.

```
echo str == "hearty"
" 거짓을 반환합니다

echo str == "hearty breakfast"
" 참을 반환합니다
```

이것을 시도해 봅시다. 대문자 "H"에 주목하세요:

```
echo str =~ "Hearty"
" 참
```

"Hearty"가 대문자임에도 불구하고 참을 반환합니다. 흥미롭군요... 제 Vim 설정이 대소문자를 무시하도록 설정되어 있기 때문입니다(`set ignorecase`). 그래서 Vim이 동등성을 확인할 때, 제 Vim 설정을 사용하고 대소문자를 무시합니다. 만약 제가 대소문자 무시를 끈다면(`set noignorecase`), 비교는 이제 거짓을 반환합니다.

```
set noignorecase
echo str =~ "Hearty"
" 대소문자가 중요하기 때문에 거짓을 반환합니다

set ignorecase
echo str =~ "Hearty"
" 대소문자가 중요하지 않기 때문에 참을 반환합니다
```

다른 사람들을 위해 플러그인을 작성하는 경우, 이것은 까다로운 상황입니다. 사용자가 `ignorecase`를 사용하나요, 아니면 `noignorecase`를 사용하나요? 사용자에게 대소문자 무시 옵션을 변경하도록 강요하고 싶지는 않을 것입니다. 그럼 어떻게 해야 할까요?

다행히도 Vim에는 *항상* 대소문자를 무시하거나 일치시킬 수 있는 연산자가 있습니다. 항상 대소문자를 일치시키려면 끝에 `#`을 추가하세요.

```
set ignorecase
echo str =~# "hearty"
" 참을 반환합니다

echo str =~# "HearTY"
" 거짓을 반환합니다

set noignorecase
echo str =~# "hearty"
" 참

echo str =~# "HearTY"
" 거짓

echo str !~# "HearTY"
" 참
```

비교할 때 항상 대소문자를 무시하려면 `?`를 붙입니다:

```
set ignorecase
echo str =~? "hearty"
" 참

echo str =~? "HearTY"
" 참

set noignorecase
echo str =~? "hearty"
" 참

echo str =~? "HearTY"
" 참

echo str !~? "HearTY"
" 거짓
```

저는 안전하게 항상 대소문자를 일치시키기 위해 `#`를 사용하는 것을 선호합니다.

## If

이제 Vim의 등식 표현식을 보았으니, 기본적인 조건 연산자인 `if` 문을 다루어 봅시다.

최소한의 구문은 다음과 같습니다:

```
if {절}
  {어떤 표현식}
endif
```

`elseif`와 `else`로 사례 분석을 확장할 수 있습니다.

```
if {조건1}
  {표현식1}
elseif {조건2}
  {표현식2}
elseif {조건3}
  {표현식3}
else
  {표현식4}
endif
```

예를 들어, [vim-signify](https://github.com/mhinz/vim-signify) 플러그인은 Vim 설정에 따라 다른 설치 방법을 사용합니다. 아래는 `if` 문을 사용한 `readme`의 설치 지침입니다:

```
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif
```

## 삼항 표현식

Vim에는 한 줄짜리 사례 분석을 위한 삼항 표현식이 있습니다:

```
{조건} ? 참일때_표현식 : 거짓일때_표현식
```

예를 들어:

```
echo 1 ? "나는 참이다" : "나는 거짓이다"
```

1은 참이므로 Vim은 "나는 참이다"를 출력합니다. 특정 시간 이후에 Vim을 사용할 때 `background`를 조건부로 어둡게 설정하고 싶다고 가정해 봅시다. vimrc에 다음을 추가하세요:

```
let &background = strftime("%H") < 18 ? "light" : "dark"
```

`&background`는 Vim의 `'background'` 옵션입니다. `strftime("%H")`는 현재 시간을 시간 단위로 반환합니다. 아직 오후 6시가 아니면 밝은 배경을 사용합니다. 그렇지 않으면 어두운 배경을 사용합니다.

## or

논리 "or" (`||`)는 많은 프로그래밍 언어처럼 작동합니다.

```
{거짓 표현식}  || {거짓 표현식}   거짓
{거짓 표현식}  || {참 표현식}  참
{참 표현식} || {거짓 표현식}   참
{참 표현식} || {참 표현식}  참
```

Vim은 표현식을 평가하고 1(참) 또는 0(거짓)을 반환합니다.

```
echo 5 || 0
" 1을 반환합니다

echo 5 || 5
" 1을 반환합니다

echo 0 || 0
" 0을 반환합니다

echo "foo5" || "foo5"
" 0을 반환합니다

echo "5foo" || "foo5"
" 1을 반환합니다
```

현재 표현식이 참으로 평가되면 후속 표현식은 평가되지 않습니다.

```
let one_dozen = 12

echo one_dozen || two_dozen
" 1을 반환합니다

echo two_dozen || one_dozen
" 오류를 반환합니다
```

`two_dozen`은 정의된 적이 없습니다. `one_dozen || two_dozen` 표현식은 `one_dozen`이 먼저 평가되어 참으로 발견되므로 오류를 발생시키지 않습니다. 그래서 Vim은 `two_dozen`을 평가하지 않습니다.

## and

논리 "and" (`&&`)는 논리 or의 보수입니다.

```
{거짓 표현식}  && {거짓 표현식}   거짓
{거짓 표현식}  && {참 표현식}  거짓
{참 표현식} && {거짓 표현식}   거짓
{참 표현식} && {참 표현식}  참
```

예를 들어:

```
echo 0 && 0
" 0을 반환합니다

echo 0 && 10
" 0을 반환합니다
```

`&&`는 첫 번째 거짓 표현식을 볼 때까지 표현식을 평가합니다. 예를 들어, `true && true`가 있으면 둘 다 평가하고 `true`를 반환합니다. `true && false && true`가 있으면 첫 번째 `true`를 평가하고 첫 번째 `false`에서 멈춥니다. 세 번째 `true`는 평가하지 않습니다.

```
let one_dozen = 12
echo one_dozen && 10
" 1을 반환합니다

echo one_dozen && v:false
" 0을 반환합니다

echo one_dozen && two_dozen
" 오류를 반환합니다

echo exists("one_dozen") && one_dozen == 12
" 1을 반환합니다
```

## for

`for` 루프는 일반적으로 리스트 데이터 타입과 함께 사용됩니다.

```
let breakfasts = ["pancakes", "waffles", "eggs"]

for breakfast in breakfasts
  echo breakfast
endfor
```

중첩 리스트에서도 작동합니다:

```
let meals = [["breakfast", "pancakes"], ["lunch", "fish"], ["dinner", "pasta"]]

for [meal_type, food] in meals
  echo "I am having " . food . " for " . meal_type
endfor
```

`keys()` 메서드를 사용하여 `for` 루프를 딕셔너리와 함께 기술적으로 사용할 수 있습니다.

```
let beverages = #{breakfast: "milk", lunch: "orange juice", dinner: "water"}
for beverage_type in keys(beverages)
  echo "I am drinking " . beverages[beverage_type] . " for " . beverage_type
endfor
```

## While

또 다른 일반적인 루프는 `while` 루프입니다.

```
let counter = 1
while counter < 5
  echo "Counter is: " . counter
  let counter += 1
endwhile
```

현재 줄의 내용부터 마지막 줄까지 가져오려면:

```
let current_line = line(".")
let last_line = line("$")

while current_line <= last_line
  echo getline(current_line)
  let current_line += 1
endwhile
```

## 오류 처리

종종 프로그램이 예상대로 실행되지 않을 수 있습니다. 결과적으로 루프에 빠지게 됩니다(말장난입니다). 필요한 것은 적절한 오류 처리입니다.

### Break

`while` 또는 `for` 루프 내에서 `break`를 사용하면 루프가 중지됩니다.

파일 시작부터 현재 줄까지 텍스트를 가져오되 "donut"이라는 단어를 보면 멈추려면:

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

다음과 같은 텍스트가 있는 경우:

```
one
two
three
donut
four
five
```

위의 `while` 루프를 실행하면 "one two three"를 반환하고 나머지 텍스트는 반환하지 않습니다. 루프가 "donut"과 일치하면 중단되기 때문입니다.

### Continue

`continue` 메서드는 `break`와 유사하며, 루프 중에 호출됩니다. 차이점은 루프를 벗어나는 대신 현재 반복을 건너뛴다는 것입니다.

동일한 텍스트가 있지만 `break` 대신 `continue`를 사용한다고 가정해 봅시다:

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

이번에는 `one two three four five`를 반환합니다. "donut"이라는 단어가 있는 줄은 건너뛰지만 루프는 계속됩니다.

### try, finally, and catch

Vim에는 오류를 처리하기 위한 `try`, `finally`, `catch`가 있습니다. 오류를 시뮬레이션하려면 `throw` 명령어를 사용할 수 있습니다.

```
try
  echo "Try"
  throw "Nope"
endtry
```

이것을 실행하세요. Vim은 `"Exception not caught: Nope"` 오류로 불평할 것입니다.

이제 catch 블록을 추가하세요:

```
try
  echo "Try"
  throw "Nope"
catch
  echo "Caught it"
endtry
```

이제 더 이상 오류가 없습니다. "Try"와 "Caught it"이 표시되어야 합니다.

`catch`를 제거하고 `finally`를 추가해 봅시다:

```
try
  echo "Try"
  throw "Nope"
  echo "You won't see me"
finally
  echo "Finally"
endtry
```

이것을 실행하세요. 이제 Vim은 오류와 "Finally"를 표시합니다.

모두 함께 넣어 봅시다:

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

이번에는 Vim이 "Caught it"과 "Finally"를 모두 표시합니다. Vim이 잡았기 때문에 오류가 표시되지 않습니다.

오류는 다른 곳에서 발생합니다. 또 다른 오류의 원인은 아래 `Nope()`과 같이 존재하지 않는 함수를 호출하는 것입니다:

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

`catch`와 `finally`의 차이점은 `finally`는 오류 여부에 관계없이 항상 실행되는 반면, catch는 코드가 오류를 얻을 때만 실행된다는 것입니다.

`:catch`로 특정 오류를 잡을 수 있습니다. `:h :catch`에 따르면:

```
catch /^Vim:Interrupt$/.             " 인터럽트 잡기 (CTRL-C)
catch /^Vim\\%((\\a\\+)\\)\\=:E/.    " 모든 Vim 오류 잡기
catch /^Vim\\%((\\a\\+)\\)\\=:/.     " 오류 및 인터럽트 잡기
catch /^Vim(write):/.                " :write의 모든 오류 잡기
catch /^Vim\\%((\\a\\+)\\)\\=:E123:/ " 오류 E123 잡기
catch /my-exception/.                " 사용자 예외 잡기
catch /.*/                           " 모든 것 잡기
catch.                               " /.*/와 동일
```

`try` 블록 내에서 인터럽트는 잡을 수 있는 오류로 간주됩니다.

```
try
  catch /^Vim:Interrupt$/
  sleep 100
endtry
```

vimrc에서 [gruvbox](https://github.com/morhetz/gruvbox)와 같은 사용자 정의 색상 구성표를 사용하고 실수로 색상 구성표 디렉토리를 삭제했지만 vimrc에 `colorscheme gruvbox` 줄이 여전히 있는 경우, `source`할 때 Vim은 오류를 발생시킵니다. 이 문제를 해결하기 위해 vimrc에 다음을 추가했습니다:

```
try
  colorscheme gruvbox
catch
  colorscheme default
endtry
```

이제 `gruvbox` 디렉토리 없이 vimrc를 `source`하면 Vim은 `colorscheme default`를 사용합니다.

## 똑똑하게 조건문 배우기

이전 챕터에서는 Vim 기본 데이터 타입에 대해 배웠습니다. 이번 챕터에서는 조건문과 반복문을 사용하여 기본 프로그램을 작성하기 위해 그것들을 조합하는 방법을 배웠습니다. 이것들은 프로그래밍의 구성 요소입니다.

다음으로, 변수 범위에 대해 배워 봅시다.