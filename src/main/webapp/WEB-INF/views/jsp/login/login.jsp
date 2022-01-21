<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="sec"
          uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <sec:csrfMetaTags/>
    <title>HanKook PG</title>
</head>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="/inc/js/login/login.js"></script>
<script src="/inc/js/sh.js"></script>
<body>
    <h1>Login 임시 페이지</h1>
    <form method="post">
        <p>ID : <input type="text" name = "memId"></p>
        <p>PW : <input type="password" name = "memPwd"></p>
        <p> <button type="button" onclick="login()" id="loginbtn">로그인</button></p>
    </form>
</body>
</html>
