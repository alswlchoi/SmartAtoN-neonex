<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<%@taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
    <sec:csrfMetaTags/>
<%@ page import="org.springframework.security.core.Authentication"%>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder"%>
<%@ page import="com.hankook.pg.content.member.dto.MemberDto"%>
<script type="text/javascript">
$(function(){
	var memId = "<%=memberDto.getMemId()%>";
	$("#okBtn").click(function(){
		if($("#nowPwd").val().length==0){
			alert("현재 비밀번호를 입력해 주세요.");
			return;
		}
		if($("#newPwd").val().length==0){
			alert("비밀번호를 입력해 주세요.");
			return;
		}
		var regPwd = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$/;
		if(!regPwd.test($("#newPwd").val())){//비밀번호는 공백도 한칸 차지이므로 trim 제거
			alert("비밀번호는 8~16자 영문자,숫자 및 특수문자 조합으로 입력해주세요.");
			$("#newPwd").focus();
			return;
		}
		if($("#newPwdChk").val().length==0){
			alert("비밀번호 확인을 입력해 주세요.");
			return;
		}
		if($("#newPwd").val() != $("#newPwdChk").val()){
			alert("비밀번호를 확인해 주세요.");
			return;
		}
		if($("#nowPwd").val() == $("#newPwd").val()){
			alert("현재 비밀번호와 동일한 비밀번호로 바꿀 수 없습니다.");
			return;
		}
		var data ={
				memPwd : $("#nowPwd").val(),
				newPwd : $("#newPwd").val()
			};
			postAjax("/user/modifyPwd/modiPwd",data,"successModiPwd",null,null,null);
	});
})
function pageMove(str){
	if(str=='tab1'){
		location.href = '/user/modify';
	}else if(str == 'tab2'){
		location.href = '/user/modifyPwd';
	}else if(str == 'tab3'){
		location.href = '/user/driver';
	}
}
function successModiPwd(data){
	if(data.result == "FAIL"){
		alert("현재 비밀번호가 올바르지 않습니다.");
	}else if(data.result == "OK"){
		alert("변경완료 되었습니다.");
		$(".lyClose").click(function(){
			location.href="/logout";
		})
	}else{
		alert("오류");
	}
}
</script>
<!-- container -->
<div id="container">
    <!-- visual -->
    <div class="visual_sub mypage"></div>
    <!-- //visual -->
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>마이페이지</span><span>회원정보</span></div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">회원정보</h2>
        <!-- //title -->
        <!-- tab -->
        <div class="wrap_tab w1200">
            <div class="tab">
                <button class="tablinks" onclick="pageMove('tab1')">회원정보 변경</button>
                <button class="tablinks active" onclick="pageMove('tab2')">비밀번호 변경</button>
                <button class="tablinks" onclick="pageMove('tab3')">운전자 정보 관리</button>
            </div>
            <div class="wrap_tabcontent">
                <!-- tab2 -->
                <div id="tab2" class="tabcontent">
                    <!-- table_view -->
                    <div class="tbl_wrap_view m-t-20">
                        <table class="tbl_view01" summary="테이블입니다.">
                            <caption>테이블입니다.</caption>
                            <colgroup>
                                <col width="180px;" />
                                <col width="" />
                            </colgroup>
                            <tr>
                                <th scope="row">아이디</th>
                                <td><%=memberDto.getMemId() %></td>
                            </tr>
                            <tr>
                                <th scope="row">현재 비밀번호<span class="required"></span></th>
                                <td>
                                    <div class="form_group w300">
                                        <input type="password" id="nowPwd" class="form_control"
                                            placeholder="현재 비밀번호 입력" name="" autocomplete="new-password" maxlength="16"/>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">비밀번호<span class="required"></span></th>
                                <td>
                                    <div class="form_group w300">
                                        <input type="password" id="newPwd" class="form_control" placeholder="비밀번호 입력"
                                            name="" autocomplete="new-password" maxlength="16"/>
                                    </div>
                                    <span class="info_ment">8~16자 영문자, 숫자 및 특수문자 조합하여 입력</span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">비밀번호 확인<span class="required"></span></th>
                                <td>
                                    <div class="form_group w300">
                                        <input type="password" id="newPwdChk" class="form_control"
                                            placeholder="비밀번호 다시 입력" name="" autocomplete="new-password" maxlength="16"/>
                                    </div>
                                    <span class="info_ment">8~16자 영문자, 숫자 및 특수문자 조합하여 입력</span>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_view -->
                    <!-- button -->
                    <section class="tac m-t-50">
<!--                         <button type="button" class="btn btn_gray m-r-11" data-layer="cancel">취소</button> -->
                        <button type="button" class="btn btn_default" id="okBtn">확인</button>
                    </section>
                    <!-- //button -->
                </div>
                <!-- //tab2 -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>