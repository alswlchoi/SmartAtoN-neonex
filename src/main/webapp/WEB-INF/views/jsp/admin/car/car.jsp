<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>목록</title>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
$(function(){
	$("#data_area").hide();	//페이지 로딩시 등록/수저폼 가림
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
	//회사 selectbox 데이터
	$.ajax({
		url : "/company/search-company",
		type : "get",
		data : {
			"pageSize" : 300
		},
		success : function(resdata){
			drawCompanySelect(resdata.rows, "");
			makeCompanyList(resdata.rows);
		},
		error : function(e){
			console.log(e);
		}
	});
	
	$(document).on("click",'.listButton' ,function(){
		$("#data_area").hide();
		search("list");
	});
	$(document).on("click",'.updButton' ,function(){
		$.ajax({
			url : "/car/detail-car",
			type : "get",
			data : {
				"cCode":$("#data_table>tbody>tr:eq(0)>td:eq(0)").text()
			},
			success : function(resdata){
				$("#data_detail").hide();
				$("#data_area").show();
				$("#cCode").prop("disabled",true);
				$("#cCode").val(undefinedChk(resdata.car.cCode,""));
				$("#compCode").val(undefinedChk(resdata.car.compCode,""));
				$("#cNumber").val(undefinedChk(resdata.car.cNumber,""));
				$("#cType").val(undefinedChk(resdata.car.cType,""));
				$("#carAge").val(undefinedChk(resdata.car.carAge,""));

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
		var cCode = $("#data_table>tbody>tr:eq(0)>td:eq(0)").text();
alert(cCode);
		var result = confirm("정보를 삭제하시겠습니까?");
		if(result){
			$.ajax({
				url : "/car/delete-car",
				type : "get",
				data : {
					"cCode":cCode
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
		if($("#cNumber").val() == ""){
			alert("차량번호를 입력하세요.");
			return false;
		}
		if($("#cType").val() == ""){
			alert("차량타입을 입력하세요.");
			return false;
		}
		if($("#compCode > option:selected").val()==""){
			alert("회사를 선택하세요.");
			return false;
		}
	
		if($(this).hasClass("reg")){
			$.ajax({
				url : "/car/insert-car",
				type : "get",
				data : {
					"cNumber":$("#cNumber").val(),
					"compCode":$("#compCode").val(),
					"cType":$("#cType").val(),
					"carAge":$("#carAge").val()
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
	 			url : "/car/update-car",
	 			type : "get",
	 			data : {
	 				"cCode":$("#cCode").val(),
	 				"cNumber":$("#cNumber").val(),
					"compCode":$("#compCode").val(),
					"cType":$("#cType").val(),
					"carAge":$("#carAge").val()
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
	var cNumber = $("#search").val();

	if(type=="button" && cNumber==""){
		alert("차량번호를 입력하세요.");
		$("#search").focus();
		return false;
	}
	if(type == "button"){//버튼 검색 
		pageNo = "1";
	}else if(type == "list") {//목록 버튼
		pageNo = $("#pageNo").text();
		$("#data_detail").hide();
	}else if(type == "paging"){//페이징 검색
		pageNo = $(".pageNo.active").attr("data-page"); 
	}
	$("#data_list").show();
	$.ajax({
		url : "/car/search-car",
		type : "get",
		data : {
				"pageSize":pageSize,
				"pageNo"  :pageNo,
				"cNumber":cNumber
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
$(document).on("click",".detailButton",function(){
	var currentRow=$(this).closest('tr');
	var pageSize = $("#pageSize").val();
	var pageNo;
	var cCode = currentRow.find('td:eq(0)').text();
	pageNo = $(".pageNo.active").attr("data-page");
	$("#pageNo").html(pageNo);
	
	$.ajax({
		url : "/car/detail-car",
		type : "get",
		data : {
			"pageSize":pageSize,
			"pageNo"  :pageNo,
			"cCode":cCode
		},
		success : function(resdata){
			drawingDetailTable(resdata.car);
		},
		error : function(e){
			console.log(e);
		}
	});
});	

//상세보기 테이블
function drawingDetailTable(car){
	$("#data_list").hide();
	$("#data_detail").show();
	var html='';

	html += '<table border="1" id="data_table">';
	html += '<tboy>';
	html += '<tr><th>차량순번</th><td>'+undefinedChk(car.cCode,"")+'</td></tr>';
	html += '<tr><th>회사명</th><td>'+undefinedChk(car.compCode,"")+'</td></tr>';
	html += '<tr><th>차량번호</th><td>'+undefinedChk(car.cNumber,"")+'</td></tr>';
	html += '<tr><th>차량타입</th><td>'+undefinedChk(car.cType,"")+'</td></tr>';
	html += '<tr><th>차량연식</th><td>'+undefinedChk(car.carAge,"")+'</td></tr>';
	html += '</tbody>';
	html += '</table>';
	html += '<div><button type="button" class="listButton"><i class="icon--ref">목록</i></button>';
	html += '<div><button type="button" class="updButton"><i class="icon--ref">수정</i></button>';
	html += '<button type="button" class="delButton"><i class="icon--del">삭제</i></button></div>';
	$("#data_detail").html(html);
}

//테이블 그리는 함수
function drawingTable(rows){
	var html='';
	for(var list in rows){
		html += '<tr class="tbtr" data-selected="none"';
		if(list%2 == 1){
			html += ' style="background-color :#ffffff;"';
		}else{
			html += ' style="background-color:#f6f7f8;"';
		}
		html += '>';
		html += '<td>'+undefinedChk(rows[list].cCode,"")+'</td>';
		html += '<td>'+undefinedChk(rows[list].compCode,"")+'</td>';
		html += '<td>'+undefinedChk(rows[list].cNumber,"")+'</td>';
		html += '<td>'+undefinedChk(rows[list].cType,"")+'</td>';
		html += '<td>'+undefinedChk(rows[list].carAge,"")+'</td>';
		html += '<td class="tac m_input">';
		html += '<button type="button" class="detailButton"><i class="icon--ref">상세보기</i></button>';
		html += '</td>';
		html += '</tr>';
	}
	$("#tbody").html(html);
}

//업체 정보 selectbox 생성 시작
function drawCompanySelect(rows, currentCompCode){
	var html='';
	html += '<select name="compCode" id="compCode">';
	html += '<option value="">회사선택</option>';
	for(var list in rows){
		html += '<option value="'+undefinedChk(rows[list].compCode,"")+'">'+undefinedChk(rows[list].compName,"")+'</td>';
	}
	html += '</select>';
	$("#complist").html(html)
}

</script>
</head>
<body>
   <!-- 등록폼 시작 -->
   <div id="data_area" class="form_content form_group_wrap">
   	  <div class="form_group">
         <label class="control_label">차량순번</label>
         <input type="text" placeholder="차량순번" title="cCode" id="cCode" class="form_control" value="자동생성" disabled="disabled" />※입력수정불가
      </div>
	  <div class="form_group">
	  	  <label class="control_label">회사선택</label>
		  <span id="complist"></span>
	  </div>
   	  <div class="form_group">
         <label class="control_label">차량번호</label>
         <input type="text" placeholder="차량번호" title="cNumber" id="cNumber" class="form_control" value="cNumber" />
      </div>
   	  <div class="form_group">
         <label class="control_label">차량타입</label>
         <input type="text" placeholder="차량타입" title="cType" id="cType" class="form_control" value="1" />
      </div>
   	  <div class="form_group">
         <label class="control_label">차량연식</label>
         <input type="text" placeholder="차량연식" title="carAge" id="carAge" class="form_control" value="1234" />
      </div>
      <div class="btn_regi_wrap">
         <button type="button" class="btn_regi reg" id="regBtn" data-branchCode="">등록</button>&nbsp;<button type="button" class="listButton"><i class="icon--ref">목록</i></button>
      </div>
   </div>
   <!-- 등록폼 끝 -->
   <!-- 상세보기 시작 -->
   <div id="data_detail">
   </div>
   <!-- 상세보기 끝 -->
   
    <div id="data_list">
	    <div class="list_top">
	        <div class="fl">목록<span id="resultCnt" class="bold">${totalCnt}</span>건</div>
	        <div class="dflex"> 
	              <div class="form_group search_form end">
	                 <input type="text" name="" id="search" value="" placeholder="업체코드" class="form_control" maxlength="50" />
	                 <button type="button" class="btn" id="searchBtn">검색</button>
	              </div>
	        </div>
	     </div>
			<table border="1">
			<caption class="hidden">회사리스트입니다.</caption>
		        <colgroup>
		           <col width="">
		           <col width="10%">
		           <col width="">
		           <col width="">
		           <col width="">
		           <col width="">
		        </colgroup>
		        <thead>
		        <tr>
		            <th scope="col">챠량순번</th>
		            <th scope="col">회사명</th>
		            <th scope="col">차량번호</th>
		            <th scope="col">차량타입</th>
		            <th scope="col">차량연식</th>
		            <th scope="col" class="tac">상세보기</th>
		        </tr>
		 		</thead>
		        <tbody id="tbody">
		        <c:if test="${totalCnt eq 0 }">
		        <tr>
		        	<td colspan="6">데이터가 존재하지 않습니다.</td>
		        </tr>
		        </c:if>
		        <c:if test="${fn:length(carList) > 0 }">
			        <c:forEach var="result" items="${carList.rows}" varStatus="status">
			            <tr class="tbtr" data-selected="none" <c:if test="${status.index%2 eq 1}">style="background-color :#ffffff;"</c:if> <c:if test="${status.index%2 ne 1}">style="background-color :#f6f7f8;"</c:if>>
			                <td><p>${result.cCode}</p></td>
			                <td><p>${result.compCode}</p></td>
			                <td><p>${result.cNumber}</td>
			                <td><p>${result.cType}</td>
			                <td><p>${result.carAge}</p></td>
			                <td class="tac m_input">
			                	<button type="button" class="detailButton"><i class="icon--ref">상세보기</i> </button>
			                </td>
			            </tr>
			        </c:forEach>
			       </c:if>
		        </tbody>
		    </table>
		    <div>
		    
		    <jsp:include page="/WEB-INF/views/jsp/common/paging.jsp"/>
		    
		    <button type="button" class="goRegButton">등록</button></div>
    </div>
    (<span id="pageNo"></span>)
</body>
</html>