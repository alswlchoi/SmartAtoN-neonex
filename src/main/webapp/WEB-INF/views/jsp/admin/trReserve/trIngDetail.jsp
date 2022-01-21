<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){	
	$(document).on("click",'#canBtn' ,function(){
		location.reload();
	});
	
	$(document).on("click",'#listBtn' ,function(){
		var tcStep = "${trReserve.tcStep}";
		if(tcStep.length>0)
			tcStep = tcStep.replace("0000", "");
		location.href="/admin/trReserve/trlisting?pageNo=${pageNo}&tcStep="+tcStep;
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
	
	$(document).on("click",'#addTrBtn2' ,function(){
		if($("#tcDay").val()==""){
			alert("입출차날짜를 선택해 주세요.");
		}else if($("#inTimeAdd").val()==""||$("#inTimeAdd").val().length!=4){
			alert("입차시간을 4자리로 입력해 주세요.");
		}else if($("#outTimeAdd").val()!=""&&$("#outTimeAdd").val().length!=4){
			alert("출차시간을 4자리로 입력해 주세요.");
		}else if($("#outTimeAdd").val()!=""&&($("#inTimeAdd").val()>=$("#outTimeAdd").val())){
			alert("출차시간이 입차시간보다 빠릅니다.");
		}else if($("select[name=carTagId] option:eq(0)").is(":selected")){
			alert('차량 번호를 선택해 주세요.');
		}else if($("select[name=tagId] option:eq(0)").is(":selected")){
			alert('운전자를 선택해 주세요.');
		}else if($("select[name=tid] option:eq(0)").is(":selected")){
			alert('시험로를 선택해 주세요.');
		}else{
			var tcSeq = "${trReserve.tcSeq}";
			//var tcDay = $("select[name=tcDay]").val();
			var tcDay = $("#tcDay").val();
			var tcReservCode = "${trReserve.tcReservCode}";
			var inTime = $("#inTimeAdd").val();
			var outTime = $("#outTimeAdd").val();
			var tagId =  $("select[name=tagId]").val();
			var carTagId =  $("select[name=carTagId]").val();
			var tid =  $("select[name=tid]").val();
			
			var param = {
				"tcSeq":tcSeq,
				"tcDay":tcDay,
				"inTime":inTime,
				"outTime":outTime,
				"tagId":tagId,
				"carTagId":carTagId,
				"tcReservCode":tcReservCode,
				"tid":tid
			};
			postAjax("/admin/trReserve/add-rfid-log", param,"succAddTrack", null, null, null);
		}
	});
	
	$(document).on("click",'button[id^=updGnrBtn]' ,function(){
		var currentRow=$(this).closest('tr');
		var inTime = currentRow.find('td input[name=inTimeUpd]').val();
		var outTime = currentRow.find('td input[name=outTimeUpd]').val();
		var prgNo = $(this).prop("id").replace("updGnrBtn", "");
		var tcReservCode = "${trReserve.tcReservCode}";
		
		if(inTime==""||inTime.length!=4){
			alert("입차시간을 입력해 주세요.");
		}else if(outTime!=""&&outTime.length!=4){
			alert("출차시간을 입력해 주세요.");
		}else if(outTime!=""&inTime>=outTime){
			alert("입차시간과 출차시간을 확인해 주세요.");
		}else{			
			var param = {
				"prgNo":prgNo,
				"inTime":inTime,
				"outTime":outTime,
				"tcReservCode":tcReservCode
			};
			//console.log("param ; " + JSON.stringify(param));
			postAjax("/admin/trReserve/update-rfid-gnr-log", param,"succAddTrack", null, null, null);
		}
	});
	
	$(document).on("click",'button[id^=updTrBtn]' ,function(){
		var currentRow=$(this).closest('tr');
		var inTime = currentRow.find('td input[name=inTimeUpd]').val();
		var outTime = currentRow.find('td input[name=outTimeUpd]').val();
		var rlSeq = $(this).prop("id").replace("updTrBtn", "");
		var tcReservCode = "${trReserve.tcReservCode}";
		
		if(inTime==""||inTime.length!=4){
			alert("입차시간을 입력해 주세요.");
		}else if(outTime!=""&&outTime.length!=4){
			alert("출차시간을 입력해 주세요.");
		}else if(outTime!=""&inTime>=outTime){
			alert("입차시간과 출차시간을 확인해 주세요.");
		}else{			
			var param = {
				"rlSeq":rlSeq,
				"inTime":inTime,
				"outTime":outTime,
				"tcReservCode":tcReservCode
			};
			//console.log("param ; " + JSON.stringify(param));
			postAjax("/admin/trReserve/update-rfid-log", param,"succAddTrack", null, null, null);
		}
	});
	
	$(document).on("click",'#btnAccounts' ,function(){

		var tcSeq = "${trReserve.tcSeq}";
		var compCode = "${trReserve.compCode}";
		var tcReservCode = "${trReserve.tcReservCode}";		
		
		var param = {
			"tcSeq":tcSeq,
			"compCode"  :compCode,
			"tcReservCode":tcReservCode
		};
		
		postAjax("/admin/trReserve/insert-accounts", param,"successUpdate", null, null, null);
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

//공동시험로 정보 selectbox 생성
function drawTrackSelect(trackList){
	var trackHtml = '';
	trackHtml += '<select name="trTrackCode" id="trTrackCode" class="trTrackCode form_control">';
	trackHtml += '<option value="">시험로선택</option>';
	var trTrackCode = '${trTrackCode}';
	for(var list in trackList){
		if(parseInt(list)>0){
			trackHtml += '<option value="'+undefinedChk(trackList[list].tid,"")+'"';
			trackHtml += '>'+undefinedChk(trackList[list].tname,"");
		}
	}
	trackHtml += '</select>';
	
	$("#trackInfo").html(trackHtml);
}

function successUpdate(data){
	if(data.code > 0){
		alert(data.message);
		$(document).on("click",'.lyClose' ,function(){
			location.href="/admin/trReserve/trlisting";
		});
	}else{
		alert(data.message);
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
	alert("("+resdata.code+")"+resdata.message);
	if(resdata.code=="200"){
		$(".lyClose").click(function(){
			location.reload();
		});	
	}
}

$(document).on("click","#btnComplete",function(){
	var tcSeq = "${trReserve.tcSeq}";
	//var tcApproval = "3";
	var tcStep = "00002";
	var tcMemo = $("#tcMemo").val();

	var data ={
		tcSeq : tcSeq,
		tcStep : tcStep,
		tcMemo : tcMemo
	};

	postAjax("/admin/trReserve/update-approval",data,"successUpdate","",null,null);
	
});
$(document).on("click","#goApproval",function(){
	var tcSeq = $("#tcSeq").text();
	var tcMemo = $("#tcMemo").val();
	
	var data ={
		tcSeq : tcSeq,
		tcMemo : tcMemo
	};
	postAjax("/admin/trReserve/update-approval", data,"successUpdate", null, null, null);
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

	postAjax("/admin/trReserve/update-approval",data,"successUpdate","",null,null);
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
                        <!-- tab1-시험중 -->
                        <div id="tab1" class="tabcontent">
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
                                            <th scope="col">항목</th>
                                            <th scope="col">유형</th>
                                            <th scope="col">진행상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
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
                                            
							                	<c:if test='${trReserve.tcDay eq trReserve.tcDay2}'>${trReserve.tcDay }</c:if>
							                	<c:if test='${trReserve.tcDay ne trReserve.tcDay2}'>
								                	<c:set var="tcDay" value="${trReserve.tcDay}"/>${fn:substring(tcDay,0,4) }.${fn:substring(tcDay,4,6) }.${fn:substring(tcDay,6,8) } ~
								                	<c:set var="tcDay2" value="${trReserve.tcDay2}"/>${fn:substring(tcDay2,0,4) }.${fn:substring(tcDay2,4,6) }.${fn:substring(tcDay2,6,8) }
								                	<c:if test="${!empty(realtcDay)}"><br /><div style="padding-top:5px"><span class="color_orange">실제사용일 </span>${realtcDay}</div></c:if>
							                	</c:if>
                                            </td>
                                            <td>
							                	<c:if test="${trReserve.compCode eq 'THINT' }"><span class="color_orange">T-HINT</span></c:if><c:if test="${trReserve.compCode ne 'THINT' }">${trReserve.compName }</c:if>
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
							                	<c:if test="${trReserve.tcStep eq '00001' }"><span class="color_red">시험중</span></c:if>
							                	<c:if test="${trReserve.tcStep eq '00002' }">시험완료</c:if>
							                </td>
                                        </tr>
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
													
													<c:if test='${!empty(result.RId) and result.RId ne ""}'>
														&nbsp;-&nbsp;<span class="color_orange">${result.RId }</span>
														<c:choose>
														<c:when test='${empty(cRfid) or cRfid eq ""}'>
															<c:set var="cRfid" value="${result.RId }" />
														</c:when>
														<c:when test='${!empty(cRfid) and cRfid ne "" }'>
															<c:set var="cRfid" value="${cRfid } / ${result.RId }" />
														</c:when>
														</c:choose>
													</c:if>
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
                            <!-- 출입차 이력 -->
                            <!-- accordion -->
                            <div class="wrap_accordion2 m-t-30">
                                <!-- <button type="button" class="btn-line-bs btn_gray posi_right" data-layer="control">입/출입
                                    수동 통제</button> -->
                                <button class="accordion">
                                	<c:set var="cRfid" value="${fn:trim(cRfid) }" />
                                    <h3 class="stitle disib vam0">출입차 이력<c:if test="${cRfid ne '' and !empty(cRfid)}"> : 차량 RFID 정보 <span class="color_orange">[ ${cRfid } ]</span></c:if></h3>
                                </button>
                                <div class="accordion_panel" style="display: block;">
                                    <!-- table list -->
                                    <section class="tbl_wrap_list">
                                        <table class="tbl_list" summary="출입차 내역테이블 입니다. 항목으로는 입차시간, 출차시간, 소요시간(분), 시험로등이 있습니다">
                                            <caption>출입차 내역</caption>
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
                                                    <th scope="col">입출차날짜</th>
                                                    <th scope="col">입차시간</th>
                                                    <th scope="col">출차시간</th>
                                                    <th scope="col">소요시간(분)</th>
                                                    <th scope="col">시험로 및 시험 정보</th>
                                                    <th scope="col">수정/추가</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="result" items="${rfidGnrLog}" varStatus="status">
                                                <c:set var="inFullTime" value="${result.inTime }" />                                                    	
                                                <c:set var="outFullTime" value="${result.outTime }" />
                                                <tr>
                                                	<td>${fn:substring(inFullTime, 0, 4) }-${fn:substring(inFullTime, 4, 6) }-${fn:substring(inFullTime, 6, 8) }</td>
                                                    <td><div class="form_group w150"><input type="text" style="text-align:center"
                                                    	name="inTimeUpd" class="form_control inTimeUpd" value="${fn:substring(inFullTime, 8, 12) }"
	                                                		placeholder="입차시간(0930)" maxlength="4" onkeypress="numberonly();" /></div>
	                                                		<br /><span class="color_red" style="margin-top:3px">ex ) 09시 30분 - 0930</span>
	                                                </td>
                                                    <td>
	                                                	<div class="form_group w150"><input type="text" style="text-align:center"
	                                                 	name="outTimeUpd" class="form_control outTimeUpd" value="${fn:substring(outFullTime, 8, 12) }"
	                                                 		placeholder="출차시간(1530)" maxlength="4" onkeypress="numberonly();" /></div>
	                                                		<br /><span class="color_red" style="margin-top:3px">ex ) 15시 30분 - 1530</span>
	                                                </td>
                                                    <td>GNR
                                                    <%--                                                    
                                                    	<fmt:parseNumber var="inTimeN" value="${startDate_D.time }" integerOnly="true" />
                                                    	<fmt:parseNumber var="outTimeN" value="${endDate_D.time }" integerOnly="true" />
                                                    	${(outTimeN - inTimeN)/1000/60 }
                                                    --%></td>
                                                    <td>GNR Gate (<span class="color_orange">차량 RFID :</span> ${result.carRfidId })
                                                    <br /><span class="info_ment color_orange" style="margin-top:10px">수정하실 시간을 입력하시고 우측 「수정」버튼을 클릭해 주세요.</span></td>
                                                    <td>
														<button type="button" id="updGnrBtn${result.prgNo }" class="btn-line btn_gray">수정</button>
													</td>
                                                </tr>
                                            </c:forEach>
                                            
                                            
                                            <c:if test="${fn:length(rfidLog)==0 }">
                                            	<tr>
                                            		<td colspan="6">시험로 입/출차 내역이 존재하지 않습니다.</td>
                                            	</tr>
                                            </c:if>
                                            <c:forEach var="result" items="${rfidLog}" varStatus="status">
                                                <c:set var="inFullTime" value="${result.inTime }" />                                                    	
                                                <c:set var="outFullTime" value="${result.outTime }" />
                                                <tr>
                                                	<td>${fn:substring(inFullTime, 0, 4) }-${fn:substring(inFullTime, 4, 6) }-${fn:substring(inFullTime, 6, 8) }</td>
                                                    <td><div class="form_group w150"><input type="text" style="text-align:center"
                                                    	name="inTimeUpd" class="form_control inTimeUpd" value="${fn:substring(inFullTime, 8, 12) }"
	                                                		placeholder="입차시간(0930)" maxlength="4" onkeypress="numberonly();" /></div>
	                                                		<br /><span class="color_red" style="margin-top:3px">ex ) 09시 30분 - 0930</span>
	                                                </td>
                                                    <td>
	                                                	<div class="form_group w150"><input type="text" style="text-align:center"
	                                                 	name="outTimeUpd" class="form_control outTimeUpd" value="${fn:substring(outFullTime, 8, 12) }"
	                                                 		placeholder="출차시간(1530)" maxlength="4" onkeypress="numberonly();" /></div>
	                                                		<br /><span class="color_red" style="margin-top:3px">ex ) 15시 30분 - 1530</span>
	                                                </td>
                                                    <td>${result.diffTime}</td>
                                                    <td>${result.TName } (<span class="color_orange">차량 RFID : </span> ${result.carTagId })
                                                    <br /><span class="info_ment color_orange" style="margin-top:10px">수정하실 시간을 입력하시고 우측 「수정」버튼을 클릭해 주세요.</span></td>
                                                    <td>
														<button type="button" id="updTrBtn${result.rlSeq }" class="btn-line btn_gray">수정</button>
													</td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${payCnt eq 0}">
	                                            <tr>
	                                                <td>
                                                		<c:forEach var="result" items="${trReserve.trackInfo}" varStatus="status">
                                                			<c:if test='${fn:indexOf(realUseDt,result.tcDay)<0 }'>
                                                			<c:set var="realUseDt" value="${realUseDt }#${result.tcDay }" />
                                                			</c:if>
                                                		</c:forEach>
	                                                	<div class="trdiv form_group w170">
		                                                	<div class="form_group">
		                                                	<c:set var="now" value="<%=new java.util.Date()%>" />
		                                                		<input type="text" style="text-align:center"
	                                                		id="tcDay" name="tcDay" class="form_control" value="<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" />" maxlength="10" readonly="readonly" />
		                                                		<%--
			                                                	<select id="tcDay" name="tcDay" class="select_group form_control">
			                                                		<option value="">입출차날짜</option>
			                                                		<c:forEach var="result" items="${fn:split(realUseDt, '#')}" varStatus="status">		                                                			
			                                                			<option value="${result }">${fn:substring(result,0,4)}-${fn:substring(result,4,6)}-${fn:substring(result,6,8)}</option>
			                                                		</c:forEach>
			                                                	</select>
			                                                	 --%>
		                                                	</div>
	                                                	</div>
	                                                </td>
	                                                <td>
	                                                	<div class="form_group w150"><input type="text" style="text-align:center"
	                                                		id="inTimeAdd" name="inTimeAdd" class="form_control" value="" placeholder="입차시간(0930)" maxlength="4" onkeypress="numberonly();" /></div>
	                                                		<br /><span class="color_red" style="margin-top:3px">ex ) 9시 30분 - 0930</span>
	                                                </td>
	                                                <td>
	                                                	<div class="form_group w150"><input type="text" style="text-align:center"
	                                                 		id="outTimeAdd" name="outTimeAdd" class="form_control" value="" placeholder="출차시간(1530)" maxlength="4" onkeypress="numberonly();" /></div>
	                                                		<br /><span class="color_red" style="margin-top:3px">ex ) 15시 30분 - 1530</span></td>
	                                                <td><span id="useTime"></span></td>
	                                                <td>
	                                                
		                                                <div class="trdiv form_group w170">
		                                                	<div class="select_group">
			                                                	<select id="tagId" name="tagId" class="select_group form_control">
			                                                		<option value="">운전자 선택</option>
					                                                <c:forEach var="result" items="${resourceArr}" varStatus="status">
					                                                	<c:set var="resource" value="${fn:split(result, '#') }" />
					                                                	<c:if test='${!empty(resource[0])&&resource[0] ne "null"}'><option value="${resource[0] }">${resource[1] }</option></c:if>
					                                                </c:forEach>
					                                            </select>
					                                        </div>
					                                    </div>
		                                                <div class="trdiv form_group w170">
		                                                	<div class="select_group">
			                                                	<select id="carTagId" name="carTagId" class="select_group form_control">
			                                                		<option value="">시험 차량 선택</option>
			                                                		<c:forEach var="result" items="${trReserve.carInfo}" varStatus="status">
			                                                			<c:if test='${!empty(result.RId) }'><option value="${result.RId }">${result.CNumber }</option></c:if>
			                                                		</c:forEach>
			                                                	</select>
			                                                </div>
		                                                </div>
		                                                <div class="trdiv form_group w170">
															<div class="select_group">
					                                            <select name="tid" id="tid" class="trTrackCode form_control">
																	<option value="">시험로선택</option>
																	<c:forEach var="result" items="${trReserve.trackInfo}" varStatus="status">
																	<c:if test="${status.index eq 0 }">
																		<c:set var="trTrackNickName" value="${result.trTrackNickName }" />
						                                            	<option value="${result.trTrackCode }">${result.trTrackNickName }</option>
																	</c:if>
						                                            <c:if test="${status.index ne 0 }">
						                                            	<c:if test="${fn:indexOf(trTrackNickName, result.trTrackNickName) < 0 }">
												                		<c:set var="trTrackNickName" value="${result.trTrackNickName }" />
						                                            	<option value="${result.trTrackCode }">${result.trTrackNickName }</option>
												                		</c:if>
						                                            </c:if>
					                                            </c:forEach>
					                                            </select>															
															</div>
														</div>
														<br /><span class="info_ment color_orange" style="margin-top:10px">시간과 시험로정보를 입력하시고 우측 「추가+」버튼을 클릭해 주세요.</span>
	                                                </td>
	                                                <td>
														<button type="button" id="addTrBtn2" class="btn-line btn_gray">추가 +</button>
													</td>	                                                
	                                            </tr>
	                                        </c:if>
                                            </tbody>
                                        </table>
                                    </section>
                                    <!-- //table list -->
                                </div>
                            </div>
                            <!-- //accordion -->
                            <!-- //출입차 이력 -->

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
                                    <button type="button" id="" class="btn btn_gray m-r-6" data-layer="cancel">취소</button>
                                    <button type="button" id="goApproval" class="btn btn_default" data-layer="complete">저장</button>
                                </section>
                            </section>
                            <c:if test="${trReserve.compCode ne 'THINT'}">
	                            <section class="btn_wrap tac m-t-0">
	                            <c:if test="${trReserve.tcStep eq '00001'}">
									<button type="button" id="btnComplete" class="btn-sb btn_default">시험 완료</button>
	                            </c:if>
	                            <c:if test="${trReserve.tcStep eq '00002'}">
		                            <c:if test="${payCnt eq 0}">
		                                <button id="btnAccounts" type="button" class="btn-sb btn_default">정산서 생성</button>
		                            </c:if>
		                            <c:if test="${payCnt ne 0}"><button type="button" class="btn-line-b btn_gray m-r-6" onclick="alert('정산서 생성이 완료된 건입니다.')">정산서 생성</button>
		                            </c:if>
		                        </c:if>
	                            </section>
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