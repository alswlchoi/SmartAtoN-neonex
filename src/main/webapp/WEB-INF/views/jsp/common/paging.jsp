<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
$(function(){
	
	
	//페이징 맨앞 버튼 클릭
	$(".pg_first").click(function(){
		$(".pageNo").each(function(index,item){
			if($(this).attr("data-page")==1){
				$(this).siblings().removeClass("active");
				$(this).addClass("active");
				$(this).hide();
			}
		});
	});
	
	//페이징 맨뒤 버튼 클릭
	$(".pg_last").click(function(){
		$(".pageNo").each(function(index,item){
			if($(this).attr("data-page")==index){
				$(this).siblings().removeClass("active");
				$(this).addClass("active");
			}
		});
	});
})
//페이징 그리는 함수
function drawingPage(paging){
		/*console.log("paging"+paging);
		console.log("pageNo"+paging.pageNo);
		console.log("pageSize"+paging.pageSize);
		console.log("finalPageNo"+paging.finalPageNo);
		console.log("curRange"+paging.curRange);
		console.log("startRowNum"+paging.startRowNum);
		console.log("endRowNum"+paging.endRowNum);
		console.log("prevPage"+paging.prevPage);
		console.log("nextPage"+paging.nextPage);*/
		var html = "";
		if(paging.pageNo != 1){
			html += '<button type="button" class="pg_first pageNo" data-page="1"></button>' ;
			html += '<button type="button" class="pg_prev pageNo" data-page="'+paging.prevPage+'"></button>';
		}else{
			html += '<button type="button" class="pg_first pageNo" data-page="1" style="display:none;"></button>';
			html += '<button type="button" class="pg_prev pageNo" style="display:none;"></button>';
		}
		for(var i=paging.startPage; i<=paging.endPage; i++){
			html += '<a href="#" class="pageNo" data-page="'+i+'">'+i+'</a>';
		}
		if(paging.pageNo < paging.finalPageNo){
			html += '<button type="button" class="pg_next pageNo" data-page="'+paging.nextPage+'"></button>' ;
			html += '<button type="button" class="pg_last pageNo" data-page="'+paging.finalPageNo+'"></button>';
		}else{
			html += '<button type="button" class="pg_next pageNo" data-page="'+paging.finalPageNo+'" style="display:none;"></button>';
			html += '<button type="button" class="pg_last pageNo" data-page="'+paging.finalPageNo+'" style="display:none;"></button>';
		}
		
		$(".pagination").html(html);
		$(".pg_prev").attr("data-page",paging.prevPage);
		$(".pageNo").removeClass("active");
		$('a[data-page="'+paging.pageNo+'"]').addClass("active");
}
//셀렉트 변경
function selectClick(){
	console.log();
	$('a[data-page="1"]').click();
}
</script>
<!-- pageing_start -->
      <div class="page_group">
         <div class="pagination">
            <c:if test="${paging.pageNo ne 1 }">
	            <button type="button" class="pg_first pageNo" data-page="1"></button>
	            <fmt:parseNumber integerOnly="true" type="number" var="i" value="${paging.pageNo }"/>
    	        <button type="button" class="pg_prev pageNo" data-page="${i - 1 }"></button>
            </c:if>
            <c:if test="${paging.pageNo eq 1 }">
	            <button type="button" class="pg_first pageNo" data-page="1" style="display:none;"></button>
    	        <button type="button" class="pg_prev pageNo" style="display:none;"></button>
            </c:if>
           	<c:forEach var="item" begin="${paging.startPage }" end="${paging.endPage }" step="1" varStatus="status">
				<c:if test="${status.index eq 1 }">
					<a href="#" class="pageNo active" data-page="1">1</a>
				</c:if>
				<c:if test="${status.index ne 1 }">
					<a href="#" class="pageNo" data-page="${status.index }">${status.index }</a>
				</c:if>
            </c:forEach>
            <c:if test="${paging.finalPageNo ne 1 }">
	            <button type="button" class="pg_next"></button>
	            <button type="button" class="pg_last pageNo" data-page="${paging.finalPageNo }"></button>
            </c:if>

         </div>
         <div class="page_select">
            <select title="" name="" id="pageSize" onchange="selectClick();">
               <option value="10" selected>10</option>
               <option value="15">15</option>
               <option value="20">20</option>
               <option value="25">25</option>
               <option value="30">30</option>
               <option value="35">35</option>
            </select>
         </div>
      </div>
      <!-- pageing_end -->