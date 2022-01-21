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
<%
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
System.out.println("authentication = "+authentication);
MemberDto memberDto = new MemberDto();
System.out.println("authentication type = "+authentication.getPrincipal().getClass().getName() );
if(authentication.getPrincipal() instanceof String){
// 	System.out.println("로그인x");
}else{
	System.out.println("로그인o");
	memberDto = (MemberDto)authentication.getPrincipal();
	System.out.println("메뉴리스트");
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
    <title>::: [한국타이어] Technoring :::</title>

    <!-- 스타일 시트 -->
<!--     <link rel="stylesheet" type="text/css" href="./css/default.css"> -->
    <link rel="stylesheet" type="text/css" href="/inc/css/default.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/common.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/font.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/layout.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/daterangepicker.css"><!-- daterangepicker style -->
    <link rel="stylesheet" type="text/css" href="/inc/css/jquery-ui.css"><!-- jquery-ui style -->

    <!-- 스크립트 -->
    <script type="text/javascript" src="/inc/js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="/inc/js/navi.js"></script> <!-- navigation -->
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
.user{
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
$(function(){
	$(".user").click(function(){
		location.href = "/user/modify";
	})

	<%
	if(authentication.getPrincipal() instanceof String){
	%>
		//로그인 x
	<%}else{%>
		//로그인 o
		if("<%=memberDto.getAuthCode()%>" != "A000" && "<%=memberDto.getAuthCode()%>" != "A002" ){
			alert("관리자는 접근할 수 없습니다.");
			$("button").click(function(){
				location.href="/logout";
			})
		}
	<%}%>
})
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
                <h1 class="logo"><a href="/"><img src="/inc/images/BI_Technoring.png" alt="Technoring" /></a></h1>
                <div class="user_session">
					<%if(authentication.getPrincipal() instanceof String){%>
	                    <a class="join" href="/member/register" title="회원가입"></a>
    	                <a class="login" href="/login" title="로그인"></a>
					<%}else{ %>
	                    <span class="user"><%=memberDto.getCompName()==null?memberDto.getMemName():memberDto.getCompName() %></span><a class="logout" href="/logout" title="로그아웃"></a>
					<%}	%>
                </div>
            </div>
            <!-- navigation -->
            <div class="navi1">
                <div class="navi1Ul_wrap">
                    <ul class="navi1Ul">
                        <li class="">
                            <a class="oneD" target="_self" onclick="action('/before/technoring','all')">시험주행장</a>
                            <div class="twoD">
                                <a class="" target="_self" onclick="action('/before/technoring','all')">테크노링 소개</a>
                                <a class="" target="_self" onclick="action('/before/track','all')">트랙 소개</a>
                                <a class="" target="_self" onclick="action('/before/shop','all')">부대시설 안내</a>
                            </div>
                        </li>
                        <li class="">
                            <a class="oneD" target="_self" onclick="action('/user/trReserve','chk')">예약</a>
                            <div class="twoD">
                                <a class="" target="_self" onclick="action('/user/trReserve','chk')">시험로</a>
                                <a class="" target="_self" onclick="action('/user/userShop','chk')">부대시설</a>
                            </div>
                        </li>
                        <li class="">
                            <a class="oneD" target="_self" onclick="action('/user/notice/n','all')">고객지원</a>
                            <div class="twoD">
                                <a class="" target="_self" onclick="action('/user/notice/n','all')">공지사항</a>
                                <a class="" target="_self" onclick="action('/user/notice/s','all')">자료실</a>
                            </div>
                        </li>
                        <li class="">
                            <a class="oneD" target="_self" onclick="action('/user/trReserve/myPage','chk')">마이페이지</a>
                            <div class="twoD">
                                <a class="" target="_self" onclick="action('/user/trReserve/myPage','chk')">예약 및 이용내역</a>
                                <a class="" target="_self" onclick="action('/user/myPageCal','chk')">정산관리</a>
                                <a class="" target="_self" onclick="action('/user/modify','chk')">회원정보</a>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
            <!-- //navigation -->
        </div>
        <!-- //header_wrap -->

