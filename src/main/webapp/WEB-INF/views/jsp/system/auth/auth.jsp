<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){
	search(1);
	//페이징 조회 버튼
	$(document).on("click",".pageNo",function(){  // $(".pageNo").click(function(){
		search($(this).attr("data-page"));
	});
	//조회버튼
	$("#searchBtn").on("click",function(){
		search(1);
	});
	//조회 엔터키 처리
	$("#searchKeyword").focus(function(){
		$(this).keydown(function(k){
			if(k.keyCode == 13){
				search(1);
			}
		});
	});
	//등록버튼
	$("#registerBtn").on("click",function(){
// 		location.href="/system/auth/register";
		if($(".add").length!=0){
			return;
		}
		var html = "";
		html += "<tr class='add'>";
		//코드
		html += "<td>";
		html += '<div class="form_group w65">';
		html += '<input type="text" class="form_control" name="authCode" placeholder="코드" maxlength="4">';
		html += "</div>";
		html += "</td>";
		//권한유형
		html += "<td>";
		html += '<div class="form_group" style="width:80px !important;left:-40px;">';
		html += '<input type="text" class="form_control" name="authNm" style="width:170px !important;" placeholder="권한명" maxlength="15">';
		html += "</div>";
		html += "</td>";
		//초기화면
		html += "<td>";
		html += 		'<div class="form_group w_full">';
		html += 			'<div class="select_group">';
		html +=	'<select id="" title="select" class="form_control url" name="defaultUrl">';
        html += '<option value="/admin">관리자 메인화면</option>';
		<c:forEach var="m" items="${menuList }">
			<c:if test="${m.MParent ne '0'}">
				<c:if test="${m.MName eq '공지사항'}">
				html +=	'<option value="${m.MUrl}" selected>${m.MName}</option>';
				</c:if>
				<c:if test="${m.MName ne '공지사항'}">
				html +=	'<option value="${m.MUrl}">${m.MName}</option>';
				</c:if>
			</c:if>
		</c:forEach>
		html += "</select>";
		html += 			"</div>";
		html += 		"</div>";
		html += "</td>";
		html += "<td>";
		html += '<button type="button" class="btn-line-s btn_default m-r-6 insertBtn">등록</button>';
		html += '<button type="button" class="btn-line-s btn_gray id="cancelBtn"">취소</button>';
		html += "</td>";
		html += "</tr>";
		$("#authList").prepend(html);
		$("#cancelBtn").on("click",function(){
			$(this).parents("tr").remove();
		});
		//취소버튼
	});
	//등록버튼
	$(document).on("click",".insertBtn",function(e){
		if($(this).parents().parents().find("input[name='authCode']").val()==""){
			alert("권한코드를 입력해 주세요.");
			return;
		}
		if($(this).parents().parents().find("input[name='authCode']").val()=="undefined"){
			alert("권한코드를 입력해 주세요.");
			return;
		}
		if($(this).parents().parents().find("input[name='authCode']").val()=="null"){
			alert("권한코드를 입력해 주세요.");
			return;
		}
		if($(this).parents().parents().find("input[name='authNm']").val()==""){
			alert("권한명을 입력해 주세요.");
			return;
		}
		var param = {
				authCode:$(this).parents().parents().find("input[name='authCode']").val(),
				authNm:$(this).parents().parents().find("input[name='authNm']").val(),
				authDefaultUrl:$(this).parents().parents().find("select[name='defaultUrl']").val()
		}
		postAjax("/system/auth/insert",param,"insertCallback",null,null,null);
	});
})

