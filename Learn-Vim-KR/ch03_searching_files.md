# Ch03. 파일 검색하기

이 장의 목표는 Vim에서 빠르게 검색하는 방법에 대한 소개를 제공하는 것입니다. 빠르게 검색할 수 있는 능력은 Vim 생산성을 급상승시키는 좋은 방법입니다. 제가 파일 검색 방법을 빠르게 알아냈을 때, 저는 Vim을 풀타임으로 사용하기로 전환했습니다.

이 장은 두 부분으로 나뉩니다: 플러그인 없이 검색하는 방법과 [fzf.vim](https://github.com/junegunn/fzf.vim) 플러그인으로 검색하는 방법입니다. 시작해 봅시다!

## 파일 열고 편집하기

Vim에서 파일을 열려면 `:edit`를 사용할 수 있습니다.

```
:edit file.txt
```

`file.txt`가 존재하면 `file.txt` 버퍼를 엽니다. `file.txt`가 존재하지 않으면 `file.txt`에 대한 새 버퍼를 만듭니다.

`<Tab>`을 사용한 자동 완성은 `:edit`와 함께 작동합니다. 예를 들어, 파일이 [Rails](https://rubyonrails.org/) *a*pp *c*ontroller *u*sers controller 디렉토리 `./app/controllers/users_controllers.rb` 안에 있다면, `<Tab>`을 사용하여 용어를 빠르게 확장할 수 있습니다:

```
:edit a<Tab>c<Tab>u<Tab>
```

`:edit`는 와일드카드 인수를 허용합니다. `*`는 현재 디렉토리의 모든 파일과 일치합니다. 현재 디렉토리에서 `.yml` 확장자를 가진 파일만 찾고 있다면:

```
:edit *.yml<Tab>
```

Vim은 현재 디렉토리의 모든 `.yml` 파일 목록을 제공하여 선택할 수 있도록 합니다.

재귀적으로 검색하려면 `**`를 사용할 수 있습니다. 프로젝트에서 모든 `*.md` 파일을 찾고 싶은데 어느 디렉토리에 있는지 확실하지 않은 경우, 다음과 같이 할 수 있습니다:

```
:edit **/*.md<Tab>
```

`:edit`는 Vim의 내장 파일 탐색기인 `netrw`를 실행하는 데 사용할 수 있습니다. 그렇게 하려면 `:edit`에 파일 대신 디렉토리 인수를 제공하세요:

```
:edit .
:edit test/unit/
```

## Find로 파일 검색하기

`:find`로 파일을 찾을 수 있습니다. 예를 들어:

```
:find package.json
:find app/controllers/users_controller.rb
```

자동 완성은 `:find`와도 작동합니다:

```
:find p<Tab>                " to find package.json
:find a<Tab>c<Tab>u<Tab>    " to find app/controllers/users_controller.rb
```

`:find`가 `:edit`와 비슷해 보일 수 있습니다. 차이점은 무엇일까요?

## Find와 Path

차이점은 `:find`는 `path`에서 파일을 찾고, `:edit`는 그렇지 않다는 것입니다. `path`에 대해 조금 배워봅시다. 경로를 수정하는 방법을 배우면 `:find`는 강력한 검색 도구가 될 수 있습니다. 경로가 무엇인지 확인하려면 다음을 수행하세요:

```
:set path?
```

기본적으로 여러분의 경로는 다음과 같을 것입니다:

```
path=.,/usr/include,,
```

- `.`는 현재 열려 있는 파일의 디렉토리에서 검색하는 것을 의미합니다.
- `,`는 현재 디렉토리에서 검색하는 것을 의미합니다.
- `/usr/include`는 C 라이브러리 헤더 파일의 일반적인 디렉토리입니다.

처음 두 개는 우리의 맥락에서 중요하며 세 번째는 지금은 무시할 수 있습니다. 여기서 중요한 점은 Vim이 파일을 검색할 자신만의 경로를 수정할 수 있다는 것입니다. 프로젝트 구조가 다음과 같다고 가정해 봅시다:

```
app/
  assets/
  controllers/
    application_controller.rb
    comments_controller.rb
    users_controller.rb
    ...
```

루트 디렉토리에서 `users_controller.rb`로 이동하려면 여러 디렉토리를 거쳐야 합니다 (그리고 상당한 양의 탭을 눌러야 합니다). 프레임워크로 작업할 때 종종 특정 디렉토리에서 90%의 시간을 보냅니다. 이 상황에서는 최소한의 키 입력으로 `controllers/` 디렉토리로 가는 것만이 중요합니다. `path` 설정은 그 여정을 단축시킬 수 있습니다.

`app/controllers/`를 현재 `path`에 추가해야 합니다. 다음과 같이 할 수 있습니다:

```
:set path+=app/controllers/
```

이제 경로가 업데이트되었으므로, `:find u<Tab>`을 입력하면 Vim은 이제 `app/controllers/` 디렉토리 내에서 "u"로 시작하는 파일을 검색합니다.

`app/controllers/account/users_controller.rb`와 같이 중첩된 `controllers/` 디렉토리가 있는 경우, Vim은 `users_controllers`를 찾지 못합니다. 대신, 자동 완성이 `users_controller.rb`를 찾으려면 `:set path+=app/controllers/**`를 추가해야 합니다. 이것은 훌륭합니다! 이제 탭을 3번 누르는 대신 1번 눌러 사용자 컨트롤러를 찾을 수 있습니다.

전체 프로젝트 디렉토리를 추가하여 `tab`을 누를 때 Vim이 모든 곳에서 해당 파일을 검색하도록 생각할 수도 있습니다:

```
:set path+=$PWD/**
```

`$PWD`는 현재 작업 디렉토리입니다. 전체 프로젝트를 `path`에 추가하여 `tab`을 누를 때 모든 파일에 접근할 수 있기를 바란다면, 작은 프로젝트에서는 작동할 수 있지만, 프로젝트에 파일 수가 많은 경우 검색 속도가 현저히 느려집니다. 가장 많이 방문하는 파일/디렉토리의 `path`만 추가하는 것을 권장합니다.

vimrc에 `set path+={your-path-here}`를 추가할 수 있습니다. `path`를 업데이트하는 데는 몇 초밖에 걸리지 않으며 그렇게 함으로써 많은 시간을 절약할 수 있습니다.

## Grep으로 파일 내용 검색하기

파일 내에서 검색해야 하는 경우(파일에서 구문 찾기), grep을 사용할 수 있습니다. Vim에는 두 가지 방법이 있습니다:

- 내부 grep (`:vim`. 예, `:vim`이라고 씁니다. `:vimgrep`의 줄임말입니다).
- 외부 grep (`:grep`).

먼저 내부 grep부터 살펴봅시다. `:vim`은 다음과 같은 구문을 가집니다:

```
:vim /pattern/ file
```

- `/pattern/`은 검색어의 정규식 패턴입니다.
- `file`은 파일 인수입니다. 여러 인수를 전달할 수 있습니다. Vim은 파일 인수 내에서 패턴을 검색합니다. `:find`와 유사하게, `*` 및 `**` 와일드카드를 전달할 수 있습니다.

예를 들어, `app/controllers/` 디렉토리 내의 모든 루비 파일(`.rb`)에서 "breakfast" 문자열의 모든 발생을 찾으려면:

```
:vim /breakfast/ app/controllers/**/*.rb
```

그것을 실행하면 첫 번째 결과로 리디렉션됩니다. Vim의 `vim` 검색 명령어는 `quickfix` 작업을 사용합니다. 모든 검색 결과를 보려면 `:copen`을 실행하세요. 이것은 `quickfix` 창을 엽니다. 즉시 생산성을 높일 수 있는 유용한 quickfix 명령어는 다음과 같습니다:

```
:copen        quickfix 창 열기
:cclose       quickfix 창 닫기
:cnext        다음 오류로 이동
:cprevious    이전 오류로 이동
:colder       이전 오류 목록으로 이동
:cnewer       최신 오류 목록으로 이동
```

quickfix에 대해 더 배우려면 `:h quickfix`를 확인하세요.

내부 grep (`:vim`)을 실행하면 일치하는 항목이 많은 경우 느려질 수 있다는 것을 알 수 있습니다. 이는 Vim이 일치하는 각 파일을 편집 중인 것처럼 메모리에 로드하기 때문입니다. Vim이 검색과 일치하는 많은 파일을 찾으면, 모든 파일을 로드하므로 많은 양의 메모리를 소비하게 됩니다.

외부 grep에 대해 이야기해 봅시다. 기본적으로 `grep` 터미널 명령어를 사용합니다. `app/controllers/` 디렉토리 내의 루비 파일에서 "lunch"를 검색하려면 다음과 같이 할 수 있습니다:

```
:grep -R "lunch" app/controllers/
```

`/pattern/`을 사용하는 대신 터미널 grep 구문인 `"pattern"`을 따릅니다. 또한 `quickfix`를 사용하여 모든 일치 항목을 표시합니다.

Vim은 `:grep` Vim 명령어를 실행할 때 실행할 외부 프로그램을 결정하기 위해 `grepprg` 변수를 정의하므로, Vim을 닫고 터미널 `grep` 명령어를 호출할 필요가 없습니다. 나중에 `:grep` Vim 명령어를 사용할 때 호출되는 기본 프로그램을 변경하는 방법을 보여드리겠습니다.

## Netrw로 파일 탐색하기

`netrw`는 Vim의 내장 파일 탐색기입니다. 프로젝트의 계층 구조를 보는 데 유용합니다. `netrw`를 실행하려면 `.vimrc`에 다음 두 가지 설정이 필요합니다:

```
set nocp
filetype plugin on
```

`netrw`는 방대한 주제이므로 기본 사용법만 다루겠지만, 시작하기에는 충분할 것입니다. Vim을 시작할 때 파일 대신 디렉토리를 매개변수로 전달하여 `netrw`를 시작할 수 있습니다. 예를 들어:

```
vim .
vim src/client/
vim app/controllers/
```

Vim 내부에서 `netrw`를 시작하려면 `:edit` 명령어를 사용하고 파일 이름 대신 디렉토리 매개변수를 전달할 수 있습니다:

```
:edit .
:edit src/client/
:edit app/controllers/
```

디렉토리를 전달하지 않고 `netrw` 창을 시작하는 다른 방법도 있습니다:

```
:Explore     현재 파일에서 netrw 시작
:Sexplore    농담이 아닙니다. 화면 상단 절반 분할하여 netrw 시작
:Vexplore    화면 왼쪽 절반 분할하여 netrw 시작
```

Vim 모션으로 `netrw`를 탐색할 수 있습니다 (모션은 나중 장에서 자세히 다룰 것입니다). 파일이나 디렉토리를 생성, 삭제 또는 이름 변경해야 하는 경우, 유용한 `netrw` 명령어 목록은 다음과 같습니다:

```
%    새 파일 생성
d    새 디렉토리 생성
R    파일 또는 디렉토리 이름 변경
D    파일 또는 디렉토리 삭제
```

`:h netrw`는 매우 포괄적입니다. 시간이 있다면 확인해보세요.

`netrw`가 너무 단조롭고 더 많은 맛이 필요하다면, [vim-vinegar](https://github.com/tpope/vim-vinegar)는 `netrw`를 개선하는 좋은 플러그인입니다. 다른 파일 탐색기를 찾고 있다면, [NERDTree](https://github.com/preservim/nerdtree)가 좋은 대안입니다. 확인해보세요!

## Fzf

이제 Vim의 내장 도구로 파일을 검색하는 방법을 배웠으니, 플러그인으로 하는 방법을 배워봅시다.

최신 텍스트 편집기가 제대로 하고 Vim이 그렇지 못했던 한 가지는 특히 퍼지 검색을 통해 파일을 쉽게 찾는 방법입니다. 이 장의 두 번째 절반에서는 [fzf.vim](https://github.com/junegunn/fzf.vim)을 사용하여 Vim에서 검색을 쉽고 강력하게 만드는 방법을 보여드리겠습니다.

## 설정

먼저, [fzf](https://github.com/junegunn/fzf)와 [ripgrep](https://github.com/BurntSushi/ripgrep)이 다운로드되었는지 확인하세요. 해당 깃허브 저장소의 지침을 따르세요. 성공적으로 설치하면 `fzf`와 `rg` 명령어를 사용할 수 있습니다.

Ripgrep은 grep과 매우 유사한 검색 도구입니다 (이름에서 알 수 있듯이). 일반적으로 grep보다 빠르며 많은 유용한 기능이 있습니다. Fzf는 범용 커맨드-라인 퍼지 파인더입니다. ripgrep을 포함한 모든 명령어와 함께 사용할 수 있습니다. 함께 사용하면 강력한 검색 도구 조합이 됩니다.

Fzf는 기본적으로 ripgrep을 사용하지 않으므로, `FZF_DEFAULT_COMMAND` 변수를 정의하여 fzf에 ripgrep을 사용하도록 알려야 합니다. 제 `.zshrc`(`.bashrc`를 사용한다면)에는 다음이 있습니다:

```
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m'
fi
```

`FZF_DEFAULT_OPTS`의 `-m`에 주목하세요. 이 옵션을 사용하면 `<Tab>` 또는 `<Shift-Tab>`으로 여러 항목을 선택할 수 있습니다. fzf가 Vim과 함께 작동하도록 이 줄이 필요하지는 않지만, 유용한 옵션이라고 생각합니다. 잠시 후에 다룰 여러 파일에서 검색 및 바꾸기를 수행할 때 유용할 것입니다. fzf 명령어는 더 많은 옵션을 허용하지만, 여기서는 다루지 않겠습니다. 더 배우려면 [fzf의 저장소](https://github.com/junegunn/fzf#usage) 또는 `man fzf`를 확인하세요. 최소한 `export FZF_DEFAULT_COMMAND='rg'`는 있어야 합니다.

fzf와 ripgrep을 설치한 후, fzf 플러그인을 설정해 봅시다. 이 예제에서는 [vim-plug](https://github.com/junegunn/vim-plug) 플러그인 관리자를 사용하지만, 어떤 플러그인 관리자든 사용할 수 있습니다.

`.vimrc` 플러그인 안에 다음을 추가하세요. [fzf.vim](https://github.com/junegunn/fzf.vim) 플러그인(동일한 fzf 작성자가 만듦)을 사용해야 합니다.

```
call plug#begin()
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
call plug#end()
```

이 줄들을 추가한 후, `vim`을 열고 `:PlugInstall`을 실행해야 합니다. `vimrc` 파일에 정의되어 있고 설치되지 않은 모든 플러그인을 설치할 것입니다. 우리의 경우, `fzf.vim`과 `fzf`를 설치할 것입니다.

이 플러그인에 대한 더 많은 정보는 [fzf.vim 저장소](https://github.com/junegunn/fzf/blob/master/README-VIM.md)에서 확인할 수 있습니다.

## Fzf 구문

fzf를 효율적으로 사용하려면 몇 가지 기본 fzf 구문을 배워야 합니다. 다행히 목록은 짧습니다:

- `^`는 접두사 정확히 일치입니다. "welcome"으로 시작하는 구문을 검색하려면: `^welcome`.
- `$`는 접미사 정확히 일치입니다. "my friends"로 끝나는 구문을 검색하려면: `friends$`.
- `'`는 정확히 일치입니다. "welcome my friends" 구문을 검색하려면: `'welcome my friends`.
- `|`는 "또는" 일치입니다. "friends" 또는 "foes"를 검색하려면: `friends | foes`.
- `!`는 역 일치입니다. "welcome"을 포함하고 "friends"를 포함하지 않는 구문을 검색하려면: `welcome !friends`

이러한 옵션들을 혼합하여 사용할 수 있습니다. 예를 들어, `^hello | ^welcome friends$`는 "welcome" 또는 "hello"로 시작하고 "friends"로 끝나는 구문을 검색합니다.

## 파일 찾기

fzf.vim 플러그인을 사용하여 Vim 내부에서 파일을 검색하려면 `:Files` 메소드를 사용할 수 있습니다. Vim에서 `:Files`를 실행하면 fzf 검색 프롬프트가 표시됩니다.

이 명령어를 자주 사용할 것이므로 키보드 단축키에 매핑하는 것이 좋습니다. 저는 `Ctrl-f`에 매핑합니다. 제 vimrc에는 다음이 있습니다:

```
nnoremap <silent> <C-f> :Files<CR>
```

## 파일 내용 찾기

파일 내부에서 검색하려면 `:Rg` 명령어를 사용할 수 있습니다.

다시, 이것을 자주 사용할 것이므로 키보드 단축키에 매핑해 봅시다. 저는 `<Leader>f`에 매핑합니다. `<Leader>` 키는 기본적으로 `\`에 매핑됩니다.

```
nnoremap <silent> <Leader>f :Rg<CR>
```

## 기타 검색

Fzf.vim은 다른 많은 검색 명령어를 제공합니다. 여기서는 각각을 다루지 않겠지만, [여기](https://github.com/junegunn/fzf.vim#commands)에서 확인할 수 있습니다.

제 fzf 맵은 다음과 같습니다:

```
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <Leader>f :Rg<CR>
nnoremap <silent> <Leader>/ :BLines<CR>
nnoremap <silent> <Leader>' :Marks<CR>
nnoremap <silent> <Leader>g :Commits<CR>
nnoremap <silent> <Leader>H :Helptags<CR>
nnoremap <silent> <Leader>hh :History<CR>
nnoremap <silent> <Leader>h: :History:<CR>
nnoremap <silent> <Leader>h/ :History/<CR>
```

## Grep을 Rg로 교체하기

앞서 언급했듯이, Vim에는 파일에서 검색하는 두 가지 방법이 있습니다: `:vim`과 `:grep`. `:grep`은 `grepprg` 키워드를 사용하여 재할당할 수 있는 외부 검색 도구를 사용합니다. `:grep` 명령어를 실행할 때 터미널 grep 대신 ripgrep을 사용하도록 Vim을 구성하는 방법을 보여드리겠습니다.

이제 `:grep` Vim 명령어가 ripgrep을 사용하도록 `grepprg`를 설정해 봅시다. vimrc에 다음을 추가하세요:

```
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
```

위의 옵션 중 일부를 자유롭게 수정하세요! 위의 옵션이 무엇을 의미하는지에 대한 더 많은 정보는 `man rg`를 확인하세요.

`grepprg`를 업데이트한 후, 이제 `:grep`을 실행하면 `grep` 대신 `rg --vimgrep --smart-case --follow`를 실행합니다. ripgrep을 사용하여 "donut"을 검색하고 싶다면, 이제 `:grep "donut" . -R` 대신 더 간결한 명령어 `:grep "donut"`을 실행할 수 있습니다.

이전 `:grep`과 마찬가지로, 이 새로운 `:grep`도 quickfix를 사용하여 결과를 표시합니다.

"음, 좋긴 한데 Vim에서 `:grep`을 사용해 본 적이 없고, 파일에서 구문을 찾기 위해 `:Rg`를 사용하면 되지 않나? 언제 `:grep`을 사용해야 할까?"라고 궁금해할 수 있습니다.

그것은 아주 좋은 질문입니다. 여러 파일에서 검색 및 바꾸기를 수행하기 위해 Vim에서 `:grep`을 사용해야 할 수도 있으며, 다음에 다룰 것입니다.

## 여러 파일에서 검색 및 바꾸기

VSCode와 같은 최신 텍스트 편집기는 여러 파일에 걸쳐 문자열을 검색하고 바꾸는 것을 매우 쉽게 만듭니다. 이 섹션에서는 Vim에서 쉽게 할 수 있는 두 가지 다른 방법을 보여드리겠습니다.

첫 번째 방법은 프로젝트에서 일치하는 *모든* 구문을 바꾸는 것입니다. `:grep`을 사용해야 합니다. "pizza"의 모든 인스턴스를 "donut"으로 바꾸고 싶다면, 다음과 같이 하세요:

```
:grep "pizza"
:cfdo %s/pizza/donut/g | update
```

명령어를 분석해 봅시다:

1. `:grep pizza`는 ripgrep을 사용하여 "pizza"의 모든 인스턴스를 검색합니다 (참고로, `grepprg`를 ripgrep을 사용하도록 재할당하지 않았더라도 이것은 여전히 작동합니다. `:grep "pizza"` 대신 `:grep "pizza" . -R`을 해야 합니다).
2. `:cfdo`는 quickfix 목록의 모든 파일에 전달하는 모든 명령어를 실행합니다. 이 경우, 명령어는 치환 명령어 `%s/pizza/donut/g`입니다. 파이프(`|`)는 체인 연산자입니다. `update` 명령어는 치환 후 각 파일을 저장합니다. 치환 명령어에 대해서는 나중 장에서 더 자세히 다룰 것입니다.

두 번째 방법은 선택한 파일에서 검색하고 바꾸는 것입니다. 이 방법을 사용하면 선택 및 바꾸기를 수행할 파일을 수동으로 선택할 수 있습니다. 다음과 같이 하세요:

1. 먼저 버퍼를 지우세요. 버퍼 목록에 바꾸기를 적용할 파일만 포함하는 것이 중요합니다. Vim을 다시 시작하거나 `:%bd | e#` 명령어를 실행할 수 있습니다 (`%bd`는 모든 버퍼를 삭제하고 `e#`는 방금 있었던 파일을 엽니다).
2. `:Files`를 실행하세요.
3. 검색 및 바꾸기를 수행할 모든 파일을 선택하세요. 여러 파일을 선택하려면 `<Tab>` / `<Shift-Tab>`을 사용하세요. 이것은 `FZF_DEFAULT_OPTS`에 다중 플래그(`-m`)가 있는 경우에만 가능합니다.
4. `:bufdo %s/pizza/donut/g | update`를 실행하세요. `:bufdo %s/pizza/donut/g | update` 명령어는 이전의 `:cfdo %s/pizza/donut/g | update` 명령어와 비슷해 보입니다. 차이점은 모든 quickfix 항목을 치환하는 대신(`:cfdo`), 모든 버퍼 항목을 치환하는 것입니다(`:bufdo`).

## 현명하게 검색 배우기

검색은 텍스트 편집의 기본입니다. Vim에서 잘 검색하는 방법을 배우면 텍스트 편집 작업 흐름이 크게 향상됩니다.

Fzf.vim은 게임 체인저입니다. 그것 없이는 Vim을 사용하는 것을 상상할 수 없습니다. Vim을 시작할 때 좋은 검색 도구를 갖는 것이 매우 중요하다고 생각합니다. 쉽고 강력한 검색 기능과 같은 최신 텍스트 편집기가 가진 중요한 기능이 없는 것처럼 보이기 때문에 Vim으로 전환하는 데 어려움을 겪는 사람들을 보았습니다. 이 장이 Vim으로의 전환을 더 쉽게 만드는 데 도움이 되기를 바랍니다.

또한 Vim의 확장성이 실제로 작동하는 것을 방금 보았습니다 - 플러그인 및 외부 프로그램으로 검색 기능을 확장하는 능력입니다. 앞으로 Vim에 확장하고 싶은 다른 기능이 무엇인지 염두에 두십시오. 아마도 이미 Vim에 있거나, 누군가가 플러그인을 만들었거나, 이미 프로그램이 있을 가능성이 높습니다. 다음으로, Vim에서 매우 중요한 주제인 Vim 문법에 대해 배울 것입니다.