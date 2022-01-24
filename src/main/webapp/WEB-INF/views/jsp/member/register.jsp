<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<%@taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
    <sec:csrfMetaTags/>
<script src="/inc/js/member/register.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
function srhAddr(){
	var width = 500; //팝업의 너비
	var height = 600; //팝업의 높이
    new daum.Postcode({
    	width: width, //생성자에 크기 값을 명시적으로 지정해야 합니다.
        height: height,
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
            // 예제를 참고하여 다양한 활용법을 확인해 보세요.
            console.log(data);
            $("#compAddr").val(data.address);
            $("#compPostNo").val(data.zonecode);
        }
    }).open({
    	left: (window.screen.width / 2) - (width / 2),
        top: (window.screen.height / 2) - (height / 2)
    });
}
//중복체크 callback
function successDueChk(data){
	console.log(data);
	$("#newIdPop").val("");
	if(data.cnt>0){
		var html="";
		html +='<span>';
		html +='"'+data.memberDto.memId+'"';
		html +='</span>';
		html +=' 아이디(ID)는 <br/>사용하실 수 없습니다.';
		$("#memIdPop").html(html);
// 		$("#iduse").hide();
		$("#dueYn").prop("checked",false);
		$("#dueChk").css("color","#333");//#333 #ec6608
	}else{
		$("#hiddenId").val(data.memberDto.memId);
		var html="";
		html +='<span>';
		html +='"'+data.memberDto.memId+'"';
		html +='</span>';
		html +=' 아이디(ID)는 <br/>사용하실 수 있습니다.';
		html +='<div class="m-t-20"><button type="button" class="btn-line btn_gray m-r-11" id="idUse">사용하기</button></div>';
		$("#memIdPop").html(html);
		//사용하기
		$("#idUse").click(function(){
			$("#dueYn").prop("checked",true);
			$("#dueChk").css("color","#ec6608");//#333 #ec6608
			$("#memId").val($("#hiddenId").val());
			$("#newIdPop").val("");
//	 		$("[data-fn='lyClose']").click();
			var _layerOn_length = $(".due > .on, .confirmDiv > .on").length;
			if (_layerOn_length) {
				$(".due > .on").removeClass("on")
				.parent().removeClass("on");
			} else {
				$(this).parent().parent().removeClass("on")
				.parent().removeClass("on");
			}
		});
	}
	$("[data-layer='id_check']").click();
}
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
//숨겨진 input file타입
function fileUp(){
	$("#hiddenFileType").click();
}
// function fileUpload(){
// 	var form = $("#fileForm")[0];
// 	var formData = new FormData(form);
// // 	var formData = $("#fileForm").serialize();
// 	var csrfHeader = $('meta[name="_csrf_header"]').attr('content');
// 	var csrfToken = $('meta[name="_csrf"]').attr('content');
// 	$.ajax({
// 		url : "/member/fileUpload/insert",
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
// 			alert2("가입 신청이 완료 되었습니다.","신청하신 정보에 대해 담당자 검토/승인 완료 후<br/>등록한 담당자 이메일로 알려드립니다.","메인화면으로 이동","goHome");
// 		},
// 		error : function(e){
// 			console.log(e);
// 		}
// 	})
// }
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
</script>
<script type="text/javascript">
$(function(){
	//아코디언
	var acc = document.getElementsByClassName("accordion");
    var i;

    for (i = 0; i < acc.length; i++) {
        acc[i].addEventListener("click", function () {
            this.classList.toggle("active");
            var panel = this.nextElementSibling;
            if (panel.style.display === "block") {
                panel.style.display = "none";
            } else {
                panel.style.display = "block";
            }
        });
    }
	//스텝1
	$("#step1Btn").click(function(event){
		openTab(event, 'tab2');
		$("#tab2Btn").addClass("active");
	});
	//스텝2
	$("#step2Btn").click(function(){
		if($(".req:checked").length == $(".req").length){
			$("#tab2").hide();
			$("#tab3").show();
			$("#memAgreement").val("Y");
		}else{
			$("#memAgreement").val("N");
			alert("약관 확인 후 모두 동의해 주셔야 합니다.");
		}
	});
	//스템2 체크박스 확인
	$("#allChk").click(function(){
		if($("#allChk").prop("checked")){
			$(".reqChk").prop("checked",true);
		}else{
			$(".reqChk").prop("checked",false);
		}
	});
	$(".reqChk").click(function(){
		if($(".reqChk:checked").length==$(".reqChk").length){
			$("#allChk").prop("checked",true);
		}else{
			$("#allChk").prop("checked",false);
		}
	});
	//회원가입 스텝3
	//아이디 중복확인 후 변경시 중복확인 해제
	$("#memId").change(function(){
		$("#dueYn").prop("checked",false);
		$("#dueChk").css("color","#333");//#333 #ec6608
	});
	$("#memId").on("keyup",function(){
		$("#dueYn").prop("checked",false);
		$("#dueChk").css("color","#333");//#333 #ec6608
		var regId = /^[A-Za-z0-9]{5,12}$/;
		if(!regId.test($("#memId").val().trim())){
			$("#memIdText").text("아이디는 5~12자 영문자,숫자로 입력해 주세요.");
			$("#memIdText").addClass("redfont");
		}else{
			$("#memIdText").text("5~12자 영문자, 숫자 입력");
			$("#memIdText").removeClass("redfont");
		}
	});

	//비밀번호 확인 문구
	$("#memPwd").on("keyup",function(){
		var regPwd = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$/;
		if(!regPwd.test($("#memPwd").val())){//비밀번호는 공백도 한칸 차지이므로 trim 제거
			$("#memPwdText").text("비밀번호는 8~16자 영문자,숫자 및 특수문자 조합으로 입력해 주세요.");
			$("#memPwdText").addClass("redfont");
			if($("#memPwd").val() == $("#memPwdChk").val()){
				$("#memPwdChkText").text("");
				$("#memPwdChkText").removeClass("info_ment");
				$("#memPwdChkText").removeClass("redfont");
			}
		}else{
			$("#memPwdText").text("8~16자 영문자,숫자 및 특수문자 조합하여 입력");
			$("#memPwdText").removeClass("redfont");
		}
	});
	$("#memPwdChk").on("keyup",function(){
		if($("#memPwd").val() == $("#memPwdChk").val()){
			$("#memPwdChkText").text("");
			$("#memPwdChkText").removeClass("info_ment");
			$("#memPwdChkText").removeClass("redfont");
		}else{
			$("#memPwdChkText").text("비밀번호가 같지 않습니다.");
			$("#memPwdChkText").addClass("redfont");
			$("#memPwdChkText").addClass("info_ment");
		}
	});

	//사업자 등록번호 확인
	$("#compLicense").change(function(){
		$("#compLicenseDueYn").prop("checked",false);
		$("#licenseBtn").css("color","#333");//#333 #ec6608
	});
	$("#compLicense").on("keyup",function(){
		$("#compLicenseDueYn").prop("checked",false);
		$("#licenseBtn").css("color","#333");//#333 #ec6608
		if($("#compLicense").val().length<10){
			$("#compLicenseText").text("사업자 등록번호는 ‘-” 없이  10자 숫자로 입력해 주세요.");
			$("#compLicenseText").addClass("redfont");
		}else if($("#compLicense").val().length>10){
			$("#compLicenseText").text("사업자 등록번호는 ‘-” 없이  10자 숫자로 입력해 주세요.");
			$("#compLicenseText").addClass("redfont");
		}else{
			$("#compLicenseText").text("'-'없이 입력하세요.");
			$("#compLicenseText").removeClass("redfont");
		}
	});
	$("#compLicense").on("paste",function(){
	    //복사 붙여넣기 시 공백, '-' ,'.' 제거 추가 할 것
    	var self = $(this);
	    setTimeout(function(){
		    var val = self.val();
		    var regx = new RegExp(/^[0123456789]$/);
		    if (!regx.test(val)) {
		        val = val.replace(/[^0-9]/gi, '').replace(/[-+]/g, '')
		        self.val(val);
		    }
	    },100)
	});
	$("#licenseBtn").click(function(){
		srhBusinessApi($("#compLicense").val());
	});


	//페이지 중복확인
	$("#dueChk").click(function(){
		if($("#memId").val().trim().length==0){
			alert("아이디를 입력해주세요.");
			$("#memId").focus();
			return;
		}
		var regId = /^[A-Za-z0-9]{5,12}$/;
		if(!regId.test($("#memId").val().trim())){
			alert("아이디는 5~12자 영문자,숫자로 입력해 주세요.");
			return;
		}

		var param = {memId :$("#memId").val().trim()}
		postAjax("/member/idDueChk",param,"successDueChk",null,null,null);
	});
	//팝업 중복확인
	$("#newDueChk").click(function(){
		if($("#newIdPop").val().trim().length==0){
			alert("아이디를 입력해주세요.");
			$("#newIdPop").focus();
			return;
		}
		var regId = /^[A-Za-z0-9]{5,12}$/;
		if(!regId.test($("#newIdPop").val().trim())){
			alert("아이디는 5~12자 영문자,숫자로 입력해 주세요.");
			return;
		}
		var param = {memId :$("#newIdPop").val().trim()}
		postAjax("/member/idDueChk",param,"successDueChk",null,null,null);
	});
	$("#sameChk").click(function(){
		if($(this).prop("checked")){
			$("#compAcctName").val($("#memName").val());
			$("#compAcctDept").val($("#memDept").val());
			$("#compAcctEmail").val($("#memEmail").val());
			$("#compAcctPhone").val($("#compPhone").val());
		}
	});
	$("#memPurpose").on("keyup",function(){
		if($(this).val().length>500){
			$(this).val($(this).val().substring(0,500));
		}
		$("#memPurposeCnt").text($(this).val().length);
	});
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
		$("#dueEmailYn").prop("checked",false);
		$("#dueEmailChk").css("color","#333");//#333 #ec6608
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
		$("#dueEmailYn").prop("checked",false);
		$("#dueEmailChk").css("color","#333");//#333 #ec6608
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
	$("#fileText").on("change",function(){
		var ext = $('#fileText').val().split('.').pop().toLowerCase();
		if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
			alert('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
			return;
		}
	})
})
</script>

