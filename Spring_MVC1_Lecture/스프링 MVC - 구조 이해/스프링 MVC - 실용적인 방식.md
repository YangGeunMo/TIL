# 스프링 MVC - 실용적인 방식 

MVC 프레임워크 만들기에서 v3은 ModelView를 개발자가 직접 생성해서 반환했기 때문에 불편했는데 v4를 만들면서 실용적으로 개선했다. 스프링 MVC도 개발자가 편리하게 개발할 수 있도록 편의 기능을 제공한다.


 ~~~java
/**
 * v3
 * Model 도입
 * ViewName 직접 반환
 * @RequestParam 사용
 * @RequestMapping -> @GetMapping, @PostMapping
 */
@Controller
@RequestMapping("/springmvc/v3/members")
public class SpringMemberControllerV3 {

    private MemberRepository memberRepository = MemberRepository.getInstance();

    @GetMapping("/new-form")
    public String newForm() {
        return "new-form";
    }

    @PostMapping("/save")
    public String save(
            @RequestParam("username") String username,
            @RequestParam("age") int age,
            Model model) {
        
        Member member = new Member(username, age);
        memberRepository.save(member);
        
        model.addAttribute("member", member);
        
        return "save-result";
    }

    @GetMapping
    public String members(Model model) {
        List<Member> members = memberRepository.findAll();
        
        model.addAttribute("members", members);
        
        return "members";
    }
}
~~~

## Model 파라미터
- save(), members() 를 보면 Model을 파라미터로 받는 것을 확인할 수 있다. 스프링 MVC도 이런 편의 기능을 제공한다.

## ViewName 직적 반환
- 뷰의 논리 이름을 반환할 수 있다.

## @RequestParam 사용
- 스프링은 HTTP 요청 파라미터를 `@RequestParam`으로 받을 수 있다.
- `@RequestParam("username")` 은 `request.getParameter("username")` 와 거의 같은 코드라 생각하자.

## @RequestMapping @GetMapping, @PostMapping
- @RequestMapping 은 URL만 매칭하는 것이 아니라, HTTP Method도 함께 구분할 수 있다.
  - `@RequestMapping(value = "/new-form", method = RequestMethod.GET)`
  - GET으로만 요청할 수 있다.

- @GetMapping , @PostMapping으로 더 편리하게 사용할 수 있다.(Get,Post,Put,Delete, Pathch 모두 어노테이션이 있다)
- @GetMapping코드를 열어보면 @RequestMapping이 있다.

# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1?cid=326674
