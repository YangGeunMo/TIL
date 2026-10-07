# HTTP 메시지 컨버터

뷰 템플릿으로 HTML을 생성해서 응답하는게 아닌 HTTP API처럼 JSON 데이터를 HTTP 메시지 바디에서 직접 읽거나 쓰는경우 HTTP 메시지 컨버터를 사용한다.

## @ResponseBody 사용원리

<img width="781" height="400" alt="스크린샷 2026-10-08 오전 12 19 10" src="https://github.com/user-attachments/assets/62dd9fc2-7244-4192-a0d7-0e4ed768d5e9" />

- @ResponseBody를 사용했을 때
  - HTTP BODY에 문자 내용을 직접 반환한다.
  - ViewResolver 대신 HttpMessageConverter가 동작한다.
  - HttpMessageConverter 기능
    - 기본 문자처리: StringHttpMessageConverter
    - 기본 객체처리: MappingJackson2HttpMessageConverter
    - byte 처리 등등 기타 여러 HttpMessageConverter가 기본으로 등록되어 있고 사용된다.
   
- 응답의 경우 클라이언트의 HTTP Accept 해더와 서버의 컨트롤러 반환 타입 정보 둘을 조합해서 HttpMessageConverter 가 선택된다.
  - Accept 뜻 : HTTP 요청 헤더인데, 클라이언트가 서버에게 "어떤 형식의 데이터를 원하는지"를 알려주는 것이다.


### HTTP 메시지 컨버터 적용

스프링 MVC는 다음 상황에서 HTTP 메시지 컨버터 적용된다.
- HTTP 요청: @RequestBody , HttpEntity(RequestEntity)
- HTTP 응답: @ResponseBody , HttpEntity(ResponseEntity)

---

## HTTP 메시지 컨버터 인터페이스 내부 - 어떤 내부인지 참고만
~~~java
public interface HttpMessageConverter<T> {

	boolean canRead(Class<?> clazz, @Nullable MediaType mediaType);
	boolean canWrite(Class<?> clazz, @Nullable MediaType mediaType);

	List<MediaType> getSupportedMediaTypes();

	default List<MediaType> getSupportedMediaTypes(Class<?> clazz) {
		return (canRead(clazz, null) || canWrite(clazz, null) ?
				getSupportedMediaTypes() : Collections.emptyList());
	}

	T read(Class<? extends T> clazz, HttpInputMessage inputMessage)
			throws IOException, HttpMessageNotReadableException;

	rite(T t, @Nullable MediaType contentType, HttpOutputMessage outputMessage)
			throws IOException, HttpMessageNotWritableException;
}
~~~

HTTP 메시지 컨버터는 HTTP 요청, 응답 둘다 사용된다.
- canRead(), canWrite() : 메시지 컨버터가 해당 클래스, 미디어타입을 지원하는지 체크
  - canRead: JSON → 객체로 변환할 수 있는지 
  - canWrite: 객체 → JSON으로 변환할 수 있는지

- read(), write() : 메시지 컨버터를 통해서 메시지를 읽고 쓰는 기능
  - read(): JSON 문자열 → 객체로 변환
  - write(): 객체 → JSON 문자열로 변환

---

## 스프링 부트 기본 메시지 컨버터 

스프링 부트는 다양한 메시지 컨버터를 제공한다. 대상 클래스 타입과 미디어 타입을 체크해  사용여부를 결정한다. 만약 만족하지 않을경우 다음 메시지 컨버터로 넘어간다. 

일부는 생략
~~~
0 = ByteArrayHttpMessageConverter
1 = StringHttpMessageConverter
2 = MappingJackson2HttpMessageConverter
~~~

## ByteArrayHttpMessageConverter
역할: 바이트 배열(이진 데이터)을 처리한다. 주로 파일, 이미지 등의 바이너리 데이터에 사용.

- 처리 클래스 타입: `byte[]`
- 지원 Media Type: `*/*` (모든 형식 가능)
- 요청 예시: `@RequestBody byte[] data` (바이너리 데이터 받기)
- 응답 예시: `@ResponseBody return byte[]` (바이너리 데이터 반환)
- 응답 Content-Type: `application/octet-stream` (일반 바이너리 형식)

