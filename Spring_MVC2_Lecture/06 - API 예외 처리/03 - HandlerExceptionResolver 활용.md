# HandlerExceptionResolver 활용

### 요약

- 예외가 발생하면 WAS까지 예외가 던져지고, WAS에서 오류 페이지 정보를 찾아서 BasicErrorController 에서 다시 /error 를 호출하는 과정은 복잡하다.
- HandlerExceptionResolver를 사용해 오류 처리를 직접 HTTP 응답 바디에 작성한다. 이러면 복잡한 과정이 줄어든다. 

### 중요 키워드
- HandlerExceptionResolver
### 내용 복습
**UserException 예외를 직접 만듦**
~~~java
public class UserException extends RuntimeException{
 
    public UserException(String message) {
        super(message);
    }
}
~~~
**user-ex요청을 보냈을 경우**
~~~java
if (id.equals("user-ex")) {
    throw new UserException("사용자 오류");
}
~~~

- Exception을 던지면서 HandlerExceptionResolver가 호출된다. 

**UserHandlerExceptionResolver**
~~~java
@Slf4j
public class UserHandlerExceptionResolver implements HandlerExceptionResolver {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public @Nullable ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, @Nullable Object handler, Exception ex) {

        try {
            //UserException 또는 그 하위 클래스만 가능
            if (ex instanceof UserException) {
                log.info("USerException resolver to 400");
                //요청 받은 Accept 값을 꺼낸다.
                String acceptHeader = request.getHeader("accept");
                //응답을 400으로 지정
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

                if ("application/json".equals(acceptHeader)) {
                    //응답 바디에 담을 에러 정보
                    Map<String, Object> errorResult = new HashMap<>();
                    //예외 클래스  이름 저장
                    errorResult.put("ex", ex.getClass());
                    //오류 메시지 저장
                    errorResult.put("message", ex.getMessage());

                    // Map을  JSON 형식의 문자열로 변환한다.
                    String result = objectMapper.writeValueAsString(errorResult);

                    //응답 데이터를 JSON으로 설정
                    response.setContentType("application/json");
                    //응답 데데이터를 UTF-8로 인코딩
                    response.setCharacterEncoding("utf-8");
                    //JSON문자열을 HTTP 응답 바디에 작성
                    response.getWriter().write(result);
                    //예외처리 완료 후 뷰는 렌더링하지 않는다.
                    return new ModelAndView();
                } else {
                    //text/html
                    return new ModelAndView("error/500");
                }
            }

        } catch (IOException e) {
            log.error("resolver ex", e);
        }
        return null;
    }
}
~~~
- sendError 방식이 아닌 response.getWriter().write(result)로 직접 JSON방식으로 오류 처리를 한다. 

**등록**
~~~java
@Override
public void extendHandlerExceptionResolvers(List<HandlerExceptionResolver> resolvers) {
    resolvers.add(new UserHandlerExceptionResolver());
}
~~~

**결과**
~~~
{
    "ex": "hello.exception.exception.UserException",
    "message": "사용자 오류"
}
~~~
- 이 방식을 사용하면 복잡하게 서블릿 컨테이너까지 예외가 전달되지 않고 스프링 mvc에서 예외 처리를 끝낸다.

# 출처
스프링 MVC 2편 - 백엔드 웹 개발 활용 기술

- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-2/dashboard?cid=327260
