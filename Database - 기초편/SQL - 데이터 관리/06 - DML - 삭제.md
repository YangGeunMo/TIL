# DML - 삭제
## 키워드
- DELETE 
## 복습 내용
**DELETE**
- 테이블 행을 삭제하는 명령어 
~~~sql
DELETE FROM table_name
WHERE condition;
~~~

~~~sql
DELETE FROM products
WHERE product_id = 1; -- 상품 ID가 1번이라고 가정
~~~
- products 테이블의 상품 1번을 삭제

**WHERE절을 잘 사용하기**
~~~sql
-- 절대로, 절대로 따라하지 말 것!
DELETE FROM customers;
~~~
- DELETE 명령문에서 WHERE절을 생략하면 모든 데이터를 삭제한다. 
- 안전 업데이트 모드가 활성화 되어 있으면 실행되지 않는다. 만약 비활성화 되어 있다면 모든 데이터가 삭제된다. 

## 요약 
- DLEETE 명령문은 테이블 행을 삭제하는 명령어
- WHERE절을 생략할 경우 테이블의 모든 데이터가 삭제된다. 조심

# 참고
김영한의 실전 데이터베이스 입문 - 모든 IT인을 위한 SQL 첫걸음(SQL부터 차근차근)
- https://www.inflearn.com/course/%EA%B9%80%EC%98%81%ED%95%9C-%EC%8B%A4%EC%A0%84-%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%A0%EC%9D%B4%EC%8A%A4-%EC%9E%85%EB%AC%B8/dashboard?cid=338210
