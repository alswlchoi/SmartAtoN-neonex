<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<%@taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
    <sec:csrfMetaTags/>
<%@ page import="org.springframework.security.core.Authentication"%>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder"%>
<%@ page import="com.hankook.pg.content.member.dto.MemberDto"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
var defaultEmail = "<%=memberDto.getMemEmail()%>";
$(function(){
	$("#compName").on("keyup",function(){
		if($(this).val().length==0){
			$("#compNameText").text("회사명을 입력해 주세요.");
			$("#compNameText").addClass("redfont");
			$("#compNameText").addClass("info_ment");
		}else{
			$("#compNameText").text("");
			$("#compNameText").removeClass("redfont");
			$("#compNameText").removeClass("info_ment");
		}
	});
	$("#memName").on("keyup",function(){
		if($(this).val().length==0){
			$("#memNameText").text("담당자 이름을 입력해 주세요.");
			$("#memNameText").addClass("redfont");
			$("#memNameText").addClass("info_ment");
		}else{
			$("#memNameText").text("");
			$("#memNameText").removeClass("redfont");
			$("#memNameText").removeClass("info_ment");
		}
	});
	$("#memDept").on("keyup",function(){
		if($(this).val().length==0){
			$("#memDeptText").text("부서명을 입력해 주세요.");
			$("#memDeptText").addClass("redfont");
			$("#memDeptText").addClass("info_ment");
		}else{
			$("#memDeptText").text("");
			$("#memDeptText").removeClass("redfont");
			$("#memDeptText").removeClass("info_ment");
		}
	});
	$("#memEmail").on("keyup",function(){
		if(defaultEmail == $("#memEmail").val().trim()){//바꿧다가 다시 원래것으로 돌아갔을때
			$("#dueEmailYn").prop("checked",true);
			$("#dueEmailChk").css("color","#ec6608");//#333 #ec6608
			$("#dueEmailChk").prop("disabled",true);
		}else{
			$("#dueEmailYn").prop("checked",false);
			$("#dueEmailChk").css("color","#333");//#333 #ec6608
			$("#dueEmailChk").prop("disabled",false);
		}
		var regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		if(!regEmail.test($("#memEmail").val().trim())){
			$("#memEmailText").text("이메일 형식에 맞지 않습니다.");
			$("#memEmailText").addClass("redfont");
		}else{
			$("#memEmailText").text("입력하신 이메일로 승인 안내 및 서비스 관련 주요사항이 안내됩니다.");
			$("#memEmailText").removeClass("redfont");
		}
	});
	$("#memEmail").change(function(){
		if(defaultEmail == $("#memEmail").val().trim()){//바꿧다가 다시 원래것으로 돌아갔을때
			$("#dueEmailYn").prop("checked",true);
			$("#dueEmailChk").css("color","#ec6608");//#333 #ec6608
			$("#dueEmailChk").prop("disabled",true);
		}else{
			$("#dueEmailYn").prop("checked",false);
			$("#dueEmailChk").css("color","#333");//#333 #ec6608
			$("#dueEmailChk").prop("disabled",false);
		}
	});
	$("#dueEmailChk").on('click',function(){
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
		var param = {memEmail :$("#memEmail").val().trim()}
		postAjax("/member/emailDueChk",param,"successDueEmailChk",null,null,null);
	})
	$("#memPhone").on("keyup",function(){
		var regMemPhone = /^01(?:0|1|[6-9])(?:\d{3}|\d{4})\d{4}$/;
		if(!regMemPhone.test($("#memPhone").val().trim())){
			$("#memPhoneText").text("형식에 맞지 않는 번호 입니다.");
			$("#memPhoneText").addClass("redfont");
		}else{
			$("#memPhoneText").text("'-' 없이 입력하세요.");
			$("#memPhoneText").removeClass("redfont");
		}
	});
	$("#compPhone").on("keyup",function(){
		var regCompPhone = /^\d{2,3}\d{3,4}\d{4}$/;
		if(!regCompPhone.test($("#compPhone").val().trim())){
			$("#memCompPhoneText").text("형식에 맞지 않는 번호 입니다.");
			$("#memCompPhoneText").addClass("redfont");
		}else{
			$("#memCompPhoneText").text("'-' 없이 입력하세요.");
			$("#memCompPhoneText").removeClass("redfont");
		}
	});
	$("#compAcctName").on("keyup",function(){
		if($(this).val().length==0){
			$("#compAcctNameText").text("담당자 이름을 입력해 주세요.");
			$("#compAcctNameText").addClass("redfont");
			$("#compAcctNameText").addClass("info_ment");
		}else{
			$("#compAcctNameText").text("");
			$("#compAcctNameText").removeClass("redfont");
			$("#compAcctNameText").removeClass("info_ment");
		}
	});
	$("#compAcctDept").on("keyup",function(){
		if($(this).val().length==0){
			$("#compAcctDeptText").text("부서명을 입력해 주세요.");
			$("#compAcctDeptText").addClass("redfont");
			$("#compAcctDeptText").addClass("info_ment");
		}else{
			$("#compAcctDeptText").text("");
			$("#compAcctDeptText").removeClass("redfont");
			$("#compAcctDeptText").removeClass("info_ment");
		}
	});
	$("#compAcctEmail").on("keyup",function(){
		var regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		if(!regEmail.test($("#compAcctEmail").val().trim())){
			$("#compAcctEmailText").text("이메일 형식에 맞지 않습니다.");
			$("#compAcctEmailText").addClass("redfont");
		}else{
			$("#compAcctEmailText").text("입력하신 이메일로 승인 안내 및 서비스 관련 주요사항이 안내됩니다.");
			$("#compAcctEmailText").removeClass("redfont");
		}
	});
	$("#compAcctPhone").on("keyup",function(){
		var regCompPhone = /^\d{2,3}\d{3,4}\d{4}$/;
		if(!regCompPhone.test($("#compAcctPhone").val().trim())){
			$("#compPhoneText").text("형식에 맞지 않는 번호 입니다.");
			$("#compPhoneText").addClass("redfont");
		}else{
			$("#compPhoneText").text("'-' 없이 입력하세요.");
			$("#compPhoneText").removeClass("redfont");
		}
	});
})
function successDueEmailChk(data){
	console.log(data);
	if(data.cnt>0){
		alert("이미 사용중인 이메일 입니다.");
		$("#dueEmailYn").prop("checked",false);
		$("#dueEmailChk").css("color","#333");//#333 #ec6608
	}else{
		alert("사용가능한 이메일 입니다.");
		$("#dueEmailYn").prop("checked",true);
		$("#dueEmailChk").css("color","#ec6608");//#333 #ec6608
	}
}
function srhAddr(){
// 	confirm("test",suc,can);
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
            // 예제를 참고하여 다양한 활용법을 확인해 보세요.
            console.log(data);
            $("#compAddr").val(data.address);
            $("#compPostNo").val(data.zonecode);
            //우편번호도 추가할것
        }
    }).open();
}
//숨겨진 input file타입
function fileUp(){
	$("#hiddenFileType").click();
}
function fileCng(e){
// 	var fileName=e.target.files;
	$("#fileText").val($("#hiddenFileType").val());
	//파일 명 체크
	var ext = $('#fileText').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#fileUpText").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#fileUpText").addClass("redfont");
		return;
	}else{
		$("#fileUpText").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#fileUpText").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("hiddenFileType").files[0].name)){
    	$("#fileUpText").text('파일명에 특수문자를 제거해주세요.');
		$("#fileUpText").addClass("redfont");
		return;
    }else{
    	$("#fileUpText").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#fileUpText").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("hiddenFileType").files[0].size;
    var maxSize = 5 * 1024 * 1024;//3MB
    if(fileSize > maxSize){
    	$("#fileUpText").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#fileUpText").addClass("redfont");
		return;
     }else{
    	$("#fileUpText").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
 		$("#fileUpText").removeClass("redfont");
     }
}
// function fileUpload(){
// 	var form = $("#fileForm")[0];
// 	var formData = new FormData(form);
// // 	var formData = $("#fileForm").serialize();
// 	var csrfHeader = $('meta[name="_csrf_header"]').attr('content');
// 	var csrfToken = $('meta[name="_csrf"]').attr('content');
// 	$.ajax({
// 		url : "/member/fileUpload/update",
// 		type : "POST",
// 		enctype : "multipart/form-data",
// 		processData : false,
//         contentType : false,
// 		data : formData,
// 		beforeSend: function(xhr) {
//             xhr.setRequestHeader("AJAX", true);
//             xhr.setRequestHeader(csrfHeader, csrfToken);
//             xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
//         },
// 		success : function(resdata){
// 			console.log(resdata);
// 			alert("변경완료 되었습니다.<br/>다시 한 번 로그인해 주세요.");
// 			$(".lyClose").click(function(){
// 				location.href="/logout";
// 			})
// 		},
// 		error : function(e){
// 			console.log(e);
// 		}
// 	})
// }

