<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
  $(document).ready(function () {
    // var test = document.querySelector('input');
    // test.addEventListener('input', evt, evt.target);

    rwTesterSearch(1);
    testerSearch(1, 'S');
    //페이징 조회 버튼
    $(document).on("click","#pagingc>span>.pageNo",function(){
      rwTesterSearch($(this).attr("data-page"));
    });
    $(document).on("click","#pagingl>span>.pageNo",function(){
      testerSearch($(this).attr("data-page"), 'S');
    });
  });

  //탭 이동
  function pageMove(str){
    if(str=='tab1'){
      location.href = '/admin/testerManage/hintTester';
    }else if(str == 'tab2'){
      location.href = '/admin/testerManage/hintCar';
    }else if(str == 'tab3'){
      location.href = '/admin/testerManage/hintStop';
    }
  }

  // 평가자 조회 테이블(R/W)
  function rwTesterSearch(page) {
    var param = {
      pageNo: page,
      text: $("#testerSearch").val(),
      type: 'rw'
    }
    postAjax("/admin/testerManage/testerList", param, "showTesterRW", null, null, null)
  }
  function showTesterRW(list) {
    console.log(list);
    $("#tester").html("");
    var testerHtml = "";
    if (list.tester.length > 0) {
      for (var i in list.tester) {
        var tester = list.tester[i];
        testerHtml += '<tr>';
        testerHtml += '<td>'+tester.name+'('+tester.employeeNo+')</td>';
        testerHtml += '<td>'+tester.rid+'</td>';
        var wch = "";
        if (tester.wch != null) {wch = tester.wch;}
        testerHtml += '<td>'+wch+'</td>';
        testerHtml += '<td>'+tester.wid+'</td>';
        // testerHtml += '<td>'+moment(tester.crnDtm).format("YYYY.MM.DD")+'</td>';
        if (tester.rreturn == null || tester.rreturn == "") {
          testerHtml += '<td><button type="button" onclick="rReturn('+tester.hrSeq+',\''+tester.rid+'\')" class="btn-line-s btn_gray" data-layer="return">RFID 반납(교체)</button></td>';
        } else { // 반납시 날짜 보여주기
          testerHtml += '<td>';
          testerHtml += ''+moment(tester.rreturn).format("YYYY.MM.DD")+'</br>   ';
          testerHtml += '<button type="button" onclick="reRfid('+tester.hrSeq+',\''+tester.name+'('+tester.employeeNo+')\')" class="btn-line-s btn_default" data-layer="reissuance">RFID 재발급</button>';
          testerHtml += '</td>';
        }
        if (tester.wreturn == null || tester.wreturn == "") {
          testerHtml += '<td><button type="button" onclick="wReturn('+tester.hrSeq+',\''+tester.wid+'\')" class="btn-line-s btn_gray" data-layer="return2">무전기 반납(교체)</button></td>';
        } else { // 반납시 날짜 보여주기
          testerHtml += '<td>';
          testerHtml += ''+moment(tester.wreturn).format("YYYY.MM.DD")+'</br>   ';
          testerHtml += '<button type="button" onclick="reWiress('+tester.hrSeq+',\''+tester.name+'('+tester.employeeNo+')\')" class="btn-line-s btn_default" data-layer="reissuance2">무전기 재발급</button>';
          testerHtml += '</td>';
        }
        testerHtml += '</tr>';
      }
    } else {
      testerHtml += '<tr class="tr_nodata">';
      testerHtml += '<td colspan="6">등록된 정보가 없습니다.</td>';
      testerHtml += '</tr>';
    }

    $("#tester").html(testerHtml);
    drawingPage(list.paging);
  }

  function rReturn(hrSeq,rId) {
    $("#rChange").html("");
    var rfidHtml = "";
    rfidHtml += '<tr>';
    rfidHtml += '<td id="changeR">'+rId+'</td>';
    rfidHtml += '<td><input type="hidden" id="hrSeqR" value="'+hrSeq+'">';
    rfidHtml += '<div class="form_group w200">';
    rfidHtml += '<input type="text" id="changeRfid" class="form_control" placeholder="RFID QR 입력" value="">';
    rfidHtml += '</div>';
    rfidHtml += '<button type="button" class="btn-line-s btn_gray" onclick="putFocus(\'cR\')">발급</button>';
    rfidHtml += '</td>';
    rfidHtml += '<td><button type="button" onclick="saveRW('+hrSeq+',\'R\')" class="btn-line-s btn_default">등록</button></td>';
    rfidHtml += '</tr>';

    $("#rChange").html(rfidHtml);
  }

  function wReturn(hrSeq,wId) {
    $("#wChange").html("");
    var wiressHtml = "";
    wiressHtml += '<tr>';
    wiressHtml += '<td id="changeW">'+wId+'</td>';
    wiressHtml += '<td>';
    wiressHtml += '<div class="form_group w100">';
    wiressHtml += '<input type="text" id="changeWiressCh" class="form_control" placeholder="무전기CH입력" value="">';
    wiressHtml += '</div>';
    wiressHtml += '</td>';
    wiressHtml += '<td><input type="hidden" id="hrSeqW" value="'+hrSeq+'">';
    wiressHtml += '<div class="form_group w200">';
    wiressHtml += '<input type="text" id="changeWiress" class="form_control" placeholder="무전기 QR 입력" value="">';
    wiressHtml += '</div>';
    wiressHtml += '<button type="button" class="btn-line-s btn_gray" onclick="putFocus(\'cW\')">발급</button>';
    wiressHtml += '</td>';
    wiressHtml += '<td><button type="button" onclick="saveRW('+hrSeq+',\'W\')" class="btn-line-s btn_default">등록</button></td>';
    wiressHtml += '</tr>';

    $("#wChange").html(wiressHtml);
  }

  function reRfid(hrSeq, name) {
    $("#reRfid").html("");
    var rfidHtml = "";
    rfidHtml += '<tr>';
    rfidHtml += '<td id="reIdR"><input type="hidden" id="reHrSeqR" value="'+hrSeq+'">'+name+'</td>';
    rfidHtml += '<td>';
    rfidHtml += '<div class="form_group w200">';
    rfidHtml += '<input type="text" id="reRfidId" class="form_control" placeholder="RFID QR 입력" value="">';
    rfidHtml += '</div>';
    rfidHtml += '<button type="button" class="btn-line-s btn_gray" onclick="putFocus(\'rR\')">발급</button>';
    rfidHtml += '</td>';
    rfidHtml += '</tr>';

    $("#reRfid").html(rfidHtml);

  }
  function reWiress(hrSeq, name) {
    $("#reWiress").html("");
    var wiressHtml = "";
    wiressHtml += '<tr>';
    wiressHtml += '<td id="reIdW"><input type="hidden" id="reHrSeqW" value="'+hrSeq+'">'+name+'</td>';
    wiressHtml += '<td><div class="form_group w100"><input type="text" id="reWiressCh" class="form_control" placeholder="무전기CH입력" value=""></div></td>';
    wiressHtml += '<td>';
    wiressHtml += '<div class="form_group w200">';
    wiressHtml += '<input type="text" id="reWiressId" class="form_control" placeholder="무전기 QR 입력" value="">';
    wiressHtml += '</div>';
    wiressHtml += '<button type="button" class="btn-line-s btn_gray" onclick="putFocus(\'rW\')">발급</button>';
    wiressHtml += '</td>';
    wiressHtml += '</tr>';

    $("#reWiress").html(wiressHtml);
  }

  // RFID/무전기 교체시
  function saveRW(hrSeq, type) {
    var param;
    if (hrSeq == "reR" && type == 'R') {
      if ($("#reRfidId").val() == '') {
        alert3("재발급 RFID를 스캔해주세요.");
        return;
      }
      param = {
        hrSeq: $("#reHrSeqR").val(),
        rqrId: $("#reRfidId").val(),
        rReturn: null
      }
    } else if (hrSeq == "reW" && type == 'W') {
      if ($("#reWiressCh").val() == '') {
        alert3("재발급 무전기 채널을 입력해주세요.");
        return;
      }
      if ($("#reWiressId").val() == '') {
        alert3("재발급 무전기를 스캔해주세요.");
        return;
      }
      param = {
        hrSeq: $("#reHrSeqW").val(),
        wqrId:$("#reWiressId").val(),
        wch:$("#reWiressCh").val(),
        wReturn: null
      }
    } else if (type == 'R') { // RFID
      if ($("#changeRfid").val() == '') {
        alert3("교체할 RFID를 스캔해주세요.");
        return;
      }
      param = {
        hrSeq: hrSeq,
        brid: $("#changeR").html(),
        rqrId: $("#changeRfid").val()
      }
    } else if (type == 'W') { // 무전기
      if ($("#changeWiressCh").val() == '') {
        alert3("교체할 무전기를 스캔해주세요.");
        return;
      }
      if ($("#changeWiress").val() == '') {
        alert3("교체할 무전기를 스캔해주세요.");
        return;
      }
      param = {
        hrSeq: hrSeq,
        bwid: $("#changeW").html(),
        wqrId:$("#changeWiress").val(),
        wch:$("#changeWiressCh").val(),
      }
    }
    postAjax("/admin/testerManage/hintUpdate", param, "resultAlert", null, null, null)
  }

  // RFID/무전기 반납시
  function returnRW(type) {
    var param;
    if (type == 'R') {
      param = {
        hrSeq: $("#hrSeq"+type).val(),
        hrType: type,
        rid: $("#change"+type).html()
      };
    } else {
      param = {
        hrSeq: $("#hrSeq"+type).val(),
        hrType: type,
        wid: $("#change"+type).html()
      };
    }
    postAjax("/admin/testerManage/hintReturn", param, "resultAlert", null, null, null)
  }

  function resultAlert(result) {
    console.log(result);
    alert3(result.update);
    if (result.update == "발급에 성공했습니다." || result.update == "반납에 성공했습니다.") {
      $(".lyClose2").click(function () {
        location.reload();
      })
    }
  }

  // 평가자 검색시 테이블
  function testerSearch(page, type) {
    var text = '';
    if (type == 'S') {
      text = $("#testerName").val()
    } else {
      text = $("#testerNameP").val()
    }
    var param = {
      pageNo: page,
      text: text,
      type: 'new'
    }
    postAjax("/admin/testerManage/testerList", param, "showTester", null, null, null)
  }
  function showTester(list) {
    $("#testerP").html("");
    var testerHtml = "";
    if (list.tester.length > 0) {
      for (var i in list.tester) {
        var tester = list.tester[i];
        testerHtml += '<tr>';
        testerHtml += '<td>';
        testerHtml += '<div class="form_group single">';
        testerHtml += '<div class="check_inline">';
        testerHtml += '<label class="check_default single">';
        testerHtml += '<input type="checkbox" name="testerChk" value="'+tester.name+'('+tester.employeeNo+')">';
        testerHtml += '<span class="check_icon"></span></label>';
        testerHtml += '</div>';
        testerHtml += '</div>';
        testerHtml += '</td>';
        testerHtml += '<td>'+tester.name+' ('+tester.employeeNo+')</td>';
        testerHtml += '<td>'+tester.deptName+'</td>';
        testerHtml += '</tr>';
      }
    } else {
      testerHtml += '<tr class="tr_nodata">';
      testerHtml += '<td colspan="3">등록된 정보가 없습니다.</td>';
      testerHtml += '</tr>';
    }

    $("#testerP").html(testerHtml);
    drawingPage2(list.paging);

    $("input:checkbox[name='testerChk']").click(function(){
      if($(this).prop("checked")){
        $("input:checkbox[name='testerChk']").prop("checked",false);
        $(this).prop("checked",true);
      }
    });
  }

  function putChk() {
    if ($("input:checkbox[name='testerChk']:checked").val() == null) {
      alert3("선택된 평가자가 없습니다.");
      return;
    }
    $("#testerName").val($("input:checkbox[name='testerChk']:checked").val());
    $(".lyClose").click();
  }

  function putFocus(type) {
    if (type == 'R') {
      $("#newRfid").val('');
      if ($("#newRfid").val() == ''){
        $("#newRfid").focus();
      }
    } else if (type == 'W') {
      $("#newWiress").val('');
      if ($("#newWiress").val() == ''){
        $("#newWiress").focus();
      }
    } else if (type == 'cR') {
      $("#changeRfid").val('');
      if ($("#changeRfid").val() == ''){
        $("#changeRfid").focus();
      }
    } else if (type == 'cW') {
      $("#changeWiress").val('');
      if ($("#changeWiress").val() == ''){
        $("#changeWiress").focus();
      }
    } else if (type == 'rR') {
      $("#reRfidId").val('');
      if ($("#reRfidId").val() == ''){
        $("#reRfidId").focus();
      }
    } else if (type == 'rW') {
      $("#reWiressId").val('');
      if ($("#reWiressId").val() == ''){
        $("#reWiressId").focus();
      }
    }
  }

  function newRW() {
    var employeeNo;
    var name;

    if ($("#testerName").val() == '') {
      alert("선택된 평가자가 없습니다.");
      return;
    }
    if ($("#newRfid").val() == '') {
      alert("입력된 RFID가 없습니다.");
      return;
    }
    if ($("#newWiressCh").val() == '') {
      alert("무전기 채널을 입력해주세요.");
      return;
    }
    if ($("#newWiress").val() == '') {
      alert("입력된 무전기가 없습니다.");
      return;
    }

    if ($("#testerName").val() != '') {
      var test1 = $("#testerName").val().indexOf('(',0);
      var test2 = $("#testerName").val().indexOf(')',0);
      employeeNo = $("#testerName").val().substring(test1+1, test2);
      name = $("#testerName").val().split('(')[0];
    }

    var param = {
      employeeNo: employeeNo,
      hrType: 'D',
      rqrId: $("#newRfid").val(),
      wch: $("#newWiressCh").val(),
      wqrId: $("#newWiress").val(),
      dname: name
    }
    postAjax("/admin/testerManage/hintRW", param, "resultAlert", null, null, null)
  }
