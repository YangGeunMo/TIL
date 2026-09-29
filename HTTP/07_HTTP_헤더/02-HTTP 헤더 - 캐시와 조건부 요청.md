# HTTP 헤더 2편 TIL - 캐시와 조건부 요청

## 캐시 기본 동작

### 캐시가 없을 경우

- 웹 브라우저에서 이미지를 요청하면 서버는 이미지를 전송한다.
- 몇 분 뒤 다시 필요해서 요청하면 다시 똑같이 전송한다.
- 데이터가 변경되지 않아도 계속 네트워크를 통해서 데이터를 다운로드한다.
- 인터넷 네트워크는 느리고 비싸기 때문에 계속 필요할 때마다 다운로드하면서 사용하면 브라우저 로딩 속도가 느려진다.

### 캐시를 적용한 경우

- 이미지를 요청하면 서버에서 HTTP 헤더의 Cache-Control 또는 Expires 헤더에 캐시 유효 시간(초)을 지정하고 전송한다.
- 브라우저 캐시에 응답 결과를 저장한다.
- 몇 분 뒤 다시 이미지를 요청할 경우 브라우저에 있는 캐시를 조회하고 캐시 유효 시간을 검증한 후 캐시에 있는 이미지를 웹 브라우저에게 전달한다.

**캐시 적용의 이점**:
- 캐시 유효 시간 동안 네트워크를 사용하지 않아도 된다.
- 네트워크 사용량을 줄일 수 있다.
- 브라우저 로딩 속도가 빨라진다.

### 캐시 만료 후

- 캐시 유효 시간이 초과되면 다시 서버에 요청한다.
- 응답 결과를 브라우저 캐시에 저장한다.

---

## 캐시 시간 초과 (검증 헤더의 필요성)

### 문제 상황

- 캐시 유효 시간이 초과해서 서버에 다시 요청하면 두 가지 상황이 나타난다.
  - 서버에서 기존 데이터를 변경했을 때
  - 서버에서 기존 데이터를 변경하지 않았을 때

### 해결 방안

- 캐시 만료 후 서버에서 데이터를 변경하지 않았을 때 다시 전송해 캐시를 보관한 후 재사용할 수 있다.
- 다만 클라이언트의 데이터와 서버의 데이터가 같다는 사실을 확인해야 한다.
- HTTP 헤더에 검증 헤더를 추가해서 확인한다.

### 검증 헤더 사용
<img width="1174" height="520" alt="image" src="https://github.com/user-attachments/assets/a86b32f6-3952-4d77-8bcd-574f3cf1cd12" />
<img width="1378" height="692" alt="image" src="https://github.com/user-attachments/assets/959c8b3f-05f2-473f-a313-15e545a9af31" />


- **Last-Modified**: 마지막 수정된 시간을 같이 전송해서 캐시에 저장한다.
- 캐시 시간이 초과하여 다시 요청할 때 캐시가 가지고 있는 데이터 최종 수정일도 같이 보낸다.
- 서버와 데이터 최종 수정일이 같으면 헤더만 전송하고(HTTP Body는 전송하지 않음) 응답 결과를 재사용한다.
- 네트워크 다운로드가 발생하지 않고 용량이 적은 헤더 정보로만 다운로드된다.

---

## 검증 헤더와 조건부 요청

### 검증 헤더

- 캐시 데이터와 서버 데이터가 같은지 검증하는 데이터를 나타낸다.
- **Last-Modified**: 마지막 수정 시간
- **ETag**: 데이터 고유 버전 정보

### 조건부 요청 헤더

- 검증 헤더로 조건에 따른 분기를 나타낸다.
- **If-Modified-Since**: Last-Modified 값을 사용한다.
- **If-None-Match**: ETag 값을 사용한다.

### 응답 결과

- 조건이 만족하지 않으면(데이터가 변경되지 않았으면) → **304 Not Modified**
- 조건이 만족하면(데이터가 변경되었으면) → **200 OK**

---

## Last-Modified & If-Modified-Since

### 예시

- If-Modified-Since**: 이 시간 이후에 데이터가 수정되었으면?

### 데이터 미변경 예시

