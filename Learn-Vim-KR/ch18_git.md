# Ch18. Git

Vim과 git은 서로 다른 두 가지를 위한 훌륭한 도구입니다. Git은 버전 관리 도구입니다. Vim은 텍스트 편집기입니다.

이 장에서는 Vim과 git을 함께 통합하는 다양한 방법을 배웁니다.

## 차이 비교하기

이전 장에서, 여러 파일 간의 차이점을 보여주기 위해 `vimdiff` 명령어를 실행할 수 있다는 것을 상기하세요.

`file1.txt`와 `file2.txt`라는 두 개의 파일이 있다고 가정해 봅시다.

`file1.txt` 내부:

```
pancakes
waffles
apples

milk
apple juice

yogurt
```

`file2.txt` 내부:

```
pancakes
waffles
oranges

milk
orange juice

yogurt
```

두 파일 간의 차이점을 보려면 다음을 실행하세요:

```
vimdiff file1.txt file2.txt
```

또는 다음을 실행할 수도 있습니다:

```
vim -d file1.txt file2.txt
```

`vimdiff`는 두 개의 버퍼를 나란히 표시합니다. 왼쪽에는 `file1.txt`가 있고 오른쪽에는 `file2.txt`가 있습니다. 첫 번째 차이점(사과와 오렌지)은 두 줄 모두에 강조 표시됩니다.

두 번째 버퍼에 오렌지가 아닌 사과가 있도록 만들고 싶다고 가정해 봅시다. 현재 위치(현재 `file1.txt`에 있음)에서 `file2.txt`로 내용을 전송하려면, 먼저 `]c`로 다음 차이점으로 이동합니다(이전 차이점 창으로 점프하려면 `[c` 사용). 이제 커서가 사과 위에 있어야 합니다. `:diffput`을 실행하세요. 이제 두 파일 모두 사과를 갖게 됩니다.

다른 버퍼(오렌지 주스, `file2.txt`)의 텍스트를 현재 버퍼(사과 주스, `file1.txt`)의 텍스트로 바꾸려면, 커서가 여전히 `file1.txt` 창에 있는 상태에서 먼저 `]c`로 다음 차이점으로 이동합니다. 이제 커서가 사과 주스 위에 있어야 합니다. `:diffget`을 실행하여 다른 버퍼에서 오렌지 주스를 가져와 우리 버퍼의 사과 주스를 바꿉니다.

`:diffput`은 현재 버퍼의 텍스트를 다른 버퍼로 *내보냅니다*. `:diffget`은 다른 버퍼의 텍스트를 현재 버퍼로 *가져옵니다*.

여러 버퍼가 있는 경우, `:diffput fileN.txt` 및 `:diffget fileN.txt`를 실행하여 fileN 버퍼를 대상으로 할 수 있습니다.

## 병합 도구로서의 Vim

> "병합 충돌 해결하는 거 정말 좋아!" - 아무도

병합 충돌 해결을 좋아하는 사람을 본 적이 없습니다. 하지만 그것들은 피할 수 없습니다. 이 섹션에서는 Vim을 병합 충돌 해결 도구로 활용하는 방법을 배웁니다.

먼저, 다음을 실행하여 기본 병합 도구를 `vimdiff`를 사용하도록 변경합니다:

```
git config merge.tool vimdiff
git config merge.conflictstyle diff3
git config mergetool.prompt false
```

또는, `~/.gitconfig`를 직접 수정할 수도 있습니다(기본적으로 루트에 있어야 하지만, 여러분의 것은 다른 위치에 있을 수 있습니다). 위 명령어는 아직 실행하지 않았다면 아래 설정처럼 보이도록 gitconfig를 수정해야 하며, gitconfig를 수동으로 편집할 수도 있습니다.

```
[core]
  editor = vim
[merge]
  tool = vimdiff
  conflictstyle = diff3
[difftool]
  prompt = false
```

이것을 테스트하기 위해 가짜 병합 충돌을 만들어 봅시다. `/food` 디렉토리를 만들고 git 저장소로 만듭니다:

```
git init
```

