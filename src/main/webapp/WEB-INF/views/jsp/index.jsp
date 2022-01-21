<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sec"
          uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>HanKook PG</title>
</head>
<body>
<h1>HanKook PG 임시 Welcome Page</h1>

<sec:authorize access="isAnonymous()">
    <a href="/login">로그인</a>
    <a href="/member/register">회원 가입</a>
</sec:authorize>

<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal.memName" var="user_name"/>
    <h3 id="user_name">안녕하세요 ${user_name} 님</h3>
    <a href="/logout">로그아웃</a>
</sec:authorize>


<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal.menuList" var="menu_list"/>
    <h3 >접속가능한 MENU 정보</h3>
    <c:forEach var="MenuDto" items="${menu_list}">
        <h5>${MenuDto.MUrl}, ${MenuDto.MName} , ${MenuDto.MParent}</h5>
    </c:forEach>
</sec:authorize>



</body>
</html>
