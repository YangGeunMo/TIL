# MVC 디자인 패턴 (Model-View-Controller)

## 📌 개요

**MVC**는 애플리케이션을 세 가지 역할로 분리하는 디자인 패턴으로,  
핵심 철학은 **"관심사의 분리 (Separation of Concerns)"** 이다.

---

## 🧩 구성 요소

### Model
- 비즈니스 로직 담당 (화면과 무관한 로직 및 데이터)
- 데이터베이스, 네트워크 통신 처리
- 데이터 변경 시 Controller에게 알림 (Notification / Callback)

### View
- UI 관련, 사용자 화면 표시
- Controller를 통해 명령을 받아 화면에 표시
- **수동적(Passive)** — 스스로 데이터를 가져오지 않고, Controller가 주는 것만 표시

### Controller (뷰 컨트롤러)
- Model의 정보를 어떻게 View에 표시할지 전달하는 **중재자**
- 사용자 입력의 유효성 검사(Validation)도 담당

---

## 🔄 전체 흐름

```
View → Controller → Model → Controller → View
```

1. **View**에서 이벤트 발생 → Controller에 전달
2. **Controller**는 Model에게 정보 요청/전달
3. **Model**은 데이터를 처리하고 결과값을 Controller에 전달
4. **Controller**는 업데이트된 내용을 View에 전달
5. **View**는 업데이트된 내용을 화면에 표시

---

## ⚠️ 주의사항

> **Model과 View는 절대 직접 통신하지 않는다.**  
> 반드시 Controller(중재자)를 거쳐야 한다.

---

## 🔁 Controller → View 업데이트 방식

| 방식 | 설명 |
|------|------|
| **직접 업데이트** | Controller가 View에 직접 데이터 전달 |
| **옵저버 패턴** | Model 변경 시 View가 감지 (iOS: NotificationCenter, KVO) |

---

## ✅ 장단점

| 장점 | 단점 |
|------|------|
| 역할 분리로 유지보수 용이 | Controller가 비대해지는 **Massive VC** 문제 |
| 병렬 개발 가능 (View / Model 독립) | View와 Controller의 강한 결합 |
| 코드 재사용성 향상 | 소규모 프로젝트엔 구조가 과할 수 있음 |

---

## 🚨 Massive VC (Massive View Controller) 문제

MVC의 대표적인 단점으로, Controller가 중재자 역할을 하다 보니  
**"이건 어디에 넣지?"** 싶은 코드들이 전부 Controller로 몰리는 현상이다.

### Controller에 쌓이는 것들
- View 설정 코드
- 데이터 가공 / 포맷팅
- 유효성 검사 (Validation)
- 화면 전환 로직
- 각종 delegate / callback 처리

결국 Controller 하나가 **수백~수천 줄**이 되어버리는 것이 Massive VC 문제다.

> 네트워크 처리는 원래 Model의 역할이지만, 구조를 제대로 지키지 않으면  
> Controller에서 직접 처리하는 잘못된 코드 습관이 생기고, 이것도 Massive VC의 원인이 된다.

### 발생하는 문제들

| 문제 | 내용 |
|------|------|
| 가독성 저하 | 코드가 너무 길어서 파악이 어려움 |
| 유지보수 어려움 | 버그 위치를 찾기 힘듦 |
| 테스트 어려움 | 로직이 뒤섞여 단위 테스트가 힘듦 |
| 재사용 불가 | 의존성이 너무 많아 다른 곳에서 쓰기 어려움 |

> 특히 iOS 개발에서 고질적인 문제로 유명하며,  
> 이를 해결하기 위해 **MVP / MVVM** 패턴이 등장했다.

---

## 🆚 관련 패턴 비교

| 패턴 | 특징 |
|------|------|
| **MVC** | Controller가 View와 Model을 중재 |
| **MVP** | Presenter가 View와 1:1 대응, View가 더 수동적 |
| **MVVM** | ViewModel + 데이터 바인딩, View가 직접 ViewModel 관찰 (SwiftUI, Android) |

> MVP, MVVM은 MVC의 단점(Massive VC, 강한 결합)을 보완하기 위해 등장했다.

---

## 💡 핵심 키워드

- **관심사의 분리 (Separation of Concerns)**
- **단방향 의존성** — View는 Model을 모른다
- **중재자 패턴** — Controller가 두 계층 사이를 조율
