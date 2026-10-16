# 검증 요구사항 

- 웹 서비스는 폼 입력시 오류가 발생하면 고객이 입력한 데이터를 유지하고 어떤 오류가 발생했는지 알려줘야 한다.
- 컨트롤러의 역할중 HTTP 요청이 정상인지 검증하는 것인데 정상 로직보다 검증 로직을 개발하는게 더 어려울 수 있다.
- 클라이언트 검증과 서버 검증이 있는데
  - 클라이언트 검증은 조작되어서 요청이 들어올 수 있으므로 보안이 취약하다.
  - 서버만 검증하면 즉작적인 고객의 사용성이 부족해진다.
  - 클라이언트 검증과 서버 검증을 섞어서 사용하나 최종적으로 서버 검증은 필수이다.
  - API 방식을 사용하면 API 스펙을 잘 정의해서 검증 오류를 API 응답 결과에 남겨줘야 한다.
  

## 검증 직접 처리
<img width="788" height="511" alt="스크린샷 2026-10-16 오후 2 57 25" src="https://github.com/user-attachments/assets/2b3adffa-bdb5-4a47-98de-9f229db75a96" />

- 상품 등록 폼에서 상품명을 입력하지 않거나 가격, 수량 등을의 범위를 지정한 수만큼 입력하지 않으면 서버 검증 로직이 실패를 해야하고 실패했을때 다시 상품 등록 폼을 보여주고 어떤 값을 잘못 입력했는지 알려줘야 한다.

## 검증 처리 - 직접 개발 

~~~java
 //검증 오류 결과를 보관
        Map<String, String> errors = new HashMap<>();
~~~
- 검증 오류가 발생하면 어디서 발생했는지 필드에 따른 오류 메시지를 저장한다.

~~~java
 //검증 로직
        if (!StringUtils.hasText(item.getItemName())) {
            errors.put("itemName", "상품이름은 필수입니다.");
        }
        if (item.getPrice() == null || item.getPrice() < 1000 || item.getPrice() > 1000000) {
            errors.put("price", "가격은 1,000 ~ 1,000,000 까지 허용합니다.");
        }
        if (item.getQuantity() == null || item.getQuantity() >= 9999) {
            errors.put("quantity", "수량은 최대 9,999 까지 허용합니다.");
        }
        //특정 필드가 아닌 복합 룰 검증
        if (item.getPrice() != null && item.getQuantity() != null) {
            int resultPrice = item.getPrice() * item.getQuantity();
            if (resultPrice < 10000) {
                errors.put("globalError", "가격 * 수량의 합은 10,000원 이상이어야 합니다. 현재 값 = " + resultPrice);
            }
        }
~~~
- 검증 오류가 발생했을때 발생한 오류에 따른 문구와 검증 오류 조건을 정한다.
- 검증이 발생하면 오류 메시지를 저장한다.

~~~java
        //검증에 실패하면 다시 입력 폼으로
        if (!errors.isEmpty()) {
            log.info("errors={}", errors);
            //검증에 실패했을경우 실패한 데이터 값이 폼에 그대로 보여준다.
            // 데이터 입력 -> 검증 실패 -> 검증 실패 데이터를 객체에 담음 ->th:object="${item}"로 매핑한 필드 값을 가져온다.
            model.addAttribute("errors", errors);
            return "validation/v1/addForm";
        }
~~~
- 검증 오류를 보관하는 errors가 비어있지 않으면 검증 오류 데이터를 model에 담아 뷰에 전달한다.

## 문제점
- price와 quantitu는 Integer 타입인데 폼에서 문자 타입을 입력받으면 오류가 발생한다. 컨트롤러에 진입 전에 예외가 발생하기 때문에 컨트롤러가 호출되지 않고 400 예외를 발생하고 오류 페이지로 이동된다.
- price에 문자를 입력해 오류가 발생해도 입력한 문자는 화면에 남겨야 한다. 문자는 바인딩이 불가능하므로 입력한 문자가 사라지고 어떤 내용을 입력해서 요류가 발생했는지 알기 어렵다.
- 입력한 값도 따로 보관해야 한다.

## 검증 처리 - BindingResult

~~~java
 public String addItemV1(@ModelAttribute Item item, BindingResult bindingResult, RedirectAttributes redirectAttributes, Model model)
~~~
- BindingResult bindingResult는 @ModelAttribute Item item 옆에 있어야 한다.

~~~java
 //검증 로직
        if (!StringUtils.hasText(item.getItemName())) {
            //필드의 오류발생시 FieldError객체를 생성해서 bindingResult에 담는다.
            bindingResult.addError(new FieldError("item","itemName","상품 이름은 필수 입니다."));
        }
        if (item.getPrice() == null || item.getPrice() < 1000 || item.getPrice() > 1000000) {
            bindingResult.addError(new FieldError("item","price","상품 이름은 필수 입니다."));
        }
        if (item.getQuantity() == null || item.getQuantity() >= 9999) {
            bindingResult.addError(new FieldError("item","quantity","수량은 최대 9,999 까지 허용합니다."));

        }
        //특정 필드가 아닌 복합 룰 검증
        if (item.getPrice() != null && item.getQuantity() != null) {
            int resultPrice = item.getPrice() * item.getQuantity();
            if (resultPrice < 10000) {
                bindingResult.addError(new ObjectError("item","가격 * 수량의 합은 10,000원 이상이어야 합니다. 현재 값 = " + resultPrice));
            }
        }
~~~
- 필드 오류를 bindingResult에 담는다.

~~~java
public FieldError(String objectName, String field, String defaultMessage) {}
~~~
- FieldError 객체를 생성해서 bindingResult에 담는다. 
  - objectName : @ModelAttribute 이름
  - field : 오류가 발생한 필드 이름
  - defaultMessage : 오류 기본 메시지
 
~~~java
public ObjectError(String objectName, String defaultMessage) {}
~~~
- 특정 필드가 아닌 오류가 발생하면 new ObjectError 객체를 생성하고 bindingResult에 담아둔다.
  - objectName : @ModelAttribute 의 이름
  - defaultMessage : 오류 기본 메시지
 
## bindingResult
- 스프링이 제공하는 검증 오류를 보관하는 객체이다. 검증 오류가 발생하면 bindingResult에 보관한다.
- bindingResult가 있으면 @ModelAttribute에 데이터 바인딩을 할때 오류가 발생해도 컨트롤러가 호출된다.
- bindingResult가 있으면 오류 정보(FieldError)를 bindingResult에 저장하고 컨트롤러 정상호출

### bindingResult을 적용하는 방법
- @ModelAttribute 객체의 타입 오류 등으로 바인딩 실패시 스프링이 FieldError 객체를 생성해서 bindingResult에 저장
- 개발자가 직접 전달
- Validator 사용
