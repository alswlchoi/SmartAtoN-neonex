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
	$(document).on("click",'.listButton' ,function(){
		$("#data_area").hide();
		search("list");
	});
	$(document).on("click",'.updButton' ,function(){
		var tpId = $("#data_table>tbody>tr:eq(0)>td:eq(0)").text();
		$.ajax({
			url : "/trPackage/detail-trPackage",
			type : "get",
			data : {
				"tpId":tpId
			},
			success : function(resdata){
				$("#data_detail").hide();
				$("#data_area").show();
				$("#tpId").prop("disabled",true);
				$("#tpId").val(undefinedChk(resdata.trPackage.tpId,""));
				$("#tpName").val(undefinedChk(resdata.trPackage.tpName,""));
				$("#tId").val(undefinedChk(resdata.trPackage.tid,""));

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
		var tpId = $("#data_table>tbody>tr:eq(0)>td:eq(0)").text();
		alert(tpId);
		var result = confirm("정보를 삭제하시겠습니까?");

		if(result){
			$.ajax({
				url : "/trPackage/delete-trPackage",
				type : "get",
				data : {
					"tpId":tpId
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
		if($(this).hasClass("reg")){
			$.ajax({
				url : "/trPackage/insert-trPackage",
				type : "get",
				data : {
					"tpId":$("#tpId").val(),
					"tpName":$("#tpName").val(),
					"tId":$("#tId").val()
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
			var tpId = $("#tpId").val();
			var tpName = $("#tpName").val();
			var tId = $("#tId").val();
	  		$.ajax({
	 			url : "/trPackage/update-trPackage",
	 			type : "get",
	 			data : {
						"tpId":tpId,
						"tpName":tpName,
						"tId":tId
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
	var tId = $("#search").val();

	if(type=="button" && tId==""){
		alert("트랙아이디를 선택하세요.");
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
		url : "/trPackage/search-trPackage",
		type : "get",
		data : {
				"pageSize":pageSize,
				"pageNo"  :pageNo,
				"tId":tId
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
	var tpId = currentRow.find('td:eq(0)').text();
	
	pageNo = $(".pageNo.active").attr("data-page");
	$("#pageNo").html(pageNo);
	
	$.ajax({
		url : "/trPackage/detail-trPackage",
		type : "get",
		data : {
			"pageSize":pageSize,
			"pageNo"  :pageNo,
			"tpId":tpId
		},
		success : function(resdata){
			drawingDetailTable(resdata.trPackage);
		},
		error : function(e){
			console.log(e);
		}
	});
});	

//상세보기 테이블
function drawingDetailTable(trPackage){
	$("#data_list").hide();
	$("#data_detail").show();
	var html='';

	html += '<table border="1" id="data_table">';
	html += '<tbody>';
	html += '<tr><th>패키지아이디</th><td>'+undefinedChk(trPackage.tpId,"")+'</td></tr>';
	html += '<tr><th>패키지명</th><td>'+undefinedChk(trPackage.tpName,"")+'</td></tr>';
	html += '<tr><th>트랙아이디</th><td>'+undefinedChk(trPackage.tid,"")+'</td></tr>';
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
		html += '<td>'+undefinedChk(rows[list].tpId,"")+'</td>';
		html += '<td>'+undefinedChk(rows[list].tpName,"")+'</td>';
		html += '<td>'+undefinedChk(rows[list].tid,"")+'</td>';
		html += '<td class="tac m_input">';
		html += '<button type="button" class="detailButton"><i class="icon--ref">상세보기</i></button>';
		html += '</td>';
		html += '</tr>';
	}
	$("#tbody").html(html);
}

</script>
</head>
<body>
   <!-- 등록폼 시작 -->
   <div id="data_area" class="form_content form_group_wrap">
   	  <div class="form_group">
         <label class="control_label">패키지아이디</label>
         <input type="text" placeholder="패키지아이디" title="tpId" id="tpId" class="form_control" value="자동생성" disabled="disabled" />※입력수정불가
      </div>
   	  <div class="form_group">
         <label class="control_label">패키지명</label>
         <input type="text" placeholder="패키지명" title="tpName" id="tpName" class="form_control" value="패키지명" />
      </div>
   	  <div class="form_group">
         <label class="control_label">트랙아이디</label>
         <input type="text" placeholder="트랙아이디" title="tId" id="tId" class="form_control" value="T002" />
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
	                 <input type="text" name="" id="search" value="" placeholder="트랙아이디" class="form_control" maxlength="50" />
	                 <button type="button" class="btn" id="searchBtn">검색</button>
	              </div>
	        </div>
	     </div>
			<table border="1">
			<caption class="hidden">패키지리스트입니다.</caption>
		        <colgroup>
		           <col width="">
		           <col width="10%">
		           <col width="">
		           <col width="">
		           <col width="">
		        </colgroup>
		        <thead>
		        <tr>
		            <th scope="col">패키지아이디</th>
		            <th scope="col">패키지명</th>
		            <th scope="col">트랙아이디</th>
		            <th scope="col" class="tac">상세보기</th>
		        </tr>
		 		</thead>
		        <tbody id="tbody">
		        <c:if test="${totalCnt eq 0 }">
		        <tr>
		        	<td colspan="8">데이터가 존재하지 않습니다.</td>
		        </tr>
		        </c:if>
		        <c:if test="${fn:length(trPackageList) > 0 }">
			        <c:forEach var="result" items="${trPackageList.rows}" varStatus="status">
			            <tr class="tbtr" data-selected="none" <c:if test="${status.index%2 eq 1}">style="background-color :#ffffff;"</c:if> <c:if test="${status.index%2 ne 1}">style="background-color :#f6f7f8;"</c:if>>
			                <td><p>${result.tpId}</p></td>
			                <td><p>${result.tpName}</td>
			                <td><p>${result.TId}</p></td>
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