<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:csrfMetaTags/>
<style>
.bg_blue{background-color: #e5f5ff !important}
.bg_red{background-color:#ffa9a9 !important}
.bg_red2{background-color:#ffefe5 !important}
</style>
<script>
$(function(){
	search(1);
	//페이징 조회 버튼
	$(document).on("click",".pageNo",function(){  // $(".pageNo").click(function(){
		search($(this).attr("data-page"));
	});
})
//조회
function search(page){
	var param = {
			pageNo:page
	}
	postAjax("/user/myPageCal/search",param,"searchCallback",null,null,null);
}
//조회콜백
function searchCallback(data){
	$("#calList").html("");
	var html = '';
	var list = data.list;
	if(list.length > 0){
		$.each(list,function(i,el){
			console.log(list[i]);
			html += '<tr onmouseover="this.className=\'on\'" onmouseout="this.className=\'\'"onclick="thisChk(\''+list[i].reservCode+'\');">';
	        html += '    <td>';
	        html += '<div class="form_group single">                               ';
	        html += '    <div class="check_inline">                                ';
	        html += '        <label class="check_default single">                  ';
	        html += '            <input type="checkbox" name="reservCode" value="'+list[i].reservCode+'" data-opt="'+list[i].reservCode+'">   ';
	        html += '            <span class="check_icon"></span></label>          ';
	        html += '    </div>                                                    ';
	        html += '</div>                                                        ';
	        html += '	</td>';
	        html += '    <td>';
	        html += 		list[i].reservCode+'';
// 	        html += 		list[i].reservCode+'<br />';
// 	        html += ' 		<button type="button" class="btn-line-s btn_gray" data-layer="estimate_detail">정산서 보기</button>';
	        html += '	</td>';
	        html += '    <td>'+list[i].regDt+'</td>';
	        html += '    <td>'+list[i].trackType+'</td>';
	        html += '    <td>'+list[i].track+'</td>';
	        html += '    <td>'+list[i].startDate+' ~ '+list[i].endDate+'</td>';
	        if(list[i].status =='Y'){
		        html += '    <td>정산완료</td>';
	        }else if(list[i].status =='N'){
		        html += '    <td>예약취소<br />';
		        html += '<button type="button" class="btn-line-s btn_default" onclick="memoPop(\''+list[i].memo+""+'\',event)">사유보기</button></td>';
	        }else if(list[i].status =='END'){
		        html += '    <td>정산완료</td>';
	        html += '';
	        }
	        html += '</tr>';
		})
	}else{
		html += '<tr class="tr_nodata">';
		html += '<td colspan="7">조회된 데이터가 없습니다.</td>';
		html += '</tr>';
	}
	$("#calList").html(html);
	drawingPage(data.paging);
}
//사유보기
function memoPop(str,e){
	e.stopPropagation();
	$("#memoText").html(str);
	$('[data-layer="approval01"]').click();
}
//체크박스 이벤트
function thisChk(str){
	if($("input[type='checkbox'][data-opt='"+str+"']").prop("checked")){
		$("input[type='checkbox'][data-opt='"+str+"']").prop("checked",false);
	}else{
		$("input[type='checkbox'][data-opt='"+str+"']").prop("checked",true);
		//두개일때
// 		if($("input[type='checkbox']:checked").length>2){
// 			alert("하나의 시험로와 하나의 부대시설만<br/> 체크 가능합니다.");
// 			$("input[type='checkbox'][data-opt='"+str+"']").prop("checked",false);
// 		}
		//한개씩으로 처리
		var cntT = 0;
		var cntF = 0;
		$("input[type='checkbox']:checked").each(function(){
			if(this.value.indexOf("T")!=-1){
				cntT+=1;
			}
			if(this.value.indexOf("F")!=-1){
				cntF+=1;
			}
		})
// 		if(cntT>1 || cntF>1){
// 			alert("하나의 시험로와 하나의 부대시설만<br/> 체크 가능합니다.");
// 			$("input[type='checkbox'][data-opt='"+str+"']").prop("checked",false);
// 		}
	}
}
//상세내역 팝업 오픈
function detailBtn(){
	if($("input[type='checkbox']:checked").length==0){
		alert("항목을 체크해 주세요.");
		return;
	}else{
		var codeArr=[];
		var cntT = 0;
		var cntF = 0;
		$("input[type='checkbox']:checked").each(function(){
			codeArr.push(this.value);
			if(this.value.indexOf("T")!=-1){
				cntT+=1;
			}
			if(this.value.indexOf("F")!=-1){
				cntF+=1;
			}
		});
		console.log("클릭",codeArr);
		console.log("시험로예약 건수",cntT);
		console.log("부대시설 예약 건수",cntF);
		if(cntT>0){
			$(".trackarea").show();
		}else{
			$(".trackarea").hide();
		}

	}
	//팝업 내용 조회 ajax
	var param = {
			codeArr : codeArr
	}
	var csrfHeader = $('meta[name="_csrf_header"]').attr('content');
	var csrfToken = $('meta[name="_csrf"]').attr('content');
	$.ajax({
		url : "/user/myPageCal/popSearch",
		type : "post",
		data : param,
		beforeSend: function(xhr) {
            xhr.setRequestHeader(csrfHeader, csrfToken);
        },
		success : function(result){
          $("#cancelInfo").hide();
			if(cntT>0){//시험로가 주행이 있을 때
				//사용내역 예약번호 + 사용일자
				var resCodeHtml = '';
				var tcDayHtml = '';
				calVoList = result.calVo;
				if(calVoList.length>0){
					$.each(calVoList,function(i,el){
						resCodeHtml+= result.calVo[i].reservCode + '</br>';
						tcDayHtml+= result.calVo[i].startDate+" ~ "+result.calVo[i].endDate + '</br>';
					})
				}
				$("#resCode").html(resCodeHtml);//예약번호
				$("#tcDay").html(tcDayHtml);//사용일자
// 				$("#resCode").text(result.calVo[0].reservCode);//예약번호
// 				$("#tcDay").text(result.calVo[0].startDate+" ~ "+result.calVo[0].endDate);//사용일자
				//사용 내역
				var logHtml = '';
				var logList = result.inoutList;
				if(logList.length>0){
					$.each(logList,function(i,el){
						logHtml +='<tr>';
						logHtml +='<td>'+changeDateFormat(logList[i].inTime)+'</td>';
						logHtml +='<td>'+changeDateFormat(logList[i].outTime)+'</td>';
						logHtml +='<td>'+logList[i].reservCode+'</td>';
						logHtml +='<td>'+logList[i].diffTime+'</td>';
// 						logHtml +='<td>'+moment.duration(moment(logList[i].outTime,"YYYYMMDDHHmmss").diff(moment(logList[i].inTime,"YYYYMMDDHHmmss"))).asMinutes()+'</td>';
						logHtml +='<td>'+logList[i].track+'</td>';
						logHtml +='<td>'+logList[i].tagId+'</td>';
						logHtml +='</tr>';
					})
				}else{
					logHtml += '<tr class="tr_nodata">';
					logHtml += '<td colspan="6">사용한 이력이 없습니다.</td>';
					logHtml += '</tr>';
				}
				$("#rfidLogList").html(logHtml);

				//이용정보
				var payHtml = '';
				var payList = result.payList;
				var sumPay = 0;
				var enterPay = 0;
				var shopI = 0;
				var payResult = 0;
				console.log("pay = ",payList);
				if(payList.length>0){
					$.each(payList,function(i,el){
// 						payHtml +='<tr>';
						//취소 색 변경 처리
			 			if(payList[i].puseTime == 0 && payList[i].ppayType != "DEFAULT"){
			 				payHtml +='<tr class="bg_red2">';
			 				$("#cancelInfo").show();
			 			}else if(payList[i].ppayType == "DEFAULT"){
			 				payHtml +='<tr class="bg_blue">';
			 			}else {
			 				payHtml +='<tr>';
			 			}
						payHtml +='<td>'+payList[i].preservCode+'</td>';
						payHtml +='<td>'+payList[i].pday+'</td>';
						payHtml +='<td>'+payList[i].ptype+'</td>';
						payHtml +='<td>'+payList[i].tid+'</td>';
						if(payList[i].ptype == '부대시설'){
							shopI = i;
							payHtml +='<td>'+payList[i].puseTime+'일</td>';
							payHtml +='<td>'+payList[i].papplyTime+'일</td>';
						}else if (payList[i].ptype == '입장료') {

							payHtml +='<td>'+payList[i].puseTime+'대</td>';
							payHtml +='<td></td>';
						}else{
                          payHtml +='<td>'+payList[i].puseTime+'분</td>';
                          payHtml +='<td class="'+payList[i].preservCode+payList[i].ppayType+payList[i].pday.replace(/\./gi,"")+'">'+payList[i].papplyTime+'분</td>';
                        }
						payHtml +='<td>'+comma(payList[i].pproductPay)+'</td>';
						payHtml +='<td>'+payList[i].pdiscount+'</td>';
						payHtml +='<td class="'+payList[i].preservCode+payList[i].ppayType+'2'+payList[i].pday.replace(/\./gi,"")+'">'+comma(payList[i].ppay)+'</td>';
						payHtml +='</tr>';
						if (payList[i].ptype == '입장료') {
						  enterPay += Number(payList[i].ppay);
                        } else {
                          sumPay += Number(payList[i].ppay);
                        }
					});
					payResult = sumPay+enterPay;
					$("#payList").html(payHtml);
					$("#sumPay").text(comma(sumPay));
					$("#sumEnter").text(comma(enterPay));
					$("#sumPayTax").text(comma(parseInt(payResult*0.1)));
	 				$("#cancelPay").text(payList[shopI].pcancelPercent+"%");
					$("#realSum").text(comma(parseInt(payResult*1.1)));


					$.each(payList,function(i,el){
						funRowspan(payList[i].preservCode+"DEFAULT"+payList[i].pday.replace(/\./gi,""));
						funRowspan(payList[i].preservCode+"DEFAULT2"+payList[i].pday.replace(/\./gi,""));
					});
				}else{
					payHtml += '<tr class="tr_nodata">';
					payHtml += '<td colspan="9">정산된 내역이 없습니다.</td>';
					payHtml += '</tr>';
					$("#payList").html(payHtml);
					$("#sumPay").text("");
					$("#sumEnter").text("");
					$("#sumPayTax").text("");
//	 				$("#cancelPay").text(comma(sumPay));
					$("#cancelPay").text("");
					$("#realSum").text("");
				}


			}else{//시험로 주행이 없을 때
				//이용정보
				var payHtml = '';
				var payList = result.payList;
				var sumPay = 0;
				if(payList.length>0){
					$.each(payList,function(i,el){
						//취소 색 변경 처리
			 			if(payList[i].puseTime == 0){
			 				payHtml +='<tr class="bg_red2">';
                          $("#cancelInfo").show();
			 			}else{
			 				payHtml +='<tr>';
			 			}
// 						payHtml +='<tr>';
						payHtml +='<td>'+payList[i].preservCode+'</td>';
						payHtml +='<td>'+payList[i].pday+'</td>';
						payHtml +='<td>'+payList[i].ptype+'</td>';
						payHtml +='<td>'+payList[i].tid+'</td>';
						payHtml +='<td>'+payList[i].puseTime+'일</td>';
						payHtml +='<td>'+payList[i].papplyTime+'일</td>';
						payHtml +='<td>'+comma(payList[i].pproductPay)+'</td>';
						payHtml +='<td>'+payList[i].pdiscount+'</td>';
						payHtml +='<td>'+comma(payList[i].ppay)+'</td>';
						payHtml +='</tr>';
						sumPay += Number(payList[i].ppay);
					})
					$("#payList").html(payHtml);
					$("#sumPay").text(comma(sumPay));
					$("#sumEnter").text(comma(0));
					$("#sumPayTax").text(comma(parseInt(sumPay*0.1)));
//	 				$("#cancelPay").text(comma(sumPay));
					$("#cancelPay").text(payList[0].pcancelPercent+"%");
					$("#realSum").text(comma(parseInt(sumPay*1.1)));
				}else{
					payHtml += '<tr class="tr_nodata">';
					payHtml += '<td colspan="9">정산된 내역이 없습니다.</td>';
					payHtml += '</tr>';
					$("#payList").html(payHtml);
					$("#sumPay").text("");
					$("#sumEnter").text("");
					$("#sumPayTax").text("");
//	 				$("#cancelPay").text(comma(sumPay));
					$("#cancelPay").text("");
					$("#realSum").text("");
				}

			}

			//팝업 콜백
			searchPopCallback(result);
		},
		error : function(e){
			console.log(e);
			alert("세션이 종료되었습니다.<br>다시 로그인 해주시길 바랍니다.");
			$(".lyClose").click(function(){
				location.reload();
			})
		}
	});

}
//팝업 조회
function searchPopCallback(data){
	//상세내역 팝업 버튼(히든)
	$("#estimatieBtn").click();
	if($( window ).height()<800){
		$("#printarea").css({"top":"60%","height":"95%"});//팝업 사이즈 임시 조절
	}
}

//인쇄하기
function print() {
	$(".hidetag").hide();
	$(".trackarea").hide();
	var divToPrint=document.getElementById('printarea');
	var newWin=window.open('','Print-Window');
	newWin.document.open();
	newWin.document.write('<html><link rel="stylesheet" type="text/css" href="/inc/css/default.css"><link rel="stylesheet" type="text/css" href="/inc/css/common.css"><link rel="stylesheet" type="text/css" href="/inc/css/print.css"><link rel="stylesheet" type="text/css" href="/inc/css/font.css"><link rel="stylesheet" type="text/css" href="/inc/css/layout.css"><link rel="stylesheet" type="text/css" href="/inc/css/daterangepicker.css"><link rel="stylesheet" type="text/css" href="/inc/css/jquery-ui.css"><body onload="setTimeout(function(){window.print();},500)" style="width:1150px;height:auto;">'+divToPrint.innerHTML+'</body></html>');
	newWin.document.close();
	setTimeout(function(){newWin.close();},1000);
	var cntT = 0;
	var cntF = 0;
	$("input[type='checkbox']:checked").each(function(){
		if(this.value.indexOf("T")!=-1){
			cntT+=1;
		}
		if(this.value.indexOf("F")!=-1){
			cntF+=1;
		}
	});
	if(cntT>0){
		$(".trackarea").show();
	}else{
		$(".trackarea").hide();
	}
	$(".hidetag").show();
}
</script>
<!-- container -->
<div id="container">
    <!-- visual -->
    <div class="visual_sub mypage"></div>
    <!-- //visual -->
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
       	<button type="button" class="memoBtn" style="display:hidden;" data-layer="approval01"></button>
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>마이페이지</span><span>정산관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">정산관리</h2>
        <!-- //title -->
        <!-- table list -->
        <section class="tbl_wrap_list">
            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                <caption>테이블</caption>
                <colgroup>
                    <col width="11%" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                </colgroup>
                <thead>
                <tr>
                    <th scope="col">선택</th>
                    <th scope="col">예약번호</th>
                    <th scope="col">접수일자</th>
                    <th scope="col">유형</th>
                    <th scope="col">항목</th>
                    <th scope="col">이용일시</th>
                    <th scope="col">상태</th>
                </tr>
                </thead>
                <tbody id="calList">
                </tbody>
            </table>
        </section>
        <!-- //table list -->
        <!-- //table list -->
		<section id="pagingc" class="pagination m-t-30">
			<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
		</section>
            <input type="button" style="display:none" data-layer=estimate id="estimatieBtn">
            <button type="button" class="btn btn_default m-t-6" style="margin-bottom: 3px;" onclick="detailBtn();">정산서 보기</button>
        <!-- //Pagination -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<!-- popup_m 반려사유 팝업 -->
<div class="ly_group">
    <article class="layer_m approval01">
        <!-- # 타이틀 # -->
        <h1>사유보기</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <div class="info_text02">
                <p></p>
                <p id="memoText"></p>
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

<!-- popup_xxl 상세 내역 팝업-->
<div class="ly_group">
    <article class="layer_xxl estimate printarea"id="printarea">
        <!-- # 타이틀 # -->
        <h1 class="hidetag">정산서 보기</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <h2>사용 내역서<button type="button" class="btn-line btn_gray hidetag" id="printBtn" onclick="print()">인쇄</button></h2>
            <section class="m-t-59">
                <div class="col">
                    <h3 class="stitle">공급자 정보</h3>
                    <!-- table_view -->
                    <div class="tbl_wrap_view m-t-10">
                        <table class="tbl_view01" summary="테이블입니다.">
                            <caption>테이블입니다.</caption>
                            <colgroup>
                                <col width="140px;" />
                                <col width="" />
                            </colgroup>
                            <tr>
                                <th scope="row">상호</th>
                                <td>한국타이어</td>
                            </tr>
                            <tr>
                                <th scope="row">주소</th>
                                <td>(88989)경기도 성남시 분당구 판교로<br />255번길 한국타이어</td>
                            </tr>
                            <tr>
                                <th scope="row">담당자</th>
                                <td>김운전</td>
                            </tr>
                            <tr>
                                <th scope="row">전화번호</th>
                                <td>02-1234-5678</td>
                            </tr>
                            <tr>
                                <th scope="row">휴대전화</th>
                                <td>010-1234-5678</td>
                            </tr>
                            <tr>
                                <th scope="row">팩스</th>
                                <td>02-1234-5678</td>
                            </tr>
                            <tr>
                                <th scope="row">이메일 주소</th>
                                <td>test@test.com</td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_view -->
                </div>
                <div class="col m-l-30">
                    <h3 class="stitle">사용자 정보</h3>
                    <!-- table_view -->
                    <div class="tbl_wrap_view m-t-10">
                        <table class="tbl_view01" summary="테이블입니다.">
                            <caption>테이블입니다.</caption>
                            <colgroup>
                                <col width="140px;" />
                                <col width="" />
                            </colgroup>
                            <tr>
                                <th scope="row">상호</th>
                                <td><%=memberDto.getCompName()%></td>
                            </tr>
                            <tr>
                                <th scope="row">주소</th>
                                <td><%=memberDto.getCompAddr()%> <%=memberDto.getCompAddrDetail()%></td>
                            </tr>
                            <tr>
                                <th scope="row">담당자</th>
                                <td><%=memberDto.getMemName()%></td>
                            </tr>
                            <tr>
                                <th scope="row">전화번호</th>
                                <td><%=memberDto.getCompPhone()%></td>
                            </tr>
                            <tr>
                                <th scope="row">휴대전화</th>
                                <td><%=memberDto.getMemPhone()%></td>
                            </tr>
                            <tr>
                                <th scope="row">이메일 주소</th>
                                <td><%=memberDto.getMemEmail()%></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_view -->
                </div>
            </section>
            <h3 class="stitle m-t-30">이용 정보
                <span id="cancelInfo" class="info_ment_orange" style="display: none">취소 위약금은 한국타이어 기본 금액 기준으로 계산되었습니다.</span>
            </h3>
            <!-- table list -->
            <section class="tbl_wrap_list m-t-10">
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
                        <col width="" />
                        <col width="" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">예약번호</th>
                        <th scope="col">예약일시</th>
                        <th scope="col">유형</th>
                        <th scope="col">항목</th>
                        <th scope="col">실사용시간</th>
                        <th scope="col">적용시간</th>
                        <th scope="col">공급금액</th>
                        <th scope="col">할인율</th>
                        <th scope="col">합계</th>
                    </tr>
                    </thead>
                    <tbody id="payList">
                    	<tr>
                    		<td colspan="9">정산된 내역이 없습니다.</td>
                    	</tr>
<!--                     <tr> -->
<!--                         <td>2020010101</td> -->
<!--                         <td>2021.09.02</td> -->
<!--                         <td>단독</td> -->
<!--                         <td>고속주회로</td> -->
<!--                         <td>4시간</td> -->
<!--                         <td>4시간</td> -->
<!--                         <td class="tar">300,000</td> -->
<!--                         <td class="tar">10%</td> -->
<!--                         <td class="tar">270,000</td> -->
<!--                     </tr> -->
<!--                     <tr> -->
<!--                         <td>2020010101</td> -->
<!--                         <td>2021.09.02</td> -->
<!--                         <td>단독</td> -->
<!--                         <td>고속주회로</td> -->
<!--                         <td>4시간</td> -->
<!--                         <td>4시간</td> -->
<!--                         <td class="tar">300,000</td> -->
<!--                         <td class="tar">10%</td> -->
<!--                         <td class="tar">270,000</td> -->
<!--                     </tr> -->
<!--                     <tr> -->
<!--                         <td>2020010101</td> -->
<!--                         <td>2021.09.02</td> -->
<!--                         <td>단독</td> -->
<!--                         <td>고속주회로</td> -->
<!--                         <td>4시간</td> -->
<!--                         <td>4시간</td> -->
<!--                         <td class="tar">300,000</td> -->
<!--                         <td class="tar">10%</td> -->
<!--                         <td class="tar">270,000</td> -->
<!--                     </tr> -->
<!--                     <tr> -->
<!--                         <td>2020010101</td> -->
<!--                         <td>2021.09.02</td> -->
<!--                         <td>부대시설</td> -->
<!--                         <td>테스트워크샵동</td> -->
<!--                         <td>1일</td> -->
<!--                         <td>1일</td> -->
<!--                         <td class="tar">100,000</td> -->
<!--                         <td class="tar">10%</td> -->
<!--                         <td class="tar">90,000</td> -->
<!--                     </tr> -->
                    </tbody>
                </table>
            </section>
            <!-- //table list -->
            <section class="m-t-50 h162">
                <!-- table_view -->
                <div class="tbl_wrap_view w398 fr">
                    <table class="tbl_view01" summary="테이블입니다.">
                        <caption>테이블입니다.</caption>
                        <colgroup>
                            <col width="150px;" />
                            <col width="" />
                        </colgroup>
                        <tr>
                            <th scope="row">공급금액 합계</th>
                            <td class="tar" id="sumPay"><!-- 900,000 --></td>
                        </tr>
                        <tr>
                            <th scope="row">입장료 합계</th>
                            <td class="tar" id="sumEnter"><!-- 900,000 --></td>
                        </tr>
                        <tr>
                            <th scope="row">부가세 (10%)</th>
                            <td class="tar" id="sumPayTax"><!-- 90,000 --></td>
                        </tr>
                        <tr>
                            <th scope="row">취소 위약금</th>
                            <td class="tar" id="cancelPay"><!-- 100% --></td>
                        </tr>
                        <tr>
                            <th scope="row">합계</th>
                            <td class="tar" id="realSum"><!-- 990,000 --></td>
                        </tr>
                    </table>
                </div>
                <!-- //table_view -->
            </section>
            <section class="text_estimate m-t-57">
                <!-- <p>2021년 8월 11일</p> -->
                <p>상기와 같이 청구합니다.</p>
            </section>
            <section class="footer_estimate m-t-45">
                <!-- <span class="info_ment_orange m-t-6">상기 견적내용은 참고용이며, 공식문서로 사용될 수 없습니다.</span> -->
                <img src="/inc/images/ci_hankook_estimate.png" alt="Hankook" style="right:3%;"/>
            </section>
        </div>

		<hr>

        <!-- # 타이틀 # -->
        <div class="ly_con trackarea">
            <h2>주행 시험장 사용 내역서</h2>
            <h3 class="stitle m-t-59">사용 내역</h3>
            <!-- table_view -->
            <div class="tbl_wrap_view m-t-10">
                <table class="tbl_view01" summary="테이블입니다.">
                    <caption>테이블입니다.</caption>
                    <colgroup>
                        <col width="200px;" />
                        <col width="" />
                        <col width="200px;" />
                        <col width="" />
                    </colgroup>
                    <tr>
                        <th scope="row">예약번호</th>
                        <td id="resCode"></td>
                        <th scope="row">사용일자</th>
                        <td id="tcDay"></td>
                    </tr>
                </table>
            </div>
            <!-- //table_view -->
            <!-- table list -->
            <section class="tbl_wrap_list m-t-20">
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
                        <th scope="col">입차시간</th>
                        <th scope="col">출차시간</th>
                        <th scope="col">예약번호</th>
                        <th scope="col">소요시간</th>
                        <th scope="col">시험로</th>
                        <th scope="col">RFID ID</th>
                    </tr>
                    </thead>
                    <tbody id="rfidLogList">
<!--                     <tr> -->
<!--                         <td>13:01:01</td> -->
<!--                         <td>16:00:00</td> -->
<!--                         <td>240</td> -->
<!--                         <td>고속주회로</td> -->
<!--                         <td>RF00001</td> -->
<!--                     </tr> -->
<!--                     <tr> -->
<!--                         <td>13:01:01</td> -->
<!--                         <td>16:00:00</td> -->
<!--                         <td>240</td> -->
<!--                         <td>고속주회로</td> -->
<!--                         <td>RF00001</td> -->
<!--                     </tr> -->
<!--                     <tr> -->
<!--                         <td>13:01:01</td> -->
<!--                         <td>16:00:00</td> -->
<!--                         <td>240</td> -->
<!--                         <td>고속주회로</td> -->
<!--                         <td>RF00001</td> -->
<!--                     </tr> -->
<!--                     <tr> -->
<!--                         <td>13:01:01</td> -->
<!--                         <td>16:00:00</td> -->
<!--                         <td>240</td> -->
<!--                         <td>고속주회로</td> -->
<!--                         <td>RF00001</td> -->
<!--                     </tr> -->
<!--                     <tr> -->
<!--                         <td>13:01:01</td> -->
<!--                         <td>16:00:00</td> -->
<!--                         <td>240</td> -->
<!--                         <td>고속주회로</td> -->
<!--                         <td>RF00001</td> -->
<!--                     </tr> -->
<!--                     <tr> -->
<!--                         <td>13:01:01</td> -->
<!--                         <td>16:00:00</td> -->
<!--                         <td>240</td> -->
<!--                         <td>고속주회로</td> -->
<!--                         <td>RF00001</td> -->
<!--                     </tr> -->
<!--                     <tr> -->
<!--                         <td>13:01:01</td> -->
<!--                         <td>16:00:00</td> -->
<!--                         <td>240</td> -->
<!--                         <td>고속주회로</td> -->
<!--                         <td>RF00001</td> -->
<!--                     </tr> -->
<!--                     <tr> -->
<!--                         <td>13:01:01</td> -->
<!--                         <td>16:00:00</td> -->
<!--                         <td>240</td> -->
<!--                         <td>고속주회로</td> -->
<!--                         <td>RF00001</td> -->
<!--                     </tr> -->
<!--                     <tr> -->
<!--                         <td>13:01:01</td> -->
<!--                         <td>16:00:00</td> -->
<!--                         <td>240</td> -->
<!--                         <td>고속주회로</td> -->
<!--                         <td>RF00001</td> -->
<!--                     </tr> -->
                    </tbody>
                </table>
            </section>
            <!-- //table list -->
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose" class="hidetag">레이어닫기</button>
    </article>
</div>
<!-- //popup_xxl -->
<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>