<!-- tab -->
<script>
    function openTab(evt, tabName) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("tabcontent");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablinks");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(tabName).style.display = "block";
        evt.currentTarget.className += " active";
    }
    // Get the element with id="defaultOpen" and click on it
    $("#defaultOpen").click();
</script>
<!-- //tab -->

 <!-- container -->
        <div id="container">
            <!-- visual -->
            <div class="visual_sub common"></div>
            <!-- //visual -->
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>회원가입</span></div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">회원가입</h2>
                <!-- //title -->
                <!-- tab -->
                <div class="wrap_tab w1200">
                    <div class="tab">
                        <button class="tablinks active" onclick="openTab(event, 'tab1')" id="defaultOpen">가입안내</button>
                        <button class="tablinks" onclick="openTab(event, 'tab2')" id="tab2Btn">회원가입</button>
                    </div>
                    <div class="wrap_tabcontent">
                        <!-- tab1 -->
                        <div id="tab1" class="tabcontent">
                            <div class="box_txt01">타이어와 자동차 기술을 개발하는 관련 부품 업체 및 연구기관 대상으로<br /><span>테크노링 서비스를
                                    제공</span>합니다.</div>
                            <h3 class="stitle m-t-70">회원가입 대상 <span>: 타이어 및 차량 관련 부품 업체 및 연구기관</span></h3>
                            <h3 class="stitle m-t-20">회원가입 절차</h3>
                            <div class="tac m-t-20"><img src="/inc/images/img_joinguide01.png" alt="" /></div>
                            <h3 class="stitle m-t-80">회원가입 준비사항 및 유의사항</h3>
                            <ul class="info_text01 m-t-12">
                                <li>- 준비사항 : 회사명, 사업자 등록번호, 회사 주소, 사용할 아이디 및 비밀번호 정보, 담당자 및 회계 담당자 정보</li>
                                <li>- 신청하신 담당자 이메일주소로 승인 완료 시 공지 되므로, 이메일주소를 정확하게 입력해 주세요. (관리자에 의해 검토 후 승인 완료 된
                                    회원사에 한하여 이메일로 공지 됩니다.)</li>
                                <li>- 사업자 등록증 사본은 회원가입 시 혹은 승인 완료 후 마이페이지 에서 제출 하실 수 있습니다. </li>
                                <li>- 회원사 당 1개의 서비스 계정이 됩니다. (기업당 여러 개 아이디 발급 불가)</li>
                            </ul>
                            <!-- button -->
                            <section class="tac m-t-50">
                                <!-- <button type="button" class="btn btn_gray m-r-11">이전</button> -->
                                <button type="button" class="btn btn_default" id="step1Btn">회원가입</button>
                            </section>
                            <!-- //button -->
                        </div>
                        <!-- //tab1 -->
                        <!-- tab2 -->
                        <div id="tab2" class="tabcontent" style="display:none;">
                            <div class="terms_wrap m-t-20">
                                <div class="terms_all">
                                    <div class="form_group check_icon-b m-t-20">
                                        <div class="check_inline">
                                            <label class="check_default">
                                                <input type="checkbox" name="" value="" id="allChk">
                                                <span class="check_icon-b"></span>모두 동의합니다.</label>
                                        </div>
                                    </div>
                                </div>
                                <!-- accordion -->
                                <div class="wrap_accordion m-t-23">
                                    <button class="accordion">
                                        <div class="form_group check_icon-b">
                                            <div class="check_inline">
                                                <label class="check_default">
                                                    <input type="checkbox" name="" value="" id="chk1" class="reqChk req">
                                                    <span class="check_icon-b"></span>(필수) 서비스 이용 약관 동의</label>
                                            </div>
                                        </div>
                                    </button>
                                    <div class="accordion_panel">
                                        서비스 이용 약관 내용
                                    </div>
                                    <button class="accordion">
                                        <div class="form_group check_icon-b">
                                            <div class="check_inline">
                                                <label class="check_default">
                                                    <input type="checkbox" name="" value="" id="chk2" class="reqChk req">
                                                    <span class="check_icon-b"></span>(필수) 개인정보 수집 및 이용</label>
                                            </div>
                                        </div>
                                    </button>
                                    <div class="accordion_panel">
                                        개인정보 수집 및 이용 내용
                                    </div>
                                    <button class="accordion">
                                        <div class="form_group check_icon-b">
                                            <div class="check_inline">
                                                <label class="check_default">
                                                    <input type="checkbox" name="" value="" id="chk3" class="reqChk req">
                                                    <span class="check_icon-b"></span>(필수) 보안 서약 관련 이용안내 동의</label>
                                            </div>
                                        </div>
                                    </button>
                                    <div class="accordion_panel">
                                        보안 서약 관련 이용안내 동의 내용
                                    </div>
                                </div>
                                <!-- //accordion -->
                            </div>
                            <!-- button -->
                            <section class="tac m-t-50">
                                <!-- <button type="button" class="btn btn_gray m-r-11">이전</button> -->
                                <button type="button" class="btn btn_default" id="step2Btn">확인</button>
                            </section>
                            <!-- //button -->
                        </div>
                        <!-- //tab2 -->
                         <form action="/member/fileUp" id="fileForm" method="post" enctype="multipart/form-data" name="fileForm">
						<!-- tab3 -->
						<div id="tab3" class="tabcontent" style="display:none;">
							<h3 class="stitle m-t-20">로그인 정보</h3>
							<!-- table_view -->
                            <div class="tbl_wrap_view m-t-15">
                                <table class="tbl_view01" summary="테이블입니다.">
                                    <caption>테이블입니다.</caption>
                                    <colgroup>
                                        <col width="180px;" />
                                        <col width="" />
                                    </colgroup>
                                    <tr>
                                        <th scope="row">아이디<span class="required"></span></th>
                                        <td colspan="3">
                                            <div class="form_group w300">
                                                <input type="text" id="memId" class="form_control" placeholder="아이디 입력" name="memId" maxlength="12"/>
                                            </div>
                                            <button type="button" class="btn-line btn_gray" id="dueChk">아이디 중복체크</button>
