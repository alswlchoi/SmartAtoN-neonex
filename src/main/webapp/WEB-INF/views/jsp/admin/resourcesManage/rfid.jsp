<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
  $(document).ready(function () {
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
    $("#searchInput").focus(function() {
      $(this).keydown(function(k) {
        if (k.keyCode == 13) {
          search(1);
        }
      });
    });
  });

  var rIndex;
  var maxId;
  function search(page) {
    var yes = "";
    var no = "";
    var lost = "";

    $("input:checkbox[name='checkbox']").each(function(){
      if($(this).is(":checked") == true) {
        if ($(this).val() == 'Y') {
          yes = "Y";
        } else if ($(this).val() == 'N') {
          no = "N";
        } else if ($(this).val() == 'L') {
          lost = "L";
        }
      }
    });

    var param = {
      pageNo: page,
      text: $("#searchInput").val(),
      yes:yes,
      no:no,
      lost:lost,
      inOut:$("#inOut option:selected").val()
    };
    postAjax("/admin/rfid/list",param,"showList",null,null,null);
  }

  function showList(list) {
    $("#rfidTable").html("");
    var rfidHtml = "";
    rIndex = list.rfid.length;
    maxId = list.maxId;
    if (list.rfid.length > 0){
      for (var i in list.rfid) {
        var rfid = list.rfid[i];
        rfidHtml += '<tr>';
        rfidHtml += '<td>'+rfid.num+'</td>';
        rfidHtml += '<td><input type="hidden" id="rId'+i+'" value="'+rfid.rid+'">'+rfid.rid+'</td>';
        rfidHtml += '<td><input type="hidden" id="rQrId'+i+'" value="'+rfid.rqrId+'">'+rfid.rqrId+'</td>';
        rfidHtml += '<td><input type="hidden" id="rSerial'+i+'" value="'+rfid.rserial+'">'+rfid.rserial+'</td>';
        rfidHtml += '<td><input type="hidden" id="rTagId'+i+'" value="'+rfid.rtagId+'">'+rfid.rtagId+'</td>';
        rfidHtml += '<td>';
        rfidHtml += '<div class="form_group">';
        rfidHtml += '<div class="select_group">';
        rfidHtml += '<select id="rStatus'+i+'" title="select" class="form_control">';
        if (rfid.rstatus == 'Y'){
          rfidHtml += '<option value="Y" selected>정상</option>';
          rfidHtml += '<option value="N">사용불가</option>';
          rfidHtml += '<option value="L">분실</option>';
        } else if (rfid.rstatus == 'N') {
          rfidHtml += '<option value="Y">정상</option>';
          rfidHtml += '<option value="N" selected>사용불가</option>';
          rfidHtml += '<option value="L">분실</option>';
        } else if (rfid.rstatus == 'L') {
          rfidHtml += '<option value="Y">정상</option>';
          rfidHtml += '<option value="N">사용불가</option>';
          rfidHtml += '<option value="L" selected>분실</option>';
        }
        rfidHtml += '</select>';
        rfidHtml += '</div>';
        rfidHtml += '</div>';
        rfidHtml += '</td>';
        rfidHtml += '<td>';
        rfidHtml += '<div class="form_group w_full">';
        if (rfid.rreason != null) {
          rfidHtml += '<input type="text" id="rReason'+i+'" class="form_control" placeholder="메모 입력" name="" value="'+rfid.rreason+'" />';
        } else {
          rfidHtml += '<input type="text" id="rReason'+i+'" class="form_control" placeholder="메모 입력" name="" value="" />';
        }
        rfidHtml += '</div>';
        rfidHtml += '</td>';
        rfidHtml += '<td>';
        rfidHtml += '<button type="button" onclick="upRfid('+i+')" class="btn-line-s btn_default m-r-6">저장</button>';
        rfidHtml += '<button type="button" onclick="delRfid('+i+')" class="btn-line-s btn_gray">삭제</button>';
        rfidHtml += '</td>';
        rfidHtml += '</tr>';
      }
    } else {
      rfidHtml += '<tr class="tr_nodata">';
      rfidHtml += '<td colspan="9">등록된 정보가 없습니다.</td>';
      rfidHtml += '</tr>';
    }
    $("#rfidTable").html(rfidHtml);
    drawingPage(list.paging);
  }

  function saveRfid(i) {
    if ($("#rId"+i).val() == '') {
      alert("관리코드를 입력해주세요.");
      return;
    }
    if ($("#rQrId"+i).val() == '') {
      alert("QR코드를 입력해주세요.");
      return;
    }
    if ($("#rSerial"+i).val() == '') {
      alert("제조사NO.를 입력해주세요.");
      return;
    }
    if ($("#rTagId"+i).val() == '') {
      alert("태그아이디를 입력해주세요.");
      return;
    }

    var param = {
      rid: $("#rId"+i).val(),
      rserial: $("#rSerial"+i).val(),
      rname: $("#rId"+i).val(),
      rstatus: $("#rStatus"+i+" option:selected").val(),
      rqrId: $("#rQrId"+i).val(),
      rtagId: $("#rTagId"+i).val(),
      ruseYn: $("#rStatus"+i+" option:selected").val(),
      rdenied: 'N',
      routCode: $("#rReason"+i).val(),
      rreason: $("#rReason"+i).val()
    };

    postAjax("/admin/rfid/insert", param, "resultAlert", null, null, null)
  }

  function upRfid(i) {
    var param = {
      rid: $("#rId"+i).val(),
      rstatus: $("#rStatus"+i+" option:selected").val(),
      ruseYn: $("#rStatus"+i+" option:selected").val(),
      rreason: $("#rReason"+i).val()
    };

    postAjax("/admin/rfid/update", param, "resultAlert", null, null, null)
  }

  function resultAlert(result) {
    alert(result.alert);
    if (result.alert == "저장에 성공했습니다.") {
      $(".lyClose").click(function () {
        location.reload();
      })
    }
  }

  function delRfid(i) {
    confirm("RFID를 삭제하시겠습니까?");
    $("#confirmTrue").click(function () {
      var param = {
        rid: $("#rId"+i).val()
      };
      postAjax("/admin/rfid/delete", param, "delAlert", null, null, null)
    })
  }
  function delAlert(result) {
    if (result != 0) {
      alert("삭제가 완료되었습니다.");
      $(".lyClose").click(function() {
        location.reload();
      })
    } else {
      alert("삭제에 실패하였습니다.");
    }
  }

  function addRfid() {
    if($(".add").length!=0){
      return;
    }
    var newId;
    if (maxId == null) {
      newId = 'R001';
    } else {
      var idNum = Number(maxId.substring(1))+1;
      if (idNum < 10) {
        newId = 'R00'+idNum;
      } else if (idNum < 100) {
        newId = 'R0'+idNum;
      } else {
        newId = 'R'+idNum;
      }
    }
    maxId = newId;
    rIndex++;
    var rfidHtml = "";
    rfidHtml += '<tr class="add">';
    rfidHtml += '<td>'+rIndex+'</td>';
    rfidHtml += '<td><input type="text" readonly id="rId'+rIndex+'" class="form_control tac" placeholder="" name="" value="'+newId+'" /></td>';
    rfidHtml += '<td><input type="text" maxlength="20" id="rQrId'+rIndex+'" class="form_control" placeholder="" name="" value="" /></td>';
    rfidHtml += '<td><input type="text" maxlength="100" id="rSerial'+rIndex+'" class="form_control" placeholder="" name="" value="" /></td>';
    rfidHtml += '<td><input type="text" maxlength="20" id="rTagId'+rIndex+'" class="form_control" placeholder="" name="" value="" /></td>';
    rfidHtml += '<td>';
    rfidHtml += '<div class="form_group">';
    rfidHtml += '<div class="select_group">';
    rfidHtml += '<select id="rStatus'+rIndex+'" title="select" class="form_control">';
    rfidHtml += '<option value="Y">정상</option>';
    rfidHtml += '<option value="N">사용불가</option>';
    rfidHtml += '<option value="L">분실</option>';
    rfidHtml += '</select>';
    rfidHtml += '</div>';
    rfidHtml += '</div>';
    rfidHtml += '</td>';
    rfidHtml += '<td>';
    rfidHtml += '<div class="form_group w_full">';
    rfidHtml += '<input type="text" id="rReason'+rIndex+'" class="form_control" placeholder="메모 입력" maxlength="200" name="" value="" />';
    rfidHtml += '</div>';
    rfidHtml += '</td>';
    rfidHtml += '<td>';
    rfidHtml += '<button type="button" onclick="saveRfid('+rIndex+')" class="btn-line-s btn_default">저장</button>';
    rfidHtml += '</td>';
    rfidHtml += '</tr>';

    $("#rfidTable").prepend(rfidHtml);
  }
