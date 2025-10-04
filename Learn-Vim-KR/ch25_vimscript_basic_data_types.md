# Ch25. Vimscript 기본 데이터 타입

다음 몇 개의 챕터에서는 Vim의 내장 프로그래밍 언어인 Vimscript에 대해 배우게 됩니다.

새로운 언어를 배울 때 찾아봐야 할 세 가지 기본 요소가 있습니다:
- 원시 자료형 (Primitives)
- 조합 수단 (Means of Combination)
- 추상화 수단 (Means of Abstraction)

이번 챕터에서는 Vim의 원시 데이터 타입에 대해 배우게 됩니다.

## 데이터 타입

Vim에는 10가지 다른 데이터 타입이 있습니다:
- 숫자 (Number)
- 부동소수점 (Float)
- 문자열 (String)
- 리스트 (List)
- 딕셔너리 (Dictionary)
- 특수 (Special)
- 함수 참조 (Funcref)
- 잡 (Job)
- 채널 (Channel)
- 블롭 (Blob)

여기서는 처음 여섯 가지 데이터 타입을 다룰 것입니다. 27장에서는 Funcref에 대해 배우게 됩니다. Vim 데이터 타입에 대한 자세한 내용은 `:h variables`를 확인하세요.

## Ex 모드로 따라하기

Vim은 기술적으로 내장 REPL이 없지만, REPL처럼 사용할 수 있는 Ex 모드가 있습니다. `Q` 또는 `gQ`로 Ex 모드로 들어갈 수 있습니다. Ex 모드는 확장된 커맨드 라인 모드와 같습니다 (커맨드 라인 모드 명령어를 멈추지 않고 계속 입력하는 것과 같습니다). Ex 모드를 종료하려면 `:visual`을 입력하세요.

이 챕터와 이후의 Vimscript 챕터에서 코드를 따라하기 위해 `:echo` 또는 `:echom`을 사용할 수 있습니다. 이것들은 JS의 `console.log`나 Python의 `print`와 같습니다. `:echo` 명령어는 주어진 표현식을 평가하여 출력합니다. `:echom` 명령어는 동일한 작업을 수행하지만, 추가로 결과를 메시지 히스토리에 저장합니다.

```viml
:echom "hello echo message"
```

다음으로 메시지 히스토리를 볼 수 있습니다:

```
:messages
```

메시지 히스토리를 지우려면 다음을 실행하세요:

```
:messages clear
```

## 숫자 (Number)

Vim에는 10진수, 16진수, 2진수, 8진수의 네 가지 다른 숫자 타입이 있습니다. 그런데, 제가 숫자 데이터 타입이라고 말할 때, 종종 정수 데이터 타입을 의미합니다. 이 가이드에서는 숫자와 정수라는 용어를 혼용하여 사용하겠습니다.

### 10진수

여러분은 10진수 체계에 익숙할 것입니다. Vim은 양수와 음수 10진수를 모두 허용합니다. 1, -1, 10 등입니다. Vimscript 프로그래밍에서는 대부분 10진수 타입을 사용하게 될 것입니다.

### 16진수

16진수는 `0x` 또는 `0X`로 시작합니다. 연상법: He**x**adecimal.

### 2진수

2진수는 `0b` 또는 `0B`로 시작합니다. 연상법: **B**inary.

### 8진수

8진수는 `0`, `0o`, `0O`로 시작합니다. 연상법: **O**ctal.

### 숫자 출력하기

16진수, 2진수 또는 8진수 숫자를 `echo`하면 Vim은 자동으로 10진수로 변환합니다.

```viml
:echo 42
" 42를 반환합니다

:echo 052
" 42를 반환합니다

:echo 0b101010
" 42를 반환합니다

:echo 0x2A
" 42를 반환합니다
```

### 참(Truthy)과 거짓(Falsy)

Vim에서 0 값은 거짓(falsy)이고 0이 아닌 모든 값은 참(truthy)입니다.

