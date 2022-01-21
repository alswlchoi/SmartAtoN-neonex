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

	//데이터 삭제
	$(document).on("click",'.delButton' ,function(){

			var currentRow=$(this).closest('tr');
			var compCode = currentRow.find('td:eq(0)').text();

			var result = confirm("정보를 삭제하시겠습니까?");
			if(result){
				$.ajax({
					url : "/company/deleteCompany",
					type : "get",
					data : {
						"compCode":compCode
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
		var emailCheck = RegExp(/^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/); 
		var idCheck= RegExp(/^[a-zA-Z0-9가-힣]{4,12}$/); 
		var nameCheck= RegExp(/^[a-zA-Z가-힣]+$/); 
		var phoneCheck= RegExp(/^[0-9-+]{8,11}$/);
		var fmt = RegExp(/^\d{6}[1234]\d{6}$/);
	
		if($(this).hasClass("reg")){
			$.ajax({
				url : "/company/insertCompany",
				type : "get",
				data : {
						"compLicense":$("#compLicense").val(),
						"compPhone":$("#compPhone").val(),
						"compTel":$("#compTel").val(),
						"compRegUser":$("#compRegUser").val()
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
	 			url : "/accounts/updateCompany",
	 			type : "get",
	 			data : {
						"compLicense":$("#compLicense").val(),
						"compPhone":$("#compPhone").children().val(),
						"compTel":$("#compTel").val(),
						"compRegUser":$("#compRegUser").val()
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

//등록 form 초기화
function reginit(){	
	$("#updBtn").text("등록");
	$("#updBtn").removeClass("upd");
	$("#updBtn").addClass("reg");
	$("#updBtn").attr("data-branchCode","");
	$("#updBtn").attr("id","regBtn");	
	$("#compCode").val("");
	$("#compLicense").val("");
	$("#compPhone").val("");
	$("#compTel").val("");
	$("#compRegUser").val("");
}

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
	var compCode = $("#search").val();

	if(type=="button" && compCode==""){
		alert("검색어를 입력하세요.");
		$("#search").focus();
		return false;
	}

	if(type == "button"){//버튼 검색 
		pageNo = "1";
	}else if(type == "paging"){//페이징 검색
		pageNo = $(".pageNo.active").attr("data-page"); 
	}
	
	$.ajax({
		url : "/company/searchCompany",
		type : "get",
		data : {
				"pageSize":pageSize,
				"pageNo"  :pageNo,
				"compCode":compCode
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
		html += '<td>'+undefinedChk(rows[list].compCode,"")+'</td>';
		html += '<td>'+undefinedChk(rows[list].compLicense,"")+'</td>';
		html += '<td>'+undefinedChk(rows[list].compPhone,"")+'</td>';
		html += '<td>'+undefinedChk(rows[list].compTel,"")+'</td>';
		html += '<td>'+undefinedChk(rows[list].compRegUser,"")+'</td>';
		var compRegDt = "";
		if(rows[list].compRegDt.length==14){
			compRegDt += rows[list].compRegDt.substring(0,4);
			compRegDt += "-";
			compRegDt += rows[list].compRegDt.substring(4,6);
			compRegDt += "-";
			compRegDt += rows[list].compRegDt.substring(6,8);
			compRegDt += " ";
			compRegDt += rows[list].compRegDt.substring(8,10);
			compRegDt += ":";
			compRegDt += rows[list].compRegDt.substring(10,12);
			compRegDt += ":";
			compRegDt += rows[list].compRegDt.substring(12,14);
		}
		html += '<td>'+compRegDt+'</td>';
		html += '<td><button type="button" class="tbtn mr3 defaultButton">상세보기</button></td>';
		html += '<td><button type="button" class="tbtn delButton">삭제</button></td>';
		html += '</td>';
		html += '</tr>';
	}
	$("#tbody").html(html);
}

</script>
</head>
<body>





   <!-- FormArea_start -->
   <div class="form_content form_group_wrap">
   	  <div class="form_group">
         <label class="control_label">compLicense</label>
         <input type="text" placeholder="compLicense" title="compLicense" id="compLicense" class="form_control" value="compLicense">
      </div>
   	  <div class="form_group">
         <label class="control_label">compPhone</label>
         <input type="text" placeholder="compPhone" title="compPhone" id="compPhone" class="form_control" value="compPhone">
      </div>
   	  <div class="form_group">
         <label class="control_label">compTel</label>
         <input type="text" placeholder="compTel" title="compTel" id="compTel" class="form_control" value="0320123456">
      </div>
   	  <div class="form_group">
         <label class="control_label">compRegUser</label>
         <input type="text" placeholder="compRegUser" title="compRegUser" id="compRegUser" class="form_control" value="compRegUser">
      </div>
      <div class="btn_regi_wrap">
         <button type="button" class="btn_regi reg" id="regBtn" data-branchCode="">등록</button>
      </div>
      </div>

   </div>
   <!-- FormArea_end -->
   
   
   
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
        <tr>
            <th>코드</th>
            <th>라이센스</th>
            <th>휴대전화번호</th>
            <th>전화번호</th>
            <th>등록자</th>
            <th>등록일</th>
            <th>상세보기</th>
            <th>삭제</th>
        </tr>
 
        <tbody id="tbody">
        <c:if test="${totalCnt eq 0 }">
        <tr>
        	<td colspan="8">데이터가 존재하지 않습니다.</td>
        </tr>
        </c:if>
        <c:if test="${fn:length(companyList) > 0 }">
	        <c:forEach var="result" items="${companyList.rows}" varStatus="status">
	            <tr <c:if test="${status.index%2 eq 1}">style="background-color :#ffffff;"</c:if> <c:if test="${status.index%2 ne 1}">style="background-color :#f6f7f8;"</c:if>>
	                <td><p>${result.compCode}</p></td>
	                <td><p>${result.compLicense}</td>
	                <td><p>${result.compPhone}</p></td>
	                <td><p>${result.compTel}</p></td>
	                <td><p>${result.compRegUser}</p></td>
	                <td><p><c:set var="compRegDt" value="${result.compRegDt}"/>${fn:substring(compRegDt,0,4) }-${fn:substring(compRegDt,4,6) }-${fn:substring(compRegDt,6,8) }</p></td>
	                <td><p><button type="button" class="tbtn mr3 defaultButton">상세보기</button></p></td>
	                <td><p><button type="button" class="tbtn delButton">삭제</button></p></td>
	            </tr>
	        </c:forEach>
	       </c:if>
        </tbody>
    </table>
    <div>
    
    <jsp:include page="/WEB-INF/views/jsp/common/paging.jsp"/>
    
    <a href="/company/write">등록</a></div>
</body>
</html>