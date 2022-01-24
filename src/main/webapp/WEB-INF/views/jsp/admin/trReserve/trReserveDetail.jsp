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

function getWeekDay() {
var param = {
   tcDay: moment().format('YYYYMM')
 };
 asyncPostAjax("/user/trReserve/search-weekday", param,"setDisable", null, null, null);
} 

var wdDay = "";
var dayOff = new Array();
getWeekDay();

$(document).ready(function(){
	$('#tcDay2').daterangepicker({
	   //minDate: moment().add(+30, 'day'),
	   //startDate: moment().add(+30, 'day'),
	   endDate: moment(),
	   autoApply: true,
	   autoUpdateInput: false,
	   locale: {
	       monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
	       daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
	       yearSuffix: '년',
	       separator:" ~ ",
	       format: 'YYYY-MM-DD'
	     },
	   isInvalidDate: function(date) {

	       var resultVal = false;

	       dayOff.every( ( test, i, self ) => {
	           // i=i+1;
	           // console.log('i='+i);
	           if( (date>=moment(test.start)) && (date<=moment(test.end))){
	               resultVal = true;
	           }
	           return true;
	       });

	       if(resultVal){
	           return true;
	       }
	       else{
	           return false;
	       }
	   }
	 });
	//등록/수정버튼 이벤트
	$(document).on("click", "#btn_regi", function () {
		var tcSeq = "${trReserve.tcSeq}";
		var tcDay = $("#tcDay2").val();
		var tcMemo = $("#tcMemo").val();

		var data ={
			tcSeq : tcSeq,
			tcDay : tcDay,
			tcMemo : tcMemo
		};
		
		postAjax("/admin/trReserve/update-trReserve",data,"successUpdate","",null,null);
	});	

  	//시험로 selectbox
  	$.ajax({
  		url : "/admin/trReserve/track-list",
  		type : "get",
  		data : {},
  		success : function(resdata){
  			drawTrackSelect(resdata.trackList);
  		},
  		error : function(e){
  			console.log(e);
  		}
  	}); 
	
	$(document).on("click",'#addTrBtn' ,function(){
		if($("select[name=trTrackCode] option:eq(0)").is(":selected")){
			alert('시험로를 선택해 주세요.');
		}else{
			var tcSeq = "${trReserve.tcSeq}";
			var trTrackCode =  $("select[name=trTrackCode]").val();
			var param = {
				"tcSeq":tcSeq,
				"trTrackCode":trTrackCode
			};
			console.log(JSON.stringify(param));
			postAjax("/admin/trReserve/add-trackinfo", param,"succAddTrack", null, null, null);
		}
	});   
});

function successUpdate(data){
	if(data.code > 0){
		alert(data.message);
		$(document).on("click",'.lyClose' ,function(){
			history.back();
		});
	}else{
		alert(data.message);
	}
}

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

$(document).on("click", "#btnCancel", function () {
	var con = confirm("취소하시면 처음부터 다시 진행해야 됩니다.\n진행 하시겠습니까?");
	$("#confirmTrue").click(function(){
		history.back();
	});
});

//조회값 undefined -> 공백 처리
function undefinedChk(str1, str2){
	if( str1 == "" || str1 == null || typeof str1 == undefined || str1 == undefined || ( str1 != null && typeof str1 == "object" && !Object.keys(str1).length ) ){
		return str2;
	}else{
		return str1;
	}
}

function succAddTrack(resdata){
	alert(resdata.message);
	if(resdata.code=="200"){
		$(".lyClose").click(function(){
			location.reload();
		});	
	}
}

$(document).on("click","#goApproval",function(){
	var tcSeq = "${trReserve.tcSeq}";
	var tcApproval = "3";	//승인
	var tcMemo = $("#tcMemo").val();

	var data ={
		tcSeq : tcSeq,
		tcApproval : tcApproval,
		tcMemo : tcMemo
	};

	postAjax("/admin/trReserve/update-approval-suc",data,"successUpdate","",null,null);
});

