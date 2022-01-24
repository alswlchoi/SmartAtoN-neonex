<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){
	search(1 , 'ready');
	//페이징 조회 버튼
    $(document).on("click", ".pageNo", function() {
			search($(this).attr("data-page"));
		});
	
	$("#allarea").hide();
	
	$("#excelDown").off("click").on("click", function(){
		downloadExcel("area","test");
	})
	
	$("#allDown").off("click").on("click", function(){
		downloadExcel("allarea","alltest");
	})
    
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
    
})

$(function(){
	$("#date1").daterangepicker({
	    locale: {
	    "separator": " ~ ",                     // 시작일시와 종료일시 구분자
	    "format": 'YYYY-MM-DD',     // 일시 노출 포맷
	    "applyLabel": "확인",                    // 확인 버튼 텍스트
	    "cancelLabel": "취소",                   // 취소 버튼 텍스트
	    "endDate": "",
	    "minDate": "moment()",
	    "daysOfWeek": ["일", "월", "화", "수", "목", "금", "토"],
	    "monthNames": ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
	    },
	    timePicker: false,                        // 시간 노출 여부
	    showDropdowns: true,                     // 년월 수동 설정 여부
	    autoApply: true,                         // 확인/취소 버튼 사용여부
	    timePicker24Hour: true,                  // 24시간 노출 여부(ex> true : 23:50, false : PM 11:50)
	    timePickerSeconds: true,                 // 초 노출 여부
	    singleDatePicker: false                   // 하나의 달력 사용 여부
	});
})

//조회
 function search(page, type) {
      var stDate = null,edDate = null;
      var text = null;
      
        // 날짜
        if ($("#date1").val() != '') {
          var readyDate = $("#date1").val().split(' ~ ');
          stDate = moment(readyDate[0]).format('YYYYMMDD');
          edDate = moment(readyDate[1]).format('YYYYMMDD');
        }
        
      var param = {
        pageNo: page,
        text : $("#searchKeyword").val(),
        wssStDay: stDate,
		wssEdDay: edDate
      };

      //console.log(param);
      postAjax("/admin/statistics/statshop", param, "searchCallback", null, null, null);
    }