<!--                                             <button type="button" class="btn-line btn_gray" data-layer="id_check2">아이디 -->
<!--                                                 중복체크</button> -->
                                            <span class="info_ment" id="memIdText">5~12자 영문자, 숫자 입력</span>
                                            <input type="checkbox" style="display:none;" id="dueYn">
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">비밀번호<span class="required"></span></th>
                                        <td colspan="3">
                                            <div class="form_group w300">
                                                <input type="password" id="memPwd" class="form_control" placeholder="비밀번호 입력"
                                                    name="memPwd" autocomplete="new-password" maxlength="16"/>
                                            </div>
                                            <span class="info_ment" id="memPwdText">8~16자 영문자, 숫자 및 특수문자 조합하여 입력</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">비밀번호 확인<span class="required"></span></th>
                                        <td colspan="3">
                                            <div class="form_group w300">
                                                <input type="password" id="memPwdChk" class="form_control"
                                                    placeholder="비밀번호 다시 입력" name="memPwdChk" maxlength="16"/>
                                            </div>
                                            <span class="" id="memPwdChkText"></span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <!-- //table_view -->
                            <h3 class="stitle m-t-30">사업자 및 담당자 정보</h3>
                            <!-- table_view -->
                            <div class="tbl_wrap_view m-t-15">
                                <table class="tbl_view01" summary="테이블입니다.">
                                    <caption>테이블입니다.</caption>
                                    <colgroup>
                                        <col width="180px;" />
                                        <col width="" />
                                    </colgroup>
                                    <tr>
                                        <th scope="row">사업자 등록번호<span class="required"></span></th>
                                        <td colspan="3">
                                            <div class="form_group w300">
                                                <input type="text"  id="compLicense" class="form_control" placeholder="사업자 등록번호 입력"
                                                    name="compLicense" maxlength="12" onkeypress="numberonly();"/>
                                            <input type="checkbox" style="display:none;" id="compLicenseDueYn">
                                            </div>
                                            <button type="button" class="btn-line btn_gray"
                                                data-layer="biz_num" id="licenseBtn">확인</button>
                                           <input type="checkbox" style="display:none;" id="compLicenseChk">
                                           <span class="info_ment" id="compLicenseText">‘-’ 없이 입력하세요.</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">회사명<span class="required"></span></th>
                                        <td colspan="3">
                                            <div class="form_group w300">
                                                <input type="text" class="form_control" placeholder="회사명 입력"
                                                    name="compName" id="compName" maxlength="100"/>
                                            </div>
                                            <span class="" id="compNameText"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th rowspan="2" scope="row">주소<span class="required"></span></th>
                                        <td colspan="3">
                                            <div class="form_group w300">
                                                <input type="text" id="compAddr" class="form_control" placeholder="기본주소 입력"
                                                    name="compAddr" onclick="srhAddr();" readonly="readonly" maxlength="200"/>
                                                <input type="hidden" id="compPostNo" name="compPostNo" placeholder="" maxlength="14">
                                            </div>
                                            <button type="button" class="btn-line btn_gray" onclick="srhAddr();">주소검색</button>
