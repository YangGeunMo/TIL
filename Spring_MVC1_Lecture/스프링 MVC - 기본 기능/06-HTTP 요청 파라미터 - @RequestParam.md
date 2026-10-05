# HTTP 요청 파라미터 - @RequestParam

## @RequestParam
- 쿼리 파라미터 값을 메서드 매개변수로 받는 어노테이션
- @RequestParam("username")  String memberName
  - username = URL에서 찾는 쿼리 파라미터 이름
  - memberName = 메서드 내에서 사용하는 변수 이름

## @ResponseBody
- @Controller 어노테이션을 사용하면 String 리턴 값이 View로 반환된다.
- View조회를 무시하고 HTTP message body에 해당 내용을 입력한다.

## 예제
~~~java
    @ResponseBody
    @RequestMapping("/request-param-v2")
    public String requestParamV2(
            @RequestParam("username") String memberName,
            @RequestParam("age") int memberAge) {

        log.info("username={}, age={}", memberName, memberAge);
        return "ok";
    }
~~~
- URL의 파라미터 값을 자동으로 추출해서 변수에 저장
- URL에서 찾은 파라미터 이름(username, age)를 memberName, memberAge에 파라미터 데이터 저장

## HTTP 파라미터 이름이 변수 이름과 같을 경우

~~~java
    @ResponseBody
    @RequestMapping("/request-param-v3")
    public String requestParamV3(
            @RequestParam String username,
            @RequestParam int age) {

        log.info("username={}, age={}", username, age);
        return "ok";
    }
~~~
- HTTP 파라미터 이름이 변수 이름과 같을 경우 @RequestParam(name="xx")생략이 가능하다.

## 기본형 타입(String, int, Interger 등)등 단순 타입일경우 

~~~java
 @ResponseBody
    @RequestMapping("/request-param-v4")
    public String requestParamV4(String username, int age) {

        log.info("username={}, age={}", username, age);
        return "ok";
    }
~~~
- String, int, Integer 등 단순 타입이면 @RequestParam을 생략할 수 있다.

## 파라미터 필수 여부 
~~~java
    @ResponseBody
    @RequestMapping("/request-param-required")
    public String requestParamRequired(
            //required = true : username이 꼭 들어와야 한다.
            @RequestParam(required = true) String username,
            //required = false age는 없어도 된다. 그러나 에러가 난다 int는 null을 담을 수 없다.
            //Integer로 바꿔야 한다.
            @RequestParam(required = false) Integer age) {

        log.info("username={}, age={}", username, age);
        return "ok";
    }
~~~

- required = true
  - 기본값이 파라미터 필수이다.
  - @RequestParam(required = true) String username : username 필수로 있어야 한다.
  - username이 없으면 400 예외가 발생한다.
  - /request-param-required?username= -> 파라미터 이름만 있고 값이 없는 경우 빈 문자로 통과한다.
- required = false age는 없어도 된다. 그러나 에러가 난다 int는 null을 담을 수가 없어 Integer로 바꿔야 한다.

## 기본 값 적용하기 
~~~java
   @ResponseBody
    @RequestMapping("/request-param-default")
    public String requestParamDefault(
            //default값이 있으면 required가 필요없다. 없어도 기본값이 있기 때문
    
            @RequestParam(required = true,defaultValue = "guest") String username,
            //required = false age는 없어도 된다. 그러나 에러가 난다 int는 null을 담을 수 없다.
            //default 값을 지정하면 int를 사용할 수 있다.
            @RequestParam(required = false,defaultValue = "-1") int age) {

        log.info("username={}, age={}", username, age);
        return "ok";
    }
~~~
- 파라미터 값이 없는 경우 defaultValue를 이용해 기본값을 지정할 수 있다.
- 기본값이 있기에 required는 필요 없다. 필수로 파라미터가 없어도 기본값이 적용된다.
- defaultValue는 값이 없어도 기본 값이 적용된다.

## 파라미터를 Map으로 조회하기 
~~~java
    @ResponseBody
    @RequestMapping("/request-param-map")
    public String requestParamMap(@RequestParam Map<String,Object> paramMap) {

        log.info("username={}, age={}", paramMap.get("username"), paramMap.get("age"));
        return "ok";
    }
~~~
- 파라미터를 Map, MultiValueMap으로 조회할 수 있다.
- MultiValueMap는 Key하나에 여러 값들을 받을 수 있다.
- 파라미터 값이 1개면 Map이 좋지만 그렇지 않으면 MultiValueMap을 사용하는게 좋다.

## 참고
- 어노테이션을 완전히 생략해도 좋으나 너무 간결하게 줄여버리면 주관적으로 생각할 수 있다. 어노테이션을 명시해서 명확하게 어떤 기능인지 알 수 있게 하는것이 좋다.

# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1/dashboard?cid=326674
