# Swift Formatter

데이터를 문자열로 또는 문자열을 데이터로 변환하는 기능이다. 

## 학습일
- 2026-05-13

## DateFormatter

날짜와 시간을 문자열로 변환하거나 문자열을 Date 타입으로 변환할 때 사용한다.

### 기본 사용법

인스턴스 생성 후 dateFormat으로 형식을 지정하고 string(from:)으로 변환한다.

```swift
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd"
let result = formatter.string(from: Date())
print(result) //2026-05-13
```

### dateFormat 심볼

| 심볼 | 의미 | 예시 |
|------|------|------|
| yyyy | 4자리 연도 | 2026 |
| yy | 2자리 연도 | 26 |
| MM | 2자리 월 | 05 |
| M | 1자리 월 | 5 |
| dd | 2자리 일 | 13 |
| d | 1자리 일 | 13 |
| HH | 24시간 | 15 |
| hh | 12시간 | 03 |
| mm | 분 | 45 |
| ss | 초 | 30 |
| a | 오전 오후 | 오후 |

### 심볼 조합 예시

```swift
let formatter = DateFormatter()
formatter.locale = Locale(identifier: "ko_KR")

formatter.dateFormat = "yyyy-MM-dd"
formatter.string(from: Date()) //2026-05-13

formatter.dateFormat = "yyyy년 MM월 dd일"
formatter.string(from: Date()) //2026년 05월 13일

formatter.dateFormat = "a hh:mm"
formatter.string(from: Date()) //오후 03:45

formatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
formatter.string(from: Date()) //2026년 05월 13일 오후 03시 45분
```

### String to Date

반환 타입이 Date 옵셔널이므로 if let 또는 guard let으로 처리한다. dateFormat과 문자열 형식이 정확히 일치해야 하며 다를 경우 nil을 반환한다.

```swift
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd"

if let date = formatter.date(from: "2026-05-13") {
    print(date)
}

//formatter.date(from: "2026/05/13")  nil 구분자 다름
//formatter.date(from: "13-05-2026")  nil 순서 다름
//formatter.date(from: "2026-05")     nil 일(dd) 없음
```

---

## NumberFormatter

숫자를 원하는 형식의 문자열로 변환할 때 사용한다. string(from:)의 파라미터 타입이 NSNumber이므로 as NSNumber로 변환이 필요하다.

### numberStyle 종류

```swift
let formatter = NumberFormatter()
let number = 1234567

formatter.numberStyle = .none
formatter.string(from: number as NSNumber) //1234567 기본

formatter.numberStyle = .decimal
formatter.string(from: number as NSNumber) //1,234,567 천 단위 콤마

formatter.numberStyle = .currency
formatter.string(from: number as NSNumber) //통화 locale 따라 달라짐

formatter.numberStyle = .percent
formatter.string(from: 0.85 as NSNumber) //85퍼센트

formatter.numberStyle = .scientific
formatter.string(from: number as NSNumber) //1.234567E6 과학적 표기
```

### 소수점 자리수 조절

```swift
let formatter = NumberFormatter()
formatter.numberStyle = .decimal
formatter.minimumFractionDigits = 2
formatter.maximumFractionDigits = 2

formatter.string(from: 3.14159 as NSNumber) //3.14
formatter.string(from: 3.1 as NSNumber)     //3.10 최소 2자리 맞춰줌
formatter.string(from: 3.0 as NSNumber)     //3.00 최소 2자리 맞춰줌
```

### locale 설정

```swift
let formatter = NumberFormatter()
formatter.numberStyle = .currency

formatter.locale = Locale(identifier: "ko_KR")
formatter.string(from: 29900 as NSNumber) //29,900원

formatter.locale = Locale(identifier: "en_US")
formatter.string(from: 29900 as NSNumber) //29,900.00달러

formatter.locale = Locale(identifier: "ja_JP")
formatter.string(from: 29900 as NSNumber) //29,900엔
```

## DateComponentsFormatter

시간 간격을 사람이 읽기 좋은 문자열로 변환할 때 사용한다.

### 기본 사용법

인스턴스 생성 후 allowedUnits로 사용할 단위를 지정하고 unitsStyle로 표시 스타일을 지정한다.

```swift
let formatter = DateComponentsFormatter()
formatter.allowedUnits = [.hour, .minute, .second]
formatter.unitsStyle = .full
formatter.string(from: 3665) //1시간 1분 5초
```

### unitsStyle 종류

```swift
formatter.unitsStyle = .full
formatter.string(from: 3665) //1시간 1분 5초

formatter.unitsStyle = .abbreviated
formatter.string(from: 3665) //1시간 1분 5초

formatter.unitsStyle = .short
formatter.string(from: 3665) //1시간 1분 5초

formatter.unitsStyle = .positional //시계 형식
formatter.string(from: 3665) //1:01:05

formatter.unitsStyle = .spellOut
formatter.string(from: 3665) //한 시간 일 분 오 초
```

### allowedUnits 조합

```swift
formatter.allowedUnits = [.hour, .minute, .second]
formatter.string(from: 3665) //1시간 1분 5초

formatter.allowedUnits = [.day, .hour, .minute]
formatter.string(from: 90061) //1일 1시간 1분

formatter.allowedUnits = [.minute, .second]
formatter.string(from: 185) //3분 5초

formatter.allowedUnits = [.month, .day]
formatter.string(from: 5270400) //2개월 1일
```

### maximumUnitCount

최대 표시 단위 수를 제한한다.

```swift
formatter.allowedUnits = [.hour, .minute, .second]
formatter.string(from: 3665) //1시간 1분 5초

formatter.maximumUnitCount = 2
formatter.string(from: 3665) //1시간 1분 초는 생략
```

### 두 Date 사이 간격

```swift
let formatter = DateComponentsFormatter()
formatter.allowedUnits = [.day, .hour, .minute]
formatter.unitsStyle = .full

let start = Date()
let end = Date().addingTimeInterval(90061)
formatter.string(from: start, to: end) //1일 1시간 1분
```