<!--                                             <button type="button" class="btn-line btn_gray" data-layer="address">주소검색</button> -->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <div class="form_group w610">
                                                <input type="text" id="compAddrDetail" class="form_control" placeholder="상세주소 입력"
                                                    name="compAddrDetail" maxlength="100"/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">사업자등록증 사본<span class="required"></span></th>
                                        <td colspan="3">
                                            <div class="form_group w300">
                                                <input type="text" id="fileText" class="form_control" placeholder="파일 첨부"
                                                    name="fileText" onclick="fileUp();" readonly="readonly"/>
<!--                                                     <form action="/member/fileUp" id="fileForm" method="post" enctype="multipart/form-data"> -->
                                                    	<input type="hidden" value="" id="compLicenseHidden" name="compLicenseHidden">
	                                                    <input type="file" name="hiddenFileType" id="hiddenFileType" style="display:none;" onChange="fileCng();">
<!--                                                     </form> -->
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
                                                <input type="text" id="memName" class="form_control" placeholder="담당자 이름 입력"
                                                    name="memName" maxlength="100"/>
                                            </div>
                                            <span class="" id="memNameText"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">부서명<span class="required"></span></th>
                                        <td colspan="3">
                                            <div class="form_group w300">
                                                <input type="text" id="memDept" class="form_control" placeholder="부서명 입력"
                                                    name="memDept"  maxlength="100"/>
                                            </div>
                                            <span class="" id="memDeptText"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">이메일 주소<span class="required"></span></th>
                                        <td colspan="3">
                                            <div class="form_group w300">
                                                <input type="text" id="memEmail" class="form_control" placeholder="이메일 주소 입력"
                                                    name="memEmail" maxlength="100"/>
                                            </div>
                                            <button type="button" class="btn-line btn_gray" id="dueEmailChk">이메일 중복체크</button>
                                            <input type="checkbox" style="display:none;" id="dueEmailYn">
                                            <span class="info_ment" id="memEmailText">입력하신 이메일로 승인 안내 및 서비스 관련 주요사항이 안내됩니다.</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">휴대폰 번호<span class="required"></span></th>
                                        <td colspan="3">
                                            <div class="form_group w300">
                                                <input type="text" id="memPhone" class="form_control" placeholder="휴대폰 번호 입력"
                                                    name="memPhone" maxlength="11" onkeypress="numberonly();" onpaste="javascript:return false;"/>
                                            </div>
                                            <span class="info_ment" id="memPhoneText">‘-’ 없이 입력하세요.</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">회사 전화번호<span class="required"></span></th>
                                        <td colspan="3">
