<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
  $(document).ready(function () {
    toDayCnt();
    getNotice('n');
    nowTest();
  });

  $(function(){
    setInterval(function() {
      nowTest();
      weather();
      toDayCnt();
    }, 900000);
  })

  function toDayCnt() {
    var param = {}
    postAjax("/admin/main/list", param, "toDayView", null, null, null)
  }
  function toDayView(list) {
    var mainVo = list.mainVo;

    $("#member").html("등록 회원사 : <strong>"+mainVo.company+"건</strong> / 등록 운전자 : <strong>"+mainVo.driver+"건</strong>")
    $("#registerCnt").html("<a href=\"/admin/company\">"+mainVo.register+"</a>");
    $("#dayDriverCnt").html("<a href=\"/admin/driver\">"+mainVo.dayDriver+"</a>");
    $("#nTrackCnt").html("<a href=\"/admin/trReserve\">"+mainVo.ntrack+"</a>");
    $("#nShopCnt").html("<a href=\"/admin/reserved/shop\">"+mainVo.nshop+"</a>");
  }

  function getNotice(ntype) {
    var param = {
      ntype: ntype
    };
    postAjax("/admin/main/notice", param, "drawNotice", null, null, null)
  }
  function drawNotice(list) {
    var index = list.length;
    var noticeHtml = "";
    if (list.length > 0) {
      for (var i in list) {
        var notice = list[i];
        noticeHtml += "<tr>";
        noticeHtml += "<td>"+index+"</td>";
        noticeHtml += "<td class=\"tal\"><a href='/admin/notice/update-form?nSeq="+notice.nseq+"'>"+notice.ntitle+"</a></td>";
        noticeHtml += "<td>"+notice.nregUser+"</td>";
        noticeHtml += "<td>"+moment(notice.nregDt, 'YYYYMMDDhhmmss').format('YYYY.MM.DD')+"</td>";
        noticeHtml += "</tr>";

        index--;
      }
    }
    $("#notice").html(noticeHtml);
  }

  function nowTest() {
    var param = {
      // today: moment().format("YYYYMMDD")
    }
    postAjax("/admin/main/dayTesting", param, "nowTestView", null, null, null)
  }
  function nowTestView(list) {
    var dayTest = list.dayTest;
    updateTime();
    $("#dayTest").html(dayTest.dayTest);
    $("#total").html(dayTest.testingAll);
    $("#each").html("HK&nbsp;&nbsp;&nbsp;: "+dayTest.testingHK+"<br />B2B : "+dayTest.testingB2B+"");
    $("#dayShop").html(dayTest.dayShop);
  }

  function updateTime() {
    var  Now = new Date(),
        nowMon = String(Now.getMonth()+1),
        nowDate = String(Now.getDate()),
        nowDay = "";
    if(nowMon.length == 1) {
      nowMon = "0"+nowMon;
    }
    var nowH = String(Now.getHours());
    if(nowH.length == 1) {
      nowH = "0"+nowH;
    }
    var nowMin = String(Now.getMinutes());
    if(nowMin.length == 1) {
      nowMin = "0"+nowMin;
    }
    var nowSec = String(Now.getSeconds());
    if(nowSec.length == 1) {
      nowSec = "0"+nowSec;
    }

    switch (Now.getDay()) {
      case 1 :
        nowDay = "월";
        break;
      case 2 :
        nowDay = "화";
        break;
      case 3 :
        nowDay = "수";
        break;
      case 4 :
        nowDay = "목";
        break;
      case 5 :
        nowDay = "금";
        break;
      case 6 :
        nowDay = "토";
        break;
      case 0 :
        nowDay = "일";
        break;
    }
    var NowToday = nowMon+"."+nowDate+"("+nowDay+") "+nowH+":"+nowMin+":"+nowSec+" 갱신";

    $("#updateTime").text(NowToday);
  }
  function openTab(evt, tabName) {
      var i, tabcontent, tablinks;
      tabcontent = document.getElementsByClassName("tabcontent");
      for (i = 0; i < tabcontent.length; i++) {
          tabcontent[i].style.display = "none";
      }
      tablinks = document.getElementsByClassName("tablinks");
      for (i = 0; i < tablinks.length; i++) {
          tablinks[i].className = tablinks[i].className.replace(" active", "");
      }
      document.getElementById(tabName).style.display = "block";
      evt.currentTarget.className += " active";
  }
  // Get the element with id="defaultOpen" and click on it
  $("#defaultOpen").click();

  function goControll() {
    location.href = '/admin/controlsystem';
  }

