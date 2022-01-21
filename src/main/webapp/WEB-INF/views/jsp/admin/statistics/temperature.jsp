<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.min.js"></script>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){
	search(1);
	$(".w230").hide();
	$(".ww").hide();
	$("#allarea").hide();
	
	$("#myChartContainer").css("width", "1400px");
	$("#myChartContainer").css("overflow-x", "scroll");
	
	//페이징 조회 버튼
    $(document).on("click", ".pageNo", function() {
			search($(this).attr("data-page"));
		});
	
    $("#excelDown").off("click").on("click" , function(){
		downloadExcel("allarea","alltest")
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
	    autoUpdateInput: false,
	    startDate: moment().add(-3, 'day'),
	    endDate: moment().add(+30, 'day'),
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
	      startDate: moment(),
	      autoApply: true,
	      singleDatePicker: true,
	      cancelLabel: '취소',
	      applyLabel: "확인",
	      locale: {
	        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
	        daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
	        yearSuffix: '년',
	        separator: " ~ ",
	        format: 'YYYY-MM-DD'
	      }
	    });
})

//자동 조회
function search(page) {
    var stDate = null,edDate = null,oneDate = null;
    
    //차트 지웠다 다시 생성
    $("#myChart").remove();
	$("#myChartContainer").append('<canvas id="myChart"></canvas>');
	
    //주간 값 넘길때
    if ($("#date1").val() != '') {
        var readyDate = $("#date1").val().split(' ~ ');
        stDate = moment(readyDate[0]).format('YYYYMMDD');
        edDate = moment(readyDate[1]).format('YYYYMMDD');
        
      }
 	
    //일별 값 넘길 때
    if ($("#date2").val() != '') {
        var readyDate = moment($("#date2").val()).format('YYYYMMDD');
        oneDate = readyDate;
      }
    
    //노면센서 값 넘길때
    select = $("#selectlist option:selected").val();
     
    year = $("#year option:selected").val();
    
	var param = {
	  tid : select,
	  date : $("#date  option:selected").val(),
	  tcDay : stDate,
	  tcDay2 : edDate,
	  oneDate : oneDate, 
	  year : year
	}
// 	console.log(param);
	postAjax("/admin/statistics/temperature1",param,"searchCallback",null,null,null);
}

//조회 버튼 눌렀을 때
function monthclick(){
    var stDate = null,edDate = null,oneDate = null;
    
    //차트 지웠다 다시 생성
    $("#myChart").remove();
	$("#myChartContainer").append('<canvas id="myChart"></canvas>');
	
    //주간 값 넘길때
    if ($("#date1").val() != '') {
        var readyDate = $("#date1").val().split(' ~ ');
        stDate = moment(readyDate[0]).format('YYYYMMDD');
        edDate = moment(readyDate[1]).format('YYYYMMDD');
        
      }
 	
    //일별 값 넘길 때
    if ($("#date2").val() != '') {
        var readyDate = moment($("#date2").val()).format('YYYYMMDD');
        oneDate = readyDate;
      }
    
  	//select박스가 기간일때 빈칸 막는
    if($("#date").val() == "week" && $("#date1").val() == ''){
    	alert("기간을 입력해 주세요");
		$(".lyClose").click(function(){
			location.reload();
		})
    	return false;
    }
    
    //노면센서 값 넘길때
    select = $("#selectlist option:selected").val();
     
    year = $("#year option:selected").val();
    
	var param = {
	  tid : select,
	  date : $("#date  option:selected").val(),
	  tcDay : stDate,
	  tcDay2 : edDate,
	  oneDate : oneDate, 
	  year : year
	}
	postAjax("/admin/statistics/temperature1",param,"searchCallback",null,null,null);
}