<!--                                             <div class="form_group"> -->
<!--                                                 <label for="se1">검색선택</label> -->
<!--                                                 <div class="select_group"> -->
<!--                                                     <select id="" title="select" class="form_control"> -->
<!--                                                         <option value="">선택</option> -->
<!--                                                         <option value="">02</option> -->
<!--                                                         <option value="">031</option> -->
<!--                                                     </select> -->
<!--                                                 </div> -->
<!--                                             </div> -->
                                            <div class="form_group w300">
                                                <input type="text" id="compPhone" class="form_control" placeholder="전화번호 입력"
                                                    name="compPhone" maxlength="11" onkeypress="numberonly();" onpaste="javascript:return false;"/>
                                            </div>
                                            <span class="info_ment" id="memCompPhoneText">‘-’ 없이 입력하세요.</span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <!-- //table_view -->
                            <h3 class="stitle m-t-30">회계 담당자 정보
                                <div class="form_group">
                                    <div class="check_inline">
                                        <label class="check_default">
                                        <input type="checkbox" name="" value="" id="sameChk">
                                        <span class="check_icon"></span>담당자 정보와 동일</label>
                                    </div>
                                </div>
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
                                                    name="compAcctName" maxlength="100"/>
                                            </div>
                                            <span class="" id="compAcctNameText"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">부서명<span class="required"></span></th>
                                        <td colspan="3">
                                            <div class="form_group w300">
                                                <input type="text" id="compAcctDept" class="form_control" placeholder="부서명 입력"
                                                    name="compAcctDept"  maxlength="100"/>
                                            </div>
                                            <span class="" id="compAcctDeptText"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">이메일 주소<span class="required"></span></th>
                                        <td colspan="3">
                                            <div class="form_group w300">
                                                <input type="text" id="compAcctEmail" class="form_control" placeholder="이메일 주소 입력"
                                                    name="compAcctEmail" maxlength="100"/>
                                            </div>
                                            <span class="info_ment" id="compAcctEmailText">입력하신 이메일로 승인 안내 및 서비스 관련 주요사항이 안내됩니다.</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">회사 전화번호<span class="required"></span></th>
                                        <td colspan="3">
