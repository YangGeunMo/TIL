# HandlerExceptionResolver 시작



`IllegalArgumentException`을 처리하지 못해서 상태코드 500을 400으로 처리하고 싶을 때 어떻게 해야할까

~~~java
if (id.equals("bad")) {
    //메서드에 잘못된 인자가 넘어왔을 때IllegalArgumentException 발생 
    throw new IllegalArgumentException("잘못된 입력 값");
}
~~~

#### 실행 했을 때
~~~
"status": 500,
"error": "Internal Server Error",
"exception": "java.lang.IllegalArgumentException",
"path": "/api/members/bad"
~~~


## HandlerExceptionResolver

스프링 MVC에서 컨트롤러 밖으로 던진 예외를 해결하고 동작을 변경하고 싶으면 HandlerExceptionResolver를 사용하면 된다. 줄여서 ExceptionResolver라고 한다.


#### ExceptionResolver 적용전 

<img width="792" height="407" alt="스크린샷 2026-10-23 오전 11 49 07" src="https://github.com/user-attachments/assets/91d203bb-0b28-4702-b980-616f69f97f5b" />


#### ExceptionResolver 적용 후 

<img width="766" height="352" alt="스크린샷 2026-10-23 오전 11 49 37" src="https://github.com/user-attachments/assets/d012a586-7908-4382-bfed-9dda362f31db" />

- ExceptionResolver로 예외를 해결해도 pstHandle()은 호출되지 않음 
#### ExceptionResolver 인터페이스

~~~java

public interface HandlerExceptionResolver {

	ModelAndView resolveException(
		HttpServletRequest request, HttpServletResponse response,
	Object handler, Exception ex);
}
~~~

- handler 핸들러(컨트롤러) 정보
- ex : 핸들러에서 발생한 예외 

#### ExceptionResolver 인터페이스 적용 
~~~java
@Slf4j
public class MyHandlerExceptionResolver implements HandlerExceptionResolver {
    @Override
    public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {


        log.info("call resolver={}", ex);


        try {
            if (ex instanceof IllegalArgumentException) {
                log.info("IllegalArgumentException resolver to 400");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, ex.getMessage());
                return new ModelAndView();
            }
        } catch (IOException e) {
            log.error("resolver ex", e);
        }
        return null;
    }
}
~~~

ModelAndView로 반환하는 이유는 Exception을 처리 후 정상흐름처럼 하기위해서이다. 

null을 반환하면 다음 ExceptionResolver를 찾아 실행하는데 처리할 수 없는 ExceptionResolver가 없으면 예외처리가 안되고 발생한 예외를 서블릿 밖으로 던진다.

**ExceptionResolver 흐름** 
~~~
bad 요청 → 컨트롤러에서 IllegalArgumentException 발생 → MyHandlerExceptionResolver가 잡음 → response.sendError(400, "잘못된 입력 값") 으로 상태와 메시지 기록 → 빈 ModelAndView 반환 (처리 완료) → WAS가 400 확인 → BasicErrorController의 기본 오류 경로 /error 호출 → BasicErrorController.error()가 JSON 응답 생성
 ~~~

WebConfig - ExceptionResolver 등록
~~~java
@Override
public void extendHandlerExceptionResolvers(List<HandlerExceptionResolver> resolvers) {
    resolvers.add(new MyHandlerExceptionResolver());
}
~~~

# 출처
스프링 MVC 2편 - 백엔드 웹 개발 활용 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-2/dashboard?cid=327260
