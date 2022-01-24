<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:csrfMetaTags/>
<script>
  $(document).ready(function () {
    $("input[name=dateto]").daterangepicker({
      locale: {
        separator: " ~ ",
        format: 'YYYY-MM-DD',
        applyLabel: "확인",
        cancelLabel: "취소",
        daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
      },
      timePicker: false,
      showDropdowns: true,
      autoApply: true,
      autoUpdateInput: false,
      timePicker24Hour: true,
      timePickerSeconds: true
    }, function(start, end, label){
      var approval = $("#useStatus option:selected").val();
      var sApproval = null, tApproval = null;
      if (approval == 'D') {
        sApproval = 'D';
        tApproval = '3';
      } else if (approval == 'R') {
        sApproval = 'R';
        tApproval = '1';
      }
      var param = {
        pageNo: 1,
        regUser: "<%=memberDto.getMemId()%>",
        stDate: moment(start).format("YYYYMMDD"),
        edDate: moment(end).format("YYYYMMDD"),
        sapproval: sApproval,
        tapproval: tApproval
      }
      console.log("!!!!!!!!");
      console.log(param);
      postAjax("/user/trReserve/useList", param, "drawUse", null, null, null)
    });

    $("input[name=dateto]").on('cancel.daterangepicker', function(ev, picker) {
      $(this).val('');
    });
    price();
    reservList(1);
    useList(1);

    //페이징 조회 버튼
    $(document).on("click","#pagingc>span>.pageNo",function(){
      reservList($(this).attr("data-page"));
    });
    $(document).on("click","#pagingl>span>.pageNo",function(){
      useList($(this).attr("data-page"));
    });

  });
  function useList2(start, end) {
    useList(1);
  }
  
  function price() {
    var param = {};
    postAjax("/user/trReserve/price", param, "drawPrice", null, null, null);
  }
  
  function drawPrice(list) {
    $("#shop").html("");
    var shopHtml = "";
    if (list.shop.length > 0) {
      for (var i in list.shop) {
        var shop = list.shop[i];
        shopHtml += '<tr>';
        shopHtml += '<td>'+shop.wsName+'</td>';
        shopHtml += '<td>'+comma(shop.wsPrice)+'</td>';
        shopHtml += '</tr>';
      }
    } else {
      shopHtml += '<tr class="tr_nodata">';
      shopHtml += '<td colspan="2">등록된 정보가 없습니다.</td>';
      shopHtml += '</tr>';
    }
    $("#shop").html(shopHtml);

    $("#fee").html("");
    var feeHtml = "";
    var fee = list.fee;
    feeHtml += '<tr>';
    feeHtml += '<td>'+fee.tname+'</td>';
    feeHtml += '<td>'+comma(fee.tprice)+'</td>';
    feeHtml += '</tr>';
    $("#fee").html(feeHtml);

    $("#track").html("");
    var trackHtml = "";
    if (list.track.length > 0) {
      for (var i in list.track) {
        var track = list.track[i];
        trackHtml += '<tr>';
        trackHtml += '<td>'+track.num+'</td>';
        trackHtml += '<td>'+track.tname+' ('+track.tnickName+')</td>';
        trackHtml += '<td>'+comma(track.tprice)+'</td>';
        trackHtml += '<td>'+comma(track.tpriceAdd)+'</td>';
        trackHtml += '<td>'+comma(track.tsolo)+'</td>';
        trackHtml += '</tr>';
      }
    } else {
      trackHtml += '<tr class="tr_nodata">';
      trackHtml += '<td colspan="5">등록된 정보가 없습니다.</td>';
      trackHtml += '</tr>';
    }
    $("#track").html(trackHtml);
  }

  function reservList(page) {
    var approval = $("#reservStatus option:selected").val();
    var sApproval = null, tApproval = null;
    if (approval == 'N') {
      sApproval = 'N';
      tApproval = '0';
    } else if (approval == 'Y') {
      sApproval = 'Y';
      tApproval = '3';
    }
    var param = {
      pageNo: page,
      regUser: "<%=memberDto.getMemId()%>",
      sapproval: sApproval,
      tapproval: tApproval
    }
    postAjax("/user/trReserve/reservList", param, "drawReserved", null, null, null)
  }

  function drawReserved(list) {
    $("#reservedList").html("");
    var reservHtml = "";
    if (list.reserved.length > 0) {
      for (var i in list.reserved) {
        var reserved = list.reserved[i];
        reservHtml += '<tr onmouseover="this.className=\'on\'" onmouseout="this.className=\'\'" onclick="goDetail(\''+reserved.reservCode+'\')">';
        reservHtml += '<td>'+reserved.reservCode+'</td>';
        reservHtml += '<td>'+moment(reserved.regDt, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';
        reservHtml += '<td>'+reserved.type+'</td>';
        reservHtml += '<td>'+reserved.name+'</td>';
        if (reserved.stDt == reserved.edDt) {
          reservHtml += '<td>'+moment(reserved.stDt).format("YYYY.MM.DD")+'</td>';
        } else {
          reservHtml += '<td>'+moment(reserved.stDt).format("YYYY.MM.DD")+' ~ '+moment(reserved.edDt).format("YYYY.MM.DD")+'</td>';
        }
        if (reserved.approval == '0' || reserved.approval == 'N') { // 승인대기
          reservHtml += '<td>승인대기<br/><button type="button" class="btn-line-s btn_gray" onclick="cancel(\''+reserved.reservCode+'\', \''+reserved.stDt+'\', event)">예약취소</button></td>';
        } else { // 승인완료
          reservHtml += '<td>승인완료</td>';
        }
      }
    } else {
      reservHtml += '<tr class="tr_nodata">';
      reservHtml += '<td colspan="6">조회된 데이터가 없습니다.</td>';
      reservHtml += '</tr>';
    }
    $("#reservedList").html(reservHtml);
    drawingPage(list.paging);
  }

  function cancel(reserveCode, stDt, e) {
    e.stopPropagation();
    $("#cancelCode").val(reserveCode);
    $("#stDt").val(stDt);
    $('[data-layer="cancel_info"]').click();
  }

  function doCancel() {
    var cancelCode = $("#cancelCode").val();
    var stDt = $("#stDt").val();
    var diff = moment(stDt).diff(moment(),'days')+1;
    var type;
    if (cancelCode.indexOf("T") >= 0) {
      type = "T";
    } else {
      type = "F";
    }
    var param;
    if (diff > 7) { // 위약금 없음
      param = {
        type: type,
        regUser: "<%=memberDto.getMemId()%>",
        compCode: "<%=memberDto.getCompCode()%>",
        reservCode: cancelCode,
        pcancel: 0
      }
    } else if (3 <= diff && diff <= 7) { // 위약금 50%
      param = {
        type: type,
        regUser: "<%=memberDto.getMemId()%>",
        compCode: "<%=memberDto.getCompCode()%>",
        reservCode: cancelCode,
        pcancel: 50
      }
    } else { // 위약금 100%
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
        location.reload();
      });
    } else {
      alert("취소에 실패했습니다.");
    }
  }

  function useList(page) {
    var approval = $("#useStatus option:selected").val();
    var sApproval = null, tApproval = null;
    if (approval == 'D') {
      sApproval = 'D';
      tApproval = '3';
    } else if (approval == 'R') {
      sApproval = 'R';
      tApproval = '1';
    }
    var date = $("#double").val();
    var stDt = null, edDt = null;
    if (date != '') {
      stDt = moment(date.split(' ~ ')[0]).format("YYYYMMDD");
      edDt = moment(date.split(' ~ ')[1]).format("YYYYMMDD");
    }
    var param = {
      pageNo: page,
      regUser: "<%=memberDto.getMemId()%>",
      stDate: stDt,
      edDate: edDt,
      sapproval: sApproval,
      tapproval: tApproval
    }
    console.log(param);
    postAjax("/user/trReserve/useList", param, "drawUse", null, null, null)
  }
  
  function drawUse(list) {
    $("#useList").html("");
    var useHtml = "";
    if (list.use.length > 0) {
      for (var i in list.use) {
        var use = list.use[i];
        useHtml += '<tr onmouseover="this.className=\'on\'" onmouseout="this.className=\'\'" onclick="goDetail(\''+use.reservCode+'\')">';
        useHtml += '<td>'+use.reservCode+'</td>';
        useHtml += '<td>'+moment(use.regDt, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';
        useHtml += '<td>'+use.type+'</td>';
        useHtml += '<td>'+use.name+'</td>';
        if (use.stDt == use.edDt) {
          useHtml += '<td>'+moment(use.stDt).format("YYYY.MM.DD")+'</td>';
        } else {
          useHtml += '<td>'+moment(use.stDt).format("YYYY.MM.DD")+' ~ '+moment(use.edDt).format("YYYY.MM.DD")+'</td>';
        }
        if (use.approval == '1' || use.approval == 'R') { // 반려
          useHtml += '<td>반려<br/><button type="button" class="btn-line-s btn_default" onclick="showReason(\''+use.reason+'\', event)">사유보기</button></td>';
        } else if (use.approval == '2' || use.approval == 'C') { // 취소
          useHtml += '<td>취소</td>';
        } else { // 이용완료
          useHtml += '<td>이용완료</td>';
        }
      }
    } else {
      useHtml += '<tr class="tr_nodata">';
      useHtml += '<td colspan="6">조회된 데이터가 없습니다.</td>';
      useHtml += '</tr>';
    }
    $("#useList").html(useHtml);
    drawingPage2(list.paging);
  }

  function showReason(reason, e) {
    e.stopPropagation();
    $("#reason").html(reason);
    $('[data-layer="approval01"]').click();
  }

  function goDetail(reservedCode) {
    var type;
    if (reservedCode.indexOf("T") >= 0) {
      type = 'T';
    } else {
      type = 'F';
    }
    location.href = "/user/trReserve/myPageDetail?reservedCode="+reservedCode+"&type="+type;
  }

  function reset() {
    $("#double").val("");
    $("#useStatus option:eq(0)").prop('selected', true);
    useList(1);
  }

  //인쇄하기
  function print() {
    $(".hidetag").hide();
    var divToPrint=document.getElementById('printarea');
    var newWin=window.open('','Print-Window');
    newWin.document.open();
    newWin.document.write('<html><link rel="stylesheet" type="text/css" href="/inc/css/default.css"><link rel="stylesheet" type="text/css" href="/inc/css/common.css"><link rel="stylesheet" type="text/css" href="/inc/css/font.css"><link rel="stylesheet" type="text/css" href="/inc/css/layout.css"><link rel="stylesheet" type="text/css" href="/inc/css/daterangepicker.css"><link rel="stylesheet" type="text/css" href="/inc/css/jquery-ui.css"><body onload="setTimeout(function(){window.print();},500)" style="width:1000px;height:auto;">'+divToPrint.innerHTML+'</body></html>');
    newWin.document.close();
    setTimeout(function(){newWin.close();},1000);
    $(".hidetag").show();
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
        <button type="button" class="memoBtn" style="display:none;" data-layer="cancel_info"></button>
        <button type="button" class="memoBtn" style="display:none;" data-layer="approval01"></button>
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>마이페이지</span><span>예약 및 이용내역</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">예약 및 이용내역</h2>
        <!-- //title -->
        <!-- 예약내역 -->
        <h3 class="stitle">예약내역
            <div class="form_group top0_2">
                <div class="select_group">
                    <select id="reservStatus" title="select" class="form_control" onchange="reservList(1)">
                        <option value="">전체</option>
                        <option value="N">승인대기</option>
                        <option value="Y">승인완료</option>
<%--                        <option value="D">이용완료</option>--%>
<%--                        <option value="R">반려/취소</option>--%>
                    </select>
                </div>
            </div>
        </h3>
        <!-- table list -->
        <section class="tbl_wrap_list m-t-15">
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
                    <th scope="col">예약일자</th>
                    <th scope="col">상태</th>
                </tr>
                </thead>
                <tbody id="reservedList">
                </tbody>
            </table>
        </section>
        <!-- //table list -->

        <!-- button -->
        <section><button type="button" class="btn-line btn_gray m-t-10" data-layer="charge">요금표 보기</button></section>
        <!-- //button -->

        <!-- Pagination -->
        <section id="pagingc" class="pagination m-t-30">
            <jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
        </section>
        <!-- //Pagination -->
        <!-- //예약내역 -->

        <!-- 이용내역 -->
        <h3 class="stitle m-t-50">이용내역
            <section>
                <div class="form_group w100" style="top: -12px;">
                    <button type="button" class="btn-s btn_default" onclick="reset()">검색초기화</button>
                </div>
                <div class="form_group w230">
                    <input type="hidden" id="useDate">
                    <input type="text" id="double" class="form_control dateicon datefromto" placeholder="기간선택" name="dateto" onchange="useList(1)">
                </div>
                <div class="form_group">
                    <div class="select_group">
                        <select id="useStatus" title="select" class="form_control" onchange="useList(1)">
                            <option value="">전체</option>
<%--                            <option value="N">승인대기</option>--%>
<%--                            <option value="Y">승인완료</option>--%>
                            <option value="D">이용완료</option>
                            <option value="R">취소/반려</option>
                        </select>
                    </div>
                </div>
            </section>
        </h3>
        <!-- table list -->
        <section class="tbl_wrap_list m-t-15">
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
                    <th scope="col">예약일자</th>
                    <th scope="col">상태</th>
                </tr>
                </thead>
                <tbody id="useList">
                </tbody>
            </table>
        </section>
        <!-- //table list -->
        <!-- Pagination -->
        <section id="pagingl" class="pagination m-t-30">
            <jsp:include page="/WEB-INF/views/jsp/common/paging2.jsp" />
        </section>
        <!-- //Pagination -->
        <!-- //이용내역 -->
        <!-- button -->
        <section class="tac m-t-50">
            <!-- <button type="button" class="btn btn_gray m-r-11">이전</button> -->
        </section>
        <!-- //button -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

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

<!-- popup_Alert -->
<div class="ly_group">
    <article class="layer_Alert cancel_info">
        <!-- # 타이틀 # -->
        <!-- <h1></h1> -->
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            예약취소시 위약금이 발생합니다. 부대시설 예약내역이 있는 경우 별도 취소해 주세요.<br /><br />
            <section class="tac color_red">- 7일이전 : 위약금 없음<br />- 7일 ~ 3일전 : 예약내역의 50%<br />- 2일전~ 시험당일 : 예약내역 100%
            </section>
            <br />예약을 취소하시겠습니까?
        </div>
        <input type="hidden" id="cancelCode">
        <input type="hidden" id="stDt">
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

<!-- popup_xxl -->
<div class="ly_group">
    <article class="layer_xxl charge printarea" id="printarea">
        <!-- # 타이틀 # -->
        <h1 class="hidetag">요금표 보기</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <h2>주행 시험장 요금표<button type="button" class="btn-line btn_gray hidetag" id="printBtn" onclick="print()">인쇄</button></h2>
            <h3 class="stitle m-t-57">워크샵 사용료<span class="fsd fr m-t-4">(단위:원, VAT 별도)</span></h3>
            <!-- table list -->
            <section class="tbl_wrap_list m-t-10">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="576px" />
                        <col width="" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">구분</th>
                        <th scope="col">일 임대료</th>
                    </tr>
                    </thead>
                    <tbody id="shop">
                    </tbody>
                </table>
                <span class="info_ment m-l-0 m-t-10">상기 금액 내 시설유지관리비 및 수도광열비 포함.</span>
            </section>
            <!-- //table list -->

            <h3 class="stitle m-t-57">기본 사용 요금<span class="fsd fr m-t-4">(단위:원, VAT 별도)</span></h3>
            <!-- table list -->
            <section class="tbl_wrap_list m-t-10">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="576px" />
                        <col width="" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">구분</th>
                        <th scope="col">가격</th>
                    </tr>
                    </thead>
                    <tbody id="fee">
                    </tbody>
                </table>
                <span class="info_ment m-l-0 m-t-10">출입 차량 대 수별 부과.</span>
            </section>
            <!-- //table list -->

            <h3 class="stitle m-t-30">시험로 사용료<span class="fsd fr m-t-4">(단위:원, VAT 별도)</span></h3>
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
                    </colgroup>
                    <thead>
                    <tr>
                        <th rowspan="2" scope="col">번호</th>
                        <th rowspan="2" scope="col">구분 (명칭 및 약어)</th>
                        <th colspan="2" scope="col" class="border-b-1">공동 사용 (1대당)</th>
                        <th scope="col" class="border-b-1">단독사용</th>
                    </tr>
                    <tr>
                        <th scope="col" class="border-l-1">기본 4시간</th>
                        <th scope="col">추가 1시간</th>
                        <th scope="col">1시간</th>
                    </tr>
                    </thead>
                    <tbody id="track">
                    </tbody>
                </table>
                <span class="info_ment m-l-0 m-t-10 disb">상기 금액 내 시설유지관리비 포함.</span>
                <span class="info_ment m-l-0 m-t-5 disb">복수 시험로 사용 시 높은 단가의 시험로 요금이 적용되며 사용시간 초과시 1시간 단위로 과금되니 이용에
                        참고바랍니다.</span>
            </section>
            <!-- //table list -->
            <section class="footer_estimate m-t-45">
                <span class="info_ment_orange m-l-0 m-t-6">상기 요금내용은 참고용이며, 공식문서로 사용될 수 없습니다.</span>
                <img src="/inc/images/ci_hankook_estimate.png" alt="Hankook" />
            </section>

        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_xxl -->
<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>
