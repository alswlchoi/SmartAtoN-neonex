$(function() {
    $(document).keypress(function(event){
        if ( event.which == 13 ) {
            $('#registerBtn').click();
        }
    });
});

function register() {
	/////////////로그인정보//////////////
	if($("#memId").val().trim().length==0){
		alert("아이디를 입력해 주세요.");
		$("#memId").focus();
		return;
	}
	var regId = /^[A-Za-z0-9]{5,12}$/;
	if(!regId.test($("#memId").val().trim())){
		alert("아이디는 5~12자 영문자,숫자로 입력해 주세요.");
		$("#memId").focus();
		return;
	}
	if(!$("#dueYn").prop("checked")){
		alert("아이디 중복확인을 해주세요.");
		return;
	}
	var regPwd = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$/;
	if(!regPwd.test($("#memPwd").val())){//비밀번호는 공백도 한칸 차지이므로 trim 제거
		alert("비밀번호는 8~16자 영문자,숫자 및 특수문자 조합으로 입력해주세요.");
		$("#memPwd").focus();
		return;
	}
	if($("#memPwd").val().length==0){
		alert("비밀번호를 입력해 주세요.");
		$("#memPwd").focus();
		return;
	}
	if($("#memPwdChk").val().length==0){
		alert("비밀번호를 입력해 주세요.");
		$("#memPwdChk").focus();
		return;
	}
	if($("#memPwd").val() != $("#memPwdChk").val()){
		alert("비밀번호를 확인해 주세요.");
		$("#memPwdChk").focus();
		return;
	}
	/////////////사업자정보//////////////
	if($("#compLicense").val().trim().length==0){
		alert("사업자 등록번호는 ‘-” 없이  10자 숫자로 입력해 주세요.");
		$("#compLicense").focus();
		return;
	}
	if(!$("#compLicenseDueYn").prop("checked")){
		alert("사업자 등록번호를 확인해 주세요.");
		return;
	}
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
	if(!$("#dueEmailYn").prop("checked")){
		alert("이메일 중복확인을 해주세요.");
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
	/////////////서비스 및 시설 이용 관련 정보//////////////
	if($("#memPurpose").val().length==0){
		alert("가입목적을 입력해 주세요.");
		$("#memPurpose").focus();
		return;
	}
	var csrfHeader = $('meta[name="_csrf_header"]').attr('content');
	var csrfToken = $('meta[name="_csrf"]').attr('content');
	var newForm = new FormData($("#fileForm")[0]);
	$.ajax({
		url : '/member/fileUpload/join',
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
		        alert2("가입 신청이 완료 되었습니다.","신청하신 정보에 대해 담당자 검토/승인 완료 후<br/>등록한 담당자 이메일로 알려드립니다.","메인화면으로 이동","goHome");
		        $("button[data-fn='lyClose']").click(function(){
					location.href="/login";
				});
		    }else if(data.result == -99){
		    	alert("회원사 가입 간 에러 발생");
		    }else if(data.result == -98){
	    		alert("회원 가입 간 에러 발생");
		    }else if(data.result == -97){
	    		alert("파일 업로드 간 에러 발생");
		    }else{
		    	alert("시스템 에러 발생<br/>관리자에게 문의해 주세요.");
		    }
		},error : function(data){
			console.log(data);
		}
	})
//    var data = {
//    		//로그인정보
//    		memId : $("#memId").val().trim(),
//    		memPwd : $("#memPwd").val(),
//    		//사업자 및 담당자 정보
//    		compLicense : $("#compLicense").val().trim(),
//    		compName : $("#compName").val().trim(),
//    		compAddr : $("#compAddr").val(),
//    		compPostNo : $("#compPostNo").val(),
//    		compAddrDetail : $("#compAddrDetail").val(),
//    		//파일업로드는 따로
//    		memName : $("#memName").val().trim(),
//    		memDept : $("#memDept").val().trim(),
//    		memEmail : $("#memEmail").val().trim(),
//    		memPhone : $("#memPhone").val().trim(),
//    		compPhone : $("#memCompPhone").val().trim(),
////    		memCompPhone : $("#memCompPhone").val().trim(),
//    		//회계 담당자 정보
//    		compAcctName : $("#compAcctName").val().trim(),
//    		compAcctDept : $("#compAcctDept").val().trim(),
//    		compAcctEmail : $("#compAcctEmail").val().trim(),
//    		compAcctPhone : $("#compPhone").val().trim(),
//    		//서비스 및 시설 이용 관련 정보
//    		memPurpose : $("#memPurpose").val(),
//    		//약관동의
//    		memAgreement : $("#memAgreement").val()
//    		};
//
//    postAjax("/member/join",data,"successRegister","failRegister",null,null);
}

//등록 성공 callback
//function successRegister(data) {
//    if(data.result == "OK") {
//    	$("#compLicenseHidden").val(data.member.compLicens);
//    	fileUpload();
////        alert2("가입 신청이 완료 되었습니다.","신청하신 정보에 대해 담당자 검토/승인 완료 후<br/>등록한 담당자 이메일로 알려드립니다.","메인화면으로 이동","goHome");
//    }else {
//    	if(data.result =="MEMBER_ERROR"){
//    		alert("회원 가입 간 에러 발생");
//    	}else{
//    		alert("회원사 가입 간 에러 발생");
//    	}
//    }
//	//파일업로드도 추가
//}
//등록 실패 callback
//function failRegister(xhr) {
//	alert("등록에 실패하였습니다.<br/>관리자에게 문의해주세요.");
//    console.log(xhr.responseText);
//}

function srhBusinessApi(no){
	if(!checkCorporateRegistrationNumber(no)){
		alert("유효하지 않은 사업자 등록번호 입니다.");
		return;
	}
	var param = {
		b_no :[no]
	};
	postAjax("/member/companyApi",param,"apiCallBack",null,null,null);
}
function apiCallBack(data){//1138189974 네오넥스//	2208162517 네이버//1208665164 구글
	console.log(data);
	if(data.cnt>0){
		alert("이미 등록된 사업자 등록번호 입니다.");
		$("#compLicenseDueYn").prop("checked",false);
		$("#licenseBtn").css("color","#333");//#333 #ec6608
	}else{
		var apiData = JSON.parse(data.apiData);
		if(apiData.data[0].b_stt_cd=="01"){
			alert("등록 가능한 사업자 등록번호 입니다.");
			$("#compLicenseDueYn").prop("checked",true);
			$("#licenseBtn").css("color","#ec6608");//#333 #ec6608
		}else{
			alert("사업자 등록번호를 다시 확인해 주세요.");
			$("#compLicenseDueYn").prop("checked",false);
			$("#licenseBtn").css("color","#333");//#333 #ec6608
		}
	}
}

function checkCorporateRegistrationNumber(value) {
    var valueMap = value.replace(/-/gi, '').split('').map(function(item) {
        return parseInt(item, 10);
    });

    if (valueMap.length === 10) {
        var multiply = new Array(1, 3, 7, 1, 3, 7, 1, 3, 5);
        var checkSum = 0;

        for (var i = 0; i < multiply.length; ++i) {
            checkSum += multiply[i] * valueMap[i];
        }

        checkSum += parseInt((multiply[8] * valueMap[8]) / 10, 10);
        return Math.floor(valueMap[9]) === (10 - (checkSum % 10));
    }

    return false;
}
