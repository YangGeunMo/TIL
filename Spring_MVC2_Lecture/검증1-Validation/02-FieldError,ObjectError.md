# FieldError와 ObjectError

- 입력한 오류 메시지를 화면에 남길 수 있다.

## FieldError 생성자
- FieldError는 2개의 생성자를 제공한다.
- ObjectError도 유사하게 두 가지 생성자를 제공한다. 
~~~java
public FieldError(String objectName, String field, String defaultMessage);
public FieldError(String objectName, String field, @Nullable Object rejectedValue, boolean bindingFailure, @Nullable String[] codes, @Nullable Object[] arguments, @Nullable String defaultMessage)
~~~
- 입력 데이터가 @ModelAttribute에 바인딩되는 시점에서 오류가가 발생하면 모델 객체에 입력 데이터를 저장하기가 어렵다(ex)Integer 타입인데 문자를 입력했을 경우) 그래서 오류가 발생한 경우 입력데이터를 따로 보관해야 한다. 보관한 입력 데이터를 검증 오류 발생시 다시 화면에 출력한다.
- FieldError를 사용해 입력 값을 저장하는 기능을 제공한다. 

### 파라미터 목록
- `objectName` : 오류가 발생한 객체 이름
- `field` : 오류 필드
- `rejectedValue` : 사용자가 입력한 값(거절된 값)
- `bindingFailure` : 타입 오류 같은 바인딩 실패인지, 검증 실패인지 구분 값
- `codes` : 메시지 코드
- `arguments` : 메시지에서 사용하는 인자
- `defaultMessage` : 기본 오류 메시지



## ValidationItemControllerV2 - addItemV2
~~~java
if (item.getPrice() == null || item.getPrice() < 1000 || item.getPrice() >1000000) {
bindingResult.addError(new FieldError("item", "price",item.getPrice(), false, null, null,"가격은 1,000 ~ 1,000,000 까지 허용합니다."));
}
~~~
- item.getPrice()를 추가하면 오류 메시지를 남길 수 있다.

# 출처
스프링 MVC 2편 - 백엔드 웹 개발 활용 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-2/dashboard?cid=327260
