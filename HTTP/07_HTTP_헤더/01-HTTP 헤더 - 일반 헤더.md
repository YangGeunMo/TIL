# HTTP 헤더 1편 TIL

## HTTP 헤더의 용도

HTTP 전송에 필요한 모든 부가정보를 담고 있습니다.

- 메시지 바디의 내용
- 메시지 바디의 크기
- 압축 방식
- 인증 정보
- 요청 클라이언트 정보
- 서버 정보
- 캐시 관리 정보 등

---

## HTTP Body

### RFC2616 (과거)
<img width="889" height="325" alt="image" src="https://github.com/user-attachments/assets/f96b2b1e-267c-4fb1-878f-3a56d6a76bbf" />

- **엔티티 본문**: 요청이나 응답에 전달할 실제 데이터
- **엔티티 헤더**: 엔티티 본문 데이터를 해석할 수 있는 정보 제공
  - 데이터 유형(json, html)
  - 데이터 길이
  - 압축 정보 등

### RFC7230 (최신)
<img width="880" height="332" alt="image 2" src="https://github.com/user-attachments/assets/49cb2b61-fe0f-468d-abea-f701d63ee06a" />

- **메시지 본문(페이로드)**: 요청이나 응답에서 전달될 실제 데이터
- **표현 헤더**: 표현 데이터를 해석할 수 있는 정보 제공

---

## 표현 헤더

### Content-Type
<img width="613" height="480" alt="image 3" src="https://github.com/user-attachments/assets/81dedace-5d56-4b78-a387-410aefc8d061" />

표현 데이터의 형식을 설명합니다.

- 미디어 타입(MIME type) 또는 문자 인코딩을 나타냅니다.
- **예시**: `text/html; charset=utf-8`, `application/json`

### Content-Encoding

표현 데이터 압축 방식을 명시합니다.

- 데이터를 압축하여 전달하기 위해 사용합니다.
- 송신자: 데이터 압축 후 인코딩 헤더 추가
- 수신자: 인코딩 헤더 정보로 압축 해제

### Content-Language
<img width="506" height="591" alt="image 4" src="https://github.com/user-attachments/assets/732b20ea-01b3-41f1-bd5e-efd944280306" />

표현 데이터의 자연 언어를 표현합니다.

- **예시**: `ko` (한국어), `en` (영어)

### Content-Length

표현 데이터의 길이를 바이트 단위로 명시합니다.

- **주의**: Transfer-Encoding(전송 코딩)을 사용하면 Content-Length를 함께 사용하면 안 됩니다.

---

## 협상(콘텐츠 네고시에이션)
<img width="1169" height="520" alt="image 5" src="https://github.com/user-attachments/assets/6c9fb8bf-33a8-4a58-8348-cc1c2d40059e" />

클라이언트가 선호하는 표현을 요청하는 방식입니다.

### 협상 헤더 (모두 요청에서만 사용)

- **Accept**: 클라이언트가 선호하는 미디어 타입
- **Accept-Encoding**: 클라이언트가 선호하는 압축 인코딩 방식
- **Accept-Charset**: 클라이언트가 선호하는 문자 인코딩
- **Accept-Language**: 클라이언트가 선호하는 자연 언어

### 협상과 우선순위1 - Quality Values(q)
<img width="1077" height="250" alt="image 6" src="https://github.com/user-attachments/assets/5d774d20-48d2-426f-94a6-a9de55d2e54f" />

- 0~1 범위에서 숫자가 클수록 높은 우선순위
- 생략하면 기본값 1

**예시**: `Accept-Language: ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7`

- `ko-KR`: q=1 (생략)
- `ko`: q=0.9
- `en-US`: q=0.8
- `en`: q=0.7

### 협상과 우선순위2 - 구체성

구체적인 것이 일반적인 것보다 우선합니다.

**예시**: `Accept: text/*, text/plain, text/plain;format=flowed, */*`

1. `text/plain;format=flowed` (가장 구체적)
2. `text/plain`
3. `text/*`
4. `*/*` (가장 일반적)

---

## 전송 방식

### 단순 전송
<img width="1288" height="562" alt="image 8" src="https://github.com/user-attachments/assets/b953161e-1b05-432f-a7ba-6d3b6a1dd897" />

- **Content-Length**: 한 번에 전송하고 한 번에 받습니다.

### 압축 전송
<img width="1307" height="577" alt="image 9" src="https://github.com/user-attachments/assets/3918fb08-287c-4b68-9933-0b48cdf83cd1" />

- gzip 등의 방식으로 압축하여 응답합니다.
- **Content-Encoding**: 압축 방식을 클라이언트에게 알려줍니다.

