# Ch17. 접기

파일을 읽을 때, 종종 파일이 무엇을 하는지 이해하는 데 방해가 되는 관련 없는 텍스트가 많이 있습니다. 불필요한 노이즈를 숨기려면 Vim 접기를 사용하세요.

이 장에서는 파일을 접는 다양한 방법을 배웁니다.

## 수동 접기

종이 한 장을 접어 일부 텍스트를 가린다고 상상해보세요. 실제 텍스트는 사라지지 않고, 여전히 거기에 있습니다. Vim 접기도 같은 방식으로 작동합니다. 텍스트 범위를 접어서 실제로 삭제하지 않고 디스플레이에서 숨깁니다.

접기 연산자는 `z`입니다 (종이를 접으면 z자 모양이 됩니다).

다음과 같은 텍스트가 있다고 가정해 봅시다:

```
Fold me
Hold me
```

첫 번째 줄에 커서를 놓고 `zfj`를 입력하세요. Vim은 두 줄을 하나로 접습니다. 다음과 같은 것을 볼 수 있습니다:

```
+-- 2 lines: Fold me -----
```

분석은 다음과 같습니다:
- `zf`는 접기 연산자입니다.
- `j`는 접기 연산자에 대한 모션입니다.

접힌 텍스트는 `zo`로 열 수 있습니다. 접기를 닫으려면 `zc`를 사용하세요.

접기는 연산자이므로 문법 규칙(`동사 + 명사`)을 따릅니다. 접기 연산자에 모션이나 텍스트 객체를 전달할 수 있습니다. 내부 문단을 접으려면 `zfip`를 실행하세요. 파일 끝까지 접으려면 `zfG`를 실행하세요. `{`와 `}` 사이의 텍스트를 접으려면 `zfa{`를 실행하세요.

비주얼 모드에서 접을 수 있습니다. 접고 싶은 영역을 강조 표시(`v`, `V`, 또는 `Ctrl-v`)한 다음, `zf`를 실행하세요.

커맨드-라인 모드에서 `:fold` 명령어로 접기를 실행할 수 있습니다. 현재 줄과 그 다음 줄을 접으려면 다음을 실행하세요:

```
:,+1fold
```

`,+1`은 범위입니다. 범위에 매개변수를 전달하지 않으면 기본적으로 현재 줄이 됩니다. `+1`은 다음 줄에 대한 범위 표시기입니다. 5번 줄부터 10번 줄까지 접으려면 `:5,10fold`를 실행하세요. 현재 위치에서 줄 끝까지 접으려면 `:,$fold`를 실행하세요.

다른 많은 접기 및 펼치기 명령어가 있습니다. 처음 시작할 때 기억하기에는 너무 많다고 생각합니다. 가장 유용한 것들은 다음과 같습니다:
- `zR` 모든 접기 열기.
- `zM` 모든 접기 닫기.
- `za` 접기 토글.

어떤 줄에서든 `zR`과 `zM`을 실행할 수 있지만, `za`는 접히거나 펼쳐진 줄에 있을 때만 작동합니다. 더 많은 접기 명령어에 대해 배우려면 `:h fold-commands`를 확인하세요.

## 다른 접기 방법

위 섹션에서는 Vim의 수동 접기를 다루었습니다. Vim에는 여섯 가지 다른 접기 방법이 있습니다:
1. 수동
2. 들여쓰기
3. 표현식
4. 구문
5. 차이
6. 마커

현재 사용 중인 접기 방법을 보려면 `:set foldmethod?`를 실행하세요. 기본적으로 Vim은 `manual` 방법을 사용합니다.

이 장의 나머지 부분에서는 다른 다섯 가지 접기 방법을 배웁니다. 들여쓰기 접기부터 시작해 봅시다.

## 들여쓰기 접기

들여쓰기 접기를 사용하려면 `'foldmethod'`를 들여쓰기로 변경하세요:

```
:set foldmethod=indent
```

다음과 같은 텍스트가 있다고 가정해 봅시다:

