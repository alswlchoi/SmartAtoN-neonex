<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){

})
//탭 이동
function pageMove(str){
	if(str=='tab1'){
		location.href = '/admin/trReserve/accounts';
	}else if(str == 'tab2'){
		location.href = '/admin/trReserve/shop';
	}
}


</script>
<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>예약/정산관리</span><span>정산관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">정산관리</h2>
        <!-- //title -->
<%-- 		${chargeDto} --%>
<%-- 		${list} --%>
<%-- 		${carlist} --%>
        <!-- tab -->
        <div class="wrap_tab">
            <div class="tab">
                <button class="tablinks active" onclick="pageMove('tab1')" id="defaultOpen">시험로</button>
                <button class="tablinks" onclick="pageMove('tab2')">부대시설</button>
            </div>
            <div class="wrap_tabcontent">
                <!-- tab1-시험로 -->
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
                                <col width="" />
                                <col width="" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">예약번호</th>
                                    <th scope="col">접수일자</th>
                                    <th scope="col">이용일자</th>
                                    <th scope="col">유형</th>
                                    <th scope="col">항목</th>
                                    <th scope="col">회사명</th>
                                    <th scope="col">상태</th>
                                    <th scope="col">취소일시</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>${chargeDto.tcReservCode}</td>
                                    <td><c:set var="comReDt" value="${chargeDto.tcRegDt}"/>${fn:substring(comReDt,0,4) }.${fn:substring(comReDt,4,6) }.${fn:substring(comReDt,6,8) }</td>
           							
           							<td><c:set var="wssStDay" value="${chargeDto.tcDay}"/>${fn:substring(wssStDay,0,4)}.${fn:substring(wssStDay,4,6)}.${fn:substring(wssStDay,6,8)}&nbsp;
                               	    ~&nbsp;<c:set var="wssEdDay" value="${chargeDto.tcDay2}"/>${fn:substring(wssEdDay,0,4)}.${fn:substring(wssEdDay,4,6)}.${fn:substring(wssEdDay,6,8)}
                               	    <c:if test="${!empty(realday)}"><div style="padding-top:5px"><span class="color_orange">실제사용일 </span>${realday}</div></c:if>
                               	    </td>
           							
                                    <td>
                                    <c:if test="${chargeDto.trTrackType eq 'TYP00'}">공동</c:if>
									<c:if test="${chargeDto.trTrackType eq 'TYP01'}">단독</c:if>
                                    </td>
                                    
                                    <td>
                                    <c:forTokens items="${chargeDto.trTrackName}" delims="#" var="item">
                                        ${item}<br/>
                                    </c:forTokens>
                                    </td>
                                    <td>${chargeDto.compName}
                                    <c:if test="${chargeDto.blackList eq 'Y'}">
									<span class="color_red">(B/L)</span></c:if>      
                                    </td>
                                    <td>
                                    <c:if test="${chargeDto.tcApproval eq 3}"><span class="color_red">정산완료</span> </c:if>
                                    <c:if test="${chargeDto.tcApproval eq 2}"><span class="color_red">예약취소</span> </c:if>
                                    </td>
                                    <td>
                                    <c:if test="${chargeDto.tcApproval eq '2'}"><c:set var="wssModDt" value="${chargeDto.tcModDt}"/>${fn:substring(wssModDt,0,4) }.${fn:substring(wssModDt,4,6) }.${fn:substring(wssModDt,6,8) }
                                    </c:if>                                 
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
                                <table class="tbl_view01" summary="테이블입니다.">
                                    <caption>테이블입니다.</caption>
                                    <colgroup>
                                        <col width="180px;" />
                                        <col width="" />
                                    </colgroup>
                                    <tr>
                                        <th scope="row">운전자</th>
                                        <td colspan="3">
                                       	<c:forEach var="item" items="${listt}">
                                        	${item.DName}
                                        	<br />
                                    	</c:forEach>                                        
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">시험차종</th>
                                        <td colspan="3">                                        
                                        <c:forEach var="item" items="${list}">
                                        	${item.CName} (${item.CColor} / ${item.CNumber})
                                        	<c:if test='${item.CType =="S" }'>
                                        		<span class="color_red"> - 특수차량</span>
                                        	</c:if>
                                        	<br />
                                        </c:forEach>                                 
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">시험 종류 및 방법</th>
                                        <td colspan="3"> ${chargeDto.tcPurpose} </td>
                                    </tr>
                                </table>
                            </div>
                            <!-- //table_view -->
                        </div>
                    </div>
                    <!-- //accordion -->
                    <!-- //시험정보 -->

                    <!-- 예약 담당자 및 회계 담당자 정보 -->
                    <!-- accordion -->
                    <div class="wrap_accordion2 m-t-30">
                        <button class="accordion open">
                            <h3 class="stitle disib vam0">예약 담당자 및 회계 담당자 정보</h3>
                        </button>
                        <div class="accordion_panel" style="display: block;">
                            <!-- table_view -->
                            <section class="tbl_wrap_view">
                                <table class="tbl_view01" summary="테이블입니다.">
                                    <caption>테이블입니다.</caption>
                                    <colgroup>
                                        <col width="180px;" />
                                        <col width="" />
                                        <col width="180px;" />
                                        <col width="" />
                                    </colgroup>
                                    <tr>
                                        <th scope="row">회사명</th>
                                        <td>${chargeDto.compName}
										<c:if test="${chargeDto.blackList eq 'Y'}">
										<span class="color_red">(B/L)</span></c:if>                                    
                                        </td>
                                        <th>사업자등록번호</th>
                                        <td>${chargeDto.compLicense}</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">예약담당자</th>
                                        <td>${chargeDto.memName}</td>
                                        <th>부서</th>
                                        <td>${chargeDto.memDept}</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">휴대폰 번호</th>
                                        <td>${chargeDto.memPhone}</td>
                                        <th>전화번호</th>
                                        <td>${chargeDto.memPhone}</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">이메일 주소</th>
                                        <td colspan="3">${chargeDto.memEmail}</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">회계담당자</th>
                                        <td>${chargeDto.compAcctName}</td>
                                        <th>부서</th>
                                        <td>${chargeDto.compAcctDept}</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">이메일 주소</th>
                                        <td>${chargeDto.compAcctEmail}</td>
                                        <th>전화번호</th>
                                        <td>${chargeDto.compAcctPhone}</td>
                                    </tr>
                                </table>
                            </section>
                            <!-- //table_view -->
                        </div>
                    </div>
                    <!-- //accordion -->
                    <!-- //예약 담당자 및 회계 담당자 정보 -->

                    <!-- 출입차 이력 -->
                    <!-- accordion -->
                    <div class="wrap_accordion2 m-t-30">
                        <button class="accordion open">
                            <h3 class="stitle disib vam0">출입차 이력 : 차량 RFID 정보 <span class="color_orange">  </span> 
                                    </h3>
                        </button>
                        <div class="accordion_panel" style="display: block;">
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
                                        	<th scope="col">차량RFID정보</th>
                                            <th scope="col">입차시간</th>
                                            <th scope="col">출차시간</th>
                                            <th scope="col">소요시간(분)</th>
                                            <th scope="col">시험로</th>
                                            <th scope="col">비고</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <c:choose>
                                    	<c:when test="${empty carlist}">
                                    		<tr>
                                        	<td colspan="6">데이터가 없습니다</td>
                                        	</tr>
                                    	</c:when>
                                    	<c:otherwise>
                                    		<c:forEach var="items" items="${carlist}">
                                    		<tr>
                                        	<td>${items.carTagId}</td>
                                        	<td><c:set var="intime" value="${items.inTime}"/>${fn:substring(intime,0,4) }.${fn:substring(intime,4,6) }.${fn:substring(intime,6,8) }.${fn:substring(intime,8,10) }:${fn:substring(intime,10,12) } </td>
                                        	<td><c:set var="outtime" value="${items.outTime}"/>${fn:substring(outtime,0,4) }.${fn:substring(outtime,4,6) }.${fn:substring(outtime,6,8) }.${fn:substring(outtime,8,10) }:${fn:substring(outtime,10,12) } </td>                                        	
                                        	<td>${items.hours }</td>
                                        	<td>${items.TName}</td>
                                        	<td></td>
                                    		</tr>
                                    	</c:forEach>
                                    	</c:otherwise>
                                    </c:choose>
                                                                        
                                    </tbody>
                                </table>
                            </section>
                            <!-- //table list -->
                        </div>
                    </div>
                    <!-- //accordion -->
                    <!-- //출입차 이력 -->

                    <!-- 수수료 내역 -->
                    <!-- accordion -->
                    <div class="wrap_accordion2 m-t-30">
                        <button class="accordion open">
                            <h3 class="stitle disib vam0">수수료 내역</h3>
                        </button>
                        <div class="accordion_panel" style="display: block;">
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
                                        <col width="" />
                                        <col width="" />
                                        <col width="" />
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col">유형</th>
                                            <th scope="col">항목</th>
                                            <th scope="col">실사용시간(분)</th>
                                            <th scope="col">적용시간(분)</th>
                                            <th scope="col">공급금액</th>
                                            <th scope="col">할인율</th>
                                            <th scope="col">할인된 금액</th>
                                            <th scope="col">부가세(10%별도)</th>
                                            <th scope="col">합계</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:forEach var="item" items="${chargelist}">
                                    		<tr>
                                    			<td>
                                    			<c:if test="${chargeDto.trTrackType eq 'TYP00'}">공동</c:if>
												<c:if test="${chargeDto.trTrackType eq 'TYP01'}">단독</c:if>
                                    			</td>
                                    			<td>${item.TName}</td>
                                    			
                                    			<c:choose>
                                    				<c:when test="${item.TId eq 'T000' }">
                                    				<td>${item.PUseTime}대</td><!--실사용시간 -->
                                    				</c:when>
                                    				<c:otherwise>
                                    				<td>${item.PUseTime}</td><!--실사용시간 -->
                                    				</c:otherwise>
                                    			</c:choose>
                                    			
                                    			<c:choose>
                                    				<c:when test="${item.PApplyTime == 0 }">
                                    				<td class="tar"></td><!--적용시간  -->
                                    				</c:when>
                                    				<c:otherwise>
                                    				<td class="tar">${item.PApplyTime}</td><!--적용시간  -->
                                    				</c:otherwise>
                                    			</c:choose>
												
                                    			<td class="tar">
                                    			<fmt:formatNumber value="${item.PProductPay}" /> <!-- 공급금액(정가)  -->
                                    			</td>
                                    			<td class="tar">${item.PDiscount}</td><!-- 할인율  -->
                                    			<td class="tar">
                                    			<fmt:formatNumber value="${item.PPay}" />  <!-- 할인된 금액 -->
                                     			</td>
                                    			<td class="tar">
                                    			<fmt:formatNumber type="number" maxFractionDigits="0" value="${item.price}" /><!--부가세  -->
                                    			</td>
                                    			<td class="tar">
                                    			<fmt:formatNumber type="number" maxFractionDigits="0" value="${item.PPay+item.price}" /><!--합계  --> 
                                    			</td>                                 		
                                    		</tr>
                                    	</c:forEach>
                                       <!--  <tr>
                                            <td>공동</td>
                                            <td>고속주회로</td>
                                            <td>240분</td>
                                            <td>240분</td>
                                            <td class="tar">300,000</td>
                                            <td class="tar">10%</td>
                                            <td class="tar">30,000</td>
                                            <td class="tar">300,000</td>
                                        </tr> -->
                                        <!-- <tr>
                                            <td>공동</td>
                                            <td>고속주회로</td>
                                            <td>240분</td>
                                            <td>240분</td>
                                            <td class="tar">300,000</td>
                                            <td class="tar">10%</td>
                                            <td class="tar">30,000</td>
                                            <td class="tar">300,000</td>
                                        </tr>
                                        <tr>
                                            <td>공동</td>
                                            <td>고속주회로</td>
                                            <td>240분</td>
                                            <td>240분</td>
                                            <td class="tar">300,000</td>
                                            <td class="tar">10%</td>
                                            <td class="tar">30,000</td>
                                            <td class="tar">300,000</td>
                                        </tr>
                                        <tr class="bg_sum color_b333">
                                            <td>합계</td>
                                            <td>고속주회로 외</td>
                                            <td>900분</td>
                                            <td>900분</td>
                                            <td class="tar">600,000</td>
                                            <td class="tar">10%</td>
                                            <td class="tar">60,000</td>
                                            <td class="tar">760,000</td>
                                        </tr> -->
                                        <tr class="bg_total color_b333">
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td class="tar">총합</td>
                                            <td class="tar">
                                            <c:set var="total" value="0"/>
                                            <c:forEach var="result" items="${chargelist}" varStatus="status">
                                            	<c:set var="total" value="${total + result.PPay+result.price}"/>
                                            </c:forEach>
<%--                                             <c:out value="${total}"/> --%>
                                            <fmt:formatNumber type="number" maxFractionDigits="0" value="${total}" />
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </section>
                            <!-- //table list -->
                        </div>
                    </div>
                    <!-- //accordion -->
                    <!-- //수수료 내역 -->

                    <!-- button -->
                    <section class="btn_wrap m-t-50">
                        <button type="button" class="btn btn_gray" onclick="history.back()">목록</button>
                        <section>
                            <!-- <button type="button" class="btn btn_gray m-r-6" data-layer="cancel">취소</button>
                            <button type="button" class="btn btn_default" data-layer="complete">저장</button> -->
                        </section>
                    </section>
                    <!-- //button -->
                </div>
                <!-- //tab1-시험로 -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

 <!-- accordion -->
    <script>
        var acc = document.getElementsByClassName("accordion");
        var i;

        for (i = 0; i < acc.length; i++) {
            acc[i].addEventListener("click", function () {
                this.classList.toggle("active");
                var panel = this.nextElementSibling;
                if (panel.style.display === "block") {
                    panel.style.display = "none";
                } else {
                    panel.style.display = "block";
                }
            });
        }
    </script>
    <!-- //accordion -->

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>