</script>

<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시험자원관리</span><span>평가자 및 평가차량 관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">평가자 및 평가차량 관리</h2>
        <!-- //title -->
        <!-- tab -->
        <div class="wrap_tab m-t-30">
            <div class="tab">
                <button class="tablinks active" onclick="pageMove('tab1')" id="defaultOpen">평가자</button>
                <button class="tablinks" onclick="pageMove('tab2')">평가차량</button>
                <button class="tablinks" onclick="pageMove('tab3')">평가자 일시정지 조회</button>
            </div>
            <div class="qrinfo">
                <span class="info_ment redfont">발급버튼을 클릭하면 현재 입력된 QR Code가 삭제됩니다. 발급버튼을 누르고 QR을 인식해주세요.</span>
            </div>
            <div class="wrap_tabcontent">
                <!-- tab1-평가자 -->
                <div id="tab1" class="tabcontent">
                    <!-- table list -->
                    <section class="tbl_wrap_list">
                        <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="20%" />
                                <col width="20%" />
                                <col width="20%" />
                                <col width="20%" />
                                <col width="20%" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th scope="col">평가자명(사번)</th>
                                <th scope="col">RFID QRcode</th>
                                <th scope="col">무전기 CH</th>
                                <th scope="col">무전기 QRcode</th>
                                <th scope="col">비고</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>
                                    <div class="form_group w200">
                                        <input type="text" id="testerName" class="form_control" placeholder="평가자명 입력" name="testerName" />
                                    </div>
                                    <button type="button" class="btn-line-s btn_gray" data-layer="tp_search" onclick="testerSearch(1,'S')">검색</button>
                                </td>
                                <td>
                                    <div class="form_group w200">
                                        <input type="text" id="newRfid" class="form_control" placeholder="RFID QR 입력" value="">
                                    </div>
                                    <button type="button" class="btn-line-s btn_gray" onclick="putFocus('R')">발급</button>
                                </td>
                                <td>
                                    <div class="form_group w200">
                                        <input type="text" id="newWiressCh" class="form_control" placeholder="무전기 CH 입력" value="">
                                    </div>
                                </td>
                                <td>
                                    <div class="form_group w200">
                                        <input type="text" id="newWiress" class="form_control" placeholder="무전기 QR 입력" value="">
                                    </div>
                                    <button type="button" class="btn-line-s btn_gray" onclick="putFocus('W')">발급</button>
                                </td>
                                <td><button type="button" class="btn-line-s btn_default" onclick="newRW()">등록</button></td>
                            </tr>
                            <!-- <tr class="tr_nodata">
                <td colspan="4">등록된 정보가 없습니다.</td>
            </tr> -->
                            </tbody>
                        </table>
                    </section>
                    <!-- //table list -->
                    <!-- search_wrap -->
                    <section class="search_wrap m-t-50 tar">
                        <div class="form_group w300">
                            <input type="text" id="testerSearch" class="form_control" placeholder="운전자명/사번/RFID No/ 무전기 No 입력" name="" />
                        </div>
                        <button type="button" class="btn-s btn_default" onclick="rwTesterSearch(1)">조회</button>
                    </section>
                    <!-- //search_wrap -->
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
                                <th scope="col">운전자명(사번)</th>
                                <th scope="col">RFID ID</th>
                                <th scope="col">무전기 CH</th>
                                <th scope="col">무전기 ID</th>
                                <th scope="col">RFID 반납</th>
                                <th scope="col">무전기 반납</th>
                            </tr>
                            </thead>
                            <tbody id="tester"></tbody> <%--평가자 RW 리스트--%>
                        </table>
                    </section>
                    <!-- //table list -->
                    <!-- Pagination -->
                    <section id="pagingc" class="pagination m-t-30">
                        <jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
                    </section>
                    <!-- //Pagination -->
                </div>
                <!-- //tab1-평가자 -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

