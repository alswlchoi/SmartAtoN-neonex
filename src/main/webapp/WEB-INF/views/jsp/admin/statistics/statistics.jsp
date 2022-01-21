<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){
	Temperature(1);
	pressure(1);
	
	$("#pressure").hide();
	$("#allpressure").hide();
	$("#alltemper").hide();
	$(".w2").hide();
	
	 
// 	$("#data_area").attr('style', "display:block");
	
	//엑셀(기온,강수량)
	$("#temperDown").off("click").on("click",function(){
		downloadExcel("temperer","tempers");
	})
	
	//엑셀(기온,강수량) 전체
	$("#alltempers").off("click").on("click",function(){
		downloadExcel("alltemper","alltempers");
	})
	
	//엑셀(습도,기압)
	$("#pressDown").off("click").on("click",function(){
		downloadExcel("pressurer","pressures");
	})
	
	//엑셀(습도,기압) 전체
	$("#allpresss").off("click").on("click",function(){
		downloadExcel("allpressure","allpressures");
	})
	
	//페이징 조회 버튼
    $(document).on("click", "#pagingc>span>.pageNo", function() {
    	Temperature($(this).attr("data-page"));
		});
	
	//페이징 조회 버튼
    $(document).on("click", "#pagingl>span>.pageNo", function() {
			pressure($(this).attr("data-page"));
		});
	
      
      $('input[type="checkbox"][name="check"]').click(function(){
  		if($(this).prop('checked')){
  			$('input[type="checkbox"][name="check"]').prop('checked',false);
  			 
  		     $(this).prop('checked',true);
  		}
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

$(function(){
	$("#date2").daterangepicker({
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
function Temperature(page) {
    var stDate = null,edDate = null;
    
    if ($("#date1").val() != '') {
        var readyDate = $("#date1").val().split(' ~ ');
        stDate = moment(readyDate[0]).format('YYYYMMDD');
        edDate = moment(readyDate[1]).format('YYYYMMDD');
      }
 

	var param = {
			pageNo: page,
			tcDay: stDate,
			tcDay2: edDate,	  
	}
	postAjax("/admin/statistics/search",param,"searchCallback",null,null,null);
}



//콜백조회
function searchCallback(data){
	var temper = data.temper;
	var alltemper = data.alltemper;
		
	var alltemphtml = "";
	var index = 1;
	$.each(alltemper,function(i, el){
		var alltemper = el;
		
			alltemphtml += '<tr>'
			
			alltemphtml += '<td>';
			alltemphtml += index; 
			alltemphtml += '</td>';
			
			alltemphtml += '<td>'+moment(alltemper.day, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>'; //이용일자
			
			alltemphtml += '<td>';
			alltemphtml += alltemper.avgTa;
			alltemphtml += '</td>';
			
			alltemphtml += '<td>';
			alltemphtml += alltemper.minTa;
			alltemphtml += '</td>';
			
			alltemphtml += '<td>';
			alltemphtml += alltemper.maxTa;
			alltemphtml += '</td>';
			
			alltemphtml += '<td>';
			alltemphtml += alltemper.rainDay;
			alltemphtml += '</td>';
			
			alltemphtml += '<td>';
			alltemphtml += alltemper.dp;
			alltemphtml += '</td>';
			
			alltemphtml += '</tr>';

			
			index++
	})
	$("#alltemperlist").html(alltemphtml);	
	
	
	
		var tempHtml = "";
	
	if(temper.length == 0){
		tempHtml += '<tr class="tr_nodata"><td colspan="7">데이터가 존재하지 않습니다.</td></tr>';
	}else{
		$("#temperlist").html("");
		var index = 1;
		$.each(temper, function(i,el){
			var temper = el;
			
			tempHtml += '<tr>';
			
			tempHtml += '<td>';
			tempHtml += index; 
			tempHtml += '</td>';
			
			tempHtml += '<td>'+moment(temper.day, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>'; //이용일자
			
			tempHtml += '<td>';
			tempHtml += temper.avgTa;
			tempHtml += '</td>';
			
			tempHtml += '<td>';
			tempHtml += temper.minTa;
			tempHtml += '</td>';
			
			tempHtml += '<td>';
			tempHtml += temper.maxTa;
			tempHtml += '</td>';
			
			tempHtml += '<td>';
			tempHtml += temper.rainDay;
			tempHtml += '</td>';
			
			tempHtml += '<td>';
			tempHtml += temper.dp;
			tempHtml += '</td>';
			
			tempHtml += '</tr>';

			index++
		})
	}
	$("#temperlist").html(tempHtml);
	drawingPage(data.paging);
	
}

//습도 기압
function pressure(page) {
    var stDate = null,edDate = null;
    
    if ($("#date1").val() != '') {
        var readyDate = $("#date1").val().split(' ~ ');
        stDate = moment(readyDate[0]).format('YYYYMMDD');
        edDate = moment(readyDate[1]).format('YYYYMMDD');
      }
 

	var param = {
			pageNo: page,
			tcDay: stDate,
			tcDay2: edDate,	  
	}
	postAjax("/admin/statistics/pressure",param,"Callback",null,null,null);
}

function Callback(data){
	var pressure = data.pressure
	var allpressure = data.allpressure
	
	var allpressurehtml = "";
	var index = 1;
	$.each(allpressure,function(i, el){
		var allpressure = el;
		
			allpressurehtml += '<tr>';
			
			allpressurehtml += '<td>';
			allpressurehtml += index; 
			allpressurehtml += '</td>';
			
			allpressurehtml += '<td>'+moment(allpressure.day, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>'; //이용일자
			
			allpressurehtml += '<td>';
			allpressurehtml += allpressure.avgRh; //평균습도
			allpressurehtml += '</td>';
			
			allpressurehtml += '<td>';
			allpressurehtml += allpressure.avgWs;
			allpressurehtml += '</td>';
			
			allpressurehtml += '<td>';
			allpressurehtml += allpressure.avgPa;
			allpressurehtml += '</td>';
			
			allpressurehtml += '<td>';
			allpressurehtml += allpressure.maxPa;
			allpressurehtml += '</td>';
			
			allpressurehtml += '<td>';
			allpressurehtml += allpressure.minPa;
			allpressurehtml += '</td>';
			
			allpressurehtml += '</tr>';

			
			index++
	})
	$("#allpressurelist").html(allpressurehtml);	
	
	
	
	
	var preHtml="";
	$("#pressurelist").html("");
	
	if(pressure.length == 0){
		preHtml += '<tr class="tr_nodata"><td colspan="7">데이터가 존재하지 않습니다.</td></tr>';
	}else{
		var index = 1;
		$.each(pressure, function(i,el){
			var pressure = el;
			
			preHtml += '<tr>';
			
			preHtml += '<td>';
			preHtml += index; 
			preHtml += '</td>';
			
			preHtml += '<td>'+moment(pressure.day, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>'; //이용일자
			
			preHtml += '<td>';
			preHtml += pressure.avgRh; //평균습도
			preHtml += '</td>';
			
			preHtml += '<td>';
			preHtml += pressure.avgWs;
			preHtml += '</td>';
			
			preHtml += '<td>';
			preHtml += pressure.avgPa;
			preHtml += '</td>';
			
			preHtml += '<td>';
			preHtml += pressure.maxPa;
			preHtml += '</td>';
			
			preHtml += '<td>';
			preHtml += pressure.minPa;
			preHtml += '</td>';
			
			preHtml += '</tr>';

			index++
		})
	}
	$("#pressurelist").html(preHtml);
	drawingPage2(data.paging);

}

//탭 이동
function pageMove(str){
	if(str=='tab1'){
		location.href = '/admin/statistics';
	}else if(str == 'tab2'){
		location.href = '/admin/statistics/temperature';
	}
}



//onchange 함수
function thechange(e){
	if(e.value == "a"){
		Temperature(1);
		$("#pagingc").show();
		$("#pressure").hide();
		$("#temper").show();
		$(".w230").show();
		$(".w2").hide();
	}else if(e.value == "b"){
		pressure(1);
		$("#pagingc").hide();
		$("#temper").hide();
		$("#pressure").show();
		$(".w230").hide();
		$(".w2").show();
	}
}

//리셋
function resetbtn(){
	$("#date1").val("");
	$("#date2").val("");
	Temperature(1);
	pressure(1);
}


//엑셀
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
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>통계</span><span>기상통계</span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">기상통계</h2>
                <!-- //title -->
				
			<div class="wrap_tab">
	             	<div class="tab">
		                <button class="tablinks active" onclick="pageMove('tab1')" id="defaultOpen">기상</button>
		                <button class="tablinks" onclick="pageMove('tab2')">노면온도</button>
	            	</div>
            <div class="wrap_tabcontent">
                <!-- search_wrap -->
                <section class="search_wrap">
                        <div class="form_group m-r-10">
                            <div class="check_inline">
                                <span class="label">구분</span>
                                <label class="check_default">
                                    <input type="checkbox" id="temp" onchange=thechange(this) checked="on" name="check" value="a">
                                    <span class="check_icon"></span>기온,강수량</label>
                                <label class="check_default">
                                    <input type="checkbox" id="press" onchange=thechange(this) name="check" value="b">
                                    <span class="check_icon"></span>습도,기압</label>
                            </div>
                        </div>
                        <div class="form_group w230">
                            <input type="text" autocomplete='off' id="date1" class="form_control dateicon datefromto"
                                placeholder="기간 선택" name="">
                        </div>
                        
                        <div class="form_group w230 w2">
                            <input type="text" autocomplete='off' id="date2" class="form_control dateicon datefromto"
                                placeholder="기간 선택" name="">
                        </div>
                        <button type="button" onclick="Temperature(1);	pressure(1); " class="btn-s btn_default">조회</button>
                        <button type="button" onclick="resetbtn()" class="btn-s btn_default">검색초기화</button>
                    </section>
                <!-- //search_wrap -->
                <!-- table list -->
                
                <!-- 전체다운로드 테이블  -->
                <div id = "alltemper">
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
						<th scope="col">일시</th>
						<th scope="col">평균기온(*C)</th>
						<th scope="col">최저기온(*C)</th>
						<th scope="col">최고기온(*C)</th>
						<th scope="col">일일 누적 강수량(mm)</th>
						<th scope="col">이슬점</th>
                    </tr>
                </thead>
                <tbody id="alltemperlist">
                    <tr>
                        <td>10</td>
						<td>2021.09.09</td>
						<td>2021.09.09</td>
						<td>2021.09.09</td>
						<td>상신브레이크</td>
						<td>워크샵A동</td>
						<td>234,000</td>
                    </tr>
                    <tr>
                        <td>10</td>
						<td>2021.09.09</td>
						<td>2021.09.09</td>
						<td>2021.09.09</td>
						<td>상신브레이크</td>
						<td>워크샵A동</td>
						<td>234,000</td>
                    </tr>
            </table>
        </section>
        </div>
				<!-- 조회된 다운로드 테이블  -->
                <div id="temper">
                <div id ="temperer">
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
                                    <th scope="col">일시</th>
                                    <th scope="col">평균기온(*C)</th>
                                    <th scope="col">최저기온(*C)</th>
                                    <th scope="col">최고기온(*C)</th>
                                    <th scope="col">일일 누적 강수량(mm)</th>
                                    <th scope="col">이슬점</th>
                                </tr>
                            </thead>
                            <tbody id="temperlist">
                                <tr>
                                    <td>10</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td>워크샵A동</td>
                                    <td>234,000</td>
                                </tr>
                                <tr>
                                    <td>10</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td>워크샵A동</td>
                                    <td>234,000</td>
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
                    	<button type="button" id="temperDown" class="btn btn_default">조회데이터다운로드</button>
                    	<button type="button" id="alltempers" class="btn btn_default">전체다운로드</button>
                      </div> 
                <!-- //Pagination -->  
                    
					<!-- 습도 기압 테이블 -->
                    <div id = "allpressure">
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
						<th scope="col">일시</th>
						<th scope="col">평균습도(%)</th>
						<th scope="col">평균풍속(m/s)</th>
						<th scope="col">평균기압(hPa)</th>
						<th scope="col">최고기압(hPa)</th>
						<th scope="col">최저기압(hPa)</th>
                    </tr>
                </thead>
                <tbody id="allpressurelist">
                    <tr>
                        <td>10</td>
						<td>2021.09.09</td>
						<td>2021.09.09</td>
						<td>2021.09.09</td>
						<td>상신브레이크</td>
						<td>워크샵A동</td>
						<td>234,000</td>
                    </tr>
                    <tr>
                        <td>10</td>
						<td>2021.09.09</td>
						<td>2021.09.09</td>
						<td>2021.09.09</td>
						<td>상신브레이크</td>
						<td>워크샵A동</td>
						<td>234,000</td>
                    </tr>
            </table>
        </section>
        </div>  
                      
                    <!-- 습도 기압 테이블 -->
                    <div id = "pressure">  
                    <div id="pressurer">
                    <section class="tbl_wrap_list m-t-30">
                    <table class="tbl_list ww" summary="테이블 입니다. 항목으로는 등이 있습니다">
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
                                    <th scope="col">일시</th>
                                    <th scope="col">평균습도(%)</th>
                                    <th scope="col">평균풍속(m/s)</th>
                                    <th scope="col">평균기압(hPa)</th>
                                    <th scope="col">최고기압(hPa)</th>
                                    <th scope="col">최저기압(hPa)</th>
                                </tr>
                            </thead>
                            <tbody id="pressurelist">
                                <tr>
                                    <td>10</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>2021.09.09</td>
                                    <td>상신브레이크</td>
                                    <td>워크샵A동</td>
                                    <td>234,000</td>
                                </tr>
                            </tbody>
                        </table>
                </section>
                </div>
                <!-- Pagination -->
                <section id="pagingl" class="pagination m-t-30">
            		<jsp:include page="/WEB-INF/views/jsp/common/paging2.jsp" />
                </section>
                    <button type="button" id="pressDown" class="btn btn_default">조회데이터다운로드</button>
                    <button type="button" id="allpresss" class="btn btn_default">전체다운로드</button>
                <!-- //Pagination -->
                </div>
                <!-- //table list -->
                </div>
        </div>
        <!-- //tab -->
            </div>
            <!-- //content -->
        </div>
        <!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>