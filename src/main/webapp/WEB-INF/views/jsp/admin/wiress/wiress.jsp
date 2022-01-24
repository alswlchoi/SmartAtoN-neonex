<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib prefix="sec"
          uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
    <sec:csrfMetaTags/>
    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <script src="/inc/js/sh.js"></script>
<title>무전기</title>
</head>
<body>
<h1>무전기</h1>
<br>
<input type="text" id="wiressName" value="" placeholder="wiressName">
<button id="searchBtn">무전기 검색</button>
<br>
무전기목록
<br>
<div id="wiressList">
</div>
</body>
<script type="text/javascript">
  $(document).ready(function () {
    $("#searchBtn").on("click",function() {
      search();
    });
  });

  function search() {
    var param = {wName: $("#wiressName").val()};
    postAjax("/admin/wiress/list",param,"wiressList",null,null,null);
  }

  function wiressList(list) {
    $("#wiressList").html("");
    var html = "";
    $.each(list,function(i,el){
      html += list[i].cseq +" , ";
      html += list[i].cparent +" , ";
      html += list[i].cid +" , ";
      html += list[i].cname +" , ";
      html += list[i].cvalue +" , ";
      html += list[i].ctype +" , ";
      html += list[i].corder;
      html += "<br/>";
    })
    $("#wiressList").html(html);
  }
</script>
</html>