# HTTP 요청 - 기본 , 헤더 조회

## HTTP 헤더 정보 조회 방법

~~~java
@Slf4j
@RestController
public class RequestHeaderController {

    @RequestMapping("/headers")
    public String headers(HttpServletRequest request,
                          HttpServletResponse response,
                          HttpMethod httpMethod,
                          Locale locale,
                          @RequestHeader MultiValueMap<String,String > headerMap,
                          @RequestHeader("host") String host,
                          @CookieValue(value = "myCookie",required = false)String cookie) {

        log.info("request={}", request);
        log.info("response={}", response);
        log.info("httpMethod={}", httpMethod);
        log.info("locale={}", locale);
        log.info("headerMap={}", headerMap);
        log.info("header host={}", host);
        log.info("myCookie={}", cookie);

        return "ok";
    }
}
~~~

- HttpMethod : HTTP 메서드를 조회한다.
- Locale : Locale 정보를 조회한다.
- @RequestHeader MultiValueMap<String,String > headerMap
  - 모든 HTTP 헤더를 MultiValueMap 형식으로 조회한다.
- @RequestHeader("host") String host : 특정 헤더를 조회한다.
- @CookieValue(value = "myCookie",required = false)String cookie) : 특정 쿠키를 조회한다.

- MultiValueMap : 하나의 키에 여러 값을 받을 수 있다.
  - keyA=value1&keyA=value2
 ~~~java
MultiValueMap<String, String> map = new LinkedMultiValueMap();
  map.add("keyA", "value1");
  map.add("keyA", "value2");

  //[value1,value2]
  List<String> values = map.get("keyA");
~~~

# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1/dashboard?cid=326674
