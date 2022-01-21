<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:csrfMetaTags/>
<script>
  function getParam(){
    var url = document.location.href;
    var pram;
    if (url.indexOf('#') >= 0){
      pram = url.substring(url.indexOf('?') + 1, url.indexOf('#')).split('&');
    } else {
      pram = url.substring(url.indexOf('?') + 1).split('&');
    }
    for(var i = 0, result = {}; i < pram.length; i++){
      pram[i] = pram[i].split('=');
      result[pram[i][0]] = decodeURIComponent(pram[i][1]);
    }
    return result;
  }
  var type;
  $(document).ready(function () {
    type = getParam().type;
    if (type == 'F') {
      $(".testInfoArea").hide();
    } else {
      $(".testInfoArea").show();
    }

    $("#info").hide();
    getDetail(getParam().reservedCode, type);
  });

  function getDetail(reservedCode, type) {
    var param = {
      text: type,
      reservCode: reservedCode
    };
    console.log(param);
    postAjax("/user/trReserve/detail", param, "drawDetail", null, null, null);
  }

  function drawDetail(list) {
    console.log(list);
    var detail = list.detail;
    if (detail.type == "단독"){
      $("#info").show();
    } else {
      $("#info").hide();
    }
    $('#reservCode').html(detail.reservCode);
    $('#regDt').html(moment(detail.regDt, "YYYYMMDDhhmmss").format("YYYY.MM.DD"));
    $('#type').html(detail.type);
    $('#name').html(detail.name);
    var date = '';
    date += '<p class="m-b-2">';
    var single = false;
    if (detail.stDt == detail.edDt) {
      // single = true;
      date += ''+moment(detail.stDt).format("YYYY.MM.DD")+'';
    } else {
      date += ''+moment(detail.stDt).format("YYYY.MM.DD") +" ~ "+ moment(detail.edDt).format("YYYY.MM.DD")+'';
    }
    date += '</p>';
    if (type == 'F') {
      date += '<span class="color_333">실 예약일수 : '+detail.papplyTime+'일</span><span class="icon_calendar datefromto"></span>';
    } else {
      date += '<span class="color_333">실 예약일수 : '+detail.realDate+'일</span><span class="icon_calendar datefromto"></span>';
    }
    $('#reservedDate').html(date);
    $('.datefromto').daterangepicker({
      autoApply: true,
      singleDatePicker: single,                  // 하나의 달력 사용 여부
      autoUpdateInput: true,
      locale: {
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
        yearSuffix: '년',
        separator:" ~ ",
        format: 'YYYY-MM-DD'
      },
      isInvalidDate: function(date) {
        var result = false;
        var value = detail.wssReservDay.split(",");
        console.log(value);
        for (var v in value) {
          console.log(value[v]);
          if (value[v] == moment(date).format("YYYYMMDD")) {
            result = true;
          }
        }
        /*value.every( (v, i, self) => {
          console.log(v);
          if (v == moment(date).format("YYYYMMDD")) {
            result = true;
          }
          return true;
        });*/

        if(result) {
          return false;
        } else {
          return true;
        }
      }
    }).on('select.daterangepicker',function(e){
      alert("날짜 변경은 불가능합니다.");
    }).on('show.daterangepicker',function(e){
      $("td.available").css({"background-color":"#ec6608", "cursor":"not-allowed", "color":"#fff"});
    });


    if (type == 'T') {
      if (detail.approval == 0) {
        $('#approval').html('승인대기<br/><button id="cancelBtn" type="button" class="btn-line-s btn_gray" data-layer="cancel_info">예약취소</button>');
      } else if (detail.approval == 3) {
        if (detail.step == '00000' || detail.step == '00001') {
          $('#approval').html('승인완료');
        } else if (detail.step == '00002' || detail.step == '00003') {
          $('#approval').html('이용완료');
        }
      } else if (detail.approval == 1) {
        $('#approval').html('반려<br /><button type="button" class="btn-line-s btn_default" data-layer="approval01">사유보기</button>');
      } else {
        $('#approval').html('취소');
      }
    } else {
      if (detail.approval == 'N') {
        $('#approval').html('승인대기<br/><button id="cancelBtn" type="button" class="btn-line-s btn_gray" data-layer="cancel_info">예약취소</button>');
      } else if (detail.approval == 'Y') {
        $('#approval').html('승인완료');
      } else if (detail.approval == 'D') {
        $('#approval').html('이용완료');
      } else if (detail.approval == 'C') {
        $('#approval').html('취소');
      } else {
        $('#approval').html('반려<br /><button type="button" class="btn-line-s btn_default" data-layer="approval01">사유보기</button>');
      }
    }

    // 운전자
    var driverHtml = "";
    for (var i in list.driver) {
      var driver = list.driver[i];
      if (i != list.driver.length-1) {
        driverHtml += ''+driver.dname+'('+driver.dlevel+') , ';
      } else {
        driverHtml += ''+driver.dname+'('+driver.dlevel+')';
      }
    }
    $('#driver').html(driverHtml);

    // 차량
    var carHtml = "";
    for (var i in list.car) {
      var car = list.car[i];
      if (i != list.car.length-1) {
        carHtml += ''+car.cname+'('+car.ccolor+'/'+car.cnumber+') , ';
      } else {
        carHtml += ''+car.cname+'('+car.ccolor+'/'+car.cnumber+')';
      }
    }
    $('#car').html(carHtml);

    $('#purpose').html(detail.purpose);

    $('#reason').html(detail.reason);
  }

  function doCancel() {
    var cancelCode = $('#reservCode').html();
    var stDt = $("#reservedDate > p").html().split(' ~ ')[0];
    var diff = moment(stDt).diff(moment(),'days')+1;
    console.log(diff);
    var param;
    if (diff > 7) { // 위약금 없음
      console.log("위약금 없음");
      param = {
        type: type,
        regUser: "<%=memberDto.getMemId()%>",
        compCode: "<%=memberDto.getCompCode()%>",
        reservCode: cancelCode,
        pcancel: 0
      }
    } else if (3 <= diff && diff <= 7) { // 위약금 50%
      console.log("위약금 50%");
      param = {
        type: type,
        regUser: "<%=memberDto.getMemId()%>",
        compCode: "<%=memberDto.getCompCode()%>",
        reservCode: cancelCode,
        pcancel: 50
      }
    } else { // 위약금 100%
      console.log("위약금 100%");
      param = {
        type: type,
        regUser: "<%=memberDto.getMemId()%>",
        compCode: "<%=memberDto.getCompCode()%>",
        reservCode: cancelCode,
        pcancel: 100
      }
    }
    postAjax("/user/trReserve/cancel", param, "resultAlert", null, null, null);
  }

  function resultAlert(list) {
    if (list != 0) {
      alert("취소에 성공했습니다.");
      $(".lyClose").click(function() {
        location.href = "/user/trReserve/myPage"
      });
    } else {
      alert("취소에 실패했습니다.");
    }
  }

  function goList() {
    location.href = "/user/trReserve/myPage";
  }
