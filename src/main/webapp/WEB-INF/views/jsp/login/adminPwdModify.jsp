<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<%@taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
    <sec:csrfMetaTags/>
<script src="/inc/js/login/adminLogin.js"></script>
<script type="text/javascript">
$(function(){
	var memId = "<%=memberDto.getMemId()%>";
	$("#okBtn").click(function(){
		if($("#newPwdChk").val().length==0){
			alert("비밀번호 확인을 입력해 주세요.");
			return;
		}
		if($("#newPwd").val() != $("#newPwdChk").val()){
			alert("비밀번호를 확인해 주세요.");
			return;
		}
		var regPwd = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$/;
		if(!regPwd.test($("#newPwd").val())){//비밀번호는 공백도 한칸 차지이므로 trim 제거
			alert("비밀번호는 8~16자 영문자,숫자 및 특수문자 조합으로 입력해주세요.");
			$("#newPwd").focus();
			return;
		}
		var data ={
				newPwd : $("#newPwd").val()
			};
			postAjax("/user/adminPwdModify/modiPwd",data,"successModiPwd",null,null,null);
	});
})
function successModiPwd(data){
	if(data.result == "OK"){
		alert("비밀번호 변경이 완료 되었습니다.<br>로그인 화면으로 이동합니다.");
		$(".lyClose").click(function(){
			location.href="/adminLogout";
		})
	}else{
		alert("오류발생 시스템 관리자에게 문의해 주세요.");
	}
}
</script>
<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>비밀번호 재설정</span></div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">비밀번호 재설정</h2>
        <!-- //title -->
        <!-- find_wrap -->
        <div class="find_wrap m-t-50">
            <p>비밀번호를 재설정 해 주시기 바랍니다.</p>
            <div class="m-t-50"><span class="info_ment">8~16자 영문자, 숫자 및 특수문자 조합하여 입력</span></div>
            <div class="form_group w500 m-t-8">
                <input type="password" id="newPwd" class="form_control_lg" placeholder="비밀번호를 입력하세요" name="" autocomplete="new-password" maxlength="16"/>
                <input type="password" id="newPwdChk" class="form_control_lg m-t-10" placeholder="비밀번호를 다시 입력하세요"
                    name="" autocomplete="new-password" maxlength="16"/>
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