</script>

<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span
                class="breadcrumb_icon"></span><span>회원사/자원관리</span><span>자원관리</span><span>RFID 자산 등록</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">RFID 자산 등록</h2>
        <!-- //title -->
        <!-- search_wrap -->
        <section class="search_wrap">
            <div class="form_group m-r-6">
                <div class="check_inline">
                    <span class="label">상태</span>
                    <label class="check_default">
                        <input type="checkbox" name="checkbox" value="Y">
                        <span class="check_icon"></span>정상</label>
                    <label class="check_default">
                        <input type="checkbox" name="checkbox" value="N">
                        <span class="check_icon"></span>사용불가</label>
                    <label class="check_default">
                        <input type="checkbox" name="checkbox" value="L">
                        <span class="check_icon"></span>분실</label>
                </div>
            </div>
            <div class="form_group w300">
                <input type="text" id="searchInput" class="form_control" placeholder="관리코드/QR Code 입력" name="" />
            </div>
            <button type="button" onclick="search(1)" class="btn-s btn_default">조회</button>
        </section>
        <!-- //search_wrap -->
        <!-- table list -->
        <section class="tbl_wrap_list m-t-30">
            <button type="button" onclick="addRfid()" class="btn btn_default posi_right_0_2">등록</button>
            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                <caption>테이블</caption>
                <colgroup>
                    <col width="80px" />
                    <col width="250px" />
                    <col width="250px" />
                    <col width="250px" />
                    <col width="250px" />
                    <col width="170px" />
                    <col width="300px" />
                    <col width="150px" />
                </colgroup>
                <thead>
                <tr>
                    <th scope="col">번호</th>
                    <th scope="col">관리코드</th>
                    <th scope="col">QR Code</th>
                    <th scope="col">제조사 NO. (S/N)</th>
                    <th scope="col">RF (Tag ID)</th>
                    <th scope="col">상태</th>
                    <th scope="col">메모</th>
                    <th scope="col">비고</th>
                </tr>
                </thead>
                <tbody id="rfidTable">
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

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>
