<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<%@taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
    <sec:csrfMetaTags/>
<script src="/inc/js/login/adminLogin.js"></script>
<script type="text/javascript">
$(function(){
<%if(authentication!=null && authentication.getPrincipal() instanceof String){%>

<%}else{ %>
	location.href="/adminLogout";
<%}	%>
	if(getCookie("userId")!=null && getCookie("userId")!=""){
		$("input[name=cookie]").prop("checked",true);
	}else{
		$("input[name=cookie]").prop("checked",false);
	}
	$("input[name='memId']").val(getCookie("userId"));
})
</script>
<!-- <body> -->
<!--     <h1>Login 임시 페이지</h1> -->
<!--     <form method="post"> -->
<!--         <p>ID : <input type="text" name = "memId" value="admin"></p> -->
<!--         <p>PW : <input type="password" name = "memPwd" value="12345"></p> -->
<!--         <p> <button type="button" onclick="login()" id="loginbtn">로그인</button></p> -->
<!--     </form> -->
<!-- </body> -->
<!-- </html> -->


<!-- container -->
<div id="container">
    <!-- visual -->
   <div class="visual_sub common"></div>
   <!-- //visual -->
   <!-- content -->
   <div class="content">
       <!-- breadcrumb -->
       <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>로그인</span></div>
       <!-- //breadcrumb -->
       <!-- title -->
       <h2 class="title">로그인</h2>
       <!-- //title -->
       <!-- //login -->
       <div class="login_wrap">
           <p>Main P/G 시험로 통합관제시스템</p>
           <div class="form_group w500 m-t-45">
               <input type="text" id="" class="form_control_lg" placeholder="아이디를 입력하세요" name="memId" value="admin" maxlength="12"/>
               <input type="password" id="" class="form_control_lg m-t-10" placeholder="비밀번호를 입력하세요" name="memPwd" value="" autocomplete="new-password"/>
           </div>
           <div class="form_group m-t-18 disb">
               <div class="check_inline">
                   <label class="check_default">
                       <input type="checkbox" name="cookie" value="">
                       <span class="check_icon"></span>아이디 저장</label>
               </div>
               <a href="/member/adminPwdSearch" class="find_pw">비밀번호 찾기</a>
           </div>
           <!-- button -->
           <section class="tac m-t-30">
               <button type="button" class="btn-b btn_default w500" data-layer="alert_pass" onclick="login()" id="loginbtn">로그인</button>
           </section>
           <!-- //button -->
       </div>
		<!-- //login -->
   </div>
   <!-- //content -->
</div>
<!-- //container -->

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>