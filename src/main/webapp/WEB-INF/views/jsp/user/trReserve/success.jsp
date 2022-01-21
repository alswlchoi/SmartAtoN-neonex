<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<sec:csrfMetaTags/>
        <!-- container -->
        <div id="container">
            <!-- visual -->
            <div class="visual_sub reservation"></div>
            <!-- //visual -->
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>예약</span><span>시험로 예약</span></div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">시험로 예약</h2>
                <!-- //title -->
                <div class="box_txt02">
                    <span>시험로 예약 신청이 완료 되었습니다.</span>
                    <p class="m-t-30">마이페이지에서 견적서 출력, 신청 내용 확인이 가능합니다.<br />신청하신 정보에 대해 시험장 사정에 따라 반려 및 이용제한이 될 수 있습니다.<br />워크샵동 이용을  원하시는 경우  워크샵동 예약을 해 주시기 바랍니다. </p>
                </div>
                <!-- button -->
                <section class="tac m-t-50">
                    <button type="button" onclick="location.href='/user/trReserve/myPage'" class="btn btn_default m-r-11">예약 및 이용내역으로 이동</button>
	                <button type="button" onclick="location.href='/user/userShop'" class="btn btn_default">워크샵동 예약 바로가기</button>
                </section>
                <!-- //button -->
            </div>
            <!-- //content -->
        </div>
        <!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>