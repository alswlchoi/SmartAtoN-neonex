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
			   console.log('dayOffLength=='+dayOff.length);

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
	
	$(document).on("click",'#canBtn' ,function(){
		location.reload();
	});
	
	$(document).on("click",'#listBtn' ,function(){
		location.href="/admin/trReserve/trlist?pageNo=${pageNo}&tcStep=${trReserve.tcStep}";
	});
	
	//데이터 삭제
	$(document).on("click",'#btnAccounts' ,function(){

		var tcSeq = "${trReserve.tcSeq}";
		var compCode = "${trReserve.compCode}";		
		
		var param = {
			"tcSeq":tcSeq,
			"compCode"  :compCode
		};
		
		postAjax("/admin/trReserve/insert-accounts", param,"succ", null, null, null);
	});

	function succ(resdata){
		alert(resdata.message);
		if(resdata.code=="200"){
			$(".lyClose").click(function(){
				location.href="/admin/trReserve/trlisting";
			});	
		}
	}
	
	//등록/수정버튼 이벤트
	$(document).on("click", "#btn_regi", function () {
		var tcSeq = $("#tcSeq").text();
		var tcDay = $("#tcDay2").val();
		var tcMemo = $("#tcMemo").val();

		var data ={
			tcSeq : tcSeq,
			tcDay : tcDay,
			tcMemo : tcMemo
		};
		
		postAjax("/admin/trReserve/update-trReserve",data,"successUpdate","",null,null);
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
			postAjax("/admin/trReserve/add-trackinfo", param,"succAddTrack", null, null, null);
		}
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
});	

function successUpdate(data){
	if(data.code > 0){
		alert(data.message);
		$(document).on("click",'.lyClose' ,function(){
			location.href="/admin/trReserve/trlist";
		});
	}else{
		alert(data.message);
	}
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
	console.log(html);
	$("#trackInfo").html(html)
}

//조회값 undefined -> 공백 처리
function undefinedChk(str1, str2){
	if( str1 == "" || str1 == null || typeof str1 == undefined || str1 == undefined || ( str1 != null && typeof str1 == "object" && !Object.keys(str1).length ) ){
		return str2;
	}else{
		return str1;
	}
}

