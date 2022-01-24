<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="sec"
          uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="org.springframework.security.core.Authentication"%>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder"%>
<%@ page import="com.hankook.pg.content.member.dto.MemberDto"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hankook.pg.content.login.dto.MenuDto"%>
<%
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
System.out.println("admin authentication = "+authentication);
MemberDto memberDto = new MemberDto();
System.out.println("authentication type = "+authentication.getPrincipal().getClass().getName() );
if(authentication.getPrincipal() instanceof String){
	System.out.println("로그인x");
}else{
	System.out.println("로그인o");
	memberDto = (MemberDto)authentication.getPrincipal();
	if(memberDto.getAuthCode().equals("A000")||memberDto.getAuthCode().equals("A002")){%>
		<jsp:forward page="/adminLogout" />
	<%}
// 	System.out.println("메뉴리스트");
// 	List<MenuDto> menuList = (List<MenuDto>) pageContext.getAttribute("menuList");
	pageContext.setAttribute("menuList", memberDto.getMenuList());
	for(int i=0;i<memberDto.getMenuList().size();i++){
		System.out.println("---"+memberDto.getMenuList().get(i));
	}
}
// MemberDto memberDto = (MemberDto)authentication.getPrincipal();
// System.out.println("member = "+memberDto);
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
    <title>::: [한국타이어] Technoring admin :::</title>

    <!-- 스타일 시트 -->
    <link rel="stylesheet" type="text/css" href="/inc/css/adminDefault.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/adminCommon.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/adminFont.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/adminLayout.css">
<!--     <link rel="stylesheet" type="text/css" href="/inc/css/default.css"> -->
<!--     <link rel="stylesheet" type="text/css" href="/inc/css/common.css"> -->
<!--     <link rel="stylesheet" type="text/css" href="/inc/css/font.css"> -->
<!--     <link rel="stylesheet" type="text/css" href="/inc/css/layout.css"> -->
    <link rel="stylesheet" type="text/css" href="/inc/css/daterangepicker.css"><!-- daterangepicker style -->
    <link rel="stylesheet" type="text/css" href="/inc/css/jquery-ui.css"><!-- jquery-ui style -->

    <!-- 스크립트 -->
    <script type="text/javascript" src="/inc/js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="/inc/js/adminNavi.js"></script> <!-- navigation -->
    <script type="text/javascript" src="/inc/js/common.js"></script>
    <script type="text/javascript" src="/inc/js/moment.min.js"></script> <!-- daterangepicker -->
    <script type="text/javascript" src="/inc/js/daterangepicker.js"></script> <!-- daterangepicker -->
    <script type="text/javascript" src="/inc/js/jquery-ui.js"></script> <!-- jquery-ui -->

    <!-- 공통 추가 -->
<!--     <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script> jquery 충돌로 주석처리-->
	<script src="/inc/js/sh.js"></script>
</head>
<style>
/* number 옆 화살표 제거 */
input[type="number"]::-webkit-outer-spin-button,
input[type="number"]::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}
a{
	cursor: pointer;
}
.mt20{
	margin-top: 20px;
}
.redfont{
	color: #ff0b0b;
}
.lodingdimm{position:fixed;display:block;width:100%;height:100%;background-color:rgba(255,255,255,0.8);left:0px;top:0px;z-index:10000;}
.loading{position:absolute;top:0;left:0;right:0;bottom:0;margin:auto;width:50px;height:50px;display:block;background:url(/inc/images/loading.gif) left top no-repeat;}
</style>
<script type="text/javascript">
$(function(){
	$(".oneD").click(function(){
// 		console.log($(this).siblings("div").find('a[target="_self"]').eq(0).attr("href"));
		location.href=$(this).siblings("div").find('a[target="_self"]').attr("href")
	})
})
function action(url,chk){
	var actionFlag = false;
	<%
	if(authentication.getPrincipal() instanceof String){
	%>
		//로그인 x
		location.href=url;
	<%}else{%>
		//로그인 o
		if(chk == "chk"){
		<%for(int i=0;i<memberDto.getMenuList().size();i++){%>
			if(url == "<%=memberDto.getMenuList().get(i).getMUrl()%>"){
// 				location.href = url;
				actionFlag = true;
			}
		<%}%>
			if(actionFlag || url =="/"){
				location.href= url;
			}else{
				alert("권한이 없는 계정입니다.");
			}
		}else if(chk =="all"){
			location.href = url;
		}
	<%}%>
// 	alert(url);
}
</script>
<body>
<div class="lodingdimm">
   <div class="loading"></div>