<!-- popup_l -->
<div class="ly_group">
    <article class="layer_l return">
        <!-- # 타이틀 # -->
        <h1>반납/교체</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            해당 운전자 RFID에 대해 반납 하시겠습니까?
            <span class="info_ment_orange m-l-0 m-t-10">교체 시에만 아래 “등록”을 통해 신규장비를 등록해주시기 바랍니다.</span>
            <!-- table list -->
            <section class="tbl_wrap_list m-t-30">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="" />
                        <col width="" />
                        <col width="" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">기존 RFID ID</th>
                        <th scope="col">교체 RFID QRcode</th>
                        <th scope="col">비고</th>
                    </tr>
                    </thead>
                    <tbody id="rChange">
                    <%--<tr>
                        <td>DE00001</td>
                        <td><button type="button" class="btn-line-s btn_gray" onclick="scanner('changeR')">발급</button></td>
                        <td><button type="button" class="btn-line-s btn_default" onclick="saveRfid()">등록</button></td>
                    </tr>--%>
                    </tbody>
                </table>
            </section>
            <!-- //table list -->
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-6">취소</button>
            <button type="button" class="btn-pop btn_default" onclick="returnRW('R')">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_l -->

<!-- popup_l -->
<div class="ly_group">
    <article class="layer_l return2">
        <!-- # 타이틀 # -->
        <h1>반납/교체</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            해당 운전자 무전기에 대해 반납 하시겠습니까?
            <span class="info_ment_orange m-l-0 m-t-10">교체 시에만 아래 “발급”을 통해 신규장비를 등록해주시기 바랍니다.</span>
            <!-- table list -->
            <section class="tbl_wrap_list m-t-30">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="" />
                        <col width="" />
                        <col width="" />
                        <col width="" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">기존 무전기 ID</th>
                        <th scope="col">교체 무전기 CH</th>
                        <th scope="col">교체 무전기 QRcode</th>
                        <th scope="col">비고</th>
                    </tr>
                    </thead>
                    <tbody id="wChange">
                    </tbody>
                </table>
            </section>
            <!-- //table list -->
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-6">취소</button>
            <button type="button" class="btn-pop btn_default" onclick="returnRW('W')">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_l -->

