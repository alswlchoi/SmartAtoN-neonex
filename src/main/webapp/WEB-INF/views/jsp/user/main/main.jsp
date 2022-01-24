<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
  $(document).ready(function () {
    getNotice('n');
    getNotice('s');
  });
  function learnMore() {
    location.href='/before/track';
  }
  function getNotice(ntype) {
    var param = {
      ntype: ntype
    };
    postAjax("/before/notice", param, "drawNotice", null, null, null)
  }
  function drawNotice(list) {
    var noticeHtml = "";
    if (list.length > 0) {
      for (var i in list) {
        var notice = list[i];
        noticeHtml += '<li><a href=\"/user/notice/'+notice.ntype+'?nSeq='+notice.nseq+'\">'+notice.ntitle+'</a></li>';
      }
    }
    if (list[0].ntype == 'n') {
      $("#noticeN").append(noticeHtml);
    } else if (list[0].ntype == 's') {
      $("#noticeS").append(noticeHtml);
    }

  }
</script>
    <!-- container -->
    <div id="container">
        <!-- visual -->
        <div class="visual_main"></div>
        <!-- //visual -->
        <!-- content -->
        <div class="content no-padding">
            <section class="main_pic_wrap">
                <div class="box_pic"><a href="/before/track"><img src="/inc/images/img_main_pic01.png" alt="시험주행장" /></a></div>
                <div class="box_pic m-l-31"><a href="/before/track"><img src="/inc/images/img_main_pic02.png" alt="시험주행장" /></a></div>
                <div class="box_info m-l-31">
                    <p>고속 주행, 일반 주행,  진동, 제동 등의<br />다양한 시험 주행로와 시험에 필요한<br />최적의 기술을 제공합니다.</p>
                    <div class="tar m-t-25"><button id="learnMore" onclick=learnMore(); type="button" class="btn-sty1 btn_default">Learn more</button></div>
                </div>
            </section>
            <section class="m-t-28">
                <!-- 공지사항 -->
                <div class="notice_wrap">

                    <div class="title_wrap">공지사항<a href="/before/notice/n" title="더보기"></a></div>
                    <ul id="noticeN">
                    </ul>
                </div>
                <!-- //공지사항 -->
                <!-- 자료실 -->
                <div class="file_wrap m-l-31">
                    <div class="title_wrap">자료실<a href="/before/notice/s" title="더보기"></a></div>
                    <ul id="noticeS">
                    </ul>
                </div>
                <!-- //자료실 -->
                <!-- 배너 -->
                <div class="banner_wrap m-l-35">
                    <div>
                        <a href="/user/trReserve" class="technoring" title="시험주행로 예약바로가기">시험주행로<br />예약바로가기</a>
                        <a href="#" id="userInfo" onclick="alert('임시 이용안내');" class="help m-l-15" title="이용안내">이용안내</a>
                        <button id="reservBtn" type="button" class="btn btn_default" data-layer="reservation_pop" style="display: none">확인</button>
                    </div>
                    <%if(authentication.getPrincipal() instanceof String){%>
                    <a href="/member/approval" class="join_result m-t-20" title="회원가입 심사결과 조회">회원가입 심사결과 조회</a>
                    <%}else{ %>
                    <%}	%>

                </div>
                <!-- //배너 -->
            </section>
        </div>
        <!-- //content -->
    </div>
    <!-- //container -->

<!-- popup_xl -->
<div class="ly_group">
    <article class="layer_xl info_pop">
        <!-- # 타이틀 # -->
        <h1>트랙 이용 안내</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <!-- 예약정보 -->
            <h3 class="stitle m-t-30">링크 필요.</h3>
            <!-- table list -->

        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-6">취소</button>
            <button type="button" class="btn-pop btn_default lyClose">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_xl -->
<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>