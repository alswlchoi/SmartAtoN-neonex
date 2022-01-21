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
    var data = {"memId" : id, "memPwd" : password,"checkbox":$("input[name=cookie]:checked").val()};

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
    var defaultUrl = data.split(",")[2];//이동할 url
    if(authCode == 'A000' || authCode == 'A002') {
    	alert("외부 회원은 사용자 페이지에서 로그인 해 주시길 바랍니다.");
		$(".lyClose").click(function(){
			location.href="/logout";
		})
    }else{
    	//초기 비밀번호 일경우

    	//최종 변경일 기간 체크
    	if(moment.duration(t1.diff(t2)).asDays()>90){
    		alert("비밀번호를 변경한지 90일이 경과되어<br/>소중한 개인정보보호를 위하여<br/>비밀번호를 변경하시기 바랍니다.");
    		$(".lyClose").click(function(){
    			//비밀번호 변경 페이지로 이동
    			location.href="/member/adminPwdModify";
    		})
    	}else{
//    		window.location = '/system';
    		window.location = defaultUrl;
    	}
    }
}

function failLogin(xhr) {
    if(xhr.status =='401') {
    	setTimeout(function(){
    		alert(xhr.responseJSON);
    	},10);
    }
    if(xhr.status == '403') {
    	setTimeout(function(){
    		alert("권한이 없습니다.");
    	},10);
        $(".lyClose").click(function(){
			location.href="/adminLogin";
		})
    }
    if(xhr.status =='404') {
    	setTimeout(function(){
    		alert("아이디 혹인 비밀번호가 잘못 되었습니다.");
    	},10);
		$(".lyClose").click(function(){
			location.href="/adminLogin";
		})
    }
}