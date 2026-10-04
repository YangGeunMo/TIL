# 스프링 MVC 전체 구조

### 직접 만든 MVC 프레임워크 구조
<img width="793" height="405" alt="스크린샷 2026-10-04 오후 3 03 17" src="https://github.com/user-attachments/assets/d99d3246-bcf6-4fc1-9368-68f846300dc3" />

### SpringMVC 구조
<img width="765" height="362" alt="스크린샷 2026-10-04 오후 3 04 52" src="https://github.com/user-attachments/assets/7efeb2d4-4437-47c7-8659-2695b0803d6b" />

* 직접 만들어본 MVC 프레임워크 구조와 SpringMVC 구조가 매우 비슷하다. 
* 스프링 MVC도 프론트 컨트롤러 패턴으로 구현되어 있다.
* 스프링 MVC의 프론트 컨트롤러가 Dispatcher Servlet이다.
* Dispatch Servlet이 스프링 MVC에서 핵심이다.

#### DispatcherServlet 서블릿 등록
* DispatchServlet도 HttpServlet을 상속받고 서블릿으로 동작한다.

#### 상속 관계

```text
HttpServlet (서블릿 기본)
    ↑
HttpServletBean (서블릿 초기화)
    ↑
FrameworkServlet (프레임워크 지원)
    ↑
DispatcherServlet (요청 분배)

```

* 스프링 부트는 DispatchServlet을 서블릿으로 자동 등록하고 모든 경로(`urlPatterns="/"` )에 대해 매핑한다.


```text
// 스프링 부트가 자동으로 한다.
@WebServlet(name = "dispatcherServlet", urlPatterns = "/")
public class DispatcherServlet extends FrameworkServlet {
    // 모든 경로(/)의 요청을 처리
}

// 직접 했던 것과 동일
@WebServlet(name = "fronControllerServletV5", urlPatterns = "/front-controller/v5/*")
public class FronControllerServletV5 extends HttpServlet {
    // /front-controller/v5/* 경로만 처리
}
```

* 경로가 더 자세할 수록  우선순위가 높다.
요청: /members/save

