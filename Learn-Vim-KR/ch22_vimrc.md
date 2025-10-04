# Ch22. Vimrc

이전 장에서는 Vim을 사용하는 방법을 배웠습니다. 이 장에서는 vimrc를 구성하고 설정하는 방법을 배웁니다.

## Vim이 Vimrc를 찾는 방법

vimrc에 대한 일반적인 지혜는 홈 디렉토리 `~/.vimrc`에 `.vimrc` 점 파일을 추가하는 것입니다(OS에 따라 다를 수 있습니다).

배후에서 Vim은 vimrc 파일을 찾기 위해 여러 곳을 살펴봅니다. 다음은 Vim이 확인하는 장소입니다:
- `$VIMINIT`
- `$HOME/.vimrc`
- `$HOME/.vim/vimrc`
- `$EXINIT`
- `$HOME/.exrc`
- `$VIMRUNTIME/defaults.vim`

Vim을 시작하면, 위 여섯 위치를 순서대로 vimrc 파일을 확인합니다. 처음 발견된 vimrc 파일이 사용되고 나머지는 무시됩니다.

먼저 Vim은 `$VIMINIT`를 찾습니다. 거기에 아무것도 없으면 Vim은 `$HOME/.vimrc`를 확인합니다. 거기에 아무것도 없으면 Vim은 `$HOME/.vim/vimrc`를 확인합니다. Vim이 그것을 찾으면, 검색을 중단하고 `$HOME/.vim/vimrc`를 사용합니다.

첫 번째 위치인 `$VIMINIT`는 환경 변수입니다. 기본적으로 정의되어 있지 않습니다. `~/dotfiles/testvimrc`를 `$VIMINIT` 값으로 사용하고 싶다면, 해당 vimrc의 경로를 포함하는 환경 변수를 만들 수 있습니다. `export VIMINIT='let $MYVIMRC="$HOME/dotfiles/testvimrc" | source $MYVIMRC'`를 실행한 후, Vim은 이제 `~/dotfiles/testvimrc`를 vimrc 파일로 사용합니다.

두 번째 위치인 `$HOME/.vimrc`는 많은 Vim 사용자들이 사용하는 일반적인 경로입니다. 많은 경우 `$HOME`은 홈 디렉토리(`~`)입니다. `~/.vimrc` 파일이 있다면, Vim은 이것을 vimrc 파일로 사용합니다.

세 번째인 `$HOME/.vim/vimrc`는 `~/.vim` 디렉토리 내에 위치합니다. 플러그인, 사용자 지정 스크립트 또는 뷰 파일을 위해 이미 `~/.vim` 디렉토리가 있을 수 있습니다. vimrc 파일 이름에 점이 없다는 점에 유의하세요 (`$HOME/.vim/.vimrc`는 작동하지 않지만, `$HOME/.vim/vimrc`는 작동합니다).

네 번째인 `$EXINIT`는 `$VIMINIT`와 유사하게 작동합니다.

다섯 번째인 `$HOME/.exrc`는 `$HOME/.vimrc`와 유사하게 작동합니다.

여섯 번째인 `$VIMRUNTIME/defaults.vim`은 Vim 빌드와 함께 제공되는 기본 vimrc입니다. 제 경우, Homebrew를 사용하여 Vim 8.2를 설치했으므로 제 경로는 (`/usr/local/share/vim/vim82`)입니다. Vim이 이전 여섯 개의 vimrc 파일을 찾지 못하면 이 파일을 사용합니다.

이 장의 나머지 부분에서는 vimrc가 `~/.vimrc` 경로를 사용한다고 가정합니다.

## 내 Vimrc에 무엇을 넣어야 할까?

제가 시작할 때 던졌던 질문은 "내 vimrc에 무엇을 넣어야 할까?"였습니다.

답은 "원하는 모든 것"입니다. 다른 사람의 vimrc를 복사-붙여넣기하고 싶은 유혹은 현실적이지만, 저항해야 합니다. 다른 사람의 vimrc를 사용하기를 고집한다면, 그것이 무엇을 하는지, 왜 그리고 어떻게 그/그녀가 그것을 사용하는지, 그리고 가장 중요하게는, 그것이 당신에게 관련이 있는지 확인하세요. 누군가 사용한다고 해서 당신도 사용할 것이라는 의미는 아닙니다.

