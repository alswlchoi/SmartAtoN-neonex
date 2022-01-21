<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="sec"
          uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>HanKook PG</title>
</head>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<body>
    <h1>페이지에 들어갈 권한이 없습니다.</h1>
    <h2><%= request.getParameter("exception")%></h2>
</body>
</html>