다음은 아무것도 출력하지 않습니다.

```viml
:if 0
:  echo "Nope"
:endif
```

하지만, 이것은 출력할 것입니다:

```viml
:if 1
:  echo "Yes"
:endif
```

0 이외의 모든 값은 음수를 포함하여 참입니다. 100은 참입니다. -1은 참입니다.

### 숫자 산술 연산

숫자는 산술 표현식을 실행하는 데 사용될 수 있습니다:

```viml
:echo 3 + 1
" 4를 반환합니다

: echo 5 - 3
" 2를 반환합니다

:echo 2 * 2
" 4를 반환합니다

:echo 4 / 2
" 2를 반환합니다
```

나머지가 있는 숫자를 나눌 때 Vim은 나머지를 버립니다.

```viml
:echo 5 / 2
" 2.5 대신 2를 반환합니다
```

더 정확한 결과를 얻으려면 부동소수점 숫자를 사용해야 합니다.

## 부동소수점 (Float)

부동소수점은 소수점 이하 자리가 있는 숫자입니다. 부동소수점 숫자를 나타내는 두 가지 방법이 있습니다: 점 표기법(예: 31.4)과 지수 표기법(3.14e01)입니다. 숫자와 마찬가지로 양수 및 음수 기호를 사용할 수 있습니다:

```viml
:echo +123.4
" 123.4를 반환합니다

:echo -1.234e2
" -123.4를 반환합니다

:echo 0.25
" 0.25를 반환합니다

:echo 2.5e-1
" 0.25를 반환합니다
```

부동소수점에는 점과 소수점 이하 숫자를 지정해야 합니다. `25e-2`(점이 없음)와 `1234.`(점은 있지만 소수점 이하 숫자가 없음)는 모두 유효하지 않은 부동소수점 숫자입니다.

### 부동소수점 산술 연산

숫자와 부동소수점 사이의 산술 표현식을 수행할 때 Vim은 결과를 부동소수점으로 강제 변환합니다.

```viml
:echo 5 / 2.0
" 2.5를 반환합니다
```

부동소수점과 부동소수점 산술 연산은 또 다른 부동소수점을 제공합니다.

```
:echo 1.0 + 1.0
" 2.0을 반환합니다
```

## 문자열 (String)

문자열은 큰따옴표(`""`) 또는 작은따옴표(`''`)로 둘러싸인 문자입니다. "Hello", "123", '123.4'는 문자열의 예입니다.

### 문자열 연결

Vim에서 문자열을 연결하려면 `.` 연산자를 사용하세요.

```viml
:echo "Hello" . " world"
" "Hello world"를 반환합니다
```

### 문자열 산술 연산

숫자와 문자열로 산술 연산자(`+ - * /`)를 실행하면 Vim은 문자열을 숫자로 강제 변환합니다.

```viml
:echo "12 donuts" + 3
" 15를 반환합니다
```

Vim이 "12 donuts"를 보면 문자열에서 12를 추출하여 숫자 12로 변환합니다. 그런 다음 덧셈을 수행하여 15를 반환합니다. 이 문자열-숫자 강제 변환이 작동하려면 숫자 문자가 문자열의 *첫 번째 문자*여야 합니다.

다음은 12가 문자열의 첫 번째 문자가 아니기 때문에 작동하지 않습니다:

```viml
:echo "donuts 12" + 3
" 3을 반환합니다
```

이것도 빈 공간이 문자열의 첫 번째 문자이기 때문에 작동하지 않습니다:

```viml
:echo " 12 donuts" + 3
" 3을 반환합니다
```

이 강제 변환은 두 개의 문자열에서도 작동합니다:

```
:echo "12 donuts" + "6 pastries"
" 18을 반환합니다
```

이것은 `+`뿐만 아니라 모든 산술 연산자에서 작동합니다:

```viml
:echo "12 donuts" * "5 boxes"
" 60을 반환합니다

:echo "12 donuts" - 5
" 7을 반환합니다

:echo "12 donuts" / "3 people"
" 4를 반환합니다
```

문자열-숫자 변환을 강제하는 깔끔한 트릭은 0을 더하거나 1을 곱하는 것입니다:

```viml
:echo "12" + 0
" 12를 반환합니다

:echo "12" * 1
" 12를 반환합니다
```

문자열의 부동소수점에 대해 산술 연산이 수행될 때 Vim은 부동소수점이 아닌 정수로 취급합니다:

```
:echo "12.0 donuts" + 12
" 24.0이 아닌 24를 반환합니다
```

### 숫자와 문자열 연결

`.` 연산자를 사용하여 숫자를 문자열로 강제 변환할 수 있습니다:

```viml
:echo 12 . "donuts"
" "12donuts"를 반환합니다
```

강제 변환은 숫자 데이터 타입에서만 작동하며 부동소수점에서는 작동하지 않습니다. 이것은 작동하지 않습니다:

```
:echo 12.0 . "donuts"
" "12.0donuts"를 반환하지 않고 오류를 발생시킵니다
```

### 문자열 조건문

0은 거짓이고 0이 아닌 모든 숫자는 참이라는 것을 기억하세요. 이것은 문자열을 조건문으로 사용할 때도 마찬가지입니다.

다음 if 문에서 Vim은 "12donuts"를 참인 12로 강제 변환합니다:

```viml
:if "12donuts"
:  echo "Yum"
:endif
" "Yum"을 반환합니다
```

반면에 이것은 거짓입니다:

```viml
:if "donuts12"
:  echo "Nope"
:endif
" 아무것도 반환하지 않습니다
```

Vim은 첫 번째 문자가 숫자가 아니기 때문에 "donuts12"를 0으로 강제 변환합니다.

### 큰따옴표 대 작은따옴표

큰따옴표는 작은따옴표와 다르게 동작합니다. 작은따옴표는 문자를 있는 그대로 표시하는 반면 큰따옴표는 특수 문자를 허용합니다.

특수 문자란 무엇일까요? 줄 바꿈 및 큰따옴표 표시를 확인하세요:

```viml
:echo "hello\nworld"
" 반환값:
" hello
" world

:echo "hello \"world\""
" "hello "world""를 반환합니다
```

작은따옴표와 비교해 보세요:

```
:echo 'hello\nworld'
" 'hello\nworld'를 반환합니다

:echo 'hello \"world\"'
" 'hello \"world\"'를 반환합니다
```

특수 문자는 이스케이프될 때 다르게 동작하는 특수 문자열 문자입니다. `\n`은 줄 바꿈처럼 작동합니다. `\"`는 리터럴 `"`처럼 작동합니다. 다른 특수 문자 목록은 `:h expr-quote`를 확인하세요.

### 문자열 프로시저

몇 가지 내장 문자열 프로시저를 살펴보겠습니다.

`strlen()`으로 문자열의 길이를 얻을 수 있습니다.

```
:echo strlen("choco")
" 5를 반환합니다
```

`str2nr()`로 문자열을 숫자로 변환할 수 있습니다:

```
:echo str2nr("12donuts")
" 12를 반환합니다

:echo str2nr("donuts12")
" 0을 반환합니다
```

이전의 문자열-숫자 강제 변환과 마찬가지로, 숫자가 첫 번째 문자가 아니면 Vim은 그것을 잡지 못합니다.

좋은 소식은 Vim에는 문자열을 부동소수점으로 변환하는 메서드인 `str2float()`가 있다는 것입니다:

```
:echo str2float("12.5donuts")
" 12.5를 반환합니다
```

`substitute()` 메서드로 문자열의 패턴을 대체할 수 있습니다:

```
:echo substitute("sweet", "e", "o", "g")
" "swoot"를 반환합니다
```