```
One
  Two
  Two again
```

`:set foldmethod=indent`를 실행하면 다음을 볼 수 있습니다:

```
One
+-- 2 lines: Two -----
```

들여쓰기 접기를 사용하면, Vim은 각 줄의 시작에 있는 공백 수를 보고 그것을 `'shiftwidth'` 옵션과 비교하여 접기 가능성을 결정합니다. `'shiftwidth'`는 들여쓰기의 각 단계에 필요한 공백 수를 반환합니다. 다음을 실행하면:

```
:set shiftwidth?
```

Vim의 기본 `'shiftwidth'` 값은 2입니다. 위 텍스트에서, 줄의 시작과 "Two" 및 "Two again" 텍스트 사이에 두 개의 공백이 있습니다. Vim이 공백 수와 `'shiftwidth'` 값이 2인 것을 보면, Vim은 해당 줄이 들여쓰기 접기 레벨 1을 갖는 것으로 간주합니다.

이번에는 줄의 시작과 텍스트 사이에 공백이 하나만 있다고 가정해 봅시다:

```
One
 Two
 Two again
```

지금 `:set foldmethod=indent`를 실행하면, 각 줄에 충분한 공백이 없기 때문에 Vim은 들여쓴 줄을 접지 않습니다. 공백 하나는 들여쓰기로 간주되지 않습니다. 하지만, `'shiftwidth'`를 1로 변경하면:

```
:set shiftwidth=1
```

이제 텍스트가 접을 수 있게 됩니다. 이제 들여쓰기로 간주됩니다.

`shiftwidth`를 다시 2로 복원하고 텍스트 사이의 공백도 다시 두 개로 만드세요. 또한, 두 개의 추가 텍스트를 추가하세요:

```
One
  Two
  Two again
    Three
    Three again
```

접기(`zM`)를 실행하면 다음을 볼 수 있습니다:

```
One
+-- 4 lines: Two -----
```

접힌 줄을 펼치고(`zR`), 커서를 "Three"에 놓고 텍스트의 접기 상태를 토글하세요(`za`):

```
One
  Two
  Two again
+-- 2 lines: Three -----
```

이게 뭐죠? 접기 속의 접기?

중첩된 접기는 유효합니다. "Two"와 "Two again" 텍스트는 접기 레벨 1을 가집니다. "Three"와 "Three again" 텍스트는 접기 레벨 2를 가집니다. 접을 수 있는 텍스트 안에 더 높은 접기 레벨을 가진 접을 수 있는 텍스트가 있다면, 여러 개의 접기 레이어를 갖게 됩니다.

## 표현식 접기

표현식 접기는 접기를 위해 일치시킬 표현식을 정의할 수 있게 해줍니다. 접기 표현식을 정의한 후, Vim은 `'foldexpr'`의 값을 위해 각 줄을 스캔합니다. 이것은 적절한 값을 반환하도록 구성해야 하는 변수입니다. `'foldexpr'`가 0을 반환하면, 해당 줄은 접히지 않습니다. 1을 반환하면, 해당 줄은 접기 레벨 1을 가집니다. 2를 반환하면, 해당 줄은 접기 레벨 2를 가집니다. 정수 외에 다른 값들도 있지만, 그것들은 다루지 않겠습니다. 궁금하다면 `:h fold-expr`를 확인하세요.

먼저, foldmethod를 변경해 봅시다:

```
:set foldmethod=expr
```

아침 식사 음식 목록이 있고 "p"로 시작하는 모든 아침 식사 항목을 접고 싶다고 가정해 봅시다:

```
donut
pancake
pop-tarts
protein bar
salmon
scrambled eggs
```

다음으로, "p"로 시작하는 표현식을 캡처하도록 `foldexpr`를 변경하세요:

```
:set foldexpr=getline(v:lnum)[0]==\\"p\\"
```

