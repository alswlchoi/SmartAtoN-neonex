$(function() {
    $(document).keypress(function(event){
        if ( event.which == 13 ) {
            $('#loginbtn').click();
        }
    });
});

function login(e) {
    var id = $("input[name='memId']").val().trim();
    var password = $("input[name='memPwd']").val().trim();
    var data = {"memId" : id, "memPwd" : password};

    postAjax("/api/login",data,"successLogin","failLogin",null,null);
}

function successLogin(data) {
    console.log(data);
    if(data == 'A001') {
        window.location = '/system';
    }
    if(data =='A002') {
        window.location = '/member';
    }
}

function failLogin(xhr) {
    if(xhr.status =='401') {
        alert(xhr.responseText);
    }
    if(xhr.status == '403') {
        alert("권한이 없습니다.");
    }
}