## 기본 Vimrc 내용

간단히 말해서, vimrc는 다음의 모음입니다:
- 플러그인
- 설정
- 사용자 지정 함수
- 사용자 지정 명령어
- 매핑

위에 언급되지 않은 다른 것들도 있지만, 일반적으로 이것이 대부분의 사용 사례를 다룹니다.

### 플러그인

이전 장에서 [fzf.vim](https://github.com/junegunn/fzf.vim), [vim-mundo](https://github.com/simnalamburt/vim-mundo), [vim-fugitive](https://github.com/tpope/vim-fugitive)와 같은 다른 플러그인들을 언급했습니다.

10년 전에는 플러그인 관리가 악몽이었습니다. 하지만, 현대적인 플러그인 관리자의 등장으로, 이제 플러그인 설치는 몇 초 만에 완료될 수 있습니다. 저는 현재 [vim-plug](https://github.com/junegunn/vim-plug)를 플러그인 관리자로 사용하고 있으므로, 이 섹션에서 그것을 사용할 것입니다. 개념은 다른 인기 있는 플러그인 관리자와 유사해야 합니다. 다음과 같은 다른 것들도 확인해보시기를 강력히 권장합니다:
- [vundle.vim](https://github.com/VundleVim/Vundle.vim)
- [vim-pathogen](https://github.com/tpope/vim-pathogen)
- [dein.vim](https://github.com/Shougo/dein.vim)

위에 나열된 것보다 더 많은 플러그인 관리자가 있으니, 자유롭게 둘러보세요. vim-plug를 설치하려면, 유닉스 기기가 있다면 다음을 실행하세요:

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

새 플러그인을 추가하려면, `call plug#begin()`과 `call plug#end()` 줄 사이에 플러그인 이름(`Plug 'github-username/repository-name'`)을 넣으세요. `emmet-vim`과 `nerdtree`를 설치하고 싶다면, vimrc에 다음 스니펫을 넣으세요:

```
call plug#begin('~/.vim/plugged')
  Plug 'mattn/emmet-vim'
  Plug 'preservim/nerdtree'
call plug#end()
```

변경 사항을 저장하고, 소싱하고(`:source %`), `:PlugInstall`을 실행하여 설치하세요.

나중에 사용하지 않는 플러그인을 제거해야 한다면, `call` 블록에서 플러그인 이름을 제거하고, 저장하고 소싱한 다음, `:PlugClean` 명령어를 실행하여 컴퓨터에서 제거하기만 하면 됩니다.

Vim 8에는 자체 내장 패키지 관리자가 있습니다. 더 많은 정보는 `:h packages`를 확인하세요. 다음 장에서 사용하는 방법을 보여드리겠습니다.

### 설정

어떤 vimrc에서든 많은 `set` 옵션을 보는 것은 일반적입니다. 커맨드-라인 모드에서 set 명령어를 실행하면 영구적이지 않습니다. Vim을 닫으면 잃게 됩니다. 예를 들어, Vim을 실행할 때마다 커맨드-라인 모드에서 `:set relativenumber number`를 실행하는 대신, vimrc 안에 이것들을 넣을 수 있습니다:

```
set relativenumber number
```

일부 설정은 `set tabstop=2`와 같이 값을 전달해야 합니다. 각 설정이 어떤 종류의 값을 받는지 배우려면 각 설정의 도움말 페이지를 확인하세요.

`set` 대신 `let`을 사용할 수도 있습니다(`&`를 앞에 붙여야 함). `let`을 사용하면 표현식을 값으로 사용할 수 있습니다. 예를 들어, 경로가 존재하는 경우에만 `'dictionary'` 옵션을 경로로 설정하려면:

```
let s:english_dict = "/usr/share/dict/words"

if filereadable(s:english_dict)
  let &dictionary=s:english_dict
endif
```

나중 장에서 Vimscript 할당 및 조건문에 대해 배울 것입니다.

Vim의 모든 가능한 옵션 목록은 `:h E355`를 확인하세요.

### 사용자 지정 함수

Vimrc는 사용자 지정 함수를 위한 좋은 장소입니다. 나중 장에서 자신만의 Vimscript 함수를 작성하는 방법을 배울 것입니다.

### 사용자 지정 명령어

`command`로 사용자 지정 커맨드-라인 명령어를 만들 수 있습니다.

오늘 날짜를 표시하는 기본 명령어 `GimmeDate`를 만들려면:

```
:command! GimmeDate echo call("strftime", ["%F"])
```

`:GimmeDate`를 실행하면, Vim은 "2021-01-1"과 같은 날짜를 표시합니다.

입력이 있는 기본 명령어를 만들려면, `<args>`를 사용할 수 있습니다. `GimmeDate`에 특정 시간/날짜 형식을 전달하고 싶다면:

```
:command! GimmeDate echo call("strftime", [<args>])

:GimmeDate "%F"
" 2020-01-01

:GimmeDate "%H:%M"
" 11:30
```

인수의 수를 제한하고 싶다면, `-nargs` 플래그를 전달할 수 있습니다. 인수를 전달하지 않으려면 `-nargs=0`을, 하나의 인수를 전달하려면 `-nargs=1`을, 적어도 하나의 인수를 전달하려면 `-nargs=+`를, 임의의 수의 인수를 전달하려면 `-nargs=*`를, 0 또는 하나의 인수를 전달하려면 `-nargs=?`를 사용하세요. n번째 인수를 전달하고 싶다면 `-nargs=n`을 사용하세요 (여기서 `n`은 임의의 정수).

`<args>`에는 두 가지 변형이 있습니다: `<f-args>`와 `<q-args>`. 전자는 Vimscript 함수에 인수를 전달하는 데 사용됩니다. 후자는 사용자 입력을 자동으로 문자열로 변환하는 데 사용됩니다.

`args` 사용하기:

```
:command! -nargs=1 Hello echo "Hello " . <args>
:Hello "Iggy"
" 'Hello Iggy' 반환

:Hello Iggy
" 정의되지 않은 변수 오류
```

`q-args` 사용하기:

```
:command! -nargs=1 Hello echo "Hello " . <q-args>
:Hello Iggy
" 'Hello Iggy' 반환
```

`f-args` 사용하기:

```
:function! PrintHello(person1, person2)
:  echo "Hello " . a:person1 . " and " . a:person2
:endfunction

:command! -nargs=* Hello call PrintHello(<f-args>)

:Hello Iggy1 Iggy2
" "Hello Iggy1 and Iggy2" 반환
```

위 함수들은 Vimscript 함수 장에 도달하면 훨씬 더 이해하기 쉬울 것입니다.

command와 args에 대해 더 배우려면 `:h command`와 `:args`를 확인하세요.

### 맵

반복적으로 동일한 복잡한 작업을 수행하고 있다면, 해당 작업에 대한 매핑을 만들어야 한다는 좋은 지표입니다.

예를 들어, 제 vimrc에는 다음과 같은 두 가지 매핑이 있습니다:

```
nnoremap <silent> <C-f> :GFiles<CR>

nnoremap <Leader>tn :call ToggleNumber()<CR>
```

첫 번째에서는, `Ctrl-F`를 [fzf.vim](https://github.com/junegunn/fzf.vim) 플러그인의 `:Gfiles` 명령어(Git 파일을 빠르게 검색)에 매핑합니다. 두 번째에서는, `<Leader>tn`을 사용자 지정 함수 `ToggleNumber`(`norelativenumber`와 `relativenumber` 옵션 토글)를 호출하도록 매핑합니다. `Ctrl-F` 매핑은 Vim의 기본 페이지 스크롤을 덮어씁니다. 매핑이 충돌하면 Vim 컨트롤을 덮어씁니다. 저는 그 기능을 거의 사용하지 않았기 때문에, 덮어써도 안전하다고 결정했습니다.

그런데, `<Leader>tn`의 이 "leader" 키는 무엇일까요?

Vim에는 매핑을 돕는 리더 키가 있습니다. 예를 들어, `<Leader>tn`을 `ToggleNumber()` 함수를 실행하도록 매핑했습니다. 리더 키가 없다면, `tn`을 사용하겠지만, Vim에는 이미 `t`("till" 검색 탐색)가 있습니다. 리더 키를 사용하면, 리더로 할당된 키를 누른 다음 `tn`을 눌러 기존 명령어와 간섭하지 않고 사용할 수 있습니다. 리더 키는 매핑 콤보를 시작하도록 설정할 수 있는 키입니다. 기본적으로 Vim은 백슬래시를 리더 키로 사용합니다(따라서 `<Leader>tn`은 "백슬래시-t-n"이 됨).

저는 개인적으로 백슬래시 기본값 대신 `<Space>`를 리더 키로 사용하는 것을 선호합니다. 리더 키를 변경하려면, vimrc에 다음을 추가하세요:

```
let mapleader = "\<space>"
```

위에서 사용된 `nnoremap` 명령어는 세 부분으로 나눌 수 있습니다:
- `n`은 일반 모드를 나타냅니다.
- `nore`는 비-재귀적을 의미합니다.
- `map`은 map 명령어입니다.

최소한, `nnoremap` 대신 `nmap`을 사용할 수 있었습니다 (`nmap <silent> <C-f> :Gfiles<CR>`). 하지만, 잠재적인 무한 루프를 피하기 위해 비-재귀적 변형을 사용하는 것이 좋은 습관입니다.

재귀적으로 매핑하지 않으면 발생할 수 있는 일은 다음과 같습니다. `B`에 매핑을 추가하여 줄 끝에 세미콜론을 추가한 다음, 한 WORD 뒤로 가고 싶다고 가정해 봅시다(Vim에서 `B`는 한 WORD 뒤로 가는 일반 모드 탐색 키임을 상기하세요).

```
nmap B A;<esc>B
```

`B`를 누르면... 오 이런! Vim이 `;`를 제어할 수 없이 추가합니다(`Ctrl-C`로 중단). 왜 그런 일이 일어났을까요? 매핑 `A;<esc>B`에서, `B`는 Vim의 기본 `B` 함수(한 WORD 뒤로 가기)를 참조하는 것이 아니라, 매핑된 함수를 참조하기 때문입니다. 실제로는 다음과 같습니다:

```
A;<esc>A;<esc>A;<esc>A;esc>...
```

이 문제를 해결하려면, 비-재귀적 맵을 추가해야 합니다:

```
nnoremap B A;<esc>B
```

이제 `B`를 다시 호출해 보세요. 이번에는 성공적으로 줄 끝에 `;`를 추가하고 한 WORD 뒤로 갑니다. 이 매핑의 `B`는 Vim의 원래 `B` 기능을 나타냅니다.

Vim에는 다른 모드에 대한 다른 맵이 있습니다. `jk`를 누를 때 삽입 모드를 종료하는 삽입 모드용 맵을 만들고 싶다면:

```
inoremap jk <esc>
```

다른 맵 모드는 다음과 같습니다: `map` (일반, 비주얼, 선택, 및 연산자-보류), `vmap` (비주얼 및 선택), `smap` (선택), `xmap` (비주얼), `omap` (연산자-보류), `map!` (삽입 및 커맨드-라인), `lmap` (삽입, 커맨드-라인, Lang-arg), `cmap` (커맨드-라인), `tmap` (터미널-작업). 자세히 다루지는 않겠습니다. 더 배우려면 `:h map.txt`를 확인하세요.

가장 직관적이고, 일관성 있고, 기억하기 쉬운 맵을 만드세요.

## Vimrc 정리하기

시간이 지남에 따라, vimrc는 커지고 복잡해질 것입니다. vimrc를 깔끔하게 유지하는 두 가지 방법이 있습니다:
- vimrc를 여러 파일로 분할합니다.
- vimrc 파일을 접습니다.

### Vimrc 분할하기

Vim의 `source` 명령어를 사용하여 vimrc를 여러 파일로 분할할 수 있습니다. 이 명령어는 주어진 파일 인수에서 커맨드-라인 명령어를 읽습니다.

`~/.vim` 디렉토리 안에 파일을 만들고 이름을 `/settings`(`~/.vim/settings`)로 지정합시다. 이름 자체는 임의적이며 원하는 대로 이름을 지정할 수 있습니다.

네 가지 구성 요소로 분할할 것입니다:
- 타사 플러그인 (`~/.vim/settings/plugins.vim`).
- 일반 설정 (`~/.vim/settings/configs.vim`).
- 사용자 지정 함수 (`~/.vim/settings/functions.vim`).
- 키 매핑 (`~/.vim/settings/mappings.vim`).

`~/.vimrc` 내부:

```
source $HOME/.vim/settings/plugins.vim
source $HOME/.vim/settings/configs.vim
source $HOME/.vim/settings/functions.vim
source $HOME/.vim/settings/mappings.vim
```

경로 아래에 커서를 놓고 `gf`를 눌러 이 파일들을 편집할 수 있습니다.

`~/.vim/settings/plugins.vim` 내부:

```
call plug#begin('~/.vim/plugged')
  Plug 'mattn/emmet-vim'
  Plug 'preservim/nerdtree'
call plug#end()
```

`~/.vim/settings/configs.vim` 내부:

```
set nocompatible
set relativenumber
set number
```

`~/.vim/settings/functions.vim` 내부:

```
function! ToggleNumber()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc
```

`~/.vim/settings/mappings.vim` 내부:

```
inoremap jk <esc>
nnoremap <silent> <C-f> :GFiles<CR>
nnoremap <Leader>tn :call ToggleNumber()<CR>
```

vimrc는 평소처럼 작동하지만, 이제 네 줄 길이밖에 되지 않습니다!

이 설정으로, 어디로 가야 할지 쉽게 알 수 있습니다. 더 많은 매핑을 추가해야 한다면, `/mappings.vim` 파일에 추가하세요. 나중에, vimrc가 커지면 언제든지 더 많은 디렉토리를 추가할 수 있습니다. 예를 들어, 색상 구성표에 대한 설정을 만들어야 한다면, `~/.vim/settings/themes.vim`을 추가할 수 있습니다.

### 하나의 Vimrc 파일 유지하기

이식성을 위해 하나의 vimrc 파일을 유지하는 것을 선호한다면, 마커 접기를 사용하여 정리할 수 있습니다. vimrc 상단에 다음을 추가하세요:

```
" setup folds {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}
```

Vim은 현재 버퍼의 파일 유형이 무엇인지 감지할 수 있습니다 (`:set filetype?`). `vim` 파일 유형이라면, 마커 접기 방법을 사용할 수 있습니다. 마커 접기는 `{{{`와 `}}}`를 사용하여 시작 및 끝 접기를 나타낸다는 것을 상기하세요.

vimrc의 나머지 부분에 `{{{`와 `}}}` 접기를 추가하세요 (주석 처리하는 것을 잊지 마세요 `"`):

```
" setup folds {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" plugins {{{
call plug#begin('~/.vim/plugged')
  Plug 'mattn/emmet-vim'
  Plug 'preservim/nerdtree'
call plug#end()
" }}}

" configs {{{
set nocompatible
set relativenumber
set number
" }}}

" functions {{{
function! ToggleNumber()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc
" }}}

" mappings {{{
inoremap jk <esc>
nnoremap <silent> <C-f> :GFiles<CR>
nnoremap <Leader>tn :call ToggleNumber()<CR>
" }}}
```

vimrc는 다음과 같아야 합니다:

```
+-- 6 lines: setup folds -----

+-- 6 lines: plugins ---------

+-- 5 lines: configs ---------

+-- 9 lines: functions -------

+-- 5 lines: mappings --------
```

## Vimrc 및 플러그인 유무에 관계없이 Vim 실행하기

vimrc와 플러그인 없이 Vim을 실행해야 한다면, 다음을 실행하세요:

```
vim -u NONE
```

vimrc 없이 플러그인과 함께 Vim을 시작해야 한다면, 다음을 실행하세요:

```
vim -u NORC
```

vimrc와 함께 플러그인 없이 Vim을 실행해야 한다면, 다음을 실행하세요:

```
vim --noplugin
```

*다른* vimrc, 예를 들어 `~/.vimrc-backup`으로 Vim을 실행해야 한다면, 다음을 실행하세요:

```
vim -u ~/.vimrc-backup
```

`defaults.vim`만 있고 플러그인 없이 Vim을 실행해야 한다면(깨진 vimrc를 수정하는 데 유용함), 다음을 실행하세요:

```
vim --clean
```

## 현명하게 Vimrc 구성하기

Vimrc는 Vim 사용자 정의의 중요한 구성 요소입니다. vimrc를 구축하는 좋은 방법은 다른 사람들의 vimrc를 읽고 시간이 지남에 따라 점차 구축하는 것입니다. 최고의 vimrc는 개발자 X가 사용하는 것이 아니라, 당신의 사고 체계와 편집 스타일에 정확히 맞도록 맞춤화된 것입니다.