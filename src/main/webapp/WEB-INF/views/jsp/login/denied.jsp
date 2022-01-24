<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="sec"
          uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>::: [한국타이어] Technoring :::</title>
    <link rel="stylesheet" type="text/css" href="/inc/css/default.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/common.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/font.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/layout.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/daterangepicker.css"><!-- daterangepicker style -->
    <link rel="stylesheet" type="text/css" href="/inc/css/jquery-ui.css"><!-- jquery-ui style -->

    <!-- 스크립트 -->
    <script type="text/javascript" src="/inc/js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="/inc/js/navi.js"></script> <!-- navigation -->
    <script type="text/javascript" src="/inc/js/common.js"></script>
    <script type="text/javascript" src="/inc/js/moment.min.js"></script> <!-- daterangepicker -->
    <script type="text/javascript" src="/inc/js/daterangepicker.js"></script> <!-- daterangepicker -->
    <script type="text/javascript" src="/inc/js/jquery-ui.js"></script> <!-- jquery-ui -->

    <!-- 공통 추가 -->
	<script src="/inc/js/sh.js"></script>
</head>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
$(function(){
	alert('<%= request.getParameter("exception")%>');
	$(".lyClose").click(function(){
		location.href="/adminLogin";
	})
})
</script>
<body>

    <!-- 알럿 공통 -->
<button type="button" data-layer="alert_pop" style="display:none;"></button>
<div class="ly_group">
    <article class="layer_Alert alert_pop">
        <!-- # 타이틀 # -->
<!--        <h1>알림</h1> -->
       <div class="ly_con" id="alertMessage">
       </div>
       <!-- 버튼 -->
       <div class="wrap_btn01">
           <button type="button" class="btn-pop btn_default lyClose">확인</button>
       </div>
       <!-- # 닫기버튼 # -->
       <button data-fn="lyClose">레이어닫기</button>
       <!-- # 컨텐츠 # -->
    </article>
</div>
<!-- //알럿 공통 -->
</body>
</html>
