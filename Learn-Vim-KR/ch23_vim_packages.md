# Ch23. Vim 패키지

이전 챕터에서, 플러그인을 설치하기 위해 외부 플러그인 매니저를 사용하는 것을 언급했습니다. 버전 8부터 Vim은 *패키지*라고 불리는 자체 내장 플러그인 매니저를 제공합니다. 이번 챕터에서는 Vim 패키지를 사용하여 플러그인을 설치하는 방법을 배우게 됩니다.

사용하는 Vim 빌드가 패키지를 사용할 수 있는지 확인하려면, `:version`을 실행하고 `+packages` 속성을 찾아보세요. 또는 `:echo has('packages')`를 실행할 수도 있습니다 (만약 1을 반환하면, 패키지 기능을 가지고 있는 것입니다).

## Pack 디렉토리

루트 경로에 `~/.vim/` 디렉토리가 있는지 확인하세요. 만약 없다면, 하나 만드세요. 그 안에 `pack`이라는 이름의 디렉토리를 만드세요 (`~/.vim/pack/`). Vim은 패키지를 찾기 위해 이 디렉토리 내부를 자동으로 검색합니다.

## 두 가지 로딩 유형

Vim 패키지에는 자동 로딩과 수동 로딩이라는 두 가지 로딩 메커니즘이 있습니다.

### 자동 로딩

Vim이 시작될 때 플러그인을 자동으로 로드하려면, `start/` 디렉토리에 플러그인을 넣어야 합니다. 경로는 다음과 같습니다:

```
~/.vim/pack/*/start/
```

이제 "pack/과 start/ 사이의 `*`는 무엇인가요?"라고 물을 수 있습니다. `*`는 임의의 이름이며 원하는 어떤 것이든 될 수 있습니다. `packdemo/`라고 이름 지어 보겠습니다:

```
~/.vim/pack/packdemo/start/
```

만약 이것을 건너뛰고 다음과 같이 한다면:

```
~/.vim/pack/start/
```

패키지 시스템은 작동하지 않을 것입니다. `pack/`과 `start/` 사이에 이름을 넣는 것이 필수적입니다.

이 데모를 위해, [NERDTree](https://github.com/preservim/nerdtree) 플러그인을 설치해 보겠습니다. `start/` 디렉토리까지 이동하여 (`cd ~/.vim/pack/packdemo/start/`) NERDTree 저장소를 클론하세요:

```
git clone https://github.com/preservim/nerdtree.git
```

이게 전부입니다! 모든 준비가 끝났습니다. 다음에 Vim을 시작하면, `:NERDTreeToggle`과 같은 NERDTree 명령어를 즉시 실행할 수 있습니다.

`~/.vim/pack/*/start/` 경로 안에 원하는 만큼 많은 플러그인 저장소를 클론할 수 있습니다. Vim은 각각을 자동으로 로드할 것입니다. 클론된 저장소를 제거하면 (`rm -rf nerdtree/`), 해당 플러그인은 더 이상 사용할 수 없게 됩니다.

### 수동 로딩

Vim이 시작될 때 플러그인을 수동으로 로드하려면, `opt/` 디렉토리에 플러그인을 넣어야 합니다. 자동 로딩과 유사하게, 경로는 다음과 같습니다:

```
~/.vim/pack/*/opt/
```

이전과 동일한 `packdemo/` 디렉토리를 사용해 보겠습니다:

```
~/.vim/pack/packdemo/opt/
```

이번에는 [killersheep](https://github.com/vim/killersheep) 게임을 설치해 보겠습니다 (Vim 8.2가 필요합니다). `opt/` 디렉토리로 이동하여 (`cd ~/.vim/pack/packdemo/opt/`) 저장소를 클론하세요:

```
git clone https://github.com/vim/killersheep.git
```

Vim을 시작하세요. 게임을 실행하는 명령어는 `:KillKillKill`입니다. 실행해 보세요. Vim은 유효한 편집기 명령어가 아니라고 불평할 것입니다. 먼저 플러그인을 *수동으로* 로드해야 합니다. 해보겠습니다:

```
:packadd killersheep
```

이제 `:KillKillKill` 명령어를 다시 실행해 보세요. 이제 명령어가 작동할 것입니다.

"왜 수동으로 패키지를 로드하고 싶을까요? 처음부터 모든 것을 자동으로 로드하는 것이 더 낫지 않을까요?"라고 궁금해할 수 있습니다.

좋은 질문입니다. KillerSheep 게임처럼 항상 사용하지 않는 플러그인들이 있습니다. 아마도 10가지 다른 게임을 로드하여 Vim 시작 시간을 늦출 필요는 없을 것입니다. 하지만 가끔 심심할 때 몇 가지 게임을 하고 싶을 수 있습니다. 필수적이지 않은 플러그인에는 수동 로딩을 사용하세요.

조건부로 플러그인을 추가하는 데에도 이것을 사용할 수 있습니다. 아마 Neovim과 Vim을 모두 사용하고 Neovim에 최적화된 플러그인이 있을 수 있습니다. vimrc에 다음과 같이 추가할 수 있습니다:

```
if has('nvim')
  packadd! neovim-only-plugin
else
  packadd! generic-vim-plugin
endif
```

## 패키지 정리하기

Vim의 패키지 시스템을 사용하기 위한 요구 사항은 다음 중 하나를 갖는 것이라는 점을 기억하세요:

```
~/.vim/pack/*/start/
```

또는:

```
~/.vim/pack/*/opt/
```

`*`가 *어떤* 이름이든 될 수 있다는 사실은 패키지를 정리하는 데 사용될 수 있습니다. 플러그인을 카테고리(색상, 구문, 게임)별로 그룹화하고 싶다고 가정해 봅시다:

```
~/.vim/pack/colors/
~/.vim/pack/syntax/
~/.vim/pack/games/
```

각 디렉토리 안에서 여전히 `start/`와 `opt/`를 사용할 수 있습니다.

```
~/.vim/pack/colors/start/
~/.vim/pack/colors/opt/

~/.vim/pack/syntax/start/
~/.vim/pack/syntax/opt/

~/.vim/pack/games/start/
~/.vim/pack/games/opt/
```

## 스마트하게 패키지 추가하기

Vim 패키지가 vim-pathogen, vundle.vim, dein.vim, vim-plug와 같은 인기 있는 플러그인 매니저를 쓸모없게 만들지 궁금할 수 있습니다.

답은 언제나 그렇듯이 "상황에 따라 다릅니다".

저는 여전히 vim-plug를 사용하는데, 플러그인을 추가, 제거 또는 업데이트하기 쉽기 때문입니다. 많은 플러그인을 사용하는 경우, 동시에 많은 플러그인을 쉽게 업데이트할 수 있으므로 플러그인 매니저를 사용하는 것이 더 편리할 수 있습니다. 일부 플러그인 매니저는 비동기 기능도 제공합니다.

미니멀리스트라면 Vim 패키지를 사용해 보세요. 플러그인을 많이 사용하는 사용자라면 플러그인 매니저 사용을 고려해 볼 수 있습니다.