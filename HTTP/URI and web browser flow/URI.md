# URI, URL, URN

## URI란?

**자원을 식별하는 것**

- **U**niform: 리소스를 식별하는 통일된 방식
- **R**esource: 자원, URI로 식별할 수 있는 모든 것 (제한 없음)
- **I**dentifier: 다른 항목과 구분하는 데 필요한 정보

URI 안에 URL, URN이 포함되는 개념이다.

## URL, URN

- **URL** (Locator): 리소스가 **있는 위치**를 지정
- **URN** (Name): 리소스에 **이름**을 부여

위치(URL)는 변할 수 있지만, 이름(URN)은 변하지 않는다.
예) 도서의 ISBN 번호는 도서의 위치가 바뀌어도 변하지 않는 고유 이름이다.

다만 URN은 이름만으로 실제 리소스를 찾아내는 방법이 보편화되어 있지 않아서,
실무에서는 **URL을 URI와 같은 의미로** 사용하는 경우가 많다.

> 이후 정리에서는 URL과 URI를 같은 의미로 사용한다.

## URL 전체 문법

```
scheme://[userinfo@]host[:port][/path][?query][#fragment]
```

예시:

```
https://www.google.com:443/search?q=hello&hl=ko
```

| 구성요소 | 값 |
|---|---|
| scheme(프로토콜) | https |
| host(호스트명) | www.google.com |
| port(포트) | 443 |
| path(패스) | /search |
| query(쿼리 파라미터) | q=hello&hl=ko |

## 구성요소별 설명

### scheme

- 주로 **프로토콜**을 사용한다.
- 프로토콜: 어떤 방식으로 자원에 접근할지에 대한 규칙. (http, https, ftp 등)
- http는 80번, https는 443번 포트를 주로 사용하며, 이 포트 번호는 생략 가능하다.

### userinfo

- 사용자 정보를 포함해서 인증할 때 사용.
- URL에서는 거의 사용하지 않는다.

### host

- 호스트명. 도메인명 또는 IP 주소를 직접 사용할 수도 있다.

### PORT

- 접속 포트.
- 일반적으로 생략한다. (http는 80, https는 443 이 기본값이라 생략 가능)

### path

- 리소스 경로. 계층적 구조로 되어 있다.
- 예) `/items/iphone12`

### query

- `key=value` 형태.
- `?`로 시작하고, `&`로 추가 파라미터를 이어 붙인다.
  예) `?keyA=valueA&keyB=valueB`
- query parameter, query string 등으로 불리며, 웹 서버에 전달하는 문자열 형태의 파라미터다.

### fragment

- html 내부 북마크(앵커) 등에 사용한다. 예) `#section2`
- 서버에는 전송되지 않으며, 브라우저(클라이언트)에서 페이지 내 특정 위치로 이동시킬 때 사용된다.

#출처

모든 개발자를 위한 HTTP 웹 기본 지식
- https://www.inflearn.com/course/http-%EC%9B%B9-%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC/dashboard?cid=326277
