# Ch24. Vim 런타임

이전 챕터에서 Vim이 `~/.vim/` 디렉토리 내에서 `pack/`(22장) 및 `compiler/`(19장)와 같은 특수 경로를 자동으로 찾는다고 언급했습니다. 이것들은 Vim 런타임 경로의 예입니다.

Vim에는 이 두 가지보다 더 많은 런타임 경로가 있습니다. 이번 챕터에서는 이러한 런타임 경로에 대한 개괄적인 개요를 배우게 됩니다. 이 챕터의 목표는 언제 호출되는지 보여주는 것입니다. 이를 알면 Vim을 더 깊이 이해하고 사용자 정의할 수 있습니다.

## 런타임 경로

유닉스 시스템에서 Vim 런타임 경로 중 하나는 `$HOME/.vim/`입니다 (윈도우와 같은 다른 OS를 사용하는 경우 경로는 다를 수 있습니다). 다른 OS의 런타임 경로를 확인하려면 `:h 'runtimepath'`를 참조하세요. 이 챕터에서는 `~/.vim/`을 기본 런타임 경로로 사용하겠습니다.

## 플러그인 스크립트

Vim에는 Vim이 시작될 때마다 이 디렉토리에 있는 모든 스크립트를 한 번씩 실행하는 플러그인 런타임 경로가 있습니다. "플러그인"이라는 이름을 외부 Vim 플러그인(NERDTree, fzf.vim 등)과 혼동하지 마세요.

`~/.vim/` 디렉토리로 이동하여 `plugin/` 디렉토리를 만드세요. `donut.vim`과 `chocolate.vim` 두 개의 파일을 만드세요.

`~/.vim/plugin/donut.vim` 내부:
```vim
echo "donut!"
```

`~/.vim/plugin/chocolate.vim` 내부:
```vim
echo "chocolate!"
```

이제 Vim을 닫으세요. 다음에 Vim을 시작하면 `"donut!"`과 `"chocolate!"`이 모두 출력되는 것을 볼 수 있습니다. 플러그인 런타임 경로는 초기화 스크립트에 사용될 수 있습니다.

## 파일 유형 감지

시작하기 전에, 이러한 감지가 작동하는지 확인하려면 vimrc에 최소한 다음 줄이 포함되어 있는지 확인하세요:
```vim
filetype plugin indent on
```

더 자세한 내용은 `:h filetype-overview`를 확인하세요. 기본적으로 이것은 Vim의 파일 유형 감지를 켭니다.

새 파일을 열면 Vim은 일반적으로 어떤 종류의 파일인지 압니다. `hello.rb` 파일이 있는 경우 `:set filetype?`을 실행하면 `filetype=ruby`라는 올바른 응답을 반환합니다.

Vim은 "일반적인" 파일 유형(Ruby, Python, Javascript 등)을 감지하는 방법을 알고 있습니다. 하지만 사용자 정의 파일이 있다면 어떨까요? Vim에게 그것을 감지하고 올바른 파일 유형을 할당하도록 가르쳐야 합니다.

파일 이름과 파일 내용을 사용하는 두 가지 감지 방법이 있습니다.

### 파일 이름 감지

파일 이름 감지는 파일 이름을 사용하여 파일 유형을 감지합니다. `hello.rb` 파일을 열면 Vim은 `.rb` 확장자로부터 루비 파일임을 압니다.

파일 이름 감지를 수행하는 두 가지 방법이 있습니다: `ftdetect/` 런타임 디렉토리 사용과 `filetype.vim` 런타임 파일 사용입니다. 둘 다 살펴보겠습니다.

#### `ftdetect/`

생소하지만 맛있는 파일 `hello.chocodonut`을 만들어 봅시다. 이 파일을 열고 `:set filetype?`을 실행하면, 일반적인 파일 이름 확장자가 아니기 때문에 Vim은 무엇을 해야 할지 모릅니다. `filetype=`을 반환합니다.

`.chocodonut`으로 끝나는 모든 파일을 "chocodonut" 파일 유형으로 설정하도록 Vim에 지시해야 합니다. 런타임 루트(`~/.vim/`)에 `ftdetect/`라는 이름의 디렉토리를 만드세요. 그 안에 `chocodonut.vim`이라는 파일을 만드세요(`~/.vim/ftdetect/chocodonut.vim`). 이 파일 안에 다음을 추가하세요:
```vim
autocmd BufNewFile,BufRead *.chocodonut set filetype=chocodonut
```

