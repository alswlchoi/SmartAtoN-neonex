<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
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
	    timePicker: false,                        // 시간 노출 여부
	    showDropdowns: true,                     // 년월 수동 설정 여부
	    autoApply: true,                         // 확인/취소 버튼 사용여부
	    timePicker24Hour: true,                  // 24시간 노출 여부(ex> true : 23:50, false : PM 11:50)
	    timePickerSeconds: true,                 // 초 노출 여부
	    singleDatePicker: false                   // 하나의 달력 사용 여부
	});
	
	$("#tcDay2").daterangepicker({
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
	    timePicker: false,                        // 시간 노출 여부
	    showDropdowns: true,                     // 년월 수동 설정 여부
	    autoApply: true,                         // 확인/취소 버튼 사용여부
	    timePicker24Hour: true,                  // 24시간 노출 여부(ex> true : 23:50, false : PM 11:50)
	    timePickerSeconds: true,                 // 초 노출 여부
	    singleDatePicker: false                   // 하나의 달력 사용 여부
	});
	//daterangepiker end
	
	$("#data_area").hide();	//페이지 로딩시 등록/수저폼 가림
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
	
	$(document).on("click",'#listBtn' ,function(){
		$("#data_area").hide();
		search("list");
	});
});	

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

function getCanDay(){
	var now = new Date();	// 현재 날짜 및 시간
	var date = new Date(new Date().setDate(now.getDate()));	// 30일 후
    var year = date.getFullYear();
    var month = ("0" + (1 + date.getMonth())).slice(-2);
    var day = ("0" + date.getDate()).slice(-2);

    return year+"-"+month+"-"+day;
}

