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
<script src="/inc/js/member/register.js"></script>
<script src="/inc/js/sh.js"></script>
<body>
<h1>HanKook PG</h1>
<div>
    <h2>임시 회원 가입</h2>
    <form method="post">
        <p>ID : <input type="text" name = "memId"></p>
        <p>PW : <input type="password" name = "memPwd"></p>
        <p>이름 : <input type="text" name = "memName"></p>
        <p>휴대폰번호 : <input type="text" name = "memPhone"></p>
        <p>이메일 : <input type="email" name = "memEmail"></p>
        <p> <button type="button" onclick="register()" id="registerBtn">회원가입</button></p>
    </form>
</div>
</body>
</html>
