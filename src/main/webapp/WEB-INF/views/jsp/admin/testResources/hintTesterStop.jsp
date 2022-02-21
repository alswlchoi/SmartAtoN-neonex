<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
  $(document).ready(function () {
    $("input[name=dateto]").daterangepicker({
      locale: {
        separator: " ~ ",
        format: 'YYYY-MM-DD',
        // applyLabel: "확인",
        // cancelLabel: "취소",
        daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
      },
      timePicker: false,
      showDropdowns: true,
      autoApply: true,
      autoUpdateInput: false,
      timePicker24Hour: true,
      timePickerSeconds: true,
    });

    $("input[name=dateto]").on('cancel.daterangepicker', function(ev, picker) {
      $(this).val('');
    });

    var test = document.querySelector('input');
    test.addEventListener('input', evt => evt.target)

    search(1);
    //페이징 조회 버튼
    $(document).on("click",".pageNo",function(){
      search($(this).attr("data-page"));
    });

    //조회 엔터키 처리
    $(this).keydown(function(k) {
      if (k.keyCode == 13) {
        search(1);
      }
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

  function search(page) {
    var stDate = null,edDate = null;
    // 날짜
    if ($("#stopDate").val() != '') {
      var scheduleDate = $("#stopDate").val().split(' ~ ');
      stDate = moment(scheduleDate[0]).format('YYYYMMDD');
      edDate = moment(scheduleDate[1]).format('YYYYMMDD');
    }
    var param = {
      pageNo: page,
      text: $("#search").val(),
      stDate: stDate,
      edDate: edDate
    }

    postAjax("/admin/testerManage/testerStop", param, "showList", null, null, null)
  }

  function showList(list) {
    $("#stopList").html("");
    var stopHtml = "";
    if (list.stop.length > 0 && list.stop[0] != null) {
      for (var i in list.stop) {
        var stop = list.stop[i];
        stopHtml += '<tr>';
        stopHtml += '<td>'+stop.name+'('+stop.employeeNo+')</td>';
        if(stop.crnDtm == null) {
            stopHtml += '<td>-</td>';
        }else{
            stopHtml += '<td>'+moment(stop.crnDtm).format("YYYY.MM.DD")+'</td>';
        }
        stopHtml += '<td>'+moment(stop.tcDay).format("YYYY.MM.DD")+'</td>';
        if (stop.rreturn == '' || stop.rreturn == null) {
          stopHtml += '<td>-</td>';
        } else {
          stopHtml += '<td>'+moment(stop.rreturn).format("YYYY.MM.DD")+'</td>';
        }
        stopHtml += '</tr>';
      }
    } else {
      stopHtml += '<tr class="tr_nodata">';
      stopHtml += '<td colspan="6">등록된 정보가 없습니다.</td>';
      stopHtml += '</tr>';
    }

    $("#stopList").html(stopHtml);
    drawingPage(list.paging);
  }

  function reset() {
    $("#stopDate").val("");
    $("#search").val("");
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
                <button class="tablinks" onclick="pageMove('tab2')">평가차량</button>
                <button class="tablinks active" onclick="pageMove('tab3')">평가자 일시정지 조회</button>
            </div>
            <div class="wrap_tabcontent">
                <!-- tab3-평가자 일시정지 조회 -->
                <div id="tab3" class="tabcontent">
                    <!-- search_wrap -->
                    <section class="search_wrap">
                        <div class="form_group w230">
                            <input type="text" id="stopDate" class="form_control dateicon datefromto"
                                   placeholder="일시정지 기간 선택" name="dateto">
                        </div>
                        <div class="form_group w300">
                            <input type="text" id="search" class="form_control" placeholder="운전자명/사번 입력" name="" />
                        </div>
                        <button type="button" class="btn-s btn_default" onclick="search(1)">조회</button>
                        <button type="button" class="btn-s btn_default" onclick="reset()">검색초기화</button>
                    </section>
                    <!-- //search_wrap -->
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
                                <th scope="col">평가자명(사번)</th>
                                <th scope="col">등록일</th>
                                <th scope="col">최근 일시정지일</th>
                                <th scope="col">반납일</th>
                            </tr>
                            </thead>
                            <tbody id="stopList">
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
                <!-- //tab3-평가자 일시정지 조회 -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>