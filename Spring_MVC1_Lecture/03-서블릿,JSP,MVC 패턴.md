# 서블릿,JSP, MVC 패턴

## 참고
- 예제의 일부를 가지고 정리했다. 다시 복습할때 이해가 안될경우 강의 PDF를 보자

## 회원 관리 웹 애플리케이션 요구사항

회원 정보
* 이름:username
* 나이: age

기능 요구사항
* 회원 저장
* 회원 목록 조회

#### 회원 도메인 모델

```
@Getter @Setter
public class Member {
    private Long id;
    private String username;
    private int age;
    public Member() {

    }
    public Member(String username, int age) {
        this.username = username;
        this.age = age;
    }
}

```

* Lombok - @Getter, @Setter
* @Getter, @Setter 애노테이션을 사용하면 Lombok이 자동으호 getter,setter 메서드를 생성해준다. 

#### 회원 저장소

```
public class MemberRepository {

    //회원을 저장할 자료구조
    private static Map<Long, Member> store = new HashMap<>();
    private static long sequence = 0L;


    //싱글톤
    private static final MemberRepository instance = new MemberRepository();
	// getInstance()로만 접근 가능
    public static MemberRepository getInstance() {
        return instance;
    }
	// 생성자를 private으로 제한 (새로운 객체 생성 불가)
    private MemberRepository() {

    }

```

- 모든 Member를 한곳에 관리하는 저장소 역할이다. 
- 싱글톤으로 안할 경우 각각 store를 가지게 되어 데이터가 분산된다. 

## 서블릿으로 회원 관리 웹 애플리케이션 만들기 

```
@WebServlet(name = "memberFormServlet", urlPatterns = "/servlet/members/new-form")
public class MemberFormServlet extends HttpServlet {
    
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("text/html");
        response.setCharacterEncoding("utf-8");

        //자바 코드로 HTML 만들기, 작성이 불편하다.
        PrintWriter w = response.getWriter();
        w.write("<!DOCTYPE html>\n" +
                "<html>\n" +
                "<head>\n" +
                " <meta charset=\"UTF-8\">\n" +
                " <title>Title</title>\n" +
                "</head>\n" +
                "<body>\n" +
                "<form action=\"/servlet/members/save\" method=\"post\">\n" +
                " username: <input type=\"text\" name=\"username\" />\n" +
                " age: <input type=\"text\" name=\"age\" />\n" +
                " <button type=\"submit\">전송</button>\n" +
                "</form>\n" +
                "</body>\n" +
                "</html>\n");
    }

```

서블릿과 자바 코드로만 HTML을 만들었는데 동적으로 원하는 HTML을 동적으로 만들 수 있다. 그런데 자바 코드로 HTML을 만드는 것보다 HTML문서로 동적으로 변경하고 필요한 부분만 자바 코드를 넣으면 더 효율적이다. 이러한 해결방법으로는 템플릿 엔진을 사용하면 HTML 문서에 필요한 곳만 코드를 적용해 동적으로 만들 수 있다.
템플릿 엔진 : JSP,Thymeleaf 등이 있다. 


## JSP로 회원 관리 웹 애플리케이션 만들기

- <%@ page contentType="text/html;charset=UTF-8" language="java" %>
  - JSP문서라는 뜻이다. JSP 문서는 이렇게 시작
 

회원 등록 폼 JSP

```
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<title>Title</title>
</head>
<body>

<form action="/jsp/members/save.jsp" method="post">
	username: <input type="text" name="username" />
	age: <input type="text" name="age" />
	<button type="submit">전송</button>
</form>
</body>
```

회원 조회 JSP 
```
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="servlet.domain.member.Member" %>
<%@ page import="servlet.domain.member.MemberRepository" %>
<%
  //request, response 사용 가능
  MemberRepository memberRepository = MemberRepository.getInstance();

  System.out.println("MemberSaveServlet.service");

  // 요청 파라미터에서 username과 age를 가져와 변수에 저장
  String username = request.getParameter("username");
  int age = Integer.parseInt(request.getParameter("age"));

  //비즈니스 로직
  Member member = new Member(username, age);
  memberRepository.save(member);
%>

```

```
<ul>
    <li>id=<%=member.getId()%></li>
    <li>username=<%=member.getUsername()%></li>
    <li>age=<%=member.getAge()%></li>
</ul>

```

* <%@ page import="servlet.domain.member.MemberRepository" %>
  * 자바의 import 문서와 같다.
* <% ~~ %>
  * 자바 코드를 입력할 수 있다.
* <%= ~~ %>
  * 자바 코드를 출력할 수 있다. 

## 서블릿과 JSP의 한계
- 서블릿으로 개발할때 뷰 화면을 위한 HTML을 만드는 작업을 자바 코드에 섞여서 난잡했는데 JSP를 사용해서 뷰를 생성하는 HTML 작업을 깔끔하게 하고 중간에 동적으로 필요한 부분만 자바 코드를 사용해 적용했다.
- 그런데 JSP를 보면 뷰 영역과 자바코드, 리포지토리 등 한 파일에 너무 많은 역할이 있다. 이러면 유지보수가 힘들다. 

#### 

## MVC 패턴 - 개요
- 너무 많은 역할 
- 하나의 서블릿, JSP만으로 비즈니스 로직과 뷰 렌더링까지 모두 처리하게되면 너무 많은 역할을 하게되고 유지보수가 어려워진다. 비즈니스 로직이나 UI변경을 할때마다 파일을 수정해야한다. 

#### 변경의 라이프 사이클
- 비즈니스 로직과 뷰 관련을 수정하는 일이 각각 다르게 발생할 가능성이 높다. 변경 라이프 사이클이 다른 부분을 하나의 코드로 관리하는건 유지보수하기 쉽지 않다. 

