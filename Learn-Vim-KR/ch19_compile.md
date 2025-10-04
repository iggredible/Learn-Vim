# Ch19. 컴파일

컴파일은 많은 언어에서 중요한 주제입니다. 이 장에서는 Vim에서 컴파일하는 방법을 배웁니다. 또한 Vim의 `:make` 명령어를 활용하는 방법도 살펴볼 것입니다.

## 커맨드 라인에서 컴파일하기

느낌표 연산자(`!`)를 사용하여 컴파일할 수 있습니다. `.cpp` 파일을 `g++`로 컴파일해야 하는 경우 다음을 실행하세요:

```
:!g++ hello.cpp -o hello
```

하지만 매번 파일 이름과 출력 파일 이름을 수동으로 입력하는 것은 오류가 발생하기 쉽고 지루합니다. makefile을 사용하는 것이 좋습니다.

## Make 명령어

Vim에는 makefile을 실행하는 `:make` 명령어가 있습니다. 이 명령어를 실행하면 Vim은 현재 디렉토리에서 실행할 makefile을 찾습니다.

현재 디렉토리에 `makefile`이라는 파일을 만들고 그 안에 다음을 넣으세요:

```
all:
	echo "Hello all"
foo:
	echo "Hello foo"
list_pls:
	ls
```

Vim에서 다음을 실행하세요:

```
:make
```

Vim은 터미널에서 실행하는 것과 동일한 방식으로 실행합니다. `:make` 명령어는 터미널 make 명령어와 마찬가지로 매개변수를 받습니다. 다음을 실행하세요:

```
:make foo
" "Hello foo" 출력

:make list_pls
" ls 명령어 결과 출력
```

`:make` 명령어는 잘못된 명령어를 실행할 경우 오류를 저장하기 위해 Vim의 quickfix를 사용합니다. 존재하지 않는 타겟을 실행해 봅시다:

```
:make dontexist
```

해당 명령어를 실행하면 오류가 표시되어야 합니다. 해당 오류를 보려면 quickfix 명령어 `:copen`을 실행하여 quickfix 창을 봅니다:

```
|| make: *** No rule to make target `dontexist'.  Stop.
```

## Make로 컴파일하기

makefile을 사용하여 기본 `.cpp` 프로그램을 컴파일해 봅시다. 먼저 `hello.cpp` 파일을 만들어 봅시다:

```
#include <iostream>

int main() {
    std::cout << "Hello!\n";
    return 0;
}
```

makefile을 업데이트하여 `.cpp` 파일을 빌드하고 실행하도록 합니다:

```
all:
	echo "build, run"
build:
	g++ hello.cpp -o hello
run:
	./hello