`breakfast.txt` 파일을 추가합니다. 내부:

```
pancakes
waffles
oranges
```

파일을 추가하고 커밋합니다:

```
git add .
git commit -m "Initial breakfast commit"
```

다음으로, 새 브랜치를 만들고 apples 브랜치라고 부릅니다:

```
git checkout -b apples
```

`breakfast.txt`를 변경합니다:

```
pancakes
waffles
apples
```

파일을 저장한 다음, 변경 사항을 추가하고 커밋합니다:

```
git add .
git commit -m "Apples not oranges"
```

좋습니다. 이제 master 브랜치에는 오렌지가 있고 apples 브랜치에는 사과가 있습니다. master 브랜치로 돌아갑시다:

```
git checkout master
```

`breakfast.txt` 안에는 기본 텍스트인 오렌지가 표시되어야 합니다. 지금 제철이므로 포도로 바꿔 봅시다:

```
pancakes
waffles
grapes
```

저장, 추가, 그리고 커밋합니다:

```
git add .
git commit -m "Grapes not oranges"
```

이제 apples 브랜치를 master 브랜치에 병합할 준비가 되었습니다:

```
git merge apples
```

다음과 같은 오류가 표시되어야 합니다:

```
Auto-merging breakfast.txt
CONFLICT (content): Merge conflict in breakfast.txt
Automatic merge failed; fix conflicts and then commit the result.
```

충돌, 좋습니다! 새로 구성한 `mergetool`을 사용하여 충돌을 해결해 봅시다. 다음을 실행하세요:

```
git mergetool
```

Vim은 네 개의 창을 표시합니다. 상단 세 개에 주목하세요:

- `LOCAL`은 `grapes`를 포함합니다. 이것은 "로컬"의 변경 사항이며, 병합 대상입니다.
- `BASE`는 `oranges`를 포함합니다. 이것은 `LOCAL`과 `REMOTE` 사이의 공통 조상으로, 어떻게 분기되었는지 비교하는 데 사용됩니다.
- `REMOTE`는 `apples`를 포함합니다. 이것은 병합되는 대상입니다.

하단(네 번째 창)에는 다음이 표시됩니다:

```
pancakes
waffles
<<<<<<< HEAD
grapes
||||||| db63958
oranges
=======
apples
>>>>>>> apples
```

네 번째 창에는 병합 충돌 텍스트가 포함되어 있습니다. 이 설정으로, 각 환경이 어떤 변경 사항을 가지고 있는지 더 쉽게 볼 수 있습니다. `LOCAL`, `BASE`, `REMOTE`의 내용을 동시에 볼 수 있습니다.

커서는 네 번째 창의 강조 표시된 영역에 있어야 합니다. `LOCAL`(포도)에서 변경 사항을 가져오려면 `:diffget LOCAL`을 실행하세요. `BASE`(오렌지)에서 변경 사항을 가져오려면 `:diffget BASE`를, `REMOTE`(사과)에서 변경 사항을 가져오려면 `:diffget REMOTE`를 실행하세요.

이 경우, `LOCAL`에서 변경 사항을 가져옵시다. `:diffget LOCAL`을 실행하세요. 이제 네 번째 창에는 포도가 표시됩니다. 완료되면 모든 파일을 저장하고 종료하세요(`:wqall`). 나쁘지 않았죠?

이제 `breakfast.txt.orig` 파일도 있다는 것을 알 수 있습니다. Git은 일이 잘 풀리지 않을 경우를 대비하여 백업 파일을 만듭니다. 병합 중에 git이 백업을 만들지 않게 하려면 다음을 실행하세요:

```
git config --global mergetool.keepBackup false
```

## Vim 내부의 Git

Vim에는 내장된 기본 git 기능이 없습니다. Vim에서 git 명령어를 실행하는 한 가지 방법은 커맨드-라인 모드에서 느낌표 연산자 `!`를 사용하는 것입니다.

모든 git 명령어는 `!`로 실행할 수 있습니다:

```
:!git status
:!git commit
:!git diff
:!git push origin master
```

