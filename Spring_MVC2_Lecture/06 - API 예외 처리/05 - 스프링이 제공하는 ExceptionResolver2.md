# 스프링이 제공하는 ExceptionResolver2
### 중요 키워드
- DefaultHandlerExceptionResolver
### 내용 
- DefaultHandlerExceptionResolver는 스프링 내부에서 발생하는 스프링 예외를 처리
- 대표적인 오류 파라미터 바인딩 시점에 타입이 안맞으면 TypeMismatchException이 발생하는데 서블릿 컨테이너까지 예외가 넘어가고 500 오류가 발생한다.
- 파라미터 바인딩 오류는 클라이언트 오류로 HTTP 상태 코드 400이 발생해야 되도록 해야 한다. 
- DefaultHandlerExceptionResolver는 500오류가 아니라 400 오류로 변경을 해주는 역할을 한다.

DefaultHandlerExceptionResolver.handleTypeMismatch를 보면response.sendError(HttpServletResponse.SC_BAD_REQUEST) (400)를 사용한다. 
sendError(400)을 호출했기에 WAS에서 오류 페이지/error를 요청한다.

~~~java
@GetMapping("/api/default-handler-ex")
public String defaultException(@RequestParam Integer data) {
    return "ok";
}
~~~

#### 실행
~~~
    "status": 400,
    "error": "Bad Request",
~~~
### 요약
- DefaultHandlerExceptionResolver는 스프링 내부 예외를 처리한다. 
- 클라이언트 오류가 발생하면 그에 맞는 오류 코드를 변경해준다. 
- HandlerExceptionResolver를 사용하기에 너무 복잡하다. @ExceptionHandler를 사용하면 쉽게 예외처리가 가능하다.


# 출처
스프링 MVC 2편 - 백엔드 웹 개발 활용 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-2/dashboard?cid=327260
