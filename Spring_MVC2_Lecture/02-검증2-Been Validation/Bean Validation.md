# Bean Validation 

Validation 섹션에서는 검증 기능을 사용할때마다 코드를 작성해야하는 번거로움이 있는데 Bean Validation을 사용하면 어노테이션 하나로 검증 기능을 적용할 수 있다.

Hibernate Validator가 제공하는 어노테이션이다. 

### Bean Validation 사용하기

우선 Bean Validation을 사용하려면 의존관계를 추가해야 한다.

~~~java
implementation 'org.springframework.boot:spring-boot-starter-validation'
~~~

## 검증 어노테이션

- `@NotBlank` : 빈값 + 공백만 있는 경우를 허용하지 않는다.
- `@NotNull` : `null` 을 허용하지 않는다.
- `@Range(min = 1000, max = 1000000)` : 범위 안의 값이어야 한다.
- `@Max(9999)` : 최대 9999까지만 허용한다.

검증 어노테이션을 적용
~~~java
@NotBlank
private String itemName;

@NotNull
@Range(min = 1000, max = 1000000)
private Integer price;

@NotNull
@Max(9999)
private Integer quantity;
~~~

## 스프링 MVC에서 Bean Validation 적용

스프링 부트는 Bean Validation 의존관계를 추가하면 자동으로 Bean Validaiton을 인지하고 스프링에 통합한다.

스프링 부트는 자동으로 `LocalValidatorFactoryBean` 을 글로벌 Validator로 등록한다. Validator는 @NotNull 등 어노테이션을 보고 검증을 수행하고 @Valid, @Validated만 적용하면 된다. 

검증 오류가 발생하면 FeildError, ObjectError를 생성하고 BindingResult에 저장한다.

### 검증 순서
1. @ModelAttribute에서 각 필드에 타입 변환을 시도
   1. 성공하면 다음
   2. 실패하면 typeMismatch로 FiledError에 추가
2. Validator 적용


### 바인딩에 성공한 필드만 Bean Validation 적용한다.

BeanValidator는 바인딩에 실패한 필드는 BeanValidation에 적용하지 않는다. 모델 객체에 바인딩 받는 값이 정상으로 들어와야 검증도 의미가 있다.

@MdoelAttribute -> 각 필드 타입 변환 시도 -> 성공한 필드만 BeanValidation 적용
예시) itemName에 문자 입력 적용 성공, price에 문자 입력 적용 실패

## Bean Validation 에러코드 적용하기
오류 메시지를 변경해보자

Bean Validation은 오류코드가 어노테이션으로 등록되는데 typeMismatch와 비슷하다.

NotBlank오류 코드를 기반으로 MessageCodeResolver를 통해 메시지 코드가 생성되고 구체적에서 범용적으로 찾아 적용한다.

- NotBlank.item.itemName
- NotBlank.itemName
- NotBlank.java.lang.String
- NotBlank


#### errors.properties
~~~
Bean Validation 추가
NotBlank={0} 공백X
~~~
- {0}은 필드명, {1}, {2}, … 은 파라미터 값이다.


### 메시지 찾는 순서
1. errors.properties처럼 messageSource에서 찾기
2. 어노테이션 message 속성 사용
3. 라이브러리가 제공하는 기본 값을 사용한다. 