Vim의 `%`(현재 버퍼) 또는 `#`(다른 버퍼) 관례도 사용할 수 있습니다:

```
:!git add %         " 현재 파일 git add
:!git checkout #    " 다른 파일 git checkout
```

다른 Vim 창에 있는 여러 파일을 추가하는 데 사용할 수 있는 한 가지 Vim 트릭은 다음을 실행하는 것입니다:

```
:windo !git add %
```

그런 다음 커밋을 만듭니다:

```
:!git commit "Just git-added everything in my Vim window, cool"
```

`windo` 명령어는 이전에 본 `argdo`와 유사한 Vim의 "do" 명령어 중 하나입니다. `windo`는 각 창에서 명령어를 실행합니다.

또는, 작업 흐름에 따라 `bufdo !git add %`를 사용하여 모든 버퍼를 git add하거나 `argdo !git add %`를 사용하여 모든 파일 인수를 git add할 수도 있습니다.

## 플러그인

git 지원을 위한 많은 Vim 플러그인이 있습니다. 다음은 Vim을 위한 인기 있는 git 관련 플러그인 목록입니다 (이 글을 읽을 때쯤에는 아마 더 많을 것입니다):

- [vim-gitgutter](https://github.com/airblade/vim-gitgutter)
- [vim-signify](https://github.com/mhinz/vim-signify)
- [vim-fugitive](https://github.com/tpope/vim-fugitive)
- [gv.vim](https://github.com/junegunn/gv.vim)
- [vimagit](https://github.com/jreybert/vimagit)
- [vim-twiggy](https://github.com/sodapopcan/vim-twiggy)
- [rhubarb](https://github.com/tpope/vim-rhubarb)

가장 인기 있는 것 중 하나는 vim-fugitive입니다. 이 장의 나머지 부분에서는 이 플러그인을 사용한 몇 가지 git 작업 흐름을 살펴보겠습니다.

## Vim-fugitive

vim-fugitive 플러그인을 사용하면 Vim 편집기를 떠나지 않고도 git CLI를 실행할 수 있습니다. 일부 명령어는 Vim 내부에서 실행할 때 더 낫다는 것을 알게 될 것입니다.

시작하려면, Vim 플러그인 관리자([vim-plug](https://github.com/junegunn/vim-plug), [vundle](https://github.com/VundleVim/Vundle.vim), [dein.vim](https://github.com/Shougo/dein.vim) 등)로 vim-fugitive를 설치하세요.

## Git Status

매개변수 없이 `:Git` 명령어를 실행하면, vim-fugitive는 git 요약 창을 표시합니다. 추적되지 않은, 스테이징되지 않은, 그리고 스테이징된 파일을 보여줍니다. 이 "`git status`" 모드에 있는 동안, 여러 가지 작업을 할 수 있습니다:
- `Ctrl-N` / `Ctrl-P` 파일 목록을 위아래로 이동합니다.
- `-` 커서 아래의 파일 이름을 스테이징하거나 스테이징 해제합니다.
- `s` 커서 아래의 파일 이름을 스테이징합니다.
- `u` 커서 아래의 파일 이름을 스테이징 해제합니다.
- `>` / `<` 커서 아래 파일 이름의 인라인 차이점을 표시하거나 숨깁니다.

더 많은 정보는 `:h fugitive-staging-maps`를 확인하세요.

## Git Blame

현재 파일에서 `:Git blame` 명령어를 실행하면, vim-fugitive는 분할된 블레임 창을 표시합니다. 이것은 버그가 있는 코드 줄을 작성한 사람을 찾아 그에게 소리치는 데 유용할 수 있습니다 (농담입니다).

이 "`git blame`" 모드에 있는 동안 할 수 있는 몇 가지 작업:
- `q` 블레임 창을 닫습니다.
- `A` 작성자 열의 크기를 조정합니다.
- `C` 커밋 열의 크기를 조정합니다.
- `D` 날짜/시간 열의 크기를 조정합니다.

더 많은 정보는 `:h :Git_blame`를 확인하세요.

## Gdiffsplit

`:Gdiffsplit` 명령어를 실행하면, vim-fugitive는 현재 파일의 최신 변경 사항을 인덱스 또는 작업 트리와 `vimdiff`합니다. `:Gdiffsplit <commit>`을 실행하면, vim-fugitive는 `<commit>` 안의 해당 파일과 `vimdiff`합니다.

`vimdiff` 모드에 있으므로, `:diffput`과 `:diffget`으로 차이점을 *가져오거나* *넣을* 수 있습니다.

## Gwrite 와 Gread

변경 사항을 만든 후 파일에서 `:Gwrite` 명령어를 실행하면, vim-fugitive는 변경 사항을 스테이징합니다. 이것은 `git add <current-file>`을 실행하는 것과 같습니다.

변경 사항을 만든 후 파일에서 `:Gread` 명령어를 실행하면, vim-fugitive는 파일을 변경 이전 상태로 복원합니다. 이것은 `git checkout <current-file>`을 실행하는 것과 같습니다. `:Gread`를 실행하는 한 가지 장점은 작업이 실행 취소 가능하다는 것입니다. `:Gread`를 실행한 후, 마음이 바뀌어 이전 변경 사항을 유지하고 싶다면, 실행 취소(`u`)를 실행하면 Vim이 `:Gread` 작업을 실행 취소합니다. CLI에서 `git checkout <current-file>`을 실행했다면 이것은 불가능했을 것입니다.

## Gclog

`:Gclog` 명령어를 실행하면, vim-fugitive는 커밋 히스토리를 표시합니다. 이것은 `git log` 명령어를 실행하는 것과 같습니다. Vim-fugitive는 이를 위해 Vim의 quickfix를 사용하므로, `:cnext`와 `:cprevious`를 사용하여 다음 또는 이전 로그 정보로 이동할 수 있습니다. `:copen`과 `:cclose`로 로그 목록을 열고 닫을 수 있습니다.

이 "`git log`" 모드에 있는 동안, 두 가지 작업을 할 수 있습니다:
- 트리를 봅니다.
- 부모(이전 커밋)를 방문합니다.

`git log` 명령어처럼 `:Gclog`에 인수를 전달할 수 있습니다. 프로젝트에 긴 커밋 히스토리가 있고 마지막 세 개의 커밋만 봐야 한다면, `:Gclog -3`을 실행할 수 있습니다. 커미터의 날짜를 기준으로 필터링해야 한다면, `:Gclog --after="January 1" --before="March 14"`와 같은 것을 실행할 수 있습니다.

## 더 많은 Vim-fugitive

이것들은 vim-fugitive가 할 수 있는 몇 가지 예일 뿐입니다. vim-fugitive에 대해 더 배우려면 `:h fugitive.txt`를 확인하세요. 인기 있는 git 명령어의 대부분은 아마도 vim-fugitive로 최적화되어 있을 것입니다. 문서에서 찾아보기만 하면 됩니다.

vim-fugitive의 "특별 모드"(예: `:Git` 또는 `:Git blame` 모드 내부) 중 하나에 있고 사용 가능한 단축키가 무엇인지 배우고 싶다면, `g?`를 누르세요. Vim-fugitive는 현재 있는 모드에 대한 적절한 `:help` 창을 표시합니다. 깔끔하죠!

## 현명하게 Vim과 Git 배우기

vim-fugitive가 작업 흐름에 좋은 보완책이 될 수도 있고 아닐 수도 있습니다. 그럼에도 불구하고, 위에 나열된 모든 플러그인을 확인해 보시기를 강력히 권장합니다. 제가 나열하지 않은 다른 것들도 아마 있을 것입니다. 가서 시도해보세요.

Vim-git 통합에 더 능숙해지는 한 가지 명백한 방법은 git에 대해 더 많이 읽는 것입니다. Git 자체는 방대한 주제이며 저는 그것의 일부만 보여주고 있습니다. 그것으로, *git going* (말장난을 용서하세요)하고 Vim을 사용하여 코드를 컴파일하는 방법에 대해 이야기해 봅시다!