마지막 매개변수인 "g"는 전역 플래그입니다. 이것을 사용하면 Vim은 일치하는 모든 항목을 대체합니다. 이것이 없으면 Vim은 첫 번째 일치 항목만 대체합니다.

```
:echo substitute("sweet", "e", "o", "")
" "swoet"를 반환합니다
```

substitute 명령어는 `getline()`과 결합될 수 있습니다. `getline()` 함수는 주어진 줄 번호의 텍스트를 가져온다는 것을 기억하세요. 5번 줄에 "chocolate donut"이라는 텍스트가 있다고 가정해 봅시다. 다음 프로시저를 사용할 수 있습니다:

```
:echo substitute(getline(5), "chocolate", "glazed", "g")
" glazed donut을 반환합니다
```

다른 많은 문자열 프로시저가 있습니다. `:h string-functions`를 확인하세요.

## 리스트 (List)

Vimscript 리스트는 Javascript의 배열이나 Python의 리스트와 같습니다. 항목의 *정렬된* 시퀀스입니다. 내용을 다른 데이터 타입과 혼합할 수 있습니다:

```
[1,2,3]
['a', 'b', 'c']
[1,'a', 3.14]
[1,2,[3,4]]
```

### 서브리스트

Vim 리스트는 0-인덱스입니다. `[n]`을 사용하여 리스트의 특정 항목에 액세스할 수 있습니다. 여기서 n은 인덱스입니다.

```
:echo ["a", "sweet", "dessert"][0]
" "a"를 반환합니다

:echo ["a", "sweet", "dessert"][2]
" "dessert"를 반환합니다
```

최대 인덱스 번호를 초과하면 Vim은 인덱스가 범위를 벗어났다는 오류를 발생시킵니다:

```
:echo ["a", "sweet", "dessert"][999]
" 오류를 반환합니다
```

0 미만으로 가면 Vim은 마지막 요소부터 인덱스를 시작합니다. 최소 인덱스 번호를 지나가도 오류가 발생합니다:

```
:echo ["a", "sweet", "dessert"][-1]
" "dessert"를 반환합니다

:echo ["a", "sweet", "dessert"][-3]
" "a"를 반환합니다

:echo ["a", "sweet", "dessert"][-999]
" 오류를 반환합니다
```

`[n:m]`을 사용하여 리스트에서 여러 요소를 "슬라이스"할 수 있습니다. 여기서 `n`은 시작 인덱스이고 `m`은 끝 인덱스입니다.

```
:echo ["chocolate", "glazed", "plain", "strawberry", "lemon", "sugar", "cream"][2:4]
" ["plain", "strawberry", "lemon"]을 반환합니다
```

`m`을 전달하지 않으면(`[n:]`), Vim은 n번째 요소부터 나머지 요소를 반환합니다. `n`을 전달하지 않으면(`[:m]`), Vim은 첫 번째 요소부터 m번째 요소까지 반환합니다.

```
:echo ["chocolate", "glazed", "plain", "strawberry", "lemon", "sugar", "cream"][2:]
" ['plain', 'strawberry', 'lemon', 'sugar', 'cream']을 반환합니다

:echo ["chocolate", "glazed", "plain", "strawberry", "lemon", "sugar", "cream"][:4]
" ['chocolate', 'glazed', 'plain', 'strawberry', 'lemon']을 반환합니다
```

배열을 슬라이스할 때 최대 항목을 초과하는 인덱스를 전달할 수 있습니다.

```viml
:echo ["chocolate", "glazed", "plain", "strawberry", "lemon", "sugar", "cream"][2:999]
" ['plain', 'strawberry', 'lemon', 'sugar', 'cream']을 반환합니다
```

### 문자열 슬라이싱

리스트처럼 문자열을 슬라이스하고 타겟팅할 수 있습니다:

```viml
:echo "choco"[0]
" "c"를 반환합니다

:echo "choco"[1:3]
" "hoc"를 반환합니다

:echo "choco"[:3]
" choc를 반환합니다

:echo "choco"[1:]
" hoco를 반환합니다
```

