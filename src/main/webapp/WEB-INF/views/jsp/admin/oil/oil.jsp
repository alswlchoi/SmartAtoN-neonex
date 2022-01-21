<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){
	alert("미기획된 페이지 입니다.(주유/세차현황)");
	$("button").click(function(){
		history.go(-1);
	});
})

</script>
 <!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>통계</span><span>주유/세차현황</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">주유/세차현황</h2>
        <!-- //title -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>