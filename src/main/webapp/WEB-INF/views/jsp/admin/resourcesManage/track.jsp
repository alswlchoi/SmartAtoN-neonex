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

  var tIndex;
  var lev;
  function showList(list) {
    lev = list.level;
    $("#trackTable").html("");
    var trackHtml = "";
    if (list.track.length > 0) {
      for (var i in list.track) {
        var track = list.track[i];
        tIndex = track.num;
        trackHtml += '<tr>';
        trackHtml += '<td>'+track.num+'</td>';
        trackHtml += '<td>';
        trackHtml += '<div class="form_group w_full">';
        trackHtml += '<input type="hidden" id="trackId'+i+'" value="'+track.tid+'" />';
        trackHtml += '<input type="text" id="trackName'+i+'" class="form_control" placeholder="" name="" value="'+track.tname+'" />';
        trackHtml += '</div>';
        trackHtml += '</td>';
        trackHtml += '<td>';
        trackHtml += '<div class="form_group w_full">';
        trackHtml += '<input type="text" id="tNickName'+i+'" class="form_control tac" placeholder="" name="" value="'+track.tnickName+'" />';
        trackHtml += '</div>';
        trackHtml += '</td>';
        trackHtml += '<td>';
        trackHtml += '<div class="form_group">';
        trackHtml += '<div class="radio_inline">';
        trackHtml += '<label class="radio_default">';
        if (track.tuseYn == 'Y') {
          trackHtml += '<input type="radio" name="tRadio'+i+'" value="Y" checked="">';
          trackHtml += '<span class="radio_icon"></span>사용</label>';
          trackHtml += '<label class="radio_default">';
          trackHtml += '<input type="radio" name="tRadio'+i+'" value="E">';
          trackHtml += '<span class="radio_icon"></span>긴급</label>';
          trackHtml += '<label class="radio_default">';
          trackHtml += '<input type="radio" name="tRadio'+i+'" value="N">';
          trackHtml += '<span class="radio_icon"></span>폐쇄</label>';
        } else if (track.tuseYn == 'E'){
          trackHtml += '<input type="radio" name="tRadio'+i+'" value="Y">';
          trackHtml += '<span class="radio_icon"></span>사용</label>';
          trackHtml += '<label class="radio_default">';
          trackHtml += '<input type="radio" name="tRadio'+i+'" value="E" checked="">';
          trackHtml += '<span class="radio_icon"></span>긴급</label>';
          trackHtml += '<label class="radio_default">';
          trackHtml += '<input type="radio" name="tRadio'+i+'" value="N">';
          trackHtml += '<span class="radio_icon"></span>폐쇄</label>';
        } else {
          trackHtml += '<input type="radio" name="tRadio'+i+'" value="Y">';
          trackHtml += '<span class="radio_icon"></span>사용</label>';
          trackHtml += '<label class="radio_default">';
          trackHtml += '<input type="radio" name="tRadio'+i+'" value="E">';
          trackHtml += '<span class="radio_icon"></span>긴급</label>';
          trackHtml += '<label class="radio_default">';
          trackHtml += '<input type="radio" name="tRadio'+i+'" value="N" checked="">';
          trackHtml += '<span class="radio_icon"></span>폐쇄</label>';
        }
        trackHtml += '</div>';
        trackHtml += '</div>';
        trackHtml += '</td>';
        trackHtml += '<td>';
        trackHtml += '<div class="form_group">';
        trackHtml += '<div class="select_group">';
        trackHtml += '<select id="trackLevel'+i+'" title="select" class="form_control">';
        if (list.level.length > 0) {
          for (var j in list.level) {
            var level = list.level[j];
            if (level.cid != 'L000') {
              if (track.tlevel == level.cname) {
                trackHtml += '<option value="'+level.cname+'" selected>'+level.cname+'</option>';
              } else {
                trackHtml += '<option value="'+level.cname+'">'+level.cname+'</option>';
              }
            }
          }
        }
        trackHtml += '</select>';
        trackHtml += '</div>';
        trackHtml += '</div>';
        trackHtml += '</td>';
        trackHtml += '<td>';
        trackHtml += '<div class="form_group w_full">';
        trackHtml += '<input type="text" id="tMax'+i+'" class="form_control tac" placeholder="" name="" value="'+track.tmax+'" />';
        trackHtml += '</div>';
        trackHtml += '</td>';
        trackHtml += '<td>';
        trackHtml += '<div class="form_group w_full">';
        trackHtml += '<input type="text" id="tPrice'+i+'" class="form_control tar" placeholder="" name="" value="'+comma(track.tprice)+'" />';
        trackHtml += '</div>';
        trackHtml += '</td>';
        trackHtml += '<td>';
        trackHtml += '<div class="form_group w_full">';
        trackHtml += '<input type="text" id="tPriceAdd'+i+'" class="form_control tar" placeholder="" name="" value="'+comma(track.tpriceAdd)+'" />';
        trackHtml += '</div>';
        trackHtml += '</td>';
        trackHtml += '<td>';
        trackHtml += '<div class="form_group w_full">';
        trackHtml += '<input type="text" id="tSolo'+i+'" class="form_control tar" placeholder="" name="" value="'+comma(track.tsolo)+'" />';
        trackHtml += '</div>';
        trackHtml += '</td>';
        trackHtml += '<td>';
        trackHtml += '<button type="button" onclick="saveTrack('+i+')" class="btn-line-s btn_default m-r-6">저장</button>';
        trackHtml += '<button type="button" onclick="delTrack('+i+')" class="btn-line-s btn_gray">삭제</button>';
        trackHtml += '</td>';
        trackHtml += '</tr>';
      }
    } else {
      trackHtml += '<tr class="tr_nodata">';
      trackHtml += '<td colspan="10">등록된 정보가 없습니다.</td>';
      trackHtml += '</tr>';
    }

    $("#trackTable").html(trackHtml);
  }

  function saveTrack(i) {
    if ($("#trackName"+i).val() == '') {
      alert3("시험로명을 입력해주세요.");
      return;
    }
    if ($("#trackLevel"+i+" option:selected").val() == '') {
      alert3("운전자 레벨을 선택해주세요.");
      return;
    }
    if ($("#tMax"+i).val() == '') {
      alert3("예약CAPA를 입력해주세요.");
      return;
    }
    if ($("#tPrice"+i).val() == '') {
      alert3("공동 기본4시간 금액을 입력해주세요.");
      return;
    }
    if ($("#tPriceAdd"+i).val() == '') {
      alert3("공동 추가1시간 금액을 입력해주세요.");
      return;
    }
    if ($("#tSolo"+i).val() == '') {
      alert3("단독 1시간 금액을 입력해주세요.");
      return;
    }
    var tPrice = $("#tPrice"+i).val().replace(/,/gi,"");
    var tPriceAdd = $("#tPriceAdd"+i).val().replace(/,/gi,"");
    var tSolo = $("#tSolo"+i).val().replace(/,/gi,"");

    var param = {
      tid: $("#trackId"+i).val(),
      tname: $("#trackName"+i).val(),
      tnickName: $("#tNickName"+i).val(),
      tuseYn: $('input[name="tRadio'+i+'"]:checked').val(),
      tlevel: $("#trackLevel"+i+" option:selected").val(),
      tmax: $("#tMax"+i).val(),
      tprice: tPrice,
      tpriceAdd: tPriceAdd,
      tsolo: tSolo
    };
    postAjax("/admin/shop/insertTrack", param, "resultAlert", null, null, null)
  }

  function delTrack(i) {
    confirm("트랙을 삭제하시겠습니까?");
    $("#confirmTrue").click(function () {
      var param = {
        tid: $("#trackId"+i).val()
      };
      console.log(param);
      postAjax("/admin/shop/deleteTrack", param, "resultAlert", null, null, null)
    })
  }

  function resultAlert(result) {
    console.log(result);
    alert(result.alert);
    if (result.alert == "저장에 성공했습니다." || result.alert == "삭제에 성공했습니다.") {
      $(".lyClose").click(function () {
        location.reload();
      })
    }
  }

  function addTrack() {
    if($(".add").length!=0){
      return;
    }
    tIndex++;
    var trackId;
    if (tIndex < 100) {
      trackId = 'T0'+tIndex;
    } else {
      trackId = 'T'+tIndex;
    }
    var trackHtml = "";
    trackHtml += '<tr class="add">';
    trackHtml += '<td>'+tIndex+'</td>';
    trackHtml += '<td>';
    trackHtml += '<div class="form_group w_full">';
    trackHtml += '<input type="hidden" id="trackId'+tIndex+'" value="'+trackId+'" />';
    trackHtml += '<input type="text" id="trackName'+tIndex+'" class="form_control" maxlength="100" placeholder="" name="" value="" />';
    trackHtml += '</div>';
    trackHtml += '</td>';
    trackHtml += '<td>';
    trackHtml += '<div class="form_group w_full">';
    trackHtml += '<input type="text" id="tNickName'+tIndex+'" class="form_control tac" maxlength="20" placeholder="" name="" value="" />';
    trackHtml += '</div>';
    trackHtml += '</td>';
    trackHtml += '<td>';
    trackHtml += '<div class="form_group">';
    trackHtml += '<div class="radio_inline">';
    trackHtml += '<label class="radio_default">';
    trackHtml += '<input type="radio" name="tRadio'+tIndex+'" value="Y" checked="">';
    trackHtml += '<span class="radio_icon"></span>사용</label>';
    trackHtml += '<label class="radio_default">';
    trackHtml += '<input type="radio" name="tRadio'+tIndex+'" value="E">';
    trackHtml += '<span class="radio_icon"></span>긴급</label>';
    trackHtml += '<label class="radio_default">';
    trackHtml += '<input type="radio" name="tRadio'+tIndex+'" value="N">';
    trackHtml += '<span class="radio_icon"></span>폐쇄</label>';
    trackHtml += '</div>';
    trackHtml += '</div>';
    trackHtml += '</td>';
    trackHtml += '<td>';
    trackHtml += '<div class="form_group">';
    trackHtml += '<div class="select_group">';
    trackHtml += '<select id="trackLevel'+tIndex+'" title="select" class="form_control">';
    if (lev.length > 0) {
      trackHtml += '<option value="">선택</option>';
      for (var j in lev) {
        var level = lev[j];
        if (level.cid != 'L000') {
          trackHtml += '<option value="'+level.cname+'">'+level.cname+'</option>';
        }
      }
    }
    trackHtml += '</select>';
    trackHtml += '</div>';
    trackHtml += '</div>';
    trackHtml += '</td>';
    trackHtml += '<td>';
    trackHtml += '<div class="form_group w_full">';
    trackHtml += '<input type="text" id="tMax'+tIndex+'" class="form_control tac" maxlength="11" onkeypress="numberonly();" placeholder="" name="" value="" />';
    trackHtml += '</div>';
    trackHtml += '</td>';
    trackHtml += '<td>';
    trackHtml += '<div class="form_group w_full">';
    trackHtml += '<input type="text" id="tPrice'+tIndex+'" class="form_control tar" maxlength="11" onkeypress="numberonly();" placeholder="" name="" value="" />';
    trackHtml += '</div>';
    trackHtml += '</td>';
    trackHtml += '<td>';
    trackHtml += '<div class="form_group w_full">';
    trackHtml += '<input type="text" id="tPriceAdd'+tIndex+'" class="form_control tar" maxlength="11" onkeypress="numberonly();" placeholder="" name="" value="" />';
    trackHtml += '</div>';
    trackHtml += '</td>';
    trackHtml += '<td>';
    trackHtml += '<div class="form_group w_full">';
    trackHtml += '<input type="text" id="tSolo'+tIndex+'" class="form_control tar" maxlength="11" onkeypress="numberonly();" placeholder="" name="" value="" />';
    trackHtml += '</div>';
    trackHtml += '</td>';
    trackHtml += '<td><button type="button" onclick="saveTrack('+tIndex+')" class="btn-line-s btn_gray">저장</button></td>';
    trackHtml += '</tr>';

    $("#trackTable").append(trackHtml);
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
                <button class="tablinks active" onclick="pageMove('tab1')" id="defaultOpen">시험로 관리</button>
                <button class="tablinks" onclick="pageMove('tab2')">부대시설 관리</button>
            </div>
            <div class="wrap_tabcontent">
                <!-- tab1-시험로 관리 -->
                <div id="tab1" class="tabcontent">
                    <!-- table list -->
                    <section class="tbl_wrap_list">
                        <button type="button" id="addTrack" onclick="addTrack()" class="btn btn_default posi_right_0_2">등록</button>
                        <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="80px" />
                                <col width="400px" />
                                <col width="150px" />
                                <col width="190px" />
                                <col width="100px" />
                                <col width="" />
                                <col width="" />
                                <col width="" />
                                <col width="" />
                                <col width="150px" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th rowspan="2" scope="col">번호</th>
                                <th rowspan="2" scope="col">시험로</th>
                                <th rowspan="2" scope="col">약어</th>
                                <th rowspan="2" scope="col">사용여부</th>
                                <th rowspan="2" scope="col">운전자레벨<br />
                                    (이상)</th>
                                <th rowspan="2" scope="col">예약CAPA</th>
                                <th colspan="3" scope="col" class="border-b-1">수수료 (단위:원)</th>
                                <th rowspan="2" scope="col">비고</th>
                            </tr>
                            <tr>
                                <th scope="col" class="border-l-1">공동<br />
                                    기본4시간</th>
                                <th scope="col">공동<br />
                                    추가1시간</th>
                                <th scope="col">단독<br />
                                    1시간</th>
                            </tr>
                            </thead>
                            <tbody id="trackTable"> </tbody>
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
                <!-- //tab1-시험로 관리 -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>
