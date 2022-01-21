<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<sec:csrfMetaTags/>

<!-- container -->
<div id="container">
    <!-- visual -->
    <div class="visual_sub mypage"></div>
    <!-- //visual -->
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>마이페이지</span><span>예약 및 이용내역</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">예약 및 이용내역</h2>
        <!-- //title -->

        <!-- 예약정보 -->
        <h3 class="stitle">예약정보</h3>
        <!-- table list -->
        <section class="tbl_wrap_list m-t-10">
            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                <caption>테이블</caption>
                <colgroup>
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                </colgroup>
                <thead>
                <tr>
                    <th scope="col">예약번호</th>
                    <th scope="col">접수일자</th>
                    <th scope="col">유형</th>
                    <th scope="col">항목</th>
                    <th scope="col">이용일시</th>
                    <th scope="col">상태</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>2020010101</td>
                    <td>2021.08.01</td>
                    <td>공동</td>
                    <td>워크샵 A동</td>
                    <td>2021.09.02</td>
                    <td>이용완료</td>
                </tr>
                </tbody>
            </table>
        </section>
        <!-- //table list -->
        <!-- //예약정보 -->

        <!-- 예약 신청자 및 회계 담당자 정보 -->
        <h3 class="stitle m-t-30">예약 신청자 및 회계 담당자 정보</h3>
        <!-- table_view -->
        <section class="tbl_wrap_view m-t-10">
            <table class="tbl_view01" summary="테이블입니다.">
                <caption>테이블입니다.</caption>
                <colgroup>
                    <col width="180px;" />
                    <col width="421px" />
                    <col width="180px;" />
                    <col width="421px" />
                </colgroup>
                <tr>
                    <th scope="row">회사명</th>
                    <td>네오자동차</td>
                    <th>사업자등록번호</th>
                    <td>333-22-55555</td>
                </tr>
                <tr>
                    <th scope="row">신청자</th>
                    <td>김길동</td>
                    <th>부서</th>
                    <td>디자털 기술부</td>
                </tr>
                <tr>
                    <th scope="row">휴대폰 번호</th>
                    <td>010-1234-5678</td>
                    <th>전화번호</th>
                    <td>02-1234-5678</td>
                </tr>
                <tr>
                    <th scope="row">이메일 주소</th>
                    <td colspan="3">aaaa@aaaa.com</td>
                </tr>
                <tr>
                    <th scope="row">회계담당자</th>
                    <td>김길동</td>
                    <th>부서</th>
                    <td>디지털 기술부</td>
                </tr>
                <tr>
                    <th scope="row">이메일 주소</th>
                    <td>aaaa@cccc.com</td>
                    <th>전화번호</th>
                    <td>02-1234-5678</td>
                </tr>
            </table>
        </section>
        <!-- //table_view -->
        <!-- //예약 신청자 및 회계 담당자 정보 -->
        <!-- button -->
        <section class="tac m-t-50">
            <button type="button" class="btn btn_gray">목록</button>
            <!-- <button type="button" class="btn btn_default">확인</button> -->
        </section>
        <!-- //button -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

<!-- popup_Alert -->
<div class="ly_group">
    <article class="layer_Alert cancel_info">
        <!-- # 타이틀 # -->
        <!-- <h1></h1> -->
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            예약취소시 위약금이 발생합니다.<br /><br />
            <section class="tac color_red">- 7일이전 : 위약금 없음<br />- 7일 ~ 3일전 : 예약내역의 50%<br />- 2일전~ 시험당일 : 예약내역 100%</section>
            <br />예약을 취소하시겠습니까?
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button>
            <button type="button" class="btn-pop btn_default lyClose">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_Alert -->

<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>