매핑된 서블릿:
1. / (DispatcherServlet)
2. /members/* (MemberServlet)  ← 더 자세한 경로 우선이 된다. 

결과:
→ /members/* 가 우선 처리됨
→ DispatcherServlet은 나머지를 처리

## DispatcherServlet 요청 흐름
```
HTTP 요청
    ↓
서블릿 컨테이너가 service() 호출
    ↓
HttpServlet.service() 
    ↓
FrameworkServlet.service() (오버라이드됨)
    ↓
여러 메서드 호출한다,
    ↓
DispatcherServlet.doDispatch()  ← 핵심
    ↓
요청 처리 시작
```

* 서블릿이 호출되면서 HttpServlet에서 제공하는 service()가 호출된다.
* 스프링 MVC는 DispatchServlet 부모인 FrameworkServlet에서 service()를 오버라이딩 했다.
* FrameworkServlet. service()를 시작으로 여러 메서드들이 호출되면서 DispatcherServlet.doDispatch()가 호출된다. 

## 직접 만든 MVC 프레임워크 VS 스프링 MVC

### 직접 만든 MVC 프레임워크
```java
@WebServlet(name = "fronControllerServletV5", urlPatterns = "/front-controller/v5/*")
public class FronControllerServletV5 extends HttpServlet {
    
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) {
        // 1. 핸들러 조회
        // 2. 어댑터 조회
        // 3. handle() 호출
        // ... 처리 로직
    }
}
```

### 스프링 MVC
```java
public class FrameworkServlet extends HttpServletBean {
    
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) {
        // FrameworkServlet에서 오버라이드
        doDispatch(request, response);  // DispatcherServlet의 메서드 호출
    }
}

protected void doDispatch(HttpServletRequest request, HttpServletResponse response) throws Exception {
    HttpServletRequest processedRequest = request;
    HandlerExecutionChain mappedHandler = null;
    ModelAndView mv = null;

    // 1. 핸들러 조회
    mappedHandler = getHandler(processedRequest);
    if (mappedHandler == null) {
        noHandlerFound(processedRequest, response);
        return;
    }

    // 2. 핸들러 어댑터 조회 - 핸들러를 처리할 수 있는 어댑터
    HandlerAdapter ha = getHandlerAdapter(mappedHandler.getHandler());

    // 3. 핸들러 어댑터 실행
    // 4. 핸들러 어댑터를 통해 핸들러 실행
    // 5. ModelAndView 반환
    mv = ha.handle(processedRequest, response, mappedHandler.getHandler());

    // 6-8. 뷰 렌더링 처리
    processDispatchResult(processedRequest, response, mappedHandler, mv, dispatchException);
}

private void processDispatchResult(HttpServletRequest request, 
                                   HttpServletResponse response, 
                                   HandlerExecutionChain mappedHandler, 
                                   ModelAndView mv, 
                                   Exception exception) throws Exception {
    // 뷰 렌더링 호출
    render(mv, request, response);
}

protected void render(ModelAndView mv, 
                      HttpServletRequest request, 
                      HttpServletResponse response) throws Exception {
    View view;
    String viewName = mv.getViewName();

    // 6. 뷰 리졸버를 통해서 뷰 찾기
    // 7. View 반환
    view = resolveViewName(viewName, mv.getModelInternal(), locale, request);

    // 8. 뷰 렌더링
    view.render(mv.getModelInternal(), request, response);
}
```

#### 비교
```
// 1. 핸들러 조회
Object handler = getHandler(request);

// 2. 핸들러 어댑터 조회
MyHandlerAdapter adapter = getHandlerAdapter(handler);

// 3-5. 어댑터 실행 → 핸들러 실행 → ModelView 반환
ModelView mv = adapter.handle(request, response, handler);

// 6-7. 뷰 리졸버 호출
MyView view = viewResolver(mv.getViewName());

// 8. 뷰 렌더링
view.render(mv.getModel(), request, response);
```

스프링 MVC의 doDispatch와 직접 만들어본 프레임워크의 기능이나 구조가 거의 똑같다.   

## 스프링 MVC의 동작 흐름

<img width="765" height="362" alt="스크린샷 2026-10-04 오후 3 04 52" src="https://github.com/user-attachments/assets/7efeb2d4-4437-47c7-8659-2695b0803d6b" />

1. 핸들러 조회 : 핸들러 매핑을 통해 URL에 매핑된 핸들러(컨트롤러)가 있는지 조회한다.
2. 어댑터 조회 : 매핑된 핸들러를 실행할 수 있는 어댑터가 있는지 조회한다. (핸들러의 타입과 어댑터의 타입이 같은지 확인해서 조회한다)
3. 핸들러 어댑터 실행 : 요청받은 데이터를 기준으로 핸들러 어댑터를 실행한다. 
4. 핸들러 실행: 핸들러 어댑터가 실제 핸들러(컨트롤러)를 호출하여 작업한다.
5. ModelAndView 반환 : 핸들러에서 작업이 끝나고 핸드럴 어댑터를 통해 ModelAndView로 변환해서 논리뷰를 반환한다.
6. viewResolver 호출: viewResolver를 찾아 호출한다.
7. View반환 : viewResolver 반환값을 논리 뷰에서 물리 뷰로 바꾸고 렌더링을 담당하는 View 객체로 반환한다.
8. render 호출 : 데이터를 저장한 model과 요청받은 정보, 응답할 객체를 가지고 렌더링을 한다. 

## 정리

스프링 MVC는 코드 분량도 매우 많고, 복잡해서 내부 구조를 다 파악하는 것은 쉽지 않다. 그래도 핵심 동작방식을 알아두어야 향후 문제가 발생했을 때 어떤 부분에서 문제가 발생했는지 쉽게 파악하고, 문제를 해결할 수 있다. 
그리고 확장 포인트가 필요할 때, 어떤 부분을 확장해야 할지 감을 잡을 수 있다. 지금까지 작성한 MVC 프레임워크와 유사한 구조여서 이해하는데 어렵지는 않았다. 

# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1?cid=326674