### 분할 전송
<img width="1330" height="604" alt="image 10" src="https://github.com/user-attachments/assets/f0afb372-7cc8-4735-9ef7-a0de82736769" />

- **Transfer-Encoding**: chunked
- 데이터를 덩어리 단위로 나누어 전송합니다.
- **주의**: 분할 전송 시 Content-Length를 지정하면 안 됩니다.

### 범위 전송
<img width="1282" height="740" alt="image 11" src="https://github.com/user-attachments/assets/d4d0b29e-794f-4e97-8b46-bfd88bd91a62" />

- **Range / Content-Range**: 데이터 수신 중 중단되면, 처음부터 다시 받지 않고 그 지점부터 다시 요청합니다.

---

## 일반 정보 헤더

### From

- **용도**: 유저 에이전트의 이메일 정보
- **사용 빈도**: 매우 낮음
- **주 사용처**: 검색 엔진 봇의 크롤링 시 사용
- **방향**: 요청(Request Header)에서만 사용

### Referer

- **용도**: 이전 웹 페이지 주소
- **동작**: A→B로 이동할 때, B를 요청하면서 `Referer: A` 포함
- **활용**: 유입경로 분석 (어디서 들어왔는지, 검색/광고/SNS 등)
- **방향**: 요청(Request Header)에서만 사용

### User-Agent

- **용도**: 클라이언트 애플리케이션 정보 (웹 브라우저, OS 등)
- **활용**:
  - 통계 정보 (크롬 사용자 비율 등)
  - 브라우저별 장애 파악
  - 모바일 유저 비율에 따른 디자인 개선
- **방향**: 요청(Request Header)에서만 사용

### Server

- **용도**: 요청을 처리하는 서버의 소프트웨어 정보
- **예시**: `Apache/2.2.22(Debian)`, `nginx`
- **활용**: 클라이언트가 웹 서버 종류 파악 가능
- **방향**: 응답(Response Header)에서만 사용

### Date

- **용도**: 메시지가 발생한 날짜와 시간
- **예시**: `Date: Tue, 15 Nov 1994 08:12:31 GMT`
- **방향**: 응답(Response Header)에서 사용

---

## 특별한 정보 헤더

### Host
<img width="1325" height="634" alt="image" src="https://github.com/user-attachments/assets/abafc565-fef4-43ea-8123-1d4bd695175c" />
<img width="1338" height="691" alt="image" src="https://github.com/user-attachments/assets/cab36bc0-1de2-47ea-a19d-937a88cf2698" />

- **용도**: 요청한 호스트 정보(도메인)
- **필수 여부**: 필수로 전송해야 합니다.
- **필요한 이유**:
  - 하나의 IP 주소에 여러 도메인이 적용된 경우
  - 하나의 서버가 여러 도메인을 처리하는 경우
  - Host 헤더 없으면 서버가 어느 도메인에 응답할지 판단 불가
- **방향**: 요청(Request Header)에서만 사용

### Location

- **용도**: 페이지 리다이렉션
- **동작**: 웹 브라우저는 3xx 응답에 Location 헤더가 있으면 자동으로 해당 위치로 이동합니다.
- **방향**: 응답(Response Header)에서 사용

### Allow

- **용도**: 허용 가능한 HTTP 메서드 명시
- **사용 시기**: 405 (Method Not Allowed) 응답과 함께 사용
- **예시**: `Allow: GET, HEAD, PUT` → 이 세 메서드만 사용 가능
- **방향**: 응답(Response Header)에서 사용

### Retry-After

- **용도**: 유저 에이전트가 다음 요청을 할 때까지 기다려야 할 시간 명시
- **사용 시기**: 503 (Service Unavailable) 응답과 함께 사용
- **표기 방식**:
  - 초 단위: `Retry-After: 120`
  - 날짜/시간: `Retry-After: Fri, 31 Dec 1999 23:59:59 GMT`
- **방향**: 응답(Response Header)에서 사용

---

## 인증 헤더

### Authorization

- **용도**: 클라이언트 인증 정보를 서버에 전달
- **형식**: `Authorization: Basic xxxxxxxxxxxxxxxx`
  - `Basic`: 인증 방식
  - `xxxxxxxxxxxxxxxx`: Base64로 인코딩된 인증 정보
- **방향**: 요청(Request Header)에서 사용

### WWW-Authenticate

- **용도**: 리소스 접근 시 필요한 인증 방법 정의
- **사용 시기**: 401 (Unauthorized) 응답과 함께 사용
- **특징**: 여러 인증 방식을 동시에 제시 가능
- **예시**: `WWW-Authenticate: Newauth realm="apps", type=1, title="Login to apps", Basic realm="simple"`
  - Newauth 인증 방식 제시
  - Basic 인증 방식 제시
