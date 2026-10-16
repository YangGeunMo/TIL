# Validator

컨트롤러를 다시보면 성공로직은 몇줄 안되는데 검증 로직이 너무 많다. 검증 로직을 따로 분리해보자.

- 직접 호출해서 사용하기
  - ItemValidator implements Validator를 따로 만들고 스프링빈에 등록하고 주입받아 사용한다.
  - supports() {} : 해당 검증기를 지원하는 여부 확인
  - validate(Object target, Errors errors) : 검증 대상 객체와 BindingResult
  - itemValidator.validate(item, bindingResult); 을 검증 부분에 추가한다.
 
- 앞에서는 검증기를 직접 불러서 사용했는데 WebDataBinder에 검증기를 추가해 사용할 수 있다.

~~~java
@InitBinder
public void init(WebDataBinder dataBinder) {
log.info("init binder {}", dataBinder);
dataBinder.addValidators(itemValidator);
}
~~~

- WebDataBinder에 검증기를 추가하면 해당 컨트롤러에 검증기를 자동으로 적용한다.
- @InitBinder` 해당 컨트롤러에만 영향을 준다. 글로벌 설정은 별도로 해야한다.

---
## 동작 방식

- WebDataBinder를 사용할때 @Validated 어노테이션을 붙여야 하는데 검증기를 실행하는 어노테이션이다. 이 어노테이션을 붙이면 WebDataBinder에 등록한 검증기를 찾아서 실행한다.
- 여기서 어떤 검증기가 실행되어야 하는지 지정을 해줘야 하는데 supports()를 사용한다.
- supports(Item.class) 호출되고, 결과가 true이므로 ItemValidator의 validate()가 호출된다.

# 출처
스프링 MVC 2편 - 백엔드 웹 개발 활용 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-2/dashboard?cid=327260
