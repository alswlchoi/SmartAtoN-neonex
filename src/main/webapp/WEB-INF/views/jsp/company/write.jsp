<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<title>등록</title>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
$(function(){
	$("#submit").click(function(){
		var phoneCheck= RegExp(/^[0-9-+]{10,11}$/);
		
		if(!phoneCheck.test($("#compPhone").val())){
			 alert("휴대전화번호는 -를 제외한 숫자(8자리~11자리이하)만 입력 가능합니다.");  
			 $("#compPhone").focus(); 
			// return false; 
		}
		
		if(!phoneCheck.test($("#compTel").val())){
			 alert("전화번호는 -를 제외한 숫자(8자리~11자리이하)만 입력 가능합니다."); 
			 $("#compTel").focus(); 
			// return false; 
		}
	});
});
</script>
</head>
<body>
	<form name="frm" id="frm" method="post" action="/company/write" enctype="multipart/form-data">
	<table border="1">
        <tr>
            <th>License</th><td><input type="text" name="compLicense" id="compLicense" value="라이센스" /></td>
        </tr>
        <tr>
            <th>코드</th><td><input type="text" name="compCode" id=""compCode"" value="C002" /></td>
        </tr>
        <tr>
            <th>휴대전화번호</th><td><input type="text" name="compPhone" id="compPhone" value="01012345678" /></td>
        </tr>
        <tr>
            <th>전화번호</th><td><input type="text" name="compTel" id="compTel" value="0212345678" /></td>
        </tr>
        <tr>
            <th>등록자</th><td><input type="text" name="compRegUser" id="compRegUser" value="등록자" /></td>
        </tr>
    </table>
    
    <div>
    	<input type="submit" id="submit" value="등록" />&nbsp;<a href="/company">목록</a>
    </div>
    </form>
</body>
</html>