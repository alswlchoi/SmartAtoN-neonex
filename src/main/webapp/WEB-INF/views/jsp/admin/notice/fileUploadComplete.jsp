<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="sec"
          uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="org.springframework.security.core.Authentication"%>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder"%>
<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>

<script type="text/javascript">
	var filePath = '${filePath}';
	var pattern = /upfiles\/editor/gi;
	filePath = filePath.replace('C:/Users/cotls/git/hankook-web/src/main/resources/static','');
	filePath = filePath.replace('/usr/hankook/web','');
	filePath = filePath.replace(pattern,'upfiles/editor?filename=');
    window.parent.CKEDITOR.tools.callFunction('${CKEditorFuncNum}',filePath, '');
</script>