function succAddTrack(resdata){
	console.log(resdata);
	alert(resdata.message);
	if(resdata.code=="200"){
		$(".lyClose").click(function(){
			location.reload();
		});	
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
</script>
        <div id="container">
            <!-- content -->
            <div class="content"><!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시험관리</span><span>스케쥴관리</span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">스케쥴관리</h2>
                <!-- //title -->

                <!-- tab -->
                <div class="wrap_tab">
                    <div class="tab">
                        <button class="tablinks active" onclick="location.href='/admin/trReserve/trcalendar'">시험로</button>
                        <button class="tablinks" onclick="location.href='/admin/reserved/schedule'">부대시설</button>
                    </div>
                    <div class="wrap_tabcontent">
                        <div class="webwidget_tab" id="webwidget_tab">
                        <!-- tab1-시험중 -->
                        <div id="tab1" class="tabcontent">
                            <div class="tabContainer" style="padding-bottom:40px">
                                <ul class="tabHead">
                                    <li id="btn1"><a href="/admin/trReserve/trcalendar">달력으로 보기</a></li>
                                    <li id="btn2" class="currentBtn"><a href="/admin/trReserve/trlist">목록으로 보기</a></li>
                                </ul>
                            </div>
                            <!-- table list -->
                            <section class="tbl_wrap_list">
                                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                                    <caption>테이블</caption>
                                    <colgroup>
                                        <col width="" />
                                        <col width="" />
                                        <col width="" />
                                        <col width="" />
                                        <col width="" />
                                        <col width="" />
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col">예약번호</th>
                                            <th scope="col">시험일자</th>
                                            <th scope="col">회사명</th>
                                            <th scope="col">평가트랙</th>
                                            <th scope="col">유형</th>
                                            <th scope="col">진행상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <c:if test="${trReserve.compCode ne 'THINT' }"> 
                                        <tr>
                                            <td>${trReserve.tcReservCode }
                                            <c:if test="${trReserve.compCode eq 'THINT' }"><br /><span class="color_orange">${trReserve.tcRequestNumber }</span></c:if></td>
                                            <td>
	                                            <c:forEach var="result" items="${trReserve.trackInfo}" varStatus="status">
		                                            <c:if test="${status.index eq 0 }">
		                                            	<c:set var="trTrackType" value="${result.trTrackType }" />
								                		<c:set var="trTrackNickName" value="${result.trTrackNickName }" />
													</c:if>
		                                            <c:if test="${status.index ne 0 }">
		                                            	<c:if test="${fn:indexOf(trTrackNickName, result.trTrackNickName) < 0 }">
								                		<c:set var="trTrackNickName" value="${result.trTrackNickName }<br />${trTrackNickName }" />
								                		</c:if>
		                                            </c:if>
													<c:if test="${trReserve.tcDay ne trReserve.tcDay2 }">
														<c:set var="tcDay" value="${fn:substring(result.tcDay,0,4) }-${fn:substring(result.tcDay,4,6) }-${fn:substring(result.tcDay,6,8) }" />
														<c:if test="${fn:indexOf(realtcDay, tcDay)<0 }">
															<c:set var="realtcDay" value="${realtcDay } / ${fn:substring(result.tcDay,0,4) }-${fn:substring(result.tcDay,4,6) }-${fn:substring(result.tcDay,6,8) }" />
														</c:if>
													</c:if>
	                                            </c:forEach>
                                            	<c:if test="${trReserve.compCode eq 'THINT' }">                                            	
								                	<c:if test='${trReserve.tcDay eq trReserve.tcDay2}'>${trReserve.tcDay }</c:if>
								                	<c:if test='${trReserve.tcDay ne trReserve.tcDay2}'>
									                	<c:set var="tcDay" value="${trReserve.tcDay}"/>${fn:substring(tcDay,0,4) }.${fn:substring(tcDay,4,6) }.${fn:substring(tcDay,6,8) } ~
									                	<c:set var="tcDay2" value="${trReserve.tcDay2}"/>${fn:substring(tcDay2,0,4) }.${fn:substring(tcDay2,4,6) }.${fn:substring(tcDay2,6,8) }
								                	</c:if>
                                            	</c:if>
                                            	<c:if test="${trReserve.compCode ne 'THINT' }">
								                	<c:set var="tcDay" value="${fn:substring(trReserve.tcDay,0,4) }-${fn:substring(trReserve.tcDay,4,6) }-${fn:substring(trReserve.tcDay,6,8) }"/>
								                	<c:set var="tcDay2" value="${fn:substring(trReserve.tcDay2,0,4) }-${fn:substring(trReserve.tcDay2,4,6) }-${fn:substring(trReserve.tcDay2,6,8) }"/>
	                                            	<div class="form_group w230"><input type="text" id="tcDay2" class="form_control dateicon datefromto"
	                                            		placeholder="예약기간 선택" name="tcDay" value="${tcDay } ~ ${tcDay2 }" autocomplete="off"/>
	                                            	</div>
	                                            	<c:if test="${!empty(realtcDay)}"><br /><div style="padding-top:5px"><span class="color_orange">실제사용일 </span>${realtcDay}</div></c:if>
	                                            </c:if>
                                            </td>
                                            <td>
							                	<c:if test="${trReserve.compCode eq 'THINT' }">T-HINT</c:if><c:if test="${trReserve.compCode ne 'THINT' }">${trReserve.compName }</c:if>
							                	<c:if test="${trReserve.blackList eq 'Y' }"><br /><span class="color_red">(B/L)</span></c:if>
							                </td>
							                <td>
							                ${trTrackNickName }
							                <br />
                                            <div class="trdiv form_group w170" style="padding-left:20px">
												<div id="trackInfo" class="select_group"></div>
											</div>
											<button type="button" id="addTrBtn" class="btn-line btn_gray">시험로 +</button>
                                            </td>
                                            <td>
												<c:if test="${trTrackType eq 'TYP00'}">공동</c:if>
    	                                        <c:if test="${trTrackType eq 'TYP01'}">단독</c:if>
    	                                        <c:if test="${trTrackType eq 'TYP02'}">시험</c:if>
    	                                        <c:if test="${trTrackType eq 'TYP03'}">연습</c:if>
    	                                        <c:if test="${trTrackType eq 'TYP04'}">점검</c:if>
    	                                        <c:if test="${trTrackType eq 'TYP05'}">시승</c:if>
    	                                        <c:if test="${trTrackType eq 'TYP06'}">사내방문</c:if>
    	                                        <c:if test="${trTrackType eq 'TYP07'}">테스트</c:if>
    	                                        <c:if test="${trTrackType eq 'TYP99'}">기타</c:if>
											</td>
                                            <td>
							                	<c:if test="${trReserve.tcStep eq '00000' }">
							                		<c:if test="${trReserve.tcApproval eq '0' }">승인대기</c:if>
							                		<c:if test="${trReserve.tcApproval eq '3' }">승인완료</c:if>
							                	</c:if>
							                	<c:if test="${trReserve.tcStep eq '00001' }"><span class="color_red">시험중</span></c:if>
							                	<c:if test="${trReserve.tcStep eq '00002' }">시험완료</c:if>
							                	<c:if test="${trReserve.tcStep eq '00003' }">이용완료</c:if>
							                </td>
                                        </tr>
                                    </c:if>
                                    <c:if test="${trReserve.compCode eq 'THINT' }">
	                                    <c:forEach var="result" items="${trReserve.trackInfo}" varStatus="status">
	                                        <tr>
	                                            <td>${trReserve.tcReservCode }<br /><span class="color_orange">${trReserve.tcRequestNumber }</span></td>
	                                            <td>${fn:substring(result.tcDay,0,4) }-${fn:substring(result.tcDay,4,6) }-${fn:substring(result.tcDay,6,8) }</td>
	                                            <td>한국타이어</td>
								                <td>${result.trTrackNickName }</td>
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
								                	<c:if test="${trReserve.tcStep eq '00001' }"><span class="color_red">시험중</span></c:if>
								                	<c:if test="${trReserve.tcStep eq '00002' }">시험완료</c:if>
								                	<c:if test="${trReserve.tcStep eq '00003' }">정산완료</c:if>
								                </td>
	                                    </c:forEach>
                                    </c:if>
                                    </tbody>
                                </table>
                            </section>
                            <!-- //table list -->

                            <!-- 시험정보 -->
                            <!-- accordion -->
                            <div class="wrap_accordion2 m-t-30">
                                <button class="accordion open">
                                    <h3 class="stitle disib vam0">시험정보</h3>
                                </button>
                                <div class="accordion_panel" style="display: block;">
                                    <!-- table_view -->
                                    <c:if test="${trReserve.compCode ne 'THINT' }">
                                    <div class="tbl_wrap_view">
                                        <table class="tbl_view01" summary="시험정보요약테이블입니다. 항목으로는 예약번호, 시험일자, 회사명, 항목, 유형, 진행상태가 있습니다.">
                                            <caption>시험정보요약 테이블입니다.</caption>
                                            <colgroup>
                                                <col width="180px;" />
                                                <col width="" />
                                            </colgroup>
                                            <tr>
                                                <th scope="row">운전자</th>
                                                <td colspan="3">${driver }</td>
                                            </tr>
                                            <tr>
                                                <th scope="row">시험차종</th>
                                                <td colspan="3">
                                                <c:set var="cRfid" />
                                                <c:forEach var="result" items="${trReserve.carInfo}" varStatus="status">
													<c:if test="${status.index ne 0 }"><br /></c:if>
													${result.CVender } ${result.CName }(${result.CNumber } / ${result.CColor })
													<c:set var="cRfid" value="${result.RId } " />
													<c:if test="${result.CType eq 'S' }">
														<span class="color_red"> - 특수차량</span>
													</c:if>
                                                </c:forEach>
												</td>
                                            </tr>
                                            <tr>
                                                <th scope="row">시험 종류 및 방법</th>
                                                <td colspan="3">${trReserve.tcPurpose }</td>
                                            </tr>
                                        </table>
                                    </div>
                                    </c:if>
                                    <c:if test="${trReserve.compCode eq 'THINT' }">
                                    <c:forEach var="result" items="${rmInfo}" varStatus="status">
                                    <div class="tbl_wrap_view" style="padding-bottom:10px">
                                        <table class="tbl_view01" summary="시험정보요약테이블입니다. 항목으로는 예약번호, 시험일자, 회사명, 항목, 유형, 진행상태가 있습니다.">
                                            <caption>시험정보요약 테이블입니다.</caption>
                                            <colgroup>
                                                <col width="180px;" />
                                                <col width="" />
                                            </colgroup>
                                            <tr>
                                                <th scope="row">시험일자</th>
                                                <td colspan="3">${fn:substring(result.tcDay,0,4) }-${fn:substring(result.tcDay,4,6) }-${fn:substring(result.tcDay,6,8) }</td>
                                            </tr>
                                            <tr>
                                                <th scope="row">운전자</th>
                                                <td colspan="3">${result.DName }(${result.rmLevel })</td>
                                            </tr>
                                            <tr>
                                                <th scope="row">시험차종</th>
                                                <td colspan="3">
                                                <c:forEach var="carresult" items="${trReserve.carInfo}" varStatus="status">
                                                	<c:if test="${result.tcDay eq carresult.tcDay }">
                                                	${carresult.CVender } ${carresult.CName }(${carresult.CNumber } / ${carresult.CColor })
                                                	</c:if>
                                                </c:forEach>
												</td>
                                            </tr>
                                            <tr>
                                                <th scope="row">시험 종류 및 방법</th>
                                                <td colspan="3">${trReserve.tcPurpose }</td>
                                            </tr>
                                        </table>
                                    </div>
                                    </c:forEach>
                                    </c:if>
                                    <!-- //table_view -->
                                </div>
                            </div>
                            <!-- //accordion -->
                            <!-- //시험정보 -->
							<c:if test="${trReserve.compCode ne 'THINT' }">
                            <!-- 예약 담당자 및 회계 담당자 정보 -->
                            <!-- accordion -->
                            <div class="wrap_accordion2 m-t-30">
                                <button class="accordion">
                                    <h3 class="stitle disib vam0">예약 담당자 및 회계 담당자 정보</h3>
                                </button>
                                <div class="accordion_panel" style="display: block;">
                                    <!-- table_view -->
                                    <section class="tbl_wrap_view">
                                        <table class="tbl_view01" summary="예약 담당자 및 회계 담당자 정보테이블입니다. 항목으로는 회사명, 사업자번호, 예약담당자, 부서, 휴대폰번호, 전화번호, 이메일주소, 회계담당자, 회계담당자부서, 회계담당자이메일, 회계담당자 전화번호등이 있습니다.">
                                            <caption>예약 담당자 및 회계 담당자 정보테이블입니다.</caption>
                                            <colgroup>
                                                <col width="180px;" />
                                                <col width="" />
                                                <col width="180px;" />
                                                <col width="" />
                                            </colgroup>
                                            <tr>
                                                <th scope="row">회사명</th>
                                                <td>${company.compName }<c:if test="${company.blackList eq 'Y' }"> <span class="color_red">(B/L)</span></c:if></td>
                                                <th>사업자등록번호</th>
                                                <td>
                                                	<c:set value="${company.compLicense}" var="compLicense" />
				                					${fn:substring(compLicense, 0, 3) }-${fn:substring(compLicense, 3, 5) }-${fn:substring(compLicense, 5, 10) }
                                                </td>
                                            </tr>
                                            <tr>
                                                <th scope="row">예약담당자</th>
                                                <td>${company.memName } </td>
                                                <th>부서</th>
                                                <td>${company.memDept } </td>
                                            </tr>
                                            <tr>
                                                <th scope="row">휴대폰 번호</th>
                                                <td>
                                                <c:set var='memPhone' value='${company.memPhone }' />
                                                ${fn:substring(memPhone,0,3) }-${fn:substring(memPhone,3,7) }-${fn:substring(memPhone,7,11) }
                                                </td>
                                                <th>전화번호</th>
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
                                                <th scope="row">이메일 주소</th>
                                                <td colspan="3">${company.memEmail } </td>
                                            </tr>
                                            <tr>
                                                <th scope="row">회계담당자</th>
                                                <td>${company.compAcctName } </td>
                                                <th>부서</th>
                                                <td>${company.compAcctDept } </td>
                                            </tr>
                                            <tr>
                                                <th scope="row">이메일 주소</th>
                                                <td>${company.compAcctEmail } </td>
                                                <th>전화번호</th>
                                                <td>
                                                <c:set var='compAcctPhone' value='${company.compAcctPhone }' />
                                                <c:if test='${compAcctPhone != "" }'>
													<c:if test='${fn:substring(compAcctPhone,0,2) =="02" or fn:length(compAcctPhone) lt 10 }'>
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
                                        </table>
                                    </section>
                                    <!-- //table_view -->
                                </div>
                            </div>
                            <!-- //accordion -->
                            <!-- //예약 담당자 및 회계 담당자 정보 -->
							</c:if>
                            
                            <!-- 관리자 메모 -->
                            <h3 class="stitle m-t-30">관리자 메모</h3>
                            <!-- table_view -->
                            <div class="tbl_wrap_view m-t-10">
                                <table class="tbl_view01" summary="관리자 메모테이블입니다.">
                                    <caption>관리자 메모테이블입니다.</caption>
                                    <colgroup>
                                        <col width="180px;" />
                                        <col width="" />
                                    </colgroup>
                                    <tr>
                                        <th scope="row">메모</th>
                                        <td colspan="3">
                                            <div class="form_group w_full">
                                                <textarea name="tcMemo" id="tcMemo" cols="" rows="5" class="form_control  h100"
                                                    placeholder="메모를 입력하세요." maxlength="300">${trReserve.tcMemo }</textarea>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <!-- //table_view -->
                            <!-- //관리자 메모 -->

                            <!-- button -->
                            <section class="btn_wrap m-t-50">
								<button type="button" id="listBtn" class="btn btn_gray">목록</button>
								<section>
									<button type="button" class="btn btn_gray m-r-6" data-layer="cancel">취소</button>
									<button type="button" id="btn_regi" class="upd btn btn_default">저장</button>
								</section>                         
							</section>
							<c:if test="${trReserve.compCode ne 'THINT'}">
								<c:if test="${trReserve.tcApproval eq '0' or trReserve.tcApproval eq '3' }">
									<section id="approvalWrap" class="btn_wrap tac m-t-0">
									    <button type="button" class="btn-line-b btn_gray m-r-6" data-layer="reason">예약 취소</button>
									</section>
								</c:if>
							</c:if>
                            <!-- //button -->
                        </div>
                        <!-- //tab1-시험중 -->
                        </div>
                    </div>
                </div>
            </div>
            <!-- //content -->
        </div>
        <!-- //container -->  
<!-- popup_Alert -->
<div class="ly_group">
    <article class="layer_Alert cancel">
        <!-- # 타이틀 # -->
        <!-- <h1></h1> -->
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            취소하시면 처음부터 다시<br />진행해야 됩니다.<br /><br />진행 하시겠습니까?
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button>
            <button type="button" id="canBtn" class="btn-pop btn_default lyClose">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_Alert -->

<!-- popup_m -->
<div class="ly_group">
    <article class="layer_m reason">
        <!-- # 타이틀 # -->
        <h1>사유등록/보기</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <div class="info_text03">
                <p>선택한 항목에 대해<br />[취소] 하시겠습니까?</p>
                <p>[내용등록]</p>
                <!-- <span class="info_ment_orange m-t-15 m-l-0"></span> -->
                <div class="form_group w_full m-t-10">
                    <textarea name="rtnRsn" id="rtnRsn" cols="" rows="5" class="form_control"
                        placeholder="취소 관련된 내용을 등록해 주세요." onkeyup="fnChkByte(this,'300')"></textarea>
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
<span id="pageNo" style="display:none">${pageNo }</span>
<span id="tcSeq" style="display:none">${trReserve.tcSeq }</span>
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>