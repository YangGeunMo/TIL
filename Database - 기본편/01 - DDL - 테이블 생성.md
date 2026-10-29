# DDL - 테이블 생성 
## 키워드
- AUTO_INCREMENT
- DATETIME DEFAULT CURRENT_TIMESTAMP
- 외래 키 제약 조건
## 복습 내용
#### 쇼핑몰 테이블 실전 설계
우리 쇼핑몰의 요구사항은 다음과 같다.
- 고객
  - 고객 id, 이름, 이메일, 비밀번호, 주소, 가입 시각이 관리되어야 한다.
- 상품
  - 상품 id, 이름, 설명, 가격, 재고 수량이 관리되어야 한다.
- 주문
  - 주문 id, 주문 고객, 주문 상품, 주문 수량, 주문 시각, 주문 상태가 관리되어야 한다.
  - 주문이 등록되면 최초의 주문 상태는 `주문접수` 상태가 된다.
  - 예제를 단순화 하기 위해 한 번의 주문 시에 한 종류의 상품만 주문할 수 있다. 한 종류의 상품을 여러 개 주문하는 것은 가능하다.

**고객 테이블**
~~~sql
# 고객 테이블 
CREATE TABLE customers (
	customer_id INT AUTO_INCREMENT PRIMARY KEY, # 고객을 식별하는 기본 키, 	AUTO_INCREMENT PRIMARY KEY : 데이터를 저장할때마다 자동으로 1씩 증가 
	name VARCHAR(50) NOT NULL,					# 이름 , 필수 입력
	email VARCHAR(100) NOT NULL UNIQUE,			# 이메일, 필수 입력, 중복 방지를 위해 UNIQUE 
	password VARCHAR(255) NOT NULL,				# 비밀번호 , 필수 입력
	address VARCHAR(255) NOT NULL,				# 주소, 필수 입력
	join_date DATETIME DEFAULT CURRENT_TIMESTAMP # 가입 시각, 값을 따로 넣지 않으면 DEFAULT 설정에 따라 현재 시각이 자동 기록 
);
~~~
- AUTO_INCREMENT : 데이터를 저장할때마다 1씩 증가해서 모든 행을 구분 할 수 있다.
- DATETIME DEFAULT CURRENT_TIMESTAMP : 가입 시간, 값을 따로 넣지 않으면 DEFAULT 설정에 따라 현재 시간이 자동 기록

~~~sql
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
~~~
- DEFAULT CURRENT_TIMESTAMP :  새로운 행(row)이 추가될 때, 해당 컬럼에 별도의 값을 지정하지 않으면 현재의 날짜와 시간이 자동 입력
- DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP : 새로운 데이터 행이 추가될때는 물론이고 같은 행의 컬럼 값이 변경되어 업데이트될 때, 업데이트한 현재 날짜와 시간을 자동 갱신한다. 

**상품 테이블**
~~~sql
CREATE TABLE products (
	product_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	description TEXT,
	price INT NOT NULL,
	stock_quantity INT NOT NULL DEFAULT 0
);
~~~
- stock_quantity : 필수로 값을 입력해야 하지만 값을 넣지 않으면 기본적으로 0이 되도록 DEFAULT 값 설정 

**주문 테이블**
~~~sql
CREATE TABLE orders(
   order_id INT AUTO_INCREMENT PRIMARY KEY,
   customer_id INT NOT NULL,
   product_id INT NOT NULL,
   quantity INT NOT NULL,
   order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
   status VARCHAR(20) NOT NULL DEFAULT '주문접수',
   
   CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
   CONSTRAINT fk_orders_product FOREIGN KEY (product_id) REFERENCES products(product_id)
   );
~~~
- customer_id: **중요한 부분**, 이 주문을 한 고객이 누구인지를 알 수 있다.
  - customers 테이블의 customer_id를 참조한다. 이 필드를 확인하면 고객을 찾을 수 있다.
- product_id : **중요한 부분**, 어떤 상품을 주문했는지 알 수 있다. 
  - products 테이블의 product_id를 참조한다. 이 필드를 확인하면 어떤 상품명인지 찾을 수 있다.

**외래 키 제약 조건**
~~~sql
CONSTRAINT [제약조건_이름]
FOREIGN KEY ([자식_테이블의_컬럼명])
REFERENCES [부모_테이블명]([부모_테이블의_컬럼명])
[ON DELETE 옵션] [ON UPDATE 옵션]
~~~

**fk_orders_customers**
- orders 테이블의  customer_id를 customers 테이블의 customer_id와 연결하는 외래키
- 두 테이블간 관계가 형성되면서 존재하지 않는 고객 id로 주문을 넣을 수 없게 데이터베이스에서 차단된다.

**fk_orders_product**
- orders 테이블의 product_id를 products 테이블의 product_id와 연결하는 외래키
- 두 테이블간 관계가 형성되어 존재하지 않는 상품id로 주문을 넣을 수 없게 데이터베이스에서 차단된다. 

## 요약 
외래 키(FOREIGN KEY)로 orders 테이블의 customer_id, product_id를 각각 customers, products 테이블의 기본 키와 연결했다. 이로써 두 테이블 사이에 관계가 형성되었고,
존재하지 않는 고객이나 상품의 id로는 주문을 등록할 수 없도록 데이터베이스가 차단하게 되었다.

# 출처
김영한의 실전 데이터베이스 입문 - 모든 IT인을 위한 SQL 첫걸음(SQL부터 차근차근)
- https://www.inflearn.com/course/%EA%B9%80%EC%98%81%ED%95%9C-%EC%8B%A4%EC%A0%84-%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%A0%EC%9D%B4%EC%8A%A4-%EC%9E%85%EB%AC%B8?cid=338210
