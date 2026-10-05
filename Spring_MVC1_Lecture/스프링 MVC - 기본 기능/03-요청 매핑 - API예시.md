# 요청 매핑 - API 예시
- 회원 관리를 HTTP API로 만드나 생각하고 매핑을 어떻게하는지 알아본다.
- 실제 데이터를 넘기는게 아닌 URL 매핑만 해본다.


## 회원 관리 API
- 회원 목록 조회 : GET /users
- 회원 등록 : POST /users
- 회원 조회 : GET /users/{userId}
- 회원 수정 : PATCH /users/{userId}
- 회원 삭제 : DELETE /users/{userId}


~~~java
@RequestMapping("/mapping/users")
public class MappingClassController {
~~~
- 클래스 레벨에 매핑 정보를 두면 메서드 레벨의 정보를 조합해서 사용한다.

~~~java
//GET 요청 /mapping/users
    @GetMapping
    public String user() {
        return "get users";
    }

    
    //POST 요청 /mapping/users
    @PostMapping
    public String addUser() {
        return "post user";
    }

    //GET 요청 /mapping/users/{userId}
    @GetMapping("/{userId}")
    public String findUser(@PathVariable String userId) {
        return "get UserId= " + userId;
    }
    //PATCH 요청 /mapping/users/{userId}
    @PatchMapping("/{userId}")
    public String updateUser(@PathVariable String userId) {
        return "update UserId= " + userId;
    }

    //DELETE 요청 /mapping/users/{userId}
    @DeleteMapping("/{userId}")
    public String deleteUser(@PathVariable String userId) {
        return "delete UserId= " + userId;
    }
~~~

# 출처
스프링 MVC 1편 - 백엔드 웹 개발 핵심 기술
- https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-mvc-1/dashboard?cid=326674