### 리스트 산술 연산

`+`를 사용하여 리스트를 연결하고 변경할 수 있습니다:

```viml
:let sweetList = ["chocolate", "strawberry"]
:let sweetList += ["sugar"]
:echo sweetList
" ["chocolate", "strawberry", "sugar"]를 반환합니다
```

### 리스트 함수

Vim의 내장 리스트 함수를 살펴보겠습니다.

리스트의 길이를 얻으려면 `len()`을 사용하세요:

```
:echo len(["chocolate", "strawberry"])
" 2를 반환합니다
```

리스트에 요소를 추가하려면 `insert()`를 사용할 수 있습니다:

```
:let sweetList = ["chocolate", "strawberry"]
:call insert(sweetList, "glazed")

:echo sweetList
" ["glazed", "chocolate", "strawberry"]를 반환합니다
```

`insert()`에 요소를 추가할 인덱스를 전달할 수도 있습니다. 두 번째 요소(인덱스 1) 앞에 항목을 추가하려면:

```
:let sweeterList = ["glazed", "chocolate", "strawberry"]
:call insert(sweeterList, "cream", 1)

:echo sweeterList
" ['glazed', 'cream', 'chocolate', 'strawberry']를 반환합니다
```

리스트 항목을 제거하려면 `remove()`를 사용하세요. 제거하려는 리스트와 요소 인덱스를 받습니다.

```
:let sweeterList = ["glazed", "chocolate", "strawberry"]
:call remove(sweeterList, 1)

:echo sweeterList
" ['glazed', 'strawberry']를 반환합니다
```

리스트에서 `map()`과 `filter()`를 사용할 수 있습니다. "choco" 구문을 포함하는 요소를 필터링하려면:

```
:let sweeterList = ["glazed", "chocolate", "strawberry"]
:call filter(sweeterList, 'v:val !~ "choco"')
:echo sweeterList
" ["glazed", "strawberry"]를 반환합니다

:let sweetestList = ["chocolate", "glazed", "sugar"]
:call map(sweetestList, 'v:val . " donut"')
:echo sweetestList
" ['chocolate donut', 'glazed donut', 'sugar donut']을 반환합니다
```

`v:val` 변수는 Vim 특수 변수입니다. `map()` 또는 `filter()`를 사용하여 리스트나 딕셔너리를 반복할 때 사용할 수 있습니다. 각 반복된 항목을 나타냅니다.

자세한 내용은 `:h list-functions`를 확인하세요.

### 리스트 언패킹

리스트를 언패킹하고 변수를 리스트 항목에 할당할 수 있습니다:

```
:let favoriteFlavor = ["chocolate", "glazed", "plain"]
:let [flavor1, flavor2, flavor3] = favoriteFlavor

:echo flavor1
" "chocolate"를 반환합니다

:echo flavor2
" "glazed"를 반환합니다
```

나머지 리스트 항목을 할당하려면 `;` 다음에 변수 이름을 사용할 수 있습니다:

```
:let favoriteFruits = ["apple", "banana", "lemon", "blueberry", "raspberry"]
:let [fruit1, fruit2; restFruits] = favoriteFruits

:echo fruit1
" "apple"를 반환합니다

:echo restFruits
" ['lemon', 'blueberry', 'raspberry']를 반환합니다
```

### 리스트 수정

리스트 항목을 직접 수정할 수 있습니다:

```
:let favoriteFlavor = ["chocolate", "glazed", "plain"]
:let favoriteFlavor[0] = "sugar"
:echo favoriteFlavor
" ['sugar', 'glazed', 'plain']을 반환합니다
```

여러 리스트 항목을 직접 변경할 수 있습니다:

```
:let favoriteFlavor = ["chocolate", "glazed", "plain"]
:let favoriteFlavor[2:] = ["strawberry", "chocolate"]
:echo favoriteFlavor
" ['chocolate', 'glazed', 'strawberry', 'chocolate']를 반환합니다
```