위 표현식은 복잡해 보입니다. 분석해 봅시다:
- `:set foldexpr`는 사용자 지정 표현식을 받도록 `'foldexpr'` 옵션을 설정합니다.
- `getline()`은 주어진 줄의 내용을 반환하는 Vimscript 함수입니다. `:echo getline(5)`를 실행하면 5번 줄의 내용이 반환됩니다.
- `v:lnum`은 `'foldexpr'` 표현식을 위한 Vim의 특수 변수입니다. Vim은 각 줄을 스캔하고 그 순간 각 줄의 번호를 `v:lnum` 변수에 저장합니다. 5번 줄에서, `v:lnum`은 값 5를 가집니다. 10번 줄에서, `v:lnum`은 값 10을 가집니다.
- `getline(v:lnum)[0]`의 맥락에서 `[0]`은 각 줄의 첫 번째 문자입니다. Vim이 한 줄을 스캔할 때, `getline(v:lnum)`은 각 줄의 내용을 반환합니다. `getline(v:lnum)[0]`은 각 줄의 첫 번째 문자를 반환합니다. 우리 목록의 첫 번째 줄 "donut"에서, `getline(v:lnum)[0]`은 "d"를 반환합니다. 우리 목록의 두 번째 줄 "pancake"에서, `getline(v:lnum)[0]`은 "p"를 반환합니다.
- `==\\"p\\"`는 등식 표현식의 두 번째 절반입니다. 방금 평가한 표현식이 "p"와 같은지 확인합니다. 참이면 1을 반환합니다. 거짓이면 0을 반환합니다. Vim에서 1은 참이고 0은 거짓입니다. 따라서 "p"로 시작하는 줄에서는 1을 반환합니다. `'foldexpr'`가 값 1을 가지면 접기 레벨 1을 갖는다는 것을 상기하세요.

이 표현식을 실행한 후, 다음을 볼 수 있습니다:

```
donut
+-- 3 lines: pancake -----
salmon
scrambled eggs
```

## 구문 접기