- **클라이언트 동작**: 제시된 방식 중 하나를 선택하여 Authorization 헤더로 요청
- **방향**: 응답(Response Header)에서 사용

---

## 쿠키

### 쿠키의 필요성

- HTTP는 무상태(stateless) 프로토콜이다 .
- HTTP는 무상태 프로토콜이므로 클라이언트와 서버가 요청과 응답을 주고 받으면 연결이 끊기는데 다시 요청하면 서버는 이전 요청을 기억 못한다. 
- 요청시 사용자 정보를 포함해서 보내면 서버는 안녕하세요 A님을 응답한다. 하지만 매번 요청할때마다 사용자 정보를 포함하기엔 번거롭다. 

**쿠키 없는 경우**:
<img width="1246" height="521" alt="image" src="https://github.com/user-attachments/assets/8162e0df-e3a5-48d2-a1a3-6db4b3f31142" />

- 클라이언트A가 로그인해도, 다음 요청에서는 서버가 이전 요청을 기억하지 못함
- 매번 요청 시 사용자 정보를 포함해야 함 (비효율적)

**쿠키 있는 경우**:
<img width="1260" height="692" alt="image" src="https://github.com/user-attachments/assets/6e5a828e-055b-416b-b97d-fb1bb5573c09" />

- 로그인 요청 시 서버가 `Set-Cookie`로 사용자 정보를 클라이언트에 저장
- 이후 모든 요청에 쿠키가 자동으로 포함되어 전송됨
- 서버는 쿠키로 사용자 식별 가능

### 쿠키 기본 구조

- **Set-Cookie**: 서버에서 클라이언트에게 쿠키 전달 (응답)
- **Cookie**: 클라이언트가 서버에서 받은 쿠키를 저장했다가, HTTP 요청 시 서버로 전달 (요청)

### 쿠키 사용처

- 사용자 로그인 세션 관리
- 광고 정보 트래킹

### 쿠키 주의사항

- **트래픽**: 쿠키 정보는 항상 서버에 전송되므로 추가 트래픽 발생
  - 최소한의 정보만 저장 (세션 ID, 인증 토큰 등)
  - 웹 브라우저 내부에만 저장하려면 웹 스토리지 사용
- **보안**: 민감한 데이터는 쿠키에 저장하면 안 됨
  - 주민등록번호, 신용카드 번호 등 금지

### 쿠키 생명주기

**만료일 지정**:
- `Set-Cookie: expires=Sat, 26-Dec-2020 04:39:21 GMT`
- 만료일이 되면 쿠키 자동 삭제

**최대 유지 시간**:
- `Set-Cookie: max-age=3600` (3600초)
- 0 또는 음수를 지정하면 쿠키 즉시 삭제

**세션 쿠키 vs 영속 쿠키**:
- **세션 쿠키**: 만료 날짜 생략 → 브라우저 종료 시까지만 유지
- **영속 쿠키**: 만료 날짜 입력 → 해당 날짜까지 유지

### 쿠키 도메인

- **명시된 경우**: 명시한 도메인 + 서브 도메인에서 쿠키 접근 가능
- **생략된 경우**: 현재 문서 기준 도메인에만 적용됨

### 쿠키 경로

- 지정한 경로를 포함한 하위 경로 페이지에서만 쿠키 접근 가능
- `path=/` 루트로 지정 권장

**예시** (`path=/home` 지정 시):
- `/home` → 가능
- `/home/level1` → 가능
- `/home/level1/level2` → 가능
- `/hello` → 불가능

### 쿠키 보안

**Secure**:
- 기본: HTTP와 HTTPS 모두에서 전송
- `Secure` 적용 시: HTTPS에서만 전송

**HttpOnly**:
- XSS(Cross-Site Scripting) 공격 방지
- 자바스크립트에서 접근 불가능
- HTTP 전송으로만 전달 가능

**SameSite**:
- CSRF(Cross-Site Request Forgery) 공격 방지
- 요청 도메인과 쿠키 도메인이 같은 경우에만 쿠키 전송

---

## 핵심 정리

- HTTP 헤더는 요청과 응답에 부가정보를 담습니다.
- 협상 헤더로 클라이언트-서버 간 최적의 표현을 선택할 수 있습니다.
- 쿠키는 HTTP 무상태 프로토콜의 한계를 극복하기 위한 중요한 메커니즘입니다.
- 쿠키는 편리하지만 보안과 프라이버시를 고려하여 사용해야 합니다.

# 출처
모든 개발자를 위한 HTTP 웹 기본 지식 
- https://www.inflearn.com/course/http-%EC%9B%B9-%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC/dashboard?cid=326277
