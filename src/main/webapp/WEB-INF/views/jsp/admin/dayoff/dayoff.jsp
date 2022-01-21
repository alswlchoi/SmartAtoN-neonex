<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
	//daterangepiker start
	$("input[name^=doStDay]").daterangepicker({
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
	    timePicker24Hour: true,                  // 24시간 노출 여부(ex> true : 23:50, false : PM 11:50)
	    timePickerSeconds: true,                 // 초 노출 여부
	    singleDatePicker: false                   // 하나의 달력 사용 여부
	});

	$("#newDay").daterangepicker({
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
	    timePicker24Hour: true,                  // 24시간 노출 여부(ex> true : 23:50, false : PM 11:50)
	    timePickerSeconds: true,                 // 초 노출 여부
	    singleDatePicker: false                   // 하나의 달력 사용 여부
	});
	//daterangepiker end

	$("#searchYear").change(function(){
		search("button");
	});

	//데이터 삭제
	$(document).on("click",'.delBtn' ,function(){
		var currentRow=$(this).closest('tr');
		var doSeq = currentRow.find('td:eq(0) span').text();
		var result = confirm("해당 내역을 삭제하시겠습니까?");

		$(document).on("click",'#confirmTrue' ,function(){
			$.ajax({
				url : "/admin/dayoff/delete-dayoff",
				type : "get",
				data : {
					"doSeq":doSeq
				},
				success : function(resdata){
					if(resdata.code == 400){
						alert(resdata.message);
					}else{
						search("button");
						alert(resdata.message);
					}
				},
				error : function(e){
					console.log(e);
				}
			});
		});

	});
	//등록/수정버튼 이벤트
	$(".btn_regi").click(function(){
		var doStDay = $("#newDay").val();
		var doName = $("#newName").val();
		var doKind = "F";

		if(doName.length == 0){
			alert("휴일명/사유를 형식에 맞게 선택해 주세요.");
			$("#newName").focus();
			return false;
		}else{
			$.ajax({
				url : "/admin/dayoff/insert-dayoff",
				type : "get",
				data : {
					"doStDay":doStDay,
					"doName":doName,
					"doKind":doKind
				},
				success : function(resdata){
					if(resdata.code == 400){
						alert(resdata.message);
					}else{
						search("button");
						alert(resdata.message);
					}
				},
				error : function(e){
					console.log(e);
				}
			});
		}
	});
});

$(document).on("click",'.updBtn' ,function(){
	var currentRow=$(this).closest('tr');
	var doSeq = currentRow.find('td:eq(0) span').text();
	console.log(doSeq);
	var doStDay = currentRow.find('td:eq(1) input').val();
	var doName = currentRow.find('td:eq(2) input').val();
	var doKind = "F";

	$.ajax({
		url : "/admin/dayoff/update-dayoff",
		type : "get",
		data : {
			"doSeq":doSeq,
			"doStDay":doStDay,
			"doName":doName,
			"doKind":doKind,
		},
		success : function(resdata){
			if(resdata.code == 400){
				alert(resdata.message);
			}else{
				search("button");
				alert(resdata.message);
			}
		},
		error : function(e){
			console.log(e);
		}
	});
});

