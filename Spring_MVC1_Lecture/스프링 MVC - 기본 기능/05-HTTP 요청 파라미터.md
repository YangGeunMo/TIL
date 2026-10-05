# HTTP 요청 파라미터 - 쿼리 파라미터, HTML Form

## HTTP 요청 데이터 조회 - 개요

- 서블릿부터 해서 점점 스프링으로 효율적으로 바뀐다.


## 클라이언트에서 서버로 요청 데이터를 전달하는 3가지

- GET - 쿼리 파라미터
  - 메시지 바디 없이, URL쿼리 파라미터에 데이터를 포함해서 전달
  - 예) 검색, 필터, 페이지등에서 사용
 
- POST - HTML Form
  - content-type: application/x-www-form-urlencoded
  - 메시지 바디에 쿼리 파리미터 형식으로 전달 username=hello&age=20
  - 예시) 회원 가입, 상품 주문 등
- HTTP message body에 데이터를 직접 담아서 요청
  - HTTP API에서 JSON, XML, TEXT를 사용한다.(주로 JSON 사용)
  - POST, PUT, PATCH

### 요청 파라미터 - 쿼리 파라미터, HTML Form
- HttpServletRequest의 request.getParamater()를 사용하면 두 가지 요청 파라미터를 조회할 수 있다.
- GET 쿼리 파라미터 전송 : `http://localhost:8080/request-param?username=hello&age=20`
- POST, HTML Form 전송 : username=hello&age=20
- 둘 다 형식이 같아 구분없이 조회가능하다.
- 이걸 요청 파라미터라고 한다.

~~~java
@Slf4j
@Controller
public class RequestParamController {

    @RequestMapping("/request-param-v1")
    public void requestParamV1(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        int age = Integer.parseInt(request.getParameter("age"));

        log.info("username={}, age={}", username, age);
        response.getWriter().write("ok");

    }
}
~~~
- request.getParameter()
  - HttpServletReqeust가 제공하는 방식으로 요청 파라미터를 조회한다.

# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1/dashboard?cid=326674
