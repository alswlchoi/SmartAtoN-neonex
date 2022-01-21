<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<script src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript">
//첨부파일 배열
var content_files = new Array();

//파일 부분 삭제 함수
function delFileInput(fileNum){
  var no = fileNum.replace(/[^0-9]/g, "");
  content_files[no].is_delete = true;
	$('#' + fileNum).remove();
	fileCount --;
  // console.log(content_files);
}

$(document).ready(function(){
	$(document).on("click",'.listBtn' ,function(){
		location.href="/admin/notice?nType=${nType}&pageNo=${pageNo}";
	});
	
	fileNum = 1;
	$('#addfile').click(function() {
        var fileIndex = $('#fileview').children().length;
        var fileHtml = '';
        fileHtml += '<li id="'+fileNum+'" style="padding-bottom:3px">';
        fileHtml += '	<div class="form_group w260">';
        fileHtml += '		<input type="text" id="nFile'+fileNum+'" class="form_control" placeholder="첨부파일 선택" />';
        fileHtml += '		<input type="file" id="nFileS'+fileNum+'" name="nFile" placeholder="첨부파일 선택" onchange="javascript:document.getElementById(\'nFile'+fileNum+'\').value=this.value"';
        fileHtml += '		style="display:none" />';
        fileHtml += '	</div>';
        fileHtml += '	<div style="display:inline">';
        fileHtml += '		<button type="button" id="regNfile'+fileNum+'" class="regNfile btn-line-bs btn_gray">파일첨부</button>';
        fileHtml += '	</div>';
        fileHtml += '</li>';
        $('#fileview').append(fileHtml);
        fileNum++;
    }); 

	//등록/수정버튼 이벤트
	$("#regBtn").click(function(){
		
		var form = $("form")[0];        
		var formData = new FormData(form);
		
		if($("#nTitle").val()==""){
			$("#errnTitle").text("제목을 입력해 주세요.")
			.addClass("redfont").css({"color":"red"})
			.addClass("info_ment");
			$("#nTitle").focus();
			return false;
		}
		var nContent = CKEDITOR.instances.nContent.getData();
		if(nContent==""){
			$("#errnContent").text("내용을 입력해 주세요.").css({"color":"red"})
			.addClass("redfont")
			.addClass("info_ment");
			$("#nContent").focus();
			return false;
		}
		
		

		var form = $("form")[0];
		var formData = new FormData(form);
		formData.append("nContent", nContent);

		for (var x = 0; x < content_files.length; x++) {
			// 삭제 안한것만 담아 준다. 
			if(!content_files[x].is_delete){
				 formData.append("nFile", content_files[x]);
			}
		}
		
		/* FormData의 key 확인
		for (let key of formData.keys()) {
		  console.log(key);
		}

		// FormData의 value 확인
		for (let value of formData.values()) {
		  console.log(value);
		}
		*/
		$.ajax({
			url : "/admin/notice/fileupload/insert-notice",
			type: "post",
   	   		enctype: "multipart/form-data",
            processData : false,
            contentType : false,
			data : formData,
			success : function(resdata){
				if(resdata.code == 400){
					alert(resdata.message);
				}else{
					location.href="/admin/notice?nType=${nType}";
				}
			},
			error : function(e){
				console.log(e);
			}
		});
	});	

	$("#nTitle").keyup(function(){
		if($("#nTitle").val()=="") {
			$("#errnTitle").text("제목을 입력해 주세요.").css({"color":"red"})
			.addClass("info_ment");
		}else{
			$("#errnTitle").text("")
			.removeClass("redfont")
			.removeClass("info_ment");	
		}
	});
	
	$("#nContent").keyup(function(){
		if(nContent=="") {
			$("#errnContent").text("내용을 입력해 주세요.").css({"color":"red"})
			.addClass("info_ment");
		}else{
			$("#errnContent").text("")
			.removeClass("redfont")
			.removeClass("info_ment");	
		}
	});

	//var nContent = CKEDITOR.instances.nContent.getData();
	//$("input[id^=nFileS]").change(function(){
	$(document).on("change","input[id^=nFileS]",function(){

		var num = $(this).prop("id").replace("nFileS", "");
		$("#nFile"+num).val($("#nFileS"+num).val());
		//파일 명 체크
		var ext = $('#nFile'+num).val().split('.').pop().toLowerCase();
		
		if($.inArray(ext, ['txt','png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
			$("#errnFile").text('txt,png,jpg,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
			$("#errnFile").addClass("redfont");
			$("#nFile"+num).val("");
			return;
		}else{
			$("#errnFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (txt, png, jpg, jpeg, bmp, tiff ,tif, pdf만 가능)");
			$("#errnFile").removeClass("redfont");
		}
		var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
	    if(pattern.test(document.getElementById("nFileS"+num).files[0].name)){
	    	$("#errnFile").text('파일명에 특수문자를 제거해주세요.');
			$("#errnFile").addClass("redfont");
			$("#nFile"+num).val("");
			return;
	    }else{
	    	$("#errnFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (txt, png, jpg, jpeg, bmp, tiff ,tif, pdf만 가능)");
			$("#errnFile").removeClass("redfont");
	    }
	    //파일 사이즈 체크
	    var fileSize = document.getElementById("nFileS"+num).files[0].size;
	    // console.log(num+" filesize : " + fileSize);
	    var maxSize = 5 * 1024 * 1024;//3MB
	    if(fileSize > maxSize){
	    	$("#errnFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
			$("#errnFile").addClass("redfont");
			$("#nFile"+num).val("");
			return;
	     }else{
	    	$("#errnFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (txt, png, jpg, jpeg, bmp, tiff ,tif, pdf만 가능)");
	 		$("#errnFile").removeClass("redfont");
	     }		
	});
});	

//조회값 undefined -> 공백 처리
function undefinedChk(str1,str2){
	if(typeof str1 =="undefined"){
		return str2;
	}else{
		return str1;
	}
}

$(document).on("click",'.regNfile' ,function(){	
	var num = $(this).prop("id").replace("regNfile", "");
	$("#nFileS"+num).click();
});
</script>
        <!-- container -->
        <div id="container">
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>컨텐츠관리</span><c:if test="${nType!='s' }">공지사항</c:if><c:if test="${nType=='s' }">자료실</c:if>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title"><c:if test="${nType!='s' }">공지사항</c:if><c:if test="${nType=='s' }">자료실</c:if></h2>
                <!-- //title -->
				
				<div id="data_area" class="form_content form_group_wrap">
					<form name="form" id="form" method="post" action="/admin/notice/fileupload/insert-notice" enctype="multipart/form-data">
					<input type="hidden" name="pageNo" id="pageNo" value="${pageNo }" />
					<input type="hidden" name="nType" id="nType" value="${nType}" />
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					<!-- table_view -->
	                <section class="tbl_wrap_view">
	                    <table class="tbl_view01" summary="테이블입니다.">
	                        <caption>테이블입니다.</caption>
	                        <colgroup>
	                            <col width="180px;" />
	                            <col width="55%" />
	                            <col width="180px;" />
	                            <col width="" />
	                        </colgroup>
	                        <tr>
	                            <th scope="row">제목</th>
	                            <td>
	                                <div class="form_group w_full">
	                                    <input type="text" id="nTitle" class="form_control" placeholder="제목 입력" name="nTitle" />
	                                </div>
	                                <div id="errnTitle"></div>
	                            </td>
	                            <th>노출여부</th>
	                            <td>
	                                <div class="form_group">
	                                    <div class="radio_inline">
	                                        <label class="radio_default">
	                                            <input type="radio" name="nTop" id="nTopY" value="Y" checked="checked" />
	                                            <span class="radio_icon"></span>노출</label>
	                                        <label class="radio_default">
	                                            <input type="radio" name="nTop" id="nTopY" value="N" />
	                                            <span class="radio_icon"></span>미노출</label>
	                                    </div>
	                                </div>
	                            </td>
	                        </tr>
	                        <tr>
	                            <th scope="row">내용</th>
	                            <td colspan="3">
	                                <div class="form_group w_full">
	                                    <textarea name="" id="nContent" cols="" rows="5" class="form_control h500"
	                                        placeholder="공지사항 내용 입력"></textarea>
	                                </div>
	                                <div id="errnContent"></div>
	                            </td>
	                        </tr>
	                        <tr>
	                            <th scope="row">첨부파일</th>
	                            <td colspan="3">
	                                <section>
	                                	<ul class="list_test01" id="fileview">
                                            <li id="li0" style="padding-bottom:3px">
			                                    <div class="form_group w260">
			                                        <input type="text" id="nFile0" class="form_control" placeholder="첨부파일 선택" />
			                                        <input type="file" id="nFileS0" name="nFile" placeholder="첨부파일 선택" onchange="javascript:document.getElementById('nFile0').value=this.value"
		                                        	style="display:none" />
		                                        </div>
			                                    <button type="button" id="regNfile0" class="regNfile btn-line-bs btn_gray">파일첨부</button>
			                                    &nbsp;<button type="button" name="addfile" id="addfile" class="btn-line-bs btn_red">파일추가</button>
                                            </li>
                                        </ul>
	                                </section>
                                    <section class="m-t-5">
                                        <span id="errnFile" class="info_ment m-l-0">5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg,
                                            bmp, tiff,tif, pdf만 가능)</span>
                                    </section>
	                            </td>
	                        </tr>
	                    </table>
	                </section>
	                <!-- //table_view -->
	                <!-- button -->
	                <section class="btn_wrap m-t-50">
	                    <button type="button" class="btn btn_gray listBtn">목록</button>
	                    <section>
	                        <button type="button" class="btn btn_gray m-r-6 listBtn">취소</button>
	                        <button type="button" id="regBtn" class="reg btn btn_default">저장</button>
	                    </section>
	                </section>
	                <!-- //button -->
					</form>
				</div>				
            </div>
            <!-- //content -->
        </div>
        <!-- //container -->
		<script type="text/javascript">
		//<![CDATA[
			CKEDITOR.replace('nContent',
					{filebrowserUploadUrl:'<c:url value="/ckeditor/fileupload" />?${_csrf.parameterName}=${_csrf.token}'} ); //]]>
		</script>
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>