<!-- popup_l -->
<div class="ly_group">
    <article class="layer_l tp_search">
        <!-- # 타이틀 # -->
        <h1>평가자 선택</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <div class="form_group w200">
                <input type="text" id="testerNameP" class="form_control" placeholder="평가자명 입력" name="testerName" />
            </div>
            <button type="button" class="btn-s btn_default" onclick="testerSearch(1,'R')">조회</button>
            <!-- table list -->
            <section class="tbl_wrap_list m-t-15">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="80px" />
                        <col width="" />
                        <col width="" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">선택</th>
                        <th scope="col">운전자명</th>
                        <th scope="col">부서정보</th>
                    </tr>
                    </thead>
                    <tbody id="testerP"></tbody> <%--평가자 검색시 팝업--%>
                </table>
            </section>
            <!-- //table list -->
            <!-- Pagination -->
            <section id="pagingl" class="pagination m-t-30">
                <jsp:include page="/WEB-INF/views/jsp/common/paging2.jsp" />
            </section>
            <!-- //Pagination -->
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-6">취소</button>
            <button type="button" class="btn-pop btn_default" onclick="putChk()">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_l -->

<!-- popup_l -->
<div class="ly_group">
    <article class="layer_l reissuance">
        <!-- # 타이틀 # -->
        <h1>재발급</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            해당 운전자 RFID에 대해 재발급 하시겠습니까?
