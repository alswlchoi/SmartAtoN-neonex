<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
  $(document).ready(function () {
    var param = {};
    postAjax("/admin/shop/list", param, "showList", null, null, null);
  });
  //탭 이동
  function pageMove(str){
    if(str=='tab1'){
      location.href = '/admin/shop/track';
    }else if(str == 'tab2'){
      location.href = '/admin/shop/shop';
    }
  }

  var sIndex;
  function showList(list) {
    $("#shopList").html("");
    var shopHtml = "";
    if (list.shop.length > 0) {
      for (var i in list.shop) {
        var shop = list.shop[i];
        sIndex = shop.num;
        shopHtml += '<tr>';
        shopHtml += '<td>'+shop.num+'</td>';
        shopHtml += '<td>';
        shopHtml += '<div class="form_group w_full">';
        shopHtml += '<input type="hidden" id="shopCode'+i+'" value="'+shop.wsCode+'" />';
        shopHtml += '<input type="text" id="shopName'+i+'" class="form_control" maxlength="100" placeholder="" name="" value="'+shop.wsName+'" />';
        shopHtml += '</div>';
        shopHtml += '</td>';
        shopHtml += '<td>';
        shopHtml += '<div class="form_group">';
        shopHtml += '<div class="radio_inline">';
        shopHtml += '<label class="radio_default">';
        if (shop.wsUseYn == 'Y') {
          shopHtml += '<input type="radio" name="sRadio'+i+'" value="Y" checked="">';
          shopHtml += '<span class="radio_icon"></span>사용</label>';
          shopHtml += '<label class="radio_default">';
          shopHtml += '<input type="radio" name="sRadio'+i+'" value="N">';
          shopHtml += '<span class="radio_icon"></span>미사용</label>';
        } else {
          shopHtml += '<input type="radio" name="sRadio'+i+'" value="Y">';
          shopHtml += '<span class="radio_icon"></span>사용</label>';
          shopHtml += '<label class="radio_default">';
          shopHtml += '<input type="radio" name="sRadio'+i+'" value="N" checked="">';
          shopHtml += '<span class="radio_icon"></span>미사용</label>';
        }
        shopHtml += '</div>';
        shopHtml += '</div>';
        shopHtml += '</td>';
        shopHtml += '<td>';
        shopHtml += '<div class="form_group w_full">';
        shopHtml += '<input type="text" id="shopPrice'+i+'" class="form_control tar" maxlength="11" onkeypress="numberonly()" placeholder="" name="" value="'+comma(shop.wsPrice)+'" />';
        shopHtml += '</div>';
        shopHtml += '</td>';
        shopHtml += '<td>';
        shopHtml += '<button type="button" onclick="saveShop('+i+')" class="btn-line-s btn_default m-r-6">저장</button>';
        shopHtml += '<button type="button" onclick="delShop('+i+')" class="btn-line-s btn_gray">삭제</button>';
        shopHtml += '</td>';
        shopHtml += '</tr>';
      }
    } else {
      shopHtml += '<tr class="tr_nodata">';
      shopHtml += '<td colspan="5">등록된 정보가 없습니다.</td>';
      shopHtml += '</tr>';
    }
    $("#shopList").html(shopHtml);
  }

  function saveShop(i) {
    if ($("#shopName"+i).val() == '') {
      alert3("부대시설명을 입력해주세요.");
      return;
    }
    if ($("#shopPrice"+i).val() == '') {
      alert3("기본 1일 금액을 입력해주세요.");
      return;
    }
    var price = $("#shopPrice"+i).val().replace(/,/gi,"");

    var param = {
      wsCode: $("#shopCode"+i).val(),
      wsName: $("#shopName"+i).val(),
      wsUseYn: $('input[name="sRadio'+i+'"]:checked').val(),
      wsPrice: price
    };
    postAjax("/admin/shop/insertShop", param, "resultAlert", null, null, null)
  }

  function delShop(i) {
    confirm("부대시설을 삭제하시겠습니까?");
    $("#confirmTrue").click(function () {
      var param = {
        wsCode: $("#shopCode"+i).val()
      };
      postAjax("/admin/shop/deleteShop", param, "resultAlert", null, null, null)
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

  function addShop() {
    if($(".add").length!=0){
      return;
    }
    sIndex++;
    var shopId;
    if (sIndex < 10) {
      shopId = 'S00'+sIndex;
    } else if (sIndex < 100) {
      shopId = 'S0'+sIndex;
    } else {
      shopId = 'S'+sIndex;
    }
    var shopHtml = "";
    shopHtml += '<tr class="add">';
    shopHtml += '<td>'+sIndex+'</td>';
    shopHtml += '<td>';
    shopHtml += '<div class="form_group w_full">';
    shopHtml += '<input type="hidden" id="shopCode'+sIndex+'" value="'+shopId+'" />';
    shopHtml += '<input type="text" id="shopName'+sIndex+'" class="form_control" maxlength="100" placeholder="" name="" value="" />';
    shopHtml += '</div>';
    shopHtml += '</td>';
    shopHtml += '<td>';
    shopHtml += '<div class="form_group">';
    shopHtml += '<div class="radio_inline">';
    shopHtml += '<label class="radio_default">';
    shopHtml += '<input type="radio" name="sRadio'+sIndex+'" value="Y" checked="">';
    shopHtml += '<span class="radio_icon"></span>사용</label>';
    shopHtml += '<label class="radio_default">';
    shopHtml += '<input type="radio" name="sRadio'+sIndex+'" value="N">';
    shopHtml += '<span class="radio_icon"></span>미사용</label>';
    shopHtml += '</div>';
    shopHtml += '</div>';
    shopHtml += '</td>';
    shopHtml += '<td>';
    shopHtml += '<div class="form_group w_full">';
    shopHtml += '<input type="text" id="shopPrice'+sIndex+'" class="form_control tar" maxlength="11" onkeypress="numberonly();" placeholder="" name="" value="" />';
    shopHtml += '</div>';
    shopHtml += '</td>';
    shopHtml += '<td><button type="button" onclick="saveShop('+sIndex+')" class="btn-line-s btn_gray">저장</button></td>';
    shopHtml += '</tr>';

    $("#shopList").append(shopHtml);
  }
</script>

<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span
                class="breadcrumb_icon"></span><span>회원사/자원관리</span><span>자원관리</span><span>시설물 관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">시설물 관리</h2>
        <!-- //title -->

        <!-- tab -->
        <div class="wrap_tab">
            <div class="tab">
                <button class="tablinks" onclick="pageMove('tab1')">시험로 관리</button>
                <button class="tablinks active" onclick="pageMove('tab2')">부대시설 관리</button>
            </div>
            <div class="wrap_tabcontent">
                <!-- tab2-부대시설 관리 -->
                <div id="tab2" class="tabcontent">
                    <!-- table list -->
                    <section class="tbl_wrap_list">
                        <button type="button" onclick="addShop()" id="addShop" class="btn btn_default posi_right_0_2">등록</button>
                        <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="80px" />
                                <col width="" />
                                <col width="" />
                                <col width="" />
                                <col width="" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th rowspan="2" scope="col">번호</th>
                                <th rowspan="2" scope="col">부대시설명</th>
                                <th rowspan="2" scope="col">사용여부</th>
                                <th scope="col" class="border-b-1">수수료 (단위:원)</th>
                                <th rowspan="2" scope="col">비고</th>
                            </tr>
                            <tr>
                                <th scope="col" class="border-l-1">기본 1일</th>
                            </tr>
                            </thead>
                            <tbody id="shopList">
                            </tbody>
                        </table>
                    </section>
                    <!-- //table list -->
                    <!-- Pagination -->
                    <%--<section class="pagination m-t-30">
                        <a class="btn_prev off" href="#">
                            <i class="fas fa-angle-left"></i>
                        </a>
                        <span class='wrap'>
                                    <a href='#' class='on'>1</a>
                                    <a href="#">2</a>
                                    <a href="#">3</a>
                                    <span class="more"></span>
                                    <a href="#">999</a>
                                </span>
                        <a class="btn_next" href="#">
                            <i class="fas fa-angle-right"></i>
                        </a>
                    </section>--%>
                    <!-- //Pagination -->
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
                <!-- //tab2-부대시설 관리 -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>
