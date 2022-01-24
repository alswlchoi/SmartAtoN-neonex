<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<%@taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
    <sec:csrfMetaTags/>
<script src="/inc/js/login/login.js"></script>
<script type="text/javascript">
$(function(){
<%if(authentication.getPrincipal() instanceof String){%>
<%}else{ %>
	location.href="/logout";
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
       <!-- login -->
       <div class="login_wrap">
           <p>테크노링에 오신 것을 환영합니다!</p>
	           <form method="post">
		           <div class="form_group w500 m-t-45">
			               <input type="text" id="" class="form_control_lg" placeholder="아이디를 입력하세요" name="memId" value=""/>
			               <input type="password" id="" class="form_control_lg m-t-10" placeholder="비밀번호를 입력하세요" name="memPwd" value="" autocomplete="new-password"/>
		           </div>
		           <div class="form_group m-t-18">
		               <div class="check_inline">
		                   <label class="check_default">
		                       <input type="checkbox" name="cookie" value="check">
		                       <span class="check_icon"></span>아이디 저장</label>
		               </div>
		           </div>
           	</form>
           <!-- button -->
           <section class="tac m-t-30">
               <button type="button" class="btn-b btn_default w500" data-layer="alert_pass" onclick="login()" id="loginbtn">로그인</button>
           </section>
           <!-- //button -->
           <div class="btn_wrap m-t-40">
               <a href="/member/search?tab=1">아이디 찾기</a><a href="/member/search?tab=2">비밀번호 찾기</a><a href="/member/register">회원가입</a><a href="/member/approval">회원가입 심사결과조회</a>
           </div>
       </div>
       <!-- //login -->

   </div>
   <!-- //content -->
</div>
<!-- //container -->

<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>