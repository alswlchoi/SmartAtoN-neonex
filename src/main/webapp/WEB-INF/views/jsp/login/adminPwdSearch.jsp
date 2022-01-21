<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<%@taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
    <sec:csrfMetaTags/>
<script src="/inc/js/login/adminLogin.js"></script>
<script type="text/javascript">
$(function(){
<%if(authentication.getPrincipal() instanceof String){%>

<%}else{ %>
	location.href="/adminLogout";
<%}	%>
	$("#okBtn").click(function(){
		var data ={
			memId : $("#memId").val().trim(),
			memName : $("#memName").val().trim()
		};
		postAjax("/member/adminPwdSearch/modify",data,"successModiPwd",null,null,null);
	});

})
function successModiPwd(data){
	if(data.result == "OK"){
		alert("등록된 이메일 주소로<br>임시비밀번호가 발급되었습니다.<br/>이메일을 확인해 주시기 바랍니다.");
		$(".lyClose").click(function(){
			location.href="/adminLogin";
		})
	}else if(data.result == "NO"){
		alert("해당 정보를 찾을 수 없습니다.<br>다시 한 번 정보를 확인해 주시기 바랍니다.");
	}else{
		alert("오류! 시스템관리자에게 문의해 주세요.");
	}
}
</script>
<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>비밀번호 찾기</span></div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">비밀번호 찾기</h2>
        <!-- //title -->
        <!-- find_wrap -->
        <div class="find_wrap m-t-50">
            <p>관리자시스템에 등록된 이메일로<br />임시비밀번호가 발송됩니다.</p>
            <div class="form_group w500 m-t-50">
                <input type="text" id="memId" class="form_control_lg" placeholder="아이디(사번)을 입력하세요" name="" maxlength="100"/>
                <input type="text" id="memName" class="form_control_lg m-t-10" placeholder="이름을 입력하세요" name="" maxlength="100"/>
            </div>
            <!-- button -->
            <section class="tac m-t-50">
                <button type="button" class="btn-b btn_default" id="okBtn">확인</button>
            </section>
            <!-- //button -->
        </div>
        <!-- //find_wrap -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>