## Bean Validation - 오브젝트 오류
필드 오류가 아닌 오브젝트 오류는 @ScriptAssert를 사용하면 된다.
~~~
@ScriptAssert(lang = "javascript", script = "_this.price * _this.quantity >= 10000")
public class Item { ..
~~~

그런데 실제 사용하면 제약이 많고 복잡하기에 @ScriptAssert보단 직접 자바 코드로 작성하는것을 권장한다. 


## Bean Validaiton의 한계

데이터를 등록할때와 수정할때 요구사항이 다를 경우 어떻게 해야할까

등록 요구사항과 수정 요구사항을 예시로 보자

#### 등록 요구사항
- 타입 검증
  - 가격, 수량에 문자가 들어가면 검증 오류 처리
- 필드 검증
  - 상품명: 필수, 공백X
  - 가격: 1000원 이상, 1백만원 이하
  - 수량: 최대 9999
- 특정 필드의 범위를 넘어서는 검증
  - 가격 * 수량의 합은 10,000원 이상
#### 수정 요구사항
- 등록시에는 `quantity` 수량을 최대 9999까지 등록할 수 있지만 ****수정시에는** **수량을** **무제한으로** **변경****할 수 있다.
- 등록시에는 `id` 에 값이 없어도 되지만, ****수정시에는** id **값이** **필수****이다.

#### 수정 요구사항 적용
~~~java
@Data
public class Item {

@NotNull //수정 요구사항 추가
private Long id;

@NotBlank
private String itemName;

@NotNull
@Range(min = 1000, max = 1000000)
private Integer price;

@NotNull
//@Max(9999) //수정 요구사항 추가
private Integer quantity;
//...
}
~~~

실행해보면 수정은 잘 되지만 등록에서 문제가 발생한다. 
등록을 할때는 id에 값이 없고 수량도 9999까지가 적용이 되지 않는다.

## Groups 기능 사용
동일 객체에 등록과 수정할때 각각 다른 검증을 할 수 있다. 

- BeanValidation의 groups을 사용한다. 

각각 저장용, 업데이트용  grpoups를 생성한다.

**저장용**
~~~java
 public interface SaveCheck {
}
~~~

**수정용**
~~~java
public interface UpdateCheck {
}
~~~

#### groups 적용하기
~~~java
@NotNull(groups = UpdateCheck.class) //수정시에만 적용
private Long id;

@NotBlank(groups = {SaveCheck.class, UpdateCheck.class})
private String itemName;

@NotNull(groups = {SaveCheck.class, UpdateCheck.class})
@Range(min = 1000, max = 1000000, groups = {SaveCheck.class,
UpdateCheck.class})
private Integer price;

@NotNull(groups = {SaveCheck.class, UpdateCheck.class})
@Max(value = 9999, groups = SaveCheck.class) //등록시에만 적용
private Integer quantity;
~~~

#### 컨트롤러에 적용하고 싶은 로직을 추가하기
~~~java
@PostMapping("/add")
public String addItemV2(@Validated(SaveCheck.class)
~~~

- @Valid는 groups를 적용할 수 없으므로 @Validated를 사용해야 한다. 


groups 기능을 적용해서 각각 다르게 검증은 가능한데 복잡도가 올라갔다. 실무에서는 groups기능을 잘 사용하지 않고 등록용 폼, 수정용 폼 등 객체를 분리해서 사용한다. 


## Form 전송 객체 분리 

실무에서는 groups를 잘사용하지 않는다 이유는 등록시 폼에서 전달하는 데이터와 Item 도메인 객체와 안맞는다. 회원 데이터만 받는게 아닌 약관 정보 등도 추라고 받기에 Item 객체와 상관없는 많은 데이터가 넘어온다. 

그래서 Item을 직접 전달받는게 아니라 많은 데이터를 컨트롤러까지 전달할 별도의 객체를 생성해서 전달한다. 

#### 폼 데이터 전달할때 Item 도메인 객체 사용할 경우
- `HTML Form -> Item -> Controller -> Item -> Repository`
  - 장점: Item 객체를 컨트롤러, 리포지토리까지 직접 전달하므로 간단하다.
  - 단점: 간단한 경우에만 적용이 가능하다. 수정시 검증이 중복될 수도 있고 groups을 사용해야 한다.
- `HTML Form -> ItemSaveForm -> Controller -> Item 생성 -> Repository`
  - 장점: 전송하는 폼의 데이터에 맞춘 별도의 객체를 사용해 데이터를 전달받는다. 저장 폼, 수정 폼 등을 받는 객체를 만들기에 검증이 중복되지 않는다.
  - 단점:Item 객체를 생성하는 과정이 추가된다.

#### 이름 결정
- `ItemSave` 라고 해도 되고, `ItemSaveForm` , `ItemSaveRequest` , `ItemSaveDto` 등으로 사용해도 된다. 중요한 것은 일관성이다.


## Bean Validation- HTTP 메시지 컨버터

- @Valid, @Validated는 `HttpMessageConverter` (`@RequestBody` )에도 적용할 수 있다.

#### 복습

- `@ModelAttribute` 는 HTTP 요청 파라미터(URL 쿼리 스트링, POST Form)를 다룰 때 사용한다.
- `@RequestBody` 는 HTTP Body의 데이터를 객체로 변환할 때 사용한다. 주로 API JSON 요청을 다룰 때 사용 한다.

#### API경우 3가지 생각하기
- 성공 요청: 성공
- 실패 요청: JSON을 객체로 생성하는 것 자체가 실패함
- 검증 오류 요청: JSON을 객체로 생성하는 것은 성공했고, 검증에서 실패함

#### @ModelAttribute vs @RequestBody

- `@ModelAttribute` 는 필드 단위로 정교하게 바인딩이 적용된다. 특정 필드가 바인딩 되지 않아도 나머지 필드는 정상 바인딩 되고, Validator를 사용한 검증도 적용할 수 있다.
- `@RequestBody` 는 HttpMessageConverter 단계에서 JSON 데이터를 객체로 변경하지 못하면 이후 단계 자체가 진행되지 않고 예외가 발생한다. 컨트롤러도 호출되지 않고, Validator도 적용할 수 없다. 
  - 따라서 메시지 컨버터의 작동이 성공해서 `ItemSaveForm` 객체를 만들어야 `@Valid` , `@Validated` 가 적용된다


# 출처
스프링 MVC 2편 - 백엔드 웹 개발 활용 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-2/dashboard?cid=327260
