<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
  $(document).ready(function () {
    $('#date').daterangepicker({
      startDate: moment(),
      autoApply: true,
      singleDatePicker: true,
      cancelLabel: '취소',
      applyLabel: "확인",
      locale: {
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
        yearSuffix: '년',
        separator: " ~ ",
        format: 'YYYY-MM-DD'
      }
    });

    search(1);
    //페이징 조회 버튼
    $(document).on("click", ".pageNo", function () {
      search($(this).attr("data-page"));
    });
    //조회버튼
    $("#searchBtn").on("click", function () {
      search(1);
    });
    //조회 엔터키 처리
    $("#searchInput").focus(function () {
      $(this).keydown(function (k) {
        if (k.keyCode == 13) {
          search(1);
        }
      });
    });
  });

  function search(page) {
    var param = {
      pageNo: page,
      text: $("#searchInput").val(),
      testDate: moment($("#date").val()).format('YYYYMMDD')
    };
    postAjax("/admin/testerManage/list", param, "showList", null, null, null);
  }

  var getCar = null;

  function showList(list) {
    var index = 1;
    getCar = list.car;
    var testerHtml = "";
    if (list.list.length > 0) {
      for (var i in list.list) {
        var tester = list.list[i];
        if (tester.rmType == 'D') {
          var rmWCh;
          if (tester.rmWCh == null) { rmWCh = ""; } else { rmWCh = tester.rmWCh; }
          // 배분된 차량 중 rfid 발급된 차량이 한대라도 있는지 확인 (있으면 Y 없으면 null 반납 완료면 R)
          var chk = null;
          for (var j in list.car) {
            var car = list.car[j];
            if (car.tcReservCode == tester.tcReservCode) {
              if (car.rid != null) {
                chk = 'Y';
              }
            }
          }
          testerHtml += '<tr>';
          testerHtml += '<td class="index">'+index+'</td>';
          testerHtml += '<td class="testDate '+tester.dseq+'2">'+moment($("#date").val()).format('YYYY.MM.DD')+'</td>';
          testerHtml += '<td>'+tester.tcReservCode+'('+tester.trTrackType+')</td>';
          if (tester.tcDay == tester.tcDay2) {
            testerHtml += '<td>'+moment(tester.tcDay).format("YYYY.MM.DD")+'</td>';
          } else {
            testerHtml += '<td>'+moment(tester.tcDay).format("YYYY.MM.DD")+' ~ '+moment(tester.tcDay2).format("YYYY.MM.DD")+'</td>';
          }
          /*if (tester.compName == null) {
            testerHtml += '<td class="compName">한국타이어</td>';
          } else {
            testerHtml += '<td class="compName">'+tester.compName+'</td>';
          }*/
          testerHtml += '<td class="compName '+tester.dseq+'3">'+tester.compName+'</td>';
          testerHtml += '<td class="name '+tester.dseq+'"><input type="hidden" class="dSeq" id="dSeq" value="'+tester.dseq+'">'+tester.dname+'</td>';
          if (tester.ndccpYN == 'Y') {
            testerHtml += '<td  id="dccpYn'+i+'" class="dccp '+tester.dseq+'4 d'+tester.dseq+'">Pass</td>';
          } else if (tester.ndccpYN == 'N') {
            testerHtml += '<td id="dccpYn'+i+'" class="dccp redfont '+tester.dseq+'4 d'+tester.dseq+'">Fail</td>';
          } else {
            testerHtml += '<td class="dccp '+tester.dseq+'4"></td>';
          }
          testerHtml += '<td class="edu '+tester.dseq+'5">';
          testerHtml += '<div class="form_group">';
          testerHtml += '<label class="check_default">';
          if (tester.dedu == 'Y') {
            testerHtml += '<input type="checkbox" checked disabled>';
            testerHtml += '<span class="check_icon"></span>이수</label>';
            testerHtml += '</div>';
            testerHtml += '<span class="m-t-5 disb">('+moment(tester.deduEndDt, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+')</span>';
          } else {
            testerHtml += '<input type="checkbox" disabled>';
            testerHtml += '<span class="check_icon"></span>이수</label>';
            testerHtml += '</div>';
          }
          testerHtml += '</td>';
          var rId = tester.rid;
          var wId = tester.wid;
          testerHtml += '<td class="rfid '+tester.dseq+'6">';
          testerHtml += '<div class="form_group w150">';
          if (rId == null || rId == '' || wId == null || wId == '') { // 사용자 발급 전
            testerHtml += '<input type="text" id="rfid'+i+'" class="form_control r'+tester.dseq+'">';
            testerHtml += '</div>';
            testerHtml += '<button type="button" id="rIssue" class="btn-line-s btn_gray" onclick="putFocus('+i+',\'R\')">발급</button>';
            testerHtml += '</td>';
            testerHtml += '<td class="wCh '+tester.dseq+'7">';
            testerHtml += '<div class="form_group w100">';
            testerHtml += '<input type="text" id="wiressCh'+i+'" maxlength="5" onkeypress="numberonly();" class="form_control wc'+tester.dseq+'" value="'+rmWCh+'">';
            testerHtml += '</div>';
            testerHtml += '</td>';
            testerHtml += '<td class="wiress '+tester.dseq+'8">';
            testerHtml += '<div class="form_group w150">';
            testerHtml += '<input type="text" id="wiress'+i+'" class="form_control w'+tester.dseq+'">';
            testerHtml += '</div>';
            testerHtml += '<button type="button" id="wIssue" class="btn-line-s btn_gray" onclick="putFocus('+i+',\'W\')">발급</button>';
            testerHtml += '</td>';
          } else if (tester.rmRYn == null || tester.rmRYn == '' || tester.rmWYn == null || tester.rmWYn == '' || tester.rmRYn == 'Y' || tester.rmWYn == 'Y') { // 사용자 발급 완료
            testerHtml += '<input type="text" id="rfid'+i+'" class="form_control r'+tester.dseq+'" value="'+tester.rid+'" readonly>';
            testerHtml += '</div>';
            testerHtml += '<button type="button" id="rReturn'+i+'" class="btn-line-s btn_default m-r-6 rb'+tester.dseq+'" onclick="returnBtn('+i+',\'R\', '+tester.dseq+')">반납</button>';
            testerHtml += '<button type="button" onclick="rChange('+tester.dseq+',\''+tester.rid+'\')" class="btn-line-s btn_gray" data-layer="return">교체</button>';
            testerHtml += '</td>';
            testerHtml += '<td class="wCh '+tester.dseq+'7">';
            testerHtml += '<div class="form_group w100">';
            testerHtml += '<input type="text" id="wiressCh'+i+'" maxlength="5" onkeypress="numberonly();" class="form_control wc'+tester.dseq+'" value="'+rmWCh+'" readonly>';
            testerHtml += '</div>';
            testerHtml += '</td>';
            testerHtml += '<td class="wiress '+tester.dseq+'8">';
            testerHtml += '<div class="form_group w150">';
            testerHtml += '<input type="text" id="wiress'+i+'" class="form_control w'+tester.dseq+'" value="'+tester.wid+'" readonly>';
            testerHtml += '</div>';
            testerHtml += '<button type="button" id="wReturn'+tester.dseq+'" class="btn-line-s btn_default m-r-6 wb'+tester.dseq+'" onclick="returnBtn('+i+',\'W\', '+tester.dseq+')">반납</button>';
            testerHtml += '<button type="button" onclick="wChange('+tester.dseq+',\''+tester.wid+'\')" class="btn-line-s btn_gray" data-layer="return2">교체</button>';
            testerHtml += '</td>';
          } else {
            chk = 'R';
            testerHtml += '<input type="text" id="rfid'+i+'" class="form_control r'+tester.dseq+'" value="'+tester.rid+'" readonly>';
            testerHtml += '</div>';
            testerHtml += '<button type="button" id="rReturn" class="btn-line-s btn_default" disabled>반납</button>';
            testerHtml += '</td>';
            testerHtml += '<td class="wCh '+tester.dseq+'7">';
            testerHtml += '<div class="form_group w100">';
            testerHtml += '<input type="text" id="wiressCh'+i+'" maxlength="5" onkeypress="numberonly();" class="form_control wc'+tester.dseq+'" value="'+rmWCh+'" readonly>';
            testerHtml += '</div>';
            testerHtml += '</td>';
            testerHtml += '<td class="wiress '+tester.dseq+'8">';
            testerHtml += '<div class="form_group w150">';
            testerHtml += '<input type="text" id="wiress'+i+'" class="form_control w'+tester.dseq+'" value="'+tester.wid+'" readonly>';
            testerHtml += '</div>';
            testerHtml += '<button type="button" id="wReturn" class="btn-line-s btn_default" disabled>반납</button>';
            testerHtml += '</td>';
          }

          testerHtml += '<td>';
          if (chk == null) { // rfid 한개도 없을경우
            testerHtml += '<button type="button" id="showCar'+i+'" class="btn-line-s btn_gray" onclick="testCar(\''+tester.tcReservCode+'\', '+i+', \'new\')">발급</button>';
            testerHtml += '</td>';
          } else if (chk == 'Y') { // rfid 한개라도 있을 경우
            testerHtml += '<button type="button" id="showCar'+i+'" class="btn-line-s btn_default" onclick="testCar(\''+tester.tcReservCode+'\', '+i+', \'return\')">반납</button>';
            testerHtml += '</td>';
          } else { // 반납완료일경우
            testerHtml += '<button type="button" id="showCar'+i+'" class="btn-line-s btn_gray" disabled>반납</button>';
            testerHtml += '</td>';
          }

          if (tester.rid == null || tester.rid == '' || tester.wid == null || tester.wid == '') { // rfid&무전기 둘다 X
            testerHtml += '<input type="hidden" id="carDone" value="N">';
            testerHtml += '<td class="testH"><button type="button" class="btn-line-s btn_gray" data-layer="complete" onclick="delivI('+i+', \'new\', '+tester.dseq+')">발급완료</button> </td>';
          } else if (chk == 'R') { // rfid&무전기 둘다 O
            testerHtml += '<td class="testH"><button type="button" class="btn-line-s btn_gray" data-layer="complete" disabled>반납완료</button> </td>';
          } else { // rfid&무전기 둘다 O
            if (tester.rmRYn == null || tester.rmRYn == '' || tester.rmWYn == null || tester.rmWYn == '' || tester.rmRYn == 'Y' || tester.rmWYn == 'Y') { //사용중
              testerHtml += '<input type="hidden" id="carDone" value="N">';
              testerHtml += '<td class="testH"><button type="button" class="btn-line-s btn_default" data-layer="complete2" onclick="delivI('+i+', \'return\', '+tester.dseq+')">반납완료</button> </td>';
            } else { //반납
              testerHtml += '<td class="testH"><button type="button" class="btn-line-s btn_gray" data-layer="complete" disabled>반납완료</button> </td>';
            }
          }
          // testerHtml += '<td class="continue">연속여부</td>';
          testerHtml += '</tr>';
          index++;
        }
      }
    } else {
      testerHtml += '<tr class="tr_nodata">';
      testerHtml += '<td colspan="14">등록된 정보가 없습니다.</td>';
      testerHtml += '</tr>';
    }

    $("#testerTable").html(testerHtml);
    for (var i in list.list) {
      funRowspan(list.list[i].dseq);
      funRowspan(list.list[i].dseq+"2");
      funRowspan(list.list[i].dseq+"3");
      funRowspan(list.list[i].dseq+"4");
      funRowspan(list.list[i].dseq+"5");
      funRowspan(list.list[i].dseq+"6");
      funRowspan(list.list[i].dseq+"7");
      funRowspan(list.list[i].dseq+"8");
    }
    drawingPage(list.paging);
  }

  function funRowspan(className){
    $("."+className).each(function(){
      var rows = $("."+className);
      if(rows.length > 1){
        rows.eq(0).attr("rowspan", rows.length);//중복되는 첫번째 td에 rowspan값 세팅
        rows.not(":eq(0)").remove();//중복되는 td를 삭제 } }); }
      }
    });
  }

  function rowspan() {
    $(".name").each(function() {
      var name = $(".name:contains('" + $(".name > .dSeq").val() + "')");
      // var testDate = name.siblings(".testDate");
      // var compName = $(".compName:contains('" + $(".compName").html() + "')");
      // var compName = name.siblings(".compName");
      // var dccp = name.siblings(".dccp");
      // var edu = name.siblings(".edu");
      // var rfid = name.siblings(".rfid");
      // var wCh = name.siblings(".wCh");
      // var wiress = name.siblings(".wiress");

      if (name.length > 1) {
        // testDate.eq(0).attr("rowspan", name.length);
        name.eq(0).attr("rowspan", name.length);
        // compName.eq(0).attr("rowspan", name.length);
        // dccp.eq(0).attr("rowspan", name.length);
        // edu.eq(0).attr("rowspan", name.length);
        // rfid.eq(0).attr("rowspan", name.length);
        // wCh.eq(0).attr("rowspan", name.length);
        // wiress.eq(0).attr("rowspan", name.length);

        // testDate.not(":eq(0)").remove();
        name.not(":eq(0)").remove();
        // compName.not(":eq(0)").remove();
        // dccp.not(":eq(0)").remove();
        // edu.not(":eq(0)").remove();
        // rfid.not(":eq(0)").remove();
        // wCh.not(":eq(0)").remove();
        // wiress.not(":eq(0)").remove();
      }
    });
  }

  function testCar(reservedCode, i, type) {
    $("#carPopup").click();
    $("#doneCol").val(i);
    $("#doneType").val(type);

    $("#carRfid").html("");
    if (type == 'return') {
      $("#carTitle").html("RFID 반납");
      $("#changeBtn").html("반납완료");
      $("#addRfid").show();
    } else {
      $("#carTitle").html("RFID 발급");
      $("#changeBtn").html("발급완료");
      $("#addRfid").hide();
    }
    var rfidHtml = "";
    var newCar = new Array();
    if (getCar.length > 0) {
      for (var j in getCar) {
        var car = getCar[j];
        if (car.tcReservCode == reservedCode) {
          newCar.push(car);
        }
      }
      if (newCar.length > 0) {
        for (var k in newCar) {
          var car = newCar[k];
          rfidHtml += '<tr data-carSeq="' + car.ccode + '">';
          rfidHtml += '<td>' + car.cnumber + '</td>';
          rfidHtml += '<td>';
          rfidHtml += '<div class="form_group w200">';
          if (car.rid == '' || car.rid == null) {
            rfidHtml += '<input type="text" id="carRfid' + k + '" class="form_control" value="">';
            rfidHtml += '</div>';
            rfidHtml += '<button type="button" class="btn-line-s btn_gray" onclick="putFocus(' + k + ', \'cR\')">발급</button>';
            if(type == 'return') {
              rfidHtml += '<button type="button" id="carBtn'+k+'" onclick="saveCarRfid('+k+', \''+ car.ccode +'\')" class="btn-line-s btn_default" style="margin-left: 5px">추가발급</button>';
            }
            rfidHtml += '</td>';
            // rfidHtml += '<td><button type="button" id="carBtn'+k+'" onclick="saveCarRfid('+k+')" class="btn-line-s btn_default">등록</button></td>';
          } else {
            rfidHtml += '<input type="text" id="carRfid' + k + '" class="form_control" value="'
                + car.rid + '" readonly>';
            rfidHtml += '</div>';
            rfidHtml += '</td>';
            // rfidHtml += '<td>';
            // if (type == 'return') {
            //   rfidHtml += '<button type="button" onclick="returnCarRfid('+k+')" class="btn-line-s btn_default">반납</button>';
            // }
            // rfidHtml += '</td>';
          }
          rfidHtml += '</tr>';
        }
      }
    } else {
      rfidHtml += '<tr class="tr_nodata">';
      rfidHtml += '<td colspan="3">등록된 정보가 없습니다.</td>';
      rfidHtml += '</tr>';
    }
    $("#carRfid").html(rfidHtml);

  }

  function saveCarRfid(i, cCode) {
    if ($("#carRfid" + i).val() == '') {
      alert3("RFID를 스캔해주세요.");
      return;
    }
    var param = {
      rqrId: $("#carRfid" + i).val(),
      ccode: cCode
    }
    postAjax("/admin/testerManage/updateRC", param, "carResultAlert", null, null, null)
    $("#carBtn" + i).attr("disabled", true);
  }

  function returnCarRfid(i) {
    var param = {
      rid: $("#carRfid" + i).val(),
      ccode: $("#carCode" + i).val()
    }
    postAjax("/admin/testerManage/returnRC", param, "carResultAlert", null, null, null)
  }

  function carResultAlert(result) {
    alert3(result.update);
  }

  function resultAlert(result) {
    alert(result.update);
    // if (result.update == "반납에 성공했습니다." || result.update == "발급에 성공했습니다.") {
      $(".lyClose").click(function () {
        location.reload();
      })
    // }
  }

  var carRfid = new Array();

  function delivI(i, type, dseq) {
    if (type == 'new') {
      $("#saveCol").val(i);
    } else {
      $("#returnCol").val(i);
    }
    $("input[name=newClass]").val(dseq);
  }

  function saveRW() {
    var i = $("#saveCol").val();
    var dseq = $("input[name=newClass]").val();
    if ($(".d" + dseq).html() == 'Fail') {
      alert3("발급 불가 대상입니다.");
      return;
    }
    if ($(".r" + dseq).val() == '' || $(".r" + dseq).val() == null) {
      alert3("RFID를 스캔해주세요.");
      return;
    }
    if ($(".wc" + dseq).val() == '' || $(".wc" + dseq).val() == null) {
      alert3("무전기 채널을 기록해주세요.");
      return;
    }
    if ($(".w" + dseq).val() == '' || $(".w" + dseq).val() == null) {
      alert3("무전기를 스캔해주세요.");
      return;
    }
    if ($("#showCar" + i).hasClass("btn_default") != true) {
      alert3("차량에 RFID를 발급해주세요.");
      return;
    }
    var param = {
      date: moment($("#date").val()).format('YYYYMMDD'),
      rqrId: $(".r" + dseq).val(),
      rmWCh: $(".wc" + dseq).val(),
      wqrId: $(".w" + dseq).val(),
      dseq: dseq,
      car: carRfid
    }
    postAjax("/admin/testerManage/updateRW", param, "resultAlert", null, null, null)
  }

  function returnRW() {
    var i = $("#returnCol").val();
    var dseq = $("input[name=newClass]").val();
    if (!$(".rb" + dseq).is(":disabled")) {
      alert3("미 반납된 RFID가 존재하여</br> 반납 완료 하실 수 없습니다.");
      return;
    }
    if (!$(".wb" + dseq).is(":disabled")) {
      alert3("미 반납된 무전기가 존재하여</br> 반납 완료 하실 수 없습니다.");
      return;
    }
    if (!$("#showCar" + i).is(":disabled")) {
      alert3("미 반납된 차량 RFID가 존재하여</br> 반납 완료 하실 수 없습니다.");
      return;
    }
    var param = {
      date: moment($("#date").val()).format('YYYYMMDD'),
      dseq: dseq,
      rid: $(".r" + dseq).val(),
      wid: $(".w" + dseq).val(),
      car: carRfid
    }
    postAjax("/admin/testerManage/returnRW", param, "resultAlert", null, null, null)
  }

  function carDone() {
    var i = $("#doneCol").val();
    var type = $("#doneType").val();
    if (type == 'new') {
      $("#showCar" + i).removeClass("btn_gray");
      $("#showCar" + i).addClass("btn_default");
    } else {
      $("#showCar" + i).attr("disabled", true);
    }

    $("#carRfid > tr").each(function (index) {
      var tr = $("#carRfid > tr").eq(index);
      if (tr.find("input").val() != '') {
        carRfid.push(
            {
              rqrId: tr.find("input").val(),
              ccode: tr.attr("data-carseq")
            }
        )
      }
    });
  }

  function returnBtn(i, type, dseq) {
    if (type == 'R') {
      $(".rb"+dseq).attr("disabled", true);
    } else {
      $(".wb"+dseq).attr("disabled", true);
    }
  }

  function putFocus(i, type) {
    if (type == 'R') {
      $("#rfid" + i).val('');
      if ($("#rfid" + i).val() == '') {
        $("#rfid" + i).focus();
      }
    } else if (type == 'W') {
      $("#wiress" + i).val('');
      if ($("#wiress" + i).val() == '') {
        $("#wiress" + i).focus();
      }
    } else if (type == 'cR') {
      $("#carRfid" + i).val('');
      if ($("#carRfid" + i).val() == '') {
        $("#carRfid" + i).focus();
      }
    }else if (type == 'rC') {
      $("#changeRfid").val('');
      if ($("#changeRfid").val() == ''){
        $("#changeRfid").focus();
      }
    } else if (type == 'wC') {
      $("#changeWiress").val('');
      if ($("#changeWiress").val() == ''){
        $("#changeWiress").focus();
      }
    }
  }

  function rChange(dSeq,rId) {
    $("#rChange").html("");
    var rfidHtml = "";
    rfidHtml += '<tr>';
    rfidHtml += '<td id="changeR">'+rId+'</td>';
    rfidHtml += '<td><input type="hidden" id="hrSeqR" value="'+dSeq+'">';
    rfidHtml += '<div class="form_group w200">';
    rfidHtml += '<input type="text" id="changeRfid" class="form_control" placeholder="RFID QR 입력" value="">';
    rfidHtml += '</div>';
    rfidHtml += '<button type="button" class="btn-line-s btn_gray" onclick="putFocus(0,\'rC\')">발급</button>';
    rfidHtml += '</td>';
    rfidHtml += '<td><button type="button" onclick="changeRW('+dSeq+',\'R\')" class="btn-line-s btn_default">등록</button></td>';
    rfidHtml += '</tr>';

    $("#rChange").html(rfidHtml);
  }

  function wChange(dSeq,wId) {
    $("#wChange").html("");
    var wiressHtml = "";
    wiressHtml += '<tr>';
    wiressHtml += '<td id="changeW">'+wId+'</td>';
    wiressHtml += '<td>';
    wiressHtml += '<div class="form_group w100">';
    wiressHtml += '<input type="text" id="changeWiressCh" class="form_control" placeholder="무전기CH입력" value="">';
    wiressHtml += '</div>';
    wiressHtml += '</td>';
    wiressHtml += '<td><input type="hidden" id="hrSeqW" value="'+dSeq+'">';
    wiressHtml += '<div class="form_group w200">';
    wiressHtml += '<input type="text" id="changeWiress" class="form_control" placeholder="무전기 QR 입력" value="">';
    wiressHtml += '</div>';
    wiressHtml += '<button type="button" class="btn-line-s btn_gray" onclick="putFocus(0,\'wC\')">발급</button>';
    wiressHtml += '</td>';
    wiressHtml += '<td><button type="button" onclick="changeRW('+dSeq+',\'W\')" class="btn-line-s btn_default">등록</button></td>';
    wiressHtml += '</tr>';

    $("#wChange").html(wiressHtml);
  }

  // RFID/무전기 교체시
  function changeRW(dSeq, type) {
    var param;
    if (type == 'R') { // RFID
      if ($("#changeRfid").val() == '') {
        alert3("교체할 RFID를 스캔해주세요.");
        return;
      }
      param = {
        date: moment($("#date").val()).format('YYYYMMDD'),
        dseq: dSeq,
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
        date: moment($("#date").val()).format('YYYYMMDD'),
        dseq: dSeq,
        bwid: $("#changeW").html(),
        wqrId:$("#changeWiress").val(),
        wch:$("#changeWiressCh").val(),
      }
    }
    console.log(param);
    postAjax("/admin/testerManage/changeRW", param, "resultAlert", null, null, null)
  }
</script>

<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span
                class="breadcrumb_icon"></span><span>시험자원관리</span><span>시험자 관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">B2B 시험자 관리</h2>
        <!-- //title -->
        <!-- search_wrap -->
        <section class="search_wrap">
            <div class="form_group">
                <input type="text" id="date" class="form_control date1 dateicon"
                       placeholder="시험일자 선택" name="">
            </div>
            <div class="form_group w300">
                <input type="text" id="searchInput" class="form_control"
                       placeholder="예약번호/회사명/운전자명 입력" name=""/>
            </div>
            <button type="button" class="btn-s btn_default" onclick="search(1)">조회</button>
            <button type="button" style="display: none" id="carPopup" data-layer="car">차량팝업</button>
        </section>
        <!-- //search_wrap -->
        <div class="qrinfo">
            <span class="info_ment redfont">발급버튼을 클릭하면 현재 입력된 QR Code가 삭제됩니다. 발급버튼을 누르고 QR을 인식해주세요.</span>
        </div>
        <!-- table list -->
        <section class="tbl_wrap_list m-t-30">
            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                <caption>테이블</caption>
                <colgroup>
                    <col width="60px;"/>
                    <col width="97px"/>
                    <col width="150px"/>
                    <col width=""/>
                    <col width="111px"/>
                    <col width="60px"/>
                    <col width="60px"/>
                    <col width=""/>
                    <col width=""/>
                    <col width=""/>
                    <col width=""/>
                    <col width="100px"/>
                    <col width="100px"/>
                    <%--                    <col width="" />--%>
                </colgroup>
                <thead>
                <tr>
                    <th scope="col">번호</th>
                    <th scope="col">시험일자</th>
                    <th scope="col">예약번호</th>
                    <th scope="col">예약일자</th>
                    <th scope="col">회사명</th>
                    <th scope="col">이름</th>
                    <th scope="col">DCCP</th>
                    <th scope="col">교육이수<br/>(유효기간)</th>
                    <th scope="col">RFID</th>
                    <th scope="col">무전기채널</th>
                    <th scope="col">무전기</th>
                    <th scope="col">차량번호<br/>차량RFID</th>
                    <th scope="col">비고</th>
                    <%--                    <th scope="col">연속일 시험자</th>--%>
                </tr>
                </thead>
                <tbody id="testerTable">
                </tbody>
            </table>
        </section>
        <!-- //table list -->
        <!-- Pagination -->
        <section id="pagingc" class="pagination m-t-30">
            <jsp:include page="/WEB-INF/views/jsp/common/paging.jsp"/>
        </section>
        <!-- //Pagination -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<!-- popup_Alert -->
<div class="ly_group">
    <article class="layer_Alert complete">
        <!-- # 타이틀 # -->
        <!-- <h1></h1> -->
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <input type="hidden" id="saveCol">
            <input type="hidden" name="newClass">
            발급완료 처리하시겠습니까?
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button>
            <button type="button" class="btn-pop btn_default lyClose" onclick="saveRW()">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_Alert -->

<!-- popup_Alert -->
<div class="ly_group">
    <article class="layer_Alert complete2">
        <!-- # 타이틀 # -->
        <!-- <h1></h1> -->
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <input type="hidden" id="returnCol">
            <input type="hidden" name="newClass">
            반납완료 처리하시겠습니까?
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button>
            <button type="button" class="btn-pop btn_default lyClose" onclick="returnRW()">확인
            </button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_Alert -->

<!-- popup_l -->
<div class="ly_group">
    <article class="layer_l car">
        <!-- # 타이틀 # -->
        <h1 id="carTitle">RFID 발급</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <input id="doneCol" type="hidden">
            <input id="doneType" type="hidden">
            <!-- table list -->
            <section class="tbl_wrap_list m-t-30">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width=""/>
                        <col width=""/>
                        <col width=""/>
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">차량번호</th>
                        <th scope="col">RFID</th>
                        <%--                        <th scope="col">비고</th>--%>
                    </tr>
                    </thead>
                    <tbody id="carRfid">
                    </tbody>
                </table>
            </section>
            <!-- //table list -->
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-6">취소</button>
            <button type="button" id="changeBtn" class="btn-pop btn_default lyClose" onclick="carDone()">발급완료</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_l -->
<!-- popup_l -->
<div class="ly_group">
    <article class="layer_l car2">
        <!-- # 타이틀 # -->
        <h1>RFID 반납</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <input id="doneCol2" type="hidden">
            <!-- table list -->
            <section class="tbl_wrap_list m-t-30">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width=""/>
                        <col width=""/>
                        <col width=""/>
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">차량번호</th>
                        <th scope="col">RFID</th>
                        <%--                        <th scope="col">비고</th>--%>
                    </tr>
                    </thead>
                    <tbody id="carRfid2">
                    </tbody>
                </table>
            </section>
            <!-- //table list -->
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-6">취소</button>
            <button type="button" class="btn-pop btn_default lyClose" onclick="carDone()">반납완료
            </button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_l -->
<!-- popup_l -->
<div class="ly_group">
    <article class="layer_l return">
        <!-- # 타이틀 # -->
        <h1>교체</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            해당 운전자 RFID에 대해 교체 하시겠습니까?
<%--            <span class="info_ment_orange m-l-0 m-t-10">교체 시에만 아래 “등록”을 통해 신규장비를 등록해주시기 바랍니다.</span>--%>
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
<%--            <button type="button" class="btn-pop btn_default" onclick="returnRW('R')">확인</button>--%>
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
        <h1>교체</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            해당 운전자 무전기에 대해 교체 하시겠습니까?
<%--            <span class="info_ment_orange m-l-0 m-t-10">교체 시에만 아래 “발급”을 통해 신규장비를 등록해주시기 바랍니다.</span>--%>
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
<%--            <button type="button" class="btn-pop btn_default" onclick="returnRW('W')">확인</button>--%>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_l -->

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>
