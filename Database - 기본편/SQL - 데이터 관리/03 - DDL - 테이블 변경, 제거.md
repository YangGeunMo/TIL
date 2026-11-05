# DDL - **테이블** **변경**, **제거**
## 키워드
- ALTER TABLE 
- ADD COLUMN
- MODLFY COLUMN
- DROP COLUMN
- TRUNCATE 
## 복습 내용

**ALTER TABLE**
- 이미 만든 테이블 구조를 변경한다.

**ADD COLUMN**
~~~sql
ALTER TABLE customers
ADD COLUMN point INT NOT NULL DEFAULT 0;
~~~
- customers 테이블을 변경하겠다는 의미 
- ADD COLUMN는 컬럼을 추가

**MODLFIY COLUMN** - 데이터 타입 변경하기 
~~~sql
ALTER TABLE customers
MODIFY COLUMN address VARCHAR(500) NOT NULL;
~~~
- address 컬럼 길이 500으로 변경하기 

**DROP COLUMN** 
- 열 삭제 
~~~sql
ALTER TABLE customers
DROP COLUMN point;
~~~


**DROP TABLE vs TRUNCATE TABLE**

DROP TABLE 
- 테이블의 데이터는 물론 테이블까지 완전히 삭제 
TRUNCATE TABLE
- 테이블만 남기고 안에 데이터는 모두 삭제

언제 사용하는가
테스트 데이터를 모두 지우고 처음부터 할때는 TRUNCATE, 테이블 자체를 지우려면 DROP을 사용하면 된다.

**제약조건 무시하기**
제약조건이 걸린 테이블은 DROP, TRUNCATE을 할 수 없다.

제약 조건을 임시로 무시하려면 외래키 체크를 비활성화 하면 된다.
~~~sql
SET FOREIGN_KEY_CHECKS = 0; -- 비활성화
SET FOREIGN_KEY_CHECKS = 1; -- 활성화
~~~
비활성화 후 다시 활성화를 해주는게 좋다.


**DROP TABLE vs TRUNCATE TABLE 차이**
| 구분                 | `DELETE FROM table;`                  | `TRUNCATE TABLE table;`         |
|--------------------|---------------------------------------|---------------------------------|
| **종류**             | **DML** (데이터 조작어)                     | **DDL** (데이터 정의어)               |
| **처리 방식**          | 한 줄씩, 조건에 따라 삭제 가능<br>(`WHERE` 사용 가능) | 테이블 전체를 한 번에 삭제 (`WHERE` 사용 불가) |
| **속도**             | 느림 (각 행의 삭제를 기록)                      | 매우 빠름 (테이블을 잘라내고 새로 만드는 개념)     |
| `AUTO_INCREMENT`   | 초기화되지 않음                              | **1부터 다시 시작하도록 초기화됨**           |
| **되돌리기(Rollback)** | 트랜잭션 내에서 `ROLLBACK` 가능                | `ROLLBACK` 불가능 (즉시 적용)          |

## 요약
- ALTER 키워드를 통해 테이블의 내용을 변경할 수 있다.
- 제약조건이 걸린 테이블은 삭제할 수 없다. 제약조건을 비활성화 후 삭제할 수 있다.

# 참고
김영한의 실전 데이터베이스 입문 - 모든 IT인을 위한 SQL 첫걸음(SQL부터 차근차근)
- https://www.inflearn.com/course/%EA%B9%80%EC%98%81%ED%95%9C-%EC%8B%A4%EC%A0%84-%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%A0%EC%9D%B4%EC%8A%A4-%EC%9E%85%EB%AC%B8/dashboard?cid=338210
