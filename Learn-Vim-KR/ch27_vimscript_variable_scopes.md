# Ch27. Vimscript 변수 범위

Vimscript 함수에 대해 알아보기 전에, Vim 변수의 다양한 소스와 범위에 대해 배워보겠습니다.

## 가변 및 불변 변수

`let`을 사용하여 Vim에서 변수에 값을 할당할 수 있습니다:

```
let pancake = "pancake"
```

나중에 언제든지 해당 변수를 호출할 수 있습니다.

```
echo pancake
" "pancake"를 반환합니다
```

`let`은 가변적이므로, 나중에 언제든지 값을 변경할 수 있습니다.

```
let pancake = "pancake"
let pancake = "not waffles"

echo pancake
" "not waffles"를 반환합니다
```

설정된 변수의 값을 변경하려면 여전히 `let`을 사용해야 합니다.

```
let beverage = "milk"

beverage = "orange juice"
" 오류를 발생시킵니다
```

`const`로 불변 변수를 정의할 수 있습니다. 불변이므로 변수 값이 한번 할당되면 다른 값으로 재할당할 수 없습니다.

```
const waffle = "waffle"
const waffle = "pancake"
" 오류를 발생시킵니다
```

## 변수 소스

변수에는 환경 변수, 옵션 변수, 레지스터 변수의 세 가지 소스가 있습니다.

### 환경 변수

Vim은 터미널 환경 변수에 접근할 수 있습니다. 예를 들어, 터미널에서 `SHELL` 환경 변수를 사용할 수 있다면 Vim에서 다음과 같이 접근할 수 있습니다:

```
echo $SHELL
" $SHELL 값을 반환합니다. 제 경우에는 /bin/bash를 반환합니다
```

### 옵션 변수

`&`를 사용하여 Vim 옵션에 접근할 수 있습니다 (`set`으로 접근하는 설정들).

예를 들어, Vim이 어떤 배경을 사용하는지 보려면 다음을 실행할 수 있습니다:

```
echo &background
" "light" 또는 "dark"를 반환합니다
```

또는, 언제든지 `set background?`를 실행하여 `background` 옵션의 값을 볼 수 있습니다.

### 레지스터 변수

`@`를 사용하여 Vim 레지스터(8장)에 접근할 수 있습니다.

"chocolate"이라는 값이 이미 레지스터 a에 저장되어 있다고 가정해 봅시다. 접근하려면 `@a`를 사용할 수 있습니다. `let`으로 업데이트할 수도 있습니다.

```
echo @a
" chocolate을 반환합니다

let @a .= " donut"

echo @a
" "chocolate donut"을 반환합니다
```

이제 레지스터 `a`에서 붙여넣기하면(`"ap`), "chocolate donut"이 반환됩니다. `.=` 연산자는 두 문자열을 연결합니다. `let @a .= " donut"` 표현식은 `let @a = @a . " donut"`과 동일합니다.

## 변수 범위

Vim에는 9가지 다른 변수 범위가 있습니다. 앞에 붙는 문자로 인식할 수 있습니다:

```
g:           전역 변수
{nothing}    전역 변수
b:           버퍼-지역 변수
w:           창-지역 변수
t:           탭-지역 변수
s:           소스된 Vimscript 변수
l:           함수 지역 변수
a:           함수 형식 매개변수 변수
v:           내장 Vim 변수
```

### 전역 변수

"일반적인" 변수를 선언할 때:

```
let pancake = "pancake"
```

`pancake`는 실제로 전역 변수입니다. 전역 변수를 정의하면 어디서든 호출할 수 있습니다.

변수에 `g:`를 붙여도 전역 변수가 생성됩니다.

```
let g:waffle = "waffle"
```

이 경우 `pancake`와 `g:waffle`은 동일한 범위를 가집니다. `g:`를 붙이거나 붙이지 않고 각각을 호출할 수 있습니다.

```
echo pancake
" "pancake"를 반환합니다

echo g:pancake
" "pancake"를 반환합니다

echo waffle
" "waffle"를 반환합니다

echo g:waffle
" "waffle"를 반환합니다
```

### 버퍼 변수

`b:`가 앞에 붙는 변수는 버퍼 변수입니다. 버퍼 변수는 현재 버퍼(2장)에 지역적인 변수입니다. 여러 버퍼가 열려 있는 경우 각 버퍼는 자신만의 버퍼 변수 목록을 가집니다.

버퍼 1에서:

```
const b:donut = "chocolate donut"
```

버퍼 2에서:

```
const b:donut = "blueberry donut"
```

