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
<title>권한관리</title>
</head>
<script type="text/javascript">
$(document).ready(function(){
	//등록버튼
	$("#insertBtn").on("click",function(){
		insertAuth();
	});
	//조회버튼
	$("#searchBtn").on("click",function(){
		search();
	});
	//조회 엔터키 처리
	$("#searchKeyword").focus(function(){
		$(this).keydown(function(k){
			if(k.keyCode == 13){
				search();
			}
		});
	});
})

//삭제
function del(authCode){
	var param = {
			authCode:authCode
	}
	console.log(param);
	postAjax("/system/auth/del",param,"insertCallback",null,null,null);
}
//수정
function upd(authCode,el){
	var param = {
			authCode:authCode,
			authNm:$(el).siblings(".authN").val(),
			authOrder:$(el).siblings(".authO").val()
	}
	console.log(param);
	postAjax("/system/auth/upd",param,"insertCallback",null,null,null);
}
//등록
function insertAuth(){
	var param = {
			authCode:$("#authCode").val(),
			authNm:$("#authName").val(),
			authOrder:$("#authOrder").val()
	}
	postAjax("/system/auth/insert",param,"insertCallback",null,null,null);
}
//등록콜백
function insertCallback(data){
	if(data>0){
		alert("성 공!");
		search();
	}else{
		alert("실 패!");
	}
}
//조회
function search(){
	var param = {
			authCode:$("#searchKeyword").val(),
			authNm:$("#searchKeyword").val()
	}
	postAjax("/system/auth/search",param,"searchCallback",null,null,null);
}
//조회콜백
function searchCallback(list){
	$("#authList").html("");
	var html ='';
	$.each(list,function(i,el){
		html += "<li>";
		html += list[i].authCode;
		html += '<input type="text" class="authN" value="'+list[i].authNm+'">';
		html += '<input type="text" class="authO" value="'+list[i].authOrder+'">';
		html += '<button class="updBtn" data-opt="'+list[i].authCode+'">수정</button>';
		html += '<button class="delBtn" data-opt="'+list[i].authCode+'">삭제</button>';
		html += "</li>";
	})
	$("#authList").html(html);

	//수정버튼
	$(".updBtn").on('click',function(){
		upd($(this).attr("data-opt"),$(this));
	});
	//삭제버튼
	$(".delBtn").on('click',function(){
		del($(this).attr("data-opt"));
	});
}
</script>
<body>
	권한 관리
	<br>
	<br>
	<br>
	권한등록
	<input type="text" id="authCode" value="" placeholder="authCode">
	<input type="text" id="authName" value="" placeholder="authName">
	<input type="number" id="authOrder" value="" placeholder="authOrder">
	<button id="insertBtn">등록버튼</button>
	<br>
	<br>
	<br>

	<input type="text" id="searchKeyword" value="" placeholder="미정">
	<button id="searchBtn">권한조회</button>
	<div>
		<ul id="authList">
		</ul>
	</div>


</body>
</html>