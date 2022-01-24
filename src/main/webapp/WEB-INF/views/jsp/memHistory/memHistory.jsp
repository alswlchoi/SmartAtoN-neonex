<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="/inc/js/sh.js"></script>
<title>이 력</title>
</head>
<body>
<h1>이 력</h1>
<br>
이력목록
<br>
<div>
    <ul id="memHistoryList"></ul>
</div>
</body>
<script type="text/javascript">
$(document).ready(function () {
  var param = {};
  postAjax("/memHistory/list", param, "memHistoryList", null, null, null)
});
function memHistoryList(list) {
  // $("#memHistoryList").html("");
  // $.forEach(list, function (i,el) {
  //   $("#memHistoryList").append("<li>"+list[i].memId+)
  // })
}
</script>
</html>