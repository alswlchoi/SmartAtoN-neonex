$(function() {
	$("input[type='password']").keypress(function(event){
        if ( event.which == 13 ) {
            $('#loginbtn').click();
            $("input[type='text']").focus();
        }
    });
});

function login(e) {
    var id = $("input[name='memId']").val().trim();
    if(id.length==0){
		alert("아이디를 입력해 주세요.");
		return;
	}
    var password = $("input[name='memPwd']").val().trim();
    if(password.length==0){
		alert("비밀번호를 입력해 주세요.");
		return;
	}
    var data = {"memId" : id, "memPwd" : password ,"checkbox":$("input[name=cookie]:checked").val()};
    postAjax("/api/login",data,"successLogin","failLogin",null,null);
}

function successLogin(data) {
	if($("input[name=cookie]").prop("checked")){
		setCookie("userId",$("input[name='memId']").val().trim(),30);//30일 쿠키보관
	}else{
		deleteCookie("userId");
	}
    var authCode = data.split(",")[0];
    var t2 = moment(data.split(",")[1],'YYYYMMDDHHmmss');//변경날짜
    var t1 = moment();//현재시간
    var useYN = data.split(",")[3];
    if(useYN =="N" || useYN ==""){
    	//뒤에서도 처리 해주고 있음
    	alert("관리자의 요청으로 계정 중지되었습니다.<br>해제를 원하시면 관리자에게 직접 문의해주세요.");
    	$(".lyClose").click(function(){
    		location.href="/logout";
    	})
    	return;
    }
    if(authCode != 'A000' && authCode != 'A002') {
    	alert("아이디 혹인 비밀번호가 잘못 되었습니다.");
		$(".lyClose").click(function(){
			location.href="/logout";
		})
		//2021-10-06 관리자 로그인 시 ID PWD 틀렸다고 알림
//		alert("관리자는 관리자 페이지에서 로그인 해 주시길 바랍니다.");
//		$(".lyClose").click(function(){
//			location.href="/adminLogout";
//		})
    }
    if(authCode=='A002') {
    	if(moment.duration(t1.diff(t2)).asDays()>90){
    		alert("비밀번호를 변경한지 90일이 경과되어<br/>소중한 개인정보보호를 위하여<br/>비밀번호를 변경하시기 바랍니다.");
    		$(".lyClose").click(function(){
    			//비밀번호 변경 페이지로 이동
    			location.href="/user/modifyPwd";
    		})
    	}else{
    		window.location = '/';
    	}
    }
    if(authCode =='A000') {
    	alert("가입승인 대기중인 아이디입니다.");
    	$(".lyClose").click(function(){
			location.href="/login";
		})
    }
    if(authCode =='A999') {
    }
}

function failLogin(xhr) {
    if(xhr.status =='401') {
    	var errMsg = xhr.responseJSON;
        alert(errMsg);
    }
    if(xhr.status == '403') {
        alert("권한이 없습니다.");
        $(".lyClose").click(function(){
			location.href="/login";
		})
    }
    if(xhr.status =='404') {
    	alert("아이디 혹인 비밀번호가 잘못 되었습니다.");
		$(".lyClose").click(function(){
			location.href="/logout";
		})
    }
}