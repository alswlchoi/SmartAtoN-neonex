<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(function(){
// 	alert("${memId}");

	$("#memPurpose").on("keyup",function(){
		if($(this).val().length>500){
			$(this).val($(this).val().substring(0,500));
		}
		$("#memPurposeCnt").text($(this).val().length);
	});
	$("#memId").change(function(){
		$("#dueYn").prop("checked",false);
		$("#dueChk").css("color","#333");//#333 #ec6608
	});
	$("#memId").on("keyup",function(){
		$("#dueYn").prop("checked",false);
		$("#dueChk").css("color","#333");//#333 #ec6608
// 		var regId = /^[0-9]{5}$/;
// 		if(!regId.test($("#memId").val().trim())){
// 		}else{
// 		}
	});
	//페이지 중복확인
	$("#dueChk").click(function(){
		if($("#memId").val().trim().length==0){
			alert("사번을 입력해주세요.");
			$("#memId").focus();
			return;
		}
// 		var regId = /^[0-9]{5}$/;
		var regId = /^[A-Za-z0-9]{5,12}$/;
		if(!regId.test($("#memId").val().trim())){
			alert("올바른 사번을 입력해 주세요.");
			return;
		}

		var param = {memId :$("#memId").val().trim()}
		postAjax("/member/idDueChk",param,"successDueChk",null,null,null);
	});
})
//중복체크 callback
function successDueChk(data){
	console.log(data);
	if(data.cnt>0){
		alert("이미 사용중인 ID(사번) 입니다.");
		$("#dueYn").prop("checked",false);
		$("#dueChk").css("color","#333");//#333 #ec6608
		return;
	}else{
		alert("사용가능한 ID(사번) 입니다.");
		$("#dueYn").prop("checked",true);
		$("#dueChk").css("color","#ec6608");//#333 #ec6608
		return;
	}
}
function backBtn(){
	location.href="/member/adminManagement";
}
function cancel(){
	confirm("취소하시면 처음부터 다시 진행해야 됩니다.<br/>취소하시겠습니까?",successConfirm,cancelConfirm);
}
//취소 후 확인
function successConfirm(data){
	location.href="/member/adminManagement";
}
//취소 후 취소
function cancelConfirm(data){
	$(".lyClose").click();
}
function register(){
	if($("#memId").val().trim().length==0){
		alert("아이디를 입력해 주세요.");
		$("#memId").focus();
		return;
	}
	var regId = /^[A-Za-z0-9]{5,12}$/;
// 	var regId = /^[0-9]{5}$/;
	if(!regId.test($("#memId").val().trim())){
		alert("올바른 ID를 입력해 주세요.");
		$("#memId").focus();
		return;
	}
	if(!$("#dueYn").prop("checked")){
		alert("아이디 중복확인을 해주세요.");
		return;
	}
	if($("#memName").val().trim().length==0){
		alert("이름을 입력해 주세요.");
		$("#memName").focus();
		return;
	}
	if($("#memDept").val().trim().length==0){
		alert("부서명을 입력해 주세요.");
		$("#memDept").focus();
		return;
	}
	if($("#memEmail").val().trim().length==0){
		alert("이메일 주소를 입력해 주세요.");
		$("#memEmail").focus();
		return;
	}
	var regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	if(!regEmail.test($("#memEmail").val().trim())){
		alert("이메일 형식에 맞지 않습니다.");
		$("#memEmail").focus();
		return;
	}
	if($("#memPhone").val().trim().length==0){
		alert("핸드폰번호를 입력해 주세요.");
		$("#memPhone").focus();
		return;
	}
	var regMemPhone = /^01(?:0|1|[6-9])(?:\d{3}|\d{4})\d{4}$/;
	if(!regMemPhone.test($("#memPhone").val().trim())){
		alert("형식에 맞지 않는 번호 입니다.");
		$("#memPhone").focus();
		return;
	}
	if($("#memPurpose").val().length==0){
		alert("메모를 입력해 주세요.");
		$("#memPurpose").focus();
		return;
	}
	 var data = {
		authCode : $("#authCode").val(),
		memId : $("#memId").val().trim(),
		memName : $("#memName").val().trim(),
		memDept : $("#memDept").val().trim(),
		memEmail : $("#memEmail").val().trim(),
		memPhone : $("#memPhone").val().trim(),
		memUseYn : $("input[name='memUseYn']:checked").val(),
		kakaoSmsYn : $("input[name='kakaoSmsYn']:checked").val(),
		memPurpose : $("#memPurpose").val()
		};
	console.log("param",data)
	postAjax("/member/adminRegister/join",data,"successRegister","failRegister",null,null);
}
function successRegister(data) {
	if(data.result == "OK") {
		alert("등록이 완료되었습니다.");
		$(".lyClose").click(function(){
			location.href="/member/adminManagement";
		})
	}else {
		alert("회원 가입 간 에러 발생");
	}
}
//등록 실패 callback
function failRegister(xhr) {
	alert("등록에 실패하였습니다.<br/>관리자에게 문의해주세요.");
	console.log(xhr.responseText);
}
</script>
 <!-- container -->
        <div id="container">
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시스템관리</span><span>관리자관리</span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">관리자관리</h2>
                <!-- //title -->

                <!-- table_view -->
                <section class="tbl_wrap_view">
                    <table class="tbl_view01" summary="테이블입니다.">
                        <caption>테이블입니다.</caption>
                        <colgroup>
                            <col width="220px" />
                            <col width="" />
                        </colgroup>
                        <tr>
                            <th scope="row">권한유형<span class="required"></span></th>
                            <td>
                                <div class="form_group w300">
                                    <div class="select_group">
                                        <select id="authCode" title="select" class="form_control">
                                            <c:forEach var="list" items="${authList }">
                                            	<c:if test="${list.authCode != 'A000' and list.authCode != 'A002' }">
													<option value="${list.authCode }">${list.authNm }</option>
                                            	</c:if>
											</c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">ID(사번)<span class="required"></span></th>
                            <td>
                                <div class="form_group w300">
                                    <input type="text" id="memId" class="form_control" placeholder="사번 입력" name="" maxlength="12"/>
                                </div>
                                <button type="button" class="btn-line-bs btn_gray" id="dueChk">중복확인</button>
                                <input type="checkbox" style="display:none;" id="dueYn">
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">이름<span class="required"></span></th>
                            <td>
                                <div class="form_group w300">
                                    <input type="text" id="memName" class="form_control" placeholder="이름 입력" name="" maxlength="100"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">부서명<span class="required"></span></th>
                            <td>
                                <div class="form_group w300">
                                    <input type="text" id="memDept" class="form_control" placeholder="부서 입력" name="" maxlength="100"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">이메일주소<span class="required"></span></th>
                            <td>
                                <div class="form_group w300">
                                    <input type="text" id="memEmail" class="form_control" placeholder="이메일주소 입력" name="" maxlength="100"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">핸드폰번호<span class="required"></span></th>
                            <td>
                                <div class="form_group w300">
                                    <input type="text" id="memPhone" class="form_control" placeholder="'-'없이 입력" name="" maxlength="11" onkeypress="numberonly();" onpaste="javascript:return false;"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">상태<span class="required"></span></th>
                            <td>
                                <div class="form_group">
                                    <div class="radio_inline">
                                        <label class="radio_default">
                                            <input type="radio" name="memUseYn" value="Y" checked="">
                                            <span class="radio_icon"></span>정상</label>
                                        <label class="radio_default">
                                            <input type="radio" name="memUseYn" value="N">
                                            <span class="radio_icon"></span>사용중지</label>
