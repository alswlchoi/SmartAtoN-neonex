//bar ajax실행중 progressbar 실행
function postAjax(uri, param, success, error, errorMessage, successParam) {
    var csrfHeader = $('meta[name="_csrf_header"]').attr('content');
    var csrfToken = $('meta[name="_csrf"]').attr('content');

    $.ajax({
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(param),
        url: uri,
        dataType: "json",
        //async : false, //nonblocking
        beforeSend: function(xhr) {
            xhr.setRequestHeader("AJAX", true);
            xhr.setRequestHeader(csrfHeader, csrfToken);
            xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
            xhr.setRequestHeader("Content-type","application/json");
        },
        success: function(data) {
            if (typeof (success) == 'undefined') {
            }else if (typeof (success) == 'function') {
                success(data);
            }else {
                var funcCall = success + "(data, successParam);";
                if(success != null){
                    var ret = eval(funcCall);
                    ret;
                }
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
            if (error==null || typeof (error) == 'undefined') {
                if (typeof (errorMessage) == 'undefined') {
//                    PostProcessError(jqXHR);
                	alert(jqXHR);
                }else{
                    if (errorMessage!=null ) {
                      alert(errorMessage + '중 에러가 발생했습니다.2');
                    }
                }
                return false;
            }
            else {
                var funcCall = error + "(jqXHR);";
                var ret = eval(funcCall);
                ret;
            }
        }
    });
}
//test
function test(){
	alert("test");
}