`BufNewFile`과 `BufRead`는 새 버퍼를 만들거나 새 버퍼를 열 때마다 트리거됩니다. `*.chocodonut`은 열린 버퍼의 파일 이름 확장자가 `.chocodonut`인 경우에만 이 이벤트가 트리거됨을 의미합니다. 마지막으로 `set filetype=chocodonut` 명령어는 파일 유형을 chocodonut 유형으로 설정합니다.

Vim을 다시 시작하세요. 이제 `hello.chocodonut` 파일을 열고 `:set filetype?`을 실행하세요. `filetype=chocodonut`을 반환합니다.

아주 맛있군요! `ftdetect/` 안에 원하는 만큼 많은 파일을 넣을 수 있습니다. 나중에 도넛 파일 유형을 확장하기로 결정하면 `ftdetect/strawberrydonut.vim`, `ftdetect/plaindonut.vim` 등을 추가할 수 있습니다.

Vim에서 파일 유형을 설정하는 방법에는 실제로 두 가지가 있습니다. 하나는 방금 사용한 `set filetype=chocodonut`이고, 다른 하나는 `setfiletype chocodonut`를 실행하는 것입니다. 전자의 명령어 `set filetype=chocodonut`은 파일 유형을 *항상* chocodonut 유형으로 설정하는 반면, 후자의 명령어 `setfiletype chocodonut`은 아직 파일 유형이 설정되지 않은 경우에만 파일 유형을 설정합니다.

#### Filetype 파일

두 번째 파일 감지 방법은 루트 디렉토리에 `filetype.vim`을 만드는 것입니다(`~/.vim/filetype.vim`). 그 안에 다음을 추가하세요:
```vim
autocmd BufNewFile,BufRead *.plaindonut set filetype=plaindonut
```

`hello.plaindonut` 파일을 만드세요. 이 파일을 열고 `:set filetype?`을 실행하면 Vim은 올바른 사용자 정의 파일 유형 `filetype=plaindonut`을 표시합니다.

세상에, 작동하네요! 그런데 `filetype.vim`을 가지고 놀다 보면 `hello.plaindonut`을 열 때 이 파일이 여러 번 실행되는 것을 알 수 있습니다. 이를 방지하기 위해 주 스크립트가 한 번만 실행되도록 가드를 추가할 수 있습니다. `filetype.vim`을 업데이트하세요:
```vim
if exists("did_load_filetypes")
  finish
endif

augroup donutfiletypedetection
  autocmd! BufRead,BufNewFile *.plaindonut setfiletype plaindonut
augroup END
```

`finish`는 나머지 스크립트 실행을 중지하는 Vim 명령어입니다. `"did_load_filetypes"` 표현식은 내장 Vim 함수가 *아닙니다*. 실제로는 `$VIMRUNTIME/filetype.vim` 내부의 전역 변수입니다. 궁금하다면 `:e $VIMRUNTIME/filetype.vim`을 실행해 보세요. 그 안에 다음 줄을 찾을 수 있습니다:
```vim
if exists("did_load_filetypes")
  finish
endif

let did_load_filetypes = 1
```

Vim이 이 파일을 호출하면 `did_load_filetypes` 변수를 정의하고 1로 설정합니다. 1은 Vim에서 참(truthy)입니다. `filetype.vim`의 나머지 부분도 읽어봐야 합니다. Vim이 호출할 때 무엇을 하는지 이해할 수 있는지 확인해 보세요.

### 파일 유형 스크립트

파일 내용을 기반으로 파일 유형을 감지하고 할당하는 방법을 배워 봅시다.

확장자가 정해지지 않은 파일 모음이 있다고 가정해 봅시다. 이 파일들의 유일한 공통점은 모두 첫 줄에 "donutify"라는 단어로 시작한다는 것입니다. 이 파일들을 `donut` 파일 유형에 할당하고 싶습니다. `sugardonut`, `glazeddonut`, `frieddonut`이라는 이름의 새 파일을 만드세요(확장자 없이). 각 파일 안에 다음 줄을 추가하세요:
```
donutify
```

`sugardonut` 안에서 `:set filetype?`을 실행하면 Vim은 이 파일에 어떤 파일 유형을 할당해야 할지 모릅니다. `filetype=`을 반환합니다.

