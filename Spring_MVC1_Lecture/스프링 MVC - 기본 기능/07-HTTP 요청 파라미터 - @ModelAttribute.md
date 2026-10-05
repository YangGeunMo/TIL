# HTTP 요청 파라미터 - @ModelAttribute

- 개발을 할때 요청 파라미터를 받아서 필요한 객체를 만들고 그 객체에 값을 넣어준다.

## 요청 파라미터를 바인딩 받을 객체 만들기
~~~java
@Data
public class HelloData {
    private String username;
    private int age;
}
~~~
- 롬복 @Data
  - @Getter, @Setter, @ToString, @EqualsAndHashCode, @RequiredArgsConstructor를 자동 적용해준다.

## @RequestParam를 이용해 쿼리 파라미터 데이터를 객체에 필드변수에 넣기 
~~~java
    @ResponseBody
    @RequestMapping("/model-attribute")
    public String modelAttribute(@RequestParam String username, @RequestParam int age) {
        HelloData helloData = new HelloData();
        helloData.setUsername(username);
        helloData.setAge(age);
        log.info("username={}, age={}", helloData.getUsername(), helloData.getAge());

        return "ok";
    }
~~~
- 쿼리 파라미터이름을 통해 값을 받고 객체를 만들어 set으로 데이터를 저장하고 get으로 조회한다.
- 이러한 과정을 @ModelAttribute 어노테이션으로 간략화 할 수 있다.

## @ModelAttribute 적용
~~~java
    @ResponseBody
    @RequestMapping("/model-attribute-v1")
    public String modelAttributeV1(@ModelAttribute HelloData helloData) {
        log.info("username={}, age={}", helloData.getUsername(), helloData.getAge());
        return "ok";
    }
~~~
- @ModelAttribute의 기능
  - HelloData 객체를 생성한다.
  - 요청 파라미터의 이름으로 HelloData 객체에 있는 프로퍼티를 찾고 해당 프로퍼티의 setter를 호출해 파라미터 값을 입력(바인딩)한다.
    - 예시) 파라미터 이름이 username이면 setUsername()메서드를 찾아 호출하고 값을 입력한다.
   
- 프로퍼티
  - 객체에 getUsername(), setUsername() 메서드가 있으면 이 객체에 username이라는 프로퍼티를 가지고 있다.
  - username 값을 변경하면 setUsername() 호출, 조회하면  getUsername() 호출된다.
 
- 바인딩 오류
  - age=abc 처럼 숫자가 들어가야할 곳에 문자가 들어가면 `BindException`이 발생한다.

## @ModelAttribute 생략 
~~~java
@ResponseBody
    @RequestMapping("/model-attribute-v2")
    public String modelAttributeV2(HelloData helloData) {
        log.info("username={}, age={}", helloData.getUsername(), helloData.getAge());
        return "ok";
    }
~~~
- @ModelAttribute도 생략이 가능하다. 그런데 만약 @RequestParam도 생략된 메서드가 있을 경우 헷갈릴수 있는데
- String, int, Integer 등 단순 타입은 @RequestParam이 적용된다.
- 나머지는 @ModelAttribute이 적용된다 (argument resolver 로 지정해둔 타입 외 예시: HttpServletResponse response)

# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1/dashboard?cid=326674
