<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
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
    if (type == 'ready') {
      $("#statusTable").show();
      $("#rejTable").hide();
      $("#readyBtn").show();
      $("#rejectBtn").hide();
    } else {
      $("#statusTable").hide();
      $("#rejTable").show();
      $("#readyBtn").hide();
      $("#rejectBtn").show();
    }

    getDetail(getParam().reservedCode);
  })

  //탭 이동
  function pageMove(str){
    if(str=='tab1'){
      location.href = '/admin/trReserve';
    }else if(str == 'tab2'){
      location.href = '/admin/reserved/shop';
    }
  }

  $(function () {
    $(".webwidget_tab").webwidget_tab({
      window_padding: '0',
      head_text_color: '#999',
      head_current_text_color: '#333'
    });
  });

  function getDetail(reservedCode) {
    var param = {
      text: reservedCode
    };
    postAjax("/admin/reserved/detailInfo", param, "drawDetail", null, null, null)
  }

  function drawDetail(list) {
    var detailHtml = "";
    var list = list.list;
    var wssReservDay = list.wssReservDay.split(",");
    $("#statusList").html("");

    detailHtml += '<tr>';
    detailHtml += '<td><input type="hidden" value="'+list.wssSeq+'" id="wssSeq">'+list.wssReservCode+'</td>';
    detailHtml += '<td>'+moment(list.wssRegDt, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';
    detailHtml += '<td>';
    if (moment(list.wssStDay) == moment(list.wssEdDay)) {
      detailHtml += ''+moment(list.wssStDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'';
    } else {
      detailHtml += ''+moment(list.wssStDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+' ~ '+moment(list.wssEdDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'';
    }
    detailHtml += '</br>';
    detailHtml += '<span class="color_orange">실제사용일</span>';
    detailHtml += '<span style="overflow: hidden;text-overflow: ellipsis; white-space: nowrap;width:600px;">';
    for(var i in wssReservDay) {
      detailHtml += ' / '+moment(wssReservDay[i]).format("YYYY-MM-DD")+'';
    }
    detailHtml += '</span>';
    detailHtml += '</td>';
    detailHtml += '<td>'+list.wsName+'</td>';
    detailHtml += '<td>'+list.compName+'</td>';
    detailHtml += '<td><span class="color_red">승인완료</span></td>';
    detailHtml += '</tr>';

    $("#statusList").html(detailHtml);

    var compNameHtml = "";
    compNameHtml += ''+list.compName+'';
    if (list.blackList == 'Y') {
      compNameHtml += '<span class="color_red">(B/L)</span>';
    }
    $("#compName").html(compNameHtml);

    $("#compLicense").html(list.compLicense);
    $("#memName").html(list.memName);
    $("#memDept").html(list.memDept);
    $("#memPhone").html(list.memPhone);
    $("#compPhone").html(list.compPhone);
    $("#memEmail").html(list.memEmail);
    $("#compAcctName").html(list.compAcctName);
    $("#compAcctDept").html(list.compAcctDept);
    $("#compAcctEmail").html(list.compAcctEmail);
    $("#compAcctPhone").html(list.compAcctPhone);

    if (list.wssMemo != null) {
      $("#memo").val(""+list.wssMemo+"");
    }
  }

  function saveMemo() {
    var param = {
      wssSeq: $("#wssSeq").val(),
      wssReservCode: getParam().reservedCode,
      wssMemo: $("#memo").val(),
      wssModUser: "<%=memberDto.getMemId()%>"
    };
    postAjax("/admin/reserved/memo", param, "resultAlert", null, null, null)
  }

  function cancel() {
    var param = {
      wssSeq: $("#wssSeq").val(),
      wssApproval: 'R',
      wssReservCode: getParam().reservedCode,
      wssMemo: $("#cancelReason").val(),
      wssModUser: "<%=memberDto.getMemId()%>",
      memEmail: $("#memEmail").val()
    };
    postAjax("/admin/reserved/update", param, "resultAlert", null, null, null)
  }

  function resultAlert(result) {
    if (result == 1) {
      alert("저장이 완료되었습니다.");
      location.href = '/admin/reserved/schedule';
    } else {
      alert("저장에 실패하였습니다.");
    }
  }

  $(function(){
    $("#cancelReason").keyup(function(){
      bytesHandler(this);
    });
  });

  function getTextLength(str) {
    var len = 0;
    for(var i =0; i < str.length; i++) {
      var currentByte = str.charCodeAt(i);
      if(currentByte > 128) {
        len += 2;
      } else {
        len++;
      }
    }

    if (len > 500) {
      alert3("500Byte가 초과되었습니다.");
    }

    return len;
  }

  function bytesHandler(obj){
    var text = $(obj).val();
    $("#cancelReason_txt").text(getTextLength(text));
  }
</script>
<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시험관리</span><span>스케쥴관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">스케쥴관리</h2>
        <!-- //title -->

        <!-- tab -->
        <div class="wrap_tab">
            <div class="tab">
                <button class="tablinks" onclick="pageMove('tab1')" id="defaultOpen">시험로</button>
                <button class="tablinks active" onclick="pageMove('tab2')">부대시설</button>
            </div>
            <div class="wrap_tabcontent">
                <!-- tab2-부대시설 -->
                <div id="tab2" class="tabcontent">
                    <!-- table list -->
                    <section class="tbl_wrap_list">
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
                                <th scope="col">예약일자</th>
                                <th scope="col">항목</th>
                                <th scope="col">회사명</th>
                                <th scope="col">진행상태</th>
                            </tr>
                            </thead>
                            <tbody id="statusList">
                            <%--<tr>
                                <td>2020010101</td>
                                <td>2021.08.01</td>
                                <td>2021.09.02</td>
                                <td>워크샵A동</td>
                                <td>상신브레이크</td>
                                <td><span class="color_red">승인완료</span></td>
                            </tr>--%>
                            </tbody>
                        </table>
                    </section>
                    <!-- //table list -->

                    <!-- 예약 담당자 및 회계 담당자 정보 -->
                    <!-- accordion -->
                    <div class="wrap_accordion2 m-t-30">
                        <button class="accordion open">
                            <h3 class="stitle disib vam0">예약 담당자 및 회계 담당자 정보</h3>
                        </button>
                        <div class="accordion_panel" style="display: block;">
                            <!-- table_view -->
                            <section class="tbl_wrap_view">
                                <table class="tbl_view01" summary="테이블입니다.">
                                    <caption>테이블입니다.</caption>
                                    <colgroup>
                                        <col width="180px;" />
                                        <col width="" />
                                        <col width="180px;" />
                                        <col width="" />
                                    </colgroup>
                                    <tr>
                                        <th scope="row">회사명</th>
                                        <td id="compName"></td>
                                        <th>사업자등록번호</th>
                                        <td id="compLicense"></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">예약담당자</th>
                                        <td id="memName"></td>
                                        <th>부서</th>
                                        <td id="memDept"></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">휴대폰 번호</th>
                                        <td id="memPhone"></td>
                                        <th>전화번호</th>
                                        <td id="compPhone"></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">이메일 주소</th>
                                        <td colspan="3" id="memEmail"></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">회계담당자</th>
                                        <td id="compAcctName"></td>
                                        <th>부서</th>
                                        <td id="compAcctDept"></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">이메일 주소</th>
                                        <td id="compAcctEmail"></td>
                                        <th>전화번호</th>
                                        <td id="compAcctPhone"></td>
                                    </tr>
                                </table>
                            </section>
                            <!-- //table_view -->
                        </div>
                    </div>
                    <!-- //accordion -->

                    <!-- //예약 담당자 및 회계 담당자 정보 -->

                    <!-- 관리자 메모 -->
                    <h3 class="stitle m-t-30">관리자 메모</h3>
                    <!-- table_view -->
                    <div class="tbl_wrap_view m-t-10">
                        <table class="tbl_view01" summary="테이블입니다.">
                            <caption>테이블입니다.</caption>
                            <colgroup>
                                <col width="180px;" />
                                <col width="" />
                            </colgroup>
                            <tr>
                                <th scope="row">메모</th>
                                <td colspan="3">
                                    <div class="form_group w_full">
                                                <textarea name="" id="memo" cols="" rows="5" class="form_control  h100"
                                                          placeholder="메모를 입력하세요."></textarea>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_view -->
                    <!-- //관리자 메모 -->

                    <!-- button -->
                    <section class="btn_wrap m-t-50">
                        <button type="button" class="btn btn_gray" onclick="history.back()">목록</button>
                        <section>
                            <button type="button" class="btn btn_gray m-r-6" data-layer="cancel">취소</button>
                            <button type="button" class="btn btn_default" data-layer="complete" onclick="saveMemo()">저장</button>
                        </section>
                    </section>
                    <section class="btn_wrap tac m-t-0">
                        <button type="button" class="btn-line-b btn_gray m-r-6" data-layer="reason">예약 반려</button>
                        <!-- <button type="button" class="btn-sb btn_default" data-layer="complete2">예약 승인</button> -->
                    </section>
                    <!-- //button -->
                </div>
                <!-- //tab2-부대시설 -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

<!-- popup_Alert -->
<div class="ly_group">
    <article class="layer_Alert cancel">
        <!-- # 타이틀 # -->
        <!-- <h1></h1> -->
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            취소하시면 처음부터 다시<br />진행해야 됩니다.<br /><br />진행 하시겠습니까?
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button>
            <button type="button" class="btn-pop btn_default lyClose" onclick="getDetail(getParam().reservedCode)">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_Alert -->

<!-- popup_m -->
<div class="ly_group">
    <article class="layer_m reason">
        <!-- # 타이틀 # -->
        <h1>사유등록</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <div class="info_text03">
                <p>선택한 항목에 대해<br />반려 하시겠습니까?</p>
                <p>[사유등록]</p>
                <span class="info_ment_orange m-t-15 m-l-0">회원사에게 전송되는 정보이므로 등록 시 유의하시기 바랍니다.</span>
                <div class="form_group w_full m-t-10">
                        <textarea name="" id="cancelReason" cols="" rows="5" class="form_control" maxlength="250"
                                  placeholder="반려 사유를 등록해 주세요."></textarea>
                    <div class="count_txt"><span id="cancelReason_txt">0</span> / 500 bytes</div>
                </div>
            </div>
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button>
            <button type="button" class="btn-pop btn_default lyClose" onclick="cancel()">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_m -->

<!-- accordion -->
<script>
  var acc = document.getElementsByClassName("accordion");
  var i;

  for (i = 0; i < acc.length; i++) {
    acc[i].addEventListener("click", function () {
      this.classList.toggle("active");
      var panel = this.nextElementSibling;
      if (panel.style.display === "block") {
        panel.style.display = "none";
      } else {
        panel.style.display = "block";
      }
    });
  }
</script>
<!-- //accordion -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>