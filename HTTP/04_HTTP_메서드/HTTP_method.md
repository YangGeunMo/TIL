# HTTP API

## 좋지 않은 URI 설계 예시

아래처럼 URI에 동사(행위)를 그대로 넣는 것은 좋은 설계가 아니다.

```
회원 목록 조회  /read-member-list
회원 조회       /read-member-by-id
회원 등록       /create-member
회원 수정       /update-member
회원 삭제       /delete-member
```

## URI 설계에서 중요한 것: 리소스 식별

- URI 설계에서 핵심은 **리소스를 식별**하는 것이다.
- "회원을 등록/수정/조회"하는 행위 자체가 리소스가 아니라, **회원이라는 개체 자체가 리소스**다.
- 행위(등록, 수정, 조회, 삭제)는 모두 배제하고, 회원이라는 리소스만 URI에 매핑한다.
  예) 10번 회원 → `/members/10`

## 계층 구조를 활용한 URI 설계

`members`라는 리소스를 통해 계층 구조로 URI를 구성한다.

```
회원 목록 조회  /members
회원 조회       /members/{id}
회원 등록       /members/{id}
회원 수정       /members/{id}
회원 삭제       /members/{id}
```

회원 목록 조회를 제외하면 나머지는 모두 `/members/{id}`로 동일하다.
이렇게 되는 이유는 **리소스와 행위를 분리**하기 때문이다.

- URI는 **리소스만 식별**한다.
  - 리소스: 회원 (명사)
  - 행위: 조회, 등록, 삭제, 변경 (동사) → **HTTP 메서드**로 표현

---

# HTTP 메서드

## 주요 메서드 5가지

| 메서드 | 설명 |
|---|---|
| GET | 리소스 조회 |
| POST | 요청 데이터 처리, 주로 등록에 사용 |
| PUT | 리소스를 대체, 해당 리소스가 없으면 생성 |
| PATCH | 리소스를 부분 변경 |
| DELETE | 리소스 삭제 |

## 기타 HTTP 메서드

- **HEAD**: GET과 동일하지만 메시지 바디는 제외하고 상태 줄과 헤더만 반환
- **OPTIONS**: 대상 리소스에 대해 통신 가능한 옵션(메서드)을 설명 (주로 CORS에서 사용)
- **CONNECT**: 대상 리소스로 식별되는 서버에 대한 터널을 설정
- **TRACE**: 대상 리소스에 대한 경로를 따라 메시지 루프백 테스트를 수행

## GET

- 리소스를 조회한다.
- 서버에 전달하고 싶은 데이터는 **query(쿼리 파라미터, 쿼리 스트링)** 를 통해 전달한다.
- 메시지 바디로도 데이터 전달이 가능하지만, 지원하지 않는 곳이 많아 권장하지 않는다.

예) `member/100`번 회원을 조회하고 싶다면, 클라이언트가 `GET /member/100`을 요청 → 서버가 확인 후 100번 회원 데이터를 응답으로 전달.

## POST

- 요청 데이터를 처리한다.
- **메시지 바디**를 통해 서버로 요청 데이터를 전달한다.
- 서버는 메시지 바디로 들어온 데이터를 처리하는 모든 기능을 수행할 수 있다.
- 주로 전달된 데이터로 **신규 리소스 등록**, **프로세스 처리**에 사용된다.

<img width="554" height="337" alt="image" src="https://github.com/user-attachments/assets/fa120af0-f1ae-48c2-b734-68064017ba92" />
<img width="598" height="331" alt="image" src="https://github.com/user-attachments/assets/ebc8e5e3-aed8-4277-ad8b-0b90829cdf0d" />
<img width="604" height="336" alt="image" src="https://github.com/user-attachments/assets/2317822c-b23f-44df-b389-34d828783f82" />


### POST의 요청 데이터 처리 방식

POST 메서드는 **대상 리소스가 가진 고유한 의미 체계에 따라**, 요청에 포함된 데이터를 처리하도록 요청하는 것이다.
즉, HTML 폼에 입력된 데이터 블록을 데이터 처리 프로세스에 제공하는 식이며,
어떤 리소스에 POST 요청이 왔을 때 그 데이터를 어떻게 처리할지는 **리소스마다 각각 정해야 한다.** 정해진 정답이 없다.

예)
- HTML FORM으로 입력한 정보로 회원 가입, 주문 등에 사용
- 게시판 글쓰기, 댓글 달기 (서버가 아직 식별하지 않은 새 리소스 생성)
- 신규 주문 생성
- 기존 자원에 데이터 추가 (예: 한 문서 끝에 내용 추가)

### POST 메서드 총정리

1. **새 리소스 생성(등록)**: 서버가 아직 식별하지 않은 새 리소스를 생성
2. **요청 데이터 처리**: 단순 생성/변경을 넘어, 프로세스를 처리해야 하는 경우
   - 예) 주문에서 결제 → 배달 시작 → 배달 완료처럼 값 변경을 넘어 프로세스 상태를 변경해야 할 때
   - 예) `POST /orders/{orderId}/start-delivery` (컨트롤 URI)
