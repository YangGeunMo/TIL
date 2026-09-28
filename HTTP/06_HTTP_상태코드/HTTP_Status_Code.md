# HTTP 상태코드

## 2xx(Successful) - 성공 
- 2xx는 클라이언트의 요청을 성공적으로 처리한다.

### 200 OK
- 요청이 성공했다는 의미다. 조회 성공, 처리 성공 등 대부분의 성공 상황에서 사용된다.
- 200 OK는 응답 메시지 message body에 요청 데이터도 같이 반환한다. 

### 201 Created 
- 요청을 성공해서 새로운 리소스가 생성되었다는 뜻이다. POST로 요청할때 회원등록을 하면 서버에서 응답을 Location 헤더에 리소스 위치를 알려준다.
<img width="1430" height="745" alt="image" src="https://github.com/user-attachments/assets/802610cc-eed0-4ba3-8361-b1b58df30495" />

### 202 Accepted 
- 요청이 접수되었으나 처리가 안료되지 않았다는 뜻이다. 서버는 요청을 받는데 나중에 처리한다.
- 대용량 파일 업로드 처리, 배치 작업, 이메일 대량 발송 같은 오래 걸리는 비동기 작업에 사용한다.

### 204 No Content 
- 서버가 요청을 성공적으로 수행했지만 응답 페이로드 본문에 보낼 메시지가 없다는 뜻이다.

기존 성공 응답 예시
```
HTTP/1.1 200 OK
Content-Type: application/json

{"name": "김철수", "email": "kim@example.com"}
                  ↑
            이 부분이 바디(본문)
```

204 No Content
```
HTTP/1.1 204 No Content
Content-Type: application/json

(빈 줄... 아무것도 없음)
↑
바디가 완전히 비어있음
```

## 3xx - 리다이렉션
- 요청을 완료하기 위해 유저 에이전으틔 추가 조치가 필요하다.
- 웹 브라우저는 3xx응답 결과에 Location 헤더가 있으면 Location 위치로 자동 이동된다.
- 예시로 URL을 www.test1.com 에서 www.test2.com 으로 변경했는데 사람들은 이전 주소를 기억으로 사용한다. 서버 응답 결과의 Location 위치를 www.test2.com으로 해놓으면 자동으로 www.test2.com를 요청해서 응답 결과를 받는다.
<img width="1243" height="710" alt="image 2" src="https://github.com/user-attachments/assets/15cc1eef-958f-41ab-87d4-6b6d5ab3632e" />

## 리다이렉션의 종류

### 301,308 영구 리다이렉션
- 특정 소스의 URI가 영구적으로 이동한다.
- 리소스의 URI가 영구적으로 이동 (www.test1.com 요청하면 변경된 www.test2.com으로 이동)
- 원래 URL사용 x, 검색 엔진도 변경인지( 변경된 것을 인지하고 이전 URL사용은 금지, 검색엔진 구글 등도 인식하여 변경된 URL로 인식한다)

### 301 Moved Permanently
- 리다이렉트시 요청 메서드가 GET으로 변하고 본문이 제거될 수 있다


POST 요청으로 데이터를 전송한 경우

```
클라이언트 요청:
POST www.test1.com/login
Body: {"username": "kim", "password": "1234"}

서버 응답:
HTTP/1.1 301 Moved Permanently
Location: www.test2.com/login

브라우저가 자동으로 변환:
GET www.test2.com/login  ← POST가 GET으로 변함
Body: (본문 제거됨)  ← 데이터 사라짐

결과: 로그인 데이터 손실 

```
<img width="1233" height="762" alt="image 3" src="https://github.com/user-attachments/assets/d332b226-ac4e-4762-881f-85f51181a1a9" />


### 308 Permanently Redirect
- 301과 기능은 같다
- 리다이렉트시 요청 메서드와 본문 유지(처음 POST를 보내면 리다이렉트도 POST 유지)

```
클라이언트 요청:
POST www.test1.com/login
Body: {"username": "kim", "password": "1234"}

서버 응답:
HTTP/1.1 308 Permanent Redirect
Location: www.test2.com/login

브라우저가 그대로 유지:
POST www.test2.com/login  ← POST 유지!
Body: {"username": "kim", "password": "1234"}  ← 데이터 유지!

결과: 로그인 성공 

```
<img width="1231" height="817" alt="image 4" src="https://github.com/user-attachments/assets/f2af3c98-63b2-4ac6-9638-ed160c7ff4eb" />


### 302, 307, 303 - 일시적인 리다이렉션
- 리소스의 URI가 이시적으로 변경된다. 따라서 검색 엔진 등에거 URL을 변경하면 안된다.

### 302 Found 
- 리다이렉트시 요청 메서드가 GET으로 변하고 본문이 제거될 수 있다.
```
클라이언트:
POST www.test.com/signup
Body: {"name": "김철수", "email": "kim@example.com"}

서버 응답 (유지보수 중):
HTTP/1.1 302 Found
Location: www.temp.com/signup

브라우저 처리:
GET www.temp.com/signup  ← POST가 GET으로 변할 수 있음
Body: (본문 제거될 수 있음)

결과: 데이터 손실 위험 
```

