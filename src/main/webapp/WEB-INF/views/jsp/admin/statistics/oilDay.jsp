<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){
	search(1 , 'han');
	month(1);
	
	$("#all").hide();
	$("#allmonth").hide();
	$("#month").hide();
	$("#monthcnt").hide();
	$(".w2").hide();
	
	//엑셀(전체)
	$("#alldownload").off("click").on("click",function(){
		downloadExcel("allexcel","일별 액셀");
	})
	
	//엑셀(전체)month
	$("#monthdownload").off("click").on("click",function(){
		downloadExcel("allexcelmonth","월별 액셀");
	})
	
	//페이징 조회 버튼
    $(document).on("click", "#pagingc>span>.pageNo", function() {
    	search($(this).attr("data-page"));
		});
	
      $("input[name=dateto]").on('cancel.daterangepicker', function(ev, picker) {
        $(this).val('');
      });
      
      $('input[type="checkbox"][name="check"]').click(function(){
  		if($(this).prop('checked')){
  			$('input[type="checkbox"][name="check"]').prop('checked',false);
  			 
  		     $(this).prop('checked',true);
  		}
  	});
    
    //회사별
    var type = $("#hkt").val();
    console.log(type);
    if(type == 'handay'){
  		$("#hkt").removeClass('currentBtn2');
  		$("#hmg").attr('class', 'currentBtn2');
  		 search(1, 'handay');
  	}else if(type == ''){
  		$("#hkt").attr('currentBtn2');
  		$("#hmg").removeClass('class', 'currentBtn2');
  		 search(1, 'han');
  	}
  	  
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
	    startDate: moment().add(-7, 'day'),
	    endDate: moment().add('day'),
	    timePicker: false,                        // 시간 노출 여부
	    showDropdowns: true,                     // 년월 수동 설정 여부
	    autoApply: true,                         // 확인/취소 버튼 사용여부
	    timePicker24Hour: true,                  // 24시간 노출 여부(ex> true : 23:50, false : PM 11:50)
	    timePickerSeconds: true,                 // 초 노출 여부
	    singleDatePicker: false                   // 하나의 달력 사용 여부
	});
	
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
	    startDate: moment().add(-30, 'day'),
	    endDate: moment().add('day'),
	    timePicker: false,                        // 시간 노출 여부
	    showDropdowns: true,                     // 년월 수동 설정 여부
	    autoApply: true,                         // 확인/취소 버튼 사용여부
	    timePicker24Hour: true,                  // 24시간 노출 여부(ex> true : 23:50, false : PM 11:50)
	    timePickerSeconds: true,                 // 초 노출 여부
	    singleDatePicker: false                   // 하나의 달력 사용 여부
	});
})

//조회
function search(page , type) {
    var stDate = null,edDate = null;
    var approval = null;
    if(type == 'handay'){
	    if ($("#date1").val() != '') {
	        var readyDate = $("#date1").val().split(' ~ ');
	        stDate = moment(readyDate[0]).format('YYYYMMDD');
	        edDate = moment(readyDate[1]).format('YYYYMMDD');
	      }
	    approval = 'H';
    } else{
    	    if ($("#date1").val() != '') {
    	        var readyDate = $("#date1").val().split(' ~ ');
    	        stDate = moment(readyDate[0]).format('YYYYMMDD');
    	        edDate = moment(readyDate[1]).format('YYYYMMDD');
    	      }
    	approval = 'I';
    }

	var param = {
			approval: approval,
			pageNo: page,
			tcDay: stDate,
			tcDay2: edDate,	  
	}
	postAjax("/admin/statistics/oillist",param,"searchCallback",null,null,null);
}


