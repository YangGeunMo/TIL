# HTTP 요청 메시지 - JSON

## 기존 서블릿을 이용
~~~java
    // ObjectMapper = JSON ↔ 자바 객체 변환
    private ObjectMapper objectMapper = new ObjectMapper();

    @PostMapping("request-body-json-v1")
    public void requestBodyJsonV1(HttpServletRequest request, HttpServletResponse response) throws IOException {
        //요청 데이터를 바이트 단위로 받는다.
        ServletInputStream inputStream = request.getInputStream();
        //바이트 단위를 UTF-8로 디코딩한다.
        String messageBody = StreamUtils.copyToString(inputStream, StandardCharsets.UTF_8);
        //로그 출력
        log.info("messageBody={}", messageBody);
        //문자로된 JSON 데이터를  Jackson 라이브러리인 objectMapper를 사용해서 자바 객체로 변환.
        HelloData data = objectMapper.readValue(messageBody, HelloData.class);
        log.info("username={}, age={}", data.getUsername(), data.getAge());

        response.getWriter().write("ok");
    }
~~~
- HttpServletRequest를 사용해 직접 HTTP 메시지 바디에서 데이터를 읽고 문자로 변환한다.
- 문자로 된 JSON 데이터를 Jackson 라이브러리인 objectMapper를 사용해서 자바 객체로 변환한다.

## @RequestBody 문자 변환
~~~java
    // 메시지 바디에 결과를 직접 입력해서 반환할 수 있다.
    @ResponseBody
    @PostMapping("/request-body-json-v2")
    // 요청을 보낸 HTTP 메시지 바디 데이터를 꺼내 메서드 파라미터에 저장한다.
    // 자동으로 바이트코드를 UTF-8로 디코딩한다.
    public String requestBodyJsonV2(@RequestBody String messageBody) {
      
        HelloData data = objectMapper.readValue(messageBody, HelloData.class);
        log.info("username={}, age={}", data.getUsername(), data.getAge());
        return "ok";
    }
~~~
- @RequestBody : 요청을 보낸 HTTP 메시지 바디 데이터를 꺼내 메서드 파라미터에 저장한다. 자동으로 바이트코드를 UTF-8로 디코딩한다.
- HelloData data = objectMapper.readValue(messageBody, HelloData.class);
  - 문자로된 JSON 데이터를 Jackson 라이브러리인 objectMapper를 사용해서 자바 객체로 변환한다.


## @RequestBody 객체 변환
~~~java
    @ResponseBody
    @PostMapping("/request-body-json-v3")
    public String requestBodyJsonV3(@RequestBody HelloData data) {
        log.info("username={}, age={}", data.getUsername(), data.getAge());
        return "ok";
    }
~~~
- Spring이 내부적으로 아래의 기능을 자동으로 해준다. 
- String messageBody = StreamUtils.copyToString(...) : 바이트 단위를 UTF-8로 디코딩한다.
- HelloData data = objectMapper.readValue(messageBody, HelloData.class); : 문자로된 JSON 데이터를 Jackson 라이브러리인 objectMapper를 사용해서 자바 객체로 변환한다.
- {"username":"john","age":30} ->  Setter 호출해서 프로퍼티에  username = "john", age = 30로 값 저장, JSON 데이터를 객체로 변환한다.
---
- @RequestBody 객체 파라미터
  - @RequestBody HelloData data
  - @RequestBody에 객체를 지정할 수 있다.

HttpEntity, @RquestBody를 사용하면 HTTP 메시지 컨버터가 HTTP 메시지 바딩 내용을 우리가 원하는 문자나 객체로 변환해 준다. 

- @RequestBody는 생략이 불가능하다.
  - @ModelAttribute, @RequestParam을 생략할 때 조건이 있다.
  - String, int, Integer 등 단순 타입 : @RequestParam 적용
  - 나머지 타입은 @ModelAttribute 적용된다(argument resolver 로 지정해둔 타입은 제외된다)
  - HelloData에 @RequestBody 를 생략하면 @ModelAttribute 가 적용되어버리고 HTTP 메시지 바디가 아니라 요청 파라미터를 처리한다.
 
## HttpEntity 이용하기
~~~java
    // 메시지 바디에 결과를 직접 입력해서 반환할 수 있다.
    @ResponseBody
    @PostMapping("/request-body-json-v4")
    // HttpEntity<HelloData>: Spring이 요청 본문을 자동으로 HelloData 객체로 변환해서 전달
    public String requestBodyJsonV4(HttpEntity<HelloData> httpEntity) {
        // HttpEntity에서 요청 본문(body)을 꺼내기
        // 이미 HelloData 객체로 변환되어 있음
        HelloData data = httpEntity.getBody();
        log.info("username={}, age={}", data.getUsername(), data.getAge());
        return "ok";
    }
~~~

## @ResponseBody로 객체를 HTTP 메시지 바디에 넣기
~~~java
    @ResponseBody
    @PostMapping("/request-body-json-v5")

    public HelloData requestBodyJsonV5(@RequestBody HelloData data) {
        log.info("username={}, age={}", data.getUsername(), data.getAge());
        return data;
    }
}
~~~
- 응답의 경우 @ResponseBody를 이용해 HTTP 메시지 바디에 직접 객체를 넣을 수 있다.
- @RequestBody 요청
  - JSON요청 -> HTTP 메시지 컨버터 -> 객체
- @ResponseBody 응답
  - 객체 -> HTTP 메시지 컨버터 -> JSON 응답

# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1?cid=326674#reviews
