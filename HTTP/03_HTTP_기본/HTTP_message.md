# HTTP 메시지

## HTTP 메시지 구조 
<img width="1401" height="773" alt="image" src="https://github.com/user-attachments/assets/f4b75382-1990-48c2-8668-345f7dcfcf50" />

색상 별로 잘 알아 두자

# HTTP 응답 메시지 구조 
<img width="1441" height="445" alt="image" src="https://github.com/user-attachments/assets/27aa94b3-de30-4821-a4e8-e1d07972e11b" />


### 시작 라인 - 요청 메시지
<img width="641" height="193" alt="image" src="https://github.com/user-attachments/assets/6af66d0b-4a29-4b5b-8c24-4b7de5554bd8" />

- start-line은 request-line / status-line 으로 구분 되는데
- request-line = method SP(공백) request-target SP HTTP-version CRLF(엔터)이다.
- request-target은 요청 대상을 나타냄

- HTTP 메서드는 GET: 조회
- 요청 대상 (/search?q=hello&hl=ko)
- HTTP Version

### 시작 라인 - 요청 메시지 - HTTP 메서드

- 종류: GET, POST, PUT, DELETE 등등이 있다.
- 이 메서드는 서버가 수행해야 할 동작을 지정한다.
- GET : 리소스 조회한다.
- POST 요청 내역을 처리한다.

### 시작 라인 - 요청 메시지 - 요청 대상
- absolute-path[?query] (절대경로[?쿼리])은 HTTP 요청의 rqeust-target(요청 대상) 형식을 설명하는 표현이다.
- 절대 경로 = "/"로 시작하는 경로

### 시작 라인 - 요청 메시지 - HTTP 버전 

- HTTP Version은 클라이언트와 서버가 어떤 HTTP 버전으로 작성되었는지 알 수 있다.

# HTTP 응답 메시지 구조
<img width="511" height="271" alt="image" src="https://github.com/user-attachments/assets/c8f43d58-a05b-43de-8fcb-56e7534b7424" />

- start-line = request-line / status-line
- stauts-line = HTTP-version SP status-code SP reason-pharase CRLF

status-lien 구조
- HTTP 버전
- HTTP 상태 코드 : 요청 성공, 실패를 나타낸다.
 - 200 : 성공
 - 400 : 클라이언트 요청 오류
 - 500 : 서버 내부 오류
- 이유 문구 : OK를 뜻함 , 사람이 이해할 수 있는 짧은 상태 코드를 설명하는 글.

# HTTP 헤더

## HTTP 헤더 구조
<img width="1279" height="304" alt="image" src="https://github.com/user-attachments/assets/d0f9eb5f-6319-46cf-b719-63d718b6da34" />

- header-field = field-name ":" OWS field-value OWS (OWS: 띄어쓰기 허용)
- fild-name은 대소문자 구분이 없다.

### HHTP 헤더 용도
- HTTP 전송에 필요한 모든 부가정보가 있다.
  - 메시지 바디의 내용, 메시지 바디 크기, 압축, 인증, 요청 클라이언트(브라우저 정보) 등
- 이미 정해진 표준 헤더가 많다.
- 필요하면 임의의 헤더를 추가해서사용이 가능하다.

# HHTP 메시지 바디
<img width="628" height="307" alt="image" src="https://github.com/user-attachments/assets/588bc09d-deac-4dcc-9239-ed95a7750ce1" />

- 실제 전송할 데이터이다.
- HTML 문서, 이미지, 영상, JSON 등 byte로 표현할 수 있는 모든 데이터를 전송 가능하다. 

# 출처
모든 개발자를 위한 HTTP 웹 기본 지식
- https://www.inflearn.com/course/http-%EC%9B%B9-%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC?cid=326277#reviews

