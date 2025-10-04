# Ch29. 플러그인 작성하기: Titlecase 연산자 만들기

Vim에 익숙해지기 시작하면 자신만의 플러그인을 작성하고 싶을 수 있습니다. 저는 최근에 첫 Vim 플러그인인 [totitle-vim](https://github.com/iggredible/totitle-vim)을 작성했습니다. 이것은 Vim의 대문자 `gU`, 소문자 `gu`, 대소문자 전환 `g~` 연산자와 유사한 titlecase 연산자 플러그인입니다.

이번 챕터에서는 `totitle-vim` 플러그인의 분석을 제시하겠습니다. 이 과정을 통해 약간의 통찰력을 제공하고 여러분이 자신만의 독특한 플러그인을 만들도록 영감을 주기를 바랍니다!

## 문제점

저는 이 가이드를 포함하여 제 기사를 작성하는 데 Vim을 사용합니다.

주요 문제 중 하나는 제목에 적절한 title case를 만드는 것이었습니다. 이를 자동화하는 한 가지 방법은 `g/^#/ s/\<./\u\0/g`로 헤더의 각 단어를 대문자로 만드는 것입니다. 기본적인 사용에는 이 명령어가 충분했지만, 실제 title case만큼 좋지는 않았습니다. "Capitalize The First Letter Of Each Word"에서 "The"와 "Of"는 소문자로 표기되어야 합니다. 적절한 대소문자 표기 없이는 문장이 약간 어색해 보입니다.

처음에는 플러그인을 작성할 계획이 없었습니다. 또한 이미 [vim-titlecase](https://github.com/christoomey/vim-titlecase)라는 titlecase 플러그인이 있다는 것을 알게 되었습니다. 하지만 제가 원하는 대로 작동하지 않는 몇 가지가 있었습니다. 주요한 것은 블록 단위 비주얼 모드의 동작이었습니다. 다음과 같은 구문이 있다면:

```
test title one
test title two
test title three
```

"tle"에 블록 비주얼 하이라이트를 사용하면:

```
test ti[tle] one
test ti[tle] two
test ti[tle] three
```

`gt`를 누르면 플러그인이 대문자로 만들지 않습니다. 저는 이것이 `gu`, `gU`, `g~`의 동작과 일관성이 없다고 생각했습니다. 그래서 저는 해당 titlecase 플러그인 저장소에서 작업을 시작하여 `gu`, `gU`, `g~`와 일관된 titlecase 플러그인을 직접 만들기로 결정했습니다! 다시 말하지만, vim-titlecase 플러그인 자체는 훌륭한 플러그인이며 그 자체로 사용할 가치가 있습니다(사실은, 아마도 마음속 깊은 곳에서는 제 자신의 Vim 플러그인을 작성하고 싶었을 것입니다. 블록 단위 titlecasing 기능이 실제 생활에서 극단적인 경우 외에는 그렇게 자주 사용될 것이라고는 생각하지 않습니다).

### 플러그인 계획하기

첫 줄의 코드를 작성하기 전에, titlecase 규칙이 무엇인지 결정해야 합니다. [titlecaseconverter 사이트](https://titlecaseconverter.com/rules/)에서 다양한 대소문자 규칙의 깔끔한 표를 찾았습니다. 영어에는 적어도 8가지 다른 대소문자 규칙이 있다는 것을 알고 계셨나요? *헉!*

결국, 저는 그 목록에서 공통 분모를 사용하여 플러그인을 위한 충분히 좋은 기본 규칙을 만들었습니다. 게다가 사람들이 "이봐, 당신은 AMA를 사용하고 있는데 왜 APA를 사용하지 않나요?"라고 불평할 것이라고는 생각하지 않습니다. 다음은 기본 규칙입니다:
- 첫 단어는 항상 대문자입니다.
- 일부 부사, 접속사, 전치사는 소문자입니다.
- 입력 단어가 완전히 대문자인 경우 아무것도 하지 않습니다(약어일 수 있음).

어떤 단어가 소문자인지에 대해서는 다른 규칙마다 다른 목록이 있습니다. 저는 `a an and at but by en for in nor of off on or out per so the to up yet vs via`에 충실하기로 결정했습니다.

### 사용자 인터페이스 계획하기

저는 플러그인이 Vim의 기존 대소문자 연산자인 `gu`, `gU`, `g~`를 보완하는 연산자가 되기를 원합니다. 연산자이므로 모션이나 텍스트 객체를 받아야 합니다(`gtw`는 다음 단어를 titlecase로, `gtiw`는 내부 단어를 titlecase로, `gt$`는 현재 위치에서 줄 끝까지 단어를 titlecase로, `gtt`는 현재 줄을 titlecase로, `gti(`는 괄호 안의 단어를 titlecase로 등). 또한 쉬운 연상을 위해 `gt`에 매핑되기를 원합니다. 또한 모든 비주얼 모드(`v`, `V`, `Ctrl-V`)에서도 작동해야 합니다. *어떤* 비주얼 모드에서든 하이라이트하고 `gt`를 누르면 모든 하이라이트된 텍스트가 titlecase가 되어야 합니다.

## Vim 런타임

저장소를 볼 때 가장 먼저 보게 되는 것은 `plugin/`과 `doc/`라는 두 개의 디렉토리가 있다는 것입니다. Vim을 시작하면 `~/.vim` 디렉토리 내에서 특수 파일과 디렉토리를 찾아 해당 디렉토리 내의 모든 스크립트 파일을 실행합니다. 자세한 내용은 Vim 런타임 챕터를 복습하세요.

플러그인은 `doc/`와 `plugin/`이라는 두 개의 Vim 런타임 디렉토리를 활용합니다. `doc/`는 도움말 문서를 넣는 곳입니다(나중에 `:h totitle`과 같이 키워드를 검색할 수 있도록). 도움말 페이지를 만드는 방법은 나중에 설명하겠습니다. 지금은 `plugin/`에 집중합시다. `plugin/` 디렉토리는 Vim이 부팅될 때 한 번 실행됩니다. 이 디렉토리 안에는 `totitle.vim`이라는 파일이 하나 있습니다. 이름은 중요하지 않습니다(`whatever.vim`이라고 이름 지었어도 작동했을 것입니다). 플러그인이 작동하는 데 책임이 있는 모든 코드는 이 파일 안에 있습니다.

## 매핑

코드를 살펴보겠습니다!

파일 시작 부분에 다음이 있습니다:

```
if !exists('g:totitle_default_keys')
  let g:totitle_default_keys = 1
endif
```

Vim을 시작하면 `g:totitle_default_keys`는 아직 존재하지 않으므로 `!exists(...)`는 참을 반환합니다. 이 경우 `g:totitle_default_keys`를 1과 같도록 정의합니다. Vim에서 0은 거짓이고 0이 아닌 값은 참입니다(참을 나타내기 위해 1을 사용).

파일 맨 아래로 점프해 봅시다. 다음을 볼 수 있습니다:

```
if g:totitle_default_keys
  nnoremap <expr> gt ToTitle()
  xnoremap <expr> gt ToTitle()
  nnoremap <expr> gtt ToTitle() .. '_'
endif
```

이것이 주요 `gt` 매핑이 정의되는 곳입니다. 이 경우, 파일 맨 아래의 `if` 조건문에 도달할 때까지 `if g:totitle_default_keys`는 1(참)을 반환하므로 Vim은 다음 맵을 수행합니다:
- `nnoremap <expr> gt ToTitle()`는 일반 모드 *연산자*를 매핑합니다. 이것은 `gtw`와 같이 연산자 + 모션/텍스트 객체를 실행하여 다음 단어를 titlecase로 만들거나 `gtiw`로 내부 단어를 titlecase로 만들 수 있게 합니다. 연산자 매핑이 어떻게 작동하는지에 대한 자세한 내용은 나중에 설명하겠습니다.
- `xnoremap <expr> gt ToTitle()`는 비주얼 모드 연산자를 매핑합니다. 이것은 시각적으로 하이라이트된 텍스트를 titlecase로 만들 수 있게 합니다.
- `nnoremap <expr> gtt ToTitle() .. '_'`는 일반 모드 줄 단위 연산자를 매핑합니다(`guu` 및 `gUU`와 유사). 끝에 있는 `.. '_'`가 무엇을 하는지 궁금할 수 있습니다. `..`는 Vim의 문자열 보간 연산자입니다. `_`는 연산자와 함께 모션으로 사용됩니다. `:help _`를 보면 밑줄은 한 줄 아래로 세는 데 사용된다고 나와 있습니다. 현재 줄에서 연산자를 수행합니다(다른 연산자와 함께 시도해 보세요, `gU_` 또는 `d_`를 실행해 보세요, `gUU` 또는 `dd`와 동일하게 작동하는 것을 알 수 있습니다).
- 마지막으로 `<expr>` 인수는 카운트를 지정할 수 있게 하므로 `3gtw`를 실행하여 다음 3개 단어의 대소문자를 전환할 수 있습니다.

기본 `gt` 매핑을 사용하고 싶지 않다면 어떻게 해야 할까요? 결국 Vim의 기본 `gt`(다음 탭) 매핑을 재정의하는 것입니다. `gt` 대신 `gz`를 사용하고 싶다면 어떻게 해야 할까요? 이전에 `if !exists('g:totitle_default_keys')`와 `if g:totitle_default_keys`를 확인하는 수고를 겪었던 것을 기억하시나요? vimrc에 `let g:totitle_default_keys = 0`을 넣으면 플러그인이 실행될 때 `g:totitle_default_keys`가 이미 존재하게 되므로(vimrc의 코드는 `plugin/` 런타임 파일보다 먼저 실행됨), `!exists('g:totitle_default_keys')`는 거짓을 반환합니다. 또한 `if g:totitle_default_keys`는 거짓이 되므로(값이 0이므로), `gt` 매핑도 수행하지 않습니다! 이것은 vimrc에서 자신만의 사용자 정의 매핑을 효과적으로 정의할 수 있게 합니다.

자신만의 titlecase 매핑을 `gz`로 정의하려면 vimrc에 다음을 추가하세요:

```
let g:totitle_default_keys = 0

nnoremap <expr> gz ToTitle()
xnoremap <expr> gz ToTitle()
nnoremap <expr> gzz ToTitle() .. '_'
```

아주 쉽죠.

## ToTitle 함수

`ToTitle()` 함수는 이 파일에서 가장 긴 함수입니다.

```
 function! ToTitle(type = '')
  if a:type ==# ''
    set opfunc=ToTitle
    return 'g@'
  endif

  " invoke this when calling the ToTitle() function
  if a:type != 'block' && a:type != 'line' && a:type != 'char'
    let l:words = a:type
    let l:wordsArr = trim(l:words)->split('\s\+')
    call map(l:wordsArr, 's:capitalize(v:val)')
    return l:wordsArr->join(' ')
  endif

  " save the current settings
  let l:sel_save = &selection
  let l:reg_save = getreginfo('"')
  let l:cb_save = &clipboard
  let l:visual_marks_save = [getpos("'<"), getpos("'>")]

  try
    set clipboard= selection=inclusive
    let l:commands = #{line: "'[V']y", char: "`[v`]y", block: "`[\<c-v>`]y"}

    silent exe 'noautocmd keepjumps normal! ' .. get(l:commands, a:type, '')
    let l:selected_phrase = getreg('"')
    let l:WORD_PATTERN = '\<\k*\>'
    let l:UPCASE_REPLACEMENT = '\=s:capitalize(submatch(0))'

    let l:startLine = line("'<")
    let l:startCol = virtcol(".")

    " when user calls a block operation
    if a:type ==# "block"
      sil! keepj norm! gv"ad
      keepj $
      keepj pu_

      let l:lastLine = line("$")

      sil! keepj norm "ap

      let l:curLine = line(".")

      sil! keepj norm! VGg@
      exe "keepj norm! 0\<c-v>G$h\"ad"
      exe "keepj " . l:startLine
      exe "sil! keepj norm! " . l:startCol . "\<bar>\"aP"
      exe "keepj " . l:lastLine
      sil! keepj norm! "_dG
      exe "keepj " . l:startLine
      exe "sil! keepj norm! " . l:startCol . "\<bar>"

    " when user calls a char or line operation
    else
      let l:titlecased = substitute(@@, l:WORD_PATTERN, l:UPCASE_REPLACEMENT, 'g')
      let l:titlecased = s:capitalizeFirstWord(l:titlecased)
      call setreg('"', l:titlecased)
      let l:subcommands = #{line: "'[V']p", char: "`[v`]p", block: "`[\<c-v>`]p"}
      silent execute "noautocmd keepjumps normal! " .. get(l:subcommands, a:type, "")
      exe "keepj " . l:startLine
      exe "sil! keepj norm! " . l:startCol . "\<bar>"
    endif
  finally

    " restore the settings
    call setreg('"', l:reg_save)
    call setpos("'<", l:visual_marks_save[0])
    call setpos("'>", l:visual_marks_save[1])
    let &clipboard = l:cb_save
    let &selection = l:sel_save
  endtry
  return
endfunction
```

이것은 매우 길므로, 나누어서 살펴보겠습니다.

*이것을 더 작은 섹션으로 리팩토링할 수 있지만, 이 챕터를 완료하기 위해 그대로 두었습니다.*

## 연산자 함수

코드의 첫 번째 부분입니다:

```
if a:type ==# ''
  set opfunc=ToTitle
  return 'g@'
endif
```

대체 `opfunc`는 무엇일까요? 왜 `g@`를 반환할까요?

Vim에는 연산자 함수인 `g@`라는 특수 연산자가 있습니다. 이 연산자는 `opfunc` 옵션에 할당된 *모든* 함수를 사용할 수 있게 합니다. `opfunc`에 `Foo()` 함수가 할당되어 있다면, `g@w`를 실행하면 다음 단어에 `Foo()`를 실행하는 것입니다. `g@i(`를 실행하면 내부 괄호에 `Foo()`를 실행하는 것입니다. 이 연산자 함수는 자신만의 Vim 연산자를 만드는 데 중요합니다.

다음 줄은 `opfunc`를 `ToTitle` 함수에 할당합니다.

```
set opfunc=ToTitle
```

다음 줄은 말 그대로 `g@`를 반환합니다:

```
return g@
```

정확히 이 두 줄이 어떻게 작동하고 왜 `g@`를 반환하는 걸까요?

다음과 같은 맵이 있다고 가정해 봅시다:

```
nnoremap <expr> gt ToTitle()`
```

그런 다음 `gtw`(다음 단어를 titlecase로)를 누릅니다. `gtw`를 처음 실행하면 Vim은 `ToTitle()` 메서드를 호출합니다. 하지만 지금은 `opfunc`가 여전히 비어 있습니다. 또한 `ToTitle()`에 인수를 전달하지 않으므로 `a:type` 값은 `''`가 됩니다. 이로 인해 조건 표현식 `if a:type ==# ''`이 참이 됩니다. 내부에서는 `set opfunc=ToTitle`로 `opfunc`를 `ToTitle` 함수에 할당합니다. 이제 `opfunc`는 `ToTitle`에 할당되었습니다. 마지막으로 `opfunc`를 `ToTitle` 함수에 할당한 후 `g@`를 반환합니다. 왜 `g@`를 반환하는지는 아래에서 설명하겠습니다.

아직 끝나지 않았습니다. 기억하세요, 방금 `gtw`를 눌렀습니다. `gt`를 누르면 위의 모든 작업이 수행되지만 아직 처리해야 할 `w`가 남아 있습니다. `g@`를 반환함으로써, 이 시점에서 기술적으로 `g@w`를 가지게 됩니다(이것이 `return g@`가 있는 이유입니다). `g@`는 함수 연산자이므로, `w` 모션을 전달하는 것입니다. 그래서 Vim은 `g@w`를 받으면 `ToTitle`을 *한 번 더* 호출합니다(걱정 마세요, 곧 보게 될 것처럼 무한 루프에 빠지지는 않을 것입니다).

요약하자면, `gtw`를 누르면 Vim은 `opfunc`가 비어 있는지 확인합니다. 비어 있으면 `ToTitle`로 할당합니다. 그런 다음 `g@`를 반환하여, 연산자로 사용할 수 있도록 `ToTitle`을 한 번 더 호출합니다. 이것이 사용자 정의 연산자를 만드는 가장 까다로운 부분이며, 여러분은 해냈습니다! 다음으로, `ToTitle()`이 실제로 입력을 titlecase로 만드는 로직을 구축해야 합니다.

## 입력 처리

이제 `ToTitle()`을 실행하는 연산자로 `gt`를 가지게 되었습니다. 하지만 다음에 무엇을 해야 할까요? 실제로 텍스트를 어떻게 titlecase로 만들까요?

Vim에서 어떤 연산자를 실행하든, 문자, 줄, 블록의 세 가지 다른 액션 모션 유형이 있습니다. `g@w`(단어)는 문자 작업의 예입니다. `g@j`(한 줄 아래)는 줄 작업의 예입니다. 블록 작업은 드물지만, 일반적으로 `Ctrl-V`(비주얼 블록) 작업을 수행할 때 블록 작업으로 계산됩니다. 몇 글자 앞으로/뒤로 타겟팅하는 작업은 일반적으로 문자 작업으로 간주됩니다(`b`, `e`, `w`, `ge` 등). 몇 줄 아래/위로 타겟팅하는 작업은 일반적으로 줄 작업으로 간주됩니다(`j`, `k`). 열을 앞으로, 뒤로, 위로 또는 아래로 타겟팅하는 작업은 일반적으로 블록 작업으로 간주됩니다(보통 열 강제 모션이거나 블록 단위 비주얼 모드입니다; 자세한 내용은 `:h forced-motion` 참조).

이는 `g@w`를 누르면 `g@`가 `ToTitle()`에 리터럴 문자열 `"char"`를 인수로 전달한다는 것을 의미합니다. `g@j`를 실행하면 `g@`가 리터럴 문자열 `"line"`을 `ToTitle()`에 전달합니다. 이 문자열이 `ToTitle` 함수에 `type` 인수로 전달될 것입니다.

## 자신만의 사용자 정의 함수 연산자 만들기

잠시 멈추고 더미 함수를 작성하여 `g@`를 가지고 놀아 봅시다:

```
function! Test(some_arg)
  echom a:some_arg
endfunction
```

이제 다음을 실행하여 해당 함수를 `opfunc`에 할당하세요:

```
:set opfunc=Test
```

`g@` 연산자는 `Test(some_arg)`를 실행하고 수행하는 작업에 따라 `"char"`, `"line"` 또는 `"block"` 중 하나를 전달합니다. `g@iw`(내부 단어), `g@j`(한 줄 아래), `g@$`(줄 끝까지) 등 다양한 작업을 실행해 보세요. 어떤 다른 값이 출력되는지 확인하세요. 블록 작업을 테스트하려면 Vim의 블록 작업용 강제 모션을 사용할 수 있습니다: `g@Ctrl-Vj`(한 열 아래 블록 작업).

비주얼 모드에서도 사용할 수 있습니다. `v`, `V`, `Ctrl-V`와 같은 다양한 비주얼 하이라이트를 사용한 다음 `g@`를 누르세요(경고: 출력 에코가 정말 빠르게 깜박이므로 빠른 눈이 필요합니다 - 하지만 에코는 확실히 있습니다. 또한 `echom`을 사용하고 있으므로 `:messages`로 기록된 에코 메시지를 확인할 수 있습니다).

꽤 멋지죠? Vim으로 프로그래밍할 수 있는 것들! 왜 학교에서는 이것을 가르쳐주지 않았을까요? 우리 플러그인을 계속 진행합시다.

## 함수로서의 ToTitle

다음 몇 줄로 넘어가겠습니다:

```
if a:type != 'block' && a:type != 'line' && a:type != 'char'
  let l:words = a:type
  let l:wordsArr = trim(l:words)->split('\s\+')
  call map(l:wordsArr, 's:capitalize(v:val)')
  return l:wordsArr->join(' ')
endif
```

이 줄은 실제로 `ToTitle()`의 연산자로서의 동작과는 아무 관련이 없으며, 호출 가능한 TitleCase 함수로 활성화하기 위한 것입니다(네, 제가 단일 책임 원칙을 위반하고 있다는 것을 압니다). 동기는 Vim에는 주어진 문자열을 대문자 및 소문자로 만드는 네이티브 `toupper()` 및 `tolower()` 함수가 있다는 것입니다. 예: `:echo toupper('hello')`는 `'HELLO'`를 반환하고 `:echo tolower('HELLO')`는 `'hello'`를 반환합니다. 저는 이 플러그인이 `ToTitle`을 실행할 수 있는 기능을 갖기를 원하므로 `:echo ToTitle('once upon a time')`을 실행하고 `'Once Upon a Time'` 반환 값을 얻을 수 있습니다.

이제 `g@`로 `ToTitle(type)`을 호출할 때 `type` 인수는 `'block'`, `'line'`, 또는 `'char'` 중 하나의 값을 가질 것이라는 것을 압니다. 인수가 `'block'`도 아니고 `'line'`도 아니고 `'char'`도 아니라면 `ToTitle()`이 `g@` 외부에서 호출되고 있다고 안전하게 가정할 수 있습니다. 이 경우 공백(`\s\+`)으로 분할합니다:

```
let l:wordsArr = trim(l:words)->split('\s\+')
```

그런 다음 각 요소를 대문자로 만듭니다:

```
call map(l:wordsArr, 's:capitalize(v:val)')
```

다시 합치기 전에:

```
l:wordsArr->join(' ')
```

`capitalize()` 함수는 나중에 다룰 것입니다.

## 임시 변수

다음 몇 줄:

```
let l:sel_save = &selection
let l:reg_save = getreginfo('"')
let l:cb_save = &clipboard
let l:visual_marks_save = [getpos("'<"), getpos("'>")]
```

이 줄들은 다양한 현재 상태를 임시 변수에 보존합니다. 나중에 비주얼 모드, 마크, 레지스터를 사용하게 됩니다. 이러한 작업을 수행하면 몇 가지 상태가 변경됩니다. 기록을 수정하고 싶지 않으므로 나중에 상태를 복원할 수 있도록 임시 변수에 저장해야 합니다.

## 선택 항목 대문자화하기

다음 줄들이 중요합니다:

```
try
  set clipboard= selection=inclusive
  let l:commands = #{line: "'[V']y", char: "`[v`]y", block: "`[\<c-v>`]y"}

  silent exe 'noautocmd keepjumps normal! ' .. get(l:commands, a:type, '')
  let l:selected_phrase = getreg('"')
  let l:WORD_PATTERN = '\<\k*\>'
  let l:UPCASE_REPLACEMENT = '\=s:capitalize(submatch(0))'

  let l:startLine = line("'<")
  let l:startCol = virtcol(".")

```
작은 덩어리로 살펴보겠습니다. 이 줄:

```
set clipboard= selection=inclusive
```

먼저 `selection` 옵션을 inclusive로 설정하고 `clipboard`를 비웁니다. selection 속성은 일반적으로 비주얼 모드와 함께 사용되며 `old`, `inclusive`, `exclusive`의 세 가지 가능한 값이 있습니다. inclusive로 설정하면 선택 항목의 마지막 문자가 포함됩니다. 여기서 다루지는 않겠지만, 요점은 inclusive로 선택하면 비주얼 모드에서 일관되게 동작한다는 것입니다. 기본적으로 Vim은 inclusive로 설정하지만, 플러그인 중 하나가 다른 값으로 설정할 경우를 대비하여 여기서 설정합니다. 궁금하다면 `:h 'clipboard'`와 `:h 'selection'`을 확인하세요.

다음으로 해시와 실행 명령어가 있는 이상하게 생긴 것이 있습니다:

```
let l:commands = #{line: "'[V']y", char: "`[v`]y", block: "`[\<c-v>`]y"}
silent exe 'noautocmd keepjumps normal! ' .. get(l:commands, a:type, '')
```

첫째, `#{}` 구문은 Vim의 딕셔너리 데이터 타입입니다. 지역 변수 `l:commands`는 'lines', 'char', 'block'을 키로 하는 해시입니다. `silent exe '...'` 명령어는 문자열 내부의 모든 명령어를 조용히 실행합니다(그렇지 않으면 화면 하단에 알림이 표시됩니다).

둘째, 실행되는 명령어는 `'noautocmd keepjumps normal! ' .. get(l:commands, a:type, '')`입니다. 첫 번째 `noautocmd`는 자동 명령어를 트리거하지 않고 후속 명령어를 실행합니다. 두 번째 `keepjumps`는 이동하는 동안 커서 움직임을 기록하지 않는 것입니다. Vim에서 특정 모션은 변경 목록, 점프 목록, 마크 목록에 자동으로 기록됩니다. 이것은 그것을 방지합니다. `noautocmd`와 `keepjumps`를 사용하는 요점은 부작용을 방지하는 것입니다. 마지막으로 `normal` 명령어는 문자열을 일반 명령어로 실행합니다. `..`는 Vim의 문자열 보간 구문입니다. `get()`은 리스트, 블롭 또는 딕셔너리를 허용하는 getter 메서드입니다. 이 경우 딕셔너리 `l:commands`를 전달하고 있습니다. 키는 `a:type`입니다. 이전에 `a:type`이 'char', 'line', 'block' 세 가지 문자열 값 중 하나라는 것을 배웠습니다. 따라서 `a:type`이 'line'이면 `"noautocmd keepjumps normal! '[V']y"`를 실행하게 됩니다(자세한 내용은 `:h silent`, `:h :exe`, `:h :noautocmd`, `:h :keepjumps`, `:h :normal`, `:h get()` 참조).

`'[V']y`가 무엇을 하는지 살펴보겠습니다. 먼저 다음과 같은 텍스트 본문이 있다고 가정해 봅시다:

```
the second breakfast
is better than the first breakfast
```
커서가 첫 번째 줄에 있다고 가정합니다. 그런 다음 `g@j`(연산자 함수 `g@`를 한 줄 아래로 `j`와 함께 실행)를 누릅니다. `'[`는 커서를 이전에 변경되거나 복사된 텍스트의 시작으로 이동합니다. 기술적으로 `g@j`로 텍스트를 변경하거나 복사하지는 않았지만 Vim은 `'[`와 `']`로 `g@` 명령어의 시작과 끝 위치를 기억합니다(자세한 내용은 `:h g@` 참조). 이 경우 `'[`를 누르면 커서가 첫 번째 줄로 이동합니다. `g@`를 실행했을 때 시작한 곳이기 때문입니다. `V`는 줄 단위 비주얼 모드 명령어입니다. 마지막으로 `']`는 커서를 이전 변경 또는 복사된 텍스트의 끝으로 이동하지만, 이 경우 마지막 `g@` 작업의 끝으로 커서를 이동합니다. 마지막으로 `y`는 선택된 텍스트를 복사합니다.

방금 한 일은 `g@`를 수행한 동일한 텍스트 본문을 복사한 것입니다.

여기에 있는 다른 두 명령어를 보면:

```
let l:commands = #{line: "'[V']y", char: "`[v`]y", block: "`[\<c-v>`]y"}
```

모두 비슷한 작업을 수행하지만, 줄 단위 작업 대신 문자 단위 또는 블록 단위 작업을 사용합니다. 중복되는 것처럼 들리겠지만, 세 가지 경우 모두 `g@`를 수행한 동일한 텍스트 본문을 효과적으로 복사하고 있습니다.

다음 줄을 봅시다:

```
let l:selected_phrase = getreg('"')
```

이 줄은 이름 없는 레지스터(`"`)의 내용을 가져와 `l:selected_phrase` 변수 안에 저장합니다. 잠깐만요... 방금 텍스트 본문을 복사하지 않았나요? 이름 없는 레지스터에는 방금 복사한 텍스트가 현재 포함되어 있습니다. 이것이 이 플러그인이 텍스트 사본을 얻을 수 있는 방법입니다.

다음 줄은 정규식 패턴입니다:

```
let l:WORD_PATTERN = '\<\k*\>'
```

`\<`와 `\>`는 단어 경계 패턴입니다. `\<` 뒤의 문자는 단어의 시작과 일치하고 `\>` 앞의 문자는 단어의 끝과 일치합니다. `\k`는 키워드 패턴입니다. `:set iskeyword?`로 Vim이 키워드로 허용하는 문자를 확인할 수 있습니다. Vim의 `w` 모션은 커서를 단어 단위로 이동시킨다는 것을 기억하세요. Vim에는 "키워드"가 무엇인지에 대한 사전 개념이 있습니다(`iskeyword` 옵션을 변경하여 편집할 수도 있음). 자세한 내용은 `:h /\<`, `:h /\>`, `:h /\k`, `:h 'iskeyword'`를 확인하세요. 마지막으로 `*`는 후속 패턴의 0개 이상을 의미합니다.

큰 그림에서 `'\<\k*\>'`는 단어와 일치합니다. 다음과 같은 문자열이 있다면:

```
one two three
```

패턴과 일치시키면 "one", "two", "three" 세 개의 일치 항목을 얻게 됩니다.

마지막으로 또 다른 패턴이 있습니다:

```
let l:UPCASE_REPLACEMENT = '\=s:capitalize(submatch(0))'
```

Vim의 substitute 명령어는 `\={your-expression}`으로 표현식과 함께 사용될 수 있다는 것을 기억하세요. 예를 들어, 현재 줄의 "donut" 문자열을 대문자로 만들고 싶다면 Vim의 `toupper()` 함수를 사용할 수 있습니다. `:%s/donut/\=toupper(submatch(0))/g`를 실행하여 이를 달성할 수 있습니다. `submatch(0)`은 substitute 명령어에서 사용되는 특수 표현식입니다. 일치하는 전체 텍스트를 반환합니다.

다음 두 줄:

```
let l:startLine = line("'<")
let l:startCol = virtcol(".")
```

`line()` 표현식은 줄 번호를 반환합니다. 여기서 마지막으로 선택한 비주얼 영역의 첫 번째 줄을 나타내는 `'<` 마크를 전달합니다. 텍스트를 복사하기 위해 비주얼 모드를 사용했다는 것을 기억하세요. `'<`는 해당 비주얼 영역 선택의 시작 줄 번호를 반환합니다. `virtcol()` 표현식은 현재 커서의 열 번호를 반환합니다. 곧 커서를 여기저기 움직일 것이므로, 나중에 돌아올 수 있도록 커서 위치를 저장해야 합니다.

여기서 잠시 쉬고 지금까지의 모든 것을 복습하세요. 여전히 잘 따라오고 있는지 확인하세요. 준비가 되면 계속합시다.

## 블록 작업 처리하기

이 섹션을 살펴보겠습니다:

```
if a:type ==# "block"
  sil! keepj norm! gv"ad
  keepj $
  keepj pu_

  let l:lastLine = line("$")

  sil! keepj norm "ap

  let l:curLine = line(".")

  sil! keepj norm! VGg@
  exe "keepj norm! 0\<c-v>G$h\"ad"
  exe "keepj " . l:startLine
  exe "sil! keepj norm! " . l:startCol . "\<bar>\"aP"
  exe "keepj " . l:lastLine
  sil! keepj norm! "_dG
  exe "keepj " . l:startLine
  exe "sil! keepj norm! " . l:startCol . "\<bar>"
```

이제 실제로 텍스트를 대문자로 만들 시간입니다. `a:type`이 'char', 'line' 또는 'block' 중 하나라는 것을 기억하세요. 대부분의 경우 'char'와 'line'을 얻게 될 것입니다. 하지만 가끔 블록을 얻을 수도 있습니다. 드물지만 그럼에도 불구하고 처리해야 합니다. 불행히도 블록을 처리하는 것은 char와 line을 처리하는 것만큼 간단하지 않습니다. 약간의 추가 노력이 필요하지만 가능합니다.

시작하기 전에 블록을 얻을 수 있는 방법의 예를 들어보겠습니다. 다음과 같은 텍스트가 있다고 가정해 봅시다:

```
pancake for breakfast
pancake for lunch
pancake for dinner
```

커서가 첫 번째 줄의 "pancake"의 "c"에 있다고 가정합니다. 그런 다음 비주얼 블록(`Ctrl-V`)을 사용하여 아래로, 앞으로 선택하여 세 줄 모두에서 "cake"를 선택합니다:

```
pan[cake] for breakfast
pan[cake] for lunch
pan[cake] for dinner
```

`gt`를 누르면 다음을 얻고 싶습니다:

```
panCake for breakfast
panCake for lunch
panCake for dinner

```
기본적인 가정은 다음과 같습니다: "pancakes"에서 세 개의 "cake"를 하이라이트할 때, 하이라이트하고 싶은 단어가 세 줄에 걸쳐 있다고 Vim에게 말하는 것입니다. 이 단어들은 "cake", "cake", "cake"입니다. "Cake", "Cake", "Cake"를 얻을 것으로 예상합니다.

구현 세부 정보로 넘어가겠습니다. 다음 몇 줄은 다음과 같습니다:

```
sil! keepj norm! gv"ad
keepj $
keepj pu_
let l:lastLine = line("$")
sil! keepj norm "ap
let l:curLine = line(".")
```

첫 번째 줄:

```
sil! keepj norm! gv"ad
```

`sil!`은 조용히 실행되고 `keepj`는 이동할 때 점프 기록을 유지한다는 것을 기억하세요. 그런 다음 일반 명령어 `gv"ad`를 실행합니다. `gv`는 마지막으로 시각적으로 하이라이트된 텍스트를 선택합니다(팬케이크 예에서는 세 개의 'cake'를 모두 다시 하이라이트합니다). `"ad`는 시각적으로 하이라이트된 텍스트를 삭제하고 레지스터 a에 저장합니다. 결과적으로 다음과 같이 됩니다:

```
pan for breakfast
pan for lunch
pan for dinner
```

이제 레지스터 a에 3개의 *블록*('줄'이 아님)의 'cake'가 저장되었습니다. 이 구별은 중요합니다. 줄 단위 비주얼 모드로 텍스트를 복사하는 것과 블록 단위 비주얼 모드로 텍스트를 복사하는 것은 다릅니다. 나중에 다시 보게 될 것이므로 이 점을 명심하세요.

다음은 다음과 같습니다:

```
keepj $
keepj pu_
```

`$`는 파일의 마지막 줄로 이동합니다. `pu_`는 커서 아래에 한 줄을 삽입합니다. 점프 기록을 변경하지 않도록 `keepj`와 함께 실행하고 싶습니다.

그런 다음 마지막 줄의 줄 번호(`line("$")`)를 지역 변수 `lastLine`에 저장합니다.

```
let l:lastLine = line("$")
```

그런 다음 `norm "ap`로 레지스터의 내용을 붙여넣습니다.

```
sil! keepj norm "ap
```

이것은 파일의 마지막 줄 아래에 만든 새 줄에서 발생하고 있다는 점을 명심하세요 - 현재 파일의 맨 아래에 있습니다. 붙여넣으면 다음과 같은 *블록* 텍스트가 생성됩니다:

```
cake
cake
cake
```

다음으로, 커서가 있는 현재 줄의 위치를 저장합니다.

```
let l:curLine = line(".")
```

이제 다음 몇 줄로 가봅시다:

```
sil! keepj norm! VGg@
exe "keepj norm! 0\<c-v>G$h\"ad"
exe "keepj " . l:startLine
exe "sil! keepj norm! " . l:startCol . "\<bar>\"aP"
exe "keepj " . l:lastLine
sil! keepj norm! "_dG
exe "keepj " . l:startLine
exe "sil! keepj norm! " . l:startCol . "\<bar>"
```

이 줄:

```
sil! keepj norm! VGg@
```

`VG`는 현재 줄부터 파일 끝까지 줄 비주얼 모드로 시각적으로 하이라이트합니다. 따라서 여기서는 세 개의 'cake' 텍스트 블록을 줄 단위 하이라이트로 하이라이트하고 있습니다(블록 대 줄 구분을 기억하세요). 처음 세 개의 "cake" 텍스트를 붙여넣었을 때 블록으로 붙여넣었다는 점에 유의하세요. 이제 줄로 하이라이트하고 있습니다. 겉보기에는 같아 보일 수 있지만 내부적으로 Vim은 텍스트 블록을 붙여넣는 것과 텍스트 줄을 붙여넣는 것의 차이를 압니다.

```
cake
cake
cake
```

`g@`는 함수 연산자이므로, 본질적으로 자신을 재귀적으로 호출하는 것입니다. 하지만 왜 그럴까요? 이것이 무엇을 성취할까요?

`g@`를 재귀적으로 호출하고 3개의 줄(V를 실행한 후에는 블록이 아닌 줄이 됨)의 'cake' 텍스트를 모두 전달하여 코드의 다른 부분에서 처리되도록 하고 있습니다(나중에 이에 대해 다룰 것입니다). `g@`를 실행한 결과는 적절하게 titlecase가 적용된 세 줄의 텍스트입니다:

```
Cake
Cake
Cake
```

다음 줄:

```
exe "keepj norm! 0\<c-v>G$h\"ad"
```

이것은 줄의 시작으로 이동(`0`), 블록 비주얼 하이라이트를 사용하여 마지막 줄과 해당 줄의 마지막 문자로 이동(`<c-v>G$`)하는 일반 모드 명령어를 실행합니다. `h`는 커서를 조정하기 위한 것입니다(`$`를 수행할 때 Vim은 오른쪽으로 한 줄 더 이동함). 마지막으로, 하이라이트된 텍스트를 삭제하고 레지스터 a에 저장합니다(`"ad`).

다음 줄:

```
exe "keepj " . l:startLine
```

커서를 `startLine`이 있던 곳으로 다시 이동합니다.

다음:

```
exe "sil! keepj norm! " . l:startCol . "\<bar>\"aP"
```

`startLine` 위치에 있으면서, 이제 `startCol`로 표시된 열로 점프합니다. `\<bar>\`는 막대 `|` 모션입니다. Vim의 막대 모션은 커서를 n번째 열로 이동합니다(예를 들어 `startCol`이 4였다고 가정해 봅시다. `4|`를 실행하면 커서가 4번째 열 위치로 점프합니다). `startCol`은 titlecase로 만들고 싶었던 텍스트의 열 위치를 저장한 곳이라는 것을 기억하세요. 마지막으로, `"aP`는 레지스터 a에 저장된 텍스트를 붙여넣습니다. 이것은 텍스트를 이전에 삭제된 곳으로 다시 되돌려 놓습니다.

다음 4줄을 봅시다:

```
exe "keepj " . l:lastLine
sil! keepj norm! "_dG
exe "keepj " . l:startLine
exe "sil! keepj norm! " . l:startCol . "\<bar>"
```

`exe "keepj " . l:lastLine`은 커서를 이전의 `lastLine` 위치로 다시 이동합니다. `sil! keepj norm! "_dG`는 블랙홀 레지스터(`"_dG`)를 사용하여 생성된 추가 공백을 삭제하여 이름 없는 레지스터를 깨끗하게 유지합니다. `exe "keepj " . l:startLine`은 커서를 `startLine`으로 다시 이동합니다. 마지막으로, `exe "sil! keepj norm! " . l:startCol . "\<bar>"`는 커서를 `startCol` 열로 이동합니다.

이것들은 모두 Vim에서 수동으로 할 수 있었던 작업들입니다. 그러나 이러한 작업들을 재사용 가능한 함수로 바꾸는 이점은 titlecase가 필요할 때마다 30줄 이상의 지침을 실행하지 않아도 된다는 것입니다. 여기서 얻을 수 있는 교훈은 Vim에서 수동으로 할 수 있는 모든 것은 재사용 가능한 함수, 즉 플러그인으로 바꿀 수 있다는 것입니다!

다음은 그것이 어떻게 보일지에 대한 것입니다.

주어진 텍스트:

```
pancake for breakfast
pancake for lunch
pancake for dinner

... some text
```

먼저, 블록 단위로 시각적으로 하이라이트합니다:

```
pan[cake] for breakfast
pan[cake] for lunch
pan[cake] for dinner

... some text
```

그런 다음 삭제하고 해당 텍스트를 레지스터 a에 저장합니다:

```
pan for breakfast
pan for lunch
pan for dinner

... some text
```

그런 다음 파일 맨 아래에 붙여넣습니다:

```
pan for breakfast
pan for lunch
pan for dinner

... some text
cake
cake
cake
```

그런 다음 대문자로 만듭니다:

```
pan for breakfast
pan for lunch
pan for dinner

... some text
Cake
Cake
Cake
```

마지막으로, 대문자로 만든 텍스트를 다시 넣습니다:

```
panCake for breakfast
panCake for lunch
panCake for dinner

... some text
```

## 줄 및 문자 작업 처리하기

아직 끝나지 않았습니다. 블록 텍스트에 `gt`를 실행할 때의 극단적인 경우만 다루었습니다. 여전히 'line' 및 'char' 작업을 처리해야 합니다. 이것이 어떻게 수행되는지 보기 위해 `else` 코드를 살펴보겠습니다.

코드는 다음과 같습니다:

```
if a:type ==# "block"
  # ...
else
  let l:titlecased = substitute(@@, l:WORD_PATTERN, l:UPCASE_REPLACEMENT, 'g')
  let l:titlecased = s:capitalizeFirstWord(l:titlecased)
  call setreg('"', l:titlecased)
  let l:subcommands = #{line: "'[V']p", char: "`[v`]p", block: "`[\<c-v>`]p"}
  silent execute "noautocmd keepjumps normal! " .. get(l:subcommands, a:type, "")
  exe "keepj " . l:startLine
  exe "sil! keepj norm! " . l:startCol . "\<bar>"
endif
```

줄 단위로 살펴보겠습니다. 이 플러그인의 비법은 실제로 이 줄에 있습니다:

```
let l:titlecased = substitute(@@, l:WORD_PATTERN, l:UPCASE_REPLACEMENT, 'g')
```

`@@`는 titlecase로 만들 이름 없는 레지스터의 텍스트를 포함합니다. `l:WORD_PATTERN`은 개별 키워드 일치입니다. `l:UPCASE_REPLACEMENT`는 `capitalize()` 명령어 호출입니다(나중에 보게 될 것입니다). `'g'`는 substitute 명령어가 첫 단어뿐만 아니라 주어진 모든 단어를 대체하도록 지시하는 전역 플래그입니다.

다음 줄:

```
let l:titlecased = s:capitalizeFirstWord(l:titlecased)
```

이것은 첫 단어가 항상 대문자로 표시되도록 보장합니다. "an apple a day keeps the doctor away"와 같은 구문이 있는 경우, 첫 단어인 "an"이 특수 단어이므로 substitute 명령어가 대문자로 만들지 않습니다. 어떤 경우에도 첫 문자를 항상 대문자로 만드는 메서드가 필요합니다. 이 함수는 바로 그 역할을 합니다(나중에 이 함수의 세부 정보를 보게 될 것입니다). 이러한 대문자화 방법의 결과는 지역 변수 `l:titlecased`에 저장됩니다.

다음 줄:

```
call setreg('"', l:titlecased)
```

이것은 대문자로 만든 문자열을 이름 없는 레지스터(`"`)에 넣습니다.

다음, 다음 두 줄:

```
let l:subcommands = #{line: "'[V']p", char: "`[v`]p", block: "`[\<c-v>`]p"}
silent execute "noautocmd keepjumps normal! " .. get(l:subcommands, a:type, "")
```

어, 익숙해 보이네요! 이전에 `l:commands`와 비슷한 패턴을 본 적이 있습니다. 복사 대신 여기서는 붙여넣기(`p`)를 사용합니다. 복습을 위해 `l:commands`에 대해 설명했던 이전 섹션을 확인하세요.

마지막으로, 이 두 줄:

```
exe "keepj " . l:startLine
exe "sil! keepj norm! " . l:startCol . "\<bar>"
```

커서를 시작했던 줄과 열로 다시 이동합니다. 그게 다입니다!

요약하자면, 위의 substitute 메서드는 주어진 텍스트를 대문자로 만들고 특수 단어를 건너뛸 만큼 똑똑합니다(나중에 자세히 설명). titlecase가 적용된 문자열이 있으면 이름 없는 레지스터에 저장합니다. 그런 다음 이전에 `g@`를 실행했던 것과 똑같은 텍스트를 시각적으로 하이라이트한 다음 이름 없는 레지스터에서 붙여넣습니다(이것은 titlecase가 아닌 텍스트를 titlecase 버전으로 효과적으로 대체합니다). 마지막으로, 커서를 시작했던 곳으로 다시 이동합니다.

## 정리

기술적으로는 끝났습니다. 이제 텍스트가 titlecase가 되었습니다. 남은 일은 레지스터와 설정을 복원하는 것뿐입니다.

```
call setreg('"', l:reg_save)
call setpos("'<", l:visual_marks_save[0])
call setpos("'>", l:visual_marks_save[1])
let &clipboard = l:cb_save
let &selection = l:sel_save
```

이것들은 다음을 복원합니다:
- 이름 없는 레지스터.
- `<` 및 `>` 마크.
- `'clipboard'` 및 `'selection'` 옵션.

휴, 끝났습니다. 긴 함수였습니다. 더 작은 함수로 나누어 함수를 더 짧게 만들 수도 있었지만, 지금은 그것으로 충분할 것입니다. 이제 capitalize 함수에 대해 간략하게 살펴보겠습니다.

## Capitalize 함수

이 섹션에서는 `s:capitalize()` 함수에 대해 살펴보겠습니다. 함수는 다음과 같습니다:

```
function! s:capitalize(string)
    if(toupper(a:string) ==# a:string && a:string != 'A')
        return a:string
    endif

    let l:str = tolower(a:string)
    let l:exclusions = '^\(a\|an\|and\|at\|but\|by\|en\|for\|in\|nor\|of\|off\|on\|or\|out\|per\|so\|the\|to\|up\|yet\|v\.?\|vs\.?\|via\)$'
    if (match(l:str, l:exclusions) >= 0) || (index(s:local_exclusion_list, l:str) >= 0)
      return l:str
    endif

    return toupper(l:str[0]) . l:str[1:]
endfunction
```

`capitalize()` 함수의 인수 `a:string`은 `g@` 연산자에 의해 전달되는 개별 단어라는 것을 기억하세요. 따라서 "pancake for breakfast" 텍스트에 `gt`를 실행하면 `ToTitle`은 "pancake"에 대해 한 번, "for"에 대해 한 번, "breakfast"에 대해 한 번, 총 *세 번* `capitalize(string)`을 호출합니다.

함수의 첫 번째 부분은 다음과 같습니다:

```
if(toupper(a:string) ==# a:string && a:string != 'A')
  return a:string
endif
```

첫 번째 조건(`toupper(a:string) ==# a:string`)은 인수의 대문자 버전이 문자열과 같은지, 그리고 문자열 자체가 "A"인지 확인합니다. 이것이 참이면 해당 문자열을 반환합니다. 이것은 주어진 단어가 이미 완전히 대문자인 경우 약어라는 가정에 기반합니다. 예를 들어, "CEO"라는 단어는 그렇지 않으면 "Ceo"로 변환될 것입니다. 흠, 당신의 CEO는 행복하지 않을 것입니다. 따라서 완전히 대문자인 단어는 그대로 두는 것이 가장 좋습니다. 두 번째 조건 `a:string != 'A'`는 대문자 "A" 문자에 대한 극단적인 경우를 다룹니다. `a:string`이 이미 대문자 "A"인 경우, `toupper(a:string) ==# a:string` 테스트를 우연히 통과했을 것입니다. "a"는 영어에서 부정관사이므로 소문자로 표기해야 합니다.

다음 부분은 문자열을 소문자로 강제합니다:

```
let l:str = tolower(a:string)
```

다음 부분은 모든 단어 제외 목록의 정규식입니다. https://titlecaseconverter.com/rules/ 에서 가져왔습니다:

```
let l:exclusions = '^\(a\|an\|and\|at\|but\|by\|en\|for\|in\|nor\|of\|off\|on\|or\|out\|per\|so\|the\|to\|up\|yet\|v\.?\|vs\.?\|via\)$'
```

다음 부분:

```
if (match(l:str, l:exclusions) >= 0) || (index(s:local_exclusion_list, l:str) >= 0)
  return l:str
endif
```

먼저, 문자열이 제외된 단어 목록(`l:exclusions`)의 일부인지 확인합니다. 그렇다면 대문자로 만들지 않습니다. 그런 다음 문자열이 로컬 제외 목록(`s:local_exclusion_list`)의 일부인지 확인합니다. 이 제외 목록은 사용자가 vimrc에 추가할 수 있는 사용자 정의 목록입니다(사용자가 특수 단어에 대한 추가 요구 사항이 있는 경우).

마지막 부분은 단어의 대문자 버전을 반환합니다. 첫 문자는 대문자로 표시되고 나머지는 그대로 유지됩니다.

```
return toupper(l:str[0]) . l:str[1:]
```

두 번째 capitalize 함수를 살펴보겠습니다. 함수는 다음과 같습니다:

```
function! s:capitalizeFirstWord(string)
  if (a:string =~ "\n")
    let l:lineArr = trim(a:string)->split('\n')
    let l:lineArr = map(l:lineArr, 'toupper(v:val[0]) . v:val[1:]')
    return l:lineArr->join("\n")
  endif
  return toupper(a:string[0]) . a:string[1:]
endfunction
```

이 함수는 "an apple a day keeps the doctor away"와 같이 제외된 단어로 시작하는 문장이 있는 경우의 극단적인 경우를 처리하기 위해 만들어졌습니다. 영어의 대문자 규칙에 따라, 문장의 모든 첫 단어는 특수 단어인지 여부에 관계없이 대문자로 표기해야 합니다. `substitute()` 명령어만으로는 문장의 "an"이 소문자로 표기될 것입니다. 첫 문자를 강제로 대문자로 만들어야 합니다.

이 `capitalizeFirstWord` 함수에서 `a:string` 인수는 `capitalize` 함수 내부의 `a:string`과 같은 개별 단어가 아니라 전체 텍스트입니다. 따라서 "pancake for breakfast"가 있는 경우 `a:string`의 값은 "pancake for breakfast"입니다. 전체 텍스트에 대해 `capitalizeFirstWord`를 한 번만 실행합니다.

주의해야 할 한 가지 시나리오는 `"an apple a day\nkeeps the doctor away"`와 같은 여러 줄 문자열이 있는 경우입니다. 모든 줄의 첫 문자를 대문자로 만들고 싶습니다. 줄 바꿈이 없으면 첫 문자만 대문자로 만듭니다.

```
return toupper(a:string[0]) . a:string[1:]
```

줄 바꿈이 있는 경우 각 줄의 첫 문자를 모두 대문자로 만들어야 하므로 줄 바꿈으로 구분된 배열로 분할합니다:

```
let l:lineArr = trim(a:string)->split('\n')
```

그런 다음 배열의 각 요소를 매핑하고 각 요소의 첫 단어를 대문자로 만듭니다:

```
let l:lineArr = map(l:lineArr, 'toupper(v:val[0]) . v:val[1:]')
```

마지막으로 배열 요소를 함께 결합합니다:

```
return l:lineArr->join("\n")
```

그리고 끝났습니다!

## 문서

저장소의 두 번째 디렉토리는 `docs/` 디렉토리입니다. 플러그인에 철저한 문서를 제공하는 것이 좋습니다. 이 섹션에서는 자신만의 플러그인 문서를 만드는 방법에 대해 간략하게 설명하겠습니다.

`docs/` 디렉토리는 Vim의 특수 런타임 경로 중 하나입니다. Vim은 `docs/` 내의 모든 파일을 읽으므로 특수 키워드를 검색하고 해당 키워드가 `docs/` 디렉토리의 파일 중 하나에서 발견되면 도움말 페이지에 표시합니다. 여기에는 `totitle.txt`가 있습니다. 플러그인 이름이기 때문에 그렇게 이름 지었지만, 원하는 대로 이름을 지정할 수 있습니다.

Vim 문서 파일은 핵심적으로 txt 파일입니다. 일반 txt 파일과 Vim 도움말 파일의 차이점은 후자가 특수 "도움말" 구문을 사용한다는 것입니다. 하지만 먼저 Vim에게 텍스트 파일 유형이 아닌 `help` 파일 유형으로 처리하도록 알려야 합니다. Vim에게 이 `totitle.txt`를 *도움말* 파일로 해석하도록 하려면 `:set ft=help`를 실행하세요(`:h 'filetype'` 참조). 참고로, Vim에게 이 `totitle.txt`를 *일반* txt 파일로 해석하도록 하려면 `:set ft=txt`를 실행하세요.

### 도움말 파일 특수 구문

키워드를 검색 가능하게 만들려면 해당 키워드를 별표로 둘러싸세요. 사용자가 `:h totitle`을 검색할 때 `totitle` 키워드를 검색 가능하게 만들려면 도움말 파일에 `*totitle*`로 작성하세요.

예를 들어, 제 목차 상단에 다음 줄이 있습니다:

```
TABLE OF CONTENTS                                     *totitle*  *totitle-toc*

// 더 많은 목차 내용
```

목차 섹션을 표시하기 위해 `*totitle*`과 `*totitle-toc*` 두 개의 키워드를 사용했습니다. 원하는 만큼 많은 키워드를 사용할 수 있습니다. 이는 `:h totitle` 또는 `:h totitle-toc`를 검색할 때마다 Vim이 이 위치로 이동한다는 것을 의미합니다.

다음은 파일 아래 어딘가에 있는 또 다른 예입니다:

```
2. Usage                                                       *totitle-usage*

// 사용법
```

`:h totitle-usage`를 검색하면 Vim이 이 섹션으로 이동합니다.

막대 구문 `|`으로 키워드를 둘러싸서 도움말 파일의 다른 섹션을 참조하는 내부 링크를 사용할 수도 있습니다. 목차 섹션에서는 `|totitle-intro|`, `|totitle-usage|` 등과 같이 막대로 둘러싸인 키워드를 볼 수 있습니다.

```
TABLE OF CONTENTS                                     *totitle*  *totitle-toc*

    1. Intro ........................... |totitle-intro|
    2. Usage ........................... |totitle-usage|
    3. Words to capitalize ............. |totitle-words|
    4. Operator ........................ |totitle-operator|
    5. Key-binding ..................... |totitle-keybinding|
    6. Bugs ............................ |totitle-bug-report|
    7. Contributing .................... |totitle-contributing|
    8. Credits ......................... |totitle-credits|

```
이렇게 하면 정의로 점프할 수 있습니다. `|totitle-intro|` 어딘가에 커서를 놓고 `Ctrl-]`를 누르면 Vim이 해당 단어의 정의로 점프합니다. 이 경우 `*totitle-intro*` 위치로 점프합니다. 이것이 도움말 문서에서 다른 키워드로 링크하는 방법입니다.

Vim에서 문서 파일을 작성하는 데 옳고 그른 방법은 없습니다. 다른 저자의 다른 플러그인을 보면 많은 사람들이 다른 형식을 사용합니다. 요점은 사용자를 위해 이해하기 쉬운 도움말 문서를 만드는 것입니다.

마지막으로, 로컬에서 자신만의 플러그인을 작성하고 문서 페이지를 테스트하고 싶다면 `~/.vim/docs/` 내에 txt 파일을 추가하는 것만으로는 키워드를 자동으로 검색 가능하게 만들 수 없습니다. Vim에게 문서 페이지를 추가하도록 지시해야 합니다. helptags 명령어를 실행하세요: `:helptags ~/.vim/doc`를 실행하여 새 태그 파일을 만듭니다. 이제 키워드를 검색할 수 있습니다.

## 결론

끝까지 오셨습니다! 이 챕터는 모든 Vimscript 챕터의 종합입니다. 여기서 지금까지 배운 것을 마침내 실천에 옮기게 됩니다. 이것을 읽고 Vim 플러그인을 만드는 방법뿐만 아니라 자신만의 플러그인을 만들도록 격려받았기를 바랍니다.

같은 일련의 작업을 여러 번 반복하는 자신을 발견할 때마다 자신만의 것을 만들어보세요! 바퀴를 재발명하지 말라는 말이 있습니다. 그러나 학습을 위해 바퀴를 재발명하는 것이 유익할 수 있다고 생각합니다. 다른 사람들의 플러그인을 읽으세요. 그것들을 재현하세요. 그것들로부터 배우세요. 자신만의 것을 작성하세요! 누가 알겠습니까, 이것을 읽고 다음 멋진, 초인기 플러그인을 작성할지도 모릅니다. 아마도 당신이 다음 전설적인 Tim Pope가 될지도 모릅니다. 그렇게 되면 알려주세요!