- 캐시: 2020년 11월 10일 10:00:00 vs 서버: 2020년 11월 10일 10:00:00
- 응답: 304 Not Modified, 헤더 데이터만 전송(BODY 미포함)
- 전송 용량: 0.1MB (헤더 0.1MB)

### 데이터 변경 예시

- 캐시: 2020년 11월 10일 10:00:00 vs 서버: 2020년 11월 10일 11:00:00
- 응답: 200 OK, 모든 데이터 전송(BODY 포함)
- 전송 용량: 1.1MB (헤더 0.1MB, 바디 1.0MB)

### Last-Modified의 단점

- **1초 미만 단위 조정 불가능**: 1초 미만(0.x초) 단위로 캐시 조정이 불가능하다.
- **날짜 기반 로직 사용**: 수정 시간만 비교한다.
- **실제 내용 변경 무시**: 데이터를 수정했는데 날짜는 다르지만 같은 데이터를 수정해서 데이터 결과가 똑같은 경우, 데이터는 같으나 데이터 최종 변경일이 달라서 다시 전체를 다운로드한다.

---

## ETag & If-None-Match

### ETag란

- **ETag(Entity Tag)**: 캐시용 데이터에 임의의 고유한 버전 이름을 달아둔다.
- 예시: ETag: v1.0

### 데이터 변경 시

- 데이터가 변경되면 이 이름을 바꾸어 변경한다(Hash를 다시 생성).
- 예시: ETag:aaa → ETag: bbb

### 동작 방식
<img width="1096" height="510" alt="image" src="https://github.com/user-attachments/assets/9fedf43b-7f75-4753-966c-6c67fce93a52" />
<img width="1409" height="741" alt="image" src="https://github.com/user-attachments/assets/3a5c7614-cc73-4fb6-9fc0-0f689ab60af4" />

- 웹브라우저에서 이미지를 요청할 때 ETag 헤더도 같이 받는다.
- 캐시 유효기간이 지나고 서버에 다시 요청할 때 If-None-Match에 ETag 값을 담아서 전송한다.
- 서버의 ETag 내용과 클라이언트가 보낸 If-None-Match 값이 같으면 HTTP 헤더만 전송한다 (HTTP Body 전송 안 함).
- 헤더의 정보만으로 응답 결과를 캐시에 저장하고 재사용한다.

### ETag의 특징

- ETag만 서버에 보내면서 같으면 유지하고 다르면 다시 받으면 된다.
- 캐시 제어 로직을 서버에서 완전히 관리한다.

---

## Cache-Control

### 캐시 지시어(directives)

- **Cache-Control: max-age**: 캐시 유효 시간을 초 단위로 지정한다.
  - 예: Cache-Control: max-age=3600 (1시간)

- **Cache-Control: no-cache**: 데이터는 캐시해도 되지만, 항상 원(origin) 서버에서 검증하고 사용한다.


- **Cache-Control: no-store**: 데이터에 민감한 정보가 있으므로 저장하면 안 된다.
  - 메모리에서 사용하고 빠르게 삭제한다.

---

## Pragma

### Pragma: no-cache

- 캐시를 사용하지 않고, 매번 서버에서 데이터를 가져온다.

### HTTP 1.0 하위 호환

- HTTP 1.0 하위 호환 때문에 사용한다.
- 구형 시스템도 인식할 수 있도록 한다.
- 현대 웹은 Cache-Control을 권장한다.

---

## Expires

### 캐시 만료일 지정 (하위 호환)

- **Expires: Mon, 01 Jan 1990 00:00:00 GMT**
- 캐시 만료일을 정확한 날짜로 지정한다.
- HTTP 1.0부터 사용했다.

### 현재 상황

- 지금은 Cache-Control: max-age를 권장한다.
- Cache-Control: max-age와 함께 사용하면 Expires는 무시된다.

---

## 검증 헤더와 조건부 요청 헤더 정리

### 검증 헤더 (Validator)

- **ETag**: "v1.0", "asid93jkrh2l" 등의 형태를 나타낸다.
- **Last-Modified**: Thu, 04 Jun 2020 07:19:24 GMT 형태를 나타낸다.

