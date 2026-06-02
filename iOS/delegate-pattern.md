# 델리게이트 패턴 (Delegate Pattern)
## 학습일
 - 2026.06.02
## 개념 정의

- **델리게이트 패턴(Delegate Pattern)** 은 한 객체가 해야 할 일의 일부를 다른 객체가 대신하도록 위임하는 iOS 개발의 핵심 디자인 패턴이다.
- **위임자 (Sender / Delegator)**: 이벤트가 발생하는 주체이다(예: `UITextField`, `UITableView`). 무슨 일이 일어났는지 대리인에게 알리는 역할만 담당한다.
- **대리인 (Delegate)**: 이벤트를 전달받아 실제 비즈니스 로직을 처리하는 주체이다(예: `UIViewController`).


## 델리게이트 패턴을 사용하는 이유 (재사용성)

- **결합도 분리**: UI 컴포넌트 내부에 특정 비즈니스 로직을 직접 추가하면, 해당 컴포넌트는 다른 화면이나 용도로 재사용할 수 없게 된다.
- **역할의 분리**:
  - **UI 컴포넌트**: 화면에 UI를 그리고 사용자의 입력을 받는 역할만 수행한다.
  - **뷰 컨트롤러**: 입력받은 데이터로 무엇을 할지(화면 전환, 데이터 검증 등) 결정한다.
  - 이처럼 역할을 분리함으로써 UI 컴포넌트들의 재사용성을 극대화할 수 있다.

---

## 장점과 단점

### 장점

- **가독성과 유지보수성**: UI 내부 로직과 비즈니스 로직이 명확하게 분리되므로 코드가 깔끔해진다.
- **유연성**: 동일한 UI 컴포넌트라도 어떤 뷰 컨트롤러를 대리인(`delegate`)으로 지정하느냐에 따라 완전히 다르게 동작하도록 만들 수 있다.

### 단점 및 주의점

- **메모리 누수(Memory Leak) 위험**: 대리인과 위임자가 서로를 강하게 참조(`Strong`)하면, 두 객체가 메모리에서 해제되지 않는 강한 순환 참조 현상이 발생할 수 있다.
  - **해결책**: 이를 방지하기 위해 위임자 내부의 `delegate` 변수 앞에는 반드시 **`weak`** 키워드를 붙여서 약한 참조로 선언해야 한다.
- **1:1 소통 구조의 한계**: 델리게이트 패턴은 기본적으로 하나의 위임자와 하나의 대리인이 소통하는 1:1 계약 관계이다. 1:N(다수)으로 이벤트를 동시에 전파해야 할 때는 사용할 수 없으므로 `NotificationCenter`나 `Combine` 등의 다른 도구를 고려해야 한다.


## 구체적인 구현 예시 (배달 앱과 음식점)

```swift
import Foundation

// 1. 프로토콜 선언 (AnyObject를 붙여 클래스 전용 자격증으로 명시)
protocol DeliveryAppDelegate: AnyObject {
    func didReceiveOrder(menu: String)
    func didCancelOrder()
}

// 2. 위임자 (배달 앱 클래스)
class DeliveryApp {
    // 강한 순환 참조를 막기 위해 weak 키워드 사용
    weak var delegate: DeliveryAppDelegate?
    
    func didReceiveOrder(menu: String) {
        delegate?.didReceiveOrder(menu: menu) // 대리인에게 이벤트 위임
    }
    
    func didCancelOrder() {
        delegate?.didCancelOrder() // 대리인에게 이벤트 위임
    }
}

// 3. 대리인 (치킨집 클래스)
class ChickenShop: DeliveryAppDelegate {
    func didReceiveOrder(menu: String) {
        print("주문이 들어온 메뉴 : \(menu)")
    }
    
    func didCancelOrder() {
        print("주문 취소")
    }
}

// --- 실행부 ---
var deliveryApp: DeliveryApp = DeliveryApp()
var chicken: ChickenShop = ChickenShop()

// 위임 관계 연결 (배달 앱의 대리인은 치킨집이다)
deliveryApp.delegate = chicken

// 이벤트 발생 및 위임 동작 확인
deliveryApp.didReceiveOrder(menu: "치킨")
deliveryApp.didReceiveOrder(menu: "양념 치킨")
deliveryApp.didCancelOrder()
```

---
프로토콜을 선언하고, DeliveryApp 클래스에서 delegate의 타입을 프로토콜 타입(DeliveryAppDelegate)으로 선언해서 해당 프로토콜을 채택한 어떤 클래스든 대리인으로 지정할 수 있다.