function register() {
	if($("#compName").val().trim().length==0){
		alert("회사명을 입력해 주세요.");
		$("#compName").focus();
		return;
	}
	if($("#compAddr").val().length==0){
		alert("기본주소를 검색해 주세요.");
		$("#compAddr").focus();
		return;
	}
	if($("#compAddrDetail").val().length==0){
		alert("상세주소를 입력해 주세요.");
		$("#compAddrDetail").focus();
		return;
	}
	if($("#fileText").val().length==0){
		alert("첨부파일을 추가해 주세요.");
		return;
	}
	//파일 명 체크
	if($("#hiddenFileType").val()!=""){
		var ext = $('#fileText').val().split('.').pop().toLowerCase();
		if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
			alert('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
			return;
		}
		var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
		if(pattern.test(document.getElementById("hiddenFileType").files[0].name)){
	        //alert("파일명에 허용된 특수문자는 '-', '_', '(', ')', '[', ']', '.' 입니다.");
	        alert('파일명에 특수문자를 제거해주세요.');
	        return;
	    }
	    //파일 사이즈 체크
	    var fileSize = document.getElementById("hiddenFileType").files[0].size;
	    var maxSize = 5 * 1024 * 1024;//3MB
	    if(fileSize > maxSize){
	    	alert("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
	        return;
	     }
	}else{
		var ext = $('#fileText').val().split('.').pop().toLowerCase();
		if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
			alert('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
			return;
		}
		var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
		if(pattern.test(document.getElementById("fileText").value)){
	        //alert("파일명에 허용된 특수문자는 '-', '_', '(', ')', '[', ']', '.' 입니다.");
	        alert('파일명에 특수문자를 제거해주세요.');
	        return;
	    }
	}
	/////////////담당자정보//////////////
	if($("#memName").val().trim().length==0){
		alert("담당자 이름을 입력해 주세요.");
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
		alert("휴대폰 번호를 입력해 주세요.");
		$("#memPhone").focus();
		return;
	}
	var regMemPhone = /^01(?:0|1|[6-9])(?:\d{3}|\d{4})\d{4}$/;
	if(!regMemPhone.test($("#memPhone").val().trim())){
		alert("형식에 맞지 않는 번호 입니다.");
		$("#memPhone").focus();
		return;
	}
	if($("#compPhone").val().trim().length==0){
		alert("전화번호를 입력해 주세요.");
		$("#compPhone").focus();
		return;
	}
	var regCompPhone = /^\d{2,3}\d{3,4}\d{4}$/;
	if(!regCompPhone.test($("#compPhone").val().trim())){
		alert("형식에 맞지 않는 번호 입니다.");
		$("#compPhone").focus();
		return;
	}
	/////////////회계담당자정보//////////////
	if($("#compAcctName").val().trim().length==0){
		alert("담당자 이름을 입력해 주세요.");
		$("#compAcctName").focus();
		return;
	}
	if($("#compAcctDept").val().trim().length==0){
		alert("부서명을 입력해 주세요.");
		$("#compAcctDept").focus();
		return;
	}
	if($("#compAcctEmail").val().trim().length==0){
		alert("이메일 주소를 입력해 주세요.");
		$("#compAcctEmail").focus();
		return;
	}
	var regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	if(!regEmail.test($("#compAcctEmail").val().trim())){
		alert("이메일 형식에 맞지 않습니다.");
		$("#compAcctEmail").focus();
		return;
	}
	if(!$("#dueEmailYn").prop("checked")){
		alert("이메일 중복확인을 해주세요.");
		return;
	}
	if($("#compAcctPhone").val().trim().length==0){
		alert("전화번호를 입력해 주세요.");
		$("#compAcctPhone").focus();
		return;
	}
	var regCompPhone = /^\d{2,3}\d{3,4}\d{4}$/;
	if(!regCompPhone.test($("#compAcctPhone").val().trim())){
		alert("형식에 맞지 않는 번호 입니다.");
		$("#compAcctPhone").focus();
		return;
	}
	var csrfHeader = $('meta[name="_csrf_header"]').attr('content');
	var csrfToken = $('meta[name="_csrf"]').attr('content');
	var newForm = new FormData($("#fileForm")[0]);
	$.ajax({
		url : '/member/fileUpload/update',
		type : 'POST',
		enctype:'multipart/form-data',
		processData:false,
		contentType:false,
		cache:false,
		data : newForm,
		beforeSend: function(xhr) {
            xhr.setRequestHeader(csrfHeader, csrfToken);
        },
        success:function(data){
			if(data.result > 0) {
				alert("변경완료 되었습니다.<br/>다시 한 번 로그인해 주세요.");
		        $(".lyClose").click(function(){
					location.href="/login";
				});
		    }else if(data.result == -99){
		    	alert("회원사 수정 간 에러 발생");
		    }else if(data.result == -98){
	    		alert("회원 수정 간 에러 발생");
		    }else if(data.result == -97){
	    		alert("파일 업로드 간 에러 발생");
		    }else{
		    	alert("시스템 에러 발생<br/>관리자에게 문의해 주세요.");
		    }
		},error : function(data){
			console.log(data);
		}
	})
//     var data = {
//     		//사업자 및 담당자 정보
//     		compName : $("#compName").val().trim(),
//     		compAddr : $("#compAddr").val(),
//     		compPostNo : $("#compPostNo").val(),
//     		compAddrDetail : $("#compAddrDetail").val(),
//     		//파일업로드는 따로
//     		memName : $("#memName").val().trim(),
//     		memDept : $("#memDept").val().trim(),
//     		memEmail : $("#memEmail").val().trim(),
//     		memPhone : $("#memPhone").val().trim(),
//     		compPhone : $("#compPhone").val().trim(),
//     		//회계 담당자 정보
//     		compAcctName : $("#compAcctName").val().trim(),
//     		compAcctDept : $("#compAcctDept").val().trim(),
//     		compAcctEmail : $("#compAcctEmail").val().trim(),
//     		compAcctPhone : $("#compAcctPhone").val().trim(),
//     		};

//     postAjax("/member/update",data,"successRegister","failRegister",null,null);
}
</script>
<script type="text/javascript">
//등록 성공 callback
// function successRegister(data) {
//     if(data.result == "OK") {
//     	fileUpload();
//     }else {
//     	if(data.result =="MEMBER_ERROR"){
//     		alert("변경간에 에러 발생");
//     	}else{
//     		alert("회원사 변경 간 에러 발생");
//     	}
//     }
// 	//파일업로드도 추가
// }
//등록 실패 callback
// function failRegister(xhr) {
//     alert("변경에 실패하였습니다.<br/>관리자에게 문의해주세요.");
//     console.log(xhr.responseText);
// }
//탭 이동
function pageMove(str){
	if(str=='tab1'){
		location.href = '/user/modify';
	}else if(str == 'tab2'){
		location.href = '/user/modifyPwd';
	}else if(str == 'tab3'){
		location.href = '/user/driver';
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
                <button class="tablinks active" onclick="pageMove('tab1')" id="defaultOpen">회원정보 변경</button>
                <button class="tablinks" onclick="pageMove('tab2')">비밀번호 변경</button>
                <button class="tablinks" onclick="pageMove('tab3')">운전자 정보 관리</button>
            </div>
            <div class="wrap_tabcontent">
                <!-- tab1 -->
                <div id="tab1" class="tabcontent">
                    <h3 class="stitle m-t-20">아이디 정보</h3>
                    <!-- table_view -->
                    <div class="tbl_wrap_view m-t-15">
                        <table class="tbl_view01" summary="테이블입니다.">
                            <caption>테이블입니다.</caption>
                            <colgroup>
                                <col width="180px;" />
                                <col width="" />
                            </colgroup>
                            <tr>
                                <th scope="row">아이디</th>
                                <td>${memberDto.getMemId()}</td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_view -->
                    <h3 class="stitle m-t-30">사업자 및 담당자 정보</h3>
                    <!-- table_view -->
                    <form action="/member/fileUp" id="fileForm" method="post" enctype="multipart/form-data" name="fileForm">
                    <div class="tbl_wrap_view m-t-15">
                        <table class="tbl_view01" summary="테이블입니다.">
                            <caption>테이블입니다.</caption>
                            <colgroup>
                                <col width="180px;" />
                                <col width="" />
                            </colgroup>
                            <tr>
                                <th scope="row">사업자 등록번호</th>
                                <td colspan="3">${memberDto.getCompLicense()}</td>
                            </tr>
                            <tr>
                                <th scope="row">회사명<span class="required"></span></th>
                                <td colspan="3">
                                    <div class="form_group w300">
                                        <input type="text" id="compName" class="form_control" placeholder="" name="compName"
                                            value="${memberDto.getCompName()}" maxlength="100"/>
                                    </div>
                                    <span class="" id="compNameText"></span>
                                </td>
                            </tr>
                            <tr>
                                <th rowspan="2" scope="row">주소<span class="required"></span></th>
                                <td colspan="3">
                                    <div class="form_group w300">
                                        <input type="text" id="compAddr" class="form_control" placeholder="" name="compAddr"
                                            value="${memberDto.getCompAddr()}" onclick="srhAddr();" readonly="readonly" maxlength="200"/>
                                    </div>
                                    <button type="button" class="btn-line btn_gray" onclick="srhAddr()">주소검색</button>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <div class="form_group w610">
                                     <input type="hidden" id="compPostNo" name="compPostNo" placeholder="" maxlength="14" value="${memberDto.getCompPostNo()}">
                                        <input type="text" id="compAddrDetail" class="form_control" placeholder="상세주소 입력"
                                            name="compAddrDetail" value="${memberDto.getCompAddrDetail()}" maxlength="100"/>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">사업자등록증 사본<span class="required"></span></th>
                                <td colspan="3">
                                    <div class="form_group w300">
                                        <input type="text" id="fileText" class="form_control" placeholder="파일 첨부"
                                            name="fileText" onclick="fileUp();" readonly="readonly" value="${memberDto.getFName()}"/>
<!--                                         <form action="/member/fileUpload" id="fileForm" method="post" enctype="multipart/form-data"> -->
                                        	<input type="hidden" value="" id="compLicenseHidden" name="compLicenseHidden">
                                        	<input type="file" name="hiddenFileType" id="hiddenFileType" style="display:none;" onChange="fileCng();">
<!--                                        	</form> -->
                                    </div>
                                    <button type="button" class="btn-line btn_gray" onclick="fileUp();">파일첨부</button>
                                    <span class="info_ment" id="fileUpText">5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg,
                                        bmp, tiff ,tif, pdf만 가능)</span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">담당자 이름<span class="required"></span></th>
                                <td colspan="3">
                                    <div class="form_group w300">
                                        <input type="text" id="memName" class="form_control" placeholder="" name="memName"
                                            value="${memberDto.getMemName()}" maxlength="100"/>
                                    </div>
                                    <span class="" id="memNameText"></span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">부서명<span class="required"></span></th>
                                <td colspan="3">
                                    <div class="form_group w300">
                                        <input type="text" id="memDept" class="form_control" placeholder="부서명 입력"
                                            name="memDept" value="${memberDto.getMemDept()}" maxlength="100"/>
                                    </div>
                                    <span class="" id="memDeptText"></span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">이메일 주소<span class="required"></span></th>
                                <td colspan="3">
                                    <div class="form_group w300">
                                        <input type="text" id="memEmail" class="form_control" placeholder="이메일 주소 입력"
                                            name="memEmail" value="${memberDto.getMemEmail()}" maxlength="100"/>
                                    </div>
                                    <button type="button" class="btn-line btn_gray" id="dueEmailChk" style="color:#ec6608;" disabled>이메일 중복체크</button>
                                            <input type="checkbox" style="display:none;" id="dueEmailYn" checked>
                                    <span class="info_ment" id="memEmailText">입력하신 이메일로 승인 안내 및 서비스 관련 주요사항이 안내됩니다.</span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">휴대폰 번호<span class="required"></span></th>
                                <td colspan="3">
                                    <div class="form_group w300">
                                        <input type="text" id="memPhone" class="form_control" placeholder="휴대폰 번호 입력"
                                            name="memPhone" value="${memberDto.getMemPhone()}" maxlength="11" onkeypress="numberonly();" onpaste="javascript:return false;"/>
                                    </div>
                                    <span class="info_ment" id="memPhoneText">‘-’ 없이 입력하세요.</span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">회사 전화번호<span class="required"></span></th>
                                <td colspan="3">
<!--                                     <div class="form_group"> -->
<!--                                         <label for="se1">검색선택</label> -->
<!--                                         <div class="select_group"> -->
<!--                                             <select id="" title="select" class="form_control"> -->
<!--                                                 <option value="">02</option> -->
<!--                                                 <option value="">032</option> -->
<!--                                                 <option value="">031</option> -->
<!--                                             </select> -->
<!--                                         </div> -->
<!--                                     </div> -->
                                    <div class="form_group w300">
                                        <input type="text" id="compPhone" class="form_control" placeholder="전화번호 입력"
                                            name="compPhone" value="${memberDto.getCompPhone()}" maxlength="11" onkeypress="numberonly();" onpaste="javascript:return false;"/>
                                    </div>
                                    <span class="info_ment" id="memCompPhoneText">‘-’ 없이 입력하세요.</span>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_view -->
                    <h3 class="stitle m-t-30">회계 담당자 정보
<!--                         <div class="form_group"> -->
<!--                             <div class="check_inline"> -->
<!--                                 <label class="check_default"> -->
<!--                                     <input type="checkbox" name="" value=""> -->
<!--                                     <span class="check_icon"></span>담당자 정보와 동일</label> -->
<!--                             </div> -->
<!--                         </div> -->
                    </h3>
                    <!-- table_view -->
                    <div class="tbl_wrap_view m-t-15">
                        <table class="tbl_view01" summary="테이블입니다.">
                            <caption>테이블입니다.</caption>
                            <colgroup>
                                <col width="180px;" />
                                <col width="" />
                            </colgroup>
                            <tr>
                                <th scope="row">담당자 이름<span class="required"></span></th>
                                <td colspan="3">
                                    <div class="form_group w300">
                                        <input type="text" id="compAcctName" class="form_control" placeholder="담당자 이름 입력"
                                            name="compAcctName" value="${memberDto.getCompAcctName()}" maxlength="100"/>
                                    </div>
                                    <span class="" id="compAcctNameText"></span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">부서명<span class="required"></span></th>
                                <td colspan="3">
                                    <div class="form_group w300">
                                        <input type="text" id="compAcctDept" class="form_control" placeholder="부서명 입력"
                                            name="compAcctDept" value="${memberDto.getCompAcctDept()}" maxlength="100"/>
                                    </div>
                                    <span class="" id="compAcctDeptText"></span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">이메일 주소<span class="required"></span></th>
                                <td colspan="3">
                                    <div class="form_group w300">
                                        <input type="text" id="compAcctEmail" class="form_control" placeholder="이메일 주소 입력"
                                            name="compAcctEmail" value="${memberDto.getCompAcctEmail()}" maxlength="100"/>
                                    </div>
                                    <span class="info_ment" id="compAcctEmailText">입력하신 이메일로 승인 안내 및 서비스 관련 주요사항이 안내됩니다.</span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">회사 전화번호<span class="required"></span></th>
                                <td colspan="3">
<!--                                     <div class="form_group"> -->
<!--                                         <label for="se1">검색선택</label> -->
<!--                                         <div class="select_group"> -->
<!--                                             <select id="" title="select" class="form_control"> -->
<!--                                                 <option value="">02</option> -->
<!--                                                 <option value="">032</option> -->
<!--                                                 <option value="">031</option> -->
<!--                                             </select> -->
<!--                                         </div> -->
<!--                                     </div> -->
                                    <div class="form_group w300">
                                        <input type="text" id="compAcctPhone" class="form_control" placeholder="전화번호 입력"
                                            name="compAcctPhone" value="${memberDto.getCompAcctPhone()}" maxlength="11" onkeypress="numberonly();" onpaste="javascript:return false;"/>
                                    </div>
                                    <span class="info_ment" id="compPhoneText">‘-’ 없이 입력하세요.</span>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_view -->
					</form>
                    <!-- button -->
                    <section class="tac m-t-50">
<!--                         <button type="button" class="btn btn_gray m-r-11" data-layer="cancel">취소</button> -->
                        <button type="button" class="btn btn_default" onclick="register()">확인</button>
                    </section>
                    <!-- //button -->
                </div>
                <!-- //tab1 -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>