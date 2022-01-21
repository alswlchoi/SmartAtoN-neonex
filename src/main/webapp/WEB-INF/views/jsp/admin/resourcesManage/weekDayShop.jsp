<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
  $(document).ready(function () {
    var param = {};
    postAjax("/admin/shop/getWeekDay", param, "showList", null, null, null);
  });
  var wdKind;
  var wIndex;
  function showList(list) {
    wdKind = list.shop;
    $("#weekDayTable").html("");
    var weekDayHtml = "";
    var stDt = "";
    var edDt = "";
    wIndex = list.weekDay.length;
    if (list.weekDay.length > 0) {
      var index = 1;
      for (var i in list.weekDay) {
        var weekDay = list.weekDay[i];
        weekDayHtml += '<tr>';
        weekDayHtml += '<td><input type="hidden" id="wdSeq'+i+'" value="'+weekDay.wdSeq+'">'+index+'</td>';
        weekDayHtml += '<td><input type="hidden" id="sName'+i+'" value="'+weekDay.wdKind+'">'+weekDay.wsName+'</td>';
        stDt = weekDay.wdStDt;
        edDt = weekDay.wdEdDt;
        stDt = stDt.substring(0,4)+"-"+stDt.substring(4,6)+"-"+stDt.substring(6,8);
        edDt = edDt.substring(0,4)+"-"+edDt.substring(4,6)+"-"+edDt.substring(6,8);
        weekDayHtml += '<td>';
        weekDayHtml += '<div class="form_group w300">';
        weekDayHtml += '<input type="text" id="dateto'+i+'" class="form_control dateicon datefromto" placeholder="기간 선택" value="'+stDt+' ~ '+edDt+'" name="dateto">';
        weekDayHtml += '</div>';
        weekDayHtml += '</td>';
        weekDayHtml += '<td>';
        weekDayHtml += '<div class="form_group">';
        weekDayHtml += '<div class="radio_inline">';
        weekDayHtml += '<label class="radio_default">';
        if (weekDay.wdCon == '1') {
          weekDayHtml += '<input type="radio" name="wRadio'+i+'" value="1" checked="">';
          weekDayHtml += '<span class="radio_icon"></span>사용불가</label>';
          weekDayHtml += '<label class="radio_default">';
          weekDayHtml += '<input type="radio" name="wRadio'+i+'" value="2">';
          weekDayHtml += '<span class="radio_icon"></span>사용가능</label>';
        } else {
          weekDayHtml += '<input type="radio" name="wRadio'+i+'" value="1">';
          weekDayHtml += '<span class="radio_icon"></span>사용불가</label>';
          weekDayHtml += '<label class="radio_default">';
          weekDayHtml += '<input type="radio" name="wRadio'+i+'" value="2" checked="">';
          weekDayHtml += '<span class="radio_icon"></span>사용가능</label>';
        }
        weekDayHtml += '</div>';
        weekDayHtml += '</div>';
        weekDayHtml += '</td>';
        weekDayHtml += '<td>';
        weekDayHtml += '<button type="button" onclick="saveWeekDay('+i+')" class="btn-line-s btn_default m-r-6">저장</button>';
        weekDayHtml += '<button type="button" onclick="delWeekDay('+i+')" class="btn-line-s btn_gray">삭제</button>';
        weekDayHtml += '</td>';
        weekDayHtml += '</tr>';

        index++;
      }
    } else {
      weekDayHtml += '<tr class="tr_nodata">';
      weekDayHtml += '<td colspan="10">등록된 정보가 없습니다.</td>';
      weekDayHtml += '</tr>';
    }

    $("#weekDayTable").append(weekDayHtml);
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
      timePicker24Hour: true,
      timePickerSeconds: true,
      singleDatePicker: false
    });
    drawingPage(list.paging);
  }

  function addWeekDay() {
    wIndex++;
    var weekDayHtml = "";
    weekDayHtml += '<tr>';
    weekDayHtml += '<td><input type="hidden" id="wdSeq'+wIndex+'" value="new">'+wIndex+'</td>';
    weekDayHtml += '<td>';
    weekDayHtml += '<div class="form_group">';
    weekDayHtml += '<div class="select_group">';
    weekDayHtml += '<select id="shopName'+wIndex+'" title="select" class="form_control">';
    if (wdKind.length > 0) {
      for (var i in wdKind) {
        var shop = wdKind[i];
        weekDayHtml += '<option value="'+shop.wsCode+'">'+shop.wsName+'</option>';
      }
    }
    weekDayHtml += '</select>';
    weekDayHtml += '</div>';
    weekDayHtml += '</div>';
    weekDayHtml += '</td>';
    weekDayHtml += '<td>';
    weekDayHtml += '<div class="form_group w300">';
    weekDayHtml += '<input type="text" id="dateto'+wIndex+'" class="form_control dateicon datefromto" placeholder="기간 선택" name="dateto">';
    weekDayHtml += '</div>';
    weekDayHtml += '</td>';
    weekDayHtml += '<td>';
    weekDayHtml += '<div class="form_group">';
    weekDayHtml += '<div class="radio_inline">';
    weekDayHtml += '<label class="radio_default">';
    weekDayHtml += '<input type="radio" name="wRadio'+wIndex+'" value="1" checked="">';
    weekDayHtml += '<span class="radio_icon"></span>사용불가</label>';
    weekDayHtml += '<label class="radio_default">';
    weekDayHtml += '<input type="radio" name="wRadio'+wIndex+'" value="2">';
    weekDayHtml += '<span class="radio_icon"></span>사용가능</label>';
    weekDayHtml += '</div>';
    weekDayHtml += '</div>';
    weekDayHtml += '</td>';
    weekDayHtml += '<td><button type="button" onclick="saveWeekDay('+wIndex+')" class="btn-line-s btn_gray">저장</button></td>';
    weekDayHtml += '</tr>';

    $("#weekDayTable").prepend(weekDayHtml);
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
      timePicker24Hour: true,
      timePickerSeconds: true,
      singleDatePicker: false
    });
  }

  function saveWeekDay(i) {
    var date = $("#dateto"+i).val().split(" ~ ");
    if ($("#shopName"+i+" option:selected").val() == '') {
      alert3("부대시설명을 입력해주세요.");
      return;
    }
    var param;
    if ($("#wdSeq"+i).val() == 'new') {
      param = {
        wdModUser: "<%=memberDto.getMemId()%>",
        wdModDt: moment().format("YYYYMMDDHHmmss"),
        wdRegUser: "<%=memberDto.getMemId()%>",
        wdRegDt: moment().format("YYYYMMDDHHmmss"),
        wdEdDt: moment(date[1]).format('YYYYMMDD'),
        wdStDt: moment(date[0]).format('YYYYMMDD'),
        wdKind: $("#shopName"+i+" option:selected").val(),
        wdCon: $('input[name="wRadio'+i+'"]:checked').val()
      };
      postAjax("/admin/shop/insertWeekDay", param, "resultAlert", null, null, null)
    } else {
      param = {
        wdSeq: $("#wdSeq"+i).val(),
        wdModUser: "<%=memberDto.getMemId()%>",
        wdModDt: moment().format("YYYYMMDDHHmmss"),
        wdEdDt: moment(date[1]).format('YYYYMMDD'),
        wdStDt: moment(date[0]).format('YYYYMMDD'),
        wdKind: $("#sName"+i).val(),
        wdCon: $('input[name="wRadio'+i+'"]:checked').val()
      };
      postAjax("/admin/shop/updateWeekDay", param, "resultAlert", null, null, null)
    }
  }

  function delWeekDay(i) {
    confirm("부대시설 점검일을 삭제하시겠습니까?");
    $("#confirmTrue").click(function () {
      var param = {
        wdSeq: $("#wdSeq"+i).val()
      };
      postAjax("/admin/shop/deleteWeekDay", param, "resultAlert", null, null, null)
    })
  }

  function resultAlert(result) {
    alert(result.alert);
    if (result.alert == "저장에 성공했습니다." || result.alert == "삭제에 성공했습니다.") {
      $(".lyClose").click(function () {
        location.reload();
      })
    }
  }