3. **다른 메서드로 처리하기 애매한 경우**
   - 예) JSON으로 조회 데이터를 넘겨야 하는데 GET을 사용하기 어려운 경우
   - 애매하면 POST를 사용한다.

## PUT

- 리소스를 **대체**한다. 리소스가 없으면 생성한다. (기존 것을 덮어버리는 느낌)
- **클라이언트가 리소스를 식별**한다. 즉 클라이언트가 리소스의 위치(URI)를 알고 직접 지정한다.

리소스가 있는경우

<img width="606" height="348" alt="image" src="https://github.com/user-attachments/assets/b7093e18-6654-41e0-a6e7-19e62ff6f7e3" />
<img width="593" height="328" alt="image" src="https://github.com/user-attachments/assets/71e6c8b3-a64e-4237-856f-676da35f5ec1" />

리소스가 없는경우

<img width="534" height="326" alt="image" src="https://github.com/user-attachments/assets/ace505b2-8359-4c80-b35c-06aaef74dfd0" />
<img width="599" height="328" alt="image" src="https://github.com/user-attachments/assets/238d5dba-f81f-4043-967e-266d87dab786" />

참고: PUT은 완전히 리소스를 대처한다.
<img width="607" height="346" alt="image" src="https://github.com/user-attachments/assets/24f5ab55-9cc9-4fea-b93e-1ca70259ca9a" />
<img width="610" height="347" alt="image" src="https://github.com/user-attachments/assets/03b567b1-a27d-4cd7-860f-bc7ebe8af282" />


- 반면 POST는 `/members`로 등록만 요청할 뿐, 리소스의 실제 위치까지는 알지 못한다.
  (리소스 위치는 서버가 결정한다.)

## PATCH

- 리소스의 **부분**을 변경한다.
- PUT은 리소스를 통째로 대체하지만, PATCH는 일부만 변경한다.
<img width="616" height="362" alt="image" src="https://github.com/user-attachments/assets/edb70fb0-eea0-4478-8c63-ab2862cb3e76" />
<img width="591" height="345" alt="image" src="https://github.com/user-attachments/assets/19f711c9-4e06-455a-a4a5-2ee73ae0ede3" />

## DELETE

- 리소스를 제거한다.

---

# HTTP 메서드 속성

HTTP 메서드에는 **안전(Safe)**, **멱등(Idempotent)**, **캐시가능(Cacheable)** 이라는 속성이 있다.

## 안전 (Safe)

- 호출해도 **리소스를 변경하지 않는다.**
- 안전은 해당 리소스가 변경되는지만 고려하며, 그 외 부수 효과(예: 계속 호출해서 로그가 쌓여 장애가 발생하는 경우 등)까지는 고려하지 않는다.

예) `GET /members/100`을 100번 호출해도 회원 정보 자체는 변하지 않으므로 GET은 안전한 메서드다.
100번 호출해서 로그가 쌓이더라도, HTTP에서의 "안전"은 **요청 대상 리소스가 변하는지**만 보기 때문에 여전히 안전한 메서드로 본다.

## 멱등 (Idempotent)

- 한 번 호출하든 100번 호출하든 **결과가 같다.**

| 메서드 | 멱등 여부 |
|---|---|
| GET | 멱등 (몇 번을 조회해도 같은 결과) |
| PUT | 멱등 (같은 요청을 여러 번 해도 결과는 같음 — 대체) |
| DELETE | 멱등 (여러 번 삭제해도 결과는 같음) |
| POST | **멱등 아님** (두 번 호출하면 같은 처리가 중복 발생할 수 있음, 예: 중복 주문/중복 결제) |

### 멱등의 활용: 자동 복구 메커니즘

서버가 타임아웃 등으로 정상 응답을 주지 못했을 때, 클라이언트가 같은 요청을 다시 보내도 되는지 판단하는 근거가 된다.

주의: **멱등은 외부 요인으로 인해 중간에 리소스가 바뀌는 상황까지는 고려하지 않는다.**

예)
```
사용자1: GET -> username:A, age:20
사용자2: PUT -> username:A, age:30
사용자1: GET -> username:A, age:30  (사용자2의 영향으로 바뀐 데이터가 조회됨)
```

## 캐시가능 (Cacheable)

- 응답 결과를 저장해두고 **다시 사용**할 수 있는지에 대한 속성이다.
- GET, HEAD, POST, PATCH가 캐시 가능하다고 되어 있지만,
  **실제로는 GET, HEAD 정도만 캐시로 사용**된다.
- POST, PATCH는 캐시 키에 본문(body) 내용까지 고려해야 하는데, 이를 구현하기가 쉽지 않기 때문이다.
