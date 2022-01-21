<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp"%>
<sec:csrfMetaTags />
<script type="text/javascript">
$(document).ready(function(){
	//daterangepiker start
	$("#stDt").daterangepicker({
	    locale: {
	    "separator": " ~ ",                     // 시작일시와 종료일시 구분자
	    "format": 'YYYY-MM-DD',     // 일시 노출 포맷
	    "applyLabel": "확인",                    // 확인 버튼 텍스트
	    "cancelLabel": "취소",                   // 취소 버튼 텍스트
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
	
	$(document).on("click",'#rtnBtn' ,function(){
		var dSeq = $("#currentdSeq").val();
		var rtnReason = $("#rtnReason").val();
		if(rtnReason==""){
			alert("반려사유를 입력해 주세요.");
		}else{
			$.ajax({
				url : "/admin/driver/update-return",
				type : "get",
				data : {
					"dSeq":dSeq,
					"dMemo":rtnReason
				},
				success : function(resdata){
					if(resdata.code == 400){
						alert(resdata.message);
					}else{
						alert(resdata.message);
					}
				},
				error : function(e){
					console.log(e);
				}
			});
		}
	});
});	

//페이지 버튼 클릭
$(document).on("click",".pageNo",function(){  
	$(this).siblings().removeClass("active");
	$(this).addClass("active");
	
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
	var keyword = $("#search").val();
	var stDt = $("#stDt").val();
	var dApproval = "";
	if($("#btn2").hasClass("active")){	//승인내역이 선택된 상태라면
		dApproval = "Y";
	}else{
		$("input[name=dApproval]:checked").each(function() {
			if(dApproval == "") {
				dApproval += $(this).val();
			}else{
				dApproval += ","+$(this).val();
			}
		});
		
		if(dApproval == "") {
			$("#dApprovalN").prop("checked",true);
			$("#dApprovalR").prop("checked",true);
			dApproval = "N,R";
		}
	}

	if(type == "list") {//목록 버튼
		pageNo = $("#pageNo").text();
		$("#data_detail").hide();
	}else if(type == "paging"){//페이징 검색
		pageNo = $(".pageNo.active").attr("data-page"); 
	}else{
		pageNo = "1";
	}
	
	if(type == "init"){
		var keyword = "";
		var stDt = "";
		$("#search").val("");
		$("#stDt").val("");
	}
	
	$.ajax({
		url : "/admin/driver/search-driver",
		type : "get",
		data : {
				"pageNo"  :pageNo,
				"keyword":keyword,
				"stDt":stDt,
				"dApproval":dApproval
		},
		success : function(resdata){
			drawingTable(resdata.rows, resdata.paging, dApproval);
			drawingPage(resdata.paging);
		},
		error : function(e){
			console.log(e);
		}
	});

}

//조회값 undefined -> 공백 처리
function undefinedChk(str1,str2){
	if( str1 == "" || str1 == null || typeof str1 == undefined || str1 == undefined || ( str1 != null && typeof str1 == "object" && !Object.keys(str1).length ) ){
		return str2;
	}else{
		return str1;
	}
}

//상세보기로 이동
$(document).on("click",".godetail, #cancelBtn",function(){
	var currentRow=$(this).closest('tr');
	var pageNo = $(".pageNo.on").attr("data-page");
	if(undefinedChk(pageNo,"")==""){
		pageNo = $("#pageNo").text();
	}
	var dSeq = currentRow.find('td:eq(0) span').text();
	if(dSeq==""){
		dSeq = $("#currentdSeq").val();
	}else{
		$("#currentdSeq").val(dSeq);	
	}
	var dApproval = "";
	if($("#btn1").hasClass("active")){
		dApproval = "N";
	}else{
		dApproval = "Y";
	}
	
	location.href="/admin/driver/detail-driver?dSeq="+dSeq+"&pageNo="+pageNo+"&dApproval="+dApproval;
});	

//테이블 그리는 함수
function drawingTable(rows, paging, dApproval){
	var html='';
	html += '<table class="tbl_list" summary="운전자 신청내역입니다. 항목으로는 번호, 회사명, 사업자 번호, 운전자명, 휴대폰 번호, 회사전화번호, 신청일시, 상태, 반려일시등이 있습니다" id="tbody">';
	html += '<caption>운전자 신청내역</caption>';
	html += '	<colgroup>';
	if(dApproval=="Y"){
		html += '	<col width="80px" />';
		html += '	<col width="" />';
		html += '	<col width="240px" />';
		html += '	<col width="190px" />';
		html += '	<col width="230px" />';
		html += '	<col width="230px" />';
		html += '	<col width="270px" />';
	}else{
		html += '	<col width="80px" />';
		html += '	<col width="" />';
		html += '	<col width="200px" />';
		html += '	<col width="150px" />';
		html += '	<col width="190px" />';
		html += '	<col width="190px" />';
		html += '	<col width="240px" />';
		html += '	<col width="140px" />';
		html += '	<col width="240px" />';
	}
	html += '</colgroup>';
	html += '<thead>';
	html += '    <tr>';
	html += '        <th scope="col">번호</th>';
	html += '        <th scope="col">회사명</th>';
	html += '        <th scope="col">사업자 번호</th>';
	html += '        <th scope="col">운전자명</th>';
	html += '        <th scope="col">휴대폰 번호</th>';
	html += '        <th scope="col">회사 전화번호</th>';
	if(dApproval=="Y"){
		html += '        <th scope="col">승인일시</th>';
	}else{
		html += '        <th scope="col">신청일시</th>';
		html += '        <th scope="col">상태</th>';
		html += '        <th scope="col">반려일시</th>';
	}
	html += '    </tr>';
	html += '</thead>';
	html += '<tbody>';
	if(rows.length==0){
		html += '<tr class="tr_nodata"><td colspan="9">데이터가 존재하지 않습니다.</td></tr>';
	}else{
		for(var list in rows){
			html += '<tr onmouseover="this.className=\'on godetail\'" onmouseout="this.className=\'\'">';
			html += '<td><span style="display:none">'+undefinedChk(rows[list].dseq,"")+'</span>';
			html += paging.totalCount-(paging.pageNo-1)*paging.pageSize-list;
			html += '</td>';
			html += '<td>'+undefinedChk(rows[list].compName,"")+'</td>';
			var compLicense = undefinedChk(rows[list].compLicense,"");
			compLicense = compLicense.substring(0,3)+"-"+compLicense.substring(3,5)+"-"+compLicense.substring(5,10);
			html += '<td>'+compLicense+'</td>';
			html += '<td>'+undefinedChk(rows[list].dname,"")+'</td>';
			var dphone = undefinedChk(rows[list].dphone,"")
			dphone = dphone.substring(0,3)+"-"+dphone.substring(3,7)+"-"+dphone.substring(7,11);
			html += '<td>'+dphone+'</td>';
			var dphone2 = undefinedChk(rows[list].dphone2,"");
			if(dphone2!=""){
				if(dphone2.substring(0,2)=="02"||dphone2.length<10){
					if(dphone2.length==10){
						dphone2 = dphone2.substring(0,2)+'-'+dphone2.substring(2,6)+'-'+dphone2.substring(6,10);
					}else{
						dphone2 = dphone2.substring(0,2)+'-'+dphone2.substring(2,5)+'-'+dphone2.substring(5,10);
					}
				}else if(dphone2.substring(0,3)=="010"){
					dphone2 = dphone2.substring(0,3)+'-'+dphone2.substring(3,7)+'-'+dphone2.substring(7,11);
				}else{
					if(dphone2.length==10){
						dphone2 = dphone2.substring(0,3)+'-'+dphone2.substring(3,6)+'-'+dphone2.substring(6,10);
					}else if(dphone2.length==11){
						dphone2 = dphone2.substring(0,3)+'-'+dphone2.substring(3,7)+'-'+dphone2.substring(7,11);
					}else if(dphone2.length==12){
						dphone2 = dphone2.substring(0,4)+'-'+dphone2.substring(4,8)+'-'+dphone2.substring(8,12);					
					}
				}
			}
			html += '<td>'+dphone2+'</td>';
			var dregDt = "";
			if(dApproval=="Y"){
				dregDt = rows[list].dmodDt;
			}else{
				dregDt = rows[list].dregDt;
			}
			if(dregDt.length==14){
				dregDt = dregDt.substring(0,4)+"-"+dregDt.substring(4,6)+"-"+dregDt.substring(6,8)+" "+dregDt.substring(8,10)+":"+dregDt.substring(10,12)+":"+dregDt.substring(12,14);
			}

			if(dApproval=="Y"){
				html += '<td>'+dregDt+'</td>';
			}else{
				html += '<td>'+dregDt+'</td>';
				var dapproval = undefinedChk(rows[list].dapproval, "");
				html += '<td>';
				if(dapproval == "N") html += "승인대기";
				if(dapproval == "R") html += "승인반려";
				html += '</td>';
				html += '<td>';
				var dmodDt = undefinedChk(rows[list].dmodDt,"");
				if(dapproval == "R") {
					if(dmodDt.length==14){
						dmodDt = dmodDt.substring(0,4)+"-"+dmodDt.substring(4,6)+"-"+dmodDt.substring(6,8)+" "+dmodDt.substring(8,10)+":"+dmodDt.substring(10,12)+":"+dmodDt.substring(12,14);
					}
					html += dmodDt;
					
				}
				html += '</td>';
			}
			html += '</tr>';
		}
	}
	html += '</tbody>';
	html += '</table>';
	$("#tbody").html(html);
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
</script>
<!-- container -->
<div id="container">
	<!-- content -->
	<div class="content">
		<!-- breadcrumb -->
		<div class="breadcrumb">
			<span class="breadcrumb_icon"></span><span>회원사/자원관리</span><span>회원사
				관리</span><span>운전자 관리</span>
		</div>
		<!-- //breadcrumb -->
		<!-- title -->
		<h2 class="title">운전자 관리</h2>
		<!-- //title -->

		<!-- tab -->
		<div class="wrap_tab">
			<div class="tab">
				<button id="btn1" class="tablinks<c:if test='${reqcon!="Y"}'> active</c:if>" onclick="goList('N')">운전자 신청내역</button>
				<button id="btn2" class="tablinks<c:if test='${reqcon=="Y"}'> active</c:if>" onclick="goList('Y')">운전자 승인내역</button>
			</div>
			<div class="wrap_tabcontent">
				<!-- tab1-운전자 신청내역 -->
				<div id="tab1" class="tabcontent">
					<div id="data_list">
						<!-- search_wrap -->
						<section class="search_wrap">
							<div class="form_group w230">
								<input type="text" id="stDt"
									class="form_control dateicon datefromto" placeholder="신청기간 선택"
									name="stDt" autocomplete="off" />
							</div>
							<div class="form_group w300">
								<input type="text" id="search" class="form_control"
									placeholder="회사명/사업자번호/운전자명 입력" name="search" />
							</div>
							<c:if test='${reqcon!="Y"}'>
								<div id="searchDApproval" class="form_group m-r-10">
									<div class="check_inline">
										<span class="label">상태</span> <label class="check_default">
											<input type="checkbox" name="dApproval" id="dApprovalN"
											value="N" checked="checked" /> <span class="check_icon"></span>승인대기
										</label> <label class="check_default"> <input type="checkbox"
											name="dApproval" id="dApprovalR" value="R" checked="checked" />
											<span class="check_icon"></span>승인반려
										</label>
									</div>
								</div>
							</c:if>
							<button type="button" id="searchBtn" class="btn-s btn_default">조회</button>
                                <button type="button" class="btn-s btn_default" id="initBtn">검색초기화</button>
						</section>
						<!-- //search_wrap -->
						<!-- table list -->
						<section class="tbl_wrap_list m-t-30">
							<table class="tbl_list"
								summary="운전자 신청내역입니다. 항목으로는 번호, 회사명, 사업자 번호, 운전자명, 휴대폰 번호, 회사전화번호, 신청일시, 상태, 반려일시등이 있습니다"
								id="tbody">
								<caption>운전자 신청내역</caption>
								<colgroup>
								<c:if test='${reqcon=="Y"}'>
									<col width="80px" />
									<col width="" />
									<col width="240px" />
									<col width="190px" />
									<col width="230px" />
									<col width="230px" />
									<col width="270px" />
								</c:if>
								<c:if test='${reqcon!="Y"}'>
									<col width="80px" />
									<col width="" />
									<col width="200px" />
									<col width="150px" />
									<col width="190px" />
									<col width="190px" />
									<col width="240px" />
									<col width="140px" />
									<col width="240px" />
								</c:if>								
								</colgroup>
								<thead>
									<tr>
									<c:if test='${reqcon=="Y"}'>
								        <th scope="col">번호</th>
								        <th scope="col">회사명</th>
								        <th scope="col">사업자 번호</th>
								        <th scope="col">운전자명</th>
								        <th scope="col">휴대폰 번호</th>
								        <th scope="col">회사 전화번호</th>
								        <th scope="col">승인일시</th>
									</c:if>
									<c:if test='${reqcon!="Y"}'>
										<th scope="col">번호</th>
										<th scope="col">회사명</th>
										<th scope="col">사업자 번호</th>
										<th scope="col">운전자명</th>
										<th scope="col">휴대폰 번호</th>
										<th scope="col">회사 전화번호</th>
										<th scope="col">신청일시</th>
										<th scope="col">상태</th>
										<th scope="col">반려일시</th>
									</c:if>
									</tr>
								</thead>
								<tbody>
									<c:if test="${fn:length(driverList.rows) == 0}">
										<tr class="tr_nodata">
											<td colspan="9">데이터가 존재하지 않습니다.</td>
										</tr>
									</c:if>
									<c:forEach var="result" items="${driverList.rows}"
										varStatus="status">
										<tr onmouseover="this.className='on godetail'"
											onmouseout="this.className=''">
											<td><span style="display: none">${result.DSeq}</span>${totalCnt - (paging.pageNo-1)*paging.pageSize - status.index }</td>
											<td>${result.compName}<c:if
													test="${result.blacklist eq 'Y' }">
													<span class="color_red">(B/L)</span>
												</c:if></td>
											<td>
												<c:set var='compLicense' value='${result.compLicense }' />
												${fn:substring(compLicense,0,3) }-${fn:substring(compLicense,3,5) }-${fn:substring(compLicense,5,10) }
											</td>
											<td>${result.DName}</td>
											<td>
	                                            <c:set var='DPhone' value='${result.DPhone }' />
                                                ${fn:substring(DPhone,0,3) }-${fn:substring(DPhone,3,7) }-${fn:substring(DPhone,7,11) }
	                                        </td>
											<td>
                                                <c:set var='DPhone2' value='${result.DPhone2 }' />
                                                <c:if test='${DPhone2 != "" }'>
													<c:if test='${fn:substring(DPhone2,0,2) =="02" or fn:length(DPhone2) lt 10 }'>
														<c:if test='${fn:length(DPhone2)==10 }'>
															${fn:substring(DPhone2,0,2) }-${fn:substring(DPhone2,2,6) }-${fn:substring(DPhone2,6,10) }
														</c:if>
														<c:if test='${fn:length(DPhone2)!=10 }'>
															${fn:substring(DPhone2,0,2) }-${fn:substring(DPhone2,2,5) }-${fn:substring(DPhone2,5,10) }
														</c:if>
													</c:if>
													<c:if test='${fn:substring(DPhone2,0,3) =="010" }'>
														${fn:substring(DPhone2,0,3) }-${fn:substring(DPhone2,3,7) }-${fn:substring(DPhone2,7,11) }
													</c:if>
													<c:if test='${fn:substring(DPhone2,0,2) !="02" && fn:substring(DPhone2,0,3) !="010" }'>
														<c:if test='${fn:length(DPhone2)==10 }'>
															${fn:substring(DPhone2,0,2) }-${fn:substring(DPhone2,2,6) }-${fn:substring(DPhone2,6,10) }
														</c:if>
														<c:if test='${fn:length(DPhone2)==11 }'>
															${fn:substring(DPhone2,0,3) }-${fn:substring(DPhone2,3,7) }-${fn:substring(DPhone2,7,11) }
														</c:if>
														<c:if test='${fn:length(DPhone2)==12 }'>
															${fn:substring(DPhone2,0,4) }-${fn:substring(DPhone2,4,8) }-${fn:substring(DPhone2,8,12) }
														</c:if>
													</c:if>
												</c:if>
											</td>
											<c:if test='${reqcon=="Y"}'>
											<td><c:if test="${result.DApproval eq 'Y' or result.DApproval eq 'R' }">
													<c:set var="DModDt" value="${result.DModDt}" />
												${fn:substring(DModDt,0,4) }-${fn:substring(DModDt,4,6) }-${fn:substring(DModDt,6,8) } ${fn:substring(DModDt,8,10) }:${fn:substring(DModDt,10,12) }:${fn:substring(DModDt,12,14) }
												</c:if></td>
											</c:if>
											<c:if test='${reqcon!="Y"}'>
												<td><c:set var="DRegDt" value="${result.DRegDt}" />
													${fn:substring(DRegDt,0,4) }-${fn:substring(DRegDt,4,6) }-${fn:substring(DRegDt,6,8) }
													${fn:substring(DRegDt,8,10) }:${fn:substring(DRegDt,10,12) }:${fn:substring(DRegDt,12,14) }
												</td>
												<td><c:if test="${result.DApproval eq 'N' }">승인대기</c:if>
													<c:if test="${result.DApproval eq 'R' }">승인반려</c:if></td>
												<td><c:if test="${result.DApproval eq 'R' }">
														<c:set var="DModDt" value="${result.DModDt}" />
													${fn:substring(DModDt,0,4) }-${fn:substring(DModDt,4,6) }-${fn:substring(DModDt,6,8) } ${fn:substring(DModDt,8,10) }:${fn:substring(DModDt,10,12) }:${fn:substring(DModDt,12,14) }
													</c:if></td>
											</c:if>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</section>
						<!-- //table list -->
						<!-- Pagination -->
						<section id="pagingc" class="pagination m-t-30">
							<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
						</section>
						<!-- //Pagination -->
					</div>
				</div>
				<!-- //tab1-운전자 신청내역 -->
			</div>
		</div>
		<!-- //tab -->
	</div>
	<!-- //content -->
</div>

<!-- popup_m -->
<div class="ly_group">
    <article class="layer_m reason">
        <!-- # 타이틀 # -->
        <h1>사유등록/보기</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <div class="info_text03">
                <p>선택한 항목에 대해<br />[$$반려 또는 취소$$] 하시겠습니까?</p>
                <p>[사유등록]</p>
                <span class="info_ment_orange m-t-15 m-l-0">회원사에게 전송되는 정보이므로 등록 시 유의하시기 바랍니다.</span>
                <div class="form_group w_full m-t-10">
                    <textarea name="rtnReason" id="rtnReason" cols="" rows="5" class="form_control" 
                        placeholder="반려/취소 /거절 사유를 등록해 주세요." onKeyUp="fnChkByte(this,'500')" style="resize: none;"></textarea>
                    <div class="count_txt"><span id="byteInfo">0</span> / 500 bytes</div>
                </div>
            </div>
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button>
            <button type="button" id="rtnBtn" class="btn-pop btn_default lyClose">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_m -->
   
<span id="pageNo" style="display:none">1</span>
<!-- //container -->
<script type="text/javascript">
    function goList(kind){
    	if(kind=="Y"){		
		   $("#btn1").removeClass("active");
		   $("#btn2").addClass("active");
		   $("#searchDApproval").hide();
    	}else{
		   $("#btn1").addClass("active");
		   $("#btn2").removeClass("active");
		   $("#searchDApproval").show();
    	}

    	search("button");
    }
</script>
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp"%>