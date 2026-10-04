# 스프링 MVC 시작


## @RequestMapping 

- RequestMappingHandlerMapping
- RequestMappingHandlerAdapter

우선 순위가 높은 핸드럴 매핑과 핸들러 어댑터이다. 
지금 스프링에서 주로 사용하는 애노테이션 기반의 컨트롤러를 지원하는 핸들러 매핑와 어댑터인데 실무에서 이 방식을 사용한다.

#### 회원 등록 컨트롤러 
~~~java
@Controller
public class SpringMemberFormControllerV1 {

    @RequestMapping("/springmvc/v1/members/new-form")
    public ModelAndView process() {
        return new ModelAndView("new-form");
    }
}
~~~

- @Controller
  - 스프링이 자동으로 스프링 빈에 등록한다.(내부에 @Component 애노테이션이 있어 컴포넌트 스캔의 대상이 된다)
  - 스프링 MVC에서 애노테이션 기반 컨트롤러를 인식한다.
- @RequestMapping
  - 요청 정보를 매핑한다. 해당 URL이 호출되면 이 메서드가 실행된다. 애노테이션을 기반으로 동작하기에 메서드이름은 임의로 지으면 된다.
- ModelAndView : 모델과 뷰 정보를 담아서 반환한다.

- RequestMappingHandlerMapping는 스프링 빈에서 @RequestMapping 또는 @Controller가 클레스 레벨에 붙어 있을 경우 매핑 정보로 인식한다.


~~~java
@Component //컴포넌트 스캔을 통해 스프링 빈으로 등록 
@RequestMapping
public class SpringMemberFormControllerV1 {

    @RequestMapping("/springmvc/v1/members/new-form")
    public ModelAndView process() {
        return new ModelAndView("new-form");
    }
}
~~~

#### 주의 - 스프링 3.0 이상
- 스프링 부트 3.0(스프링 프레임워크 6.0)부터 클래스 레벨에 @RequestMapping이 있어도 스프링 컨트롤러로 인식이 되지 않는다. 
@Controller가 있어야 스프링 컨트롤러로 인식한다. 참고로 @RestController는 애노테이션 내부에 @Controller를 포함한다.


#### 회원 저장 컨트롤러 

~~~java
@Controller
public class SpringMemberSaveControllerV1 {

    private MemberRepository memberRepository = MemberRepository.getInstance();

    @RequestMapping("/springmvc/v1/members/save")
    public ModelAndView process(HttpServletRequest request, 
                                HttpServletResponse response) {
        String username = request.getParameter("username");
        int age = Integer.parseInt(request.getParameter("age"));

        Member member = new Member(username, age);
        System.out.println("member = " + member);
        memberRepository.save(member);

        ModelAndView mv = new ModelAndView("save-result");
        mv.addObject("member", member);

        return mv;
    }
}
~~~
- mv.addObject("member", member)
  - 스프링이 제공하는 ModelAndView를 통해 Model 데이터를 추가할떄 addObject()를 사용하면 된다.
  - request.setAttribute("member", member)와 동일한 기능
  - 뷰 렌더링할때 데이터로 사용된다. 

# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1?cid=326674
