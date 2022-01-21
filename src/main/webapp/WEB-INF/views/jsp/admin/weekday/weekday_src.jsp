<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>목록</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.3/dist/jquery.validate.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
<script type="text/javascript">
$(function(){
	//daterangepiker start
	$("#wdStDt").daterangepicker({
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

	$("#data_area").hide();	//페이지 로딩시 등록/수저폼 가림
	$("#search").keydown(function(key) {
		if (key.keyCode == 13) {
			search("button");
		}
	});
	

	$("#searchBtn").click(function(){
		search("button");
	});

	//등록페이지로 이동
	$(".goRegButton").click(function(){
		$(".godetail").removeClass("selrow");
		
		$("#wdSeq").val($("#wdSeq").val());
		$("#data_area").show();
		$("#wdCon1").prop("checked", true);
		$("input:radio[id=wdKindt]").prop("checked", true);
		$("#wdKindEtc").val("");
		$("input:checkbox[name=wdDay]").prop("checked", false);
		$("#wdStDt").val();
		$("#wdStHour option:eq(0)").prop("selected", true);
		$("#wdStMin option:eq(0)").prop("selected", true);
		$("#wdEdHour option:eq(0)").prop("selected", true);
		$("#wdEdMin option:eq(0)").prop("selected", true);
		$("#wdCanStHour option:eq(0)").prop("selected", true);
		$("#wdCanStMin option:eq(0)").prop("selected", true);
		$("#wdCanEdHour option:eq(0)").prop("selected", true);
		$("#wdCanEdMin option:eq(0)").prop("selected", true);

		$("#regBtn").text("등록");
		$("#regBtn").removeClass("upd");
		$("#regBtn").addClass("reg");
	});
	
	//취소버튼 이벤트
	$(".btn_cancel").click(function(){
		$("#wdSeq").val($("#wdSeq").val());
		$("#data_area").show();
		$("input:radio[name=wdCon]").prop("checked", true);
		$("input:radio[id=wdKindt]").prop("checked", true);
		$("#wdKindEtc").val("");
		$("input:checkbox[name=wdDay]").prop("checked", false);
		$("#wdStDt").val();
		$("#wdStHour option:eq(0)").prop("selected", true);
		$("#wdStMin option:eq(0)").prop("selected", true);
		$("#wdEdHour option:eq(0)").prop("selected", true);
		$("#wdEdMin option:eq(0)").prop("selected", true);
		$("#wdCanStHour option:eq(0)").prop("selected", true);
		$("#wdCanStMin option:eq(0)").prop("selected", true);
		$("#wdCanEdHour option:eq(0)").prop("selected", true);
		$("#wdCanEdMin option:eq(0)").prop("selected", true);
	});
});

$(document).ready(function(){
	$(document).on("click",'.listButton' ,function(){
		$("#data_area").hide();
		search("list");
	});
	$(document).on("click",'.updButton' ,function(){
		$("#data_list").hide();
		var currentRow=$(this).closest('tr');
		var wdSeq = currentRow.find('td:eq(0)').text();
		
		$.ajax({
			url : "/admin/weekday/detail-weekday",
			type : "get",
			data : {
				"wdSeq":wdSeq
			},
			success : function(resdata){
				$("#data_area").show();
				$("#wdSeq").val(undefinedChk(resdata.weekday.wdSeq,""));
				$("#wdSeq").prop("disabled",true);
				var wdStDt = undefinedChk(resdata.weekday.wdStDt,"");
				var wdEdDt = undefinedChk(resdata.weekday.wdEdDt,"");
				$("#wdStDt").prop("disabled",true);
				$("#wdEdDt").prop("disabled",true);
				$("#areaNotice").text("기간설정을 원하시는 경우 삭제 후 재등록 해주세요.");
				wdStDt = wdStDt.substring(0,4)+'-'+wdStDt.substring(4,6)+'-'+wdStDt.substring(6,8);
				wdEdDt = wdEdDt.substring(0, 4)+'-'+wdEdDt.substring(4, 6)+'-'+wdEdDt.substring(6, 8);
				$("#wdStDt").val(wdStDt);
				$("#wdEdDt").val(wdEdDt);
				// 선택된 요일 체크해 주기 시작
				$.fn.checkboxSelect = function(val) {

					if(!Array.isArray(val))
						val = [val];
					
					this.each(function() {
					var $this = $(this);
					var map = val.reduce(function(accu, v) {
					accu[v] = true;
					return accu;
					}, []);
					
					map[$this.val()] ? $this.prop('checked', true) : $this.prop('checked', false);
					});
					return this;
				};
				
				var wdDayArray = [];
				var wdDay = undefinedChk(resdata.weekday.wdDay,"");
				
				for (var i = 0; i < wdDay.length; i++) {
					wdDayArray.push(wdDay[i]);
				}
				$(":checkbox[name='wdDay']").checkboxSelect(wdDayArray);
				//// 선택된 요일 체크해 주기 끝
				var wdStHour = parseInt(undefinedChk(resdata.weekday.wdStHour,""));
				var wdEdHour = parseInt(undefinedChk(resdata.weekday.wdEdHour,""));
				$("#wdStHour").val(wdStHour).prop("selected", true);
				$("#wdEdHour").val(wdEdHour).prop("selected", true);
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
		var wdSeq = currentRow.find('td:eq(0)').text();
		var result = confirm("정보를 삭제하시겠습니까?");
		if(result){
			$.ajax({
				url : "/admin/weekday/delete-weekday",
				type : "get",
				data : {
					"wdSeq":wdSeq
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
		var wdCon = $("input:radio[name='wdCon']:checked").val();
		var wdKind = $("input:radio[name='wdKind']:checked").val();
		if(wdKind=="e"){
			wdKind = $("#wdKindEtc").val();
		}
		var wdStDt = $("#wdStDt").val();
		var wdStHour = $("#wdStHour").val();
		var wdStMin = $("#wdStMin").val();
		var wdEdHour = $("#wdEdHour").val();
		var wdEdMin = $("#wdEdMin").val();
		var wdCanStHour = $("#wdCanStHour").val();
		var wdCanStMin = $("#wdCanStMin").val();
		var wdCanEdHour = $("#wdCanEdHour").val();
		var wdCanEdMin = $("#wdCanEdMin").val();
		
		var wdDay = []; 
		$("input[name='wdDay']:checked").each(function(i) {
			wdDay.push($(this).val());
		});

		//유효성 체크 시작
		if(wdKind.length == 0){
			$("#error_wdKind").text("구분을 선택/입력해 주세요.");
			$("#wdKindt").focus();
			return false;
		}else{
			$("#error_wdKind").text("");
		}
		
		if(wdDay.length == 0){
			$("#error_wdDay").text("운영요일을 선택해 주세요.");
			$("#wdDay2").focus();
			return false;
		}else{
			$("#error_wdDay").text("");
		}
		
		if(wdStDt.length == 0){
			$("#error_wdStDt").text("운영기간을 입력해 주세요.");
			$("#wdStDt").focus();
			return false;
		}else{
			$("#error_wdStDt").text("");
		}
		
		if(wdStHour.length == 0 || wdStMin.length == 0 || wdEdHour.length == 0 || wdEdMin.length == 0){
			$("#error_time").text("실운영시간을 입력해 주세요.");
			return false;
		}else{
			$("#error_time").text("");
		}
		
		if(wdCanStHour.length == 0 || wdCanStMin.length == 0 || wdCanEdHour.length == 0 || wdCanEdMin.length == 0){
			$("#error_canTime").text("예약가능시간을 입력해 주세요.");
			return false;
		}else{
			$("#error_canTime").text("");
		}
		//유효성 체크 끝
		
		if($(this).hasClass("reg")){
			
			$.ajax({
				url : "/admin/weekday/insert-weekday",
				type : "get",
				data : {
					"wdCon":wdCon,
					"wdKind":wdKind,
					"wdStDt":wdStDt,
					"wdDay":wdDay,
					"wdStHour":wdStHour,
					"wdStMin":wdStMin,
					"wdEdHour":wdEdHour,
					"wdEdMin":wdEdMin,
					"wdCanStHour":wdCanStHour,
					"wdCanStMin":wdCanStMin,
					"wdCanEdHour":wdCanEdHour,
					"wdCanEdMin":wdCanEdMin
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
			wdSeq = $("#wdSeq").text();
	  		$.ajax({
	 			url : "/admin/weekday/update-weekday",
	 			type : "get",
	 			data : {
					"wdSeq":wdSeq,
					"wdCon":wdCon,
					"wdKind":wdKind,
					"wdStDt":wdStDt,
					"wdDay":wdDay,
					"wdStHour":wdStHour,
					"wdStMin":wdStMin,
					"wdEdHour":wdEdHour,
					"wdEdMin":wdEdMin,
					"wdCanStHour":wdCanStHour,
					"wdCanStMin":wdCanStMin,
					"wdCanEdHour":wdCanEdHour,
					"wdCanEdMin":wdCanEdMin
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
	var searchDay = $("#search").val();
	var datatimeRegexp = /[0-9]{4}-(0?[1-9]|1[012])-(0?[1-9]|[12][0-9]|3[01])/;
	
	if(type=="button" && (searchDay==""||!datatimeRegexp.test(searchDay))) {
		alert("검색일을 형식(yyyy-mm-dd)에 맞게 입력해 주세요.");
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
	$("#data_list").show();
	$.ajax({
		url : "/admin/weekday/search-weekday",
		type : "get",
		data : {
				"pageSize":pageSize,
				"pageNo"  :pageNo,
				"searchDay":searchDay
		},
		success : function(resdata){
			drawingTable(resdata.rows);
			drawingPage(resdata.paging);
			$("#totCnt").html(numberWithCommas(resdata.paging.totalCount));
		},
		error : function(e){
			console.log(e);
		}
	});

}

//숫자 콤마 설정
function numberWithCommas(x) {return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");}

//조회값 undefined -> 공백 처리
function undefinedChk(str1,str2){
	if(typeof str1 =="undefined"||str1 ==null){
		return str2;
	}else{
		return str1;
	}
}


//상세보기로 이동
$(document).on("click",".godetail",function(){
	var currentRow=$(this).closest('tr');
	currentRow.addClass("selrow").siblings().removeClass("selrow");
	var wdSeq = currentRow.find('td:eq(0)>span').text();
	$("#wdSeq").text(wdSeq);
	var pageSize = $("#pageSize").val();
	var pageNo;
	
	pageNo = $(".pageNo.active").attr("data-page");
	$("#pageNo").html(pageNo);
	
	$.ajax({
		url : "/admin/weekday/detail-weekday",
		type : "get",
		data : {
			"pageSize":pageSize,
			"pageNo"  :pageNo,
			"wdSeq":wdSeq
		},
		success : function(resdata){
			drawingDetailTable(resdata.weekday);
		},
		error : function(e){
			console.log(e);
		}
	});
});	


function drawingDetailTable(weekday){
	$("#data_area").show();
	$("#wdSeq").text(weekday.wdSeq);
	var wdCon = undefinedChk(weekday.wdCon,"");
	if(wdCon=="1") $("input:radio[id=wdCon1]").prop("checked", true);	//정상
	if(wdCon=="0") $("input:radio[id=wdCon0]").prop("checked", true);	//중단
	var wdKind = undefinedChk(weekday.wdKind,"");
	if(wdKind=="t") {
		$("input:radio[id=wdKindt]").prop("checked", true);
	}else{
		$("input:radio[id=wdKindt]").prop("checked", false);
	}
	if(wdKind=="b") {
 		$("input:radio[id=wdKindb]").prop("checked", true);
	}else{
		$("input:radio[id=wdKindb]").prop("checked", false);
	}
	if(wdKind!="t"&&wdKind!="b") {
		$("input:radio[id=wdKinde]").prop("checked", true);
		$("#wdKindEtc").val(wdKind);
	}else{
		$("input:radio[id=wdKinde]").prop("checked", false);
		$("#wdKindEtc").val("");
	}
	//운영요일
	$("input:radio[name=wdDay]").prop("checked", false);
	var wdDay = undefinedChk(weekday.wdDay,"");	//요일
	if(wdDay.indexOf('2')>-1) { $("#wdDay2").prop("checked", true) }else{ $("#wdDay2").prop("checked", false) }
	if(wdDay.indexOf('3')>-1) { $("#wdDay3").prop("checked", true) }else{ $("#wdDay3").prop("checked", false) }
	if(wdDay.indexOf('4')>-1) { $("#wdDay4").prop("checked", true) }else{ $("#wdDay4").prop("checked", false) }
	if(wdDay.indexOf('5')>-1) { $("#wdDay5").prop("checked", true) }else{ $("#wdDay5").prop("checked", false) }
	if(wdDay.indexOf('6')>-1) { $("#wdDay6").prop("checked", true) }else{ $("#wdDay6").prop("checked", false) }
	if(wdDay.indexOf('7')>-1) { $("#wdDay7").prop("checked", true) }else{ $("#wdDay7").prop("checked", false) }
	if(wdDay.indexOf('1')>-1) { $("#wdDay1").prop("checked", true) }else{ $("#wdDay1").prop("checked", false) }
	//운영요일
	
	//운영기간
	var wdStDt = undefinedChk(weekday.wdStDt,"");
	var wdEdDt = undefinedChk(weekday.wdEdDt,"");
	wdStDt = wdStDt.substring(0,4)+"-"+wdStDt.substring(4,6)+"-"+wdStDt.substring(6,8);
	wdEdDt = wdEdDt.substring(0,4)+"-"+wdEdDt.substring(4,6)+"-"+wdEdDt.substring(6,8);
	$("#wdStDt").val(wdStDt+" ~ "+wdEdDt);
	
	//실운영시간
	var wdStHour = undefinedChk(weekday.wdStHour,"");
	$("#wdStHour").val(wdStHour.substring(0,2));
	$("#wdStMin").val(wdStHour.substring(2,4));
	
	var wdEdHour = undefinedChk(weekday.wdEdHour,"");
	$("#wdEdHour").val(wdEdHour.substring(0,2));
	$("#wdEdMin").val(wdEdHour.substring(2,4));
	
	//예약가능시간
	var wdCanStHour = undefinedChk(weekday.wdCanStHour,"");
	$("#wdCanStHour").val(wdCanStHour.substring(0,2));
	$("#wdCanStMin").val(wdCanStHour.substring(2,4));
	
	var wdCanEdHour = undefinedChk(weekday.wdCanEdHour,"");
	$("#wdCanEdHour").val(wdCanEdHour.substring(0,2));
	$("#wdCanEdMin").val(wdCanEdHour.substring(2,4));
	
	var html = '';
	html += '<table border="1">';
	html += '<tbody>';
	html += '<tr>';
	var wdRegDt = undefinedChk(weekday.wdRegDt,"");
	wdRegDt = wdRegDt.substring(0,4)+'-'+wdRegDt.substring(4,6)+'-'+wdRegDt.substring(6,8)+' '+wdRegDt.substring(8,10)+':'+wdRegDt.substring(10,12)+'.'+wdRegDt.substring(12,14);
	html += '<th>등록자</th><td>'+undefinedChk(weekday.wdRegUser,"")+'</td>';
	html += '<th>등록일</th><td>'+wdRegDt+'</td>';
	html += '</tr>';
	html += '<tr>';
	var wdModUser = undefinedChk(weekday.wdModUser,"");

	if(wdModUser!=""){
		html += '<th>수정자</th><td>'+wdModUser+'</td>';
		var wdModDt = undefinedChk(weekday.wdModDt,"");
		wdModDt = wdModDt.substring(0,4)+'-'+wdModDt.substring(4,6)+'-'+wdModDt.substring(6,8)+' '+wdModDt.substring(8,10)+':'+wdModDt.substring(10,12)+'.'+wdModDt.substring(12,14);
		html += '<th>수정일</th><td>'+wdModDt+'</td>';
	}
	html += '</tr>';
	html += '</table>';
	
	$("#regInfo").html(html);

	$("#regBtn").text("수정");
	$("#regBtn").removeClass("reg");
	$("#regBtn").addClass("upd");
}

//테이블 그리는 함수
function drawingTable(rows){
	var html='';
	var i = 0;
	var wdKind = '';
	if(rows.length==0) {
		html += '<tr>';
		html += '<td colspan="7">데이터가 존재하지 않습니다.</td>';
		html += '</tr>';
	}else{
		for(var list in rows){
			html += '<tr class="godetail">';
			html += '<td><span class="hidden">'+undefinedChk(rows[list].wdSeq,"")+'</span>'+(rows.length-i)+'</td>';
			if(rows[list].wdKind=='t'){
				wdKind="한국타이어";
			}else if(rows[list].wdKind=='b'){
				wdKind="B2B전용";
			}else{
				wdKind=rows[list].wdKind;
			}
			html += '<td>'+wdKind+'</td>';
			var wdDay = undefinedChk(rows[list].wdDay,"");
			wdDay = wdDay.replace("2", "월");
			wdDay = wdDay.replace("3", "화");
			wdDay = wdDay.replace("4", "수");
			wdDay = wdDay.replace("5", "목");
			wdDay = wdDay.replace("6", "금");
			wdDay = wdDay.replace("7", "토");
			wdDay = wdDay.replace("1", "일");
			html += '<td>'+wdDay+'</td>';
			var wdStDt = undefinedChk(rows[list].wdStDt,"");
			var wdEdDt = undefinedChk(rows[list].wdEdDt,"");
			wdStDt = wdStDt.substring(0,4)+"-"+wdStDt.substring(4,6)+"-"+wdStDt.substring(6,8);
			wdEdDt = wdEdDt.substring(0,4)+"-"+wdEdDt.substring(4,6)+"-"+wdEdDt.substring(6,8);
			html += '<td>'+wdStDt+' ~ '+wdEdDt+'</td>';	
			
			var wdStHour = undefinedChk(rows[list].wdStHour,"");
			wdStHour = wdStHour.substring(0,2)+":"+wdStHour.substring(2,4);
			var wdEdHour = undefinedChk(rows[list].wdEdHour,"");
			wdEdHour = wdEdHour.substring(0,2)+":"+wdEdHour.substring(2,4);
			var wdCanStHour = undefinedChk(rows[list].wdCanStHour,"");
			wdCanStHour = wdCanStHour.substring(0,2)+":"+wdCanStHour.substring(2,4);
			var wdCanEdHour = undefinedChk(rows[list].wdCanEdHour,"");
			wdCanEdHour = wdCanEdHour.substring(0,2)+":"+wdCanEdHour.substring(2,4);
			html += '<td>'+wdStHour+' ~ '+wdEdHour+'</td>';
			html += '<td>'+wdCanStHour+' ~ '+wdCanEdHour+'</td>';
			html += '<td>'+(undefinedChk(rows[list].wdCon,"")=='1'? '정상':'중단')+'</td>';
			html += '</tr>';
		}
	}
	$("#tbody").html(html);
}

</script>
</head>
<body>
   
	<button type="button" class="goRegButton">등록</button>
    <div id="data_list">
	    <div class="list_top">
	        <div class="fl">목록<span id="resultCnt" class="bold">${totalCnt}</span>건</div>
	        <div class="dflex"> 
	              <div class="form_group search_form end">
	                 <input type="text" name="" id="search" value="" placeholder="검색일" maxlength="50" />
	                 <button type="button" class="btn" id="searchBtn">검색</button>
	              </div>
	        </div>
	     </div>
			<table border="1">
			<caption class="hidden">요일/운영시간리스트입니다.</caption>
		        <colgroup>
		           <col width="">
		           <col width="">
		           <col width="20%">
		           <col width="17%">
		           <col width="">
		           <col width="">
		           <col width="">
		        </colgroup>
		        <thead>
		        <tr>
		            <th scope="col">NO</th>
		            <th scope="col">구분</th>
		            <th scope="col">운영요일</th>
		            <th scope="col">운영기간</th>
		            <th scope="col">실운영시간</th>
		            <th scope="col">예매가능시간</th>
		            <th scope="col">상태</th>
		        </tr>
		 		</thead>
		        <tbody id="tbody">
		        <c:if test="${totalCnt eq 0 }">
		        <tr>
		        	<td colspan="7">데이터가 존재하지 않습니다.</td>
		        </tr>
		        </c:if>
		        <c:if test="${fn:length(weekdayList) > 0 }">
			        <c:forEach var="result" items="${weekdayList.rows}" varStatus="status">
			            <tr class="godetail" data-selected="none">
			                <td><span class="hidden">${result.wdSeq}</span>${totalCnt-status.index}</td>
			                <td>
			                	<c:if test="${result.wdKind eq 't' }">한국타이어</c:if>
			                	<c:if test="${result.wdKind eq 'b' }">B2B전용</c:if>
			                	<c:if test="${result.wdKind ne 't' and result.wdKind ne 'b'}">${result.wdKind }</c:if>
			                </td>
			                <td>
			                	<c:set var="wdDay" value="${fn:replace(fn:replace(fn:replace(fn:replace(fn:replace(fn:replace(fn:replace(result.wdDay, '2', '월'), '3', '화'), '4', '수'), '5', '목'), '6', '금'), '7', '토'), '1', '일')}" /> 
			                	${wdDay }
			                </td>
			                <td>
			                	<c:set var="wdStDt" value="${result.wdStDt}"/>${fn:substring(wdStDt,0,4) }-${fn:substring(wdStDt,4,6) }-${fn:substring(wdStDt,6,8) } ~
			                	<c:set var="wdEdDt" value="${result.wdEdDt}"/>${fn:substring(wdEdDt,0,4) }-${fn:substring(wdEdDt,4,6) }-${fn:substring(wdEdDt,6,8) }
			                </td>
			                <td>
			                	<c:set var="wdStHour" value="${result.wdStHour}" />${fn:substring(wdStHour,0,2) }:${fn:substring(wdStHour,2,4) } ~ 
			                	<c:set var="wdEdHour" value="${result.wdEdHour}" />${fn:substring(wdEdHour,0,2) }:${fn:substring(wdEdHour,2,4) }
			                </td>
			                <td>
			                	<c:set var="wdCanStHour" value="${result.wdCanStHour}" />${fn:substring(wdCanStHour,0,2) }:${fn:substring(wdCanStHour,2,4) } ~ 
			                	<c:set var="wdCanEdHour" value="${result.wdCanEdHour}" />${fn:substring(wdCanEdHour,0,2) }:${fn:substring(wdCanEdHour,2,4) }
			                </td>
			                <td>
			                	<c:if test="${result.wdCon eq '1'}">정상</c:if>
			                	<c:if test="${result.wdCon ne '1'}">중단</c:if>
			                </td>
			            </tr>
			        </c:forEach>
			       </c:if>
		        </tbody>
		    </table>
		    <div>
		    
		    <jsp:include page="/WEB-INF/views/jsp/common/paging.jsp"/>
		 </div>
    </div>
    
    
   <!-- 등록폼 시작 -->
   <hr />
   <div id="data_area">
   <table border="1">
		<caption class="hidden">등록/수정폼입니다.</caption>
        <colgroup>
           <col width="15%">
           <col width="35%">
           <col width="15%">
           <col width="35%">
        </colgroup>
        <tr>
        	<th>상태</th>
        	<td colspan="3">
        		<input type="radio" name="wdCon" id="wdCon1" value="1" checked="checked" /><label for="wdCon1">정상</label>
        		<input type="radio" name="wdCon" id="wdCon0" value="0" /><label for="wdCon0">중단</label>
        		<p id="error_wdCon" class="error red"></p>
        	</td>
        </tr>
        <tr>
        	<th>구분</th>        	
        	<td class="left">
        		<input type="radio" name="wdKind" id="wdKindt" value="t" checked="checked" /><label for="wdKindt">한국타이어</label>
        		<input type="radio" name="wdKind" id="wdKindb" value="b" /><label for="wdKindb">B2B회원</label>        		
        		<input type="radio" name="wdKind" id="wdKinde" value="e" /><label for="wdKinde">그외</label>
        		<input type="text" name="wdKindEtc" id="wdKindEtc" value="" placeholder="구분입력" />
        		<p id="error_wdKind" class="error red"></p>
        	</td>
        	<th>운영요일</th>
        	<td>
	        	<input type="checkbox" name="wdDay" id="wdDay2" value="2" /><label for="wdDay2">월</label>
		        <input type="checkbox" name="wdDay" id="wdDay3" value="3" /><label for="wdDay3">화</label>
		        <input type="checkbox" name="wdDay" id="wdDay4" value="4" /><label for="wdDay4">수</label>
		        <input type="checkbox" name="wdDay" id="wdDay5" value="5" /><label for="wdDay5">목</label>
		        <input type="checkbox" name="wdDay" id="wdDay6" value="6" /><label for="wdDay6">금</label>
		        <input type="checkbox" name="wdDay" id="wdDay7" value="7" /><label for="wdDay7">토</label>
		        <input type="checkbox" name="wdDay" id="wdDay1" value="1" /><label for="wdDay1">일</label>
		        <p id="error_wdDay" class="error red"></p>
        	</td>
        </tr>
        <tr>
        	<th>운영기간</th>
        	<td colspan="3" class="left">
        		<input type="text" placeholder="운영기간" title="wdStDt" id="wdStDt" value="" />
        		<p id="error_wdStDt" class="error red"></p>
        	</td>
        </tr>
        <tr>
        	<th>실운영시간</th>
        	<td>
        		<select name="wdStHour" id="wdStHour">
		        	<option value="">시간선택</option>
		        	<c:forEach var="wdStHour" begin="6" end="20">
		        	<c:if test="${wdStHour < 10}"><c:set var="wdStHour" value="0${wdStHour}"/></c:if>
		        	<option value="${wdStHour }">${wdStHour }</option>
		        	</c:forEach> 
		        </select>시
        		<select name="wdStMin" id="wdStMin">
		        	<option value="">분선택</option>
		        	<c:forEach var="wdStMin" begin="0" end="50" step="5">
		        	<c:if test="${wdStMin < 10}"><c:set var="wdStMin" value="0${wdStMin}"/></c:if>
		        	<option value="${wdStMin }">${wdStMin }</option>
		        	</c:forEach> 
		        </select>분 ~ 
		        <select name="wdEdHour" id="wdEdHour">
		        	<option value="">시간선택</option>
		        	<c:forEach var="wdEdHour" begin="6" end="20">
		        	<c:if test="${wdEdHour < 10}"><c:set var="wdEdHour" value="0${wdEdHour}"/></c:if>
		        	<option value="${wdEdHour }">${wdEdHour }</option>
		        	</c:forEach> 
		        </select>시
		        <select name="wdEdMin" id="wdEdMin">
		        	<option value="">분선택</option>
		        	<c:forEach var="wdStMin" begin="0" end="50" step="5">
		        	<c:if test="${wdStMin < 10}"><c:set var="wdStMin" value="0${wdStMin}"/></c:if>
		        	<option value="${wdStMin }">${wdStMin }</option>
		        	</c:forEach> 
		        </select>분
		        <p id="error_time" class="error red"></p>
        	</td>
        	<th>예약가능시간</th>
        	<td>
        		<select name="wdCanStHour" id="wdCanStHour">
		        	<option value="">시간선택</option>
		        	<c:forEach var="wdCanStHour" begin="6" end="20">
		        	<c:if test="${wdCanStHour < 10}"><c:set var="wdCanStHour" value="0${wdCanStHour}"/></c:if>
		        	<option value="${wdCanStHour }">${wdCanStHour }</option>
		        	</c:forEach>
		        </select>시
        		<select name="wdCanStMin" id="wdCanStMin">
		        	<option value="">분선택</option>
		        	<c:forEach var="wdCanStMin" begin="0" end="50" step="5">
		        	<c:if test="${wdCanStMin < 10}"><c:set var="wdCanStMin" value="0${wdCanStMin}"/></c:if>
		        	<option value="${wdCanStMin }">${wdCanStMin }</option>
		        	</c:forEach> 
		        </select>분 ~ <select name="wdCanEdHour" id="wdCanEdHour">
		        	<option value="">시간선택</option>
		        	<c:forEach var="wdCanStHour" begin="6" end="20">
		        	<c:if test="${wdCanStHour < 10}"><c:set var="wdCanStHour" value="0${wdCanStHour}"/></c:if>
		        	<option value="${wdCanStHour }">${wdCanStHour }</option>
		        	</c:forEach> 
		        </select>시
		        <select name="wdCanEdMin" id="wdCanEdMin">
		        	<option value="">분선택</option>
		        	<c:forEach var="wdCanStMin" begin="0" end="50" step="5">
		        	<c:if test="${wdCanStMin < 10}"><c:set var="wdCanStMin" value="0${wdCanStMin}"/></c:if>
		        	<option value="${wdCanStMin }">${wdCanStMin }</option>
		        	</c:forEach> 
		        </select>분
		        <p id="error_canTime" class="error red"></p>
        	</td>
        </tr>
	</table>
	<div id="regInfo">
	</div>
      <div class="btn_regi_wrap">
         <button type="button" class="btn_cancel">취소</button>&nbsp;<button type="button" class="btn_regi reg" id="regBtn" data-branchCode="">저장</button>
      </div>
   </div>
   <!-- 등록폼 끝 -->
    <span id="pageNo" class="hidden"></span>
    <span id="wdSeq"></span>
</body>
</html>