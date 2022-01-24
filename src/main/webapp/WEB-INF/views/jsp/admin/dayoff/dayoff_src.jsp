<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>목록</title>
<link rel="stylesheet" type="text/css" href="/inc/css/common.css" />
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.3/dist/jquery.validate.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />


<script type="text/javascript">
$(function(){
		//daterangepiker start
		$("#doStDay").daterangepicker({
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
	 
	$("#search").keydown(function(key) {
		if (key.keyCode == 13) {
			search("button");
		}
	});
	

	$("#searchBtn").click(function(){
		search("button");
	});
});

$(document).ready(function(){
	$(document).on("click",'.listButton' ,function(){
		search("list");
	});
	$(document).on("click",'.updButton' ,function(){
		$.ajax({
			url : "/admin/dayoff/detail-dayoff",
			type : "get",
			data : {
				"searchYear":$("#searchYear").val()
			},
			success : function(resdata){
				$("#doStDay").val(undefinedChk(resdata.dayoff.dday,""));
				$("#dName").val(undefinedChk(resdata.dayoff.dname,""));

				$("#regBtn").text("수정");
				$("#regBtn").removeClass("reg");
				$("#regBtn").addClass("upd");
			},
			error : function(e){
				console.log(e);
			}
		});
	});
	
	//데이터 삭제
	$(document).on("click",'.delButton' ,function(){
		var currentRow=$(this).closest('tr');
		var doStDay = currentRow.find('td:eq(1)').text();

		var result = confirm("정보를 삭제하시겠습니까?");
		if(result){
			$.ajax({
				url : "/admin/dayoff/delete-dayoff",
				type : "get",
				data : {
					"doStDay":doStDay
				},
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
	//등록/수정버튼 이벤트
	$(".btn_regi").click(function(){
		var hobbyCheck = false; 
		var doStDay = $("#doStDay").val();
		var doName = $("#doName").val();
		
		if($(this).hasClass("reg")){
			if(doName.length == 0){
				$("#error_doName").text("휴일명/사유를 형식에 맞게 선택해 주세요.");
				return false;
			}
			
			$.ajax({
				url : "/admin/dayoff/insert-dayoff",
				type : "get",
				data : {
					"doStDay":doStDay,
					"doName":doName
				},
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
				
		}else if($(this).hasClass("upd")){
	  		$.ajax({
	 			url : "/admin/dayoff/update-dayoff",
	 			type : "get",
	 			data : {
						"doStDay":$("#doStDay").val(),
						"dName":$("#dName").val()
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
			drawingTable(resdata);
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

//등록페이지로 이동
$(document).on("click",".goRegButton",function(){
	$("#data_area").removeClass("hidden");
	
})

//상세보기로 이동
$(document).on("click",".detailButton",function(){
	var currentRow=$(this).closest('tr');
	var pageSize = $("#pageSize").val();
	var pageNo;
	var searchYear = $("#searchYear option:selected").val();
	
	pageNo = $(".pageNo.active").attr("data-page");
	$("#pageNo").html(pageNo);
});	

//테이블 그리는 함수
function drawingTable(rows){
	var html='';
	var doStDay = '';
	var doEdDay = '';
	var i = 0;
	for(var list in rows){
		html += '<tr>'; 
		doStDay = undefinedChk(rows[list].doStDay,"");
		doEdDay = undefinedChk(rows[list].doEdDay,"");
		doStDay = doStDay.substring(0,4)+"-"+doStDay.substring(4,6)+"-"+doStDay.substring(6,8);
		doEdDay = doEdDay.substring(0,4)+"-"+doEdDay.substring(4,6)+"-"+doEdDay.substring(6,8);
		html += '<td>'+(rows.length-i)+'</td>';
		html += '<td>'+doStDay+' ~ '+doEdDay+'</td>';
		html += '<td>'+undefinedChk(rows[list].doName,"")+'</td>';
		html += '<td><button type="button" class="delButton"><i class="icon--ref">삭제</i> </button></td>';
		html += '</tr>';
		i++;
	}
	$("#tbody").html(html);
}

</script>
</head>
<body>   
    <div id="data_list">
	    <div class="list_top">
	        <div class="fl">목록<span id="resultCnt" class="bold">${totalCnt}</span>건</div>
	        <div class="dflex"> 
				<div class="form_group search_form end">
					<jsp:useBean id="now" class="java.util.Date" />
					<fmt:formatDate var="year" value="${now}" pattern="yyyy" />
	              	<select id="searchYear" name="searchYear">
						<c:set var="yearStart" value="2021" />
						<c:forEach begin="${yearStart }" end="${year+1 }" var="year" step="1">
							<option value="${year }">${year }</option>
						</c:forEach>						
					</select>
	                 <button type="button" class="btn" id="searchBtn">검색</button>
	              </div>
	        </div>
	     </div>
	     
		<button type="button" class="goRegButton" class="float_r">등록</button></div>
	   
		<table border="1">
		<caption class="hidden">휴일리스트입니다.</caption>
	        <colgroup>
	           <col>
	           <col width="30%">
	           <col width="30%">
	           <col width="20%">
	           <col>
	        </colgroup>
	        <thead>
	        <tr>
	            <th scope="col">NO</th>
	            <th scope="col">일자</th>
	            <th scope="col">휴일명/사유</th>
	            <th scope="col">비고</th>
	        </tr>
	 		</thead>
	        <tbody id="tbody">
	        <tr id="data_area" class="hidden">
	        	<td></td>
                <td><input type="text" placeholder="YYYY-MM-DD" title="일자" id="doStDay" value="" />
                <p id="error_doStDay" class="error red"></p></td>
                <td><input type="text" placeholder="휴일명/사유" title="휴일명/사유" id="doName" class="form_control" value="" />
                <p id="error_doName" class="error red"></p></td>
                <td><button type="button" class="btn_regi reg" id="regBtn" data-branchCode="">저장</button></td>
            </tr>
	        <c:if test="${totalCnt eq 0 }">
	        <tr>
	        	<td colspan="4">데이터가 존재하지 않습니다.</td>
	        </tr>
	        </c:if>
	        <c:if test="${fn:length(dayoffList) > 0 }">
		        <c:forEach var="result" items="${dayoffList}" varStatus="status">
		            <tr>
		            	<td>${totalCnt-status.index}</td>
		                <td>
		                	<c:set var="doStDay" value="${result.doStDay}" />${fn:substring(doStDay, 0, 4) }-${fn:substring(doStDay,4,6) }-${fn:substring(doStDay,6,8) } ~ 
		                	<c:set var="doEdDay" value="${result.doEdDay}" />${fn:substring(doEdDay, 0, 4) }-${fn:substring(doEdDay,4,6) }-${fn:substring(doEdDay,6,8) }
		                </td>
		                <td>${result.doName}</td>
		                <td>
		                	<button type="button" class="delButton"><i class="icon--ref">삭제</i> </button>
		                </td>
		            </tr>
		        </c:forEach>
		       </c:if>
	        </tbody>
	    </table>
	    <div>
    </div>
</body>
</html>