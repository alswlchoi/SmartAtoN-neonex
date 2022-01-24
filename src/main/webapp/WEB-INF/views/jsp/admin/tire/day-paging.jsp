<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
//페이징 그리는 함수
function drawingDayPage(paging){
	var html = "";
	if(paging.pageNo != 1){
		html += '<a class="dayPageNo btn_prev" data-page="'+paging.prevPage+'" style="cursor:pointer">';
		html += '   <i class="fas fa-angle-left"></i>';
		html += '</a>';
	}else{
		html += '<a class="btn_prev off" style="cursor:default">';
		html += '   <i class="fas fa-angle-left"></i>';
		html += '</a>';
	}
	html += '<span class="wrap">';
	for(var i=paging.startPage; i<=paging.endPage; i++){
		html += '<a class="dayPageNo" data-page="'+i+'" style="cursor:pointer">'+i+'</a>';
	}
	html += '</span>';
	if(paging.finalPageNo > paging.pageNo){
		html += '<a class="dayPageNo btn_next" data-page="'+paging.nextPage+'" style="cursor:pointer">';
		html += '   <i class="fas fa-angle-left"></i>';
		html += '</a>';
	}else{
		html += '<a class="btn_next off" style="cursor:default">';
		html += '   <i class="fas fa-angle-left"></i>';
		html += '</a>';
	}
	
	$("#day-paging").html(html);
	$("#day-paging a.btn_prev").attr("data-page",paging.prevPage);
	$("#day-paging a.dayPageNo").removeClass("on");
	$('#day-paging a[data-page="'+paging.pageNo+'"]').addClass("on");
}
</script>

<!-- pageing_start -->
      <c:if test="${paging.pageNo ne 1 }">
       <fmt:parseNumber integerOnly="true" type="number" var="i" value="${paging.pageNo }"/>
          <a class="dayPageNo btn_prev" data-page="${paging.prevPage }" style="cursor:pointer">
              <i class="fas fa-angle-left"></i>
          </a>
      </c:if>
      <c:if test="${paging.pageNo eq 1 }">
          <a class="btn_prev off" style="cursor:default">
              <i class="fas fa-angle-left"></i>
          </a>
      </c:if>
      <span class='wrap'>
     	<c:forEach var="item" begin="${paging.startPage }" end="${paging.endPage }" step="1" varStatus="status">
		<a class="dayPageNo<c:if test="${paging.pageNo == status.index }"> on</c:if>" data-page="${status.index }" style="cursor:pointer">${status.index }</a>
      </c:forEach>
      </span>
      <c:if test="${paging.finalPageNo gt paging.pageNo }">
       <a class="dayPageNo btn_next" data-page="${paging.nextPage }" style="cursor:pointer">
           <i class="fas fa-angle-right"></i>
       </a>
   </c:if>
      <c:if test="${paging.finalPageNo le paging.pageNo }">
       <a class="btn_next off" style="cursor:default">
           <i class="fas fa-angle-right"></i>
       </a>
   </c:if>
  <!-- pageing_end -->