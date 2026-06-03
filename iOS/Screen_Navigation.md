# iOS 화면 이동 (View Controller Navigation)

## 학습일
- 2026.06.03

## Segue란?

화면 이동을 담당하는 객체

| 속성 | 설명 |
|------|------|
| `segue.source` | 근원지 (시작 뷰컨트롤러) |
| `segue.identifier` | 식별자 (세그웨이 구분 문자열) |
| `segue.destination` | 종착지 (다음 뷰컨트롤러) |



## 방법별 흐름 요약

| 방법 | 흐름 |
|------|------|
| 코드로 화면 이동 | 다음 VC 객체 생성 → `present` |
| 코드로 스토리보드 객체 생성 후 이동 | 스토리보드를 통해 VC 객체 생성 → `present` |
| 간접 세그웨이 | Segue 만들기 (스토리보드) → `performSegue` (조건 설정 가능) → `prepare` 자동 호출 (데이터 전달) |
| 직접 세그웨이 | Segue 만들기 (버튼 → VC 직접 연결) → `shouldPerformSegue` (이동 여부 결정) → `prepare` 자동 호출 (데이터 전달) |



## 1. 코드로 화면 이동 (코드 기반 VC)

```swift
let firstVC = FirstViewController()
firstVC.modalPresentationStyle = .fullScreen
firstVC.name = "데이터 전달"
present(firstVC, animated: true)
```

- **조건**: 다음 VC가 **코드로 작성된 경우에만** 사용 가능
- **주의**: 스토리보드 VC의 레이블 등에 직접 접근하면 에러 발생 (뷰 연결 전 접근)



## 2. 코드로 스토리보드 VC 인스턴스화

```swift
guard let secondVC = storyboard?.instantiateViewController(withIdentifier: "secondVC") as? SecondViewController else { return }
secondVC.name = "데이터 전달"
secondVC.modalPresentationStyle = .fullScreen
present(secondVC, animated: true)
```

- `instantiateViewController`로 스토리보드와 코드를 올바르게 연결

### 왜 단순 `SecondViewController()` 는 안 되나?

| 구분 | 메모리 동작 |
|------|------------|
| 코드 기반 VC | 인스턴스 생성 시 모든 속성이 한꺼번에 메모리에 올라와 **바로 연결**됨 |
| 스토리보드 기반 VC | VC 인스턴스 ↔ 스토리보드 UI 인스턴스가 **별도 생성** 후 나중에 연결됨 → `viewDidLoad` 이후에야 연결 완료 |

> 스토리보드로 만든 VC를 단순히 `ViewController()` 로 생성하면,  
> 코드 인스턴스와 스토리보드 UI 인스턴스가 연결되기 전에 접근하게 되어 에러 발생



## 3. 간접 세그웨이

```
Segue 만들기 (스토리보드) → performSegue → prepare 자동 호출
```

```swift
// 조건에 따라 화면 이동
performSegue(withIdentifier: "toThirdVC", sender: self)

// 데이터 전달 (자동 호출)
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toThirdVC" {
        let thirdVC = segue.destination as! ThirdViewController
        thirdVC.name = "데이터 전달"
    }
}
```

- 스토리보드에서 세그웨이 연결 후, 코드에서 `performSegue`로 **실행 시점 제어**
- 데이터 전달은 반드시 `prepare(for:sender:)` 에서 처리



## 4. 직접 세그웨이

```
Segue 만들기 (버튼 → VC 직접 연결) → shouldPerformSegue → prepare 자동 호출
```

```swift
// 이동 여부 결정 (true: 이동 / false: 이동 안함)
override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    return true
}

// 데이터 전달 (자동 호출)
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toFourthVC" {
        let fourVC = segue.destination as! FourthViewController
        fourVC.name = "데이터 전달"
    }
}
```

- 스토리보드에서 버튼을 VC에 **직접 드래그 연결** → `performSegue` 없이 버튼 탭만으로 실행
- `shouldPerformSegue`로 이동 여부를 **조건부 제어** 가능

  
## 전달 받을 ViewController

```swift
//SecondVC,ThirdVC도 같음, FirstVC는 코드로 UI를 작성해야함(레이블, 버튼 등)
class FourthViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    // 전달받을 데이터 변수
    var someString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainLabel.text = someString
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
        
    }
}
```
## Reference
- 앨런 iOS 앱 개발 (15개의 앱을 만들면서 근본원리부터 배우는 UIKit) - MVVM까지