```

이제 다음을 실행하세요:

```
:make build
```

`g++`는 `./hello.cpp`를 컴파일하고 `./hello`를 생성합니다. 그런 다음 다음을 실행하세요:

```
:make run
```

터미널에 `"Hello!"`가 출력되는 것을 볼 수 있습니다.

## 다른 Make 프로그램

`:make`를 실행하면 Vim은 실제로 `makeprg` 옵션 아래에 설정된 모든 명령어를 실행합니다. `:set makeprg?`를 실행하면 다음을 볼 수 있습니다:

```
makeprg=make
```

기본 `:make` 명령어는 `make` 외부 명령어입니다. `:make` 명령어를 실행할 때마다 `g++ {your-file-name}`을 실행하도록 변경하려면 다음을 실행하세요:

```
:set makeprg=g++\ %
```

`\`는 `g++` 뒤의 공백을 이스케이프하기 위한 것입니다. Vim에서 `%` 기호는 현재 파일을 나타냅니다. `g++\\ %` 명령어는 `g++ hello.cpp`를 실행하는 것과 같습니다.

`./hello.cpp`로 이동한 다음 `:make`를 실행하세요. 출력을 지정하지 않았기 때문에 Vim은 `hello.cpp`를 컴파일하고 `a.out`을 생성합니다. 컴파일된 출력의 이름을 확장자를 뺀 원본 파일의 이름으로 지정하도록 리팩토링해 봅시다. 다음을 실행하거나 vimrc에 추가하세요:

```
set makeprg=g++\ %\ -o\ %<
```

분석:
- `g++\ %`는 위와 동일합니다. `g++ <your-file>`을 실행하는 것과 같습니다.
- `-o`는 출력 옵션입니다.
- Vim에서 `%<`는 확장자가 없는 현재 파일 이름을 나타냅니다(`hello.cpp`는 `hello`가 됨).

`./hello.cpp` 내부에서 `:make`를 실행하면 `./hello`로 컴파일됩니다. `./hello.cpp` 내부에서 `./hello`를 빠르게 실행하려면 `:!./%<`를 실행하세요. 다시 말하지만, 이것은 `:!./{current-file-name-minus-the-extension}`을 실행하는 것과 같습니다.

더 많은 정보는 `:h :compiler` 및 `:h write-compiler-plugin`을 확인하세요.

## 저장 시 자동 컴파일

컴파일을 자동화하여 삶을 훨씬 더 쉽게 만들 수 있습니다. Vim의 `autocmd`를 사용하여 특정 이벤트를 기반으로 자동 작업을 트리거할 수 있다는 것을 상기하세요. 각 저장 시 `.cpp` 파일을 자동으로 컴파일하려면 vimrc에 다음을 추가하세요:

```
autocmd BufWritePost *.cpp make
```

`.cpp` 파일 내부에서 저장할 때마다 Vim은 `make` 명령어를 실행합니다.

## 컴파일러 전환하기

Vim에는 컴파일러를 빠르게 전환하는 `:compiler` 명령어가 있습니다. 여러분의 Vim 빌드에는 아마도 여러 개의 사전 빌드된 컴파일러 구성이 함께 제공될 것입니다. 어떤 컴파일러가 있는지 확인하려면 다음을 실행하세요:

```
:e $VIMRUNTIME/compiler/<Tab>
```

다른 프로그래밍 언어에 대한 컴파일러 목록을 볼 수 있습니다.

`:compiler` 명령어를 사용하려면, `hello.rb`라는 루비 파일이 있고 그 안에 다음이 있다고 가정해 봅시다:

```
puts "Hello ruby"
```

`:make`를 실행하면 Vim은 `makeprg`에 할당된 모든 명령어를 실행한다는 것을 상기하세요(기본값은 `make`). 다음을 실행하면:

```
:compiler ruby
```

Vim은 `$VIMRUNTIME/compiler/ruby.vim` 스크립트를 실행하고 `makeprg`를 `ruby` 명령어를 사용하도록 변경합니다. 이제 `:set makeprg?`를 실행하면 `makeprg=ruby`라고 표시되어야 합니다(이것은 `$VIMRUNTIME/compiler/ruby.vim` 파일의 내용이나 다른 사용자 지정 루비 컴파일러가 있는지 여부에 따라 다릅니다. 여러분의 것은 다를 수 있습니다). `:compiler {your-lang}` 명령어는 다른 컴파일러로 빠르게 전환할 수 있게 해줍니다. 이것은 프로젝트가 여러 언어를 사용하는 경우 유용합니다.

프로그램을 컴파일하기 위해 `:compiler`와 `makeprg`를 사용할 필요는 없습니다. 테스트 스크립트를 실행하거나, 파일을 린트하거나, 신호를 보내거나, 원하는 모든 것을 할 수 있습니다.

## 사용자 지정 컴파일러 만들기

간단한 타입스크립트 컴파일러를 만들어 봅시다. 컴퓨터에 타입스크립트(`npm install -g typescript`)를 설치하세요. 이제 `tsc` 명령어를 사용할 수 있습니다. 이전에 타입스크립트를 다뤄본 적이 없다면, `tsc`는 타입스크립트 파일을 자바스크립트 파일로 컴파일합니다. `hello.ts`라는 파일이 있다고 가정해 봅시다:

```
const hello = "hello";
console.log(hello);
```

`tsc hello.ts`를 실행하면 `hello.js`로 컴파일됩니다. 하지만, `hello.ts` 안에 다음과 같은 표현식이 있다면:

```
const hello = "hello";
hello = "hello again";
console.log(hello);
```

`const` 변수를 변경할 수 없기 때문에 오류가 발생합니다. `tsc hello.ts`를 실행하면 다음과 같은 오류가 발생합니다:

```
hello.ts:2:1 - error TS2588: Cannot assign to 'person' because it is a constant.

2 person = "hello again";
  ~~~~~~


