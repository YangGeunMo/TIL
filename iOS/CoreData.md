# CoreData

## 학습일
- 2026-05-22

---

## 개념

CoreData는 Apple이 제공하는 **영구 데이터 저장 프레임워크**다.
내부적으로 SQLite를 사용하지만, SQL 없이 Swift 코드로 데이터를 저장하고 관리할 수 있다.

---

## CoreData 스택 전체 구조

```
┌─────────────────────────────────────┐
│          .xcdatamodeld              │
│     데이터 구조 설계도               │
│  (엔티티, 어트리뷰트 정의)           │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│       NSPersistentContainer         │
│   CoreData 스택 전체를 관리하는      │
│           보관함                     │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│     NSManagedObjectContext          │
│  실제 작업이 이루어지는 임시 저장소  │
│           (viewContext)             │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│         NSManagedObject             │
│   Context 안에서 다루는 데이터 객체  │
└──────────────┬──────────────────────┘
               │  save() 호출 시 반영
               ▼
┌─────────────────────────────────────┐
│        SQLite (영구 저장소)          │
│      실제 데이터가 저장되는 파일     │
└─────────────────────────────────────┘
```

> 모든 CRUD 작업은 Context 에서 처리되며, `save()` 를 호출해야 실제 DB에 반영된다

---

## NSPersistentContainer

CoreData를 사용하기 위한 **전체 시스템을 담고 있는 보관함**이다.

```
NSPersistentContainer
        │
        ├── 설계도 (.xcdatamodeld)   → 어떤 데이터를 저장할지 구조 정의
        ├── 작업실 (viewContext)      → 실제 데이터를 읽고 쓰는 공간
        └── 창고   (SQLite)          → 데이터가 영구적으로 저장되는 곳
```

AppDelegate에 기본으로 생성되어 있다.

---

## NSManagedObjectContext

**데이터를 읽고 쓰는 임시 작업공간**이다. 단, 저장 단계는 아님.

```
[내 코드]  →  Context (임시 작업공간)  →  save()  →  SQLite (영구 저장소)
                       │
               hasChanges == true
               변경 사항이 있을 때만 저장
```

- `save()` 를 호출하지 않으면 앱 종료 시 데이터가 사라진다
- `hasChanges` 로 변경 사항 여부를 먼저 확인하고 저장한다

---

## NSManagedObject

CoreData에서 **데이터 하나를 표현하는 객체**다.

```
Person 엔티티
┌────────┬─────┐
│ name   │ age │
├────────┼─────┤
│ 철수   │ 25  │  ← NSManagedObject 하나
│ 영희   │ 30  │  ← NSManagedObject 하나
└────────┴─────┘
```

반환 타입이 `NSManagedObject` 이기 때문에 프로퍼티에 직접 접근할 수 없다.
문자열 키로 접근하며, 오타가 나도 컴파일 에러가 아닌 **런타임 크래시**가 발생한다.

---

## CRUD

```
Create  →  insertNewObject → setValue  →  save()
Read    →  NSFetchRequest  → fetch()   →  value(forKey:)
Update  →  editTarget      → setValue  →  save()
Delete  →  context.delete  →           →  save()

※ Read는 save() 불필요
※ Create · Update · Delete는 반드시 save() 필요
```



---

## 정리

| 항목 | 내용 |
|------|------|
| NSPersistentContainer | CoreData 스택 전체를 관리하는 보관함 |
| NSManagedObjectContext | 실제 작업이 이루어지는 임시 저장소 |
| viewContext | 메인 스레드용 Context, AppDelegate에서 꺼내 사용 |
| NSManagedObject | Context 안에서 다루는 데이터 객체 |
| NSEntityDescription | 엔티티 객체를 생성하고 Context에 등록 |
| NSFetchRequest | 데이터를 읽어올 때 사용하는 요청서 |
| setValue(forKey:) | 문자열 키로 값 설정, 컴파일 타임 검증 불가 |
| value(forKey:) | 문자열 키로 값 읽기, Any 타입으로 반환 |
| hasChanges | Context에 저장되지 않은 변경 사항 여부 확인 |
| save() | Context의 변경 사항을 실제 DB에 반영 |

---

## Reference
- Kxcoding Mastering iOS
