<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp"%>
<spring:eval var="ifserver" expression="@environment.getProperty('environments.ifserver')" />
<sec:csrfMetaTags />
<script type="text/javascript">
	var ifserver = "${ifserver}";
	//트랙정보 3초 주기 갱신
	function procRfid(){
		var trackId = $("#trackId").val();
		var tag_id = $("#tag_id").val();
		var car_tag_id = $("#car_tag_id").val();
		var data = {
			"trackId":trackId,
			"tag_id"  :tag_id,
			"car_tag_id"  :car_tag_id
		};

		var url = ifserver+"/gate/rfid";	
		
		console.log(" 실행");
		postAjax(url,data,"success","fail", null, null);
	}
	
	function success(){
		alert("성공");
	}
	function fail(){
		alert("성공");
	}
</script>
</head>
<body>
<table>
<tr>
<td>트랙</td><td><input type="text" size="4" name="trackId" id="trackId" /></td>
</tr>
<tr>
<td>운전자 RID</td><td><input type="text" size="4" name="tag_id" id="tag_id" /></td>
</tr>
<tr>
<td>차량 RID</td><td><input type="text" size="4" name="car_tag_id" id="car_tag_id" /></td>
</tr>
</table>
<button name="btn" id="btn" onclick="procRfid()">클릭</button>

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp"%>