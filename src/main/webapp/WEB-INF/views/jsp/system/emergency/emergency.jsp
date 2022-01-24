<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(function(){
	search(1);
	//페이징 조회 버튼
	$(document).on("click",".pageNo",function(){  // $(".pageNo").click(function(){
		search($(this).attr("data-page"));
	});
	//등록버튼
	$("#registerBtn").on("click",function(){
		if($(".add").length!=0){
			return;
		}
		postAjax("/admin/emergency/max",null,"registerBtnCallBack",null,null,null);
	})
	//등록버튼
	$(document).on("click",".insertBtn",function(e){
		if($(this).parents().parents().find("input[name='emergencyId']").val()==""){
			alert("코드ID를 입력해 주세요.");
			return;
		}
		if($(this).parents().parents().find("input[name='emergencyValue']").val()==""){
			alert("코드내용을 입력해 주세요.");
			return;
		}
		var param = {
				emergencyId:$(this).parents().parents().find("input[name='emergencyId']").val(),
				emergencyValue:$(this).parents().parents().find("input[name='emergencyValue']").val(),
				emergencyCode:$(this).attr("data-opt")
		}
		postAjax("/admin/emergency/insert",param,"insertCallback",null,null,null);
	});
})
//등록버튼 클릭 콜백
function registerBtnCallBack(data){
	console.log(data);
	var html = "";
	html += "<tr class='add'>";
	html += 	"<td>";
	html += 		'<div class="form_group w_full">';
//		html += 			'<input type="text" id="" class="form_control tac" placeholder="코드명 입력" name="emergencyCode" maxlength="6"/>'
	html += data.emergencyCode;
	html += 		'</div>';
	html += 	"</td>";
	html += 	"<td>";
	html += 		'<div class="form_group w_full">';
	html += 			'<input type="text" id="" class="form_control tac" placeholder="코드ID 입력" name="emergencyId" maxlength="100"/>'
	html += 		'</div>';
	html += 	"</td>";
	html += 	"<td>";
	html += 		'<div class="form_group w_full">';
	html += 			'<input type="text" id="" class="form_control tac" placeholder="코드값 입력" name="emergencyValue" maxlength="100"/>'
	html += 		'</div>';
	html += 	"</td>";
	html += "<td>";
	html += '<button type="button" class="btn-line-s btn_default m-r-6 insertBtn" data-opt="'+data.emergencyCode+'">등록</button>';
	html += '<button type="button" class="btn-line-s btn_gray cancelBtn">취소</button>';
	html += "</td>";
	html += "</tr>";
	$("#emergencyList").prepend(html);
	$(".cancelBtn").on("click",function(){
		$(this).parents("tr").remove();
	});
}
//등록콜백
function insertCallback(data){
	if(data>0){
		alert("등록에 성공했습니다.");
		$(".lyClose").click(function(){
			location.reload();
		})
	}else{
		alert("등록에 실패했습니다.");
	}
}
//조회
function search(page){
	var param = {
			pageNo:page
	}
	postAjax("/admin/emergency/search",param,"searchCallback",null,null,null);
}
//조회콜백
function searchCallback(data){
	$("#emergencyList").html("");
	console.log(data);
	var html ='';
	var list = data.list;
	if(list.length>0){
		$.each(list,function(i,el){
			html += "<tr>";
			html += 	"<td>";
			html += 		'<div class="form_group w_full">';
			html += 		list[i].emergencyCode;
			html += 		'</div>';
			html += 	"</td>";
			html += 	"<td>";
			html += 		'<div class="form_group w_full">';
			html += 			'<input type="text" id="" class="form_control tac emergencyId" placeholder="코드ID 입력" name="" value="'+list[i].emergencyId+'" data-opt="'+list[i].emergencyCode+'" maxlength="100"/>'
			html += 		'</div>';
			html += 	"</td>";
			html += 	"<td>";
			html += 		'<div class="form_group w_full">';
			html += 			'<input type="text" id="" class="form_control tac emergencyValue" placeholder="코드값 입력" name="" value="'+list[i].emergencyValue+'" data-opt="'+list[i].emergencyCode+'" maxlength="500"/>'
			html += 		'</div>';
			html += 	"</td>";
			html += 	"<td>";
			html += 		'<button type="button" class="btn-line-s btn_default m-r-6 updBtn" data-opt="'+list[i].emergencyCode+'">저장</button>';
			html += 		'<button type="button" class="btn-line-s btn_gray delBtn" data-opt="'+list[i].emergencyCode+'">삭제</button>';
			html += 	"</td>";
			html += "</tr>";
		})
	}else{
		html += '<tr class="tr_nodata">';
		html += '<td colspan="5">등록된 정보가 없습니다.</td>';
		html += '</tr>';
	}
	$("#emergencyList").html(html);
	drawingPage(data.paging);
	//수정버튼
	$(".updBtn").on('click',function(){
		upd($(this).attr("data-opt"),$(this));
	});
	//삭제버튼
	$(".delBtn").on('click',function(){
		del($(this).attr("data-opt"));
	});
}
//삭제
function del(emergencyCode){
	var param = {
			emergencyCode : emergencyCode
	}
	postAjax("/admin/emergency/del",param,"deleteCallback",null,null,null);
}
//삭제콜백
function deleteCallback(data){
	if(data>0){
		alert("삭제에 성공했습니다.");
		search(1);
	}else{
		alert("삭제에 실패했습니다.");
	}
}
//수정
function upd(emergencyCode,el){
	if($("input[data-opt='"+emergencyCode+"'].emergencyId").val()==""){
		alert("코드ID를 입력해 주세요.");
		return;
	}
	if($("input[data-opt='"+emergencyCode+"'].emergencyValue").val()==""){
		alert("코드내용을 입력해 주세요.");
		return;
	}
	var param = {
		emergencyCode:emergencyCode,
		emergencyId:$("input[data-opt='"+emergencyCode+"'].emergencyId").val(),
		emergencyValue:$("input[data-opt='"+emergencyCode+"'].emergencyValue").val()
	}
	console.log("upd param = ",param);
	postAjax("/admin/emergency/upd",param,"updateCallback",null,null,null);
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
</script>
<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시스템관리</span><span>비상상황 코드관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">비상상황 코드관리</h2>
        <!-- //title -->

        <!-- table list -->
        <section class="tbl_wrap_list m-t-30">
            <button type="button" class="btn btn_default posi_right_0_2" id="registerBtn">등록</button>
            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                <caption>테이블</caption>
                <colgroup>
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col">코드</th>
                        <th scope="col">코드ID</th>
                        <th scope="col">코드내용</th>
                        <th scope="col">조작</th>
                    </tr>
                </thead>
                <tbody id="emergencyList">

                </tbody>
            </table>
        </section>
        <!-- //table list -->
        <!-- Pagination -->
        <section id="pagingc" class="pagination m-t-30">
<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
</section>
  <!-- //Pagination -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>