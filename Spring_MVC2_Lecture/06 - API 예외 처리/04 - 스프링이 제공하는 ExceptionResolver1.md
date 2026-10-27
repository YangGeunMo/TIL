# 스프링이 제공하는 ExceptionResolver1

#### 중요 키워드
- ResponseStatusExceptionResolver

#### 내용 복습
ResponseStatusExceptionResolver는 HTTP 상태 코드를 지정할 수 있다.

두 가지를 처리한다.
- @ResponseStatus가 달려 있는 예외
- ResponseException 예외

### @ResponseStatus

~~~java
@ResponseStatus(code = HttpStatus.BAD_REQUEST,reason = "잘못된 요청 오류")
public class BadRequestException extends RuntimeException{
}
~~~


@ResponseStatus를 적용하면 HTTP 상태 코드를 변경한다.
BadRequestException예외가 컨트롤러 밖으로 넘어가면 ResponseStatusExceptionResolver 예외가@ResponseStatus를 확인해서 오류 코드와 메시지를 담는다.

ResponseStatusExceptionResolver코드를 보면 response.sendError(statusCode, resolvedReason)을 호출한다. sendError()를 호출했기에 WAS에서 오류 페이지(/error)를 요청한다.


### 메시지 기능
`reason` 을 `MessageSource` 에서 찾는 기능도 제공한다. `reason = "error.bad"`

~~~java
@ResponseStatus(code = HttpStatus.BAD_REQUEST,reason = "error.bad")
~~~

**messages.properties**에서 적용할 수 있다.  
error.bad라는 키가 있어야 한다.
~~~
error.bad=잘못된 요청 오류입니다. 메시지 사용
~~~

### ResponseStatusException
- @ResponseStatus는 개발자가 직접 변경할 수 없는 예외에는 적용할 수 없다.( 코드를 수정할 수 없는 라이브러리 등) 
- 그때`ResponseStatusException`예외를 사용하면 된다.

~~~java
@GetMapping("/api/response-stauts-ex2")
public String responseStatusEx2() {
    throw new ResponseStatusException(HttpStatus.NOT_FOUND, "error.bad", new IllegalArgumentException());
}
~~~

### 요약
- ResponseStatusExceptionResolver는 @ResponseStatus와 ResponseStatusException의 예외를 처리해준다.
- @ResponseStatus는 상태 코드와 메시지를 전달할 수 있다.
- ResponseStatusException은 코드를 수정할 수 없는 라이브러리 등에 @ResponseStatus를 사용할 수 없을 때 사용된다.

# 출처
스프링 MVC 2편 - 백엔드 웹 개발 활용 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-2/dashboard?cid=327260