### 조건부 요청 헤더

- **If-Match, If-None-Match**: ETag 값을 사용한다.
- **If-Modified-Since, If-Unmodified-Since**: Last-Modified 값을 사용한다.

---

## 프록시 캐시

### 필요성
<img width="1292" height="655" alt="image" src="https://github.com/user-attachments/assets/1bb00a60-7066-404f-9574-927b76d47b81" />

- 만약 한국에 있는 클라이언트가 미국에 있는 원(origin) 서버에 요청하면 시간이 걸린다.
- 그래서 미국에 있는 원 서버는 한국에 프록시 캐시 서버를 만들고 한국에 있는 클라이언트는 프록시 서버를 이용해 응답 시간을 줄일 수 있다.

---

## Cache-Control - 프록시 캐시 지시어

### Cache-Control: public

- 응답이 public 캐시에 저장되어도 된다.
- 예: 검색 결과 페이지 - 모든 사용자가 같은 내용을 본다.

### Cache-Control: private

- 응답이 해당 사용자만을 위한 것임을 나타낸다.
- private 캐시에 저장해야 한다 (기본값).
- 예: 사용자A의 정보 페이지, 사용자B가 같은 캐시를 보면 안 된다.
- 생략하면 private이 기본값이다.

### Cache-Control: s-maxage

- 프록시 캐시에만 적용되는 max-age 캐시 유지 시간을 나타낸다.
- 프록시 캐시 서버 ←→ 오리진 서버 간의 캐시 지정이다.

### Age: 60 (HTTP 헤더)

- 오리진 서버에서 응답 후 프록시 캐시 내에 머문 시간(초)을 나타낸다.
- 프록시가 이 캐시를 얼마나 보관했는지 알려주는 헤더이다.
- 클라이언트가 남은 캐시 유효 기간을 계산할 때 사용한다.

---

## 캐시 무효화

### Cache-Control: no-cache

- 데이터는 캐시해도 되지만, 항상 원 서버에 검증하고 사용한다.
- 이름에 주의한다.

### Cache-Control: no-store

- 데이터에 민감한 정보가 있으므로 저장하면 안 된다.
- 메모리에서 사용하고 최대한 빨리 삭제한다.

### Cache-Control: must-revalidate

- 캐시 만료 후 최초 조회 시 원 서버에 검증해야 한다.
- 원 서버 접근 실패 시 반드시 오류가 발생해야 한다 - 504(Gateway Timeout).
- must-revalidate는 캐시 유효 시간이라면 캐시를 사용한다.

---

## no-cache 기본 동작
<img width="1375" height="526" alt="image" src="https://github.com/user-attachments/assets/f69b486f-96ec-4e5b-8465-51c84e26ab1a" />
<img width="1335" height="529" alt="image" src="https://github.com/user-attachments/assets/010d55c4-f62a-406c-8318-6472f0eed318" />

- 브라우저에서 캐시 유효 시간이 만료되어 다시 요청할 때 no-cache + ETag를 프록시 서버를 통해 원서버에 요청한다.
- 원 서버는 검증 후 응답한다.
- 값이 변하지 않았을 경우 헤더만 보내고 캐시를 재사용한다.
- 만약 원서버에 장애 등으로 접근할 수 없을 경우 프록시 캐시 서버에서 캐시 데이터를 반환해준다.
- 이때 Error 또는 200 OK를 응답한다.

---

## Cache-Control: must-revalidate
<img width="1340" height="528" alt="image" src="https://github.com/user-attachments/assets/5b382d09-7f61-4d79-8d4d-5de0fe7efe3c" />

- 캐시 만료 후 원서버에 must-revalidate + ETag를 요청한다.
- 원서버가 장애 등으로 접근할 수 없는 경우 504 Gateway Timeout 코드를 클라이언트에게 응답한다.
- 반드시 캐시가 만료되면 원 서버에서 검증을 받아야 사용할 수 있다.

# 출처
모든 개발자를 위한 HTTP 웹 기본 지식
- https://www.inflearn.com/course/http-%EC%9B%B9-%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC/dashboard?cid=326277