<%--            <span class="info_ment_orange m-l-0 m-t-10">교체 시에만 아래 “발급”을 통해 신규장비를 등록해주시기 바랍니다.</span>--%>
            <!-- table list -->
            <section class="tbl_wrap_list m-t-30">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="" />
                        <col width="" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">운전자명(사번)</th>
                        <th scope="col">재발급 RFID QRcode</th>
                    </tr>
                    </thead>
                    <tbody id="reRfid">
                    </tbody>
                </table>
            </section>
            <!-- //table list -->
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-6">취소</button>
            <button type="button" class="btn-pop btn_default" onclick="saveRW('reR','R')">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_l -->
<!-- popup_l -->
<div class="ly_group">
    <article class="layer_l reissuance2">
        <!-- # 타이틀 # -->
        <h1>재발급</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            해당 운전자 무전기에 대해 재발급 하시겠습니까?
<%--            <span class="info_ment_orange m-l-0 m-t-10">교체 시에만 아래 “발급”을 통해 신규장비를 등록해주시기 바랍니다.</span>--%>
            <!-- table list -->
            <section class="tbl_wrap_list m-t-30">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="" />
                        <col width="" />
                        <col width="" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">운전자명(사번)</th>
                        <th scope="col">재발급 무전기 CH</th>
                        <th scope="col">재발급 무전기 QRcode</th>
                    </tr>
                    </thead>
                    <tbody id="reWiress">
                    </tbody>
                </table>
            </section>
            <!-- //table list -->
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-6">취소</button>
            <button type="button" class="btn-pop btn_default" onclick="saveRW('reW','W')">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_l -->

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>