# Swift 메모리 관리 (Memory Management)

##  학습일
- 2026-05-13

##  OS 메모리 공간 구조

프로그램이 실행되면 OS는 메모리 공간을 네 영역으로 나누어 관리한다.

- **Code** : 기계어로 번역된 명령어(데이터)가 저장되는 영역
- **Data** : 정적(static) 변수, 전역(global) 변수가 저장되는 영역. 프로그램 시작 시 생성되고 종료 시 제거된다.
- **Heap** : 동적으로 할당되는 데이터를 저장하는 공간. 개발자가 직접 메모리를 만들고 사용한다. 일반적으로 수동 관리가 필요하지만, Swift에서는 ARC가 자동으로 메모리를 관리한다. 사용하지 않는 메모리가 해제되지 않으면 메모리 누수(Memory Leak)가 발생한다.
- **Stack** : 지역 변수, 파라미터, 리턴값 등이 저장되는 공간. 함수가 호출될 때마다 **스택 프레임(Stack Frame)** 이 생성되고, 함수가 끝나면 최근에 추가된 것부터 LIFO 방식으로 제거된다.

---

##  값 타입 (Value Type) vs 참조 타입 (Reference Type)

### 값 타입
- 구조체(struct), 열거형(enum), 튜플(tuple)이 해당
- 스택에 저장되고 값을 복사해서 전달
- Swift는 Copy on Write 로 최적화되어 있어, 값을 실제로 수정할 때까지는 복사가 일어나지 않는다. 단순히 읽기만 하면 복사되지 않는다.

```swift
struct Point {
    var x = 0.0
    var y = 0.0
}

var p1 = Point()
var p2 = p1   // 아직 실제로 복사되지 않음 (Copy on Write)

p2.x = 10.0   // 이 시점에 실제로 복사가 일어남
p2.y = 20.0

print(p1)  // Point(x: 0.0, y: 0.0)
print(p2)  // Point(x: 10.0, y: 20.0)
```

### 참조 타입
- 클래스(class)가 해당
- 힙과 스택에 하나씩 저장됨
  - 스택 : 힙에 있는 인스턴스의 메모리 주소
  - 힙 : 실제 인스턴스 값
- 변수에 할당하거나 전달하면 메모리 주소만 복사되므로, 여러 변수가 같은 인스턴스를 공유한다.

```swift
class Rectangle {
    var width = 0.0
    var height = 0.0
}

var r1 = Rectangle()  // 힙에 인스턴스 생성, r1은 해당 주소를 가짐
var r2 = r1           // 주소만 복사 → 같은 인스턴스를 공유

r2.width = 100.0
r2.height = 50.0

print(r1.width, r1.height)  // 100.0 50.0  (같은 인스턴스이므로 r1도 변경됨)
print(r2.width, r2.height)  // 100.0 50.0
```

---

##  `let`의 동작 차이

| 타입 | `let`으로 선언 시 동작 |
|------|----------------------|
| 값 타입 (struct) | 인스턴스 자체가 상수가 되어 메모리 전체가 잠김. 프로퍼티 수정 불가 |
| 참조 타입 (class) | 메모리 **주소만 잠김**. 다른 인스턴스로 교체는 불가하지만, 힙에 저장된 프로퍼티 값은 변경 가능 |

```swift
//값 타입: 인스턴스 전체가 잠김
let fixedPoint = Point()
// fixedPoint.x = 5.0  //컴파일 에러

//참조 타입: 주소만 잠김, 힙의 값은 변경 가능
let fixedRect = Rectangle()
fixedRect.width = 30.0      //가능
//fixedRect = Rectangle()  //불가
```

---

##  항등 연산자 vs 비교 연산자

- **항등 연산자 `===` / `!==`** : 두 참조가 같은 인스턴스를 가리키는지(=메모리 주소가 같은지) 비교. 참조 타입에만 사용 가능
- **비교 연산자 `==` / `!=`** : 두 대상이 같은 값을 가지는지 비교. `Equatable` 프로토콜을 따르는 타입에 사용

```swift
class Box {}

let boxA = Box()
let boxB = boxA   // 같은 인스턴스를 가리킴
let boxC = Box()  // 새로운 인스턴스

print(boxA === boxB)  // true  (같은 주소)
print(boxA === boxC)  // false (다른 주소)
print(boxA !== boxC)  // true
```

---

##  ARC (Automatic Reference Counting)

Swift의 메모리 관리 방식. 클래스 인스턴스에만 적용되며, 컴파일 타임에 retain/release 코드가 자동으로 삽입된다.

### 소유 정책 (Ownership Policy)
- 인스턴스를 변수나 상수에 저장하면 소유자(owner)** 가 생긴다.
- 인스턴스는 소유자가 한 명 이상 있어야 메모리에 유지된다.

### 참조 카운트 (Reference Count)
- 소유자의 수를 저장
- 참조 카운트가 **1 이상이면 메모리에 유지**, **0이 되면 해제**된다.

### retain / release
- **retain** : 소유권을 얻음 → 참조 카운트 +1
- **release** : 소유권을 포기 → 참조 카운트 −1
- 두 작업 모두 ARC가 자동으로 처리한다.

