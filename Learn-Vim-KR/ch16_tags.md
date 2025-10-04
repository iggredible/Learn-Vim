# Ch16. 태그

텍스트 편집에서 유용한 기능 중 하나는 모든 정의로 빠르게 이동할 수 있는 것입니다. 이 장에서는 Vim 태그를 사용하여 그 작업을 수행하는 방법을 배웁니다.

## 태그 개요

누군가 새로운 코드베이스를 건네주었다고 가정해 봅시다:

```
one = One.new
one.donut
```

`One`? `donut`? 음, 이것들은 오래 전에 코드를 작성한 개발자들에게는 명백했을지 모르지만, 이제 그 개발자들은 더 이상 여기에 없고 이 불분명한 코드를 이해하는 것은 당신에게 달려 있습니다. 이것을 이해하는 데 도움이 되는 한 가지 방법은 `One`과 `donut`이 정의된 소스 코드를 따라가는 것입니다.

`fzf`나 `grep`(또는 `vimgrep`)으로 검색할 수 있지만, 이 경우에는 태그가 더 빠릅니다.

태그를 주소록처럼 생각해보세요:

```
이름    주소
Iggy1   1234 Cool St, 11111
Iggy2   9876 Awesome Ave, 2222
```

이름-주소 쌍을 갖는 대신, 태그는 정의와 주소를 쌍으로 저장합니다.

같은 디렉토리 안에 다음과 같은 두 개의 루비 파일이 있다고 가정해 봅시다:

```
## one.rb
class One
  def initialize
    puts "Initialized"
  end

  def donut
    puts "Bar"
  end
end
```

그리고

```
## two.rb
require './one'

one = One.new
one.donut
```

정의로 점프하려면, 일반 모드에서 `Ctrl-]`를 사용할 수 있습니다. `two.rb` 안에서, `one.donut`이 있는 줄로 가서 커서를 `donut` 위로 이동하세요. `Ctrl-]`를 누르세요.

이런, Vim이 태그 파일을 찾을 수 없었습니다. 먼저 태그 파일을 생성해야 합니다.

## 태그 생성기

최신 Vim에는 태그 생성기가 함께 제공되지 않으므로, 외부 태그 생성기를 다운로드해야 합니다. 선택할 수 있는 몇 가지 옵션이 있습니다:

- ctags = C 전용. 거의 모든 곳에서 사용 가능.
- exuberant ctags = 가장 인기 있는 것 중 하나. 많은 언어 지원.
- universal ctags = exuberant ctags와 유사하지만, 더 최신.
- etags = Emacs용. 흠...
- JTags = Java
- ptags.py = Python
- ptags = Perl
- gnatxref = Ada

