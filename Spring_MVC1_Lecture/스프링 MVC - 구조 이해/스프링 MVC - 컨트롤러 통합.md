# 스프링 MVC - 컨트롤러 통합 

@RequestMapping을 잘 보면 클래스 단위가 아니라 메서드 단위에 적용된 것을 확인할 수 있다. 따라서 컨트롤러 클
래스를 유연하게 하나로 통합할 수 있다.

~~~java
/**
 * 클래스 단위 -> 메서드 단위
 * @RequestMapping 클래스 레벨과 메서드 레벨 조합
 */
@Controller
@RequestMapping("/springmvc/v2/members")
public class SpringMemberControllerV2 {

    private MemberRepository memberRepository = MemberRepository.getInstance();

    @RequestMapping("/new-form")
    public ModelAndView newForm() {
        return new ModelAndView("new-form");
    }

    @RequestMapping("/save")
    public ModelAndView save(HttpServletRequest request, 
                            HttpServletResponse response) {
        String username = request.getParameter("username");
        int age = Integer.parseInt(request.getParameter("age"));

        Member member = new Member(username, age);
        memberRepository.save(member);

        ModelAndView mav = new ModelAndView("save-result");
        mav.addObject("member", member);

        return mav;
    }

    @RequestMapping
    public ModelAndView members() {
        List<Member> members = memberRepository.findAll();

        ModelAndView mav = new ModelAndView("members");
        mav.addObject("members", members);

        return mav;
    }
}
~~~

## 조합 

컨트롤러 클래스를 통합하는 것도 가능하지만 조합도 가능하다. 
/springmvc/v2/members라는 부분에 중복이 있다.

- `@RequestMapping("/springmvc/v2/members/new-form")`
- `@RequestMapping("/springmvc/v2/members")`
- `@RequestMapping("/springmvc/v2/members/save")`

이렇게 사용해도 되지만 클래스 레벨에 @RequestMapping을 두면 메서드 레벨과 조합이 된다. 
~~~java
@Controller
@RequestMapping("/springmvc/v2/members")
public class SpringMemberControllerV2 {}
~~~

### 조합 결과

- `클래스 레벨 @RequestMapping("/springmvc/v2/members")`
- `메서드 레벨 @RequestMapping("/new-form")` -> `/springmvc/v2/members/new-form`
- `메서드 레벨 @RequestMapping("/save")` -> `/springmvc/v2/members/save`
- `메서드 레벨 @RequestMapping` -> `/springmvc/v2/members`


# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1?cid=326674
