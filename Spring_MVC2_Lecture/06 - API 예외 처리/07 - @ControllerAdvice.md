# @ControllerAdvice
## 주요 키워드
- ControllderAdvice
- RestControllerAdvice
## 내용
- @ExceptionHandler를 사용해 예외처리를 편리하게 처리했지만 정상 코드와 예외 처리 코드가 하나의 컨트롤러에 있다.
- @ControllderAdvice나 @RestControllderAdvice를 이용하면 정상 코드와 예외 처리 코드를 분리할 수 있다.

~~~java
@Slf4j
@RestControllerAdvice
public class ExControllerAdvice {

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    //IllegalArgumentException 예외 발생시 호출
    @ExceptionHandler(IllegalArgumentException.class)
    //ErrorResult가 json으로 반환
    public ErrorResult illegalExHandler(IllegalArgumentException e) {
        log.error("[exceptionHandler] ex", e);
        return new ErrorResult("BAD", e.getMessage());
    }
}
~~~

- ExControllerAdvice 클래스를 만들고 예외 처리 코드를 정상 코드에서 분리시켰다.
- @ControllerAdvice는 대상으로 지정한 여러 컨트롤러에 @ExceptionHandler , @InitBinder 기능을 부여해주는 역할을 한다.
- @ControllerAdvice는 대상을 지정하지 않으면 글로벌 적용이 된다. ( 전체 적용)
- @RestControllerAdvice는 @ControllerAdvice에서 @ResponseBody가 추가된것이다. 

**대상 컨트롤러 지정 방법**
~~~java
```java
// Target all Controllers annotated with @RestController
@ControllerAdvice(annotations = RestController.class)
public class ExampleAdvice1 {}

// Target all Controllers within specific packages
@ControllerAdvice("org.example.controllers")
public class ExampleAdvice2 {}

// Target all Controllers assignable to specific classes
@ControllerAdvice(assignableTypes = {ControllerInterface.class,
AbstractController.class})
public class ExampleAdvice3 {}
~~~
- 특정 어노테이션이 있는 컨트롤러를 지정할 수 있다.
- 특정 패키지를 직접 지정할 수 있다.
## 요약
- @ExceptionHandler와 @ControllerAdvice를 사용하면 정상 코드와 예외를 분리하고 예외를 간편하게 해결할 수 있다.
- @ControllerAdvice를 사용해 정상 코드와 에러 처리 코드를 분리한다.
- @RestControllerAdvice는 @ControllerAdvice에 @ResponseBady를 추가한 것이다.


# 출처
스프링 MVC 2편 - 백엔드 웹 개발 활용 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-2/dashboard?cid=327260
