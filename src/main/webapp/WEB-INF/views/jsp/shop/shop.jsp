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
<title>부대시설</title>
</head>
<body>
<h1>부대시설</h1>
<br>
<input type="text" id="shopName" value="" placeholder="shopName">
<button id="searchBtn">부대시설 검색</button>
<br>
부대시설 목록
<br>
<div id="shopList">
</div>
<div id="calendar"></div>
</body>
<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function() {
      var calendarEl = document.getElementById('calendar');
      var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth'
      });
      calendar.render();
    });

  $(document).ready(function () {
    $("#searchBtn").on("click",function() {
      search();
    });
  });
    function search() {
      var param = {wsName: $("#shopName").val()};
      postAjax("/admin/shop/list", param, "shopList", null, null, null)
    }
  function shopList(list) {
    $("#shopList").html("");
    var html = "";
    $.each(list,function(i,el){
      html += list[i].wscode +" , ";
      html += list[i].wsuseyn +" , ";
      html += list[i].wsprice +" , ";
      html += list[i].wsname;
      html += "<br/>";
    })
    $("#shopList").html(html);
  }
</script>
</html>