런타임 루트 경로에 `scripts.vim` 파일을 추가하세요(`~/.vim/scripts.vim`). 그 안에 다음을 추가하세요:
```vim
if did_filetype()
  finish
endif

if getline(1) =~ '^\\<donutify\\>'
  setfiletype donut
endif
```

`getline(1)` 함수는 첫 번째 줄의 텍스트를 반환합니다. 첫 번째 줄이 "donutify"라는 단어로 시작하는지 확인합니다. `did_filetype()` 함수는 Vim 내장 함수입니다. 파일 유형 관련 이벤트가 한 번 이상 트리거되면 참을 반환합니다. 파일 유형 이벤트를 다시 실행하는 것을 막는 가드로 사용됩니다.

`sugardonut` 파일을 열고 `:set filetype?`을 실행하면 Vim은 이제 `filetype=donut`을 반환합니다. 다른 도넛 파일(`glazeddonut` 및 `frieddonut`)을 열면 Vim은 해당 파일 유형도 `donut` 유형으로 식별합니다.

`scripts.vim`은 Vim이 알 수 없는 파일 유형의 파일을 열 때만 실행된다는 점에 유의하세요. Vim이 알려진 파일 유형의 파일을 열면 `scripts.vim`은 실행되지 않습니다.

## 파일 유형 플러그인

chocodonut 파일을 열 때 Vim이 chocodonut 관련 스크립트를 실행하고 plaindonut 파일을 열 때는 해당 스크립트를 실행하지 않도록 하려면 어떻게 해야 할까요?

파일 유형 플러그인 런타임 경로(`~/.vim/ftplugin/`)를 사용하여 이 작업을 수행할 수 있습니다. Vim은 이 디렉토리에서 방금 연 파일 유형과 동일한 이름의 파일을 찾습니다. `chocodonut.vim`을 만드세요(`~/.vim/ftplugin/chocodonut.vim`):
```vim
echo "Calling from chocodonut ftplugin"
```

다른 ftplugin 파일인 `plaindonut.vim`을 만드세요(`~/.vim/ftplugin/plaindonut.vim`):
```vim
echo "Calling from plaindonut ftplugin"
```

이제 chocodonut 파일 유형을 열 때마다 Vim은 `~/.vim/ftplugin/chocodonut.vim`의 스크립트를 실행합니다. plaindonut 파일 유형을 열 때마다 Vim은 `~/.vim/ftplugin/plaindonut.vim`의 스크립트를 실행합니다.

한 가지 경고: 이 파일들은 버퍼 파일 유형이 설정될 때마다 실행됩니다(예: `set filetype=chocodonut`). 3개의 다른 chocodonut 파일을 열면 스크립트는 *총* 세 번 실행됩니다.

## 들여쓰기 파일

Vim에는 ftplugin과 유사하게 작동하는 들여쓰기 런타임 경로가 있으며, 여기서 Vim은 열린 파일 유형과 동일한 이름의 파일을 찾습니다. 이러한 들여쓰기 런타임 경로의 목적은 들여쓰기 관련 코드를 저장하는 것입니다. `~/.vim/indent/chocodonut.vim` 파일이 있는 경우, chocodonut 파일 유형을 열 때만 실행됩니다. 여기에 chocodonut 파일에 대한 들여쓰기 관련 코드를 저장할 수 있습니다.

## 색상

Vim에는 색상 구성표를 저장하기 위한 색상 런타임 경로(`~/.vim/colors/`)가 있습니다. 디렉토리 안에 들어가는 모든 파일은 `:color` 커맨드 라인 명령어에 표시됩니다.

`~/.vim/colors/beautifulprettycolors.vim` 파일이 있는 경우, `:color`를 실행하고 탭을 누르면 `beautifulprettycolors`가 색상 옵션 중 하나로 표시됩니다. 자신만의 색상 구성표를 추가하고 싶다면 이곳이 바로 그곳입니다.

