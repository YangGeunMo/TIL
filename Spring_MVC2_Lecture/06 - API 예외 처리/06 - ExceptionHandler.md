# ExceptionHandler
## 키워드
- @ExceptionHandler
- HandlerExceptionResolver
## 내용
**HandlerExceptionResolver**
- HandlerExceptionResolver는 API응답에 필요없는 ModelAndView를 반환해야 했다.
- HttpServletResponse에 직접 응답 데이터를 넣어줬는데 불편하다.

**@ExceptionHandler**
- ExceptionHandler 어노테이션을 사용하면 간편하게 예외 처리를 할 수 있다. 
- 스프링은 ExceptionHandlerExceptionResolver를  기본으로 제공하고 `ExceptionResolver`에서 우선순위가 높다. 실무에서 API 예외 처리는 이 기능을 사용한다. 

**ErrorResult** 
- 예외가 발생했을 때 응답으로 사용하는 객체 
~~~java
@Data
@AllArgsConstructor
public class ErrorResult {
    private String code;
    private String message;
}
~~~

**@ExceptionHandler 예외 처리 방법**
- @ExceptionHandler 어노테이션을 선언하고 해당 컨트롤러에 처리하고 싶은 예외를 지정해준다.
~~~java
if (id.equals("bad")) {
    //메서드에 잘못된 인자가 넘어왔을 때IllegalArgumentException 발생
    //ExceptionResolver에서 ExceptionHandlerExceptionResolver를 실행하고 @ExceptionHandler있으면 호출한다.
    throw new IllegalArgumentException("잘못된 입력 값");
}
~~~


~~~java
@ResponseStatus(HttpStatus.BAD_REQUEST)
//IllegalArgumentException 예외 발생시 호출
@ExceptionHandler(IllegalArgumentException.class)
//ErrorResult가 json으로 반환
public ErrorResult illegalExHandler(IllegalArgumentException e) {
    log.error("[exceptionHandler] ex", e);
    return new ErrorResult("BAD", e.getMessage());
}

~~~
**실행 흐름**
- 컨트롤러를 호출한 결과 `IllegalArgumentException` 예외가 컨트롤러 밖으로 던져진다.
- 예외가 발생했으로 `ExceptionResolver` 가 작동한다. 가장 우선순위가 높은`ExceptionHandlerExceptionResolver` 가 실행된다.

- `ExceptionHandlerExceptionResolver` 는 해당 컨트롤러에 `IllegalArgumentException` 을 처리할 수 있는 `@ExceptionHandler` 가 있는지 확인한다.

- `illegalExHandle()` 를 실행한다. `@RestController` 이므로 `illegalExHandle()` 에도`@ResponseBody` 가 적용된다. 따라서 HTTP 컨버터가 사용되고, 응답이 다음과 같은 JSON으로 반환된다.

- `@ResponseStatus(HttpStatus.BAD_REQUEST)` 를 지정했으므로 HTTP 상태 코드 400으로 응답한다.


**우선순위**
- 지정한 예외 또는 그 예외 자식 클래스는 모두 잡을 수 있다.
- 스프링에서 우선순위는 자세한 것이 우선순위를 갖는다.
~~~java
@ExceptionHandler(부모예외.class) // exception
public String 부모예외처리()(부모예외 e) {}

@ExceptionHandler(자식예외.class) // RuntimeException
public String 자식예외처리()(자식예외 e) {}
~~~
- @ExceptionHandler 지정한 부모 클래스는 자식 클래스 까지 처리할 수 있다.
- 자식 예외가 발생하면 부모, 자식 예외 둘다 호출이 되는데 자세한 자식 예외처리가 우선으로 호출 된다.

**다양한 예외**
- 예외를 여러개 처리할 수 있다.
~~~java
@ExceptionHandler({AException.class, BException.class})
~~~

**예외 생략**
- 예외를 생략하면 메서드의 파라미터가 예외로 지정된다.
~~~java
@ExceptionHandler
public ResponseEntity<ErrorResult> userExHandle(UserException e) {}
~~~
## 요약
- @ExceptionHandler를 이용해 예외처리를 하면 간편하게 예외 처리를 할 수 있다. 
- @ExceptionHandler로 예외를 잡아 응답 객체(ErrorResult)를 JSON으로 반환한다
- ExceptionHandlerExceptionResolver가 가장 우선순위가 높고, 자식 예외 핸들러가 부모보다 먼저 선택된다
- 상태 코드는 @ResponseStatus 또는 ResponseEntity로 지정해야 한다 (기본은 200)

# 출처
스프링 MVC 2편 - 백엔드 웹 개발 활용 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-2/dashboard?cid=327260
