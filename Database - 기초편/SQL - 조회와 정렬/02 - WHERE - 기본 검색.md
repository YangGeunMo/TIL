# WHERE - 기본 검색
## 키워드
- WHERE
- BETWEEN
- IN
- LIKE
## 복습 내용
**WHERE**
- 특정한 조건을 만족하는 데이터를 찾고 싶을때 사용한다.
~~~sql
SELECT 열이름
FROM 테이블이름
WHERE 조건;
~~~

**비교 연산자**
- = : 같다
- ! = 또는 <> : 같지 않다
- `>`  : 크다
- < : 작다
- `>=` : 크거나 같다
- <= : 작거나 같다

문자열 날짜는 (‘)로 감싸준다. 숫자는 그대로 사용한다.

**논리 연산자**
- AND : 양쪽 조건 모두 참
- OR : 양쪽 조건중 하나라도 참
- NOT : 주어진 조건을 부정

**가격 5000원 이상이면서, 재고 50개 이상인 상품 조회**
~~~sql
SELECT * FROM products WHERE price >= 5000 AND stock_quantity >= 50;
~~~

**편리한 조건검색 : BETWEEN, IN, LIKE, IS NULL**

**BETWEEN : 특정 범위에 있는 값 찾기**
- BETWEEN a AND b : a는 최소값, b는 최댓값

가격이 5000원에서 15000원 사이인 상품 찾기 
~~~sql
ELECT * FROM products WHERE price >= 5000 AND price <= 15000
~~~

**BETWEEN 적용**
~~~sql
SELECT * FROM products WHERE price BETWEEN 5000 AND 15000;
~~~

**NOT BETWEEN**
- 특정 범위를 제외한 값 찾기

가격이 5000원에서 15000원 사이인 상품은 대상이 아닌 상품 찾기 
~~~sql
SELECT * FROM products WHERE price NOT BETWEEN 5000 AND 15000;
~~~

**IN**
- 목록에 포함된 값을 찾는다.

갤럭시, 아이폰, 에어팟 상품들만 출력 
~~~sql
SELECT * FROM products WHERE name ='갤럭시' 
OR name ='아이폰' 
OR name ='에어팟';
~~~
- OR을 많이 사용하므로 불편하다.

**IN사용**
~~~sql
SELECT * FROM products WHERE name IN ('갤럭시','아이폰','에어팟');
~~~
- OR을 여러번 쓰는것보다 가독성이 좋아졌다.

**NOT IN**
- 목록에 포함되지 않는 값 찾기
~~~sql
SELECT * FROM products WHERE name NOT IN ('갤럭시','아이폰','에어팟');
~~~

**LIKE**
- 문자열 일부 검색하기
- %: 모든 문자를 의미 
  - 김% : 김으로 시작하는 문자열을 검색한다. 
  - %김: 김으로 끝나는 문자열을 검색한다. 
  - %김%: 김이라는 단어를 포함한 모든 문자열을 검색한다.
  - 홍_동: 홍으로 시작하고 동으로 끝나는 세글자 이름을 검색한다. 

서울시에 사는 고객들 검색하기
~~~sql
SELECT * FROM customers WHERE address LIKE '서울시%';
~~~

**NOT LIKE**
- 특정 패턴을 제외하고 검색

서울시에 거주하지 않는 고객들 검색하기
~~~sql
SELECT * FROM customers WHERE address NOT LIKE '서울시%';
~~~
## 요약 
- WHERE절은 특정 조건에 만족하는 데이터를 찾을 때 사용한다. 
- BETWEEN은 특정 범위를 찾을때 사용한다. 
- IN은 목록에 포함된 데이터를 찾을때 사용한다.
- LIKE는 문자열일부를 검색할때 사용한다.

# 참고
김영한의 실전 데이터베이스 입문 - 모든 IT인을 위한 SQL 첫걸음(SQL부터 차근차근)
- https://www.inflearn.com/course/%EA%B9%80%EC%98%81%ED%95%9C-%EC%8B%A4%EC%A0%84-%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%A0%EC%9D%B4%EC%8A%A4-%EC%9E%85%EB%AC%B8/dashboard?cid=338210
