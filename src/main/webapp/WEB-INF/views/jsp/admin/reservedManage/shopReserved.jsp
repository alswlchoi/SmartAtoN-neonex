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

      var type = getParam().type;
      if (type == 'reject') {
        $("#N").removeClass('currentBtn2');
        $("#C").attr('class', 'currentBtn2');
        search(1, 'reject');
      } else {
        $("#N").attr('currentBtn2');
        $("#C").removeClass('class', 'currentBtn2');
        search(1, 'ready');
      }

      //페이징 조회 버튼
      $(document).on("click","#pagingc>span>.pageNo",function(){
        search($(this).attr("data-page"), 'ready');
      });
      $(document).on("click","#pagingl>span>.pageNo",function(){
        search($(this).attr("data-page"), 'reject');
      });
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

      $("#select2").html("");
      var selectHtml2 = "";
      if (list.shop.length > 0) {
        selectHtml2 += '<select id="shopCode2" title="select" class="form_control">';
        selectHtml2 += '<option value="">선택</option>';
        for (var i in list.shop) {
          var shop = list.shop[i];
          selectHtml2 += '<option value="'+shop.wsCode+'">'+shop.wsName+'</option>';
        }
        selectHtml2 += '</select>';
      }
      $("#select2").html(selectHtml2);
    }

    function search(page, type) {
      var stDate = null,edDate = null;
      var text = null, select = null, approval1 = null, approval2 = null;
      var orderName1="",orderKind1="";
      var orderName2="",orderKind2="";
      if (type == 'ready') { // 예약승인대기
        // 날짜
        if ($("#readyDate").val() != '') {
          var readyDate = $("#readyDate").val().split(' ~ ');
          stDate = moment(readyDate[0]).format('YYYYMMDD');
          edDate = moment(readyDate[1]).format('YYYYMMDD');
        }
        // keyword
        text = $("#readyKeyword").val();
        // select
        select = $("#shopCode option:selected").val();
        // approval
        approval1 = 'N';
        // 정렬
        if($("#readyOrder1").hasClass("btn_sort_down")){
          orderName1="Y";
          orderKind1="DESC";
        }else if($("#readyOrder1").hasClass("btn_sort_up")){
          orderName1="Y";
          orderKind1="ASC";
        }
        if($("#readyOrder2").hasClass("btn_sort_down")){
          orderName2="Y";
          orderKind2="DESC";
        }else if($("#readyOrder2").hasClass("btn_sort_up")){
          orderName2="Y";
          orderKind2="ASC";
        }
      } else { // 예약반려/취소
        // 날짜
        if ($("#rejectDate").val() != '') {
          var rejectDate = $("#rejectDate").val().split(' ~ ');
          stDate = moment(rejectDate[0]).format('YYYYMMDD');
          edDate = moment(rejectDate[1]).format('YYYYMMDD');
        }
        // keyword
        text = $("#rejectKeyword").val();
        // select
        select = $("#shopCode2 option:selected").val();
        // approval
        approval1 = 'R';
        approval2 = 'C';
        // 정렬
        if($("#rejectOrder1").hasClass("btn_sort_down")){
          orderName1="Y";
          orderKind1="DESC";
        }else if($("#rejectOrder1").hasClass("btn_sort_up")){
          orderName1="Y";
          orderKind1="ASC";
        }
        if($("#rejectOrder2").hasClass("btn_sort_down")){
          orderName2="Y";
          orderKind2="DESC";
        }else if($("#rejectOrder2").hasClass("btn_sort_up")){
          orderName2="Y";
          orderKind2="ASC";
        }
      }
      if (select == null) {
        select = "";
      }

      var param = {
        pageNo: page,
        text: text,
        stDate: stDate,
        edDate: edDate,
        select: select,
        wssApproval1: approval1,
        wssApproval2: approval2,
        orderName1: orderName1,
        orderName2: orderName2,
        orderKind1: orderKind1,
        orderKind2: orderKind2
      }
      postAjax("/admin/reserved/list", param, "showList", null, null, null)
    }

    function showList(list) {
      var reservHtml = "";
      var paging = list.paging;
      if (list.list.length > 0) {
        for (var i in list.list) {
          var reserv = list.list[i];
          var index=paging.totalCount-(paging.pageNo-1)*paging.pageSize-i;
          reservHtml += '<tr onmouseover="this.className=\'on\'" onmouseout="this.className=\'\'" onclick="goDetail(\''+reserv.wssReservCode+'\', '+i+', \''+reserv.wssApproval+'\')">';
          reservHtml += '<td>'+index+'</td>';
          reservHtml += '<td>'+reserv.wssReservCode+'</td>';
          reservHtml += '<td>'+moment(reserv.wssRegDt, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';
          if (moment(reserv.wssStDay) == moment(reserv.wssEdDay)) {
            reservHtml += '<td>'+moment(reserv.wssStDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';
          } else {
            reservHtml += '<td>'+moment(reserv.wssStDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+' ~ '+moment(reserv.wssEdDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';
          }

          reservHtml += '<td>'+reserv.compName+'';
          if (reserv.blackList == 'Y') {
            reservHtml += '<span class="color_red">(B/L)</span>';
          }
          reservHtml += '</td>';
          reservHtml += '<td>'+reserv.wsName+'</td>';
          reservHtml += '</tr>';

          index++;
        }
      } else {
        reservHtml += '<tr class="tr_nodata">';
        reservHtml += '<td colspan="6">등록된 정보가 없습니다.</td>';
        reservHtml += '</tr>';
      }
      if ($(".currentBtn2").val() == 0) {
        $("#readyList").html("");
        $("#readyList").html(reservHtml);
        drawingPage(list.paging);
        $("#ready").show();
        $("#reject").hide();
      } else {
        $("#rejectList").html("");
        $("#rejectList").html(reservHtml);
        drawingPage2(list.paging);
        $("#ready").hide();
        $("#reject").show();
      }
    }

    function goDetail(reservedCode, i, type) {
      location.href = "/admin/reserved/detail?reservedCode="+reservedCode+"&type="+type;
    }

    // 정렬버튼 이미지 변경
    function sort(column, type) {
      if (type == 'ready') { // 예약승인대기
        if (column == 1) { // 컬럼 구분
          search(1,type);
          if ($("#readyOrder1").hasClass("btn_sort_down")){
            $("#readyOrder1").attr("class","btn_sort_up")
          } else if ($("#readyOrder1").hasClass("btn_sort_up")){
            $("#readyOrder1").attr("class","btn_sort_down")
          }
        } else if (column == 2) {
          search(1,type);
          if ($("#readyOrder2").hasClass("btn_sort_down")){
            $("#readyOrder2").attr("class","btn_sort_up")
          } else if ($("#readyOrder2").hasClass("btn_sort_up")){
            $("#readyOrder2").attr("class","btn_sort_down")
          }
        }
      } else { // 예약반려/취소
        if (column == 1) { // 컬럼 구분
          search(1,type);
          if ($("#rejectOrder1").hasClass("btn_sort_down")){
            $("#rejectOrder1").attr("class","btn_sort_up")
          } else if ($("#rejectOrder1").hasClass("btn_sort_up")){
            $("#rejectOrder1").attr("class","btn_sort_down")
          }
        } else if (column == 2) {
          search(1,type);
          if ($("#rejectOrder2").hasClass("btn_sort_down")){
            $("#rejectOrder2").attr("class","btn_sort_up")
          } else if ($("#rejectOrder2").hasClass("btn_sort_up")){
            $("#rejectOrder2").attr("class","btn_sort_down")
          }
        }
      }
    }

    function reset() {
      $("#readyDate").val("");
      $("#rejectDate").val("");
      $("#readyKeyword").val("");
      $("#rejectKeyword").val("");
      $("#shopCode option:eq(0)").attr("selected", "selected");
      $("#shopCode2 option:eq(0)").attr("selected", "selected");
    }

</script>
<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>예약/정산관리</span><span>예약관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">예약관리</h2>
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
                    <!-- tab2 -->
                    <div class="webwidget_tab" id="webwidget_tab">
                        <div class="tabContainer2">
                            <ul class="tabHead2">
                                <li id="N" class="currentBtn2" value="0"><a href="javascript:search(1,'ready');">예약승인대기</a></li>
                                <li id="C" value="1"><a href="javascript:search(1,'reject');">예약반려/취소</a></li>
                            </ul>
                        </div>
                        <div class="tabBody2">
                            <ul>
                                <!-- 예약승인대기(부대시설) -->
                                <li id="ready" class="tabCot2">
                                    <!-- search_wrap -->
                                    <section class="search_wrap m-t-30">
                                        <div class="form_group w230">
                                            <input type="text" id="readyDate"
                                                   class="form_control dateicon datefromto" placeholder="예약기간 선택"
                                                   name="dateto">
                                        </div>
                                        <div class="form_group w300">
                                            <input type="text" id="readyKeyword" class="form_control"
                                                   placeholder="예약번호/사업자번호/회사명 입력" name="" />
                                        </div>
                                        <div class="form_group">
                                            <div class="select_group" id="select">
                                            </div>
                                        </div>
                                        <button type="button" class="btn-s btn_default" onclick="search(1, 'ready')">조회</button>
                                        <button type="button" class="btn-s btn_default" onclick="reset()">검색초기화</button>
                                    </section>
                                    <!-- //search_wrap -->
                                    <!-- table list -->
                                    <section class="tbl_wrap_list m-t-15">
                                        <table id="approvalTable" class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
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
                                                    <button id="readyOrder1" onclick="sort(1, 'ready')" class="btn_sort_down"></button>
                                                </th>
                                                <th scope="col">예약일자
                                                    <button id="readyOrder2" onclick="sort(2, 'ready')" class="btn_sort_down"></button>
                                                </th>
                                                <th scope="col">회사명</th>
                                                <th scope="col">항목</th>
                                            </tr>
                                            </thead>
                                            <tbody id="readyList">
                                            <tr onmouseover="this.className='on'" onmouseout="this.className=''" onclick="location.href='#';">
                                                <td>10</td>
                                                <td>2020010101</td>
                                                <td>2021.08.01</td>
                                                <td>2021.01.01</td>
                                                <td>원투연구소<span class="color_red">(B/L)</span></td>
                                                <td>워크샵A동</td>
                                            </tr>
                                            <!-- <tr class="tr_nodata">
                <td colspan="6">등록된 정보가 없습니다.</td>
            </tr> -->
                                            </tbody>
                                        </table>
                                    </section>
                                    <!-- //table list -->
                                    <!-- Pagination -->
                                    <section id="pagingc" class="pagination m-t-30">
                                        <jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
                                    </section>
                                    <!-- //Pagination -->
                                </li>
                                <!-- //예약승인대기(부대시설) -->
                                <!-- 예약반려/취소(부대시설) -->
                                <li id="reject" class="tabCot2">
                                    <!-- search_wrap -->
                                    <section class="search_wrap m-t-30">
                                        <div class="form_group w230">
                                            <input type="text" id="rejectDate"
                                                   class="form_control dateicon datefromto" placeholder="예약기간 선택"
                                                   name="dateto">
                                        </div>
                                        <div class="form_group w300">
                                            <input type="text" id="rejectKeyword" class="form_control"
                                                   placeholder="예약번호/사업자번호/회사명 입력" name="" />
                                        </div>
                                        <div class="form_group">
                                            <!-- <label for="se1">검색선택</label> -->
                                            <div class="select_group" id="select2">
                                            </div>
                                        </div>
                                        <button type="button" onclick="search(1, 'reject')" class="btn-s btn_default">조회</button>
                                        <button type="button" class="btn-s btn_default" onclick="reset()">검색초기화</button>
                                    </section>
                                    <!-- //search_wrap -->
                                    <!-- table list -->
                                    <section class="tbl_wrap_list m-t-15">
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
                                                    <button id="rejectOrder1" onclick="sort(1, 'reject')" class="btn_sort_down"></button>
                                                </th>
                                                <th scope="col">예약일자
                                                    <button id="rejectOrder2" onclick="sort(2, 'reject')" class="btn_sort_down"></button>
                                                </th>
                                                <th scope="col">회사명</th>
                                                <th scope="col">항목</th>
                                            </tr>
                                            </thead>
                                            <tbody id="rejectList">
                                            <tr onmouseover="this.className='on'"
                                                onmouseout="this.className=''" onclick="location.href='#';">
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
                                    <section id="pagingl" class="pagination m-t-30">
                                        <jsp:include page="/WEB-INF/views/jsp/common/paging2.jsp" />
                                    </section>
                                    <!-- //Pagination -->
                                </li>
                                <!-- //예약반려/취소(부대시설) -->
                            </ul>
                        </div>
                    </div>
                    <!-- //tab2 -->
                </div>
                <!-- //tab2-부대시설 -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>