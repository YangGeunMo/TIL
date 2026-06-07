# iOS UITableView

> 날짜: 2026-06-08  
> 주제: UITableView 구조, DataSource/Delegate 패턴

---

## UITableView 구조

```
UITableView
  └── UITableViewCell  ← 각각 독립적인 객체
```

- `UITableView`와 `UITableViewCell`은 각각 별개의 객체다.
- 셀은 **재사용 큐(Reuse Queue)** 로 관리된다.
  - 화면 밖으로 사라진 셀 → 큐에 반환 → 새 셀 필요 시 꺼내서 재사용
  - `dequeueReusableCell(withIdentifier:)` 가 이 역할을 담당한다.
  - 셀을 매번 새로 생성하지 않으므로 **메모리 효율**이 높다.

---

## DataSource vs Delegate

| 프로토콜 | 역할 | 필수 여부 |
|---|---|---|
| `UITableViewDataSource` | **무엇을** 보여줄지 (데이터, 구성) |  필수 |
| `UITableViewDelegate` | **어떻게** 반응할지 (동작, 이벤트) |  선택 |

> 뷰컨트롤러가 두 프로토콜을 채택해서, 테이블뷰가 "물어보면" 답하는 구조다.

---

## UITableViewDataSource

```swift
extension ViewController: UITableViewDataSource {

    // 테이블뷰에 몇 개의 셀을 표시할지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 데이터 개수 반환
    }

    // indexPath에 해당하는 셀의 구성을 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 재사용 큐에서 셀을 꺼내와 데이터를 구성 후 반환
    }
}
```

---

## IndexPath

```
Section 0 ─── row 0   (indexPath.section = 0, indexPath.row = 0)
          ─── row 1   (indexPath.section = 0, indexPath.row = 1)
          ─── row 2
Section 1 ─── row 0   (indexPath.section = 1, indexPath.row = 0)
          ─── row 1
```

- 테이블뷰의 모든 위치는 **섹션 + 행** 으로 식별한다.
- 섹션 없이 단순 리스트라면 `indexPath.row` 만 사용하면 된다.
- 섹션이 여러 개라면 `indexPath.section` 도 함께 활용해야 한다.

---

## 5. UITableViewDelegate

```swift
extension ViewController: UITableViewDelegate {

    // 셀이 선택되었을 때 호출
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택된 셀의 위치를 indexPath로 받아서 원하는 동작 처리
    }
}
```

---

## 핵심 요약

| 개념 | 설명 |
|---|---|
| 재사용 큐 | 화면 밖 셀을 버리지 않고 재활용 → 메모리 절약 |
| DataSource | 셀 개수, 셀 구성 등 **데이터** 관련 |
| Delegate | 셀 선택 등 **동작/이벤트** 관련 |
| IndexPath | 셀의 위치 (section + row) |


## Reference
- 앨런 iOS 앱 개발 (15개의 앱을 만들면서 근본원리부터 배우는 UIKit) - MVVM까지
