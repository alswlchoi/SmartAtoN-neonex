<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){
	//search(1, 'ready');
	$("#searchKeyword1").keydown(function(key) {
		if (key.keyCode == 13) {
			search();
		}
	});
	$("#searchKeyword2").keydown(function(key) {
		if (key.keyCode == 13) {
			search();
		}
	});
	$("#searchKeyword3").keydown(function(key) {
		if (key.keyCode == 13) {
			search();
		}
	});
	
	//검색초기화 버튼
	$("#initBtn").click(function(){
		$("#searchKeyword1").val("");
		$("#searchKeyword2").val("");
		$("#searchKeyword3").val("");
		$("#date1").val("");
		search();		
	});
	
	//엑셀 조회 데이터다운로드
	$("#carsectionDown").off("click").on("click",function(){
		downloadExcel("carsection", "carsections");
	})
	
	//엑셀 전체 다운로드
	$("#allcars").off("click").on("click",function(){
		downloadExcel("allcarsection","allcarsections");
	})
});

function search(){
	var stDate = "", edDate = "";
	
	if($("#date1").val() != ''){
		var readyDate = $("#date1").val().split(' ~ ');
		console.log(readyDate);
        stDate = moment(readyDate[0]).format('YYYYMMDD');
        edDate = moment(readyDate[1]).format('YYYYMMDD');
	}
	
	var param = {
		vhclName : $("#searchKeyword1").val(),
		vhclRgsno : $("#searchKeyword2").val(),
		carOil : $("#searchKeyword3").val(),
		stDay : stDate,
		stDay2 : edDate,
	};
	console.log(param);
	postAjax("/admin/statistics/carSectionlist",param,"searchCallback",null,null,null);
}

function searchCallback(data){
	console.log(data);
	var carsection = data.carsection;
	//차량별주유정보 데이터
	$("#carSeclist").html("");
	var html = "";
	var index = 1;
	
	if(carsection.length == 0){
		html += '<tr class="tr_nodata"><td colspan="9">데이터가 존재하지 않습니다.</td></tr>';
	}else{
		for(var list in carsection){
			if(carsection[list].vhclRgsno !== null){
				html += '<tr>'
				html += '<td>'; //번호
				html += index;
				html += '</td>';
				html += '<td>'; //번호
				html += carsection[list].vhclRgsno;
				html += '</td>';
				html += '<td>'+moment(carsection[list].pumpEnd, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>';  //시험일자
				html += '<td>'; //센서
				html += carsection[list].qty;
				html += '</td>';
				html += '</tr>'
				index++
			}else{
				html += '<tr class="bg_total color_b333">'
				html += '<td>'; 
				html += '</td>';
				html += '<td>'; 
				html += '</td>';
				html += '<td>'; //센서
				html += '합계';
				html += '</td>';
				html += '<td>';
				html += carsection[list].sumQty;
				html += '</td>';
				html += '</tr>'
			}
		}
	}
	$("#carSeclist").html(html);	
}

function pageMove(str){
	if(str=='tab1'){
		location.href = '/admin/statistics/oil';
	}else if(str == 'tab2'){
		location.href = '/admin/statistics/carSection';
	}
}

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
// 	    singleDatePicker: true                   // 하나의 달력 사용 여부
	});
})

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
		<div class="breadcrumb">
			<span class="breadcrumb_icon"></span><span>통계</span><span>주유 통계</span>
		</div>
		<!-- //breadcrumb -->
		<!-- title -->
		<h2 class="title">주유 통계</h2>
		<!-- //title -->
		
		<!-- tab -->
		<div class="wrap_tab">
			<div class="tab">
				<button class="tablinks" onclick="pageMove('tab1')">기간별</button>
                <button class="tablinks active" onclick="pageMove('tab2')" id="defaultOpen">차량별</button>
			</div>
			<div class="wrap_tabcontent">
				<!-- search_wrap -->
				<section class="search_wrap">
				    <div class="form_group m-r-10">
				        <div class="check_default">
				         <div class="form_group w300">
				         <input type="text" id="searchKeyword1" class="form_control" placeholder="차량명 입력" name="" />
				     	</div>
				         <div class="form_group w300">
				         <input type="text" id="searchKeyword2" class="form_control" placeholder="차량번호 입력" name="" />
				     	</div>
				     	<div class="form_group w300">
				         <input type="text" id="searchKeyword3" class="form_control" placeholder="유종" name=""/>
				     	</div>
				        </div>
				    </div>
				    <div class="form_group w230">
				        <input type="text" id="date1" class="form_control dateicon datefromto"
				            placeholder="기간 선택" name="">
				    </div>
				    <button type="button" onclick="search(1)" class="btn-s btn_default">조회</button>
				    <button type="button" id="initBtn" class="btn-s btn_default">검색초기화</button>
				</section>
				<!-- //search_wrap -->
				<!-- 엑셀다운로드 테이블 -->
				<div id="carsection">
				<section class="tbl_wrap_list m-t-30" >
					<table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
					    <caption>테이블</caption>
					    <colgroup>
					        <col width="40px" />
					        <col width="80px" />
					        <col width="80px" />
					        <col width="80px" />
					    </colgroup>
					    <thead>
					        <tr>
					        	<th scope="col">번호</th>
					        	<th scope="col">차량번호</th>
					            <th scope="col">주유일자</th>
					            <th scope="col">주유량</th>
					        </tr>
					    </thead>
					    <tbody id="carSeclist">
					    <!-- 화면로딩 -->
					    <c:if test="${fn:length(carsection.length) == 0}">
							<tr class="tr_nodata">
								<td colspan="9">데이터가 존재하지 않습니다.</td>
							</tr>
						</c:if>
					    </tbody>
					</table>
				</section>
					<button type="button" id="carsectionDown" class="btn btn_default m-t-30">조회데이터다운로드</button>
               		<button type="button" id="allcars" class="btn btn_default m-t-30">전체다운로드</button>
				<!-- //Pagination -->
				</div>
			</div>
		</div>
		<!-- //tab -->
	</div>
	<!-- //content -->
</div>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>