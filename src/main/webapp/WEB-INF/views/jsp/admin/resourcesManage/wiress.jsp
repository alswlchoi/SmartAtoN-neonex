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

    var wIndex;
    var maxName;
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
        lost:lost
      };
      postAjax("/admin/wiress/list",param,"showList",null,null,null);
    }

    function showList(list) {
      $("#wiressTable").html("");
      var wiressHtml = "";
      maxName = list.maxId;
      wIndex = list.wiress.length;
      var index = 1;
      if (list.wiress.length > 0) {
        for (var i in list.wiress) {
          var wiress = list.wiress[i];
          wiressHtml += '<tr>';
          wiressHtml += '<td>'+index+'</td>';
          wiressHtml += '<td id="wName'+i+'">'+wiress.wname+'</td>';
          wiressHtml += '<td id="wQrId'+i+'">'+wiress.wqrId+'</td>';
          wiressHtml += '<td id="wSerial'+i+'">'+wiress.wserial+'</td>';
          wiressHtml += '<td>';
          wiressHtml += '<div class="form_group">';
          wiressHtml += '<div class="select_group">';
          wiressHtml += '<select id="wStatus'+i+'" title="select" class="form_control">';
          if (wiress.wstatus == 'Y'){
            wiressHtml += '<option value="Y" selected>정상</option>';
            wiressHtml += '<option value="N">사용불가</option>';
            wiressHtml += '<option value="L">분실</option>';
          } else if (wiress.wstatus == 'N') {
            wiressHtml += '<option value="Y">정상</option>';
            wiressHtml += '<option value="N" selected>사용불가</option>';
            wiressHtml += '<option value="L">분실</option>';
          } else if (wiress.wstatus == 'L') {
            wiressHtml += '<option value="Y">정상</option>';
            wiressHtml += '<option value="N">사용불가</option>';
            wiressHtml += '<option value="L" selected>분실</option>';
          }
          wiressHtml += '</select>';
          wiressHtml += '</div>';
          wiressHtml += '</div>';
          wiressHtml += '</td>';
          wiressHtml += '<td>';
          wiressHtml += '<div class="form_group w_full">';
          if (wiress.wreason != null) {
            wiressHtml += '<input type="text" id="wReason'+i+'" class="form_control" placeholder="메모 입력" name="" value="'+wiress.wreason+'" />';
          } else {
            wiressHtml += '<input type="text" id="wReason'+i+'" class="form_control" placeholder="메모 입력" name="" value="" />';
          }
          wiressHtml += '</div>';
          wiressHtml += '</td>';
          wiressHtml += '<td><button type="button" onclick="upWiress('+i+')" class="btn-line-s btn_default m-r-6">저장</button>';
          wiressHtml += '<button type="button" onclick="delWiress('+i+')" class="btn-line-s btn_gray">삭제</button></td>';
          wiressHtml += '</tr>';
          index++;
        }
      } else {
        wiressHtml += '<tr class="tr_nodata">';
        wiressHtml += '<td colspan="6">등록된 정보가 없습니다.</td>';
        wiressHtml += '</tr>';
      }
      $("#wiressTable").html(wiressHtml);
      drawingPage(list.paging);
    }

    function chkWQr() {
      var param = {
        text: $("#newWQrId").val()
      }
      postAjax("/admin/wiress/chkWQr", param, "chkResult", null, null, null)
    }
    function chkResult(result) {
      if (result > 0) {
        alert("중복되는 QR이 존재합니다.");
      } else {
        saveWiress('new');
      }
    }

    function delWiress(i) {
      confirm("무전기를 삭제하시겠습니까?");
      $("#confirmTrue").click(function () {
        var param = {
          wid: $("#wName"+i).html()
        };
        postAjax("/admin/wiress/delete", param, "delAlert", null, null, null)
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

    function saveWiress() {
      if ($("#newWName").val() == '') {
        alert("관리코드를 입력해주세요.");
        return;
      }
      if ($("#newWQrId").val() == '') {
        alert("QR코드를 입력해주세요.");
        return;
      }
      if ($("#newWSerial").val() == '') {
        alert("제조사NO.를 입력해주세요.");
        return;
      }

      var param = {
        wid: $("#newWName").val(),
        wname: $("#newWName").val(),
        wqrId: $("#newWQrId").val(),
        wserial: $("#newWSerial").val(),
        wstatus: $("#newWStatus option:selected").val(),
        wuseYn: $("#newWStatus option:selected").val(),
        wreason: $("#newWReason").val()
      };

      postAjax("/admin/wiress/insert", param, "resultAlert", null, null, null)
    }

    function upWiress(i) {
      var param = {
        wid: $("#wName"+i).html(),
        wstatus: $("#wStatus"+i+" option:selected").val(),
        wuseYn: $("#wStatus"+i+" option:selected").val(),
        wreason: $("#wReason"+i).val()
      };

      postAjax("/admin/wiress/update", param, "resultAlert", null, null, null)
    }

    function resultAlert(result) {
      alert(result.alert);
      if (result.alert == "저장에 성공했습니다.") {
        $(".lyClose").click(function () {
          location.reload();
        })
      }
    }

    function addWiress() {
      if($(".add").length!=0){
        return;
      }
      var newName;
      var nameNum = Number(maxName.substring(2))+1;
      if (nameNum < 10) {
        newName = 'W00'+nameNum;
      } else if (nameNum < 100) {
        newName = 'W0'+nameNum;
      } else {
        newName = 'W'+nameNum;
      }
      maxName = newName;
      wIndex++;
      var wiressHtml = "";
      wiressHtml += '<tr class="add">';
      wiressHtml += '<td>'+wIndex+'</td>';
      wiressHtml += '<td>';
      wiressHtml += '<div class="form_group w_full">';
      wiressHtml += '<input type="text" id="newWName" class="form_control tac" readonly placeholder="" name="" value="'+newName+'" />';
      wiressHtml += '</div>';
      wiressHtml += '</td>';
      wiressHtml += '<td>';
      wiressHtml += '<div class="form_group w_full">';
      wiressHtml += '<input type="text" id="newWQrId" class="form_control tac" maxlength="100" placeholder="" name="" value="" />';
      wiressHtml += '</div>';
      wiressHtml += '</td>';
      wiressHtml += '<td>';
      wiressHtml += '<div class="form_group w_full">';
      wiressHtml += '<input type="text" id="newWSerial" class="form_control tac" maxlength="100" placeholder="" name="" value="" />';
      wiressHtml += '</div>';
      wiressHtml += '</td>';
      wiressHtml += '<td>';
      wiressHtml += '<div class="form_group">';
      wiressHtml += '<div class="select_group">';
      wiressHtml += '<select id="newWStatus" title="select" class="form_control">';
      wiressHtml += '<option value="Y">정상</option>';
      wiressHtml += '<option value="N">사용불가</option>';
      wiressHtml += '<option value="L">분실</option>';
      wiressHtml += '</select>';
      wiressHtml += '</div>';
      wiressHtml += '</div>';
      wiressHtml += '</td>';
      wiressHtml += '<td>';
      wiressHtml += '<div class="form_group w_full">';
      wiressHtml += '<input type="text" id="newWReason" class="form_control" maxlength="100" placeholder="메모 입력" name="" value="" />';
      wiressHtml += '</div>';
      wiressHtml += '</td>';
      wiressHtml += '<td><button type="button" onclick="saveWiress()" class="btn-line-s btn_default">저장</button></td>';
      wiressHtml += '</tr>';

      $("#wiressTable").prepend(wiressHtml);
    }
</script>

<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span
                class="breadcrumb_icon"></span><span>회원사/자원관리</span><span>자원관리</span><span>무전기 자산 등록</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">무전기 자산 등록</h2>
        <!-- //title -->
        <!-- search_wrap -->
        <section class="search_wrap">
            <div class="form_group m-r-10">
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
                <input type="text" id="searchInput" class="form_control" placeholder="관리코드/제조자No./불출코드 입력" name="" />
            </div>
            <button type="button" onclick="search()" class="btn-s btn_default">조회</button>
        </section>
        <!-- //search_wrap -->
        <!-- table list -->
        <section class="tbl_wrap_list m-t-30">
            <button type="button" onclick="addWiress()" class="btn btn_default posi_right_0_2">등록</button>
            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                <caption>테이블</caption>
                <colgroup>
                    <col width="80px" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="100px" />
                    <col width="400px" />
                    <col width="150px" />
                </colgroup>
                <thead>
                <tr>
                    <th scope="col">번호</th>
                    <th scope="col">관리코드</th>
                    <th scope="col">QR CODE</th>
                    <th scope="col">제조사 NO.</th>
                    <th scope="col">상태</th>
                    <th scope="col">메모</th>
                    <th scope="col">비고</th>
                </tr>
                </thead>
                <tbody id="wiressTable">
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
