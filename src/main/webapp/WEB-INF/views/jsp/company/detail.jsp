<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>${company.compLicense } 상세보기</title>
<script type="text/javascript">
	function bdDelte(){
		var conf = confirm("정말로 삭제하시겠습니까?");
		if(conf){
			document.frm.submit();
		}
	}
</script>
</head>
<body>
	<form name="frm" id="frm" method="post" action="/company/${company.compCode}">
	<input type="hidden" id="method" name="_method" value="delete" />
	
	<table border="1">
        <tr>
            <th>License</th><td>${company.compLicense }</td>
        </tr>
        <tr>
            <th>휴대전화번호</th><td>${company.compPhone }</td>
        </tr>
        <tr>
            <th>전화번호</th><td>${company.compTel }</td>
        </tr>
        <tr>
            <th>등록자</th><td>${company.compRegUser }</td>
        </tr>
    </table>
    
    <div>
    	<a href="/company">목록</a>&nbsp;<a href="/company/modify/${company.compCode }">수정</a>&nbsp;<a href="/company/${company.compCode }" onclick="bdDelte();return false">삭제</a>
    </div>
	</form>
</body>
</html>