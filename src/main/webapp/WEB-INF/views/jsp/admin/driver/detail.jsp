<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp"%>
<sec:csrfMetaTags />
<script type="text/javascript">
$(document).ready(function(){
	//daterangepiker start
	
	$("#dEduEndDt").daterangepicker({
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
	    singleDatePicker: true                   // 하나의 달력 사용 여부
	});

	$(document).on("click",'#updBtn' ,function(){
		var dSeq = $("#currentdSeq").val();
		var pageNo = $("#pageNo").text();
		
		location.href="/admin/driver/modify-driver?dSeq="+dSeq+"&pageNo="+pageNo;
	});
	
	$(document).on("click",'#listBtn, #canBtn' ,function(){
		location.href="/admin/driver?pageNo=${driver.pageNo}&reqcon=${driver.DApproval}";
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
						alert("반려처리되었습니다.");
						$(document).on("click",'.lyClose' ,function(){
							history.back();
						});
					}
				},
				error : function(e){
					console.log(e);
				}
			});
		}
	});
	
	//데이터 삭제
	$(document).on("click",'.delButton' ,function(){

		var dSeq = $("#currentdSeq").val();
		var result = confirm("정보를 삭제하시겠습니까?");
		if(result){
			$.ajax({
				url : "/admin/driver/delete-driver",
				type : "get",
				data : {
					"dSeq":dSeq
				},
				success : function(resdata){
					if(resdata.code == 400){
						alert(resdata.message);
					}else{
						alert(resdata.message);
							location.reload();
					}
				},
				error : function(e){
					console.log(e);
				}
			});
		}
	
	});
	
	$(document).on("click","span[id^=fn]",function(){
		var fseq = $(this).prop("id").replace("fn", "");
		var url = "/admin/company/fileupload/download/"+fseq;
		
	    $.ajax({
	        method:"GET",
	        url : url,
	        success : function(data) {
	            if(undefinedChk(data.code, "")!=""){
		        	alert(data.message);	
	            }else{
	            	location.href=url;
	            }
	        },
	        error:function(data){
	        	alert(data.message);
	        }
	    });			
	});
	
	//날짜형식(YYYY-MM-DD) 체크
	var datatimeRegexp = RegExp(/^(19|20)\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$/);
});	