<!--                                         <label class="radio_default"> -->
<!--                                             <input type="radio" name="memUseYn" value="D"> -->
<!--                                             <span class="radio_icon"></span>탈퇴</label> -->
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">SMS 수신<span class="required"></span></th>
                            <td>
                                <div class="form_group">
                                    <div class="radio_inline">
                                        <label class="radio_default">
                                            <input type="radio" name="kakaoSmsYn" value="Y" checked="">
                                            <span class="radio_icon"></span>동의</label>
                                        <label class="radio_default">
                                            <input type="radio" name="kakaoSmsYn" value="N">
                                            <span class="radio_icon"></span>거부</label>
<!--                                         <label class="radio_default"> -->
<!--                                             <input type="radio" name="memUseYn" value="D"> -->
<!--                                             <span class="radio_icon"></span>탈퇴</label> -->
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">메모입력<span class="required"></span></th>
                            <td>
                                <div class="form_group w_full">
                                    <textarea name="" id="memPurpose" cols="" rows="5" class="form_control  h100"
                                        placeholder="메모를 입력하세요."></textarea>
                                </div>
                                <div class="count_txt"><span id="memPurposeCnt">0</span> / 500 bytes</div>
                            </td>
                        </tr>
                    </table>
                </section>

                <!-- button -->
                <section class="btn_wrap m-t-50">
                    <button type="button" class="btn btn_gray" onclick="backBtn();">목록</button>
                    <section>
                        <button type="button" class="btn btn_gray m-r-6" onclick="cancel();">취소</button>
                        <button type="button" class="btn btn_default" onclick="register();">저장</button>
                    </section>
                </section>
                <!-- //button -->
            </div>
            <!-- //content -->
        </div>
        <!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>