구문 접기는 구문 언어 강조 표시에 의해 결정됩니다. [vim-polyglot](https://github.com/sheerun/vim-polyglot)과 같은 언어 구문 플러그인을 사용하면, 구문 접기는 즉시 작동합니다. 접기 방법을 구문으로 변경하기만 하면 됩니다:

```
:set foldmethod=syntax
```

자바스크립트 파일을 편집 중이고 vim-polyglot이 설치되어 있다고 가정해 봅시다. 다음과 같은 배열이 있다면:

```
const nums = [
  one,
  two,
  three,
  four
]
```

구문 접기로 접힐 것입니다. 특정 언어에 대한 구문 강조 표시를 정의할 때(보통 `syntax/` 디렉토리 내부), `fold` 속성을 추가하여 접을 수 있도록 만들 수 있습니다. 아래는 vim-polyglot 자바스크립트 구문 파일의 일부입니다. 끝에 있는 `fold` 키워드에 주목하세요.

```
syntax region  jsBracket                      matchgroup=jsBrackets            start=/\[/ end=/\]/ contains=@jsExpression,jsSpreadExpression extend fold
```

이 가이드에서는 `syntax` 기능을 다루지 않습니다. 궁금하다면 `:h syntax.txt`를 확인하세요.

## 차이 접기

Vim은 두 개 이상의 파일을 비교하기 위해 차이 절차를 수행할 수 있습니다.

`file1.txt`가 있다면:

```
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
```

그리고 `file2.txt`:

```
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
emacs is ok
```

`vimdiff file1.txt file2.txt`를 실행하세요:

```
+-- 3 lines: vim is awesome -----
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
vim is awesome
[vim is awesome] / [emacs is ok]
```

Vim은 일부 동일한 줄을 자동으로 접습니다. `vimdiff` 명령어를 실행할 때, Vim은 자동으로 `foldmethod=diff`를 사용합니다. `:set foldmethod?`를 실행하면 `diff`를 반환합니다.

## 마커 접기

마커 접기를 사용하려면 다음을 실행하세요:

```
:set foldmethod=marker
```

다음과 같은 텍스트가 있다고 가정해 봅시다:

```
Hello

{{{
world
vim
}}}
```

`zM`을 실행하면 다음을 볼 수 있습니다:

```
hello

+-- 4 lines: -----
```

Vim은 `{{{`와 `}}}`를 접기 표시기로 보고 그 사이의 텍스트를 접습니다. 마커 접기를 사용하면, Vim은 `'foldmarker'` 옵션에 의해 정의된 특수 마커를 찾아 접기 영역을 표시합니다. Vim이 어떤 마커를 사용하는지 보려면 다음을 실행하세요:

```
:set foldmarker?
```

기본적으로 Vim은 `{{{`와 `}}}`를 표시기로 사용합니다. 표시기를 "coffee1"과 "coffee2"와 같은 다른 텍스트로 변경하고 싶다면:

```
:set foldmarker=coffee1,coffee2
```

다음과 같은 텍스트가 있다면:

```
hello

coffee1
world
vim
coffee2
```

이제 Vim은 `coffee1`과 `coffee2`를 새로운 접기 마커로 사용합니다. 참고로, 표시기는 리터럴 문자열이어야 하며 정규식일 수 없습니다.

## 접기 유지하기

Vim 세션을 닫으면 모든 접기 정보가 손실됩니다. `count.txt` 파일이 있다면:

```
one
two
three
four
five
```

그런 다음 "three" 줄부터 아래로 수동 접기를 합니다 (`:3,$fold`):

```
one
two
+-- 3 lines: three ---
```

Vim을 종료하고 `count.txt`를 다시 열면, 접기가 더 이상 없습니다!

접기를 보존하려면, 접은 후 다음을 실행하세요:

```
:mkview
```

그런 다음 `count.txt`를 열 때, 다음을 실행하세요:

```
:loadview
```

접기가 복원됩니다. 하지만, `mkview`와 `loadview`를 수동으로 실행해야 합니다. 언젠가 파일을 닫기 전에 `mkview`를 실행하는 것을 잊어버리고 모든 접기를 잃게 될 것이라는 것을 압니다. 이 과정을 어떻게 자동화할 수 있을까요?

`.txt` 파일을 닫을 때 자동으로 `mkview`를 실행하고 `.txt` 파일을 열 때 `loadview`를 실행하려면, vimrc에 다음을 추가하세요:

```
autocmd BufWinLeave *.txt mkview
autocmd BufWinEnter *.txt silent loadview
```

`autocmd`는 이벤트 트리거 시 명령어를 실행하는 데 사용된다는 것을 상기하세요. 여기서 두 이벤트는 다음과 같습니다:
- `BufWinLeave` 창에서 버퍼를 제거할 때.
- `BufWinEnter` 창에서 버퍼를 로드할 때.

이제 `.txt` 파일 내부에서 접고 Vim을 종료한 후, 다음에 해당 파일을 열면 접기 정보가 복원됩니다.

기본적으로, Vim은 유닉스 시스템의 경우 `~/.vim/view` 내부에 `mkview`를 실행할 때 접기 정보를 저장합니다. 더 많은 정보는 `:h 'viewdir'`를 확인하세요.

## 현명하게 접기 배우기

Vim을 처음 시작했을 때, 유용하다고 생각하지 않았기 때문에 접기 배우는 것을 소홀히 했습니다. 하지만 코딩을 오래 할수록 접기가 더 유용하다는 것을 알게 되었습니다. 전략적으로 배치된 접기는 책의 목차처럼 텍스트 구조에 대한 더 나은 개요를 제공할 수 있습니다.

접기를 배울 때, 즉시 사용할 수 있기 때문에 수동 접기부터 시작하세요. 그런 다음 점차 들여쓰기 및 마커 접기를 하는 다른 트릭을 배우세요. 마지막으로, 구문 및 표현식 접기를 하는 방법을 배우세요. 후자의 두 가지를 사용하여 자신만의 Vim 플러그인을 작성할 수도 있습니다.