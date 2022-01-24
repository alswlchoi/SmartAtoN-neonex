<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib prefix="sec"
		  uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<sec:csrfMetaTags/>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="/inc/js/sh.js"></script>
<title>메뉴관리</title>
</head>
<script type="text/javascript">
$(document).ready(function(){
	//조회버튼
	$("#searchBtn").on("click",function(){
		search();
	});
	//매핑 수정 버튼
	$(".updBtn").on("click",function(){
		var authCode = $(this).attr("data-authcode");
		var chkArr = new Array();
		$("."+authCode+":checked").each(function(i){
			chkArr.push($(this).val());
		});
		alert(chkArr);

		var param = {
				authCode:authCode,
				chkArr:chkArr
		}
		postAjax("/system/menu/update",param,"callbackFunction",null,null,null);
	});

})
//조회
function search(){
	var param = {
			authCode:$("#searchKeyword").val(),
			authNm:$("#searchKeyword").val()
	}
	postAjax("/system/menu/search",param,"searchCallback",null,null,null);
}
//조회콜백
function searchCallback(list){
	$("#list").html("");
	var html ='';
	$.each(list,function(i,el){
		html += list[i].authCode + " / ";
		html += list[i].menuCode + " / ";
		html += list[i].mname + " / ";
		html += list[i].mparent + " / ";
		html += list[i].murl;
		html += " <br/> ";
	})
	$("#list").html(html);
}
//등록콜백
function callbackFunction(data){
	if(data>0){
		alert("성 공!");
		search();
	}else{
		alert("실 패!");
	}
}
</script>
<body>
<button id="searchBtn">메뉴조회</button>
<div id="list">

</div>
------------------------------------------------------------------------<br>
	<c:forEach var="a" items="${authList}">
		${a.authCode} / ${a.authNm}
		<button class="updBtn" data-authcode="${a.authCode}">수정</button>
			<br/>
			<c:forEach var="m" items="${menuList}">
				<input type="checkbox" value="${m.menuCode}" class="${a.authCode}" name="${a.authCode}-${m.menuCode}">
				<label for="${a.authCode}-${m.menuCode}">${m.MName}</label>
			</c:forEach>
		<br/>
	</c:forEach>
------------------------------------------------------------------------
</body>
</html>