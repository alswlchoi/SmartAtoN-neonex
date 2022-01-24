<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
// 가져온 날짜 형식 변경
function changeDate(str) {
  var y = str.substr(0,4);
  var m = str.substr(4,2);
  var d = str.substr(6,2);
  var date = y+'-'+m+'-'+d;
  return date;
}

function convertDateFormat(date) {
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    month = month >= 10 ? month : '0' + month;
    var day = date.getDate();
    day = day >= 10 ? day : '0' + day;
    return [year, month, day].join('-');
}
var dayOff = new Array();
$(document).ready(function(){
	$(".lodingdimm").show();
	//daterangepiker start
	$("#tcDay").daterangepicker({
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
	//daterangepiker end
	
	$("#search").keydown(function(key) {
		if (key.keyCode == 13) {
			search("button");
		}
	});
	
	$("#searchBtn").click(function(){
		search("button");
	});
	
	$("#initBtn").click(function(){
		search("init");
	});
	
	//페이지 로딩시 상세보기 달력 내용 가져오기
	$(document).on("click",'#divCalendar' ,function(){
		calcHeight();
	});
	//시험로 selectbox
	$.ajax({
		url : "/admin/trReserve/track-list",
		type : "get",
		data : {},
		success : function(resdata){
			drawTrackSelect(resdata.trackList, "");
		},
		error : function(e){
			console.log(e);
		}
	});
	
	$(document).on("click",'#listBtn' ,function(){
		search("list");
	});
});

//탭 이동
function pageMove(str){
  if(str=='tab1'){
    location.href = '/admin/trReserve';
  }else if(str == 'tab2'){
    location.href = '/admin/reserved/shop';
  }
}

$(document).on("click", ".accordion", function () {
    this.classList.toggle("active");
    var panel = this.nextElementSibling;
    if (panel.style.display === "block") {
        panel.style.display = "none";
    } else {
        panel.style.display = "block";
    }
});

//페이지 버튼 클릭
$(document).on("click",".pageNo",function(){  
	$(this).siblings().removeClass("on");
	$(this).addClass("on");
	
	if($(this).attr("data-page")==1){
		$(".pg_first").hide();
		$(".pg_prev").hide();
	}else{
		$(".pg_first").show();
		$(".pg_prev").show();
	}

	search("paging");

});

function search(type){
	var pageNo;
	var compName = $("#search").val();
	var tcDay = $("#tcDay").val();
	var trTrackCode = $("#trTrackCode").val();
	
	var tcApproval = "";
	if($("#btn2").hasClass("currentBtn")){	//취소내역이 선택된 상태라면
		$("input[name=tcApproval]:checked").each(function() {
			if(tcApproval == "") {
				tcApproval += $(this).val();
			}else{
				tcApproval += ","+$(this).val();
			}
		});
		
		if(tcApproval == "") {
			$("#tcApproval1").prop("checked",true);
			$("#tcApproval2").prop("checked",true);
			tcApproval = "1,2";
		}
	}else{
		tcApproval = "0";
	}
	
	if(type == "list") {//목록 버튼
		pageNo = $("#pageNo").text();
	}else if(type == "paging"){//페이징 검색
		pageNo = $(".pageNo.on").attr("data-page"); 
	}else{
		pageNo = "1";
	}
		
	if(pageNo == ""){
		pageNo = "1";
	}
	
	if(type == "init"){
		var compName = "";
		var tcDay = "";
		$("#search").val("");
		$("#tcDay").val("");
		$("#trTrackCode option:eq(0)").prop("selected", true);
		trTrackCode = "";
	}

	var orderName1="";
	var orderKind1="";
	var orderName2="";
	var orderKind2="";
	var orderName3="";
	var orderKind3="";
	var orderName4="";
	var orderKind4="";
	var orderName5="";
	var orderKind5="";

	if($("#order1").hasClass("btn_sort_down")){
		orderName1="Y";
		orderKind1="DESC";
    }else if($("#order1").hasClass("btn_sort_up")){
		orderName1="Y";
		orderKind1="ASC";	    	
    }
	if($("#order2").hasClass("btn_sort_down")){
		orderName2="Y";
		orderKind2="DESC";
    }else if($("#order2").hasClass("btn_sort_up")){
		orderName2="Y";
		orderKind2="ASC";	    	
    }
	if($("#order3").hasClass("btn_sort_down")){
		orderName3="Y";
		orderKind3="DESC";
    }else if($("#order3").hasClass("btn_sort_up")){
		orderName3="Y";
		orderKind3="ASC";	    	
    }
	if($("#order4").hasClass("btn_sort_down")){
		orderName4="Y";
		orderKind4="DESC";
    }else if($("#order4").hasClass("btn_sort_up")){
		orderName4="Y";
		orderKind4="ASC";	    	
    }
	if($("#order5").hasClass("btn_sort_down")){
		orderName5="Y";
		orderKind5="DESC";
    }else if($("#order5").hasClass("btn_sort_up")){
		orderName5="Y";
		orderKind5="ASC";	    	
    }

	$("#tabBody").show();
	$(".lodingdimm").show();
	
	$.ajax({
		url : "/admin/trReserve/search-trReserve",
		type : "get",
		data : {
				"pageNo"  :pageNo,
				"compName":compName,
				"tcDay":tcDay,
				"trTrackCode":trTrackCode,
				"tcApproval":tcApproval,
				"orderName1":orderName1,
				"orderName2":orderName2,
				"orderName3":orderName3,
				"orderName4":orderName4,
				"orderName5":orderName5,
				"orderKind1":orderKind1,
				"orderKind2":orderKind2,
				"orderKind3":orderKind3,
				"orderKind4":orderKind4,
				"orderKind5":orderKind5
		},
		success : function(resdata){
			drawingTable(resdata.rows, resdata.paging, tcApproval);
			drawingPage(resdata.paging);
		},
		error : function(e){
			console.log(e);
		}
	});

}

//조회값 undefined -> 공백 처리
function undefinedChk(str1, str2){
	if( str1 == "" || str1 == null || typeof str1 == undefined || str1 == undefined || ( str1 != null && typeof str1 == "object" && !Object.keys(str1).length ) ){
		return str2;
	}else{
		return str1;
	}
}

$(document).on("click","button[id^=order]",function(){
	var orderName1="";
	var orderKind1="";
	var orderName2="";
	var orderKind2="";
	var orderName3="";
	var orderKind3="";
	var orderName4="";
	var orderKind4="";
	var orderName5="";
	var orderKind5="";
	if($(this).prop("id")=="order1"){
		if(!$(this).hasClass("btn_sort_down")&&!$(this).hasClass("btn_sort_up") ){
			orderName1="Y";
			orderKind1="DESC";
			$(this).addClass("btn_sort_down");
	    }else if($(this).hasClass("btn_sort_down")){
			orderName1="Y";
			orderKind1="ASC";
			$(this).removeClass("btn_sort_down")
			.addClass("btn_sort_up");
	    }else if($(this).hasClass("btn_sort_up")){
			orderName1="";
			$(this).removeClass("btn_sort_down")
			.removeClass("btn_sort_up");	    	
	    }
	}
	if($(this).prop("id")=="order3"){
		if(!$(this).hasClass("btn_sort_down")&&!$(this).hasClass("btn_sort_up") ){
			orderName3="Y";
			orderKind3="DESC";
			$(this).addClass("btn_sort_down");
	    }else if($(this).hasClass("btn_sort_down")){
			orderName3="Y";
			orderKind3="ASC";
			$(this).removeClass("btn_sort_down")
			.addClass("btn_sort_up");
	    }else if($(this).hasClass("btn_sort_up")){
			orderName3="";
			$(this).removeClass("btn_sort_down")
			.removeClass("btn_sort_up");	    	
	    }
	}
	if($(this).prop("id")=="order4"){
		if(!$(this).hasClass("btn_sort_down")&&!$(this).hasClass("btn_sort_up") ){
			orderName4="Y";
			orderKind4="DESC";
			$(this).addClass("btn_sort_down");
	    }else if($(this).hasClass("btn_sort_down")){
			orderName4="Y";
			orderKind4="ASC";
			$(this).removeClass("btn_sort_down")
			.addClass("btn_sort_up");
	    }else if($(this).hasClass("btn_sort_up")){
			orderName4="";
			$(this).removeClass("btn_sort_down")
			.removeClass("btn_sort_up");	    	
	    }
	}
	if($(this).prop("id")=="order5"){
		if(!$(this).hasClass("btn_sort_down")&&!$(this).hasClass("btn_sort_up") ){
			orderName5="Y";
			orderKind5="DESC";
			$(this).addClass("btn_sort_down");
	    }else if($(this).hasClass("btn_sort_down")){
			orderName5="Y";
			orderKind5="ASC";
			$(this).removeClass("btn_sort_down")
			.addClass("btn_sort_up");
	    }else if($(this).hasClass("btn_sort_up")){
			orderName5="";
			$(this).removeClass("btn_sort_down")
			.removeClass("btn_sort_up");	    	
	    }
	}
	search("list");
});

//상세보기로 이동
$(document).on("click",".godetail",function(){
	var currentRow=$(this).closest('tr');
	var pageNo;
	var tcSeq = currentRow.find('td:eq(0) span').text();
	var tcDay = currentRow.find('td:eq(3) span').text();
	tcDay = tcDay.replace(/\./g,'');
	pageNo = $(".pageNo.on").attr("data-page");
	$("#pageNo").html(pageNo);
	$("#tcSeq").text(tcSeq);
	
	location.href="/admin/trReserve/detail-trReserve?pageNo="+pageNo+"&tcSeq="+tcSeq+"&tcDay="+tcDay;
});	

function fnChkByte(obj, maxByte){
	var str = obj.value;
	var str_len = str.length;

	var rbyte = 0;
	var rlen = 0;
	var one_char = "";
	var str2 = "";

	for(var i=0; i<str_len; i++){
		one_char = str.charAt(i);
		if(escape(one_char).length > 4){
		    rbyte += 2;                                         //한글2Byte
		}else{
		    rbyte++;                                            //영문 등 나머지 1Byte
		}

		if(rbyte <= maxByte){
		    rlen = i+1;                                          //return할 문자열 갯수
		}
	}

	if(rbyte > maxByte){
	    //alert("한글 "+(maxByte/2)+"자 / 영문 "+maxByte+"자를 초과 입력할 수 없습니다.");
	    str2 = str.substr(0,rlen);                                  //문자열 자르기
	    obj.value = str2;
	    fnChkByte(obj, maxByte);
	}else{
	    document.getElementById('byteInfo').innerText = rbyte;
	}
}

//테이블 그리는 함수
function drawingTable(rows, paging, tcApproval){
	var html='';
	if(rows.length==0){
		html += '<tr class="tr_nodata"><td colspan="8">데이터가 존재하지 않습니다.</td></tr>';
	}else{
		for(var list in rows){
			html += '<tr onmouseover="this.className=\'on godetail\'"onmouseout="this.className=\'\'">';
			html += '<td><span style="display:none">'+undefinedChk(rows[list].tcSeq,"")+'</span>';
			html += paging.totalCount-(paging.pageNo-1)*paging.pageSize-list;
			html += '</td>';
			html += '<td>'+undefinedChk(rows[list].tcReservCode,"")+'</td>';
			var tcRegDt = undefinedChk(rows[list].tcRegDt,"");
			if(tcRegDt.length==14){
				tcRegDt = tcRegDt.substring(0,4)+ "."+ tcRegDt.substring(4,6)+ "."+ tcRegDt.substring(6,8);
			}
			html += '<td>'+tcRegDt+'</td>';
			var tcDay = undefinedChk(rows[list].tcDay,"");
			var tcDay2 = undefinedChk(rows[list].tcDay2,"");
			if(tcDay.length==8){
				tcDay = tcDay.substring(0,4)+ "."+ tcDay.substring(4,6)+ "."+ tcDay.substring(6,8);
			}
			if(tcDay2.length==8){
				tcDay2 = tcDay2.substring(0,4)+ "."+ tcDay2.substring(4,6)+ "."+ tcDay2.substring(6,8);
			}
			html += '<td>';
			html += '<span>'+tcDay+'</span>';
			if(tcDay!=tcDay2){
				html += '~<br />'+tcDay2;
			}
			html += '</td>';
			html += '<td>';
			if(undefinedChk(rows[list].compCode,"")=="THINT"){
				html += 'T-HINT';
			}else{
				html += undefinedChk(rows[list].compName,"");
				if(undefinedChk(rows[list].blackList,"")=="Y") {
					html += '<br /><span class="color_red">(B/L)</span>';	
				}
			}
			html += '</td>';
			html += '<td>'+undefinedChk(rows[list].trTrackNickName,"").replace(/#/g, "<br />")+'</td>';
			html += '<td>';
			var trTrackType = undefinedChk(rows[list].trTrackType,"");
			if(trTrackType=="TYP00") {
				html += '공동';
			}else if(trTrackType=="TYP01") {
				html += '단독';
			}else if(trTrackType=="TYP02") {
				html += '시험';
			}else if(trTrackType=="TYP03") {
				html += '연습';
			}else if(trTrackType=="TYP04") {
				html += '점검';
			}else if(trTrackType=="TYP05") {
				html += '시승';
			}else if(trTrackType=="TYP06") {
				html += '사내방문';
			}else if(trTrackType=="TYP07") {
				html += '테스트';
			}else if(trTrackType=="TYP99") {
				html += '기타';
			}
			html += '</td>';
			html += '</tr>';
		}
	}
	$("#tbody").html(html);
}

//시험로 정보 selectbox 생성
function drawTrackSelect(trackList, currentTid){
	var html='';
	html += '<select name="trTrackCode" id="trTrackCode" class="form_control">';
	html += '<option value="">시험로선택</option>';
	for(var list in trackList){
		if(parseInt(list)>0){
			html += '<option value="'+undefinedChk(trackList[list].tid,"")+'">'+undefinedChk(trackList[list].tname,"")+'</option>';
		}
	}
	html += '</select>';
	$("#tracklist").html(html)
}

//RFID 정보 selectbox 생성
function drawRfidSelect(rows, currentrId){
	var html='';
	html += '<select name="rId" id="rId">';
	html += '<option value="">RFID선택</option>';
	for(var list in rows){
		html += '<option value="'+undefinedChk(rows[list].rId,"")+'">'+undefinedChk(rows[list].rId,"")+'</option>';
	}
	html += '</select>';
	$("#rfidlist").html(html)
}

function calcHeight(){
	 //find the height of the internal page

	 var the_height=
	 document.getElementById('iframe').contentWindow.
	 document.body.scrollHeight;

	 //change the height of the iframe
	 document.getElementById('iframe').height=
	 the_height;

	 //document.getElementById('the_iframe').scrolling = "no";
	 document.getElementById('iframe').style.overflow = "hidden";
	}
</script>
        <div id="container">
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>예약/정산관리</span><span>예약관리</span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">예약관리</h2>
                <!-- //title -->

                <!-- tab -->
                <div class="wrap_tab">
                    <div class="tab">
                        <button class="tablinks active" onclick="pageMove('tab1')">시험로</button>
                        <button class="tablinks" onclick="pageMove('tab2')">부대시설</button>
                    </div>
                    <div class="wrap_tabcontent">
                        <!-- tab1-시험로 -->
                        <div id="tab1" class="tabcontent">
                            <!-- tab2 -->
                            <div class="webwidget_tab" id="webwidget_tab">
                                <div class="tabContainer">
                                    <ul class="tabHead">
                                        <li id="btn1"<c:if test='${tcApproval eq "0"}'> class="currentBtn"</c:if>><a href="/admin/trReserve?tcApproval=0">예약승인대기</a></li>
                                        <li id="btn2"<c:if test='${tcApproval eq "2"}'> class="currentBtn"</c:if>><a href="/admin/trReserve?tcApproval=2">취소</a></li>
                                    </ul>
                                </div>
                                <div id="tabBody" class="tabBody">
                                    <ul>
                                        <!-- 예약승인대기 -->
                                        <li class="tabCot">
                                            <!-- search_wrap -->
                                            <section class="search_wrap m-t-30">
                                                <div class="form_group w230">
                                                    <input type="text" id="tcDay"
                                                        class="form_control dateicon datefromto" placeholder="예약기간 선택"
                                                        name="tcDay" autocomplete="off" />
                                                </div>
                                                <div class="form_group w300">
                                                    <input type="text" id="search" class="form_control"
                                                        placeholder="예약번호/사업자번호/회사명 입력" name="search" autocomplete="off" />
                                                </div>
                                                <div class="form_group">
                                                    <!-- <label for="se1">검색선택</label> -->
                                                    <div id="tracklist" class="select_group">
                                                    </div>
                                                </div>
												<div id="searchTcApproval" class="form_group m-r-10" style="display:none">
													<div class="check_inline">
														<span class="label">상태</span> <label class="check_default">
															<input type="checkbox" name="tcApproval" id="tcApproval1"
															value="1" checked="checked" /> <span class="check_icon"></span>승인반려
														</label> <label class="check_default"> <input type="checkbox"
															name="tcApproval" id="tcApproval2" value="2" checked="checked" />
															<span class="check_icon"></span>예약취소
														</label>
													</div>
												</div>
                                                <button type="button" id="searchBtn" class="btn-s btn_default">조회</button>
                               					<button type="button" class="btn-s btn_default" id="initBtn">검색초기화</button>
                                            </section>
                                            <!-- //search_wrap -->
                                            <!-- table list -->
                                            <section class="tbl_wrap_list m-t-15">
                                                <table class="tbl_list" summary="예약승인대기목록테이블 입니다. 항목으로는 NO, 예약번호, 접수일자, 시험일자, 회사명, 항목, 유형등이 있습니다">
                                                    <caption>예약승인대기목록테이블</caption>
                                                    <colgroup>
                                                        <col width="80px" />
                                                        <col width="" />
                                                        <col width="" />
                                                        <col width="" />
                                                        <col width="" />
                                                        <col width="" />
                                                        <col width="" />
                                                        <col width="" />
                                                    </colgroup>
                                                    <thead>
                                                        <tr>
                                                            <th scope="col">NO</th>
                                                            <th scope="col">예약번호</th>
                                                            <th scope="col"><button id="order3">접수일자</button>
                                                            </th>
                                                            <th scope="col"><button id="order1">시험일자</button>
                                                            </th>
                                                            <th scope="col">회사명</th>
                                                            <th scope="col">평가트랙</th>
                                                            <th scope="col"><button id="order5">유형</button></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="tbody">
												    <c:if test="${fn:length(trReserveList.rows) eq 0 }">
												        <tr class="tr_nodata">
												        	<td colspan="7">데이터가 존재하지 않습니다.</td>
												        </tr>
												    </c:if>
												    <c:if test="${fn:length(trReserveList.rows) > 0 }">
													    <c:forEach var="result" items="${trReserveList.rows}" varStatus="status">
                                                        <tr onmouseover="this.className='on godetail'"
                                                            onmouseout="this.className=''">
                                                            <td><span style="display:none">${result.tcSeq}</span>${totalCnt - (paging.pageNo-1)*paging.pageSize - status.index }</td>
                                                            <td>${result.tcReservCode }</td>
                                                            <td><c:set var="tcRegDt" value="${result.tcRegDt}"/>${fn:substring(tcRegDt,0,4) }.${fn:substring(tcRegDt,4,6) }.${fn:substring(tcRegDt,6,8) }</td>
											                <td>
											                	<c:if test='${result.tcDay eq result.tcDay2}'><c:set var="tcDay" value="${result.tcDay}"/><span>${fn:substring(tcDay,0,4) }.${fn:substring(tcDay,4,6) }.${fn:substring(tcDay,6,8) }</span></c:if>
											                	<c:if test='${result.tcDay ne result.tcDay2}'>
												                	<c:set var="tcDay" value="${result.tcDay}"/><span>${fn:substring(tcDay,0,4) }.${fn:substring(tcDay,4,6) }.${fn:substring(tcDay,6,8) }</span> ~<br />
												                	<c:set var="tcDay2" value="${result.tcDay2}"/>${fn:substring(tcDay2,0,4) }.${fn:substring(tcDay2,4,6) }.${fn:substring(tcDay2,6,8) }
											                	</c:if>
											                </td>
											                <td>
											                	<c:if test="${result.compCode eq 'THINT' }">한국타이어</c:if><c:if test="${result.compCode ne 'THINT' }">${result.compName }</c:if>
											                	<c:if test="${result.blackList eq 'Y' }"><br /><span class="color_red">(B/L)</span></c:if>
											                </td>
											                <td>${fn:replace(result.trTrackNickName, '#', '<br />') }</td>
											                <td>
												                <c:if test="${result.trTrackType eq 'TYP00'}">공동</c:if>
																<c:if test="${result.trTrackType eq 'TYP01'}">단독</c:if>
																<c:if test="${result.trTrackType eq 'TYP02'}">시험</c:if>
																<c:if test="${result.trTrackType eq 'TYP03'}">연습</c:if>
																<c:if test="${result.trTrackType eq 'TYP04'}">점검</c:if>
																<c:if test="${result.trTrackType eq 'TYP05'}">시승</c:if>
																<c:if test="${result.trTrackType eq 'TYP06'}">사내방문</c:if>
																<c:if test="${result.trTrackType eq 'TYP07'}">테스트</c:if>
																<c:if test="${result.trTrackType eq 'TYP99'}">기타</c:if>
											                </td>
                                                        </tr>
                                                        </c:forEach>
                                                    </c:if>
                                                    </tbody>
                                                </table>
                                            </section>
                                            <!-- //table list -->
                                            <!-- Pagination -->
                                            <section id="pagingc" class="pagination m-t-30">
						    				<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp"/>
                                            </section>
                                            <!-- //Pagination -->
                                        </li>
                                        <!-- //예약승인대기 -->
                                    </ul>
                                </div>
                            </div>
                            <!-- //tab2 -->
                        </div>
                        <!-- //tab1-시험로 -->
                    </div>
                </div>
                <!-- //tab -->
            </div>
            <!-- //content -->
        </div>
        <!-- //container -->
<span id="pageNo" style="display:none"></span>
<span id="tcSeq" style="display:none"></span>
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>