</script>

<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span
                class="breadcrumb_icon"></span><span>회원사/자원관리</span><span>자원관리</span><span>부대시설 전용운영일 관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">부대시설 점검일 관리</h2>
        <!-- //title -->
        <!-- table list -->
        <section class="tbl_wrap_list m-t-30">
            <button type="button" onclick="addWeekDay()" class="btn btn_default posi_right_0_2">등록</button>
            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                <caption>테이블</caption>
                <colgroup>
                    <col width="80px" />
                    <col width="255px" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                </colgroup>
                <thead>
                <tr>
                    <th scope="col">번호</th>
                    <th scope="col">부대시설명</th>
                    <th scope="col">기간</th>
                    <th scope="col">상태</th>
                    <th scope="col">비고</th>
                </tr>
                </thead>
                <tbody id="weekDayTable">
                </tbody>
            </table>
        </section>
        <!-- Pagination -->
        <section id="pagingc" class="pagination m-t-30">
            <jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
        </section>
        <!-- //Pagination -->
        <!-- //table_view -->
        <!-- table_view -->
        <%--<section class="tbl_wrap_view m-t-50">
            <table class="tbl_view01" summary="테이블입니다.">
                <caption>테이블입니다.</caption>
                <colgroup>
                    <col width="180px" />
                    <col width="40%" />
                    <col width="180px" />
                    <col width="" />
                </colgroup>
                <tr>
                    <th scope="row">등록자</th>
                    <td>admin1</td>
                    <th>등록일</th>
                    <td>2021.07.21 14:00:00</td>
                </tr>
                <tr>
                    <th scope="row">수정자</th>
                    <td>admin55</td>
                    <th>수정일</th>
                    <td>2021.07.21 14:00:00</td>
                </tr>
            </table>
        </section>--%>
        <!-- //table_view -->
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
            <!-- <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button> -->
            <button type="button" class="btn-pop btn_default lyClose">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_Alert -->

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
            <button type="button" class="btn-pop btn_default lyClose">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_Alert -->

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>