<!--                                             <div class="form_group"> -->
                                                <!-- <label for="se1">검색선택</label> -->
<!--                                                 <div class="select_group"> -->
<!--                                                     <select id="" title="select" class="form_control"> -->
<!--                                                         <option value="">선택</option> -->
<!--                                                         <option value="">02</option> -->
<!--                                                         <option value="">031</option> -->
<!--                                                     </select> -->
<!--                                                 </div> -->
<!--                                             </div> -->
                                            <div class="form_group w300">
                                                <input type="text" id="compAcctPhone" class="form_control" placeholder="전화번호 입력"
                                                    name="compAcctPhone" maxlength="11" onkeypress="numberonly();" onpaste="javascript:return false;"/>
                                            </div>
                                            <span class="info_ment" id="compPhoneText">‘-’ 없이 입력하세요.</span>
                                        </td><!---->
                                    </tr>
                                </table>
                            </div>
                            <!-- //table_view -->
                            <h3 class="stitle m-t-30">서비스 및 시설 이용 관련 정보</h3>
                            <!-- table_view -->
                            <div class="tbl_wrap_view m-t-15">
                                <table class="tbl_view01" summary="테이블입니다.">
                                    <caption>테이블입니다.</caption>
                                    <colgroup>
                                        <col width="180px;" />
                                        <col width="" />
                                    </colgroup>
                                    <tr>
                                        <th scope="row">가입목적<span class="required"></span></th>
                                        <td colspan="3">
                                            <div class="form_group w610">
                                                <textarea name="memPurpose" id="memPurpose" cols="" rows="5" class="form_control"
                                                    placeholder="예) 자동차 브레이크 관련 부품 연구 개발 기업으로 타이어 브레이크 제동 부품 제작을 위한 테스트 및 평가를 위해서 가입 등 시험평가 요소 에 따른 서비스 가입 목적 기재"></textarea>
                                            </div>
                                            <div class="count_txt w610"><span id="memPurposeCnt">0</span> / 500 bytes</div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
