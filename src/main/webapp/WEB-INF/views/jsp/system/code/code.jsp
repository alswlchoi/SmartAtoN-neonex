<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="/inc/js/sh.js"></script>
<title>코드</title>
</head>
<body>
<h1>코드</h1>
<br>
<input type="text" id="codeName" value="" placeholder="codeName">
<button id="searchBtn">코드 검색</button>
<br>
코드목록
<br>
<div>
    <ul id="codeList"></ul>
</div>
</body>
<script type="text/javascript">
  $(document).ready(function () {
    $("#searchBtn").on("click",function() {
      var param = {cParent: $("#codeName").val()};
      postAjax("/system/code/list", param, "codeList", null, null, null)
    });
  });
  function codeList(list) {
    console.log(list);
  }
</script>
</html>