deliveryApp.delegate = chicken에서 chicken 인스턴스는 ChickenShop 타입이지만 DeliveryAppDelegate 프로토콜을 채택하고 있기 때문에 할당이 가능하다.

weak var delegate: DeliveryAppDelegate?는 힙 영역에 있는 chicken 인스턴스를 약하게 참조(weak reference) 하고 있고, 인스턴스 자체를 복사해서 저장하는 게 아니라 원본 객체를 가리키는 방식이다. 메서드 호출 시 그 인스턴스를 통해 코드 영역의 ChickenShop 메서드가 실행된다.

## `UITextFieldDelegate` 구현

`UITextField`(위임자)가 발생시키는 이벤트를 `ViewController`(대리인)가 처리하는 iOS 코드 예시.

### 메서드 호출 

| 순서 | 메서드 | 설명 | 반환값 |
|------|--------|------|--------|
| 1 | `textFieldShouldBeginEditing` | 입력 시작 허락 여부 | `Bool` |
| 2 | `textFieldDidBeginEditing` | 입력이 실제로 시작됨 | - |
| 3 | `textField(_:shouldChangeCharactersIn:replacementString:)` | 글자 입력/삭제 시 허락 여부 (글자 수 제한 가능) | `Bool` |
| 4 | `textFieldShouldClear` | 클리어 버튼 허락 여부 | `Bool` |
| 5 | `textFieldShouldReturn` | 엔터 키 허락 여부 | `Bool` |
| 6 | `textFieldShouldEndEditing` | 입력 종료 허락 여부 | `Bool` |
| 7 | `textFieldDidEndEditing` | 입력이 완전히 끝남 | - |

> `Should~` 메서드는 **허락 여부를 결정**하는 메서드로 `Bool`을 반환하고, `Did~` 메서드는 **이미 발생한 이벤트**를 알리는 메서드로 반환값이 없다.

### 구현 코드

```swift
import UIKit

// 대리인(ViewController)이 위임자(UITextField)의 이벤트를 받아 처리하는 실제 구현
extension ViewController: UITextFieldDelegate {
    
    // 텍스트필드의 입력을 시작할 때 호출, 시작할지 말지 여부 결정 (대답을 리턴)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    // 텍스트필드 입력이 실제로 시작된 시점에 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
        print("유저가 텍스트필드의 입력을 시작")
    }
    
    // 텍스트필드의 클리어 버튼을 눌렀을 때 초기화를 허용할지 결정
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    // 텍스트필드 글자 내용이 입력되거나 지워질 때 호출되고, 허락 여부 결정 (글자 수 제한 가능)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.count)! + string.count > 10 {
            return false // 10글자가 넘어가면 입력을 막음
        } else {
            return true
        }
    }
    
    // 텍스트 필드의 엔터(Return)가 눌리면 다음 동작의 허락을 결정
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        if textField.text == "" {
            textField.placeholder = "헉"
            return false // 텍스트가 없으면 엔터 이벤트를 거부
        }
        return true
    }
    
    // 텍스트 필드의 입력이 끝날 때 호출 (끝낼지 말지 허락)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    // 텍스트필드의 입력이 실제 완전히 끝났을 때 호출
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
        print("유저의 입력이 끝남")
    }
}
```

## 6. 키보드 올리기 / 내리기 — First Responder
 
| 메서드 | 설명 |
|--------|------|
| `textField.becomeFirstResponder()` | 텍스트필드에 포커스를 강제로 지정 → 키보드가 올라옴 |
| `textField.resignFirstResponder()` | 텍스트필드의 포커스를 해제 → 키보드가 내려감 |
| `self.view.endEditing(true)` | 현재 뷰의 모든 텍스트필드 포커스를 해제 → 키보드가 내려감 |
 
### 구현 코드
 
```swift
// 응답 객체 - 특정 텍스트필드에 포커스를 주어 키보드를 올림, 텍스트 필드를 직접 터치하지 않더라도, 화면이 열리자마자 바로 글자를 입력하게 만들고 싶을 때
textField.becomeFirstResponder()
 
// 화면의 탭을 감지하는 메서드 - 빈 화면 탭 시 키보드를 내림, 사용자가 빈 화면을 터치하는 순간 호출되는 메서드 
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true) // 배경을 터치하면 어떤 키보드든 다 내려버린다
}
 
// 특정 텍스트필드의 포커스만 해제하여 키보드를 내림, 엔터(Return) 키가 눌렸을 때 키보드 내려감 
textField.resignFirstResponder()
```
 