## 딕셔너리 (Dictionary)

Vimscript 딕셔너리는 연관된, 정렬되지 않은 리스트입니다. 비어 있지 않은 딕셔너리는 최소한 하나의 키-값 쌍으로 구성됩니다.

```
{"breakfast": "waffles", "lunch": "pancakes"}
{"meal": ["breakfast", "second breakfast", "third breakfast"]}
{"dinner": 1, "dessert": 2}
```

Vim 딕셔너리 데이터 객체는 키에 문자열을 사용합니다. 숫자를 사용하려고 하면 Vim은 문자열로 강제 변환합니다.

```
:let breakfastNo = {1: "7am", 2: "9am", "11ses": "11am"}

:echo breakfastNo
" {'1': '7am', '2': '9am', '11ses': '11am'}를 반환합니다
```

각 키 주위에 따옴표를 넣기 귀찮다면 `#{}` 표기법을 사용할 수 있습니다:

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}

:echo mealPlans
" {'lunch': 'pancakes', 'breakfast': 'waffles', 'dinner': 'donuts'}를 반환합니다
```

`#{}` 구문을 사용하기 위한 유일한 요구 사항은 각 키가 다음 중 하나여야 한다는 것입니다:

- ASCII 문자.
- 숫자.
- 밑줄 (`_`).
- 하이픈 (`-`).

리스트와 마찬가지로 값으로 모든 데이터 타입을 사용할 수 있습니다.

```
:let mealPlan = {"breakfast": ["pancake", "waffle", "hash brown"], "lunch": WhatsForLunch(), "dinner": {"appetizer": "gruel", "entree": "more gruel"}}
```

### 딕셔너리 접근

딕셔너리에서 값에 접근하려면 대괄호(`['key']`) 또는 점 표기법(`.key`)으로 키를 호출할 수 있습니다.

```
:let meal = {"breakfast": "gruel omelettes", "lunch": "gruel sandwiches", "dinner": "more gruel"}

:let breakfast = meal['breakfast']
:let lunch = meal.lunch

:echo breakfast
" "gruel omelettes"를 반환합니다

:echo lunch
" "gruel sandwiches"를 반환합니다
```

### 딕셔너리 수정

딕셔너리 내용을 수정하거나 추가할 수도 있습니다:

```
:let meal = {"breakfast": "gruel omelettes", "lunch": "gruel sandwiches"}

:let meal.breakfast = "breakfast tacos"
:let meal["lunch"] = "tacos al pastor"
:let meal["dinner"] = "quesadillas"

:echo meal
" {'lunch': 'tacos al pastor', 'breakfast': 'breakfast tacos', 'dinner': 'quesadillas'}를 반환합니다
```

### 딕셔너리 함수

딕셔너리를 처리하기 위한 Vim의 내장 함수 몇 가지를 살펴보겠습니다.

딕셔너리의 길이를 확인하려면 `len()`을 사용하세요.

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}

:echo len(meaPlans)
" 3을 반환합니다
```

딕셔너리가 특정 키를 포함하는지 확인하려면 `has_key()`를 사용하세요.

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}

:echo has_key(mealPlans, "breakfast")
" 1을 반환합니다

:echo has_key(mealPlans, "dessert")
" 0을 반환합니다
```

딕셔너리에 항목이 있는지 확인하려면 `empty()`를 사용하세요. `empty()` 프로시저는 리스트, 딕셔너리, 문자열, 숫자, 부동소수점 등 모든 데이터 타입에서 작동합니다.

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}
:let noMealPlan = {}

:echo empty(noMealPlan)
" 1을 반환합니다

:echo empty(mealPlans)
" 0을 반환합니다
```

딕셔너리에서 항목을 제거하려면 `remove()`를 사용하세요.

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}

:echo "removing breakfast: " . remove(mealPlans, "breakfast")
" "removing breakfast: 'waffles'""를 반환합니다

:echo mealPlans
" {'lunch': 'pancakes', 'dinner': 'donuts'}를 반환합니다
```