Found 1 error.
```

간단한 타입스크립트 컴파일러를 만들려면, `~/.vim/` 디렉토리에 `compiler` 디렉토리(`~/.vim/compiler/`)를 추가한 다음, `typescript.vim` 파일(`~/.vim/compiler/typescript.vim`)을 만듭니다. 그 안에 다음을 넣으세요:

```
CompilerSet makeprg=tsc
CompilerSet errorformat=%f:\ %m
```

첫 번째 줄은 `makeprg`를 `tsc` 명령어를 실행하도록 설정합니다. 두 번째 줄은 오류 형식을 파일(`%f`), 그 다음에 리터럴 콜론(`:`), 이스케이프된 공백(`\ `), 그 다음에 오류 메시지(`%m`)를 표시하도록 설정합니다. 오류 서식에 대해 더 배우려면 `:h errorformat`을 확인하세요.

다른 사람들이 어떻게 하는지 보려면 미리 만들어진 컴파일러 중 일부를 읽어보는 것도 좋습니다. `:e $VIMRUNTIME/compiler/<some-language>.vim`을 확인하세요.

일부 플러그인이 타입스크립트 파일을 방해할 수 있으므로, `--noplugin` 플래그를 사용하여 플러그인 없이 `hello.ts`를 엽시다:

```
vim --noplugin hello.ts
```

`makeprg`를 확인하세요:

```
:set makeprg?
```

기본 `make` 프로그램이라고 표시되어야 합니다. 새로운 타입스크립트 컴파일러를 사용하려면 다음을 실행하세요:

```
:compiler typescript
```

`:set makeprg?`를 실행하면 이제 `tsc`라고 표시되어야 합니다. 테스트해 봅시다. 다음을 실행하세요:

```
:make %
```

`%`가 현재 파일을 의미한다는 것을 상기하세요. 타입스크립트 컴파일러가 예상대로 작동하는 것을 지켜보세요! 오류 목록을 보려면 `:copen`을 실행하세요.

## 비동기 컴파일러

때때로 컴파일하는 데 시간이 오래 걸릴 수 있습니다. 컴파일 프로세스가 끝날 때까지 멈춘 Vim을 쳐다보고 싶지는 않을 것입니다. 컴파일 중에 여전히 Vim을 사용할 수 있도록 비동기적으로 컴파일할 수 있다면 좋지 않을까요?

다행히 비동기 프로세스를 실행하는 플러그인이 있습니다. 두 가지 주요 플러그인은 다음과 같습니다:

- [vim-dispatch](https://github.com/tpope/vim-dispatch)
- [asyncrun.vim](https://github.com/skywind3000/asyncrun.vim)

이 장의 나머지 부분에서는 vim-dispatch에 대해 살펴보겠지만, 다른 모든 플러그인도 시도해 보시기를 강력히 권장합니다.

*Vim과 NeoVim은 실제로 비동기 작업을 지원하지만, 이 장의 범위를 벗어납니다. 궁금하다면 `:h job-channel-overview.txt`를 확인하세요.*

## 플러그인: Vim-dispatch

Vim-dispatch에는 여러 명령어가 있지만, 두 가지 주요 명령어는 `:Make`와 `:Dispatch` 명령어입니다.

### 비동기 Make

Vim-dispatch의 `:Make` 명령어는 Vim의 `:make`와 유사하지만, 비동기적으로 실행됩니다. 자바스크립트 프로젝트에 있고 `npm t`를 실행해야 하는 경우, makeprg를 다음과 같이 설정하려고 시도할 수 있습니다:

```
:set makeprg=npm\\ t
```

다음을 실행하면:

```
:make
```

Vim은 `npm t`를 실행하지만, 자바스크립트 테스트가 실행되는 동안 멈춘 화면을 쳐다보게 될 것입니다. vim-dispatch를 사용하면 다음을 실행하기만 하면 됩니다:

```
:Make
```

Vim은 `npm t`를 비동기적으로 실행합니다. 이렇게 하면, `npm t`가 백그라운드 프로세스에서 실행되는 동안, 하던 일을 계속할 수 있습니다. 멋지죠!

### 비동기 Dispatch

`:Dispatch` 명령어는 `:compiler` 및 `:!` 명령어와 같습니다. Vim에서 모든 외부 명령어를 비동기적으로 실행할 수 있습니다.

루비 스펙 파일 안에 있고 테스트를 실행해야 한다고 가정해 봅시다. 다음을 실행하세요:

```
:Dispatch bundle exec rspec %
```

Vim은 현재 파일(`%`)에 대해 `rspec` 명령어를 비동기적으로 실행합니다.

### Dispatch 자동화하기

Vim-dispatch에는 특정 명령어를 자동으로 평가하도록 구성할 수 있는 `b:dispatch` 버퍼 변수가 있습니다. `autocmd`와 함께 활용할 수 있습니다. vimrc에 다음을 추가하면:

```
autocmd BufEnter *_spec.rb let b:dispatch = 'bundle exec rspec %'
```

이제 `_spec.rb`로 끝나는 파일에 들어갈 때마다(`BufEnter`), `:Dispatch`를 실행하면 자동으로 `bundle exec rspec {your-current-ruby-spec-file}`이 실행됩니다.

## 현명하게 컴파일 배우기

이 장에서는 `make` 및 `compiler` 명령어를 사용하여 Vim 내부에서 *모든* 프로세스를 비동기적으로 실행하여 프로그래밍 작업 흐름을 보완할 수 있다는 것을 배웠습니다. Vim이 다른 프로그램으로 자신을 확장하는 능력은 강력합니다.