//콜백조회
function searchCallback(data){
	var oillist = data.list;
	var alloillist = data.alllist;
	var gasoline = data.daygtotal;
	var diesel = data.daydtotal;
	
	var alloilhtml = "";
	var index = 1;
	$.each(alloillist,function(i, el){
		var alloil = el;
		
			alloilhtml += '<tr>'
			
			alloilhtml += '<td>'+moment(alloil.pumpEnd, "YYYYMMDDhh").format("YYYY.MM.DD")+'</td>'; //이용일자
			
			alloilhtml += '<td>';
			alloilhtml += alloil.gasoline;
			alloilhtml += '</td>';

			alloilhtml += '<td>';
			alloilhtml += alloil.diesel;
			alloilhtml += '</td>';
			
			alloilhtml += '</tr>';

			
			index++
	})
	$("#alloil").html(alloilhtml);	
	
	var totalhtml = "";
		totalhtml += '<tr>'
		
		totalhtml +='<td>'
		totalhtml += "일별 주유량 합계"
		totalhtml +='</td>'
		
		totalhtml +='<td>'
		if(gasoline == null){
			totalhtml += 0;
		}else {
			totalhtml += gasoline
		}
		totalhtml +='</td>'
		
		totalhtml +='<td>'
		if(diesel == null){
			totalhtml += 0;
		}else{
			totalhtml += diesel
		}
		totalhtml +='</td>'
				
		totalhtml += '</tr>'
		
	$("#total").html(totalhtml);	
		
	var oilhtml = "";
	$("#oillist").html("");
	if(oillist.length > 0){
		var index = 1;
		$.each(oillist, function(i,el){
			var oillist = el;
			
			oilhtml += '<tr>';
			
			oilhtml += '<td>'+moment(oillist.pumpEnd, "YYYYMMDD").format("YYYY.MM.DD")+'</td>'; //이용일자
			
			oilhtml += '<td>';
			oilhtml += oillist.gasoline;
			oilhtml += '</td>';

			oilhtml += '<td>';
			oilhtml += oillist.diesel;
			oilhtml += '</td>';
			
			oilhtml += '</tr>';

			index++
		})
	}else{
		oilhtml += '<tr class="tr_nodata"><td colspan="3">데이터가 존재하지 않습니다.</td></tr>';
	}
	$("#nowoill").html(oilhtml);
	drawingPage(data.paging);
	
}
//월별
function month(page) {
    var stDate = null,edDate = null;
    var date = new Date();
    var year = date.getFullYear();
    
    if ($("#date2").val() != '') {
        var readyDate = $("#date2").val().split(' ~ ');
        stDate = moment(readyDate[0]).format('YYYYMMDD');
        edDate = moment(readyDate[1]).format('YYYYMMDD');
      }
 	

	var param = {
			year: year,
			pageNo: page,
			tcDay: stDate,
			tcDay2: edDate,	  
	}
	postAjax("/admin/statistics/monthList",param,"monthCallback",null,null,null);
	
}
//월별
function monthCallback(data){
	var monthlist = data.list;
	var allmonthlist = data.alllist;
	var gasoline = data.monthgtotal;
	var diesel = data.monthdtotal;
	
	var allmonthhtml = "";
	var index = 1;
	$.each(allmonthlist,function(i, el){
		var allmonth = el;
		
			allmonthhtml += '<tr>'
			
			allmonthhtml += '<td>'
			allmonthhtml += moment(allmonth.pumpEnd, "YYYYMMDDhh").format("MM")+"월";
			allmonthhtml += '</td>'; //이용일자
			
			allmonthhtml += '<td>';
			allmonthhtml += allmonth.gasoline;
			allmonthhtml += '</td>';

			allmonthhtml += '<td>';
			allmonthhtml += allmonth.diesel;
			allmonthhtml += '</td>';
			
			allmonthhtml += '</tr>';

			
			index++
	})
	$("#allmonthl").html(allmonthhtml);	
	
	
	var monthtotalhtml = "";
		monthtotalhtml += '<tr>'
		
		monthtotalhtml += '<td>'
		monthtotalhtml += "월별 주유량 합계";
		monthtotalhtml += '</td>'
		
		monthtotalhtml += '<td>'
		if(gasoline == null){
			monthtotalhtml += 0;
		}else{
			monthtotalhtml += gasoline;
		}
		monthtotalhtml += '</td>'
				
		monthtotalhtml += '<td>'
		if(diesel == null){
			monthtotalhtml += 0;
		}else{
			monthtotalhtml += diesel;
		}
		monthtotalhtml += '</td>'
						
		monthtotalhtml += '<tr>'
	
	$("#monthtotal").html(monthtotalhtml);
	
	var monthlisthtml = "";
	console.log(monthlist.length);
	if(monthlist.length > 0){
		var index = 1;
		$.each(monthlist, function(i,el){
			var monthlist = el;
			
			monthlisthtml += '<tr>';
			
			monthlisthtml += '<td>'
			monthlisthtml += moment(monthlist.pumpEnd, "YYYYMMDD").format("MM")+"월";
			monthlisthtml += '</td>'; //이용일자
			
			monthlisthtml += '<td>';
			monthlisthtml += monthlist.gasoline;
			monthlisthtml += '</td>';

			monthlisthtml += '<td>';
			monthlisthtml += monthlist.diesel;
			monthlisthtml += '</td>';
			
			monthlisthtml += '</tr>';

			index++
		})
	}else{
		monthlisthtml += '<tr class="tr_nodata"><td colspan="3">데이터가 존재하지 않습니다.</td></tr>';
	}
	$("#monthlist").html(monthlisthtml);
	drawingPage(data.paging);
	
}