### Model View Controller
- 컨트롤러 : HTTP 요청을 받아 파라미터를 검증하고 비즈니스 로직을 실행하고 결과 데이터를 Model에 담고 View에 전달한다. 
- 모델 : 뷰에 출력할 데이터를 담아둔다. 뷰가 필요한 데이터를 모두 Model에 담아 전달해주기 때문에 뷰는 비즈니스 로직이나 데이터 접근을 몰라도 된다. 
- 뷰 : 모델에 담겨 있는 데이터를 사용해 화면에 출력한다. 여기가 HTML을 생성하는 부분

### MVC 패턴 이전
<img width="832" height="436" alt="image" src="https://github.com/user-attachments/assets/6ff3b1c2-90d3-4186-9adc-0ec49c254476" />

하나의 파일에 각각의 역할들이 다 포함되어 있다. 




### MVC 패턴
<img width="825" height="450" alt="image 2" src="https://github.com/user-attachments/assets/1626ec03-aeeb-4614-876f-12a249a537bb" />

각 파일들이 독립적으로 작동하고 유지보수가 쉽다. 

## MVC 패턴 - 적용
- 서블릿을 컨트롤러로 사용하고 뷰를 JSP로해서 MVC 패턴 적용하기
- Model은 HttpServletRequest 객체를 사용한다. request는 내부에 데이터 저장소를 가지고 있는데, request.setAttribute() ,request.getAttribute() 를 사용하면 데이터를 보관하고, 조회할 수 있다.
- request.setAttribute()는 HTTP 요청받은 데이터를 임시 저장해주는 메서드이고 request.getAttribute()는 임시 저장된 데이터를 꺼낸다. JSP에서 request.getAttribute()로 꺼내 화면에 출력한다. 
- Controller(서블릿) -> Model(request.setAttribute())->View(JSP) 구조이다. 

#### 회원 등록 폼 - 컨트롤러 

```
@WebServlet(name = "mvcMemberFormServlet", urlPatterns = "/servlet-mvc/members/new-form")
public class MvcMemberFormServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String viewPath = "/WEB-INF/views/new-form.jsp";
        //컨트롤러에서 뷰로 이동할때 
        RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath);
        //서블릿에서 jsp 호출
        //서버 내부에서 컨트롤러에서 모델에 데이터를 전달하거나 view에게 전달하든지 내부에서 일어나서 클라이언트는 모른다.
        dispatcher.forward(request,response);
        
    }
}
```
* request.getRequestDispatcher() : JSP 경로에 보낼 수 있는 객체 생성
* dispatcher.forward() :  다른 서블릿이나 JSP로 이동할 수 있다. 서버 내부에서 다시 호출한다. 
* JSP 경로에 보낼 수 있는 객체를 만들고 forward()를 통해 이동한다. 
* dispatcher.forward(request,response)의미 
  * request (요청 객체)
    * 역할: 클라이언트의 요청 정보 + Controller에서 저장한 데이터를 전달
    * JSP가 setAttribute()로 저장된 데이터를 getAttribute()로 꺼낼 수 있도록 함
  - ⠀response (응답 객체)
    * 역할: JSP가 HTML을 작성해서 클라이언트에게 응답할 수 있도록 함
    * JSP가 out.write()나 response.getWriter()로 HTML을 작성
* redirect vs forward 차이
  * redirect
    * 클라이언트에 응답이 나갔다 클라이언트가 redirect경로로 다시 요청한다. 클라이언트도 이 과정을 인지할 수 있고 URL 경로도 실제 변경된다.
  * forward
    * 서버 내부에서 요청을 다른 리소스로 넘긴다. 클라이언트는 이 과정을 알 수가 없다. 
      * 예를 들어 Controller에서 JSP로 forward하면, 브라우저는 Controller URL을 계속 본다. 
      * 왜냐하면 서버 내부에서만 이동하기 때문이다.그리고 forward할 때 request에 setAttribute로 저장한 데이터가 그대로 JSP로 전달된다.

#### 회원 등록 뷰
```
<!-- 상대경로 사용, [현재 URL이 속한 계층 경로 + /save] -->
<form action="save" method="post">
  username: <input type="text" name="username" />
  age: <input type="text" name="age" />
  <button type="submit">전송</button>
```

action을 보면 절대 경로(/로 시작)가 아니라 상대 경로(/로 시작x)인 것을 확인할 수 있다. 상대경로로 하면 폼 전송시 현재URL이 속한 계층 경로에 + save가 호출
* 현재 계층 경로: /servlet-mvc/members/
* 결과 : /servlet-mvc/members/save 

## MVC패턴 - 한계
- MVC 패턴을 적용한 덕분에 컨트롤러, 뷰 역할을 구분할 수 있다. 뷰는 뷰 역할만 있으니 코드도 뷰 관련 코드만 있다.
- MVC패턴을 이용해 모델에서 데이터를 꺼내 화면만 만들면 된다. 
- 하지만 컨트롤러의 중복이 많고 필요없는 코드도 많다. 

#### MVC 컨트롤러의 단점

포워드 중복
View로 이동하는 코드가 중복 호출되어야 한다. 해당 메서드도 항상 직접 호출해야 한다. 
```
RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath);
dispatcher.forward(request, response);
```

viewPath 중복
```
String viewPath = "/WEB-INF/views/new-form.jsp";
```

공통 처리의 문제
기능이 복잡해지면 컨트롤러에서 공통으로 처리해야 하는 부분이 증가한다. 공통 기능을 메서드로 만들어도 해당 메서드를 항상 호출해야하고 호출하지 않을 경우 문제가 될 수 있다. 그리고 호출 자체도 중복이다.

# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1/dashboard?cid=326674