</script>
<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>통합관제시스템</span></div>
        <!-- //breadcrumb -->
        <!-- wrap_left -->
        <div class="wrap_left">
            <!-- title -->
            <h2 class="title">통합관제시스템<button type="button" class="btn-line btn_gray fr" onclick="goControll()">컨트롤 보드</button></h2>
            <!-- //title -->
            <!-- row -->
            <div class="row">
                <div class="col">
                    <h3>회원현황
                        <span id="member"></span>
                    </h3>
                    <!-- table list -->
                    <section class="tbl_wrap_list m-t-10">
                        <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="50%" />
                                <col width="50%" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th scope="col">회원가입신청</th>
                                <th scope="col">금일운전자신청</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td id="registerCnt"><a href="#"></a></td>
                                <td id="dayDriverCnt"><a href="#"></a></td>
                            </tr>
                            </tbody>
                        </table>
                    </section>
                    <!-- //table list -->
                </div>
                <div class="col">
                    <h3>예약신청현황</h3>
                    <!-- table list -->
                    <section class="tbl_wrap_list m-t-10">
                        <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="50%" />
                                <col width="50%" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th scope="col">예약승인대기(시험로)</th>
                                <th scope="col">부대시설 승인대기</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td id="nTrackCnt"><a href="#"></a></td>
                                <td id="nShopCnt"><a href="#"></a></td>
                            </tr>
                            </tbody>
                        </table>
                    </section>
                    <!-- //table list -->
                </div>
            </div>
            <!-- //row -->
            <h3 class="m-t-19">공지사항</h3>
            <!-- table list -->
            <section class="tbl_wrap_list m-t-10">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="80px" />
                        <col width="" />
                        <col width="180px" />
                        <col width="180px" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">번호</th>
                        <th scope="col">제목</th>
                        <th scope="col">등록자</th>
                        <th scope="col">등록일</th>
                    </tr>
                    </thead>
                    <tbody id="notice">
                    </tbody>
                </table>
            </section>
            <!-- //table list -->
        </div>
        <!-- //wrap_left -->

        <!-- wrap_right -->
        <div class="wrap_right">
            <div class="update_time" id="updateTime">12.07(화) 13:00:00 갱신</div>
            <h3 class="m-t-30">전체현황</h3>
            <div class="wrap_totalState m-t-10">
                <div class="col01 m-t-11">
                    <span id="dayTest"></span>
                    <p>시험계획</p>
                </div>
                <div class="col02">
                            <span id="testing">
                                <small>Total</small>
                                <strong id="total"></strong>
                                <p class="state m-t-10" id="each"></p>
                            </span>
                    <p>시험중</p>
                </div>
                <div class="col03 m-t-11">
                    <span id="dayShop"></span>
                    <p>부대시설</p>
                </div>
            </div>
            <h3 class="m-t-21">기상정보</h3>
            <div class="wrap_weather m-t-10">
                <%@ include file="/WEB-INF/views/jsp/common/weather.jsp" %>
            </div>
            <h3 class="m-t-22">운전자/평가자 관리</h3>
            <div class="wrap_banner m-t-10">
                <a href="/admin/dccp" title="운전자 DCCP">운전자 DCCP</a>
                <a href="/admin/testerManage" title="시험자 관리">시험자 관리</a>
                <a href="/admin/testerManage/hintTester" title="평가자 관리">평가자 관리</a>
            </div>
            <h3 class="m-t-22">시험예약 관리</h3>
            <div class="wrap_banner2 m-t-10">
                <a href="/admin/trReserve/trcalendar" title="스케쥴 관리">스케쥴 관리</a>
            </div>
        </div>
        <!-- //wrap_right -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>