//탭 이동
function pageMove(str){
	if(str=='tab1'){
		location.href = '/admin/statistics/oil';
	}else if(str == 'tab2'){
		location.href = '/admin/statistics/carSection';
	}
}



 //onchange 함수
function thechange(e){
	if(e.value == "a"){
		search(1);
		$("#month").hide();
		$("#monthcnt").hide();
		$("#now").show();
		$("#daycnt").show();
		$(".w230").show();
		$(".w2").hide();
	}else if(e.value == "b"){
		month(1);
		$("#now").hide();
		$("#daycnt").hide();
		$("#month").show();
		$("#monthcnt").show();
		$(".w230").hide();
		$(".w2").show();
	}
}

//리셋
function resetbtn(){
	$("#date1").val("");
	$("#date2").val("");
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
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>통계</span><span>주유 통계</span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">주유 통계</h2>
                <!-- //title -->
				
			<div class="wrap_tab">
	             	<div class="tab">
		                <button class="tablinks active" onclick="pageMove('tab1')" id="defaultOpen">기간별</button>
		                <button class="tablinks" onclick="pageMove('tab2')">차량별</button>
	            	</div>
            <div class="webwidget_tab m-t-20">
            	 <div class="tabContainer2">
                     <ul class="tabHead2">
                         <li id="hkt" class="currentBtn2" value="0"><a href="javascript:search(1,'handay');">HKT</a></li> 
                         <li id="hmg" value="1"><a href="javascript:search(1,'han');">HMG</a></li>
                     </ul>
                 </div>
                <!-- search_wrap -->
                 <section class="search_wrap m-t-20">
                        <div class="form_group m-r-10">
                            <div class="check_inline">
                                <label class="check_default">
                                    <input type="checkbox" id="temp" onchange=thechange(this) checked="on" name="check" value="a">
                                    <span class="check_icon"></span>일별</label>
                                <label class="check_default">
                                    <input type="checkbox" id="press" onchange=thechange(this) name="check" value="b">
                                    <span class="check_icon"></span>월별</label>
                            </div>
                        </div>
                        <div class="form_group w230">
                            <input type="text" autocomplete='off' id="date1" class="form_control dateicon datefromto"
                                placeholder="기간 선택" name="dateto">
                        </div>
                        
                        <div class="form_group w230 w2">
                            <input type="text" autocomplete='off' id="date2" class="form_control dateicon datefromto"
                                placeholder="기간 선택" name="dateto">
                        </div>
                        
                        <button type="button" onclick="search(1); month(1); " class="btn-s btn_default">조회</button>
                        <button type="button" onclick="resetbtn()" class="btn-s btn_default">검색초기화</button>
                   </section>
                   <div id = "allexcel">
                   <div id = "daycnt">
                   <section class="tbl_wrap_list m-t-40">
                   <table class="tbl_list m-t-30" summary="합계 테이블">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col"></th>
                                    <th scope="col">휘발유</th>
                                    <th scope="col">경유</th>
                                </tr>
                            </thead>
                            <tbody id = "total">
                                <tr>
                                    <td>일별 주유량 합계</td>
                                    <td>10</td>
                                    <td>10</td>
                                </tr>
                            </tbody>
                        </table>
                        </section>
                        </div>
                <!-- //search_wrap -->
                <!-- table list -->
				<!-- 전체 테이블 보이기X -->
				<div id = "all">
                <section class="tbl_wrap_list m-t-40">
                    <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col" rowspan="2">주유일자</th>
                                    <th scope="col" colspan="2" class="border-b-1">주유량</th>
                                </tr>
                                <tr>
                                    <th scope="col" class="border-l-1">휘발유</th>
                                    <th scope="col">경유</th>
                                </tr>
                            </thead>
                            <tbody id="alloil">
                                <tr>
                                    <td>2021.01.07</td>
                                    <td>20</td>
                                    <td>10</td>                                   
                                </tr>
                                <tr>
                                    <td>2021.01.08</td>
                                    <td>7</td>
                                    <td>8</td>
                                </tr>
                                <tr>
                                    <td>2021.01.09</td>
                                    <td>7</td>
                                    <td>8</td>
                                </tr>
                                <tr>
                                    <td>2021.01.10</td>
                                    <td>7</td>
                                    <td>8</td>
                                </tr>
                            </tbody>
                        </table>
                      </section>
                      </div>
                      </div>
                     <!-- 조회된 다운로드 테이블  -->
                     <div id = "now">
                    <section class="tbl_wrap_list m-t-40">
                    <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col" rowspan="2">주유일자</th>
                                    <th scope="col" colspan="2" class="border-b-1">주유량</th>
                                </tr>
                                <tr>
                                    <th scope="col" class="border-l-1">휘발유</th>
                                    <th scope="col">경유</th>
                                </tr>
                            </thead>
                            <tbody id="nowoill">
                                <tr>
                                    <td>2021.01.07</td>
                                    <td>20</td>
                                    <td>10</td>                                   
                                </tr>
                                <tr>
                                    <td>2021.01.08</td>
                                    <td>7</td>
                                    <td>8</td>
                                </tr>
                                <tr>
                                    <td>2021.01.09</td>
                                    <td>7</td>
                                    <td>8</td>
                                </tr>
                                <tr>
                                    <td>2021.01.10</td>
                                    <td>7</td>
                                    <td>8</td>
                                </tr>
                            </tbody>
                        </table>
                      </section>
                      
                      <section id="pagingc" class="pagination m-t-30">
	            			<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
	                  </section>
	                    	<button type="button" id="alldownload" class="btn btn_default">전체다운로드</button>
                      </div>
                <div id="allexcelmonth">
                <div id = "monthcnt">
                   <section class="tbl_wrap_list m-t-40">
                   <table class="tbl_list m-t-30" summary="합계 테이블">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col"></th>
                                    <th scope="col">휘발유</th>
                                    <th scope="col">경유</th>
                                </tr>
                            </thead>
                            <tbody id = "monthtotal">
                                <tr>
                                    <td>월별 주유량 합계</td>
                                    <td>7</td>
                                    <td>8</td>
                                </tr>
                            </tbody>
                        </table>
                        </section>
                        </div>      
                <!-- 전체 테이블  -->
                <div id = "allmonth">      
                <section class="tbl_wrap_list m-t-40">
                    <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col" rowspan="2">주유일자</th>
                                    <th scope="col" colspan="2" class="border-b-1">주유량</th>
                                </tr>
                                <tr>
                                    <th scope="col" class="border-l-1">휘발유</th>
                                    <th scope="col">경유</th>
                                </tr>
                            </thead>
                            <tbody id="allmonthl">
                                <tr>
                                    <td>2021.01.07</td>
                                    <td>20</td>
                                    <td>10</td>                                   
                                </tr>
                                <tr>
                                    <td>2021.01.08</td>
                                    <td>7</td>
                                    <td>8</td>
                                </tr>
                                <tr>
                                    <td>2021.01.09</td>
                                    <td>7</td>
                                    <td>8</td>
                                </tr>
                                <tr>
                                    <td>2021.01.10</td>
                                    <td>7</td>
                                    <td>8</td>
                                </tr>
                            </tbody>
                        </table>
                      </section>
                      </div>
                      </div>
                      <!-- 월별  -->
                     <div id = "month">
                    <section class="tbl_wrap_list m-t-40">
                    <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="80px" />
                                <col width="80px" />
                                <col width="80px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col" rowspan="2">주유일자</th>
                                    <th scope="col" colspan="2" class="border-b-1">주유량</th>
                                </tr>
                                <tr>
                                    <th scope="col" class="border-l-1">휘발유</th>
                                    <th scope="col">경유</th>
                                </tr>
                            </thead>
                            <tbody id="monthlist">
                                <tr>
                                    <td>2021.01.07</td>
                                    <td>20</td>
                                    <td>10</td>                                   
                                </tr>
                                <tr>
                                    <td>2021.01.08</td>
                                    <td>7</td>
                                    <td>8</td>
                                </tr>
                                <tr>
                                    <td>2021.01.09</td>
                                    <td>7</td>
                                    <td>8</td>
                                </tr>
                                <tr>
                                    <td>2021.01.10</td>
                                    <td>7</td>
                                    <td>8</td>
                                </tr>
                            </tbody>
                        </table>
                      </section>
                      <!-- Pagination -->
	                <section id="pagingl" class="pagination m-t-30">
	                </section>
                    	<button type="button" id="monthdownload" class="btn btn_default">전체다운로드</button>
	                <!-- //Pagination -->  
	                <!-- //table list -->
                      </div>
                </div>
        </div>
        <!-- //tab -->
            </div>
            <!-- //content -->
        </div>
        <!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>