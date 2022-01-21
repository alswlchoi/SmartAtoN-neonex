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
	$("#registerBtn").click(function(){
		location.href="/member/adminRegister"
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
})
//조회
function search(page){
	var param = {
			authCode : $("#authCode").val(),
			searchKeyword : $("#searchKeyword").val(),
			memUseYn : $("input[name='memUseYn']:checked").val(),
			pageNo:page
	}
	console.log("조회 파람 = ",param);
	postAjax("/member/adminManagement/search",param,"searchCallback",null,null,null);
}
//조회콜백
function searchCallback(data){
	console.log("data = ",data);
	$("#adminList").html("");
	var html ='';
	var list = data.list;
	if(list.length>0){
		$.each(list,function(i,el){
			html += '<tr>';
			html += '<td>';
			html += list[i].rnum;
			html += '</td>';
			html += '<td>';
			if(list[i].memUseYn == 'Y'){
				html += '정상';
			}else if(list[i].memUseYn == 'N'){
				html += '사용중지';
			}else if(list[i].memUseYn == 'D'){
				html += '탈퇴';
			}else{
			}
			html += '</td>';
			html += '<td>';
			html += list[i].memId;
			html += '</td>';
			html += '<td>';
			html += '<a href="#" class="changePage" data-opt="'+list[i].memId+'">'+list[i].memName+'</a>';
			html += '</td>';
			html += '<td>';
			html += list[i].authNm;
			html += '</td>';
			html += '<td>';
			html += list[i].memRegUser;
			html += '</td>';
			html += '<td>';
			html += changeDateFormat(list[i].memRegDt);
			html += '</td>';
			html += '</tr>';
		});
	}else{
		html += '<tr class="tr_nodata">';
		html += '<td colspan="7">등록된 정보가 없습니다.</td>';
		html += '</tr>';
	}
	$("#adminList").html(html);
	drawingPage(data.paging);
	//수정페이지 이동
	$(".changePage").on("click",function(){
		var form = $("<form></form>");
		form.attr("action","/member/adminModify");
		form.attr("method","post");
		form.appendTo("body");
		var inputMemId = $('<input type="hidden" value='+$(this).attr("data-opt")+' name="memId">');
		form.append(inputMemId);
		var inputToken = $('<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">');
		form.append(inputToken);
		form.submit();
	})
}
</script>
<!-- container -->
        <div id="container">
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시스템관리</span><span>관리자관리</span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">관리자관리</h2>
                <!-- //title -->

                <!-- search_wrap -->
                <section class="search_wrap">
                    <div class="form_group">
                        <div class="select_group">
                            <select id="authCode" title="select" class="form_control">
                                <option value="">권한유형 선택</option>
                                <c:forEach var="list" items="${authList }">
                                	<c:if test="${list.authCode != 'A000' and list.authCode!='A002' }">
										<option value="${list.authCode }">${list.authNm }</option>
                                	</c:if>
								</c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="form_group w300">
                        <input type="text" id="searchKeyword" class="form_control" placeholder="관리자ID / 관리자명 입력" name="" maxlength="100"/>
                    </div>
                    <div class="form_group m-r-10">
                        <div class="radio_inline">
                        	<span class="label">상태</span>
		                    <label class="radio_default">
		                        <input type="radio" name="memUseYn" value="" checked>
		                        <span class="radio_icon"></span>전체</label>
		                    <label class="radio_default">
		                        <input type="radio" name="memUseYn" value="Y">
		                        <span class="radio_icon"></span>정상</label>
		                    <label class="radio_default">
		                        <input type="radio" name="memUseYn" value="N">
		                        <span class="radio_icon"></span>사용중지</label>
		                    <label class="radio_default">
		                        <input type="radio" name="memUseYn" value="D">
		                        <span class="radio_icon"></span>탈퇴</label>
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
                            <col width="" />
                            <col width="" />
                            <col width="220px" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col">번호</th>
                                <th scope="col">상태</th>
                                <th scope="col">ID(사번)</th>
                                <th scope="col">관리자명</th>
                                <th scope="col">권한유형</th>
                                <th scope="col">등록자</th>
                                <th scope="col">등록일시</th>
                            </tr>
                        </thead>
                        <tbody id="adminList">
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
            <!-- quickmenu -->
<!--             <div class="quickmenu_wrap"> -->
<%--                 <section> --%>
<!--                     <a href="#" class="test" title="시험로 시험관리">시험로<br />시험관리</a> -->
<!--                     <a href="#" class="gate" title="게이트 제어">게이트<br />제어</a> -->
<!--                     <a href="#" class="schedule" title="스케줄 관리">스케줄<br />관리</a> -->
<%--                 </section> --%>
<!--                 <a href="#" class="top" title="위로 이동"></a> -->
<!--             </div> -->
            <!-- //quickmenu -->
        </div>
        <!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>