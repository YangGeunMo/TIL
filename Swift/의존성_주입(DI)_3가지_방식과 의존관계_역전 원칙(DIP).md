# 의존성 주입(DI) 3가지 방식과 의존관계 역전 원칙(DIP)

## 학습일
2026-05-10

## 의존성이란?

객체가 동작하기 위해 필요한 다른 객체. `LoginManager`가 동작하려면 `LoginService`가 필요하다.

## 의존성 주입 3가지 방식

### 속성 주입 (Property Injection)
- 외부에서 직접 속성에 할당하는 방식. 주입을 깜빡하면 런타임에 터지는 위험이 있다.

### 생성자 주입 (Initializer Injection)
- `init`에서 받는 방식. `private let`으로 은닉성까지 챙길 수 있고 안전하다.
단, 구체 클래스에 고정되어 유연성이 없다.

### 인터페이스 주입 (Interface Injection)
- 프로토콜 타입으로 받는 방식. 어떤 구현체든 주입 가능하고,
새로운 로그인 방식이 추가돼도 `LoginManager`를 수정할 필요가 없다.

## 은닉성 (Encapsulation)

- 내부 데이터를 외부에서 직접 조작하지 못하게 막는 것. 객체를 예측 가능한 범위에서 관리할 수 있다.
- 조작이 필요하다면 메소드를 이용해서 개발자가 의도된 방식으로 조작하게 한다.

## **의존관계 역전 원칙 (DIP)**

- 고수준 모듈과 저수준 모듈이 서로 직접 의존하지 않고 프로토콜(추상화)에 의존하게 하는 원칙. 인터페이스 주입을 쓰면 자연스럽게 DIP를 따르게 된다.

## 예제 코드

```swift
// MARK: - 프로토콜 정의 (추상화)
protocol LoginService{
    func login()
}

// MARK: - 로그인 구현체들 (저수준 모듈)
class KakaoLogin:LoginService{
    func login() {
        print("카카오 로그인 완료")
    }
}
class AppleLogin:LoginService{
    func login() {
        print("애플 로그인 완료")
    }
}
class GoogleLogin:LoginService{
    func login() {
        print("구글 로그인 완료")
    }
}
class NaverLogin:LoginService{
    func login() {
        print("네이버 로그인")
    }
}

// MARK: - 속성 주입 (Property Injection)
// 외부에서 직접 할당. 주입 안 하면 런타임에 fatalError
class LoginManager{
    var service : KakaoLogin?
    
    func Manager() {
        guard let service else {
            fatalError("로그인 실패")
        }
        service.login()
    }
}
let login:LoginManager = LoginManager()
login.service = KakaoLogin()
login.Manager()

// MARK: - 생성자 주입 (Initializer Injection)
// private let으로 은닉성 확보. 단, KakaoLogin으로 고정되어 유연성 없음
class LoginManager1{
    private let service : KakaoLogin
    
    init(service: KakaoLogin) {
        self.service = service
    }
    func Manager() {
        service.login()
    }
}
let login1:LoginManager1 = LoginManager1(service: KakaoLogin())
login1.Manager()

// MARK: - 인터페이스 주입 + DIP (Interface Injection)
// 프로토콜 타입으로 받아 어떤 구현체든 주입 가능. LoginManager2 수정 불필요
class LoginManager2{
    private let service : LoginService
    
    init(service: LoginService) {
        self.service = service
    }
    func Manager() {
        service.login()
    }
}
let appleLogin : LoginManager2 = LoginManager2(service: AppleLogin())
let kakaoLogin : LoginManager2 = LoginManager2(service: KakaoLogin())
let googleLogin : LoginManager2 = LoginManager2(service: GoogleLogin())
let naverLogin : LoginManager2 = LoginManager2(service: NaverLogin())
```

## **느낀 점**
- 세 방식을 단계별로 직접 구현해보니 중복을 최소화할 수 있는 인터페이스 주입이 왜 좋은지 체감됐다.

## Reference
- kxcoding의 Mastering iOS 강의