온라인에서 Vim 튜토리얼을 보면, 많은 사람들이 [exuberant ctags](http://ctags.sourceforge.net/)를 추천할 것입니다. [41개의 프로그래밍 언어](http://ctags.sourceforge.net/languages.html)를 지원합니다. 저도 사용해봤고 훌륭하게 작동했습니다. 하지만, 2009년 이후로 유지보수되지 않았기 때문에, Universal ctags가 더 나은 선택일 것입니다. exuberant ctags와 유사하게 작동하며 현재 유지보수되고 있습니다.

universal ctags를 설치하는 방법에 대한 자세한 내용은 다루지 않겠습니다. 더 많은 지침은 [universal ctags](https://github.com/universal-ctags/ctags) 저장소를 확인하세요.

universal ctags가 설치되었다고 가정하고, 기본 태그 파일을 생성해 봅시다. 다음을 실행하세요:

```
ctags -R .
```

`R` 옵션은 ctags에게 현재 위치(`.`)에서 재귀적 스캔을 실행하도록 지시합니다. 현재 디렉토리에 `tags` 파일이 표시되어야 합니다. 그 안에는 다음과 같은 것이 보일 것입니다:

```
!_TAG_FILE_FORMAT	2	/extended format; --format=1 will not append ;" to lines/
!_TAG_FILE_SORTED	1	/0=unsorted, 1=sorted, 2=foldcase/
!_TAG_OUTPUT_FILESEP	slash	/slash or backslash/
!_TAG_OUTPUT_MODE	u-ctags	/u-ctags or e-ctags/
!_TAG_PATTERN_LENGTH_LIMIT	96	/0 for no limit/
!_TAG_PROGRAM_AUTHOR	Universal Ctags Team	//
!_TAG_PROGRAM_NAME	Universal Ctags	/Derived from Exuberant Ctags/
!_TAG_PROGRAM_URL	<https://ctags.io/>	/official site/
!_TAG_PROGRAM_VERSION	0.0.0	/b43eb39/
One	one.rb	/^class One$/;"	c
donut	one.rb	/^  def donut$/;"	f	class:One
initialize	one.rb	/^  def initialize$/;"	f	class:One
```

Vim 설정과 ctags 생성기에 따라 여러분의 것은 약간 다르게 보일 수 있습니다. 태그 파일은 두 부분으로 구성됩니다: 태그 메타데이터와 태그 목록입니다. 이러한 메타데이터(`!TAG_FILE...`)는 보통 ctags 생성기에 의해 제어됩니다. 여기서는 논의하지 않겠지만, 더 많은 정보를 원하시면 해당 문서를 자유롭게 확인하세요! 태그 목록은 ctags에 의해 인덱싱된 모든 정의의 목록입니다.

이제 `two.rb`로 가서, 커서를 `donut`에 놓고, `Ctrl-]`를 입력하세요. Vim은 `one.rb` 파일의 `def donut`이 있는 줄로 당신을 데려갈 것입니다. 성공! 하지만 Vim은 이것을 어떻게 했을까요?

## 태그 해부

`donut` 태그 항목을 살펴봅시다:

```
donut	one.rb	/^  def donut$/;"	f	class:One
```

위 태그 항목은 네 가지 구성 요소로 이루어져 있습니다: `tagname`, `tagfile`, `tagaddress`, 그리고 태그 옵션입니다.
- `donut`은 `tagname`입니다. 커서가 "donut" 위에 있을 때, Vim은 "donut" 문자열이 있는 줄을 태그 파일에서 검색합니다.
- `one.rb`는 `tagfile`입니다. Vim은 `one.rb` 파일을 찾습니다.
- `/^ def donut$/`는 `tagaddress`입니다. `/.../`는 패턴 표시기입니다. `^`는 줄의 첫 번째 요소에 대한 패턴입니다. 그 뒤에 두 개의 공백, 그리고 "def donut" 문자열이 옵니다. 마지막으로, `$`는 줄의 마지막 요소에 대한 패턴입니다.
- `f class:One`은 `donut` 함수가 함수(`f`)이고 `One` 클래스의 일부임을 Vim에 알려주는 태그 옵션입니다.

태그 목록의 다른 항목을 살펴봅시다:

```
One	one.rb	/^class One$/;"	c
```

이 줄은 `donut` 패턴과 동일한 방식으로 작동합니다:

- `One`은 `tagname`입니다. 태그에서는 첫 번째 스캔이 대소문자를 구분한다는 점에 유의하세요. 목록에 `One`과 `one`이 있다면, Vim은 `one`보다 `One`을 우선시합니다.
- `one.rb`는 `tagfile`입니다. Vim은 `one.rb` 파일을 찾습니다.
- `/^class One$/`는 `tagaddress` 패턴입니다. Vim은 `class`로 시작(`^`)하고 `One`으로 끝나는(`$`) 줄을 찾습니다.
- `c`는 가능한 태그 옵션 중 하나입니다. `One`은 프로시저가 아닌 루비 클래스이므로 `c`로 표시합니다.

사용하는 태그 생성기에 따라 태그 파일의 내용이 다르게 보일 수 있습니다. 최소한, 태그 파일은 다음 형식 중 하나를 가져야 합니다:

```
1.  {tagname} {TAB} {tagfile} {TAB} {tagaddress}
2.  {tagname} {TAB} {tagfile} {TAB} {tagaddress} {term} {field} ..
```

## 태그 파일

`ctags -R .`을 실행한 후 `tags`라는 새 파일이 생성된다는 것을 배웠습니다. Vim은 태그 파일을 어디서 찾아야 하는지 어떻게 알까요?

`:set tags?`를 실행하면, `tags=./tags,tags`와 같은 것을 볼 수 있습니다 (Vim 설정에 따라 다를 수 있습니다). 여기서 Vim은 `./tags`의 경우 현재 파일의 경로에 있는 모든 태그를, `tags`의 경우 현재 디렉토리(프로젝트 루트)에 있는 모든 태그를 찾습니다.

또한 `./tags`의 경우, Vim은 먼저 현재 파일이 얼마나 중첩되어 있든 상관없이 현재 파일의 경로 내에서 태그 파일을 찾은 다음, 현재 디렉토리(프로젝트 루트)의 태그 파일을 찾습니다. Vim은 첫 번째 일치 항목을 찾은 후 중지합니다.

`'tags'` 파일에 `tags=./tags,tags,/user/iggy/mytags/tags`라고 되어 있다면, Vim은 `./tags`와 `tags` 디렉토리를 검색한 후 `/user/iggy/mytags` 디렉토리에서도 태그 파일을 찾을 것입니다. 태그 파일을 프로젝트 안에 저장할 필요는 없으며, 별도로 보관할 수 있습니다.

새로운 태그 파일 위치를 추가하려면 다음을 사용하세요:

```
set tags+=path/to/my/tags/file
```

## 대규모 프로젝트를 위한 태그 생성하기

대규모 프로젝트에서 ctags를 실행하려고 하면, Vim이 모든 중첩된 디렉토리 안도 보기 때문에 시간이 오래 걸릴 수 있습니다. 자바스크립트 개발자라면 `node_modules`가 매우 클 수 있다는 것을 알 것입니다. 다섯 개의 하위 프로젝트가 있고 각각 고유한 `node_modules` 디렉토리를 포함하고 있다고 상상해보세요. `ctags -R .`을 실행하면, ctags는 5개의 `node_modules`를 모두 스캔하려고 시도할 것입니다. 아마도 `node_modules`에 대해 ctags를 실행할 필요는 없을 것입니다.

`node_modules`를 제외하고 ctags를 실행하려면 다음을 실행하세요:

```
ctags -R --exclude=node_modules .
```

이번에는 1초도 채 걸리지 않을 것입니다. 그런데, `exclude` 옵션을 여러 번 사용할 수 있습니다:

```
ctags -R --exclude=.git --exclude=vendor --exclude=node_modules --exclude=db --exclude=log .
```

요점은, 디렉토리를 생략하고 싶다면 `--exclude`가 가장 좋은 친구라는 것입니다.

## 태그 탐색

`Ctrl-]`만 사용해도 많은 것을 할 수 있지만, 몇 가지 트릭을 더 배워봅시다. 태그 점프 키 `Ctrl-]`에는 커맨드-라인 모드 대안이 있습니다: `:tag {tag-name}`. 다음을 실행하면:

```
:tag donut
```

Vim은 "donut" 문자열에서 `Ctrl-]`를 하는 것과 마찬가지로 `donut` 메소드로 점프합니다. 인수도 `<Tab>`으로 자동 완성할 수 있습니다:

```
:tag d<Tab>
```

Vim은 "d"로 시작하는 모든 태그를 나열합니다. 이 경우, "donut"입니다.

실제 프로젝트에서는 같은 이름의 여러 메소드를 만날 수 있습니다. 이전의 두 루비 파일을 업데이트해 봅시다. `one.rb` 안:

```
## one.rb
class One
  def initialize
    puts "Initialized"
  end

  def donut
    puts "one donut"
  end

  def pancake
    puts "one pancake"
  end
end
```

`two.rb` 안:

```
## two.rb
require './one.rb'

def pancake
  "Two pancakes"
end

one = One.new
one.donut
puts pancake
```

코딩을 따라하고 있다면, 이제 여러 개의 새로운 프로시저가 생겼으므로 `ctags -R .`을 다시 실행하는 것을 잊지 마세요. `pancake` 프로시저의 인스턴스가 두 개 있습니다. `two.rb` 안에 있고 `Ctrl-]`를 눌렀다면, 무슨 일이 일어날까요?

Vim은 `one.rb` 안의 `def pancake`가 아닌 `two.rb` 안의 `def pancake`로 점프할 것입니다. 이것은 Vim이 `two.rb` 안의 `pancake` 프로시저를 다른 `pancake` 프로시저보다 우선 순위가 높은 것으로 보기 때문입니다.

## 태그 우선 순위

모든 태그가 동등하지는 않습니다. 일부 태그는 더 높은 우선 순위를 가집니다. Vim에 중복된 항목 이름이 제시되면, Vim은 키워드의 우선 순위를 확인합니다. 순서는 다음과 같습니다:

1. 현재 파일의 완전히 일치하는 정적 태그.
2. 현재 파일의 완전히 일치하는 전역 태그.
3. 다른 파일의 완전히 일치하는 전역 태그.
4. 다른 파일의 완전히 일치하는 정적 태그.
5. 현재 파일의 대소문자를 구분하지 않는 일치하는 정적 태그.
6. 현재 파일의 대소문자를 구분하지 않는 일치하는 전역 태그.
7. 다른 파일의 대소문자를 구분하지 않는 일치하는 전역 태그.
8. 현재 파일의 대소문자를 구분하지 않는 일치하는 정적 태그.

우선 순위 목록에 따르면, Vim은 동일한 파일에서 발견된 정확한 일치를 우선시합니다. 이것이 Vim이 `one.rb` 안의 `pancake` 프로시저보다 `two.rb` 안의 `pancake` 프로시저를 선택하는 이유입니다. `'tagcase'`, `'ignorecase'`, `'smartcase'` 설정에 따라 위 우선 순위 목록에 몇 가지 예외가 있지만, 여기서는 논의하지 않겠습니다. 관심이 있다면 `:h tag-priority`를 확인하세요.

## 선택적 태그 점프

항상 가장 높은 우선 순위의 태그 항목으로 점프하는 대신 어떤 태그 항목으로 점프할지 선택할 수 있다면 좋을 것입니다. 실제로 `two.rb`가 아닌 `one.rb`의 `pancake` 메소드로 점프해야 할 수도 있습니다. 그렇게 하려면 `:tselect`를 사용할 수 있습니다. 다음을 실행하세요:

```
:tselect pancake
```

화면 하단에 다음이 표시됩니다:

```
## pri kind tag               file
1 F C f    pancake           two.rb
             def pancake
2 F   f    pancake           one.rb
             class:One
             def pancake
```

2를 입력하면, Vim은 `one.rb`의 프로시저로 점프합니다. 1을 입력하면, Vim은 `two.rb`의 프로시저로 점프합니다.

`pri` 열에 주목하세요. 첫 번째 일치 항목에는 `F C`가 있고 두 번째 일치 항목에는 `F`가 있습니다. 이것이 Vim이 태그 우선 순위를 결정하는 데 사용하는 것입니다. `F C`는 현재(`C`) 파일의 완전히 일치하는(`F`) 전역 태그를 의미합니다. `F`는 완전히 일치하는(`F`) 전역 태그만을 의미합니다. `F C`는 항상 `F`보다 높은 우선 순위를 가집니다.

`:tselect donut`을 실행하면, 선택할 옵션이 하나뿐임에도 불구하고 Vim은 어떤 태그 항목으로 점프할지 선택하라는 메시지를 표시합니다. 여러 일치 항목이 있는 경우에만 태그 목록을 표시하고 태그가 하나만 발견되면 즉시 점프하는 방법이 있을까요?

물론입니다! Vim에는 `:tjump` 메소드가 있습니다. 다음을 실행하세요:

```
:tjump donut
```

Vim은 `:tag donut`을 실행하는 것과 마찬가지로 즉시 `one.rb`의 `donut` 프로시저로 점프합니다. 이제 다음을 실행하세요:

```
:tjump pancake
```

Vim은 `:tselect pancake`를 실행하는 것과 마찬가지로 선택할 태그 옵션을 표시합니다. `tjump`를 사용하면 두 가지 방법의 장점을 모두 얻을 수 있습니다.

Vim에는 `tjump`에 대한 일반 모드 키가 있습니다: `g Ctrl-]`. 저는 개인적으로 `Ctrl-]`보다 `g Ctrl-]`를 더 좋아합니다.

## 태그로 자동 완성

태그는 자동 완성을 도울 수 있습니다. 6장 삽입 모드에서 `Ctrl-X` 하위 모드를 사용하여 다양한 자동 완성을 할 수 있다는 것을 상기하세요. 제가 언급하지 않은 한 가지 자동 완성 하위 모드는 `Ctrl-]`였습니다. 삽입 모드에 있는 동안 `Ctrl-X Ctrl-]`를 하면, Vim은 자동 완성을 위해 태그 파일을 사용합니다.

삽입 모드로 들어가서 `Ctrl-x Ctrl-]`를 입력하면 다음을 볼 수 있습니다:

```
One
donut
initialize
pancake
```

## 태그 스택

Vim은 당신이 점프한 모든 태그의 목록을 태그 스택에 보관합니다. `:tags`로 이 스택을 볼 수 있습니다. 먼저 `pancake`로 태그 점프한 다음 `donut`으로 점프했다면, `:tags`를 실행하면 다음을 볼 수 있습니다:

```
  # TO tag         FROM line  in file/text
  1  1 pancake            10  ch16_tags/two.rb
  2  1 donut               9  ch16_tags/two.rb
>
```

위의 `>` 기호에 주목하세요. 스택에서 현재 위치를 보여줍니다. 스택을 "팝"하여 이전 스택으로 돌아가려면 `:pop`을 실행할 수 있습니다. 시도해 본 다음, `:tags`를 다시 실행하세요:

```
  # TO tag         FROM line  in file/text
  1  1 pancake            10  puts pancake
> 2  1 donut               9  one.donut

```

`>` 기호가 이제 `donut`이 있는 2번 줄에 있다는 점에 유의하세요. 한 번 더 `pop`한 다음, `:tags`를 다시 실행하세요:

```
  # TO tag         FROM line  in file/text
> 1  1 pancake            10  puts pancake
  2  1 donut               9  one.donut
```

일반 모드에서는 `Ctrl-t`를 실행하여 `:pop`과 동일한 효과를 얻을 수 있습니다.

## 자동 태그 생성

Vim 태그의 가장 큰 단점 중 하나는 중요한 변경을 할 때마다 태그 파일을 다시 생성해야 한다는 것입니다. 최근에 `pancake` 프로시저를 `waffle` 프로시저로 이름을 바꿨다면, 태그 파일은 `pancake` 프로시저의 이름이 바뀌었다는 것을 알지 못했습니다. 여전히 `pancake`를 태그 목록에 저장하고 있었습니다. 업데이트된 태그 파일을 만들려면 `ctags -R .`을 실행해야 합니다. 이런 식으로 새 태그 파일을 다시 만드는 것은 번거로울 수 있습니다.

다행히 태그를 자동으로 생성하기 위해 사용할 수 있는 몇 가지 방법이 있습니다.

## 저장 시 태그 생성

Vim에는 이벤트 트리거 시 모든 명령어를 실행하는 자동 명령어(`autocmd`) 메소드가 있습니다. 이것을 사용하여 각 저장 시 태그를 생성할 수 있습니다. 다음을 실행하세요:

```
:autocmd BufWritePost *.rb silent !ctags -R .
```

분석:
- `autocmd`는 커맨드-라인 명령어입니다. 이벤트, 파일 패턴, 명령어를 받습니다.
- `BufWritePost`는 버퍼 저장에 대한 이벤트입니다. 파일을 저장할 때마다 `BufWritePost` 이벤트를 트리거합니다.
- `.rb`는 루비 파일에 대한 파일 패턴입니다.
- `silent`는 실제로 전달하는 명령어의 일부입니다. 이것이 없으면, 자동 명령어를 트리거할 때마다 Vim은 `press ENTER or type command to continue`를 표시합니다.
- `!ctags -R .`은 실행할 명령어입니다. Vim 내부에서 `!cmd`는 터미널 명령어를 실행한다는 것을 상기하세요.

이제 루비 파일 내부에서 저장할 때마다 Vim은 `ctags -R .`을 실행합니다.

## 플러그인 사용하기

ctags를 자동으로 생성하는 몇 가지 플러그인이 있습니다:

- [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)
- [vim-tags](https://github.com/szw/vim-tags)
- [vim-easytags](https://github.com/xolox/vim-easytags)
- [vim-autotag](https://github.com/craigemery/vim-autotag)

저는 vim-gutentags를 사용합니다. 사용하기 간단하고 즉시 작동합니다.

## Ctags와 Git 훅

많은 훌륭한 Vim 플러그인의 저자인 팀 포프는 git 훅을 사용하라는 블로그 글을 썼습니다. [확인해보세요](https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html).

## 현명하게 태그 배우기

태그는 올바르게 구성되면 유용합니다. 새로운 코드베이스에 직면했고 `functionFood`가 무엇을 하는지 이해하고 싶다고 가정해 봅시다. 정의로 점프하여 쉽게 읽을 수 있습니다. 그 안에서, `functionBreakfast`도 호출한다는 것을 배웁니다. 그것을 따라가면 `functionPancake`를 호출한다는 것을 배웁니다. 함수 호출 그래프는 다음과 같을 것입니다:

```
functionFood -> functionBreakfast -> functionPancake
```

이것은 이 코드 흐름이 아침 식사로 팬케이크를 먹는 것과 관련이 있다는 통찰력을 줍니다.

태그에 대해 더 배우려면 `:h tags`를 확인하세요. 이제 태그를 사용하는 방법을 알았으니, 다른 기능인 폴딩을 탐색해 봅시다.