사용용도 : 파일 다운로드/업로드, 이미지, 동영상 등

---

## StringHttpMessageConverter
역할: 단순 문자열 데이터를 처리한다. 텍스트만 주고받을 때 사용.

- 처리 클래스 타입: `String`
- 지원 Media Type: `*/*` (모든 형식 가능)
- 요청 예시: `@RequestBody String data` (문자열 받기)
- 응답 예시: `@ResponseBody return "ok"` (문자열 반환)
- 응답 Content-Type: `text/plain` (일반 텍스트)

사용 용도:  간단한 텍스트 응답 (거의 안 씀)

---

## MappingJackson2HttpMessageConverter
역할: Java 객체를 JSON으로 변환한다. 현대적인 REST API에서 가장 많이 사용.
- Jackson 라이브러리가 자동으로 객체 ↔ JSON 변환

- 처리 클래스 타입: 객체, `HashMap` (JSON으로 변환 가능한 모든 타입)
- 지원 Media Type: `application/json`
- 요청 예시**: `@RequestBody ProductDto data` (JSON → ProductDto 객체로 변환)
- 응답 예시: `@ResponseBody return productDto` (ProductDto 객체 → JSON으로 변환)
- 응답 Content-Type: `application/json`

사용 용도:  REST API에서 거의 항상 이것! (API 응답은 대부분 JSON을 사용한다.)

## HTTP 요청 데이터 읽기 (@RequestBody)

HTTP 요청 → 컨트롤러에서 `@RequestBody`, `HttpEntity` 파라미터 사용

1. `canRead()` 호출해서 조건 확인
   - 대상 클래스 타입 지원하는지 확인 (byte[], String, HelloData 등)
   - Content-Type 지원하는지 확인 (text/plain, application/json, */ * 등)

2. 조건 만족하면 `read()` 호출한다.
   - HTTP 요청 데이터를 객체로 변환해서 반환

---

## HTTP 메시지 컨버터 선택
~~~java
content-type: application/json
@RequestMapping
void hello(@RequestBody HelloData data) {}
~~~

@RequestBody에 요청이 들어오면:

0 = ByteArrayHttpMessageConverter
1 = StringHttpMessageConverter
2 = MappingJackson2HttpMessageConverter

각 컨버터가 조건을 만족하는지 순서대로 확인한다.

1. ByteArrayHttpMessageConverter
   - 대상 타입이 byte[]인지 확인한다. HelloData 타입이므로 패스한다. 

2. StringHttpMessageConverter
   - 대상 타입이 String인지 확인한다. HelloData 타입이므로 패스한다. 

3. MappingJackson2HttpMessageConverter
   - 대상 타입이 객체인지 확인한다. HelloData 객체 타입이 맞다.
   - Content-Type이 application/json인지 확인한다. 맞다.
   - 둘다 만족하면 사용한다. 

## HTTP 요청 데이터 읽기 (@RequestBody)

HTTP 요청 → 컨트롤러에서 `@RequestBody`, `HttpEntity` 파라미터 사용

1. `canRead()` 호출해서 조건 확인한다.
   - 대상 클래스 타입 지원하는지 (byte[], String, HelloData 등)
   - Content-Type 지원하는지 (text/plain, application/json, */ * 등)

2. 조건 만족하면 `read()` 호출한다.
   - HTTP 요청 데이터를 객체로 변환해서 반환

---

## HTTP 응답 데이터 생성 (@ResponseBody)

컨트롤러에서 `@ResponseBody`, `HttpEntity`로 값 반환

1. `canWrite()` 호출해서 조건을 확인한다.
   - 반환 클래스 타입을 확인한다. (byte[], String, HelloData 등)
   - Accept 헤더 지원하는지 확인한다. (text/plain, application/json, */ * 등)

2. 조건 만족하면 `write()` 호출한다.
   - 객체를 HTTP 응답 메시지 바디에 데이터로 변환해서 생성

# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1/dashboard?cid=326674
