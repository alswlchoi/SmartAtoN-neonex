<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<script src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#search").keydown(function(key) {
		if (key.keyCode == 13) {
			search("button");
		}
	});	

	$("#searchBtn").click(function(){
		search("button");
	});
	
	$("#initBtn").click(function(){
		search("init");
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
	    autoUpdateInput: false,
	    timePicker: false,                        // 시간 노출 여부
	    showDropdowns: true,                     // 년월 수동 설정 여부
	    autoApply: true,                         // 확인/취소 버튼 사용여부
	    timePicker24Hour: false,                  // 24시간 노출 여부(ex> true : 23:50, false : PM 11:50)
	    timePickerSeconds: false,                 // 초 노출 여부
	    singleDatePicker: false,                   // 하나의 달력 사용 여부
	});
	//daterangepiker end

	
	$(document).on("click",'.listBtn' ,function(){
		search("list");
	});

	$(document).on("click",'.godetail' ,function(){
		var currentRow=$(this).closest('tr');
		var pageNo;
		var nSeq = currentRow.find('td span').text();
		pageNo = $(".pageNo.on").attr("data-page");
		var nType = "${nType}";
		var schTop = "${schTop}";

		var form = $("<form></form>");
		form.attr("action","/admin/notice/update-form");
		form.attr("method","post");
		form.appendTo("body");
		form.append('<input type="hidden" value='+nSeq+' name="nSeq" />');
		form.append('<input type="hidden" value='+pageNo+' name="pageNo" />');
		form.append('<input type="hidden" value='+nType+' name="nType" />');
		form.append('<input type="hidden" value='+schTop+' name="schTop" />');
		var inputToken = $('<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />');
		form.append(inputToken);
		form.submit();
	});
});	

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
	var nType = "${nType}";
	var schTop = "${schTop}";
	var nTitle = $("#schTitle").val();
	var nTop = [];
	
	
	$("input[name='schTop']:checked").each(function(i) {
		nTop.push($(this).val());
	});
	var nRegStDt = $("#nRegStDt").val();

	if(type == "list") {//목록 버튼
		pageNo = $("#pageNo").text();
		$("#data_detail").hide();
	}else if(type == "paging"){//페이징 검색
		pageNo = $(".pageNo.on").attr("data-page"); 
	}else{
		pageNo = "1";
	}

	if(pageNo==""){
		pageNo = "1";
	}
	
	if(type == "init"){
		var nTitle = "";
		var nRegStDt = "";
		$("#schTitle").val("");
		$("#nRegStDt").val("");
		nTop = "";
		$("input[name='schTop']:checked").each(function(i) {
			$(this).prop("checked", false);
		});
	}
	
	$.ajax({
		url : "/admin/notice/search-notice",
		type : "get",
		data : {
			"pageNo"  :pageNo,
			"nType":nType,
			"nTop":nTop,
			"schTop":schTop,
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
</script>
        <!-- container -->
        <div id="container">
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>컨텐츠관리</span><span><c:if test="${nType!='s' }">공지사항</c:if><c:if test="${nType=='s' }">자료실</c:if></span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title"><c:if test="${nType!='s' }">공지사항</c:if><c:if test="${nType=='s' }">자료실</c:if></h2>
                <!-- //title -->
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
	                            placeholder="등록기간 선택" name="" autocomplete="off" />
	                    </div>
	                    <button type="button" id="searchBtn" class="btn-s btn_default">조회</button>
                        <button type="button" class="btn-s btn_default" id="initBtn">검색초기화</button>
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
								<c:if test="${totalCnt == 0 }">
	                            <tr class="tr_nodata">
					                <td colspan="5">등록된 정보가 없습니다.</td>
					            </tr>
					            </c:if>
								<c:if test="${totalCnt > 0 }">
						        <c:forEach var="result" items="${noticeList.rows}" varStatus="status">
	                            <tr onmouseover="this.className='on godetail'" onmouseout="this.className=''">
	                                <td>
	                                	<span style="display:none">${result.NSeq}</span>
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
	                <section id="pagingc" class="pagination m-t-30">
		    			<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp"/>
	                </section>
                    <div style="text-align:right">
                    <button type="button" onclick="location.href='/admin/notice/regform?nType=${nType }&amp;schTop=${schTop }&amp;pageNo=${pageNo }'" class="btn btn_default goRegButton">등록</button>
                    </div>
	                <!-- //Pagination -->
                </div>
            </div>
            <!-- //content -->
        </div>
		<span id="pageNo" style="display:none"></span>
        <!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>