$(document).on("click","#goReturn",function(){
	var tcSeq = "${trReserve.tcSeq}";
	var tcApproval = "2";	//취소
	var tcMemo = $("#rtnRsn").val();

	var data ={
		tcSeq : tcSeq,
		tcApproval : tcApproval,
		tcMemo : tcMemo
	};

	postAjax("/admin/trReserve/update-approval-return",data,"successUpdate","",null,null);
});

function replaceBrTag(str) {
    str = str.replace(/\r\n/ig, '\r\n');
    str = str.replace(/\\n/ig, '\r\n');
    str = str.replace(/\n/ig, '\r\n');
    str = str.replace(/(<br>|<br\/>|<br \/>)/g, '\r\n');
    return str;
}

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

function setDisable(list){
 if (list.weekday.length > 0) {
   for (var i in list.weekday) {
     var data = list.weekday[i];
     
     var wdDayStr =  data.wdDay
     var now = new Date();
     var daysOfYear = [];
     
     var begin = new Date(changeDate(data.wdStDt));
     var end = new Date(changeDate(data.wdEdDt));

     for (;begin < end; begin.setDate(begin.getDate()+1)) {
    	 if(wdDayStr.indexOf(begin.getDay())<0){
    		 var date = convertDateFormat(begin);
    		 dayOff.push({
               start: date,
               end: date
             });
    	 }
     }
   }
 }

 if (list.dayOff.length > 0) {
   for (var i in list.dayOff) {
     var data = list.dayOff[i];
     dayOff.push({
       start: changeDate(data.doStDay),
       end: changeDate(data.doEdDay)
     });
   }
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
				html += '한국타이어';
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

//트랙 정보 selectbox 생성
function drawTrackSelect(trackList, currentTid){
	var html='';
	html += '<select name="trTrackCode" id="trTrackCode" class="form_control">';
	html += '<option value="">트랙선택</option>';
	for(var list in trackList){
		html += '<option value="'+undefinedChk(trackList[list].tid,"")+'">'+undefinedChk(trackList[list].tname,"")+'</option>';
	}
	html += '</select>';
	$("#trackInfo").html(html)
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
                                        <li id="btn1"<c:if test='${trReserve.tcApproval eq "0"}'> class="currentBtn"</c:if>><a href="/admin/trReserve?tcApproval=0">예약승인대기</a></li>
                                        <li id="btn2"<c:if test='${trReserve.tcApproval eq "2"}'> class="currentBtn"</c:if>><a href="/admin/trReserve?tcApproval=2">취소</a></li>
                                    </ul>
                                </div>
							   <!-- 상세보기 -->
							   <div id="data_detail" style="margin-top:40px">
							   <c:set var="trackInfoHtml" value="" />
							   <c:forEach var="result" items="${trReserve.trackInfo }" varStatus="status">
									<c:if test="${fn:indexOf(trackInfoHtml, result.trTrackNickName) < 0 }">
							   			<c:set var="trackInfoHtml" value="${trackInfoHtml }${result.trTrackNickName }<br />" />
									</c:if>
									<c:if test="${trReserve.tcDay ne trReserve.tcDay2 }">
										<c:set var="tcDay" value="${fn:substring(result.tcDay,0,4) }-${fn:substring(result.tcDay,4,6) }-${fn:substring(result.tcDay,6,8) }" />
										<c:if test="${fn:indexOf(realtcDay, tcDay)<0 }">
											<c:set var="realtcDay" value="${realtcDay } / ${fn:substring(result.tcDay,0,4) }-${fn:substring(result.tcDay,4,6) }-${fn:substring(result.tcDay,6,8) }" />
										</c:if>
									</c:if>
									<c:set var="trTrackType" value="${result.trTrackType }" />
								</c:forEach>
								
								<div class="wrap_accordion2 m-t-30">
									<button class="accordion open">								
									   <h3 class="stitle disib vam0">시험유형 – 
									   <c:if test='${trTrackType=="TYP00" }'>공동</c:if>
									   <c:if test='${trTrackType=="TYP01" }'>단독</c:if>
									   <c:if test='${trTrackType=="TYP02" }'>시험</c:if>
									   <c:if test='${trTrackType=="TYP03" }'>연습</c:if>
									   <c:if test='${trTrackType=="TYP04" }'>점검</c:if>
									   <c:if test='${trTrackType=="TYP05" }'>시승</c:if>
									   <c:if test='${trTrackType=="TYP06" }'>사내방문</c:if>
									   <c:if test='${trTrackType=="TYP07" }'>테스트</c:if>
									   <c:if test='${trTrackType=="TYP99" }'>기타</c:if>
									   </h3>
									</button>
									<!-- 예약 테이블 시작 -->
									<div class="accordion_panel" style="display: block;">
										<section class="tbl_wrap_list">
											<table id="data_table" class="tbl_list" summary="예약 테이블입니다. 항목으로는 예약번호, 접수일자, 시험일자, 회사명, 항목, 유형, 진행상태등이 있습니다.">
												<caption>예약 테이블</caption>
												<colgroup>
                                                    <col width="150px">
                                                    <col width="150px">
                                                    <col width="">
                                                    <col width="180px">
                                                    <col width="340px">
                                                    <col width="130px">
                                                    <col width="130px">
                                                </colgroup>
												<thead>		
												<tr>		
												<th>예약번호</th><th>접수일자</th><th>시험일자</th><th>회사명</th><th>평가트랙</th><th>유형</th><th>진행상태</th>
												</tr>
												</thead>		
												<tbody>
												<td>${trReserve.tcReservCode }</td>			
												<td>
													<c:set var="tcRegDt" value="${trReserve.tcRegDt }" />
													${fn:substring(tcRegDt,0,4) }.${fn:substring(tcRegDt,4,6) }.${fn:substring(tcRegDt,6,8) }
												</td>
												<td>
													<c:set var="tcDay" value="${trReserve.tcDay }" />
													<c:set var="tcDay2" value="${trReserve.tcDay2 }" />
													<div class="form_group w230"><input type="text" id="tcDay2" class="form_control dateicon datefromto"
														placeholder="예약기간 선택" name="tcDay" value="${fn:substring(tcDay,0,4) }-${fn:substring(tcDay,4,6) }-${fn:substring(tcDay,6,8) } ~ ${fn:substring(tcDay2,0,4) }-${fn:substring(tcDay2,4,6) }-${fn:substring(tcDay2,6,8) }" autocomplete="off"/>
													</div>
													<c:if test="${!empty(realtcDay)}"><div style="padding-top:5px"><span class="color_orange">실제사용일 </span>${realtcDay}</div></c:if>
												</td>
												<td>	
													${trReserve.compName }
													<c:if test='${trReserve.blackList =="Y"}'><br /><span class="color_red">(B/L)</span></c:if>
												</td>
												<td>
													${trackInfoHtml }
													<c:set var="tcApproval" value="${trReserve.tcApproval }" />
													<c:if test='${tcApproval eq "0" or tcApproval eq "3" }'><br />
		                                            <div class="trdiv form_group w170" style="padding-left:20px">
														<div id="trackInfo" class="select_group"></div>
													</div>
													<button type="button" id="addTrBtn" class="btn-line btn_gray">시험로 +</button>
													</c:if>
												</td>
												<td>
													<c:if test='${trTrackType=="TYP00" }'>공동</c:if>
													<c:if test='${trTrackType=="TYP01" }'>단독</c:if>
													<c:if test='${trTrackType=="TYP02" }'>시험</c:if>
													<c:if test='${trTrackType=="TYP03" }'>연습</c:if>
													<c:if test='${trTrackType=="TYP04" }'>점검</c:if>
													<c:if test='${trTrackType=="TYP05" }'>시승</c:if>
													<c:if test='${trTrackType=="TYP06" }'>사내방문</c:if>
													<c:if test='${trTrackType=="TYP07" }'>테스트</c:if>
													<c:if test='${trTrackType=="TYP99" }'>기타</c:if>
												</td>
												<td id="appTxt">
													<c:if test='${tcApproval=="0" }'>승인대기</c:if>
													<c:if test='${tcApproval=="1" }'><span class="color_red">예약취소</span><br /><button type="button" class="btn-line-s btn_gray" data-layer="reason_result">사유보기</button></c:if>
													<c:if test='${tcApproval=="2" }'>예약취소</c:if>
													<c:if test='${tcApproval=="3" }'>승인완료</c:if>
												</td>
												</tbody>
											</table>
										</section>
									</div>
									<!-- //예약 테이블 -->
								</div>
								
								<div class="wrap_accordion2 m-t-30">
									<button id="divCalendar" class="accordion">
									   <h3 class="stitle disib vam0">시험예약 상세보기</h3>
									</button>
									<div id="calendar" class="accordion_panel">
										<iframe id="iframe" src="/admin/trReserve/trcalendar?viewKind=detail" frameborder="0" width="100%" height="1100px" scrolling="no"
											marginwidth="0" marginheight="0"></iframe>
									</div>
								</div>
								
								<div class="wrap_accordion2 m-t-30">
									<button class="accordion open">
									   <h3 class="stitle disib vam0">시험정보</h3>
									</button>
									<div class="accordion_panel" style="display: block;">
										<section class="tbl_wrap_view">
											<table class="tbl_view01" id="data_table1" summary="시험 정보테이블입니다. 항목으로는 운전자, 시험차종, 시험종류 및 방법등이 있습니다.">
											    <caption>시험 정보테이블</caption>
											    <colgroup>
												     <col width="180px;" />
												     <col width="" />
												 </colgroup>
												<tbody>
												<tr><th scope="row">운전자</th><td>${driver }</td></tr>
												<tr><th scope="row">시험차종</th>
												<td>
												<c:forEach var="result" items="${trReserve.carInfo }" varStatus="status">
													${result.CVender } ${result.CName } (${result.CNumber } / ${result.CColor })
													<c:if test='${result.CType =="S" }'>
														<span class="color_red"> - 특수차량</span>
													</c:if>
													<br />
												</c:forEach>
												</td>
												</tr>
												<tr>
													<th scope="row">시험종류 및 방법</th>
													<td>
														<% pageContext.setAttribute("newLineChar", "\n"); %>
														${fn:replace(trReserve.tcPurpose, newLineChar, "<br />")}
													</td>
												</tr>
											</tbody>
											</table>
										</section>
									</div>
								</div>
								
								<c:if test='${company.compCode ne "THINT"}'>
								<div class="wrap_accordion2 m-t-30">
								<button class="accordion open">
								   <h3 class="stitle disib vam0">예약 담당자 및 회계 담당자 정보</h3>
								</button>
								<div class="accordion_panel" style="display: block;">
									<section class="tbl_wrap_view">	
										<table class="tbl_view01" id="data_table1" summary="예약 담당자 및 회계 담당자 정보테이블입니다. 항목으로는 운전자, 시험차종, 시험종류 및 방법등이 있습니다.">
										   <caption>예약 담당자 및 회계 담당자 정보테이블</caption>
										   <colgroup>
											    <col width="180px;" />
											    <col width="" />
											    <col width="180px;" />
											    <col width="" />
											</colgroup>
											<tbody>
												<tr>
													<th scope="row">회사명</th>
													<td>${company.compName }
													<c:if test='${company.blackList eq "Y"}'>
														 <span class="color_red">(B/L)</span>	
													</c:if>
													</td>
													<th scope="row">사업자번호</th>
													<td>
													<c:set var="lic" value="${company.compLicense }" />
													<c:if test='${lic ne ""}'>
														${fn:substring(lic,0,3) }-${fn:substring(lic,3,5) }-${fn:substring(lic,5,8) }
													</c:if>
													</td>
												</tr>
												<tr>
													<th scope="row">예약담당자</th><td>${company.memName}</td>
													<th scope="row">부서</th><td>${company.memDept}</td>
												</tr>
												<tr>
													<th scope="row">휴대폰번호</th>
													<td>
														<c:set var="memPhone" value="${company.memPhone}" />
														${fn:substring(memPhone,0,3)}-${fn:substring(memPhone,3,7)}-${fn:substring(memPhone,7,11)}
													</td>
													<th scope="row">전화번호</th>
													<td>
				                               		<c:set var='compPhone' value='${company.compPhone }' />
				                                    <c:if test='${compPhone != "" }'>
														<c:if test='${fn:substring(compPhone,0,2) =="02" or fn:length(compPhone) lt 10 }'>
															<c:if test='${fn:length(compPhone)==10 }'>
																${fn:substring(compPhone,0,2) }-${fn:substring(compPhone,2,6) }-${fn:substring(compPhone,6,10) }
															</c:if>
															<c:if test='${fn:length(compPhone)!=10 }'>
																${fn:substring(compPhone,0,2) }-${fn:substring(compPhone,2,5) }-${fn:substring(compPhone,5,10) }
															</c:if>
														</c:if>
														<c:if test='${fn:substring(compPhone,0,3) =="010" }'>
															${fn:substring(compPhone,0,3) }-${fn:substring(compPhone,3,7) }-${fn:substring(compPhone,7,11) }
														</c:if>
														<c:if test='${fn:substring(compPhone,0,2) !="02" && fn:substring(compPhone,0,3) !="010" }'>
															<c:if test='${fn:length(compPhone)==10 }'>
																${fn:substring(compPhone,0,2) }-${fn:substring(compPhone,2,6) }-${fn:substring(compPhone,6,10) }
															</c:if>
															<c:if test='${fn:length(compPhone)==11 }'>
																${fn:substring(compPhone,0,3) }-${fn:substring(compPhone,3,7) }-${fn:substring(compPhone,7,11) }
															</c:if>
															<c:if test='${fn:length(compPhone)==12 }'>
																${fn:substring(compPhone,0,4) }-${fn:substring(compPhone,4,8) }-${fn:substring(compPhone,8,12) }
															</c:if>
														</c:if>
													</c:if>
				                                </td>
												</tr>
												<tr>
													<th scope="row">이메일주소</th>
													<td colspan="3">${company.memEmail}</td>
												</tr>
												<tr>
													<th scope="row">회계담당자</th>
													<td>${company.compAcctName}</td>
													<th scope="row">부서</th>
													<td>${company.compAcctDept}</td>
												</tr>
												<tr>
													<th scope="row">이메일주소</th>
													<td>${company.compAcctEmail}</td>
													<th scope="row">전화번호</th>
													<td>
				                               		<c:set var='compAcctPhone' value='${company.compAcctPhone }' />
				                                    <c:if test='${compAcctPhone != "" }'>
														<c:if test='${fn:substring(compAcctPhone,0,2) =="02" }'>
															<c:if test='${fn:length(compAcctPhone)==10 }'>
																${fn:substring(compAcctPhone,0,2) }-${fn:substring(compAcctPhone,2,6) }-${fn:substring(compAcctPhone,6,10) }
															</c:if>
															<c:if test='${fn:length(compAcctPhone)!=10 }'>
																${fn:substring(compAcctPhone,0,2) }-${fn:substring(compAcctPhone,2,5) }-${fn:substring(compAcctPhone,5,10) }
															</c:if>
														</c:if>
														<c:if test='${fn:substring(compAcctPhone,0,3) =="010" }'>
															${fn:substring(compAcctPhone,0,3) }-${fn:substring(compAcctPhone,3,7) }-${fn:substring(compAcctPhone,7,11) }
														</c:if>
														<c:if test='${fn:substring(compAcctPhone,0,2) !="02" && fn:substring(compAcctPhone,0,3) !="010" }'>
															<c:if test='${fn:length(compAcctPhone)==10 }'>
																${fn:substring(compAcctPhone,0,2) }-${fn:substring(compAcctPhone,2,6) }-${fn:substring(compAcctPhone,6,10) }
															</c:if>
															<c:if test='${fn:length(compAcctPhone)==11 }'>
																${fn:substring(compAcctPhone,0,3) }-${fn:substring(compAcctPhone,3,7) }-${fn:substring(compAcctPhone,7,11) }
															</c:if>
															<c:if test='${fn:length(compAcctPhone)==12 }'>
																${fn:substring(compAcctPhone,0,4) }-${fn:substring(compAcctPhone,4,8) }-${fn:substring(compAcctPhone,8,12) }
															</c:if>
														</c:if>
													</c:if>
				                                </td>
											</tr>
										</tbody>
									</table>
								</section>
							</div>	
						</div>
						</c:if>	

								<div class="wrap_accordion2 m-t-30">
									<button class="accordion open">
									   <h3 class="stitle disib vam0">관리자 메모</h3>
									</button>
									<div class="accordion_panel" style="display: block;">
										<section class="tbl_wrap_view">	
										<table class="tbl_view01" id="data_table1" summary="관리자 메모테이블입니다.">
										   <caption>관리자 메모</caption>
										   <colgroup>
											    <col width="180px;" />
											    <col width="" />
											</colgroup>
											<tbody>
												<tr>
													<th scope="row">관리자 메모</th><td>
													<div class="form_group w_full">
														<textarea name="tcMemo" id="tcMemo" cols="" rows="5"
															class="form_control  h100" placeholder="메모를 입력하세요." maxlength="100">${trReserve.tcMemo}</textarea>
													</div>	
													</td>	
												</tr>
											</tbody>
										</table>
										</section>
									</div>
								</div>
								
								<section class="btn_wrap m-t-50">
								    <button type="button" class="btn btn_gray" onclick="history.back()">목록</button>
								    <section>
								        <button type="button" id="btnCancel" class="btn btn_gray m-r-6" data-layer="cancel">취소</button>
								        <button type="button" id="btn_regi" class="upd btn btn_default">저장</button>
								    </section>
								</section>
								
								<c:if test='${tcApproval eq "0" || tcApproval eq "3" }'>
									<section id="approvalWrap" class="btn_wrap tac m-t-0">
									    <button type="button" class="btn-line-b btn_gray m-r-6" data-layer="reason">예약 취소</button>
									<c:if test='${tcApproval eq "0"}'>
									    <button type="button" id="goApproval" class="btn-sb btn_default">예약승인</button>
									</section>
									</c:if>
								</c:if>
							   </div>
							   <!-- //상세보기 -->
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

<!-- popup_m -->
<div class="ly_group">
    <article class="layer_m reason">
        <!-- # 타이틀 # -->
        <h1>사유등록/보기</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <div class="info_text03">
                <p>선택한 항목에 대해<br />취소하시겠습니까?</p>
                <p>[사유등록]</p>
                <span class="info_ment_orange m-t-15 m-l-0">회원사에게 전송되는 정보이므로 등록 시 유의하시기 바랍니다.</span>
                <div class="form_group w_full m-t-10">
                    <textarea name="rtnRsn" id="rtnRsn" cols="" rows="5" class="form_control"
                        placeholder="취소 사유를 등록해 주세요." onkeyup="fnChkByte(this,'300')"></textarea>
                    <div class="count_txt"><span id="byteInfo">0</span> / 300 bytes</div>
                </div>
            </div>
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button>
            <button type="button" id="goReturn" class="btn-pop btn_default lyClose">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_m -->

 <!-- popup_m -->
 <div class="ly_group">
     <article class="layer_m reason_result">
         <!-- # 타이틀 # -->
         <h1>사유등록/보기</h1>
         <!-- # 컨텐츠 # -->
         <div class="ly_con">
             <div class="info_text03">
                 <p id="rtnReason"></p>
             </div>
         </div>
         <!-- 버튼 -->
         <div class="wrap_btn01">
             <!-- <button type="button" class="btn-pop btn_gray m-r-11">취소</button> -->
             <button type="button" class="btn-pop btn_default lyClose">확인</button>
         </div>
         <!-- # 닫기버튼 # -->
         <button data-fn="lyClose">레이어닫기</button>
     </article>
 </div>
 <!-- //popup_m -->
<span id="pageNo" style="display:none"></span>
<span id="tcSeq" style="display:none"></span>
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>