//페이지 버튼 클릭
$(document).on("click",".pageNo",function(){
	$(this).siblings().removeClass("active");
	$(this).addClass("active");

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
	var pageSize = $("#pageSize").val();
	var pageNo;
	var searchYear = $("#searchYear option:selected").val();

	if(type=="button" && searchYear==""){
		alert("검색어를 입력하세요.");
		$("#search").focus();
		return false;
	}
	if(type == "button"){//버튼 검색
		pageNo = "1";
	}else if(type == "list") {//목록 버튼
		pageNo = $("#pageNo").text();
	}else if(type == "paging"){//페이징 검색
		pageNo = $(".pageNo.active").attr("data-page");
	}
	$.ajax({
		url : "/admin/dayoff/search-dayoff",
		type : "get",
		data : {
				"pageSize":pageSize,
				"pageNo"  :pageNo,
				"searchYear":searchYear
		},
		success : function(resdata){
			$("#resultCnt").html(resdata.totalCount);
			drawingTable(resdata.rows);
		},
		error : function(e){
			console.log(e);
		}
	});

}

//조회값 undefined -> 공백 처리
function undefinedChk(str1,str2){
	if(typeof str1 =="undefined"){
		return str2;
	}else{
		return str1;
	}
}

//테이블 그리는 함수
function drawingTable(rows){
	console.log(rows.length);
	var html='';
	var doStDay = '';
	var doEdDay = '';
	var i = 0;
	html += '<tr>';
	html += '    <td>&nbsp;</td>';
	html += '    <td>';
	html += '        <div class="form_group w300">';
	html += '        	<input type="text" class="form_control dateicon datefromto"';
	html += '                placeholder="기간선택" id="newDay" name="newDay" />';
	html += '        </div>';
	html += '    </td>';
	html += '    <td>';
	html += '        <div class="form_group w_full">';
	html += '            <input type="text" id="newName" name="newName" class="form_control" placeholder="새로 등록할 휴일기간을 입력하세요." value="" />';
	html += '        </div>';
	html += '    </td>';
	html += '    <td style="text-align:left;padding-left:22px;"><button type="button" class="btn_regi btn-line-s btn_default m-r-6">저장</button></td>';
	html += '</tr>';
	if(rows.length==0){
		html += '<tr><td colspan="4">등록된 정보가 없습니다.</td></tr>';
	}else{
		for(var list in rows){
			html += '<tr>';
			doStDay = undefinedChk(rows[list].doStDay,"");
			doEdDay = undefinedChk(rows[list].doEdDay,"");
			doStDay = doStDay.substring(0,4)+"-"+doStDay.substring(4,6)+"-"+doStDay.substring(6,8);
			doEdDay = doEdDay.substring(0,4)+"-"+doEdDay.substring(4,6)+"-"+doEdDay.substring(6,8);
			html += '<td><span style="display:none">'+undefinedChk(rows[list].doSeq,"")+'</span>'+(rows.length-i)+'</td>';
			html += '<td><div class="form_group w300"><input type="text" id="doStDay'+list+'" name="doStDay'+list+'" class="form_control dateicon datefromto" ';
			html += 'placeholder="기간선택" value="'+doStDay+' ~ '+doEdDay+'" /></div></td>';
			html += '<td><div class="form_group w_full"><input type="text" id="doName'+list+'" name="doName'+list+'" class="form_control"';
            html += ' placeholder="휴일명/사유" value="'+undefinedChk(rows[list].doName,"")+'" /></div></td>';
			html += '<td><button type="button" class="btn-line-s btn_default m-r-6 updBtn">저장</button>';
			html += '<button type="button" class="btn-line-s btn_gray delBtn">삭제</button>';
			html += '</td>';
			html += '</tr>';
			i++;
		}
	}
	$("#tbody").html(html);
	$("input[name^=doStDay]").daterangepicker({
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
	    timePicker24Hour: true,                  // 24시간 노출 여부(ex> true : 23:50, false : PM 11:50)
	    timePickerSeconds: true,                 // 초 노출 여부
	    singleDatePicker: false                   // 하나의 달력 사용 여부
	});
}

</script>
        <div id="container">
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span
                        class="breadcrumb_icon"></span><span>회원사/자원관리</span><span>자원관리</span><span>휴일관리</span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">휴일관리</h2>
                <!-- //title -->
                <%--
				<div class="select_group">
					<jsp:useBean id="now" class="java.util.Date" />
					<fmt:formatDate var="year" value="${now}" pattern="yyyy" />
	              	<select id="searchYear" name="searchYear" class="form_control w200">
						<c:set var="yearStart" value="2021" />
						<c:forEach begin="${yearStart }" end="${year+1 }" var="year" step="1">
							<option value="${year }">${year }</option>
						</c:forEach>
					</select>
	              </div>--%>
                <!-- table list -->
                <section class="tbl_wrap_list m-t-30">
                    <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                        <caption>테이블</caption>
                        <colgroup>
                            <col width="80px" />
                            <col width="340px" />
                            <col width="" />
                            <col width="150px" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col">번호</th>
                                <th scope="col">기간</th>
                                <th scope="col">휴일명/사유</th>
                                <th scope="col">비고</th>
                            </tr>
                        </thead>
                        <tbody id="tbody">
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <div class="form_group w300">
                                    	<input type="text" class="form_control dateicon datefromto"
                                            placeholder="기간선택" id="newDay" name="newDay" />
                                    </div>
                                </td>
                                <td>
                                    <div class="form_group w_full">
                                        <input type="text" id="newName" name="newName" class="form_control" placeholder="새로 등록할 휴일기간을 입력하세요." value="" />
                                    </div>
                                </td>
                                <td style="text-align:left;padding-left:22px;"><button type="button" class="btn_regi reg btn-line-s btn_default m-r-6">저장</button></td>
                            </tr>
                        <c:if test="${totalCnt eq 0 }">
					        <tr>
					        	<td colspan="4">데이터가 존재하지 않습니다.</td>
					        </tr>
				        </c:if>
				        <c:if test="${fn:length(dayoffList) > 0 }">
					        <c:forEach var="result" items="${dayoffList.rows}" varStatus="status">
                            <tr>
                                <td><span style="display:none">${result.doSeq}</span>${totalCnt - (paging.pageNo-1)*paging.pageSize - status.index }</td>
                                <td>
                                    <div class="form_group w300">
					                	<c:set var="doStDay" value="${result.doStDay}" />
					                	<c:set var="doEdDay" value="${result.doEdDay}" />
                                        <input type="text" class="form_control dateicon datefromto"
                                            placeholder="기간선택" id="" name="doStDay${status.index }" value="${fn:substring(result.doStDay, 0, 4) }-${fn:substring(result.doStDay,4,6) }-${fn:substring(result.doStDay,6,8) } ~ ${fn:substring(doEdDay, 0, 4) }-${fn:substring(doEdDay,4,6) }-${fn:substring(doEdDay,6,8) }" />
                                    </div>
                                </td>
                                <td>
                                    <div class="form_group w_full">
                                        <input type="text" class="form_control" placeholder="휴일명/사유" id="doName${status.index }" name="doName${status.index }"
                                            value="${result.doName}" />
                                    </div>
                                </td>
                                <td><button type="button" class="btn-line-s btn_default m-r-6 updBtn">저장</button><button
                                        type="button" class="btn-line-s btn_gray delBtn">삭제</button></td>
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
                </section>
                <!-- //Pagination -->
            </div>
            <!-- //content -->
        </div>
        <!-- //container -->
  		<span id="pageNo" style="display:none">1</span>
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>