<!--                             <h3 class="stitle m-t-30">주사용 트랙</h3> -->
<!--                             table_view -->
<!--                             <div class="tbl_wrap_view m-t-15"> -->
<!--                                 <table class="tbl_view01" summary="테이블입니다."> -->
<!--                                     <caption>테이블입니다.</caption> -->
<!--                                     <colgroup> -->
<!--                                         <col width="180px;" /> -->
<!--                                         <col width="" /> -->
<!--                                     </colgroup> -->
<!--                                     <tr> -->
<!--                                         <th scope="row">기획 확인 필요<span class="required"></span></th> -->
<!--                                         <td colspan="3"> -->
<!--                                             <div class="form_group w610"> -->
<!--                                             </div> -->
<!--                                         </td> -->
<!--                                     </tr> -->
<!--                                 </table> -->
<!--                             </div> -->
<!--                             //table_view -->
                            <!-- button -->
                            <input type="hidden" value="N" id="memAgreement" name="memAgreement">
                            <section class="tac m-t-50">
                                <button type="button" class="btn btn_gray m-r-11" onclick="goLogin();">이전</button>
                                <button type="button" class="btn btn_default" onclick="register();">저장</button>
                            </section>
                            <!-- //button -->
						</div>
                        </form>
						<!-- //tab3 -->
                    </div>
                </div>
                <!-- //tab -->
            </div>
            <!-- //content -->
        </div>
        <!-- //container -->
<!-- popup_m -->
<div class="due ly_group">
    <article class="layer_m id_check">
        <!-- # 타이틀 # -->
       <h1>아이디 중복확인</h1>
       <!-- # 컨텐츠 # -->
       <div class="ly_con">
       <input type="hidden" value="" id="hiddenId">
           <div class="box_poptxt01" id="memIdPop"><span>”neonexsoft 123”</span> 아이디(ID)는<br />사용하실 수 있습니다.
               <div class="m-t-20"><button type="button" class="btn-line btn_gray m-r-11" id="idUse">사용하기</button></div>
           </div>
           <div class="box_poptxt01_2 m-t-20">
               다른 아이디를 사용하시려면<br />아래 다른 아이디를 입력하고 중복확인을 클릭해 주세요
               <div class="m-t-10">
                   <div class="form_group w200">
                       <input type="text" id="newIdPop" class="form_control" placeholder="아이디 입력" name="" />
                   </div>
<!--                    <button type="button" class="btn-line btn_gray" id="newDueChk">중복확인</button> -->
					<button type="hidden" data-layer="id_check"></button>
                   <button type="button" class="btn-line btn_gray" id="newDueChk">중복확인</button>
               </div>
           </div>
       </div>
       <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_m -->

<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>