다른 사람들이 만든 색상 구성표를 확인하고 싶다면 [vimcolors](https://vimcolors.com/)를 방문하는 것이 좋습니다.

## 구문 강조

Vim에는 구문 강조를 정의하기 위한 구문 런타임 경로(`~/.vim/syntax/`)가 있습니다.

`hello.chocodonut` 파일이 있고 그 안에 다음과 같은 표현식이 있다고 가정해 봅시다:
```
(donut "tasty")
(donut "savory")
```

Vim이 이제 올바른 파일 유형을 알지만 모든 텍스트의 색상이 동일합니다. "donut" 키워드를 강조 표시하는 구문 강조 규칙을 추가해 봅시다. 새 chocodonut 구문 파일 `~/.vim/syntax/chocodonut.vim`을 만드세요. 그 안에 다음을 추가하세요:
```vim
syntax keyword donutKeyword donut

highlight link donutKeyword Keyword
```

이제 `hello.chocodonut` 파일을 다시 여세요. `donut` 키워드가 이제 강조 표시됩니다.

이 챕터에서는 구문 강조에 대해 깊이 다루지 않을 것입니다. 이것은 방대한 주제입니다. 궁금하다면 `:h syntax.txt`를 확인하세요.

[vim-polyglot](https://github.com/sheerun/vim-polyglot) 플러그인은 많은 인기 있는 프로그래밍 언어에 대한 강조 표시를 제공하는 훌륭한 플러그인입니다.

## 문서

플러그인을 만들면 자신만의 문서를 만들어야 합니다. 이를 위해 문서 런타임 경로를 사용합니다.

chocodonut 및 plaindonut 키워드에 대한 기본 문서를 만들어 봅시다. `donut.txt`를 만드세요(`~/.vim/doc/donut.txt`). 그 안에 다음 텍스트를 추가하세요:
```
*chocodonut* 맛있는 초콜릿 도넛

*plaindonut* 초콜릿은 없지만 여전히 맛있는 도넛
```

`chocodonut`과 `plaindonut`을 검색하려고 하면(`:h chocodonut` 및 `:h plaindonut`) 아무것도 찾을 수 없습니다.

먼저, 새 도움말 항목을 생성하려면 `:helptags`를 실행해야 합니다. `:helptags ~/.vim/doc/`를 실행하세요.

이제 `:h chocodonut` 및 `:h plaindonut`을 실행하면 이러한 새 도움말 항목을 찾을 수 있습니다. 이제 파일이 읽기 전용이고 "help" 파일 유형을 가지고 있다는 것을 알 수 있습니다.

## 지연 로딩 스크립트

이 챕터에서 배운 모든 런타임 경로는 자동으로 실행되었습니다. 스크립트를 수동으로 로드하려면 autoload 런타임 경로를 사용하세요.

autoload 디렉토리를 만드세요(`~/.vim/autoload/`). 해당 디렉토리 안에 `tasty.vim`이라는 새 파일을 만드세요(`~/.vim/autoload/tasty.vim`). 그 안에 다음을 추가하세요:
```vim
echo "tasty.vim global"

function tasty#donut()
  echo "tasty#donut"
endfunction
```

함수 이름은 `donut()`이 아니라 `tasty#donut`입니다. autoload 기능을 사용할 때는 파운드 기호(`#`)가 필요합니다. autoload 기능의 함수 이름 지정 규칙은 다음과 같습니다:
```
function fileName#functionName()
  ...
endfunction
```

이 경우 파일 이름은 `tasty.vim`이고 함수 이름은 (기술적으로) `donut`입니다.

함수를 호출하려면 `call` 명령어가 필요합니다. `:call tasty#donut()`로 해당 함수를 호출해 봅시다.

함수를 처음 호출하면 *두* 에코 메시지("tasty.vim global" 및 "tasty#donut")가 모두 표시되어야 합니다. 이후 `tasty#donut` 함수를 호출하면 "tasty#donut" 에코만 표시됩니다.

Vim에서 파일을 열 때 이전 런타임 경로와 달리 autoload 스크립트는 자동으로 로드되지 않습니다. `tasty#donut()`을 명시적으로 호출할 때만 Vim은 `tasty.vim` 파일을 찾아 `tasty#donut()` 함수를 포함한 모든 내용을 로드합니다. Autoload는 많은 리소스를 사용하지만 자주 사용하지 않는 함수에 완벽한 메커니즘입니다.

autoload에 원하는 만큼 중첩된 디렉토리를 추가할 수 있습니다. `~/.vim/autoload/one/two/three/tasty.vim` 런타임 경로가 있는 경우 `:call one#two#three#tasty#donut()`로 함수를 호출할 수 있습니다.

## After 스크립트

Vim에는 `~/.vim/`의 구조를 미러링하는 after 런타임 경로(`~/.vim/after/`)가 있습니다. 이 경로에 있는 모든 것은 마지막에 실행되므로 개발자는 일반적으로 스크립트 재정의에 이러한 경로를 사용합니다.

예를 들어 `plugin/chocolate.vim`의 스크립트를 덮어쓰고 싶다면 `~/.vim/after/plugin/chocolate.vim`을 만들어 재정의 스크립트를 넣을 수 있습니다. Vim은 `~/.vim/plugin/chocolate.vim` *다음에* `~/.vim/after/plugin/chocolate.vim`을 실행합니다.

## $VIMRUNTIME

Vim에는 기본 스크립트 및 지원 파일을 위한 환경 변수 `$VIMRUNTIME`이 있습니다. `:e $VIMRUNTIME`을 실행하여 확인할 수 있습니다.

구조가 익숙해 보일 것입니다. 이 챕터에서 배운 많은 런타임 경로를 포함하고 있습니다.

21장에서 Vim을 열 때 일곱 군데 다른 위치에서 vimrc 파일을 찾는다고 배웠습니다. Vim이 확인하는 마지막 위치는 `$VIMRUNTIME/defaults.vim`이라고 말했습니다. Vim이 사용자 vimrc 파일을 찾지 못하면 Vim은 `defaults.vim`을 vimrc로 사용합니다.

vim-polyglot과 같은 구문 플러그인 없이 Vim을 실행해 본 적이 있습니까? 그런데도 파일이 구문 강조 표시되는 것을 본 적이 있나요? 이는 Vim이 런타임 경로에서 구문 파일을 찾지 못하면 `$VIMRUNTIME` 구문 디렉토리에서 구문 파일을 찾기 때문입니다.

더 배우려면 `:h $VIMRUNTIME`을 확인하세요.

## Runtimepath 옵션

runtimepath를 확인하려면 `:set runtimepath?`를 실행하세요.

Vim-Plug나 인기 있는 외부 플러그인 매니저를 사용하는 경우 디렉토리 목록이 표시됩니다. 예를 들어 제 경우에는 다음과 같이 표시됩니다:
```
runtimepath=~/.vim,~/.vim/plugged/vim-signify,~/.vim/plugged/base16-vim,~/.vim/plugged/fzf.vim,~/.vim/plugged/fzf,~/.vim/plugged/vim-gutentags,~/.vim/plugged/tcomment_vim,~/.vim/plugged/emmet-vim,~/.vim/plugged/vim-fugitive,~/.vim/plugged/vim-sensible,~/.vim/plugged/lightline.vim, ...
```

플러그인 매니저가 하는 일 중 하나는 각 플러그인을 런타임 경로에 추가하는 것입니다. 각 런타임 경로는 `~/.vim/`과 유사한 자체 디렉토리 구조를 가질 수 있습니다.

`~/box/of/donuts/` 디렉토리가 있고 해당 디렉토리를 런타임 경로에 추가하고 싶다면 vimrc에 다음을 추가할 수 있습니다:
```vim
set rtp+=$HOME/box/of/donuts/
```

`~/box/of/donuts/` 안에 플러그인 디렉토리(`~/box/of/donuts/plugin/hello.vim`)와 ftplugin(`~/box/of/donuts/ftplugin/chocodonut.vim`)이 있는 경우, Vim을 열 때 `plugin/hello.vim`의 모든 스크립트를 실행합니다. 또한 chocodonut 파일을 열 때 `ftplugin/chocodonut.vim`을 실행합니다.

직접 시도해 보세요: 임의의 경로를 만들고 runtimepath에 추가하세요. 이 챕터에서 배운 런타임 경로 중 일부를 추가하세요. 예상대로 작동하는지 확인하세요.

## 똑똑하게 런타임 배우기

시간을 내어 읽고 이러한 런타임 경로를 가지고 놀아보세요. 런타임 경로가 실제 어떻게 사용되는지 보려면 좋아하는 Vim 플러그인 중 하나의 저장소로 가서 디렉토리 구조를 연구해 보세요. 이제 대부분을 이해할 수 있을 것입니다. 따라가며 큰 그림을 파악하려고 노력하세요. 이제 Vim 디렉토리 구조를 이해했으므로 Vimscript를 배울 준비가 되었습니다.