//차트 데이터 
function searchCallback(data){	
	//console.log(data);
	
	//엑셀다운로드 데이터
	var excel = data.excel;
	$("#alltracklist").html("");
	var html = "";
	var index = 1;
	$.each(excel,function(i,el){
		var excel = el;
		
			html += '<tr>'
			
			html += '<td>'; //번호
			html += index;
			html += '</td>';
			
			html += '<td>'+moment(excel.roadInTime, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';  //일자
	
			html += '<td>'; //센서
			html += excel.tnickname;
			html += '</td>';
			
			html += '<td>'; //온도
			html += excel.roadTemp;
			html += '</td>';
			
			html += '</tr>'
			
			index++
			
		
	})
	$("#alltracklist").html(html);	
	
	// intime 가져온거
	var Listdata = data.Listdata;
	var list = data.list;
	
	console.log(list);
// 	console.log(Listdata);
// 	console.log(monthdata);
// 	console.log(yeardata);

	
	// labels에 넣어줄 새 배열
	var newLabels = new Array();
	var datasets = new Array();
	var newLabels1 = new Array();
	
	var arr1 = new Array(),
	arr2 = new Array(),
	arr3 = new Array(),
	arr4 = new Array(),
	arr5 = new Array(),
	arr6 = new Array(),
	arr7 = new Array(),
	arr8 = new Array(),
	arr9 = new Array();
	
	//x축 데이터
	if($("#date").val() == "day"){
		for(var i in list){//day일때
			newLabels.push(moment(list[i].regDt, "YYYYMMDDhhmm").format("HH:mm"));
		}
			var set1 = new Set(newLabels);
			newLabels1 = Array.from(set1);
			
	}else if($("#date").val() == "week"){
		for(var i in list){//week일때
			newLabels.push(moment(list[i].regDt, "YYYYMMDDhhmm").format("MM/DD"));
		}
			var set1 = new Set(newLabels);
			newLabels1 = Array.from(set1);
	}else{
		for(var i in list){//year일떄
			newLabels.push(list[i].wcount);
		}
			var set1 = new Set(newLabels);
			newLabels1 = Array.from(set1);
	}
	
	//y축 데이터
	for (var i in list) {
		switch (list[i].tid) {
		case "T1":
			arr1.push(list[i].temp);
			break;
		case "T2":
			arr2.push(list[i].temp);
			break;
		case "T3":
			arr3.push(list[i].temp);
			break;
		case "T4":
			arr4.push(list[i].temp);
			break;
		case "T5":
			arr5.push(list[i].temp);
			break;
		case "T6":
			arr6.push(list[i].temp);
			break;
		case "T7":
			arr7.push(list[i].temp);
			break;
		case "T8":
			arr8.push(list[i].temp);
			break;
		case "T9":
			arr9.push(list[i].temp);
			break;
		}
	}
// 	console.log(newLabels);
// 	console.log(newmonthdata);
// 	console.log(newyeardata);
// 	console.log(arr1);
// 	console.log(arr2);
// 	console.log(arr3);
// 	console.log(arr4);
// 	console.log(arr5);
// 	console.log(arr6);
// 	console.log(arr7);
// 	console.log(arr8);
// 	console.log(arr9);
	
    var ctx = document.getElementById("myChart").getContext('2d');
    var myChart = new Chart(ctx, {
    	
  	  type: 'line',
  	  data: {
  		  labels: newLabels1,
  		  datasets: [{
  			  label: 'DHC',
  			  data: arr1,
   			  fill: false,
   			  borderColor: [
  				  'rgba(43, 44, 170)',
  			  ],
  		  },
  		  {
  			  label: 'WHC',
  			  data: arr2,
   			  fill: false,
   			  borderColor: [
  				  'rgba(132, 140, 207)',
  			  ],
  		  },
  		  {
  			  label: 'WHC#2',
  			  data: arr3,
   			  fill: false,
   			  borderColor: [
  				  'rgba(44, 130, 201)',
  			  ],
  		  },
  		  {
  			  label: 'NVH',
  			  data: arr4,
   			  fill: false,
   			  borderColor: [
  				  'rgba(0, 181, 204)',
  			  ],
  		  },
  		  {
  			  label: 'NVH#2',
  			  data: arr5,
   			  fill: false,
   			  borderColor: [
  				  'rgba(30, 139, 195)',
  			  ],
  		  },
  		  {
  			  label: 'BRK(WET-Smooth)',
  			  data: arr6,
   			  fill: false,
   			  borderColor: [
  				  'rgba(137, 196, 244)',
  			  ],
  		  },
  		  {
  			  label: 'BRK(Hydro-straight)',
  			  data: arr7,
   			  fill: false,
   			  borderColor: [
  				  'rgba(72, 113, 247)',
  			  ],
  		  },
  		  {
  			  label: 'BRK(WEB-ASP)',
  			  data: arr8,
   			  fill: false,
   			  borderColor: [
  				  'rgba(45, 85, 255)',
  			  ],
  		  },
  		  {
  			  label: 'BRK(DRY-ASP)',
  			  data: arr9,
   			  fill: false,
   			  borderColor: [
  				  'rgba(65, 131, 215)',
  			  ],
  		  }]
  	  },
  	  options: {
  		  scales: {
  			  yAxes: [{
  				  ticks: {
  					  beginAtZero: true
  				  }
  			  }]
  		  }
  	  }
    });
    
    
    
}


//탭 이동
function pageMove(str){
	if(str=='tab1'){
		location.href = '/admin/statistics';
	}else if(str == 'tab2'){
		location.href = '/admin/statistics/temperature';
	}
}

//리셋 함수
function resetbtn(){
	var today = new Date();     
	var year = today.getFullYear();
	var month = ("0" + (1 + today.getMonth())).slice(-2);
	var date = ("0" + today.getDate()).slice(-2);
	var day = year+"-"+month+"-"+date;
	
	$("#date1").val("");
	$("#date2").val(day);
	$("#selectlist").val("");
	$("#year").val(year);
}

//onchange 함수
function thechange(e){
	var today = new Date();     
	var year = today.getFullYear();
	var month = ("0" + (1 + today.getMonth())).slice(-2);
	var date = ("0" + today.getDate()).slice(-2);
	var day = year+"-"+month+"-"+date;
	
	if(e.value == "day"){
		$(".w230").hide(); //기간
		$(".ww").hide(); // 연도
		$(".qq").show(); //일별
		$("#date2").val(day);
	}else if(e.value == "week"){
		$(".w230").show();
		$(".qq").hide();
		$(".ww").hide();
		$("#date1").val("");
	}else if(e.value == "year"){
		$(".w230").hide();
		$(".qq").hide();
		$(".ww").show();
		$("#year").val(year);
	}
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
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>통계</span><span>기상통계</span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">기상통계</h2>
                <!-- //title -->
				
			<div class="wrap_tab">
	             	<div class="tab">
		                <button class="tablinks" onclick="pageMove('tab1')">기상</button>
		                <button class="tablinks active" onclick="pageMove('tab2')" id="defaultOpen">노면온도</button>
	            	</div>
            <div class="wrap_tabcontent">
                <!-- search_wrap -->
                <section class="search_wrap">
                        <div class="form_group">
			                <div class="select_group">
			                    <select id="selectlist" title="select" class="form_control">
			                        <option value="">노면센서</option>
			                        <c:forEach var="list" items="${list}">
			                        	<option value="${list.TId}"> ${list.TNickname}</option>
			                        </c:forEach>
			                    </select>
			                </div>
			            </div>
                        <div class="form_group">
			                <div class="select_group">
			                    <select id="date" title="select" onchange=thechange(this) class="form_control">
			                        <option value="day">일별</option>
			                        <option value="week">기간</option>
			                        <option value="year">연도</option>
			                    </select>
			                </div>
			            </div>
			            
                        <div class="form_group w230">
                            <input type="text" id="date1" autocomplete='off' class="form_control dateicon datefromto"
                                placeholder="기간 선택" name="date1">
                        </div>
                        
                        <div class="form_group ww">
			                <div class="select_group" >
			                    <select id="year" title="select" class="form_control">
			                        <c:set var="today" value="<%=new java.util.Date()%>" />
									<fmt:formatDate value="${today}" pattern="yyyy" var="start"/> 
									<c:forEach begin="0" end="5" var="idx" step="1">
									<option value="<c:out value="${start - idx}" />"><c:out value="${start - idx}" /></option>
									</c:forEach>
			                    </select>
			                </div>
			            </div>
			            
                        <div class="form_group qq">
			                <input type="text" id="date2" class="form_control date1 dateicon" 
			                	placeholder="날짜 선택" name="date2">
			            </div>
                        <button type="button" onclick="monthclick()" class="btn-s btn_default" id="aaa">조회</button>
                        <button type="button" onclick="resetbtn()" class="btn-s btn_default" id="rebtn">검색초기화</button>
                    	<button type="button" id="excelDown" class="btn btn_default">전체다운로드</button>
                    </section>
                <!-- //search_wrap -->
                <!-- table list -->
                
                <section id = "myChartContainer" class="tbl_wrap_list m-t-30">
                
					<canvas id="myChart" width="100" height="100"></canvas>
                
                </section>
               
			            <div id = "allarea">
			        	<section class="tbl_wrap_list m-t-30">
			            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
			                <caption>테이블</caption>
			                <colgroup>
			                    <col width="80px" />
			                    <col width="80px" />
			                    <col width="80px" />
			                    <col width="80px" />
			                </colgroup>
			                <thead>
			                    <tr>
			                        <th scope="col">번호</th>
			                        <th scope="col">일자</th>
			                        <th scope="col">센서</th>
			                        <th scope="col">온도(*C)</th>
			                    </tr>
			                </thead>
			                <tbody id="alltracklist">
			                    <tr>
			                        <td>10</td>
			                        <td>2021.09.09</td>
			                        <td>VHC</td>
			                        <td>36.1</td>
			                    </tr>
			                    <tr>
			                        <td>10</td>
			                        <td>2021.09.09</td>
			                        <td>BRAKING</td>
			                        <td>36.1</td>
			                    </tr>
			                </tbody>
			            </table>
			        </section>
			        </div>
                </div>
        	</div>
        <!-- //tab -->
            </div>
            <!-- //content -->
        </div>
        <!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>