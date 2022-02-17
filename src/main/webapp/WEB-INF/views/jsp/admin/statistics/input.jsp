<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){
	search(1);
	$("#allarea").hide();
	
	//페이징 조회 버튼
    $(document).on("click", ".pageNo", function() {
		search($(this).attr("data-page"));
	});
	
	//엑셀 다운로드
	$("#excelDown").off("click").on("click",function(){
		downloadExcel("area","test");
	})
    
	$("#allDown").off("click").on("click",function(){
		downloadExcel("allarea", "alltest");
	})
	
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
      var stDate = null,edDate = null,text=null;
      
        // 날짜
        if ($("#date1").val() != '') {
          var readyDate = $("#date1").val().split(' ~ ');
          stDate = moment(readyDate[0]).format('YYYYMMDD');
          edDate = moment(readyDate[1]).format('YYYYMMDD');
        }
      // keyword
      text = $("#searchKeyword").val();
      
      var param = {
        pageNo: page,
        text : $("#searchKeyword").val(),
        tcDay: stDate,
        tcDay2: edDate
      };
      postAjax("/admin/statistics/inout", param, "searchCallback", null, null, null);
    }

//조회 콜백
function searchCallback(data){
	console.log(data);
	var list = data.list;
	var alllist = data.alllist;
	
	$("#allstatshop").html("");
	var html = "";
	var index = 1;
	$.each(alllist, function(i,el){
		var alllist = el;
		
		html += '<tr>';
		
		html += '<td>'; //번호
		html += index;
		html += '</td>';
		
		html += '<td>'+moment(alllist.tcDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';  //시험일자

		html += '<td>'; //기업명
		html += alllist.compName;
		html += '</td>';
		
		html += '<td>'; //입차시간
		html += changeDateFormat(alllist.inTime);
		html += '</td>';
		
		html += '<td>';//출차시간
		if(alllist.outTime == null ){
			html += "";
		}else{
			html += changeDateFormat(alllist.outTime);
		}
		html += '</td>';
		
		html += '<td>';//사용시간
		html += alllist.diffTime;
		html += '</td>';
		
		html += '<td>';//차량TAG
		html += alllist.carTagId;
		html += '</td>';
		
		html += '<td>';//시험로
		html += alllist.tname;
		html += '</td>';
		
		html += '<td>';//차량번호
		if(alllist.cnumber == null ){
			html += "";
		}else{
			html += alllist.cnumber;
		}
		html += '</td>';
		
		html += '</tr>';
		
		index++
	})
	$("#allstatshop").html(html);
	
	
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
			
			html += '<td>'+moment(code.tcDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';  //시험일자

			html += '<td>'; //기업명
			html += code.compName;
			html += '</td>';
			
			html += '<td>'; //입차시간
			html += changeDateFormat(code.inTime);
			html += '</td>';
			
			html += '<td>';//출차시간
			if(code.outTime == null ){
				html += "";
			}else{
				html += changeDateFormat(code.outTime);
			}
			html += '</td>';
			
			html += '<td>';//사용시간
			html += code.diffTime;
			html += '</td>';
			
			html += '<td>';//차량TAG
			html += code.carTagId;
			html += '</td>';
			
			html += '<td>';//시험로
			html += code.tname;
			html += '</td>';
			
			html += '<td>';//차량번호
			if(code.cnumber == null ){
				html += "";
			}else{
				html += code.cnumber;
			}
			html += '</td>';
			
			html += '</tr>';
			
			index++
		})
	}
	$("#statshop").html(html);
	drawingPage(data.paging);
}


function resetbtn(){
	$("#date1").val("");
	$("#searchKeyword").val("");
}

//엑셀다운로드
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
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>통계</span><span>일자별 입출로그</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">일자별 입출로그</h2>
        <!-- //title -->

        <!-- tab -->
        <div class="wrap_tab">
            <div class="wrap_tabcontent">
                <!-- tab2-부대시설 -->
                <div id="tab2" class="tabcontent">
                    <!-- search_wrap -->
                    <section class="search_wrap">
                        <div class="form_group w230">
                            <input type="text" autocomplete='off' id="date1" class="form_control dateicon datefromto"
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
                                <col width="40px" />
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                                <col width="60px" />
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">시험일자</th>
                                    <th scope="col">기업명</th>
                                    <th scope="col">입차시간</th>
                                    <th scope="col">출차시간</th>
                                    <th scope="col">사용시간(분)</th>
                                    <th scope="col">차량TAG</th>
                                    <th scope="col">시험로</th>
                                    <th scope="col">차량번호</th>
                                </tr>
                            </thead>
                            <tbody id="statshop">
                                <tr>
                                    <td>10</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td>워크샵A동</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
                                </tr>
                                <tr>
                                    <td>10</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td>워크샵A동</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
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
                                <col width="80px" />
                                <col width="80px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">시험일자</th>
                                    <th scope="col">기업명</th>
                                    <th scope="col">입차시간</th>
                                    <th scope="col">출차시간</th>
                                    <th scope="col">사용시간(분)</th>
                                    <th scope="col">차량TAG</th>
                                    <th scope="col">시험로</th>
                                    <th scope="col">차량번호</th>
                                </tr>
                            </thead>
                            <tbody id="allstatshop">
                                <tr>
                                    <td>10</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td>워크샵A동</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
                                </tr>
                                <tr>
                                    <td>10</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td>워크샵A동</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
                                    <td class="tar">234,000</td>
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