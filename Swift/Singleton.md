# 싱글톤 패턴 (Singleton Pattern)

## 학습일
- 2026-05-22



## 개념

앱 전체에서 인스턴스를 **딱 하나만** 생성하고, 어디서든 그 인스턴스를 공유하는 디자인 패턴

일반적인 클래스는 인스턴스를 여러 개 만들 수 있지만, 싱글톤은 인스턴스가 오직 하나만 존재하도록 강제한다.



## 기본 구현

Swift에서 싱글톤은 두 가지 요소로 구현한다.

- **타입 프로퍼티** : `static let`으로 유일한 인스턴스를 저장. 처음 접근하는 시점에 딱 한번만 생성된다.
- **private init** : 외부에서 인스턴스를 직접 생성하지 못하도록 차단한다.

```swift
class UserSettings {

    static let shared = UserSettings()
    private init() { }

    var isDarkMode: Bool = false
    var fontSize: Int = 14
    var language: String = "한국어"
}
```

```swift
// shared를 통해서만 접근 가능
UserSettings.shared.isDarkMode = true

// 컴파일 에러 - private init이므로 직접 생성 불가
let settings = UserSettings()
```



## 동작 원리

### 처음 접근 시 자동 초기화
`static let`은 처음 접근하는 시점에 자동으로 초기화된다. 앱 시작과 동시에 만들어지는 게 아니라 필요한 순간에 생성된다.

### Thread-Safe 보장
Swift의 `static let`은 내부적으로 `dispatch_once`와 동일하게 동작하여 멀티 스레드 환경에서도 인스턴스가 단 한번만 생성됨을 보장한다.

### 같은 인스턴스 공유 확인

```swift
let a = UserSettings.shared
let b = UserSettings.shared

a.fontSize = 20

print(b.fontSize)   // 20 - a와 b는 같은 인스턴스를 가리킴
print(a === b)      // true
```



## 코코아 터치의 싱글톤

Apple 프레임워크에서도 싱글톤 패턴을 적극적으로 사용한다.
`shared` / `default` / `standard` 가 보이면 싱글톤이라고 보면 된다.

```swift
NotificationCenter.default     // 알림 관리
UserDefaults.standard          // 간단한 데이터 저장
FileManager.default            // 파일 시스템 접근
URLSession.shared              // 네트워크 요청
UIApplication.shared           // 앱 자체 접근
```

---

## 언제 사용하는지

- 앱 전체에서 하나의 상태를 공유해야 할 때 (로그인 유저 정보, 앱 설정값)
- 공통 자원을 관리할 때 (네트워크 매니저, CoreData 매니저)
- 여러 화면에서 동일한 데이터를 읽고 써야 할 때 (장바구니, 테마 설정)



## 장점

- 인스턴스가 하나이므로 메모리 절약
- `shared` 하나로 어디서든 쉽게 접근 가능
- 여러 화면 간 데이터 공유가 쉬움
- `static let`으로 thread-safe 초기화 자동 보장



## 단점 및 주의점

### 예상치 못한 사이드 이펙트
어디서든 접근 가능하다는 건, 어디서든 데이터를 바꿀 수 있다는 의미이기도 하다.

```swift
// A 화면에서
UserSettings.shared.fontSize = 20

// B 화면에서 (의도치 않게 영향을 받음)
print(UserSettings.shared.fontSize)  // 20
```

### 멀티 스레드 주의
초기화는 thread-safe하지만, 이후 프로퍼티 접근은 thread-safe하지 않다.

```swift
// 여러 스레드에서 동시에 접근하면 데이터 충돌 위험
DispatchQueue.global().async {
    UserSettings.shared.fontSize = 20  // ⚠️ 위험
}
DispatchQueue.global().async {
    UserSettings.shared.fontSize = 30  // ⚠️ 위험
}
```

### 테스트가 어렵다
싱글톤 인스턴스는 테스트 실행 중 하나만 만들어지고 테스트 간에 공유된다.
테스트는 독립적으로 실행되어야 한다는 원칙을 위반하기 때문에 테스트 결과가 달라질 수 있다.

### 확장성 저하
싱글톤 하나에 너무 많은 기능을 몰아넣으면 유지보수가 어려워진다.



## 예제

```swift
import Foundation

class UserSettings {
    static let shared = UserSettings()
    private init() { }

    var isDarkMode: Bool = false
    var fontSize: Int = 14
    var language: String = "한국어"
}

// 설정 화면에서 변경
UserSettings.shared.isDarkMode = true
UserSettings.shared.fontSize = 18

// 다른 화면에서 동일하게 반영됨
print(UserSettings.shared.isDarkMode)  // true
print(UserSettings.shared.fontSize)   // 18
```



## 의존성 주입으로 대체하기

유닛 테스트가 중요한 경우, 싱글톤을 직접 참조하는 대신 외부에서 의존성을 주입하는 방식으로 구현하면 테스트 시 mock 객체로 쉽게 교체할 수 있어 독립적인 테스트가 가능해진다.



## 정리

| 항목 | 내용 |
|------|------|
| 핵심 구현 | `static let shared` + `private init()` |
| 초기화 시점 | 처음 접근하는 순간 자동 생성 |
| Thread-Safe | 초기화는 보장, 프로퍼티 접근은 직접 관리 필요 |
| 코코아 터치 | `shared` / `default` / `standard` 이름이면 싱글톤 |
| 사용 권장 | 앱 전역 공유 자원 관리에 한해 제한적으로 사용 |
| 테스트 대안 | 의존성 주입(DI) 방식으로 대체 |



## Reference
- Kxcoding Mastering iOS
