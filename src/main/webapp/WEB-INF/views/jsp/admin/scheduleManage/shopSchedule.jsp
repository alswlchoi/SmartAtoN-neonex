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
      timePickerSeconds: true,
    });

    $("input[name=dateto]").on('cancel.daterangepicker', function(ev, picker) {
      $(this).val('');
    });
    getShop();
    search(1);
    //페이징 조회 버튼
    $(document).on("click",".pageNo",function(){
      search($(this).attr("data-page"));
    });
  })

  //탭 이동
  function pageMove(str){
    if(str=='tab1'){
      location.href = '/admin/trReserve/trcalendar';
    }else if(str == 'tab2'){
      location.href = '/admin/reserved/schedule';
    }
  }

  function getShop() {
    var param = {};
    postAjax("/admin/shop/list", param, "drawSelect", null, null, null)
  }

  function drawSelect (list) {
    $("#select").html("");
    var selectHtml = "";
    if (list.shop.length > 0) {
      selectHtml += '<select id="shopCode" title="select" class="form_control">';
      selectHtml += '<option value="">선택</option>';
      for (var i in list.shop) {
        var shop = list.shop[i];
        selectHtml += '<option value="'+shop.wsCode+'">'+shop.wsName+'</option>';
      }
      selectHtml += '</select>';
    }
    $("#select").html(selectHtml);
  }

  function search(page) {
    var stDate = null,edDate = null;
    var orderName1="",orderKind1="";
    var orderName2="",orderKind2="";

    // 날짜
    if ($("#scheduleDate").val() != '') {
      var scheduleDate = $("#scheduleDate").val().split(' ~ ');
      stDate = moment(scheduleDate[0]).format('YYYYMMDD');
      edDate = moment(scheduleDate[1]).format('YYYYMMDD');
    }
    // 정렬
    if($("#order1").hasClass("btn_sort_down")){
      orderName1="Y";
      orderKind1="DESC";
    }else if($("#order1").hasClass("btn_sort_up")){
      orderName1="Y";
      orderKind1="ASC";
    }
    if($("#order2").hasClass("btn_sort_down")){
      orderName2="Y";
      orderKind2="DESC";
    }else if($("#order2").hasClass("btn_sort_up")){
      orderName2="Y";
      orderKind2="ASC";
    }

    var param = {
      pageNo: page,
      text: $("#keyword").val(),
      stDate: stDate,
      edDate: edDate,
      select: $("#shopCode option:selected").val(),
      wssApproval1: 'Y',
      wssApproval2: null,
      orderName1: orderName1,
      orderName2: orderName2,
      orderKind1: orderKind1,
      orderKind2: orderKind2
    };
    console.log(param);
    postAjax("/admin/reserved/list", param, "showList", null, null, null)
  }

  function showList(list) {
    console.log(list);
    var scheduledHtml = "";
    if (list.list.length > 0) {
      for (var i in list.list) {
        var schedule = list.list[i];
        scheduledHtml += '<tr onmouseover="this.className=\'on\'" onmouseout="this.className=\'\'" onclick="goDetail(\''+schedule.wssReservCode+'\')">';
        scheduledHtml += '<td>'+schedule.num+'</td>';
        scheduledHtml += '<td>'+schedule.wssReservCode+'</td>';
        scheduledHtml += '<td>'+moment(schedule.wssRegDt, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';
        if (moment(schedule.wssStDay) == moment(schedule.wssEdDay)) {
          scheduledHtml += '<td>'+moment(schedule.wssStDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';
        } else {
          scheduledHtml += '<td>'+moment(schedule.wssStDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+' ~ '+moment(schedule.wssEdDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';
        }

        scheduledHtml += '<td>'+schedule.compName+'';
        if (schedule.blackList == 'Y') {
          scheduledHtml += '<span class="color_red">(B/L)</span>';
        }
        scheduledHtml += '</td>';
        scheduledHtml += '<td>'+schedule.wsName+'</td>';
        scheduledHtml += '</tr>';
      }
    } else {
      scheduledHtml += '<tr class="tr_nodata">';
      scheduledHtml += '<td colspan="6">등록된 정보가 없습니다.</td>';
      scheduledHtml += '</tr>';
    }
    $("#scheduleList").html(scheduledHtml);
    drawingPage(list.paging);
  }

  function goDetail(reservedCode) {
    location.href = "/admin/reserved/scheduleDetail?reservedCode="+reservedCode;
  }

  // 정렬버튼 이미지 변경
  function sort(column, type) {
    if (column == 1) { // 컬럼 구분
      search(1);
      if ($("#order1").hasClass("btn_sort_down")){
        $("#order1").attr("class","btn_sort_up")
      } else if ($("#order1").hasClass("btn_sort_up")){
        $("#order1").attr("class","btn_sort_down")
      }
    } else if (column == 2) {
      search(1);
      if ($("#order2").hasClass("btn_sort_down")){
        $("#order2").attr("class","btn_sort_up")
      } else if ($("#order2").hasClass("btn_sort_up")){
        $("#order2").attr("class","btn_sort_down")
      }
    }
  }

  function reset() {
    $("#scheduleDate").val("");
    $("#keyword").val("");
    $("#shopCode option:eq(0)").attr("selected", "selected");
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
                    <!-- search_wrap -->
                    <section class="search_wrap">
                        <div class="form_group w230">
                            <input type="text" id="scheduleDate" class="form_control dateicon datefromto"
                                   placeholder="예약기간 선택" name="dateto">
                        </div>
                        <div class="form_group w300">
                            <input type="text" id="keyword" class="form_control" placeholder="예약번호/사업자번호/회사명 입력"
                                   name="" />
                        </div>
                        <div class="form_group">
                            <!-- <label for="se1">검색선택</label> -->
                            <div class="select_group" id="select">
                            </div>
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
                                <col width="80px" />
                                <col width="317px" />
                                <col width="268px" />
                                <col width="" />
                                <col width="301px" />
                                <col width="213px" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th scope="col">번호</th>
                                <th scope="col">예약번호</th>
                                <th scope="col">접수일자
                                    <button id="order1" onclick="sort(1)" class="btn_sort_down"></button>
                                </th>
                                <th scope="col">예약일자
                                    <button id="order2" onclick="sort(2)" class="btn_sort_down"></button>
                                </th>
                                <th scope="col">회사명</th>
                                <th scope="col">항목</th>
                            </tr>
                            </thead>
                            <tbody id="scheduleList">
                            <tr onmouseover="this.className='on'" onmouseout="this.className=''"
                                onclick="location.href='#';">
                                <td>10</td>
                                <td>2020010101</td>
                                <td>2021.08.01</td>
                                <td>2021.01.01</td>
                                <td>원투연구소<span class="color_red">(B/L)</span></td>
                                <td>워크샵A동</td>
                            </tr>
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
                <!-- //tab2-부대시설 -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

<!-- tab2 -->
<script>
  $(function () {
    $(".webwidget_tab").webwidget_tab({
      window_padding: '0',
      head_text_color: '#999',
      head_current_text_color: '#333'
    });
  });
</script>
<!-- //tab2 -->

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