### 307 Temporary Redirect 
- 302와 같다, 리다이렉트 요청시 요청 메서드와 본문 유지(절대 변경하면 안된다.)
```
클라이언트:
POST www.test.com/signup
Body: {"name": "김철수", "email": "kim@example.com"}

서버 응답 (유지보수 중):
HTTP/1.1 307 Temporary Redirect
Location: www.temp.com/signup

브라우저 처리:
POST www.temp.com/signup  ← POST 반드시 유지
Body: {"name": "김철수", "email": "kim@example.com"}  ← 데이터 유지

결과: 데이터 안전함 
```
### 303 See Other 
- 302와 같다. 리다이렉트 요청시 요청 메서드가 GET으로 변경한다.
```
클라이언트:
POST www.test.com/signup
Body: {"name": "김철수", "email": "kim@example.com"}

서버 응답:
HTTP/1.1 303 See Other
Location: www.temp.com/result

브라우저 처리:
GET www.temp.com/result  ← GET으로 반드시 변경
Body: (제거됨)

결과: POST에서 GET으로 명확하게 변환
```

### 일시적인 리다이렉션 - PRG :Post/Redirect/Get
- POST로 주문후 웹 브라우저를 새로고침하면 문제가 발생한다. 새로고침은 다시 요청이란 뜻으로 중복 주문이 될 수 있다.

PRG 사용전
<img width="1451" height="856" alt="image 5" src="https://github.com/user-attachments/assets/220b19d6-0308-46fc-9203-f5c88cf54910" />
새로고침 후 다시 POST로 요청되어 주문이 중복된다. 

PRG 사용후
<img width="1434" height="868" alt="image 6" src="https://github.com/user-attachments/assets/2b2ac36d-175b-4857-a864-de256ac4bb90" />

- PRG 방식으로 주문 중복을 방지할 수 있다. 
- POST로 주문후 주문 결과 화면을 GET 메서드로 리다이렉트하면 된다. 새로고침을 해도 결과 화면을 GET으로 조회한다.

그래서 302,307,303 중 어떤걸 사용해야 할까?
현실은 307,303을 권장하지만 많은 애플리케이션 라이브러리들이 302를 기본값으로 사용한다.
자동 리다이렉션시 GET으로 변해도 되면 그냥 302를 사용해도 문제가 없다. 

### 304 Not Modified 
- 캐시를 목적으로 사용한다. 클라이언트에게 리소스가 수정되지 않았다고 알려주고 클라이언트는 로컬 PC의 저장된 캐시를 재사용한다. 캐시로 리다이렉트를 한다.

```
[첫 번째 요청]
GET /image.jpg
↓
서버 응답 (200 OK):
image data... (실제 파일)
ETag: "abc123"  ← 파일의 버전 정보
Last-Modified: 2024-09-28

[클라이언트 저장]
로컬 PC 캐시:
- 이미지 파일 저장
- ETag: "abc123" 저장
- Last-Modified: 2024-09-28 저장

---

[두 번째 요청 - 캐시 검증]
GET /image.jpg
If-None-Match: "abc123"  ← 버전 확인
↓
서버가 확인:
현재 파일의 ETag도 abc123
↓
서버 응답 (304 Not Modified):
(응답 본문 없음)  ← 캐시 사용

[클라이언트]
로컬 PC의 캐시된 이미지 사용
```

## 4xx - 클라이언트 오류 
- 클라이언트의 요청에 잘못된 문법등으로 서버가 요청을 수행할 수 없다. 오류의 원인은 클라이언트다.

### 400 Bad Request
- 클라이언트가 잘못된 요청을 해서 서버가 요청을 처리할 수 없다.
- 클라이언트가 요청 구문, 메시지 등 오류로 인해 발생한다. 클라이언트는 요청 내용을 다시 확인하고 보내야 한다.
- 예시) 잘못된 파라미터나 API스펙이 맞지 않을때

### 401 Unauthorized
- 클라이언트가 해당 리소스에 대한 인증이 필요할때
- 클라이언트가 로그인하지 않음 (인증 안 됨)
- 누가 당신인지 증명해야 접근 가능
- 서버가 인증 방법을 WWW-Authenticate 헤더로 알려준다.
```
인증(Authentication) = "당신이 정말 김철수인가요?"
                      (본인 확인 - 로그인)
                      ↓
인가(Authorization) = "김철수는 ADMIN 권한이 있나요?"
                     (권한 확인)
  ```
### 403 Forbidden
- 서버가 요청을 이해했지만 승인을 거부
- 주로 인증 자격 증명은 있지만, 접근 권한이 불충분한 경우 
- 예시 ) 어드민 등급이 아닌 사용자가 로그인은 했지만, 어드민 등급의 리소스에 접근한 경우

### 404 Not Found 
- 요청 리소스를 찾을 수 없다는 뜻이다. 요청 리소스가 서버에 없거나 클라이언트가 권한이 부족한 리소스에 접근할 때, 해당 리소스를 숨기고 싶을 때 사용한다.

### 5xx(Server Error) - 서버오류
- 서버 문제로 오류가 발생했을 때 생기는 오류이다.
- 서버에 문제가 있기 때문에 재시도하면 성공할 수 있다.(복구되거나 등)

### 500 Internal Server Error
- 서버 문제로 오류 발생, 애매하면 500 오류
- 서버 내부문제로 오류발생했을 때나타난다. 애매하면 500 오류

### 503 Service Unavailable 
- 서비스 이용 불가 상태
- 서버가 일시적인 과부하 또는 예정된 작업으로 잠시 요청을 처리할 수 없다.
- Retry-After 헤더 필드로 얼마뒤에 복구되는지 보낼 수 있다. 

# 출처
모든 개발자를 위한 HTTP 웹 기본 지식 
- https://www.inflearn.com/course/http-%EC%9B%B9-%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC?cid=326277