</script>
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
<%--        <div class="qrinfo">--%>
<%--            <span class="info_ment redfont">11:30부터 13:30분까지 사용가능합니다.</span>--%>
<%--        </div>--%>
        <h3 class="stitle">예약정보</h3><span id="info" class="info_ment redfont" style="float: right;">11:30부터 13:30분까지 사용가능합니다.</span>
        <!-- table list -->
        <section class="tbl_wrap_list m-t-20">
            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                <caption>테이블</caption>
                <colgroup>
                    <col width="215px" />
                    <col width="187px" />
                    <col width="146px" />
                    <col width="140px" />
                    <col width="335px" />
                    <col width="174px" />
                </colgroup>
                <thead>
                <tr>
                    <th scope="col">예약번호</th>
                    <th scope="col">접수일자</th>
                    <th scope="col">유형</th>
                    <th scope="col">항목</th>
                    <th scope="col">이용일자</th>
                    <th scope="col">상태</th>
                </tr>
                </thead>
                <tbody id="reservedInfo">
                <tr>
                    <td id="reservCode"></td>
                    <td id="regDt"></td>
                    <td id="type"></td>
                    <td id="name"></td>
                    <td id="reservedDate">
                        <%--<p class="m-b-2">2021.05.06 ~ 2021.05.15</p>
                        <span class="color_333">실 예약일수 : 5일</span><span class="icon_calendar datefromto"></span>--%>
                    </td>
                    <td id="approval"></td>
                </tr>
                </tbody>
            </table>
        </section>
        <!-- //table list -->
        <!-- //예약정보 -->
        <!-- 시험정보 -->
        <h3 class="stitle m-t-30 testInfoArea">시험정보</h3>
        <!-- table_view -->
        <div class="tbl_wrap_view m-t-10 testInfoArea">
            <table class="tbl_view01" summary="테이블입니다.">
                <caption>테이블입니다.</caption>
                <colgroup>
                    <col width="180px;" />
                    <col width="" />
                </colgroup>
                <tr>
                    <th scope="row">운전자</th>
                    <td colspan="3" id="driver"></td>
                </tr>
                <tr>
                    <th scope="row">시험차종</th>
                    <td colspan="3" id="car"></td>
                </tr>
                <tr>
                    <th scope="row">시험 종류 및 방법</th>
                    <td colspan="3" id="purpose"></td>
                </tr>
            </table>
        </div>
        <!-- //table_view -->
        <!-- //시험정보 -->

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
                    <td id="compName"><input id="compCode" type="hidden"><%=memberDto.getCompName()%></td>
                    <th>사업자등록번호</th>
                    <td id="compLicense"><%=memberDto.getCompLicense()%></td>
                </tr>
                <tr>
                    <th scope="row">신청자</th>
                    <td id="memName"><%=memberDto.getMemName()%></td>
                    <th>부서</th>
                    <td id="memDept"><%=memberDto.getMemDept()%></td>
                </tr>
                <tr>
                    <th scope="row">휴대폰 번호</th>
                    <td id="memPhone"><%=memberDto.getMemPhone()%></td>
                    <th>전화번호</th>
                    <td id="compPhone"><%=memberDto.getCompPhone()%></td>
                </tr>
                <tr>
                    <th scope="row">이메일 주소</th>
                    <td colspan="3" id="memEmail"><%=memberDto.getMemEmail()%></td>
                </tr>
                <tr>
                    <th scope="row">회계담당자</th>
                    <td id="acctName"><%=memberDto.getCompAcctName()%></td>
                    <th>부서</th>
                    <td id="acctDept"><%=memberDto.getCompAcctDept()%></td>
                </tr>
                <tr>
                    <th scope="row">이메일 주소</th>
                    <td id="acctEmail"><%=memberDto.getCompAcctEmail()%></td>
                    <th>전화번호</th>
                    <td id="compAcctPhone"><%=memberDto.getCompAcctPhone()%></td>
                </tr>
            </table>
        </section>
        <!-- //table_view -->
        <!-- //예약 신청자 및 회계 담당자 정보 -->
        <!-- button -->
        <section class="tac m-t-50">
            <button type="button" class="btn btn_gray" onclick="goList()">목록</button>
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
            <button type="button" class="btn-pop btn_default lyClose" onclick="doCancel()">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_Alert -->
<!-- popup_m -->
<div class="ly_group">
    <article class="layer_m approval01">
        <!-- # 타이틀 # -->
        <h1>심사결과 안내</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <div class="info_text02">
                <p>신청하신 정보에 대해 담당자 검토 결과<br />예약 승인이 거절되었습니다.</p>
                <p>[반려사유]</p>
                <br/>
                <p id="reason">선택하신 시험로에 대한 적합한 운전자가 없습니다.</p>
            </div>
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <!-- <button type="button" class="btn-pop btn_gray m-r-11">취소</button> -->
            <button type="button" class="btn-pop btn_default lyClose">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_m -->

<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>
