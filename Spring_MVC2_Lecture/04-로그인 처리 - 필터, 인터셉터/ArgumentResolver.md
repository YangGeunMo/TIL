# ArgumentResolver 활용

## 핵심 원리 

- 컨트롤러 파라미터에 @Login 어노테이션이 붙어 있으면, HandlerMethodArgumentResolver가 그 파라미터 값을 대신 채운다.
- Resolver는 세션에서 LOGIN_MEMBER를 꺼내 반환하고, 세션이 없으면 null을 반환한다.
- 사용하려면 Resolver 클래스를 만들고, WebMvcConfigurer.addArgumentResolvers에 등록한다.
---

**Login 어노테이션**
~~~java
@Target(ElementType.PARAMETER)
@Retention(RetentionPolicy.RUNTIME)
public @interface Login {
}
~~~

- `@Target(ElementType.PARAMETER)` : 파라미터에만 사용
- `@Retention(RetentionPolicy.RUNTIME)` : 리플렉션 등을 활용할 수 있도록 런타임까지 애노테이션 정보가 남아있다

---

**LoginMemberArgumentResolver 생성**
~~~java
@Slf4j
public class LoginArgumentResolver implements HandlerMethodArgumentResolver {
    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        log.info("supportsParameter 실행");
        //Login 어노테이션
        boolean hasLoginAnnotation = parameter.hasParameterAnnotation(Login.class);
        //Member 타입
        boolean hasMemberType = Member.class.isAssignableFrom(parameter.getParameterType());

        
        return hasLoginAnnotation && hasMemberType;
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer macController, NativeWebRequest webRequest, WebDataBinderFactory webDataBinderFactory) throws Exception {

        log.info("resolveArgument 실행");
        HttpServletRequest request = (HttpServletRequest) webRequest.getNativeRequest();
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        return session.getAttribute(SessionConst.LOGIN_MEMBER);
    }
}
~~~
- `supportsParameter()` : `@Login` 애노테이션이 있으면서 `Member` 타입이면 해당 `ArgumentResolver`가 사용된다.
- `resolveArgument()` : 컨트롤러 호출 직전에 호출 되어서 필요한 파라미터 정보를 생성해준다. 여기서는 세션에 있는 로그인 회원 정보인 `member` 객체를 찾아서 반환해준다. 이후 스프링MVC는 컨트롤러의 메서드를 호출하면서 여기에서 반환된 `member` 객체를 파라미터에 전달해준다.

---

**LoginMemberArgumentResolver 등록**
~~~java
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(new LoginArgumentResolver());
    }
~~~

---

**정리**
ArgumentResolver 를 활용하면 공통 작업이 필요할 때 컨트롤러를 더욱 편리하게 사용할 수 있다.

# 출처
스프링 MVC 2편 - 백엔드 웹 개발 활용 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-2?cid=327260
