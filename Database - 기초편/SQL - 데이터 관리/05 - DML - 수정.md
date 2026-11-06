# DML - 수정
## 키워드
- UPDATE 
## 복습 내용
**UPDATE**
- 존재하는 데이터를 수정하는 명령어
~~~sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
~~~
- SET은 수정할 데이터
- WHERE은 수정할 행을 지정  

**SQL 안전 업데이트 모드**
UPDATE를 사용할때 WHERE절을 생략할 경우 모든 값이 변경될 수 있다.
~~~sql
UPDATE products
SET price = 990; -- WHERE product_id = 1; -- 실수로 생략
~~~
- 이렇게 실행된다면 price의 모든 값이 990로 바뀐다.
- 이렇게 실행하면 안전 업데이트 모드를 사용중이므로 실행이되지 않고 오류가 발생한다. 

~~~sql
SELECT @@SQL_SAFE_UPDATES;
~~~
- 실행 결과는 1은 안전 업데이트 모드 활성화, 0은 비활성화 

그러므로 안전 업데이트 모드를 사용할때는 WHERE절을 반드시 사용해야 한다. 

MySQL이 제공하는 안전 업데이트 모드는 기본적으로 비활성화이다. 
- MySQL 서버: 0
- 애플리케이션(커넥션) : 0
- MySQL 워크벤치 : 1 이다.

~~~sql
SET SQL_SAFE_UPDATES = 0; -- 안전 업데이트 모드 끄기
SET SQL_SAFE_UPDATES = 1; -- 안전 업데이트 모드 활성화
~~~
안전 업데이트 모드는 임의로 변경할 수 있다. 안전 업데이트 모드를 비활성화하고 필요한 기능을 사용한 후에 다시 안전 업데이트 모드를 활성화 하는게 안전하다. 
## 요약
- UPDATE는 존재하는 데이터를 수정하는 명령어이다.
- WHERE절을 안쓰고 SET으로 데이터를 변경할때 그 필드의 모든 값이 변경될 수 있다. 
- SQL 안전 업데이트 모드가 있는데 활성화 되어 있을 경우 WHERE절 없이는 실행이 안된다.
- 안전 업데이트 모드를 활성화 하는 경우에는 WHERE절이 필수다. 
- 안전 업데이트 모드를 비활성화 하고 필요한 기능을 사용 후 다시 업데이트 모드를 활성화 하는게 안전하다.

# 출처
김영한의 실전 데이터베이스 입문 - 모든 IT인을 위한 SQL 첫걸음(SQL부터 차근차근)
- https://www.inflearn.com/course/%EA%B9%80%EC%98%81%ED%95%9C-%EC%8B%A4%EC%A0%84-%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%A0%EC%9D%B4%EC%8A%A4-%EC%9E%85%EB%AC%B8/dashboard?cid=338210