</div>
<!-- u_skip -->
<!--     <div id="u_skip"> -->
<!--         <a href="#container">본문 바로가기</a></li> -->
<!--     </div> -->
    <!-- //u_skip -->
<!-- wrapper -->
<div id="wrapper">
    <!-- header_wrap -->
    <div class="header_wrap">
        <div class="gnb_wrap">
            <h1 class="logo"><a href="/admin/main"><img src="/inc/images/BI_Technoring.png" alt="Technoring" /></a></h1>
			<div class="user_session">
				<%if(authentication.getPrincipal() instanceof String){%>
<!-- 	                   <a class="join" href="/member/register" title="회원가입"></a> -->
	  	               <a class="login" href="/adminLogin" title="로그인"></a>
				<%}else{ %>
					<a class="btn_dashboard" href="/admin/dashboard" title="대시보드"></a>
<!-- 					<a class="btn_main" href="/system" title="메인화면"></a> -->
	                   <span class="user"><%=memberDto.getMemName() %></span>
	                   <a class="logout" href="/adminLogout" title="로그아웃"></a>
				<%}	%>
            </div>
        </div>
        <!-- navigation -->
        <div class="navi1">
            <ul class="navi1Ul">
<%-- 				<c:forEach var="menu" items="${menuList }" varStatus="vs"> --%>
<%-- 				<c:if test='${menu.MLevel eq "1" }'> --%>
<!-- 					<li> -->
<%-- 						<a href="#" class="oneD" target="_self"><span>${menu.MName }</span></a> --%>
<%-- 						<c:if test="${menu.MSubTwo > 0 }"> --%>
<!-- 							<div class="twoD"> -->
<%-- 								<c:forEach begin="1" end="${menu.MSubTwo}" step="1" var="two"> --%>
<%-- 									<c:if test="${menuList[vs.index+two+menuList[vs.index+two-1].MSubThree].MParent eq menu.menuCode}"> --%>
<%-- 				                        <a href="${menuList[vs.index+two+menuList[vs.index+two-1].MSubThree].MUrl }" class="" target="_self">${menuList[vs.index+two+menuList[vs.index+two-1].MSubThree].MName }</a> --%>
<!-- 				                        <ul class="threeD"> -->
<%-- 				                        <c:if test="${menuList[vs.index+two+menuList[vs.index+two-1].MSubThree].MSubThree > 0}"> --%>
<%-- 						                        <c:forEach begin="1" end="${menuList[vs.index+two+menuList[vs.index+two-1].MSubThree].MSubThree}" step="1" var="three"> --%>
<%-- 							                        <c:if test="${menuList[vs.index+two+menuList[vs.index+two-1].MSubThree+three].MParent eq menuList[vs.index+two+menuList[vs.index+two-1].MSubThree].menuCode}"> --%>
<%-- 							                        	<li><a href="${menuList[vs.index+two+menuList[vs.index+two-1].MSubThree+three].MUrl}" class="threeD" target="_self">${menuList[vs.index+two+menuList[vs.index+two-1].MSubThree+three].MName}</a></li> --%>
<%-- 							                        </c:if> --%>
<%-- 						                        </c:forEach> --%>
<%-- 				                        </c:if> --%>
<!-- 				                        </ul> -->
<%-- 									</c:if> --%>
<%-- 								</c:forEach> --%>
<!-- 		                    </div> -->
<%-- 						</c:if> --%>
<!-- 					</li> -->
<%-- 				</c:if> --%>
<%-- 				</c:forEach> --%>
				<c:forEach var="menu" items="${menuList }" varStatus="vs">
					<c:if test='${menu.MLevel eq "1" }'>
						<li>
							<a href="#" class="oneD" target="_self"><span>${menu.MName }</span></a>
							<c:if test="${menu.MSubTwo > 0 }">
								<div class="twoD">
									<c:forEach items="${menuList}" var="two">
										<c:if test="${two.MParent eq menu.menuCode}">
											<a href="${two.MUrl }" class="" target="_self">${two.MName }</a>
											<c:if test="${two.MSubThree > 0 }">
												<ul class="threeD">
													<c:forEach items="${menuList}" var="three">
														<c:if test="${three.MParent eq two.menuCode}">
															<li><a href="${three.MUrl}" class="threeD" target="_self">${three.MName}</a></li>
														</c:if>
													</c:forEach>
												</ul>
											</c:if>
										</c:if>
									</c:forEach>
								</div>
							</c:if>
						</li>
					</c:if>
				</c:forEach>
            </ul>
        </div>
        <!-- //navigation -->
    </div>
    <!-- //header_wrap -->

