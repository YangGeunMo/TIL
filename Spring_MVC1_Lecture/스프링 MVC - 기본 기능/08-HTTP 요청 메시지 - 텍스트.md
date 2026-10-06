# HTTP 요청 메시지 - 단순 텍스트

- HTTP message body에 데이터를 직접 담아서 요청한다.
- HTTP API에서 JSON, XML, TEXT 등이 있는데 주로 JSON을 사용한다.
- HTTP 메시지 바디에서 데이터가 오는 경우 @RequestParam ,@ModelAttribute 를 사용할 수 없다(HTML Form 형식으로 전달될 경우 요청 파라미터로 인정된다)

## 예제
~~~java
   @PostMapping("/request-body-string-v1")
    public void requestBodyString(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 요청 객체에서 입력 스트림 얻기
        // 클라이언트가 보낸 메시지를 바이트 단위로 읽는다.
        ServletInputStream inputStream = request.getInputStream();
        // 바이트 스트림을 문자열로 변환한다.
        // 입력 스트림의 내용을 UTF-8 디코딩해 문자열로 변환한다.
        String messageBody = StreamUtils.copyToString(inputStream, StandardCharsets.UTF_8);

        log.info("messageBody={}", messageBody);
        response.getWriter().write("ok");

    }
~~~
- HTT 메시지 바디 데이터를 InputStream으로 직접 읽을 수 있다.
- 스트림을 통해 클라이언트가 보낸 메시지를 바이트 단위로 읽고 입력 스트림의 내용을 UTF-8로 디코인해 문자열로 변환한다.

## InputStream(Reader), OutputStream(Writer) 이용
~~~java
    @PostMapping("/request-body-string-v2")
    public void requestBodyString(InputStream inputStream, Writer responseWriter) throws IOException {
        // 스프링이 자동으로 주입해준다.
        //HTTP 요청 메시지를 직접 조회한다.
        String messageBody = StreamUtils.copyToString(inputStream, StandardCharsets.UTF_8);

        log.info("messageBody={}", messageBody);
        //HTTP 응답 메시지에 직접 결과를 출력한다.
        responseWriter.write("ok");
    }
~~~
- InputStream(Reader): HTTP 요청 메시지 바디의 내용을 직접 조회한다.
- OutputStream(Writer): HTTP 응답 메시지의 바디에 직접 결과 출력한다.
- 스프링이 자동으로 inputStream으로 HTTP 메시지 바디 데이터를 읽어오고 responseWriter로 응답 메시지 결과를 직접 출력한다.

## HttpEntity 이용
~~~java
   @PostMapping("/request-body-string-v3")
    public HttpEntity<String> requestBodyString(HttpEntity<String> httpEntity) throws IOException {
        // HttpEntity에서 요청 본문(body)을 String으로 가져오기
        String messageBody = httpEntity.getBody();
        // 요청으로 받은 본문 출력
        log.info("messageBody={}", messageBody);
        // 응답 본문에 "ok"를 담아서 반환
        // HttpEntity로 감싸서 반환하면 Spring이 HTTP 응답으로 변환
        return new HttpEntity<>("ok");
    }
~~~
- HttpEntity는 HTTP header, body 정보를 편리하게 조회를 할 수 있다.
- 메시지 바디 정보를 직접 조회 가능하다.
- 요청 파라미터르 조회하는 기능은 없다. @RequestParam, @ModelAttribute를 사용할 수 없다.
- 응답에서도 사용이 가능하다.
  - 메시지 바디 정보를 직접 반환할 수 있다.
  - view조회를 하지 않는다.
 
## RequestBody
~~~java
// HTTP 응답 본문에 결과를 직접 입력해서 전달할 수 있다.
    @ResponseBody
    @PostMapping("/request-body-string-v4")
    // @RequestBody : HTTP 요청 본문을 String으로 자동 변환해서 받기
    // Spring이 요청 본문 → String으로 디코딩 + 변환
    public String requestBodyString(@RequestBody String messageBody) {
        // 요청으로 받은 본문 출력
        log.info("messageBody={}", messageBody);
        // "ok"를 응답 본문으로 반환
        // @ResponseBody 때문에 view를 찾지 않고 "ok" 그대로 반환
        return "ok";
    }
~~~
-  @RequestBody는 HTTP 요청 본문을 바이트에서 String으로 자동 변환해서 받는다.
-  @ResponseBody는 HTTP 응답 본문에 결과를 직접 입력해서 전달할 수 있다.
-  만약 헤더 정보가 필요하면 HttpEntity 를 사용하거나 @RequestHeader 를 사용하면 된다.

### 요청 파라미터 VS HTTP 메시지 바디 
- 요청 파라미터를 조회 : @RequestParam ,@ModelAttribute
- HTTP 메시지 바디를 직접 조회: @RequestBody

# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1/dashboard?cid=326674