버퍼 1에서 `echo b:donut`을 실행하면 "chocolate donut"을 반환합니다. 버퍼 2에서 실행하면 "blueberry donut"을 반환합니다.

참고로, Vim에는 현재 버퍼에 대한 모든 변경 사항을 추적하는 *특수* 버퍼 변수 `b:changedtick`이 있습니다.

1. `echo b:changedtick`을 실행하고 반환되는 숫자를 기록합니다.
2. Vim에서 변경 사항을 만듭니다.
3. `echo b:changedtick`을 다시 실행하고 이제 반환되는 숫자를 기록합니다.

### 창 변수

`w:`가 앞에 붙는 변수는 창 변수입니다. 해당 창에만 존재합니다.

창 1에서:

```
const w:donut = "chocolate donut"
```

창 2에서:

```
const w:donut = "raspberry donut"
```

각 창에서 `echo w:donut`을 호출하여 고유한 값을 얻을 수 있습니다.

### 탭 변수

`t:`가 앞에 붙는 변수는 탭 변수입니다. 해당 탭에만 존재합니다.

탭 1에서:

```
const t:donut = "chocolate donut"
```

탭 2에서:

```
const t:donut = "blackberry donut"
```

각 탭에서 `echo t:donut`을 호출하여 고유한 값을 얻을 수 있습니다.

### 스크립트 변수

`s:`가 앞에 붙는 변수는 스크립트 변수입니다. 이러한 변수는 해당 스크립트 내에서만 접근할 수 있습니다.

임의의 파일 `dozen.vim`이 있고 그 안에 다음이 있다고 가정해 봅시다:

```
let s:dozen = 12

function Consume()
  let s:dozen -= 1
  echo s:dozen " is left"
endfunction
```

`:source dozen.vim`으로 파일을 소스합니다. 이제 `Consume` 함수를 호출합니다:

```
:call Consume()
" "11 is left"를 반환합니다

:call Consume()
" "10 is left"를 반환합니다

:echo s:dozen
" 정의되지 않은 변수 오류
```

`Consume`을 호출하면 예상대로 `s:dozen` 값이 감소하는 것을 볼 수 있습니다. `s:dozen` 값을 직접 가져오려고 하면 Vim은 범위를 벗어났기 때문에 찾지 못합니다. `s:dozen`은 `dozen.vim` 내부에서만 접근할 수 있습니다.

`dozen.vim` 파일을 소스할 때마다 `s:dozen` 카운터가 재설정됩니다. `s:dozen` 값을 감소시키는 중간에 `:source dozen.vim`을 실행하면 카운터가 12로 다시 설정됩니다. 이것은 의심하지 않는 사용자에게 문제가 될 수 있습니다. 이 문제를 해결하려면 코드를 리팩토링하세요:

```
if !exists("s:dozen")
  let s:dozen = 12
endif

function Consume()
  let s:dozen -= 1
  echo s:dozen
endfunction
```

이제 감소시키는 중간에 `dozen.vim`을 소스하면, Vim은 `!exists("s:dozen")`을 읽고 참임을 발견하고 값을 12로 재설정하지 않습니다.

### 함수 지역 및 함수 형식 매개변수 변수

함수 지역 변수(`l:`)와 함수 형식 변수(`a:`)는 다음 챕터에서 다룰 것입니다.

### 내장 Vim 변수

`v:`가 앞에 붙는 변수는 특별한 내장 Vim 변수입니다. 이러한 변수는 정의할 수 없습니다. 이미 일부를 보았습니다.
- `v:version`은 사용 중인 Vim 버전을 알려줍니다.
- `v:key`는 딕셔너리를 반복할 때 현재 항목의 값을 포함합니다.
- `v:val`은 `map()` 또는 `filter()` 작업을 실행할 때 현재 항목의 값을 포함합니다.
- `v:true`, `v:false`, `v:null`, `v:none`은 특수 데이터 타입입니다.

다른 변수들도 있습니다. Vim 내장 변수 목록은 `:h vim-variable` 또는 `:h v:`를 확인하세요.

## 똑똑하게 Vim 변수 범위 사용하기

환경, 옵션, 레지스터 변수에 빠르게 접근할 수 있으면 편집기와 터미널 환경을 사용자 정의하는 데 폭넓은 유연성을 제공합니다. 또한 Vim에는 9가지 다른 변수 범위가 있으며, 각 범위는 특정 제약 조건 하에 존재한다는 것을 배웠습니다. 이러한 고유한 변수 타입을 활용하여 프로그램을 분리할 수 있습니다.

여기까지 오셨습니다. 데이터 타입, 조합 수단, 변수 범위에 대해 배웠습니다. 이제 남은 것은 함수뿐입니다.