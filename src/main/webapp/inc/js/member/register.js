$(function() {
    $(document).keypress(function(event){
        if ( event.which == 13 ) {
            $('#registerBtn').click();
        }
    });
});

function register() {
    var id = $("input[name='memId']").val().trim();
    var password = $("input[name='memPwd']").val().trim();
    var name = $("input[name='memName']").val().trim();
    var phone = $("input[name='memPhone']").val().trim();
    var email = $("input[name='memEmail']").val().trim();
    var data = {"memId" : id, "memPwd" : password, "memName" : name ,"memPhone" : phone, "memEmail" : email};

    postAjax("/member/register",data,"successRegister","failRegister",null,null);
}

function successRegister(data) {
    if(data>0) {
        alert("회원 가입 완료");
        window.location = "/login";
    }else {
        alert("회원 가입 간 에러 발생");
    }
}

function failRegister(xhr) {
    alert(xhr.responseText);
}