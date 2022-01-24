<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){
	search(1 , 'ready');
	$("#allarea").hide();
	
	//페이징 조회 버튼
    $(document).on("click", ".pageNo", function() {
			search($(this).attr("data-page"));
		});

    $("#excelDown").off("click").on("click", function () {
      downloadExcel("testArea", "test");
    })
    
    $("#allDown").off("click").on("click", function () {
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
    var stDate = null,edDate = null;
    var text = null, select = null, approval1 = null, approval2 = null;
    
    if ($("#date1").val() != '') {
        var readyDate = $("#date1").val().split(' ~ ');
        stDate = moment(readyDate[0]).format('YYYYMMDD');
        edDate = moment(readyDate[1]).format('YYYYMMDD');
      }
      // keyword
      text = $("#searchKeyword").val();
      //checkbox
      var Hint = null;
      
      $("input[name=cbox]:checked").each(function(){
    	 if($(this).is(":checked") == true){
    		 if($("input:checkbox[name=cbox]").length != 
    			 $("input:checkbox[name=cbox]:checked").length){
    			 Hint = $(this).val();
    		 }
    	 }
      })

	var param = {
			text : $("#searchKeyword").val(),
			pageNo : page,
			tcApproval : Hint,
			tcDay: stDate,
			tcDay2: edDate,	  
	}
	console.log(param);
	postAjax("/admin/statistics/statcompany",param,"searchCallback",null,null,null);
	
}

//조회콜백
function searchCallback(data){
	console.log(data);
	var list = data.list;
	var alllist = data.allList;
	
	$("#alllist").html("");
	var html = "";
	var index = 1;
	$.each(alllist,function(i,el){
		var alllist = el;
		
			html += '<tr>'
			
			html += '<td>';
			html += index; 
			html += '</td>';
			
			html += '<td>';
			html += alllist.tcReservCode;
			html += '</td>';
			
			html += '<td>'+moment(alllist.tcDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>'; //이용일자
			
			html += '<td>';
			html += alllist.compName;
			html += '</td>';
			
			html += '<td>';
			html += alllist.tname;
			html += '</td>';
			
			html += '<td>';
			html += alllist.puseTime;
			html += '</td>';
			
			html += '<td>';
			html += comma(alllist.ppay + alllist.price);
			html += '</td>';
			
			html += '</tr>';
			
			index++
		
	})
		$("#alllist").html(html);

	
	if(list.length == 0){
		html += '<tr class="tr_nodata"><td colspan="7">데이터가 존재하지 않습니다.</td></tr>';
	}else{
		$("#companylist").html("");
		var html = "";
		var index = 1;
		$.each(list,function(i,el){
			var list = el;
			
			html += '<tr>'
			
			html += '<td>';
			html += index; 
			html += '</td>';
			
			html += '<td>';
			html += list.tcReservCode;
			html += '</td>';
			
			html += '<td>'+moment(list.tcDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>'; //이용일자
			
			html += '<td>';
			if(list.compName == null){
				html += "";
			}else {
				html += list.compName;
			}
			html += '</td>';
			
			html += '<td>';
			html += list.trTrackName;
			html += '</td>';
			
			html += '<td>';
			if(list.applyTime == null){
				html += "-"
			}else{
				html += list.applyTime;
			}
			html += '</td>';
			
			html += '<td>';
			html += comma(list.pay );
			html += '</td>';
			
			html += '</tr>';
			
			index++
	
		})
	}
	
	$("#companylist").html(html);
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


//초기화
function resetbtn(){
	$("#date1").val("");
	$("#searchKeyword").val("");
	$("input[name=cbox]").prop('checked',false);
	
}

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
                <button class="tablinks active" onclick="pageMove('tab1')" id="defaultOpen">시험로</button>
                <button class="tablinks" onclick="pageMove('tab2')">부대시설</button>
            </div>
            <div class="wrap_tabcontent">
               
                    <!-- search_wrap -->
                    <section class="search_wrap">
<!--                         <div class="form_group m-r-10"> -->
<!--                             <div class="check_inline"> -->
<!--                                 <span class="label">회원구분</span> -->
<!--                                 <label class="check_default"> -->
<!--                                     <input type="checkbox" name="cbox" value="B"> -->
<!--                                     <span class="check_icon"></span>B2B회원</label> -->
<!--                                 <label class="check_default"> -->
<!--                                     <input type="checkbox" name="cbox" value="H"> -->
<!--                                     <span class="check_icon"></span>내부평가</label> -->
<!--                             </div> -->
<!--                         </div> -->
                        <div class="form_group w230">
                            <input type="text" id="date1" autocomplete='off' class="form_control dateicon datefromto"
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
                <div id="testArea">
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
                                    <th scope="col">시험일자</th>
                                    <th scope="col">기업명</th>
                                    <th scope="col">시험로</th>
                                    <th scope="col">사용시간(분)</th>
                                    <th scope="col">정산금액(원)</th>
                                </tr>
                            </thead>
                            <tbody id="companylist">
                                <tr>
                                    <td>10</td>
                                    <td>B2B회원</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td class="tal">고속주행로,범용로</td>
                                    <td>240</td>
                                    <td class="tar">234,000</td>
                                </tr>
                                <tr>
                                    <td>10</td>
                                    <td>B2B회원</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td class="tal">고속주행로,범용로</td>
                                    <td>240</td>
                                    <td class="tar">234,000</td>
                                </tr>
                                <tr>
                                    <td>10</td>
                                    <td>B2B회원</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td class="tal">고속주행로,범용로</td>
                                    <td>240</td>
                                    <td class="tar">234,000</td>
                                </tr>
                                <!-- <tr class="tr_nodata">
    <td colspan="7">등록된 정보가 없습니다.</td>
</tr> -->
                            </tbody>
                        </table>
                    </section>
                </div>
                <!-- 전체 페이지  -->
                <div id="allarea">
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
                                    <th scope="col">시험일자</th>
                                    <th scope="col">기업명</th>
                                    <th scope="col">시험로</th>
                                    <th scope="col">사용시간(분)</th>
                                    <th scope="col">정산금액(원)</th>
                                </tr>
                            </thead>
                            <tbody id="alllist">
                                <tr>
                                    <td>10</td>
                                    <td>B2B회원</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td class="tal">고속주행로,범용로</td>
                                    <td>240</td>
                                    <td class="tar">234,000</td>
                                </tr>
                                <tr>
                                    <td>10</td>
                                    <td>B2B회원</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td class="tal">고속주행로,범용로</td>
                                    <td>240</td>
                                    <td class="tar">234,000</td>
                                </tr>
                                <tr>
                                    <td>10</td>
                                    <td>B2B회원</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td class="tal">고속주행로,범용로</td>
                                    <td>240</td>
                                    <td class="tar">234,000</td>
                                </tr>
                                <!-- <tr class="tr_nodata">
    <td colspan="7">등록된 정보가 없습니다.</td>
</tr> -->
                            </tbody>
                        </table>
                    </section>
                
                </div>
                    <!-- //table list -->
                    <!-- Pagination -->
        			<section id="pagingc" class="pagination m-t-30">
            			<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
                    </section>
                        <button type="button" id="excelDown" class="btn btn_default">조회데이터다운로드</button>
                        <button type="button" id="allDown" class="btn btn_default">전체다운로드</button>
                    <!-- //Pagination -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>