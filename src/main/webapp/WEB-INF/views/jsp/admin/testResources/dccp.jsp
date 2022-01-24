<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
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
    $(document).on("click",".pageNo",function(){
      search($(this).attr("data-page"));
    });
    //조회버튼
    $("#searchBtn").on("click",function(){
      search(1);
    });
    //조회 엔터키 처리
    $(this).keydown(function(k){
      if(k.keyCode == 13){
        search(1);
      }
    });
  });

  function search(page) {
    var param = {
      pageNo: page,
      text: $("#searchInput").val(),
      testDate: moment($("#date").val()).format('YYYYMMDD')
    };
    postAjax("/admin/dccp/list",param,"showList",null,null,null);
  }

  var dIndex = 0;
  function showList(list) {
    $("#dccpTable").html("");
    var dccpHtml = "";
    if (list.dccp.length > 0) {
      for(var i in list.dccp) {
        var dccp = list.dccp[i];
        var etc;
        if (dccp.etc != null){ etc = dccp.etc; } else { etc = ""; }
        var alcol = dccp.alcol, bloodPres = dccp.bloodPres, temp = dccp.temp;
        var salcol = dccp.salcol, sbloodPres = dccp.sbloodPres, stemp = dccp.stemp;
        dccpHtml += '<tr>';
        dccpHtml += '<td><input type="hidden" id="dcSeq'+dIndex+'" value="'+dccp.dcSeq+'">'+dccp.num+'</td>';
        dccpHtml += '<td>'+dccp.compName+'</td>';
        dccpHtml += '<td><input type="hidden" id="dSeq'+dIndex+'" value="'+dccp.dseq+'">'+dccp.dname+'</td>';
        dccpHtml += '<td>'+dccp.tcReservCode+'</td>';
        dccpHtml += '<td>';
        // 1차, 2차 결과 없을때
        if (alcol == null && bloodPres == null && temp == null) {
          dccpHtml += '<div class="form_group">';
          dccpHtml += '<div class="radio_inline">';
          dccpHtml += '<label class="radio_default">';
          dccpHtml += '<input type="radio" name="alcol'+dIndex+'" value="P" checked>';
          dccpHtml += '<span class="radio_icon"></span>Pass</label>';
          dccpHtml += '<label class="radio_default">';
          dccpHtml += '<input type="radio" name="alcol'+dIndex+'" value="F">';
          dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          dccpHtml += '</div>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          dccpHtml += '<td>';
          dccpHtml += '<div class="form_group">';
          dccpHtml += '<div class="radio_inline">';
          dccpHtml += '<label class="radio_default">';
          dccpHtml += '<input type="radio" name="bloodPres'+dIndex+'" value="P" checked>';
          dccpHtml += '<span class="radio_icon"></span>Pass</label>';
          dccpHtml += '<label class="radio_default">';
          dccpHtml += '<input type="radio" name="bloodPres'+dIndex+'" value="F">';
          dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          dccpHtml += '</div>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          dccpHtml += '<td>';
          dccpHtml += '<div class="form_group">';
          dccpHtml += '<div class="radio_inline">';
          dccpHtml += '<label class="radio_default">';
          dccpHtml += '<input type="radio" name="temp'+dIndex+'" value="P" checked>';
          dccpHtml += '<span class="radio_icon"></span>Pass</label>';
          dccpHtml += '<label class="radio_default">';
          dccpHtml += '<input type="radio" name="temp'+dIndex+'" value="F">';
          dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          dccpHtml += '</div>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          dccpHtml += '<td></td>';
          dccpHtml += '<td></td>';
          dccpHtml += '<td></td>';
          dccpHtml += '<td>';
          dccpHtml += '<div class="form_group w200">';
          dccpHtml += '<input type="text" id="reason'+dIndex+'" class="form_control" maxlength="300" placeholder="사유입력" value="'+etc+'"/>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          dccpHtml += '<td>';
          dccpHtml += '<button type="button" onclick="saveDccp('+dIndex+', '+dccp.regDt+')" class="btn-line-s btn_gray">저장</button>';
        } else if (salcol == null && sbloodPres == null && stemp == null) {// 1차O 2차X
          dccpHtml += '<div class="form_group">';
          dccpHtml += '<div class="radio_inline">';
          dccpHtml += '<label class="radio_default">';
          if (alcol == 'P') {
            dccpHtml += '<input type="radio" name="alcol'+dIndex+'" value="P" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="alcol'+dIndex+'" value="F" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          } else {
            dccpHtml += '<input type="radio" name="alcol'+dIndex+'" value="P" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="alcol'+dIndex+'" value="F" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          }
          dccpHtml += '</div>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          dccpHtml += '<td>';
          dccpHtml += '<div class="form_group">';
          dccpHtml += '<div class="radio_inline">';
          dccpHtml += '<label class="radio_default">';
          if (bloodPres == 'P') {
            dccpHtml += '<input type="radio" name="bloodPres'+dIndex+'" value="P" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="bloodPres'+dIndex+'" value="F" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          } else {
            dccpHtml += '<input type="radio" name="bloodPres'+dIndex+'" value="P" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="bloodPres'+dIndex+'" value="F" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          }
          dccpHtml += '</div>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          dccpHtml += '<td>';
          dccpHtml += '<div class="form_group">';
          dccpHtml += '<div class="radio_inline">';
          dccpHtml += '<label class="radio_default">';
          if (temp == 'P') {
            dccpHtml += '<input type="radio" name="temp'+dIndex+'" value="P" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="temp'+dIndex+'" value="F" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          } else {
            dccpHtml += '<input type="radio" name="temp'+dIndex+'" value="P" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="temp'+dIndex+'" value="F" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          }
          dccpHtml += '</div>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          var t1 = moment(dccp.regDt, 'YYYYMMDDhhmmss');
          if (alcol == 'P' && bloodPres == 'P' && temp == 'P') {
            dccpHtml += '<td></td>';
            dccpHtml += '<td></td>';
            dccpHtml += '<td></td>';
            dccpHtml += '<td>';
            dccpHtml += '<div class="form_group w200">';
            dccpHtml += '<input type="text" id="reason'+dIndex+'" class="form_control" maxlength="300" placeholder="사유입력" value="'+etc+'" readonly/>';
            dccpHtml += '</div>';
            dccpHtml += '</td>';
            dccpHtml += '<td>';
          } else if (moment.duration(moment().diff(t1)).asMinutes() >= 50) {
            dccpHtml += '<td>';
            dccpHtml += '<div class="form_group">';
            dccpHtml += '<div class="radio_inline">';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="sAlcol'+dIndex+'" value="P" checked>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="sAlcol'+dIndex+'" value="F">';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
            dccpHtml += '</div>';
            dccpHtml += '</div>';
            dccpHtml += '</td>';
            dccpHtml += '<td>';
            dccpHtml += '<div class="form_group">';
            dccpHtml += '<div class="radio_inline">';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="sBloodPres'+dIndex+'" value="P" checked>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="sBloodPres'+dIndex+'" value="F">';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
            dccpHtml += '</div>';
            dccpHtml += '</div>';
            dccpHtml += '</td>';
            dccpHtml += '<td>';
            dccpHtml += '<div class="form_group">';
            dccpHtml += '<div class="radio_inline">';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="sTemp'+dIndex+'" value="P" checked>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="sTemp'+dIndex+'" value="F">';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
            dccpHtml += '</div>';
            dccpHtml += '</div>';
            dccpHtml += '</td>';
            dccpHtml += '<td>';
            dccpHtml += '<div class="form_group w200">';
            dccpHtml += '<input type="text" id="reason'+dIndex+'" class="form_control" maxlength="300" placeholder="사유입력" value="'+etc+'"/>';
            dccpHtml += '</div>';
            dccpHtml += '</td>';
            dccpHtml += '<td>';
            dccpHtml += '<button type="button" onclick="saveDccp('+dIndex+', '+dccp.regDt+')" class="btn-line-s btn_gray">저장</button>';
          } else {
            dccpHtml += '<td></td>';
            dccpHtml += '<td></td>';
            dccpHtml += '<td></td>';
            dccpHtml += '<td>';
            dccpHtml += '<div class="form_group w200">';
            dccpHtml += '<input type="text" id="reason'+dIndex+'" class="form_control" maxlength="300" placeholder="사유입력" value="'+etc+'"/>';
            dccpHtml += '</div>';
            dccpHtml += '</td>';
            dccpHtml += '<td>';
            dccpHtml += '<button type="button" onclick="showTime('+dccp.regDt+')" class="btn-line-s btn_gray">저장</button>';
          }
        } else {// 1차O 2차O
          dccpHtml += '<div class="form_group">';
          dccpHtml += '<div class="radio_inline">';
          dccpHtml += '<label class="radio_default">';
          if (alcol == 'P') {
            dccpHtml += '<input type="radio" name="alcol'+dIndex+'" value="P" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="alcol'+dIndex+'" value="F" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          } else {
            dccpHtml += '<input type="radio" name="alcol'+dIndex+'" value="P" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="alcol'+dIndex+'" value="F" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          }
          dccpHtml += '</div>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          dccpHtml += '<td>';
          dccpHtml += '<div class="form_group">';
          dccpHtml += '<div class="radio_inline">';
          dccpHtml += '<label class="radio_default">';
          if (bloodPres == 'P') {
            dccpHtml += '<input type="radio" name="bloodPres'+dIndex+'" value="P" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="bloodPres'+dIndex+'" value="F" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          } else {
            dccpHtml += '<input type="radio" name="bloodPres'+dIndex+'" value="P" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="bloodPres'+dIndex+'" value="F" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          }
          dccpHtml += '</div>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          dccpHtml += '<td>';
          dccpHtml += '<div class="form_group">';
          dccpHtml += '<div class="radio_inline">';
          dccpHtml += '<label class="radio_default">';
          if (temp == 'P') {
            dccpHtml += '<input type="radio" name="temp'+dIndex+'" value="P" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="temp'+dIndex+'" value="F" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          } else {
            dccpHtml += '<input type="radio" name="temp'+dIndex+'" value="P" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="temp'+dIndex+'" value="F" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          }
          dccpHtml += '</div>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          dccpHtml += '<td>';
          dccpHtml += '<div class="form_group">';
          dccpHtml += '<div class="radio_inline">';
          dccpHtml += '<label class="radio_default">';
          if (salcol == 'P') {
            dccpHtml += '<input type="radio" name="sAlcol'+dIndex+'" value="P" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="sAlcol'+dIndex+'" value="F" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          } else {
            dccpHtml += '<input type="radio" name="sAlcol'+dIndex+'" value="P" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="sAlcol'+dIndex+'" value="F" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          }
          dccpHtml += '</div>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          dccpHtml += '<td>';
          dccpHtml += '<div class="form_group">';
          dccpHtml += '<div class="radio_inline">';
          dccpHtml += '<label class="radio_default">';
          if (sbloodPres == 'P') {
            dccpHtml += '<input type="radio" name="sBloodPres'+dIndex+'" value="P" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="sBloodPres'+dIndex+'" value="F" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          } else {
            dccpHtml += '<input type="radio" name="sBloodPres'+dIndex+'" value="P" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="sBloodPres'+dIndex+'" value="F" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          }
          dccpHtml += '</div>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          dccpHtml += '<td>';
          dccpHtml += '<div class="form_group">';
          dccpHtml += '<div class="radio_inline">';
          dccpHtml += '<label class="radio_default">';
          if (stemp == 'P') {
            dccpHtml += '<input type="radio" name="sTemp'+dIndex+'" value="P" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="sTemp'+dIndex+'" value="F" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          } else {
            dccpHtml += '<input type="radio" name="sTemp'+dIndex+'" value="P" disabled>';
            dccpHtml += '<span class="radio_icon"></span>Pass</label>';
            dccpHtml += '<label class="radio_default">';
            dccpHtml += '<input type="radio" name="sTemp'+dIndex+'" value="F" checked disabled>';
            dccpHtml += '<span class="radio_icon"></span>Fail</label>';
          }
          dccpHtml += '</div>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          dccpHtml += '<td>';
          dccpHtml += '<div class="form_group w200">';
          dccpHtml += '<input type="text" id="reason'+dIndex+'" class="form_control" maxlength="300" placeholder="사유입력" value="'+etc+'" readonly/>';
          dccpHtml += '</div>';
          dccpHtml += '</td>';
          dccpHtml += '<td>';
        }
        dccpHtml += '</td>';
        dccpHtml += '</tr>';

        dIndex++;
      }
    } else {
      dccpHtml += '<tr class="tr_nodata">';
      dccpHtml += '<td colspan="13">등록된 정보가 없습니다.</td>';
      dccpHtml += '</tr>';
    }
    $("#dccpTable").html(dccpHtml);
    drawingPage(list.paging);
  }

  function showTime(regDt) {
    var afterT = moment(regDt, "YYYYMMDDhhmmss").add("30", "m");
    var leftM = afterT.diff(moment(), 'minutes');
    alert(leftM+"분 후</br> 2차가 활성화됩니다.");
    $('.lyClose').click(function () {
      location.reload();
    })
  }

  function saveDccp(i, regDt) {

    if (moment($("#date").val()).format('YYYY-MM-DD') != moment().format('YYYY-MM-DD')) {
      alert3("당일 시험이 있는 운전자가 아닙니다.");
      return;
    }
    var alcol = $('input[name="alcol'+i+'"]:checked').val();
    var bloodPres = $('input[name="bloodPres'+i+'"]:checked').val();
    var temp = $('input[name="temp'+i+'"]:checked').val();

    var sAlcol = $('input[name="sAlcol'+i+'"]:checked').val();
    var sBloodPres = $('input[name="sBloodPres'+i+'"]:checked').val();
    var sTemp = $('input[name="sTemp'+i+'"]:checked').val();

    var nDccpYn = 'N';
    if (regDt == null) {

      if (alcol != 'P' && alcol != 'F') {
        alert3("1차 음주여부를 체크하세요.");
        return;
      }
      if (bloodPres != 'P' && bloodPres != 'F') {
        alert3("1차 혈압을 체크하세요.");
        return;
      }
      if (temp != 'P' && temp != 'F') {
        alert3("1차 체온을 체크하세요.");
        return;
      }

      if (alcol == 'P' && bloodPres == 'P' && temp == 'P') {
        sAlcol = null;
        sBloodPres = null;
        sTemp = null;
        nDccpYn = 'Y';
      }

      var param = {
        dseq: $("#dSeq"+i).val(),
        alcol: alcol,
        bloodPres: bloodPres,
        temp: temp,
        salcol: sAlcol,
        sbloodPres: sBloodPres,
        stemp: sTemp,
        etc: $("#reason"+i).val(),
        regUser: "<%=memberDto.getMemId()%>",
        regDt: moment().format("YYYYMMDDHHmmss"),
        ndccpYn: nDccpYn
      };

      postAjax("/admin/dccp/insert",param,"resultAlert",null,null,null);
    } else {

      if (sAlcol != 'P' && sAlcol != 'F') {
        alert3("2차 음주여부를 체크하세요.");
        return;
      }
      if (sBloodPres != 'P' && sBloodPres != 'F') {
        alert3("2차 혈압을 체크하세요.");
        return;
      }
      if (sTemp != 'P' && sTemp != 'F') {
        alert3("2차 체온을 체크하세요.");
        return;
      }

      if (sAlcol == 'P' && sBloodPres == 'P' && sTemp == 'P') {
        nDccpYn = 'Y';
      }

      var param = {
        dcSeq: $("#dcSeq"+i).val(),
        dseq: $("#dSeq"+i).val(),
        salcol: sAlcol,
        sbloodPres: sBloodPres,
        stemp: sTemp,
        etc: $("#reason"+i).val(),
        regUser: "<%=memberDto.getMemId()%>",
        regDt: moment().format("YYYYMMDDHHmmss"),
        ndccpYn: nDccpYn
      };

      postAjax("/admin/dccp/update",param,"resultAlert",null,null,null);
    }

  }

  function resultAlert(result) {
    if (result == 1) {
      alert("저장이 완료되었습니다.");
      $(".lyClose").click(function () {
        location.reload();
      })
    } else {
      alert("저장에 실패하였습니다.");
    }
  }
</script>

<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시험자원관리</span><span>운전자 DCCP 관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">운전자 DCCP 관리</h2>
        <!-- //title -->
        <!-- search_wrap -->
        <section class="search_wrap">
            <div class="form_group">
                <input type="text" id="date" class="form_control date1 dateicon" placeholder="시험일자 선택" name="">
            </div>
            <div class="form_group w300">
                <input type="text" id="searchInput" class="form_control" placeholder="예약번호/회사명/운전자명 입력" name="" />
            </div>
            <button type="button" id="searchButton" onclick="search()" class="btn-s btn_default">조회</button>
        </section>
        <!-- //search_wrap -->

        <!-- table list -->
        <section class="tbl_wrap_list m-t-30">
            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                <caption>테이블</caption>
                <colgroup>
                    <col width="60px;" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="156px" />
                    <col width="156px" />
                    <col width="156px" />
                    <col width="156px" />
                    <col width="156px" />
                    <col width="156px" />
                    <col width="" />
                    <col width="" />
                </colgroup>
                <thead>
                <tr>
                    <th rowspan="2" scope="col">번호</th>
                    <th rowspan="2" scope="col">회사명</th>
                    <th rowspan="2" scope="col">운전자명</th>
                    <th rowspan="2" scope="col">예약번호</th>
                    <th colspan="3" scope="col" class="border-b-1">1차</th>
                    <th colspan="3" scope="col" class="border-b-1">2차</th>
                    <th rowspan="2" scope="col">사유</th>
                    <th rowspan="2" scope="col">비고</th>
                </tr>
                <tr>
                    <th scope="col" class="border-l-1">음주여부</th>
                    <th scope="col">혈압</th>
                    <th scope="col">체온</th>
                    <th scope="col">음주여부</th>
                    <th scope="col">혈압</th>
                    <th scope="col">체온</th>
                </tr>
                </thead>
                <tbody id="dccpTable">
                </tbody>
            </table>
        </section>
        <!-- //table list -->
        <!-- Pagination -->
        <section id="pagingc" class="pagination m-t-30">
            <jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
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
            저장완료 되었습니다.
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
<!-- //popup_Alert -->

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>