딕셔너리를 리스트의 리스트로 변환하려면 `items()`를 사용하세요:

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}

:echo items(mealPlans)
" [['lunch', 'pancakes'], ['breakfast', 'waffles'], ['dinner', 'donuts']]를 반환합니다
```

`filter()`와 `map()`도 사용할 수 있습니다.

```
:let breakfastNo = {1: "7am", 2: "9am", "11ses": "11am"}
:call filter(breakfastNo, 'v:key > 1')

:echo breakfastNo
" {'2': '9am', '11ses': '11am'}를 반환합니다
```

딕셔너리는 키-값 쌍을 포함하므로 Vim은 `v:val`과 유사하게 작동하는 `v:key` 특수 변수를 제공합니다. 딕셔너리를 반복할 때 `v:key`는 현재 반복되는 키의 값을 보유합니다.

`mealPlans` 딕셔너리가 있는 경우 `v:key`를 사용하여 매핑할 수 있습니다.

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}
:call map(mealPlans, 'v:key . " and milk"')

:echo mealPlans
" {'lunch': 'lunch and milk', 'breakfast': 'breakfast and milk', 'dinner': 'dinner and milk'}를 반환합니다
```

마찬가지로 `v:val`을 사용하여 매핑할 수 있습니다:

```
:let mealPlans = #{breakfast: "waffles", lunch: "pancakes", dinner: "donuts"}
:call map(mealPlans, 'v:val . " and milk"')

:echo mealPlans
" {'lunch': 'pancakes and milk', 'breakfast': 'waffles and milk', 'dinner': 'donuts and milk'}를 반환합니다
```

더 많은 딕셔너리 함수를 보려면 `:h dict-functions`를 확인하세요.

## 특수 원시 자료형 (Special Primitives)

Vim에는 특수 원시 자료형이 있습니다:

- `v:false`
- `v:true`
- `v:none`
- `v:null`

참고로, `v:`는 Vim의 내장 변수입니다. 나중 챕터에서 더 자세히 다룰 것입니다.

제 경험상, 이러한 특수 원시 자료형을 자주 사용하지는 않을 것입니다. 참/거짓 값이 필요하면 0(거짓)과 0이 아닌 값(참)을 사용하면 됩니다. 빈 문자열이 필요하면 `""`를 사용하면 됩니다. 하지만 알아두면 좋습니다. 간단히 살펴보겠습니다.

### True

이것은 `true`와 같습니다. 0이 아닌 값을 가진 숫자와 같습니다. `json_encode()`로 json을 디코딩할 때 "true"로 해석됩니다.

```
:echo json_encode({"test": v:true})
" {"test": true}를 반환합니다
```

### False

이것은 `false`와 같습니다. 0 값을 가진 숫자와 같습니다. `json_encode()`로 json을 디코딩할 때 "false"로 해석됩니다.

```
:echo json_encode({"test": v:false})
" {"test": false}를 반환합니다
```

### None

빈 문자열과 같습니다. `json_encode()`로 json을 디코딩할 때 빈 항목(`null`)으로 해석됩니다.

```
:echo json_encode({"test": v:none})
" {"test": null}를 반환합니다
```

### Null

`v:none`과 유사합니다.

```
:echo json_encode({"test": v:null})
" {"test": null}를 반환합니다
```

## 똑똑하게 데이터 타입 배우기

이번 챕터에서는 Vimscript의 기본 데이터 타입인 숫자, 부동소수점, 문자열, 리스트, 딕셔너리, 특수 자료형에 대해 배웠습니다. 이것들을 배우는 것은 Vimscript 프로그래밍을 시작하는 첫 단계입니다.

다음 챕터에서는 등식, 조건문, 루프와 같은 표현식을 작성하기 위해 이것들을 조합하는 방법을 배우게 됩니다.