//삭제
function del(authCode){
	var param = {
			authCode:authCode
	}
	postAjax("/system/auth/del",param,"deleteCallback",null,null,null);
}
//수정
function upd(authCode,el){
	var param = {
		authCode:authCode,
		authDefaultUrl:$("select[data-opt='"+authCode+"']").val()
	}
	console.log($("select[data-opt='"+authCode+"']").val());
	postAjax("/system/auth/upd",param,"updateCallback",null,null,null);
}
//등록콜백
function insertCallback(data){
	if(data==999){
		alert("이미 사용중인 코드 입니다.");
		return;
	}else if(data>0){
		alert("등록에 성공했습니다.");
		$(".lyClose").click(function(){
			location.reload();
		})
	}else{
		alert("등록에 실패했습니다.");
	}
}
//삭제콜백
function deleteCallback(data){
	if(data>0){
		alert("삭제에 성공했습니다.");
		search(1);
	}else{
		alert("해당 권한을 사용중인 계정이 있습니다.");
	}
}
//수정콜백
function updateCallback(data){
	if(data>0){
		alert("수정에 성공했습니다.");
		search(1);
	}else{
		alert("수정에 실패했습니다.");
	}
}
//조회
function search(page){
	var param = {
			authCode:$("#searchKeyword").val(),
			pageNo:page
	}
	postAjax("/system/auth/search",param,"searchCallback",null,null,null);
}
//조회콜백
function searchCallback(data){
	$("#authList").html("");
	var html ='';
	var list = data.list;
	if(list.length>0){
		$.each(list,function(i,el){
			html += "<tr>";
			html += 	"<td>";
			html += list[i].authCode;
			html += 	"</td>";
			html += 	'<td>';
			if(list[i].authCode == "A000" ||list[i].authCode == "A001"||list[i].authCode == "A002"){
				html += list[i].authNm;
			}else{
				html +=		'<a href="#" class="changePage" data-opt="'+list[i].authCode+'">';
				html += list[i].authNm;
				html += 	"</a>";
			}
			html += 	"</td>";
			html += 	"<td>";
			html += 		'<div class="form_group w_full">';
			html += 			'<div class="select_group">';
			if(list[i].authCode == "A000" ||list[i].authCode == "A002"){
				html +=					'<select id="" title="select" class="form_control url" readonly>';
				html +=						'<option value="/">사용자 메인화면</option>';
				html += 				"</select>";
			}else if(list[i].authCode == "A001"){
				html +=					'<select id="" title="select" class="form_control url" readonly>';
				html +=						'<option value="/admin">관리자 메인화면</option>';
				html += 				"</select>";
			}else{
				html +=					'<select id="" title="select" class="form_control url" data-opt="'+list[i].authCode+'">';
                html += '<option value="/admin" selected>관리자 메인화면</option>';
                <c:forEach var="m" items="${menuList }">
					<c:if test="${m.MParent ne '0'}">
						html +=						'<option value="${m.MUrl}" ';
						if(list[i].authDefaultUrl == "${m.MUrl}"){
							html+="selected"
						}
						html +=						'>${m.MName}</option>';
		// 				html +=						'<option value="">'+list[i].authDefaultUrlNm+'</option>';
					</c:if>
				</c:forEach>
				html += 				"</select>";
			}
			html += 			"</div>";
			html += 		"</div>";
			html += 	"</td>";
			html += 	"<td>";
			if(list[i].authCode == "A000" ||list[i].authCode == "A002"||list[i].authCode == "A001"){
			}else{
				html += 		'<button type="button" class="btn-line-s btn_default m-r-6 updBtn" data-opt="'+list[i].authCode+'">수정</button>';
				html += 		'<button type="button" class="btn-line-s btn_gray delBtn" data-opt="'+list[i].authCode+'">삭제</button>';
			}
			html += 	"</td>";
			html += "</tr>";
		})
	}else{
		html += '<tr class="tr_nodata">';
		html += '<td colspan="4">등록된 정보가 없습니다.</td>';
		html += '</tr>';
	}
	$("#authList").html(html);
	drawingPage(data.paging);
	//권한유형 클릭
	$(".changePage").on("click",function(){
		var form = $("<form></form>");
		form.attr("action","/system/auth/register");
		form.attr("method","post");
		form.appendTo("body");
		var inputAuthCode = $('<input type="hidden" value='+$(this).attr("data-opt")+' name="authCode">');
		form.append(inputAuthCode);
		var inputToken = $('<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">');
		form.append(inputToken);
		form.submit();
	})

	//수정버튼
	$(".updBtn").on('click',function(){
		upd($(this).attr("data-opt"),$(this));
	});
	//삭제버튼
	$(".delBtn").on('click',function(){
		del($(this).attr("data-opt"));
	});
}
</script>
 <!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시스템관리</span><span>메뉴 및 권한관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">메뉴 및 권한관리</h2>
        <!-- //title -->

        <!-- search_wrap -->
        <section class="search_wrap">
            <div class="form_group">
                <div class="select_group">
                    <select id="searchKeyword" title="select" class="form_control">
<!--                         <option value="">권한유형 선택</option> -->
<!--                         <option value="">전체</option> -->
<!--                         <option value="">선택하세요1</option> -->
<!--                         <option value="">선택하세요2</option> -->
						<option value="">전체</option>
						<c:forEach var="list" items="${authList }">
							<option value="${list.authCode }">${list.authNm }</option>
						</c:forEach>
                    </select>
                </div>
            </div>
            <button type="button" class="btn-s btn_default" id="searchBtn">조회</button>
        </section>
        <!-- //search_wrap -->
        <!-- table list -->
        <section class="tbl_wrap_list m-t-30">
            <button type="button" class="btn btn_default posi_right_0_2" id="registerBtn">등록</button>
            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                <caption>테이블</caption>
                <colgroup>
                    <col width="80px" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col">코드</th>
                        <th scope="col">권한유형</th>
                        <th scope="col">초기화면</th>
                        <th scope="col">비고</th>
                    </tr>
                </thead>
                <tbody id="authList">

                </tbody>
            </table>
        </section>
        <!-- //table list -->
		<section id="pagingc" class="pagination m-t-30">
			<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
		</section>
        <!-- //Pagination -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>