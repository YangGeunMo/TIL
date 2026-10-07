# HTTP 응답 - 정적 리소스, 뷰 템플릿

- 스프링에서 응답 데이터를 만드는 방법은 3가지가 있다.

- 정적 리소스 : 웹 브라우저에 정적인 HTML, css, js를 제공할 때 정적 리소스를 사용한다.
- 뷰 템플릿 : 웹 브라우저에 동적인 HTML을 제공할 때는 뷰 템플릿을 사용한다.
- HTTP 메시지 : HTTP API를 제공할때는 HTML이 아니라 HTTP 메시지 바디에 JSON같은 형식의 데이터를 담아 보낸다.


## 정적 리소스

스프링 부트는 클래스패스의 다음 디렉토리에 있는 정적 리소스 제공
- 예시 : /static, /public, /resources, /META-INF/resources

src/main/resources는 리소스를 보관하는 곳이고 클래스 패스의 시작 경로이다.
- 다음 디렉토리에 리소르르 넣어두면 스프링 부트가 정적 리소스로 서비스를 제공한다.

- 이 경로에 있는 파일 : src/main/resources/static/basic/hello-form.html
  - 웹 브라우저에서 실행되면 `http://localhost:8080/basic/hello-form.html` 실행된다.


## 뷰 템플릿
뷰 템플릿을 통해서 HTML이 생성되고 뷰가 응답을 만들어 전달한다. 

스프링 부트는 기본 뷰 템플릿 경로를 제공한다.
- src/main/resources/templates

### 뷰 템플릿 생성

- 뷰 템플릿 경로
  - `src/main/resources/templates/response/hello.html`

~~~html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<p th:text="${data}">empty</p>
</body>
</html>
~~~

### 뷰 템플릿을 호출하는 컨트롤러 
~~~java
  @RequestMapping("/response-view-v1")
    public ModelAndView responseViewV1() {
        ModelAndView mav = new ModelAndView("response/hello")
                .addObject("data", "hello");
        return mav;
    }

    @RequestMapping("/response-view-v2")
    public String responseViewV1(Model model) {
        model.addAttribute("data", "hello");
        return "response/hello";
    }
~~~
- String을 반환하는 경우
  - @ResponseBody가 없으면 response/hello로 뷰 리졸버가 실행되고 뷰를 찾고 렌더링한다.
  - @ResponseBody가 있으면 뷰 리졸버를 실행하지않고 HTTP 메시지 바디에 직접 response/hello라는 문자가 입력된다.
 
## HTTP 메시지
@ResponseBody, HttpEntity 를 사용하면, 뷰 템플릿을 사용하는 것이 아니라, HTTP 메시지 바디에 직접 응답 데이터를 출력할 수 있다.

### 서블릿
~~~java
 @GetMapping("/response-body-string-v1")
    public void responseBodyV1(HttpServletResponse response) throws IOException {
        response.getWriter().write("ok");
    }
~~~
- 서블릿을 이용해 HttpSErvletResponse 객체를 HTTP 메시지 바디에 직접 ok 응답 메시지를 전달.

### ResponseEntity
~~~java
    @GetMapping("/response-body-string-v2")
    public ResponseEntity<String> responseBodyV2() {
        return new ResponseEntity<>("ok", HttpStatus.OK);
    }
~~~
- ResponseEntity는 HttpEntity를 상속받아 사용한다. HttpEntity는 HTTP 메시지의 헤더, 바디 정보를 이용할 수 있는데 ResponseEntity는 HTTP 응답 코드를 설정할 수 있다.

### @ResponseBody 
~~~java
    @ResponseBody
    @GetMapping("/response-body-string-v3")
    public String responseBodyV3() {
        return "ok";
    }
~~~
- @ResponseBody 를 사용하면 view를 사용하지 않고, HTTP 메시지 컨버터를 통해서 HTTP 메시지를 직접 입력할 수 있다. ResponseEntity도 동일한 방식으로 동작한다.

### JSON 응답 - 1
~~~java
  @GetMapping("/response-body-json-v1")
    //응답 바디에 들어갈 객체 타입
    public ResponseEntity<HelloData> responseBodyJsonV1() {
        HelloData helloData = new HelloData();
        helloData.setUsername("userA");
        helloData.setAge(20);
        //JSON으로 감싸서 응답 데이터 전달
        return new ResponseEntity<>(helloData, HttpStatus.OK);
    }
~~~
- ResponseEntity 를 반환한다. HTTP 메시지 컨버터를 통해서 JSON 형식으로 변환되어서 반환된다.

### JSON 응답 - 2
~~~java
    @ResponseStatus(HttpStatus.OK)
    @ResponseBody
    @GetMapping("/response-body-json-v2")
    public HelloData responseBodyJsonV2() {
        HelloData helloData = new HelloData();
        helloData.setUsername("userA");
        helloData.setAge(20);
        return helloData;
    }
~~~
- ResponseEntity 는 HTTP 응답 코드를 설정할 수 있는데, @ResponseBody 를 사용하면 응답 코드까지 설정하기 번거롭다.
- @ResponseStatus(HttpStatus.OK) 애노테이션을 사용하면 응답 코드도 설정할 수 있다.
- 어노테이션이기 때문에 동적으로 변경할 수 없다. 동적으로 변경하려면 ResponseEntity를 사용해야 한다.

## @RestController
- @RestController 어노테이션을 사용하면 해당 컨트롤러 모두 @ResponseBody가 적용된다. 뷰 템플릿을 사용하는 것이 아니라 HTTP 메시지 바디에 직접 데이터를 입력한다.
- Rest API(HTTP API)를 만들 때 사용하는 컨트롤러이다.

# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1/dashboard?cid=326674
