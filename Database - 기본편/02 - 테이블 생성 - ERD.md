# DDL - 테이블 생성 - ERD

## 키워드
- EDR(Entity Relationship Diagram)
## 내용 복습
**MySQL 워크벤치로 ERD만드는법**
- MySQL 워크벤치 실행
- 상단 메뉴 바에서 Database > Reverse Engineer.. 실행
- Continue 버튼으로 계속 넘어가다가 우리가 만든 `my_shop` 데이터베이스 선택
- 이후 계속 넘어가면 다음과 같은 ERD 확인 가능

**my_shop ERD**

<img width="634" height="211" alt="스크린샷 2026-10-28 오후 9 23 36" src="https://github.com/user-attachments/assets/11d04dbc-6dd9-4027-b695-9c9ff74e1ae3" />


**ERD가 필요한 이유**
여러 테이블을 만들었지만 테이블이 너무 많으면 구조 관계를 이해하기 힘들다. ERD가 시각적으로 테이블과 관계를 표현해줘서 구조 관계를 확인하기에 좋다. 

**관계 의미**
- 고객 한명(1)은 여러 번 주문(N)을 할 수 있다. 1:N (일대다 관계, One-to-Many)
- 상품(1)은 여러번 주문(N) 될 수있다. 1:N (일대다 관계, One-to-Many)

**까마귀발 표기법**
`—< 기호는 까마귀발 표기법(Crow's Foot Notation)을 간단히 표현한 것으로, <가 다수(Many)쪽을 의미한다.`


## 요약
MySQL 워크벤치의 Reverse Engineer 기능으로 my_shop 데이터베이스의 ERD를 만들어 테이블 구조와 관계를 시각적으로 확인했다. 고객과 주문, 상품과 주문은 각각 1:N(일대다) 관계이며, 까마귀발 표기법에서 < 기호는 다수(N)쪽을 나타낸다.

# 출처
김영한의 실전 데이터베이스 입문 - 모든 IT인을 위한 SQL 첫걸음(SQL부터 차근차근)
- https://www.inflearn.com/course/%EA%B9%80%EC%98%81%ED%95%9C-%EC%8B%A4%EC%A0%84-%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%A0%EC%9D%B4%EC%8A%A4-%EC%9E%85%EB%AC%B8?cid=338210