function search(type){
	var pageNo;
	var compName = $("#search").val();
	var tcDay = $("#tcDay").val();
	//var trTrackCode = $("#trTrackCode").val();
	
	var tcApproval = "3"; //승인완료 전용페이지
	if($("#btn2").hasClass("active")){	//시험완료가 선택된 상태라면
		tcStep = "2";
	}else{
		tcStep = "1";
	}
	
	if(type == "list") {//목록 버튼
		pageNo = $("#pageNo").text();
		$("#data_detail").hide();
	}else if(type == "paging"){//페이징 검색
		pageNo = $(".pageNo.on").attr("data-page"); 
	}else{
		pageNo = "1";
	}
	
	if(pageNo == ""){
		pageNo = "1";
	}
	
	if(type == "init"){
		var today = getCanDay();
		var compName = "";
		var tcDay = today+" ~ "+today;
		$("#search").val("");
		$("#tcDay").val(tcDay);
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
				"tcStep":tcStep,
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
	var tcSeq = currentRow.find('td:eq(0) span').text();
	var tcDay = currentRow.find('td:eq(2) span').text();

	tcDay = tcDay.replace(/\./g, "")
	var tcStep = "${tcStep }";
	var pageNo = $(".pageNo.on").attr("data-page");

	if(undefinedChk(pageNo, "")==""){
		pageNo = "1";
	}
	
	$("#pageNo").html(pageNo);
	$("#tcSeq").text(tcSeq);

	location.href="/admin/trReserve/tring-detail?pageNo="+pageNo+"&tcStep="+tcStep+"&tcSeq="+tcSeq+"&tcDay="+tcDay;
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
		html += '<tr class="tr_nodata"><td colspan="9">데이터가 존재하지 않습니다.</td></tr>';
	}else{
		for(var list in rows){
			html += '<tr onmouseover="this.className=\'on godetail\'"onmouseout="this.className=\'\'">';
			html += '<td><span style="display:none">'+undefinedChk(rows[list].tcSeq,"")+'</span>';
			html += paging.totalCount-(paging.pageNo-1)*paging.pageSize-list;
			html += '</td>';
			html += '<td>'+undefinedChk(rows[list].tcReservCode,"")+'</td>';
			var tcDay = rows[list].tcDay.substring(0,4)+ "."+ rows[list].tcDay.substring(4,6)+ "."+ rows[list].tcDay.substring(6,8);
			var tcDay2 = rows[list].tcDay2.substring(0,4)+ "."+ rows[list].tcDay2.substring(4,6)+ "."+ rows[list].tcDay2.substring(6,8);
			if(tcDay==tcDay2){
				html += '<td><span>'+tcDay+'</span></td>';
			}else{
				html += '<td>';
				html += '<span>'+tcDay+'</span> ~<br />'+tcDay2;
				html += '</td>';
			}
			html += '<td>';
			if(undefinedChk(rows[list].compCode,"")=="THINT"){
				html += '<span class="color_orange">한국타이어<br />';
				var rmArr = rows[list].rmList;
				var dname = ""
				for(index in rmArr){
					if(parseInt(index) == 0){
						dname = rmArr[index].dname;
					}else{
						if(dname.indexOf(rmArr[index].dname)<0){
							dname += ", "+rmArr[index].dname;
						}
					}
				}
				html += '('+dname+')';
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
			}else if(trTrackType=="TYP02") {
				html += '점검';
			}else if(trTrackType=="TYP02") {
				html += '시승';
			}
			html += '</td>';
			html += '<td>';
			var carArr = new Array();
			carArr = undefinedChk(rows[list].carList, "");
			for(var carlist in carArr) {
				var carInfo = carArr[carlist];
				if(carlist > 0){
					html += '<br />';
				}
				html += carInfo.cname;
				if(undefinedChk(carInfo.rid, "")!=""){
					html += " ("+carInfo.rid+")";				
				}
				if(carInfo.ctype=="S"){
					html += '<span class="color_red"> - 특수차량</span>';
				}
			}
			rmArr = undefinedChk(rows[list].rmList,"");
			if(rmArr!=null){
				var driverStr = "";
				var widStr = "";
				
				for(var rmi in rmArr) {
					var rmInfo = undefinedChk(rmArr[rmi], "");

					if(rmi > 0) {
						driverStr += "<br />";
						widStr += "<br />";
					}
					driverStr += undefinedChk(rmInfo.dname, "");
					if(undefinedChk(rmInfo.rid, "")!=""){
						driverStr += " (" +undefinedChk(rmInfo.rid, "")+")";
					}
					widStr += undefinedChk(rmInfo.wid, "");
				}

				html += '<td>'
				html += widStr;
				html += '</td>';
				html += '<td>';
				html += driverStr;
				html += '</td>';
			}
			html += '</td>';
			html += '</tr>';
		}
	}
	html += '</table>';
	$("#tbody").html(html);
}
</script>
        <div id="container">
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시험관리</span><span>시험로 시험관리</span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">시험로 시험관리</h2>
                <!-- //title -->

                <!-- tab -->
                <div class="wrap_tab">
                    <div class="tab">
                        <button class="tablinks<c:if test='${tcStep eq "1"}'> active</c:if>" onclick="location.href='/admin/trReserve/trlisting'" id="btn1">시험중</button>
                        <button class="tablinks<c:if test='${tcStep eq "2"}'> active</c:if>"  onclick="location.href='/admin/trReserve/trlisting?tcStep=2'" id="btn2">시험완료</button>
                    </div>
                    <div class="wrap_tabcontent">
                            <div class="webwidget_tab" id="webwidget_tab">
							   <!-- 상세보기 시작 -->
							   <div id="data_detail" style="margin-top:40px">
							   </div>
							   <!-- 상세보기 끝 -->
                                <div id="tabBody" class="tabBody">
                                    <ul>
                                        <!-- 예약승인대기 -->
                                        <li class="tabCot">
                                            <!-- search_wrap -->
                                            <section class="search_wrap m-t-30">
                                                <div class="form_group w230">
                                                    <input type="text" id="tcDay"
                                                        class="form_control dateicon datefromto" placeholder="예약기간 선택"
                                                        name="tcDay" />
                                                </div>
                                                <div class="form_group w300">
                                                    <input type="text" id="search" class="form_control"
                                                        placeholder="예약번호/사업자번호/회사명 입력" name="search" autocomplete="off" />
                                                </div>
                                                <div class="form_group">
                                                    <%--<div id="tracklist" class="select_group"></div> --%>
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
                                                <table class="tbl_list" summary="예약승인대기목록테이블 입니다. 항목으로는 번호, 예약번호, 시험일자, 회사명, 항목, 유형, 차량 RFID, 무전기, 운전자 RFID등이 있습니다">
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
                                                            <th scope="col">번호</th>
                                                            <th scope="col">예약번호</th>
                                                            <th scope="col">시험일자</th>
                                                            <th scope="col">회사명</th>
                                                            <th scope="col">평가트랙</th>
                                                            <th scope="col">유형</th>
                                                            <th scope="col">차량 RFID</th>
                                                            <th scope="col">무전기</th>
                                                            <th scope="col">운전자 RFID</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="tbody">
												    <c:if test="${fn:length(trReserveList.rows) eq 0 }">
												        <tr class="tr_nodata">
												        	<td colspan="9">데이터가 존재하지 않습니다.</td>
												        </tr>
												    </c:if>
												    <c:if test="${fn:length(trReserveList.rows) > 0 }">
													    <c:forEach var="result" items="${trReserveList.rows}" varStatus="status">
                                                        <tr onmouseover="this.className='on godetail'"
                                                            onmouseout="this.className=''">
                                                            <td><span style="display:none">${result.tcSeq}</span>${totalCnt - (paging.pageNo-1)*paging.pageSize - status.index }</td>
                                                            <td>${result.tcReservCode }
                                                            	<c:if test="${result.compCode eq 'THINT'}">
                                                            		<br /><span class="color_red">${result.tcRequestNumber }</span>
                                                            	</c:if>
                                                            </td>
											                <td>
											                	<c:if test='${result.tcDay eq result.tcDay2}'><span>${result.tcDay }</span></c:if>
											                	<c:if test='${result.tcDay ne result.tcDay2}'>
												                	<c:set var="tcDay" value="${result.tcDay}"/><span>${fn:substring(tcDay,0,4) }.${fn:substring(tcDay,4,6) }.${fn:substring(tcDay,6,8) }</span> ~<br />
												                	<c:set var="tcDay2" value="${result.tcDay2}"/>${fn:substring(tcDay2,0,4) }.${fn:substring(tcDay2,4,6) }.${fn:substring(tcDay2,6,8) }
											                	</c:if>
											                </td>
											                <td>
											                	<c:if test="${result.compCode eq 'THINT' }">
											                		<span class="color_red">한국타이어<br />(
											                		<c:forEach var="rmResult" items="${result.rmList}" varStatus="rmStatus">
											                			<c:if test="${rmStatus.index ne 0 }">, </c:if>${rmResult.DName }
											                		</c:forEach>
											                		)</span>											                	
											                	</c:if><c:if test="${result.compCode ne 'THINT' }">${result.compName }</c:if>
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
											                <td>
											                <c:forEach var="carresult" items="${result.carList }" varStatus="carstatus">
												                <c:if test="${carstatus.index > 0}"><br /></c:if>
												                ${carresult.CName }<c:if test="${carresult.RId ne '' && !empty carresult.RId}"> (${carresult.RId })</c:if>
												                <c:if test="${carresult.CType eq 'S' }">
																	<span class="color_red"> - 특수차량</span>
																</c:if>
											                </c:forEach>
											                </td>
											                <c:set var="driverStr" />
											                <c:set var="widStr" />
											                <c:forEach var="rmresult" items="${result.rmList }" varStatus="rmstatus">
											                	<c:if test="${rmstatus.index > 0}">
													                <c:set var="driverStr" value="${driverStr }<br />" />
													                <c:set var="widStr" value="${widStr }<br />" />
													            </c:if>
												                <c:set var="driverStr" value="${driverStr } ${rmresult.DName }" />
												                <c:if test="${rmresult.RId ne '' && !empty rmresult.RId}">
												                	<c:set var="driverStr" value="${driverStr } (${rmresult.RId })" />
												                </c:if>												                
												                <c:set var="widStr" value="${widStr } ${rmresult.WId }" />
											                </c:forEach>
											                <td>
											                	${widStr }
											                </td>
											                <td>
											                	${driverStr }
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
                    </div>
                </div>
            </div>
            <!-- //content -->
        </div>
        <!-- //container -->
		<script type="text/javascript">
	    function goList(kind){
	    	if(kind=="1"){
			   $("#btn1").addClass("active");
			   $("#btn2").removeClass("active");
	    	}else{
			   $("#btn1").removeClass("active");
			   $("#btn2").addClass("active");
	    	}
	
	    	search("button");
	    }
		</script>
<span id="pageNo" style="display:none">${paging.pageNo }</span>
<span id="tcSeq" style="display:none"></span>
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>