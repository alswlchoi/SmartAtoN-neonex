<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
  $(document).ready(function () {
    // var test = document.querySelector('input');
    // test.addEventListener('input', evt => evt.target);

    rWCarSearch(1);
    carSearch(1, 'S');
    //페이징 조회 버튼
    $(document).on("click","#pagingc>span>.pageNo",function(){
      rWCarSearch($(this).attr("data-page"));
    });
    $(document).on("click","#pagingl>span>.pageNo",function(){
      carSearch($(this).attr("data-page"), 'S');
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

  // 차량 조회 테이블(R/W)
  function rWCarSearch(page) {
    var param = {
      pageNo: page,
      text: $("#carSearch").val(),
      type: 'rw'
    }
    postAjax("/admin/testerManage/testCarList", param, "showCarRWList", null, null, null)
  }
  function showCarRWList(list) {
    console.log(list);
    $("#carTable").html("");
    var carHtml = "";
    if (list.car.length > 0) {
      for (var i in list.car) {
        var car = list.car[i];
        carHtml += '<tr>';
        carHtml += '<td>'+car.vhclRgsno+'</td>';
        carHtml += '<td id="rId'+i+'">';
        carHtml += ''+car.rid+'';
        carHtml += '</td>';
        // carHtml += '<td>'+moment(car.crnDtm).format("YYYY.MM.DD")+'</td>';
        if (car.rreturn == null || car.rreturn == '') {
          carHtml += '<td>';
          carHtml += '<input type="hidden" id="hrSeq'+i+'" value="'+car.hrSeq+'">';
          carHtml += '<button type="button" class="btn-line-s btn_gray" data-layer="complete2" onclick="inputCCode('+i+')">반납</button>';
          carHtml += '</td>';
          carHtml += '<td></td>';
        } else {
          carHtml += '<td><button type="button" class="btn-line-s btn_default" data-layer="reissuance" onclick="reRfid('+car.hrSeq+', \''+car.vhclRgsno+'\')">재발급</button>';
          carHtml += '<td>'+moment(car.rreturn).format("YYYY.MM.DD")+'</td>';
        }
        carHtml += '</tr>';
      }
    } else {
      carHtml += '<tr class="tr_nodata">';
      carHtml += '<td colspan="4">등록된 정보가 없습니다.</td>';
      carHtml += '</tr>';
    }

    $("#carTable").html(carHtml);
    drawingPage(list.paging);
  }

  // 차량 검색시 테이블
  function carSearch(page, type) {
    var text = '';
    if (type == 'S') {
      text = $("#carName").val()
    } else {
      text = $("#carNameP").val()
    }
    var param = {
      pageNo: page,
      text: text,
      type: 'new'
    }
    postAjax("/admin/testerManage/testCarList", param, "showCar", null, null, null)
  }
  function showCar(list) {
    $("#carTableP").html("");
    var carHtml = "";
    if (list.car.length > 0) {
      for (var i in list.car) {
        var car = list.car[i];
        carHtml += '<tr>';
        carHtml += '<td>';
        carHtml += '<div class="form_group single">';
        carHtml += '<div class="check_inline">';
        carHtml += '<label class="check_default single">';
        carHtml += '<input type="checkbox" name="carChk" value="'+car.vhclCode+'/'+car.vhclRgsno+'">';
        carHtml += '<span class="check_icon"></span></label>';
        carHtml += '</div>';
        carHtml += '</div>';
        carHtml += '</td>';
        carHtml += '<td>'+car.vhclRgsno+'</td>';
        carHtml += '<td>'+car.vhclMaker+'</td>';
        carHtml += '</tr>';
      }
    } else {
      carHtml += '<tr class="tr_nodata">';
      carHtml += '<td colspan="3">등록된 정보가 없습니다.</td>';
      carHtml += '</tr>';
    }

    $("#carTableP").html(carHtml);
    drawingPage2(list.paging);

    $("input:checkbox[name='carChk']").click(function(){
      if($(this).prop("checked")){
        $("input:checkbox[name='carChk']").prop("checked",false);
        $(this).prop("checked",true);
      }
    });
  }

  function reRfid(hrSeq, name) {
    $("#reRfid").html("");
    var rfidHtml = "";

    rfidHtml += '<tr>';
    rfidHtml += '<td><input type="hidden" id="reHrSeqR" value="'+hrSeq+'">'+name+'</td>';
    rfidHtml += '<td>';
    rfidHtml += '<div class="form_group w200">';
    rfidHtml += '<input type="text" id="reRfidId" class="form_control" placeholder="RFID QR 입력" value="">';
    rfidHtml += '</div>';
    rfidHtml += '<button type="button" class="btn-line-s btn_gray" onclick="putFocus(\'rR\')">발급</button>';
    rfidHtml += '</td>';
    rfidHtml += '</tr>';

    $("#reRfid").html(rfidHtml);

  }

  function newR() {
    if ($("#carName").val() == '') {
      alert3("선택된 평가차량이 없습니다.");
      return;
    }
    if ($("#newRfid").val() == '') {
      alert3("선택된 RFID가 없습니다.");
      return;
    }
    var param = {
      vhclCode: $("#carCode").val(),
      hrType: 'C',
      rqrId: $("#newRfid").val()
    }
    console.log(param);
    postAjax("/admin/testerManage/hintRW", param, "resultAlert", null, null, null)
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

  function putChk() {
    if ($("input:checkbox[name='carChk']:checked").val() == null) {
      alert3("선택된 평가차량이 없습니다.");
      return;
    }
    var checked = $("input:checkbox[name='carChk']:checked").val().split('/');
    $("#carCode").val(checked[0]);
    $("#carName").val(checked[1]);
  }

  function putFocus(type) {
    if (type == 'R') {
      $("#newRfid").val('');
      if ($("#newRfid").val() == ''){
        $("#newRfid").focus();
      }
    } else if (type == 'rR') {
      $("#reRfidId").val('');
      if ($("#reRfidId").val() == ''){
        $("#reRfidId").focus();
      }
    }
  }

  function inputCCode(i) {
    var hrSeq = $("#hrSeq"+i).val();
    var rId = $("#rId"+i).html();
    $("#reHrSeq").val(hrSeq);
    $("#returnRfid").val(rId);
  }

  function returnRC() {
    var param = {
      hrType: 'R',
      hrSeq: $("#reHrSeq").val(),
      rid: $("#returnRfid").val()
    }
    console.log(param);
    postAjax("/admin/testerManage/hintReturn", param, "resultAlert", null, null, null)
  }

  // RFID/무전기 교체시
  function saveRW(hrSeq, type) {
    var param;
    if (hrSeq == "reR" && type == 'R') {
      if ($("#reRfidId").val() == '') {
        alert3("교체할 RFID를 스캔해주세요.");
        return;
      }
      param = {
        hrSeq: $("#reHrSeqR").val(),
        brQrId: $("#changeR").val(),
        rqrId: $("#reRfidId").val(),
        rReturn: null
      }
    } else if (type == 'R') { // RFID
      if ($("#changeRfid").val() == '') {
        alert3("교체할 RFID를 스캔해주세요.");
        return;
      }
      param = {
        hrSeq: hrSeq,
        rqrId: $("#changeRfid").val()
      }
    }

    postAjax("/admin/testerManage/hintUpdate", param, "resultAlert", null, null, null)
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
                <button class="tablinks" onclick="pageMove('tab1')" id="defaultOpen">평가자</button>
                <button class="tablinks active" onclick="pageMove('tab2')">평가차량</button>
                <button class="tablinks" onclick="pageMove('tab3')">평가자 일시정지 조회</button>
            </div>
            <div class="qrinfo">
                <span class="info_ment redfont">발급버튼을 클릭하면 현재 입력된 QR Code가 삭제됩니다. 발급버튼을 누르고 QR을 인식해주세요.</span>
            </div>
            <div class="wrap_tabcontent">
                <!-- tab2-평가차량 -->
                <div id="tab2" class="tabcontent">
                    <!-- table list -->
                    <section class="tbl_wrap_list">
                        <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="33%" />
                                <col width="33%" />
                                <col width="33%" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th scope="col">평가차량번호</th>
                                <th scope="col">RFID QRcode</th>
                                <th scope="col">비고</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>
                                    <div class="form_group">
                                        <div class="form_group w200">
                                            <input type="hidden" id="carCode"/>
                                            <input type="text" id="carName" class="form_control" placeholder="평가차량번호 입력" name="" />
                                        </div>
                                        <button type="button" class="btn-line-s btn_gray" data-layer="tc_search" onclick="carSearch(1,'S')">검색</button>
                                    </div>
                                </td>
                                <td>
                                    <div class="form_group w200">
                                        <input type="text" id="newRfid" class="form_control" placeholder="RFID QR 입력" name="" />
                                    </div>
                                    <button type="button" class="btn-line-s btn_gray" onclick="putFocus('R')">발급</button>
                                </td>
                                <td><button type="button" class="btn-line-s btn_default" onclick="newR()">등록</button></td>
                            </tr>
                            <!-- <tr class="tr_nodata">
                <td colspan="3">등록된 정보가 없습니다.</td>
            </tr> -->
                            </tbody>
                        </table>
                    </section>
                    <!-- //table list -->
                    <!-- search_wrap -->
                    <section class="search_wrap m-t-50 tar">
                        <div class="form_group w300">
                            <input type="text" id="carSearch" class="form_control" placeholder="평가차량번호 입력"
                                   name="" />
                        </div>
                        <button type="button" class="btn-s btn_default" onclick="rWCarSearch(1)">조회</button>
                    </section>
                    <!-- //search_wrap -->
                    <!-- table list -->
                    <section class="tbl_wrap_list m-t-10">
                        <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="" />
                                <col width="" />
<%--                                <col width="" />--%>
                                <col width="" />
                                <col width="" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th scope="col">평가차량번호</th>
                                <th scope="col">RFID ID</th>
<%--                                <th scope="col">등록일</th>--%>
                                <th scope="col">반납</th>
                                <th scope="col">반납일</th>
                            </tr>
                            </thead>
                            <tbody id="carTable"></tbody> <%--평가차량 조회--%>
                        </table>
                    </section>
                    <!-- //table list -->
                    <!-- Pagination -->
                    <section id="pagingc" class="pagination m-t-30">
                        <jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
                    </section>
                    <!-- //Pagination -->
                </div>
                <!-- //tab2-평가차량 -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

<!-- popup_Alert -->
<div class="ly_group">
    <article class="layer_Alert complete2">
        <!-- # 타이틀 # -->
        <!-- <h1></h1> -->
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <input type="hidden" id="reHrSeq">
            <input type="hidden" id="returnRfid">
            해당 챠랑의 RFID<br />반납 처리하시겠습니까?
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button>
            <button type="button" class="btn-pop btn_default lyClose2" onclick="returnRC()">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose2">레이어닫기</button>
    </article>
</div>
<!-- //popup_Alert -->

<!-- popup_l -->
<div class="ly_group">
    <article class="layer_l tc_search">
        <!-- # 타이틀 # -->
        <h1>평가차량 선택</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <div class="form_group w200">
                <input type="text" id="carNameP" class="form_control" placeholder="평가차량번호 입력" name="" />
            </div>
            <button type="button" class="btn-s btn_default" onclick="carSearch(1,'R')">조회</button>
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
                        <th scope="col">평가챠량</th>
                        <th scope="col">MAKER</th>
                    </tr>
                    </thead>
                    <tbody id="carTableP"></tbody> <%--평가차량 검색시 팝업--%>
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
            <button type="button" class="btn-pop btn_default lyClose" onclick="putChk()">확인</button>
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
            해당 차량에 RFID를 재발급 하시겠습니까?
            <section class="tbl_wrap_list m-t-30">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="" />
                        <col width="" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">평가차량번호</th>
                        <th scope="col">재발급 RFID NO.</th>
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

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>