//조회값 undefined -> 공백 처리
function undefinedChk(str1,str2){
	if( str1 == "" || str1 == null || typeof str1 == undefined || str1 == undefined || ( str1 != null && typeof str1 == "object" && !Object.keys(str1).length ) ){
		return str2;
	}else{
		return str1;
	}
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

$(document).on("click","#goApproval",function(){
	var dSeq = $("#currentdSeq").val();
	var dLevel = $("#dLevel").val();
	var dEdu = $("input:radio[name=dEdu]:checked").val();
	var dEduEndDt = $("#dEduEndDt").val();
	var dMemo = $("#dMemo").val();
	if(dLevel==""){
		alert("운전자 레벨을 선택해 주세요.");
		return false;
	}else if(dEdu!="Y"){
		alert("	안전교육이수여부를 이수에 체크해 주세요.");
	}else if(dEduEndDt==""){
		alert("	안전교육이수여부 유효기간일을 선택해 주세요.");
		return false;
	}else{
		var param = {
			"dseq":dSeq,
			"dlevel"  :dLevel,
			"dedu"  :dEdu,
			"deduEndDt"  :dEduEndDt,
			"dmemo"  :dMemo
		};
		postAjax("/admin/driver/update-approval", param,"approvalSuccess", null, null, null);
	}
});

function approvalSuccess(resdata){
	alert("승인이 완료되었습니다.");
	$(document).on("click",'.lyClose' ,function(){
		location.href="/admin/driver?reqcon=N";
	});
}

$(document).on("click","#btnUpt",function(){
	var dSeq = $("#currentdSeq").val();
	var dLevel = $("#dLevel").val();
	var dEdu = $("input:radio[name=dEdu]:checked").val();
	var dEduEndDt = $("#dEduEndDt").val();
	var dMemo = $("#dMemo").val();
	
	if(dLevel==""){
		alert("운전자 레벨을 선택해 주세요.");
		return false;
	}else if(dEduEndDt==""){
		alert("안전교육이수여부 유효기간일을 선택해 주세요.");
		return false;
	}else{
		var param = {
			"dseq":dSeq,
			"dlevel"  :dLevel,
			"dedu"  :dEdu,
			"deduEndDt"  :dEduEndDt,
			"dmemo"  :dMemo
		};
		postAjax("/admin/driver/update-approval", param,"updateInfo", null, null, null);
	}
});

function updateInfo(resdata){
	alert("수정이 완료되었습니다.");
	$(document).on("click",'.lyClose' ,function(){
		location.href="/admin/driver?reqcon=Y";
	});
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
				<button id="btn1" class="tablinks<c:if test='${driver.DApproval=="N"||driver.DApproval=="R"}'> active</c:if>" onclick="location.href='/admin/driver?reqcon=N'">운전자 신청내역</button>
				<button id="btn2" class="tablinks<c:if test='${driver.DApproval=="Y"}'> active</c:if>" onclick="location.href='/admin/driver?reqcon=Y'">운전자 승인내역</button>
			</div>
			<div class="wrap_tabcontent">
				<!-- tab1-운전자 신청내역 -->
				<div id="tab1" class="tabcontent">
				<input type="hidden" id="currentdSeq" name="currentdSeq" value="${driver.DSeq }" />					
					<!-- 상세보기 시작 -->
					<div id="data_detail">
						<div id="data_table">
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
						            <col width="" />
						        </colgroup>
						        <thead>
						            <tr>
						                <th scope="col">관리번호</th>
						                <th scope="col">회사명</th>
						                <th scope="col">사업자 번호</th>
						                <th scope="col">운전자명</th>
						                <th scope="col">신청일시</th>
						                <th scope="col">반려일시</th>
						                <th scope="col">상태</th>
						            </tr>
						        </thead>
						        <tbody>
						            <tr>
						                <td>${driver.DSeq }</td>
						                <td>${driver.compName }</td>
						                <td>
											<c:set var='compLicense' value='${driver.compLicense }' />
											${fn:substring(compLicense,0,3) }-${fn:substring(compLicense,3,5) }-${fn:substring(compLicense,5,10) }
										</td>
										<td>${driver.DName }</td>
										<td>
										<c:set var='dregDt' value='${driver.DRegDt }' />
										${fn:substring(dregDt,0,4) }-${fn:substring(dregDt,4,6) }-${fn:substring(dregDt,6,8) }
										${fn:substring(dregDt,8,10) }:${fn:substring(dregDt,10,12) }:${fn:substring(dregDt,12,14) }   
										</td>
										<td>
										<c:set var='dapproval' value='${driver.DApproval }' />
											<c:set var='dmodDt' value='${driver.DModDt }' />
										<c:if test='${dapproval=="R" }'>
											${fn:substring(dmodDt,0,4) }-${fn:substring(dmodDt,4,6) }-${fn:substring(dmodDt,6,8) }
										${fn:substring(dmodDt,8,10) }:${fn:substring(dmodDt,10,12) }:${fn:substring(dmodDt,12,14) }   
										</c:if>
										</td>
										<td>
										<c:if test='${dapproval=="N" }'>
											<span class="color_red">승인대기</span>
										</c:if>		
										<c:if test='${dapproval=="R" }'>
											<span class="color_red">승인반려</span><br /><button type="button" class="btn-line-s btn_gray" data-layer="reason_result">사유보기</button>
										</c:if>
									</td>
					            </tr>
					        </tbody>
					    </table>
					</section>
					<h3 class="stitle m-t-30">운전자 상세 정보</h3>
				    <section style="text-align:right">
				        <button type="button" id="updBtn" class="btn btn_default" data-layer="complete">개인정보수정</button>
				    </section>
					<section class="tbl_wrap_view m-t-10">
					<table class="tbl_view01" summary="테이블입니다.">
					    <caption>테이블입니다.</caption>
					    <colgroup>
					        <col width="180px" />
					        <col width="40%" />
					        <col width="180px" />
					        <col width="" />
					    </colgroup>
					    <tr>
					        <th scope="row">이름(관리번호)</th>
					        <td>${driver.DName }</td>
					        <th>생년월일</th>
					        <td>
					        	<c:set var='dbirth' value='${driver.DBirth }' />
								${fn:substring(dbirth,0,4) }-${fn:substring(dbirth,4,6) }-${fn:substring(dbirth,6,8) }
							</td>
					    </tr>
					    <tr>
					        <th scope="row">이메일주소</th>
					        <td>${driver.DEmail }</td>
					        <th>휴대폰번호/전화번호</th>
					        <td>
					        	<c:set var='dphone' value='${driver.DPhone }' />
					        	<c:set var='dphone2' value='${driver.DPhone2 }' />					        	
					        	${fn:substring(dphone,0,3) }-${fn:substring(dphone,3,7) }-${fn:substring(dphone,7,11) } / 
					        	
								<c:if test='${dphone2 != "" }'>
									<c:if test='${fn:substring(dphone2,0,2) =="02" or fn:length(DPhone2) lt 10 }'>
										<c:if test='${fn:length(dphone2)==10 }'>
											${fn:substring(dphone2,0,2) }-${fn:substring(dphone2,2,6) }-${fn:substring(dphone2,6,10) }
										</c:if>
										<c:if test='${fn:length(dphone2)!=10 }'>
											${fn:substring(dphone2,0,2) }-${fn:substring(dphone2,2,5) }-${fn:substring(dphone2,5,10) }
										</c:if>
									</c:if>
									<c:if test='${fn:substring(dphone2,0,3) =="010" }'>
										${fn:substring(dphone2,0,3) }-${fn:substring(dphone2,3,7) }-${fn:substring(dphone2,7,11) }
									</c:if>
									<c:if test='${fn:substring(dphone2,0,2) !="02" && fn:substring(dphone2,0,3) !="010" }'>
										<c:if test='${fn:length(dphone2)==10 }'>
											${fn:substring(dphone2,0,2) }-${fn:substring(dphone2,2,6) }-${fn:substring(dphone2,6,10) }
										</c:if>
										<c:if test='${fn:length(dphone2)==11 }'>
											${fn:substring(dphone2,0,3) }-${fn:substring(dphone2,3,7) }-${fn:substring(dphone2,7,11) }
										</c:if>
										<c:if test='${fn:length(dphone2)==12 }'>
											${fn:substring(dphone2,0,4) }-${fn:substring(dphone2,4,8) }-${fn:substring(dphone2,8,12) }
										</c:if>
									</c:if>
								</c:if>
							 </td>
					    </tr>
					    <tr>
					        <th scope="row">운전면허종류</th>
					        <td>
					        <c:set var='dLicenseType' value='${driver.DLicenseType }' />
					        <c:choose>
					        	<c:when test='${dLicenseType.split(",")[0] == "LT10"}'>제1종 대형면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[0] == "LT11"}'>제1종 보통면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[0] == "LT12"}'>제1종 소형면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[0] == "LT13"}'>제1종 특수면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[0] == "LT21"}'>제2종 보통면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[0] == "LT22"}'>제2종 소형면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[0] == "LT23"}'>제2종 원동기장치자전거면허</c:when>
					        </c:choose>
					        <c:set var='dLicenseType' value='${driver.DLicenseType }' />
					        <c:choose>
					        	<c:when test='${dLicenseType.split(",")[1] == "LT10"}'><br />제1종 대형면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[1] == "LT11"}'><br />제1종 보통면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[1] == "LT12"}'><br />제1종 소형면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[1] == "LT13"}'><br />제1종 특수면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[1] == "LT21"}'><br />제2종 보통면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[1] == "LT22"}'><br />제2종 소형면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[1] == "LT23"}'><br />제2종 원동기장치자전거면허</c:when>
					        </c:choose>
					        <c:choose>
					        	<c:when test='${dLicenseType.split(",")[2] == "LT10"}'><br />제1종 대형면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[2] == "LT11"}'><br />제1종 보통면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[2] == "LT12"}'><br />제1종 소형면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[2] == "LT13"}'><br />제1종 특수면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[2] == "LT21"}'><br />제2종 보통면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[2] == "LT22"}'><br />제2종 소형면허</c:when>
					        	<c:when test='${dLicenseType.split(",")[2] == "LT23"}'><br />제2종 원동기장치자전거면허</c:when>
					        </c:choose>
							</td>
					        <th>운전기간</th>
					        <td>${driver.DHistory }년&nbsp;/&nbsp;5년이상</td>
					    </tr>
					    <tr>
					        <th scope="row">혈액형</th>
					        <td colspan="3">${driver.DBloodType }형
					        <c:set var='dbloodSpecial' value='${driver.DBloodSpecial }' />
							
							<c:if test='${dbloodSpecial != "" }'>&nbsp;/&nbsp;${dbloodSpecial }</c:if>
							</td>
					    </tr>
							
						<tr>
			    		    <th scope="row">운전면허증</th>
			        		<td>
			        			<c:forEach var="result" items="${driver.upfiles }" varStatus="status">
			        				<c:if test='${result.FType eq "d" }'>
					        			<span id="fn${result.FSeq }" style="cursor:pointer;text-decoration:underline">${result.FName }</span><br />
			        				</c:if>
			        				<c:if test='${result.FType eq "a" }'>
			        					<c:set var='agreeFseq' value='${result.FSeq }' />
			        					<c:set var='agreeFName' value='${result.FName }' />
			        				</c:if>
			        				<c:if test='${result.FType eq "e" }'>
			        					<c:set var='employFseq' value='${result.FSeq }' />
			        					<c:set var='employFName' value='${result.FName }' />
			        				</c:if>
			        			</c:forEach>
			        		</td>
			       			<th scope="row">동의서<br />재직증명서</th>
			        		<td>
			        			<c:if test='${!empty(agreeFseq) and !empty(agreeFName)  }'>
			        				<span id="fn${agreeFseq }" style="display:inline-block; padding-top:4px;cursor:pointer;text-decoration:underline">${agreeFName }</span><br />
			        			</c:if>
			        			<c:if test='${!empty(employFseq) and !empty(employFName)  }'>
			        				<span id="fn${employFseq }" style="cursor:pointer;text-decoration:underline">${employFName }</span>
			        			</c:if>
			        		</td>
			    		</tr>
							
					    <tr>
					        <th scope="row">운전자 레벨</th>
					        <td>
								<div class="form_group w300">
									<div class="select_group">
									<c:set var='dLevel' value='${driver.DLevel }' />
									<select name="dLevel" id="dLevel" class="form_control">
										<option value="">운전자 레벨</option>
										<c:forEach var="track" items="${track}">
											<option var="${track.DLevelName}">${track.DLevelName}</option>
										</c:forEach>
										<%-- <option value="T"<c:if test='${dLevel == "T"}'> selected="selected"</c:if>>T</option>
										<option value="R"<c:if test='${dLevel == "R"}'> selected="selected"</c:if>>R</option>
										<option value="C"<c:if test='${dLevel == "C"}'> selected="selected"</c:if>>C</option>
										<option value="B1"<c:if test='${dLevel == "B1"}'> selected="selected"</c:if>>B1</option>
										<option value="B2"<c:if test='${dLevel == "B2"}'> selected="selected"</c:if>>B2</option>
										<option value="A"<c:if test='${dLevel == "A"}'> selected="selected"</c:if>>A</option>
										<option value="As"<c:if test='${dLevel == "As"}'> selected="selected"</c:if>>As</option> --%>
									</select>
									</div>
								</div>
							 </td>
					        <th>안전교육이수여부<br />(유효기간)</th>
					        <td>
								<div class="form_group">
									<div class="radio_inline">
									<c:set var='dEdu' value='${driver.DEdu }' />
					        			<label class="radio_default"><input type="radio" name="dEdu" id="dEduY" value="Y"<c:if test='${dEdu == "Y"}'> checked="checked"</c:if>/><span class="radio_icon"></span>이수&nbsp;
					        			<label class="radio_default"><input type="radio" name="dEdu" id="dEduN" value="N"<c:if test='${dEdu == "N"}'> checked="checked"</c:if>/><span class="radio_icon"></span>미이수
									</div>
								</div>
								<div class="form_group">
								<c:set var='deduEndDt' value='${driver.DEduEndDt }' />
									<input type="text" id="dEduEndDt" class="form_control date1 dateicon" placeholder="YYYY-MM-DD" name="dEduEndDt" 
									value="<c:if test="${driver.DEduEndDt ne ''}">${fn:substring(deduEndDt,0,4) }-${fn:substring(deduEndDt,4,6) }-${fn:substring(deduEndDt,6,8) }</c:if>" autocomplete="off" />
								</div>
							 </td>
					    </tr>
					</table>
					</section>
					<h3 class="stitle m-t-30">관리자 메모</h3>
					<div class="tbl_wrap_view m-t-10">
					<table class="tbl_view01" summary="관리자 메모테이블입니다. 항목으로는 관리자 메모가 있습니다.">
					    <caption>관리자 메모테이블입니다.</caption>
					    <colgroup>
					        <col width="180px;" />
					        <col width="" />
					    </colgroup>
					    <tr>
					        <th scope="row">메모</th>
					        <td colspan="3">
					            <div class="form_group w_full"><textarea name="dMemo" id="dMemo" cols="" rows="5" class="form_control  h100" placeholder="메모를 입력하세요." style="resize: none;">${driver.DMemo }</textarea></div>
					        </td>
					    </tr>
					 </table>
					</div>
					</div>
						<section class="btn_wrap tac m-t-50">
					  	    <button type="button" id="listBtn" class="btn-sb btn_gray">목록</button>
							<c:if test="${dapproval=='N' }">
							    <button type="button" class="btn-line-b btn_gray m-r-6" data-layer="reason">가입반려</button>
							    <button type="button" id="goApproval" class="btn-line-b btn_default">가입승인</button>
							</c:if>
							<c:if test="${dapproval=='Y' }">
							    <button type="button" id="btnUpt" class="btn-sb btn_default">수정</button>
							</c:if>
						</section>
					</div>
					<!-- 상세보기 끝 -->
				</div>
				<!-- //tab1-운전자 신청내역 -->
			</div>
		</div>
		<!-- //tab -->
	</div>
	<!-- //content -->
</div>

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
                <p>선택한 항목에 대해<br />반려하시겠습니까?</p>
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
   
<!-- popup_m -->
<div class="ly_group">
    <article class="layer_m reason_result">
        <!-- # 타이틀 # -->
        <h1>사유등록/보기</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <div class="info_text03">
                <p>${driver.DMemo }</p>
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

<span id="pageNo" style="display:none">${driver.pageNo }</span>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp"%>