---

##  강한 참조 (Strong Reference)

- 클래스 인스턴스를 변수/상수에 연결하면 기본적으로 **강한 참조**가 된다.
- 강한 참조는 참조 카운트를 증가시킨다.
- 변수에 `nil`을 할당하거나 스코프를 벗어나면 참조 카운트가 감소하고, 0이 되면 인스턴스가 해제되며 `deinit`이 호출된다.

```swift
class User {
    var name: String

    init(name: String) {
        self.name = name
        print("\(name) 생성됨")
    }

    deinit {
        print("\(name) 메모리 해제됨")
    }
}

var user1: User? = User(name: "Alice")  // 참조 카운트: 1
var user2: User? = user1                // 참조 카운트: 2

user1 = nil  // 참조 카운트: 1 (아직 살아 있음)
user2 = nil  // 참조 카운트: 0 → deinit 호출, "Alice 메모리 해제됨" 출력
```

---

##  강한 참조 순환 (Strong Reference Cycle)

두 인스턴스가 서로를 강하게 참조하면, 참조 카운트가 절대 0이 되지 않아 **메모리 누수**가 발생한다. 이때 `deinit`도 호출되지 않는다.

```swift
class Owner {
    var name: String
    var pet: Pet?   //강한 참조

    init(name: String) { self.name = name }
    deinit { print("\(name) (Owner) 해제됨") }
}

class Pet {
    var nickname: String
    var owner: Owner?   //강한 참조 → 순환 발생

    init(nickname: String) { self.nickname = nickname }
    deinit { print("\(nickname) (Pet) 해제됨") }
}

var owner: Owner? = Owner(name: "Tom")   // Owner RC: 1
var pet: Pet? = Pet(nickname: "Mochi")   // Pet RC: 1

owner?.pet = pet      // Pet RC: 2
pet?.owner = owner    // Owner RC: 2

owner = nil           // Owner RC: 1 (pet이 여전히 참조)
pet = nil             // Pet RC: 1 (owner가 여전히 참조)
//둘 다 RC가 0이 되지 않아 deinit 호출 안 되고 메모리 누수
```

---

## 8. 해결 방법

### Weak Reference (약한 참조)
- 대상을 **소유하지 않으면서 접근만** 한다.
- 참조 카운트를 증가시키지 않는다.
- 참조하던 대상이 해제되면 **자동으로 `nil`로 초기화**된다.
- 항상 **Optional 타입**이어야 하며 `var`로 선언해야 한다.
- 대부분의 순환 참조는 이 방식으로 해결한다.

```swift
class Owner {
    var name: String
    var pet: Pet?

    init(name: String) { self.name = name }
    deinit { print("\(name) (Owner) 해제됨") }
}

class Pet {
    var nickname: String
    weak var owner: Owner?   //약한 참조

    init(nickname: String) { self.nickname = nickname }
    deinit { print("\(nickname) (Pet) 해제됨") }
}

var owner: Owner? = Owner(name: "Tom")
var pet: Pet? = Pet(nickname: "Mochi")

owner?.pet = pet
pet?.owner = owner   // 참조 카운트 증가하지 않음

owner = nil   // "Tom (Owner) 해제됨" 출력
pet = nil     // "Mochi (Pet) 해제됨" 출력
```

### Unowned Reference (미소유 참조)
- 마찬가지로 참조 카운트를 증가시키지 않는다.
- weak와 달리 **non-Optional**이며, 해제되어도 `nil`로 바뀌지 않는다.
- **참조 대상이 자신보다 항상 오래 살아있다고 보장될 때만** 사용해야 한다.
- 해제된 인스턴스에 접근하면 **런타임 크래시**가 발생한다.
- 생명 주기가 명확한 경우(예: 부모-자식 관계에서 자식이 항상 부모보다 먼저 사라지는 경우)에 제한적으로 사용한다.

```swift
class Country {
    var name: String
    var capital: City!

    init(name: String, capitalName: String) {
        self.name = name
        self.capital = City(name: capitalName, country: self)
    }
    deinit { print("\(name) (Country) 해제됨") }
}

class City {
    var name: String
    unowned var country: Country   //미소유 참조

    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
    deinit { print("\(name) (City) 해제됨") }
}

var korea: Country? = Country(name: "Korea", capitalName: "Seoul")
korea = nil
// "Korea (Country) 해제됨"
// "Seoul (City) 해제됨"
```

City는 Country 없이 존재할 수 없으므로, City가 Country보다 오래 살 일이 없다. 이런 경우 `unowned`가 적합하다.

### weak vs unowned 정리

| 구분 | weak | unowned |
|------|------|---------|
| 참조 카운트 증가 | X | X |
| Optional 여부 | Optional | Non-Optional |
| 대상 해제 시 동작 | 자동으로 `nil` | 접근 시 크래시 |
| 사용 시점 | 일반적인 순환 참조 해결 | 생명 주기가 보장될 때 |

##  Reference
- Kxcoding Mastering iOS