//조회 콜백
function searchCallback(data){
	var list = data.list;
	var alllist = data.allist;
	console.log(list);
	
	$("#allshop").html("");
	var html = "";
	var index = 1;
	$.each(list,function(i, el){
		var alllist = el;
		
		html += '<tr>';
		
		html += '<td>'; //번호
		html += index;
		html += '</td>';
		
		html += '<td>'; //예약번호
		html += alllist.wssReservCode;
		html += '</td>';
		
		html += '<td>'+moment(alllist.wssStDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';  //접수일자
		
		html += '<td>'+moment(alllist.wssStDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';  //사용일자
		
		html += '<td>'; //기업명
		html += alllist.compName;
		html += '</td>';
		
		html += '<td>'; //예약동
		html += alllist.wsName;
		html += '</td>';
		
		html += '<td>';//정산금액
		if(alllist.ppay == null){
			html += 0;
		}else{
			html += alllist.ppay;
		}
		html += '</td>';		
		
		html += '</tr>';
		
		index++
		
	})
	
	$("#allshop").html(html);
	
	if(list.length == 0){
		html += '<tr class="tr_nodata"><td colspan="9">데이터가 존재하지 않습니다.</td></tr>';
	}else{
		$("#statshop").html("");
		var html = "";
		var index = 1;
		$.each(list,function(i, el){
			var code = el;
			
			html += '<tr>';
			
			html += '<td>'; //번호
			html += index;
			html += '</td>';
			
			html += '<td>'; //예약번호
			html += code.wssReservCode;
			html += '</td>';
			
			html += '<td>'+moment(code.wssRegDt, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';  //접수일자
			
			html += '<td>'+moment(code.wssStDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';  //사용일자
			
			html += '<td>'; //기업명
			html += code.compName;
			html += '</td>';
			
			html += '<td>'; //예약동
			html += code.wsName;
			html += '</td>';
			
			html += '<td>';//정산금액
			if(code.ppay == null){
				html += 0
			}else{
				html += code.ppay;
			}
			html += '</td>';		
			
			html += '</tr>';
			
			index++
			
		})
	}
	$("#statshop").html(html);
	drawingPage(data.paging);
}



//탭 이동
function pageMove(str){
	if(str=='tab1'){
		location.href = '/admin/statistics/stat-company';
	}else if(str == 'tab2'){
		location.href = '/admin/statistics/stat-shop';
	}
}



function resetbtn(){
	$("#date1").val("");
	$("#searchKeyword").val("");
}


//엑셀 다운로드
function downloadExcel(targetId, fileName) {
  var tab_text = '<html xmlns:x="urn:schemas-microsoft-com:office:excel">';
  tab_text = tab_text + '<head><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8">';
  tab_text = tab_text + '<xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>'
  tab_text = tab_text + '<x:Name>Test Sheet</x:Name>';
  tab_text = tab_text + '<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';
  tab_text = tab_text + '</x:ExcelWorksheets></x:ExcelWorkbook></xml></head><body>';
  tab_text = tab_text + "<table border='1px'>";
  var exportTable = $('#' + targetId).clone();
  exportTable.find('input').each(function (index, elem) { $(elem).remove(); });
  tab_text = tab_text + exportTable.html();
  tab_text = tab_text + '</table></body></html>';
  var data_type = 'data:application/vnd.ms-excel';
  var ua = window.navigator.userAgent;
  var msie = ua.indexOf("MSIE ");
  var fileName = fileName + '.xls';
  //Explorer 환경에서 다운로드
  if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
    if (window.navigator.msSaveBlob)
    {
      var blob = new Blob([tab_text], {
        type: "application/csv;charset=utf-8;"
      });
      navigator.msSaveBlob(blob, fileName);
    }
  } else {
    var blob2 = new Blob([tab_text], {
      type: "application/csv;charset=utf-8;"
    });
    var filename = fileName;
    var elem = window.document.createElement('a');
    elem.href = window.URL.createObjectURL(blob2);
    elem.download = filename;
    document.body.appendChild(elem);
    elem.click();
    document.body.removeChild(elem);
  }
}

</script>
<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>통계</span><span>회원사별 시험이력</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">회원사별 시험이력</h2>
        <!-- //title -->

        <!-- tab -->
        <div class="wrap_tab">
            <div class="tab">
                <button class="tablinks" onclick="pageMove('tab1')" >시험로</button>
                <button class="tablinks active" onclick="pageMove('tab2')" id="defaultOpen">부대시설</button>
            </div>
            <div class="wrap_tabcontent">
                <!-- tab2-부대시설 -->
                <div id="tab2" class="tabcontent">
                    <!-- search_wrap -->
                    <section class="search_wrap">
                        <div class="form_group w230">
                            <input type="text" autocomplete='off'  id="date1" class="form_control dateicon datefromto"
                                placeholder="기간 선택" name="">
                        </div>
                        <div class="form_group w300">
                            <input type="text" autocomplete='off' id="searchKeyword" class="form_control" placeholder="기업명 입력"
                                name="" />
                        </div>
                        <button type="button" onclick="search(1, 'ready')" class="btn-s btn_default">조회</button>
                        <button type="button" onclick="resetbtn()" class="btn-s btn_default">검색초기화</button>
                    </section>
                    <!-- //search_wrap -->
                    <!-- table list -->
                    <div id = "area">
                    <section class="tbl_wrap_list m-t-30">
                        <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">예약번호</th>
                                    <th scope="col">접수일자</th>
                                    <th scope="col">사용일자</th>
                                    <th scope="col">기업명</th>
                                    <th scope="col">예약동</th>
                                    <th scope="col">정산금액(원)</th>
                                </tr>
                            </thead>
                            <tbody id="statshop">
                                <tr>
                                    <td>10</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td>워크샵A동</td>
                                    <td class="tar">234,000</td>
                                </tr>
                                <tr>
                                    <td>10</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td>워크샵A동</td>
                                    <td class="tar">234,000</td>
                                </tr>
                                <!-- <tr class="tr_nodata">
    <td colspan="5">등록된 정보가 없습니다.</td>
</tr> -->
                            </tbody>
                        </table>
                    </section>
                    </div>
                    <!-- //table list -->
                    
                    <div id = "allarea">
                    <section class="tbl_wrap_list m-t-30">
                        <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">예약번호</th>
                                    <th scope="col">접수일자</th>
                                    <th scope="col">사용일자</th>
                                    <th scope="col">기업명</th>
                                    <th scope="col">예약동</th>
                                    <th scope="col">정산금액(원)</th>
                                </tr>
                            </thead>
                            <tbody id="allshop">
                                <tr>
                                    <td>10</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td>워크샵A동</td>
                                    <td class="tar">234,000</td>
                                </tr>
                                <tr>
                                    <td>10</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td>워크샵A동</td>
                                    <td class="tar">234,000</td>
                                </tr>
                                <!-- <tr class="tr_nodata">
    <td colspan="5">등록된 정보가 없습니다.</td>
</tr> -->
                            </tbody>
                        </table>
                    </section>
                    </div>
                    
                    <!-- Pagination -->
                    <section id="pagingc" class="pagination m-t-30">
                       	<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
                    </section>
                        <button type="button" id="excelDown" class="btn btn_default">조회데이터다운로드</button>
                        <button type="button" id="allDown" class="btn btn_default">전체다운로드</button>
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
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>