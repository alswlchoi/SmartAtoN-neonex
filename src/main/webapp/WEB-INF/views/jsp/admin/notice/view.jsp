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
  console.log(content_files);
}

function fileDelete(fSeq){
	var con = confirm("삭제된 파일은 파일을 삭제하시겠습니까?");
	var delLi = $(this).parent();
	alert(delLi.prop("tagName"));
	$("#confirmTrue").click(function(){
		$.ajax({
			url : "/admin/notice/delete-file",
			type : "get",
			data : {
				"fSeq" : fSeq
			},
			success : function(resdata){
				alert(delLi.prop("tagName"));
				delLi.remove();
			},
			error : function(e){
				console.log(e);
			}
		});
	});
}

$(document).ready(function(){
	$("#data_area").hide();	//페이지 로딩시 등록/수저폼 가림

	$("#search").keydown(function(key) {
		if (key.keyCode == 13) {
			search("button");
		}
	});	

	$("#searchBtn").click(function(){
		search("button");
	});
	
	//daterangepiker start
	$("#nRegStDt").daterangepicker({
	    locale: {
	    "separator": " ~ ",                     // 시작일시와 종료일시 구분자
	    "format": 'YYYY-MM-DD',     // 일시 노출 포맷
	    "applyLabel": "확인",                    // 확인 버튼 텍스트
	    "cancelLabel": "취소",                   // 취소 버튼 텍스트
	    "daysOfWeek": ["일", "월", "화", "수", "목", "금", "토"],
	    "monthNames": ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
	    },
	    timePicker: false,                        // 시간 노출 여부
	    showDropdowns: true,                     // 년월 수동 설정 여부
	    autoApply: true,                         // 확인/취소 버튼 사용여부
	    timePicker24Hour: false,                  // 24시간 노출 여부(ex> true : 23:50, false : PM 11:50)
	    timePickerSeconds: false,                 // 초 노출 여부
	    singleDatePicker: false,                   // 하나의 달력 사용 여부
	});
	//daterangepiker end

	
	$(document).on("click",'.listBtn' ,function(){
		$("#data_area").hide();
		search("list");
	});

	$(document).on("click",'.godetail' ,function(){
		var currentRow=$(this).closest('tr');
		var pageNo;
		var nSeq = currentRow.find('td span').text();
		pageNo = $(".pageNo.on").attr("data-page");
		$("#pageNo").html(pageNo);
		
		$.ajax({
			url : "/admin/notice/detail-notice",
			type : "get",
			data : {
				"nSeq" : nSeq
			},
			success : function(resdata){
				drawingDetailTable(resdata);
			},
			error : function(e){
				console.log(e);
			}
		});
	});
	fileNum = 1;
	$('#addfile').click(function() {
        var fileIndex = $('#fileview').children().length;
        var fileHtml = '';
        fileHtml += '<div class="form_group w260">';
        fileHtml += '<input type="text" id="nFile'+fileNum+'" class="form_control" placeholder="첨부파일 선택" />';
        fileHtml += '<input type="file" id="nFileS'+fileNum+'" name="nFile" placeholder="첨부파일 선택" onchange="javascript:document.getElementById(\'nFile'+fileNum+'\').value=this.value"';
        fileHtml += 'style="display:none" onchange="fileCng();" />';
        fileHtml += '</div>';
        fileHtml += '<button type="button" id="regNfile'+fileNum+'" class="regNfile btn-line-bs btn_gray">파일첨부</button>';
        $('#fileview').append(fileHtml);
        fileNum++;
    });  
	
	//데이터 삭제
	$(document).on("click",'.delButton' ,function(){

		var currentRow=$(this).closest('tr');
		var nSeq = currentRow.find('td:eq(0)').text();

		var result = confirm("정보를 삭제하시겠습니까?");
		if(result){
			$.ajax({
				url : "/admin/notice/delete-notice",
				type : "get",
				data : {
					"nSeq":nSeq
				},
				success : function(resdata){
					if(resdata.code == 400){
						alert(resdata.message);
					}else{
						alert(resdata.message);
					}
				},
				error : function(e){
					console.log(e);
				}
			});
		}	
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
		
		
		if($(this).hasClass("reg")){
			var form = $("form")[0];
			var formData = new FormData(form);
			formData.append("nContent", nContent);
			console.log(nContent);
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
				type: "POST",
	   	   		enctype: "multipart/form-data",
	            processData : false,
	            contentType : false,
				data : formData,
				success : function(resdata){
					if(resdata.code == 400){
						alert(resdata.message);
					}else{
						$("#data_area").hide();
						search("list");
						alert(resdata.message);
					}
				},
				error : function(e){
					console.log(e);
				}
			});
				
		}else if($(this).hasClass("upd")){
			var nseq = $("#currentNSeq").val();
			formData.append("nSeq", nseq); 
			for (var x = 0; x < content_files.length; x++) {
				// 삭제 안한것만 담아 준다. 
				if(!content_files[x].is_delete){
					 formData.append("nFile", content_files[x]);
				}
			}
			
	  		$.ajax({
	 			url : "/admin/notice/update-notice",
	 			type : "POST",
	   	   		enctype: "multipart/form-data",
	            processData : false,
	            contentType : false,
				data : formData,
	 			success : function(resdata){
	 				if(resdata.code == 400){
	 					alert(resdata.message);
	 				}else{
	 					alert(resdata.message);
		 				location.reload();
	 				}
	 			},
	 			error : function(e){
	 				console.log(e);
	 			}
	 		});
		}
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
	$("input[name=nFile]").change(function(){

		var num = $(this).prop("id").replace("nFileS", "");
		$("#nFile"+num).val($("#nFileS"+num).val());
		//파일 명 체크
		var ext = $('#nFile'+num).val().split('.').pop().toLowerCase();
		alert("ext : " + ext);
		if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
			$("#errnFile").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
			$("#errnFile").addClass("redfont");
			return;
		}else{
			$("#errnFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
			$("#errnFile").removeClass("redfont");
		}
		var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
	    if(pattern.test(document.getElementById("hiddenFileType").files[0].name)){
	    	$("#errnFile").text('파일명에 특수문자를 제거해주세요.');
			$("#errnFile").addClass("redfont");
			return;
	    }else{
	    	$("#errnFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
			$("#errnFile").removeClass("redfont");
	    }
	    //파일 사이즈 체크
	    var fileSize = document.getElementById("hiddenFileType").files[0].size;
	    var maxSize = 5 * 1024 * 1024;//3MB
	    if(fileSize > maxSize){
	    	$("#errnFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
			$("#errnFile").addClass("redfont");
			return;
	     }else{
	    	$("#errnFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
	 		$("#errnFile").removeClass("redfont");
	     }		
	});
});	

//등록 form 초기화
function reginit(){	
	$("#updBtn").text("등록");
	$("#updBtn").removeClass("upd");
	$("#updBtn").addClass("reg");
	$("#updBtn").attr("data-branchCode","");
	$("#updBtn").attr("id","regBtn");	
	$("#nSeq").val("");
	$("#compLicense").val("");
	$("#compPhone").val("");
	$("#compTel").val("");
	$("#compRegUser").val("");
}

//페이지 버튼 클릭
$(document).on("click",".pageNo",function(){  
	$(this).siblings().removeClass("on");
	$(this).addClass("on");
	
	if($(this).attr("data-page")==1){
		$(".pg_first").hide();
		$(".pg_prev").hide();
	}else{
		$(".pg_first").show();
		$(".pg_prev").show();
	}

	search("paging");

});

function search(type){
	var pageNo;
	var nTitle = $("#schTitle").val();
	var nTop = []; 
	$("input[name='schTop']:checked").each(function(i) {
		nTop.push($(this).val());
	});
	var nRegStDt = $("#nRegStDt").val();

	if(type == "button"){//버튼 검색 
		pageNo = "1";
	}else if(type == "list") {//목록 버튼
		pageNo = $("#pageNo").text();
		$("#data_detail").hide();
	}else if(type == "paging"){//페이징 검색
		pageNo = $(".pageNo.on").attr("data-page"); 
	}

	if(pageNo==""){
		pageNo = "1";
	}
	$("#data_list").show();
	$.ajax({
		url : "/admin/notice/search-notice",
		type : "get",
		data : {
			"pageNo"  :pageNo,
			"nTop":nTop,
			"nTitle":nTitle,
			"nRegStDt":nRegStDt
		},
		success : function(resdata){
			drawingTable(resdata.rows, resdata.paging);
			drawingPage(resdata.paging);
		},
		error : function(e){
			console.log(e);
		}
	});
}

//숫자 콤마 설정

//조회값 undefined -> 공백 처리
function undefinedChk(str1,str2){
	if(typeof str1 =="undefined"){
		return str2;
	}else{
		return str1;
	}
}

//등록페이지로 이동
$(document).on("click",".goRegButton",function(){
	$("#data_list").hide();
	$("#data_area").show();
	
})

//상세보기로 이동
$(document).on("click",".onnn",function(){
	var currentRow=$(this).closest('tr');
	var pageNo;
	var nSeq = currentRow.find('td span').text();
	pageNo = $(".pageNo.on").attr("data-page");
	$("#pageNo").html(pageNo);
	
	$.ajax({
		url : "/admin/notice/detail-notice",
		type : "get",
		data : {
			"pageNo"  :pageNo,
			"nSeq":nSeq
		},
		success : function(resdata){
			drawingDetailTable(resdata);
			drawingFileInfo(resdata.file);
		},
		error : function(e){
			console.log(e);
		}
	});
});	

$(document).on("click",'.regNfile' ,function(){	
	var num = $(this).prop("id").replace("regNfile", "");
	$("#nFileS"+num).click();
});

//상세보기 테이블
function drawingDetailTable(resdata){
	$("#data_list").hide();
	$("#data_area").show();
	$("#currentNSeq").val(undefinedChk(resdata.notice.nseq,""));
	$("#nTitle").val(undefinedChk(resdata.notice.ntitle,""));
	var nContent = undefinedChk(resdata.notice.ncontent,"");
	var pattern = /upfiles\/editor/gi;
	nContent = nContent.replace(pattern, 'upfiles/editor?filename=');
	CKEDITOR.instances.nContent.setData(nContent);
	$("#regBtn").text("수정");
	$("#regBtn").removeClass("reg");
	$("#regBtn").addClass("upd");
	
	var html = '';
	
	for(var list in resdata.file){
		var fileUrl = "/admin/notice/fileupload/download/"+undefinedChk(resdata.file[list].fseq,"");
		html += '<li><a href="'+fileUrl+'">'+undefinedChk(resdata.file[list].fname,"")+'</a>';
		html += '<button onclick="javascript:fileDelete('+undefinedChk(resdata.file[list].fseq,"")+');return false;"></button></li>';
	}
	$(".attachfile_wrap").html(html);
}

//테이블 그리는 함수
function drawingTable(rows, paging){
	var html='';
	if(rows.length==0){
		html += '<tr class="tr_nodata">';
		html += '	<td colspan="5">등록된 정보가 없습니다.</td>';
		html += '</tr>';
	}else{
		for(var list in rows){
			html += '<tr onmouseover="this.className=\'on godetail\'" onmouseout="this.className=\'\'">';
			html += '<td><span style="display:none">'+undefinedChk(rows[list].nseq,"")+"</span>";
			html += paging.totalCount-(paging.pageNo-1)*paging.pageSize-list;
			html +='</td>';
			html += '<td>';
			if(undefinedChk(rows[list].ntop,"")=="Y") {
				html += '노출';
			}else{
				html += '미노출';
			}
			html += '</td>';
			html += '<td class="tal">'+undefinedChk(rows[list].ntitle,"")+'</td>';
			html += '<td>'+undefinedChk(rows[list].nregUser,"")+'</td>';
			var nregDt = "";
			if(rows[list].nregDt.length==14){
				nregDt += rows[list].nregDt.substring(0,4);
				nregDt += "-";
				nregDt += rows[list].nregDt.substring(4,6);
				nregDt += "-";
				nregDt += rows[list].nregDt.substring(6,8);
				nregDt += " ";
				nregDt += rows[list].nregDt.substring(8,10);
				nregDt += ":";
				nregDt += rows[list].nregDt.substring(10,12);
				nregDt += ":";
				nregDt += rows[list].nregDt.substring(12,14);
			}
			html += '<td>'+nregDt+'</td>';
			html += '</tr>';
		}
	}
	$("#tbody").html(html);
}

//테이블 그리는 함수
function drawingFileInfo(rows){
	var html='';
	console.log(rows);
	for(var list in rows){
		var fileUrl = "/admin/notice/download/"+undefinedChk(rows[list].fseq,"");
		html += undefinedChk(rows[list].fname,"")+'<a href="'+fileUrl+'">다운로드</a><br />';
	}
	$("#filelist").html(html);
}
</script>
        <!-- container -->
        <div id="container">
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>컨텐츠관리</span><span>공지사항</span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">공지사항</h2>
                <!-- //title -->
				
				<div id="data_area" class="form_content form_group_wrap">
					<form name="form" id="form" method="post" action="/admin/notice/fileupload/insert-notice" enctype="multipart/form-data">
					<input type="hidden" name="currentNSeq" id="currentNSeq" value="" />
					<input type="hidden" name="nType" id="nType" value="n" />
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
	                                    <div class="form_group w260">
	                                        <input type="text" id="nFile0" class="form_control" placeholder="첨부파일 선택" />
	                                        <input type="file" id="nFileS0" name="nFile" placeholder="첨부파일 선택" onchange="javascript:document.getElementById('nFile0').value=this.value"
                                        	style="display:none" onchange="fileCng();" />
	                                    </div>
	                                    <button type="button" id="regNfile0" class="regNfile btn-line-bs btn_gray">파일첨부</button>
	                                    &nbsp;<button type="button" name="addfile" id="addfile" class="btn-line-bs btn_red">파일추가</button>
	                                    <div class="form_group w260" id="fileview">
	                                    </div>
	                                    <section class="m-t-5">
	                                        <span id="errnFile" class="info_ment m-l-0">5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg,
	                                            bmp, tiff,tif, pdf만 가능)</span>
	                                    </section>
	                                </section>
	                                <section>
	                                    <ul class="attachfile_wrap">
	                                    </ul>
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
				<!-- 상세보기 시작 -->
				<div id="data_detail"></div>
				<!-- 상세보기 끝 -->
				<div id="data_list">
	                <!-- search_wrap -->
	                <section class="search_wrap">
	                    <div class="form_group w300">
	                        <input type="text" name="schTitle" id="schTitle" class="form_control" placeholder="제목 키워드 입력" />
	                    </div>                    
	                    <div class="form_group">                        
	                        <div class="check_inline">
	                            <span class="label">노출상태</span>
	                            <label class="check_default">
	                                <input type="checkbox" name="schTop" id="nTopY" value="Y" />
	                                <span class="check_icon"></span>노출</label>
	                            <label class="check_default">
	                                <input type="checkbox" name="schTop" id="nTopY" value="N" />
	                                <span class="check_icon"></span>미노출</label>
	                        </div>
	                    </div>
	                    <div class="form_group w230 m-l-6">
	                        <input type="text" id="nRegStDt" class="form_control dateicon datefromto"
	                            placeholder="등록기간 선택" name="" />
	                    </div>
	                    <button type="button" id="searchBtn" class="btn-s btn_default">조회</button>
	                </section>
	                <!-- //search_wrap -->
	                <!-- table list -->
	                <section class="tbl_wrap_list m-t-30">
	                    <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
	                        <caption>테이블</caption>
	                        <colgroup>
	                            <col width="80px" />
	                            <col width="10%" />
	                            <col width="" />
	                            <col width="20%" />
	                            <col width="20%" />
	                        </colgroup>
	                        <thead>
	                            <tr>
	                                <th scope="col">번호</th>
	                                <th scope="col">상태</th>
	                                <th scope="col">제목</th>
	                                <th scope="col">등록자</th>
	                                <th scope="col">등록일시</th>
	                            </tr>
	                        </thead>
	                        <tbody id="tbody">
								<c:if test="${empty noticeList}">
	                            <tr class="tr_nodata">
					                <td colspan="5">등록된 정보가 없습니다.</td>
					            </tr>
					            </c:if>
								<c:if test="${!empty noticeList}">
						        <c:forEach var="result" items="${noticeList.rows}" varStatus="status">
	                            <tr onmouseover="this.className='on godetail'" onmouseout="this.className=''">
	                                <td>
	                                	<span>${result.NSeq}</span>
	                                	${totalCnt - (paging.pageNo-1)*paging.pageSize - status.index }
	                                </td>
	                                <td>
					                	<c:if test="${result.NTop eq 'Y'}">노출</c:if>
					                	<c:if test="${result.NTop eq 'N'}">미노출</c:if>
					                </td>
	                                <td class="tal">${result.NTitle}</td>                                
	                                <td>${result.NRegUser}</td>
	                                <td>
	                                	<c:set var="NRegDt" value="${result.NRegDt}"/>${fn:substring(NRegDt,0,4) }-${fn:substring(NRegDt,4,6) }-${fn:substring(NRegDt,6,8) } ${fn:substring(NRegDt,8,10) }:${fn:substring(NRegDt,10,12) }:${fn:substring(NRegDt,12,14) }
	                                </td>
	                            </tr>
	                            </c:forEach>
	                            </c:if>
	                        </tbody>
	                    </table>
	                </section>
	                <!-- //table list -->
	                <!-- Pagination -->
	                <section class="pagination m-t-30">
		    			<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp"/>
	                    <button type="button" class="btn btn_default goRegButton">등록</button>
	                </section>
	                <!-- //Pagination -->
                </div>
            </div>
            <!-- //content -->
        </div>
		<span id="pageNo" style="display:none"></span>
        <!-- //container -->
		<script type="text/javascript">
		//<![CDATA[
			CKEDITOR.replace('nContent',
					{filebrowserUploadUrl:'<c:url value="/ckeditor/fileupload" />?${_csrf.parameterName}=${_csrf.token}'} ); //]]>
		</script>
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>