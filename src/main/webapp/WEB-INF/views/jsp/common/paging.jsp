<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
//페이징 그리는 함수
function drawingPage(paging){
	/*
	console.log("paging"+paging);
	console.log("pageNo"+paging.pageNo);
	console.log("pageSize"+paging.pageSize);
	console.log("finalPageNo"+paging.finalPageNo);
	console.log("curRange"+paging.curRange);
	console.log("startPage"+paging.startPage);
	console.log("endPage"+paging.endPage);
	console.log("prevPage"+paging.prevPage);
	console.log("nextPage"+paging.nextPage);
	*/
	var html = "";
    html += '<span class="wrap">';
    if(paging.pageNo != 1){
		html += '<a class="pageNo btn_prev" data-page="'+paging.prevPage+'" style="cursor:pointer">';
		html += '   <i class="fas fa-angle-left"></i>';
		html += '</a>';
	}else{
		html += '<a class="btn_prev off" style="cursor:default">';
		html += '   <i class="fas fa-angle-left"></i>';
		html += '</a>';
	}
	for(var i=paging.startPage; i<=paging.endPage; i++){
		html += '<a class="pageNo" data-page="'+i+'" style="cursor:pointer">'+i+'</a>';
	}
	if(paging.finalPageNo > paging.pageNo){
		html += '<a class="pageNo btn_next" data-page="'+paging.nextPage+'" style="cursor:pointer">';
		html += '   <i class="fas fa-angle-left"></i>';
		html += '</a>';
	}else{
		html += '<a class="btn_next off" style="cursor:default">';
		html += '   <i class="fas fa-angle-left"></i>';
		html += '</a>';
	}
    html += '</span>';
	
	$("#pagingc").html(html);
	$("#pagingc a.btn_prev").attr("data-page",paging.prevPage);
	$("#pagingc a.pageNo").removeClass("on");
	$('#pagingc a[data-page="'+paging.pageNo+'"]').addClass("on");
}
</script>

<!-- pageing_start -->
    <span class='wrap'>
      <c:if test="${paging.pageNo ne 1 }">
       <fmt:parseNumber integerOnly="true" type="number" var="i" value="${paging.pageNo }"/>
          <a class="pageNo btn_prev" data-page="${paging.prevPage }" style="cursor:pointer">
              <i class="fas fa-angle-left"></i>
          </a>
      </c:if>
      <c:if test="${paging.pageNo eq 1 }">
          <a class="btn_prev off" style="cursor:default">
              <i class="fas fa-angle-left"></i>
          </a>
      </c:if>
     	<c:forEach var="item" begin="${paging.startPage }" end="${paging.endPage }" step="1" varStatus="status">
		<a class="pageNo<c:if test="${paging.pageNo == status.index }"> on</c:if>" data-page="${status.index }" style="cursor:pointer">${status.index }</a>
      </c:forEach>

      <c:if test="${paging.finalPageNo gt paging.pageNo }">
       <a class="pageNo btn_next" data-page="${paging.nextPage }" style="cursor:pointer">
           <i class="fas fa-angle-right"></i>
       </a>
      </span>
   </c:if>
      <c:if test="${paging.finalPageNo le paging.pageNo }">
       <a class="btn_next off" style="cursor:default">
           <i class="fas fa-angle-right"></i>
       </a>
   </c:if>
  <!-- pageing_end -->