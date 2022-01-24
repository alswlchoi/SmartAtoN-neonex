<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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

        <!-- tab -->
        <div class="wrap_tab">
            <div class="tab">
                <button class="tablinks" onclick="pageMove('tab1')">시험로</button>
                <button class="tablinks active" onclick="pageMove('tab2')" id="defaultOpen">부대시설</button>
            </div>
            <div class="wrap_tabcontent">
<%--             ${chargeDto} --%>
                <!-- tab2-부대시설 -->
                <div id="tab2" class="tabcontent">
                    <!-- table list -->
                    <section class="tbl_wrap_list" id="statusTable">
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
                                    <th scope="col">예약번호</th>
                                    <th scope="col">접수일자</th>
                                    <th scope="col">이용일자</th>
                                    <th scope="col">회사명</th>
                                    <th scope="col">항목</th>
                                    <th scope="col">상태</th>
                                    <th scope="col">취소일시</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>${chargeDto.wssReservCode}</td>
                                    
									<td><c:set var="comReDt" value="${chargeDto.compRegDt}"/>${fn:substring(comReDt,0,4) }.${fn:substring(comReDt,4,6) }.${fn:substring(comReDt,6,8) }</td>
                                    
                               	    <td>
                               	    <c:set var="wssStDay" value="${chargeDto.wssStDay}"/>${fn:substring(wssStDay,0,4)}.${fn:substring(wssStDay,4,6)}.${fn:substring(wssStDay,6,8)}
                               	    &nbsp;~&nbsp;
                               	    <c:set var="wssEdDay" value="${chargeDto.wssEdDay}"/>${fn:substring(wssEdDay,0,4)}.${fn:substring(wssEdDay,4,6)}.${fn:substring(wssEdDay,6,8)}
                               		<c:if test="${!empty(realdate)}"><div style="padding-top:5px"><span class="color_orange">실제사용일 </span>${realdate}</div></c:if>
                               	    </td>
                               	                                   	                                 	           
                                    <td>${chargeDto.compName}
                                    <c:if test="${chargeDto.blackList eq 'Y'}"><span class="color_red">(B/L)</span></c:if>
                                    </td>
                                    <td>${chargeDto.wsName}</td>
                                	<td>
                                	<c:if test="${chargeDto.wssApproval eq 'D'}"><span class="color_red">정산완료</span></c:if>
                                	<c:if test="${chargeDto.wssApproval eq 'C'}"><span class="color_red">예약취소</span></c:if>
                                	</td>   
                                    <td>
                                    <c:if test="${chargeDto.wssApproval eq 'C'}"><c:set var="wssModDt" value="${chargeDto.wssModDt}"/>${fn:substring(wssModDt,0,4) }.${fn:substring(wssModDt,4,6) }.${fn:substring(wssModDt,6,8) }</c:if>
                                    </td>                                    
                                </tr>
                            </tbody>
                        </table>
                    </section>
                    <!-- //table list -->

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
                                    	<c:if test="${chargeDto.blackList eq 'Y'}"><span class="color_red">(B/L)</span></c:if>                                    
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
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col">항목</th>
                                            <th scope="col">실사용일</th>
                                            <th scope="col">적용일</th>
                                            <th scope="col">공급금액</th>
                                            <th scope="col">할인율</th>
                                            <th scope="col">부가세(10%별도)</th>
                                            <th scope="col">합계</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        
                                        <c:choose>
                                        	<c:when test = "${empty chargeDtolist }">
                                        		<tr>
                                        		<td colspan="7">데이터가 없습니다</td>
                                        		</tr>
                                        	</c:when>
                                        	<c:otherwise>
                                        	<tr>
                                        	<td>${chargeDto.wsName}</td>
                                            <td>
                                               ${chargeDtolist.PUseTime}일
                                            </td>
                                            <td>
                                               ${chargeDtolist.PApplyTime}일
                                            </td>
											<td>
											<fmt:formatNumber value="${chargeDtolist.PPay}" pattern="#,###" />
											</td>
                                         	<td class="tar">
											${chargeDto.dcCount}
                                         	</td>
                                            <td class="tar">
                                    		<fmt:formatNumber type="number" maxFractionDigits="0" value="${chargeDtolist.price}" /><!--부가세  -->
                                            </td>
                                            <td class="tar">
											<fmt:formatNumber type="number" maxFractionDigits="0" value="${chargeDtolist.PPay+chargeDtolist.price}" /><!--합계  --> 
                                            </td>
	                                        </tr>
                                        <tr class="bg_total color_b333">
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td class="tar">총합</td>
                                            <td class="tar">
											<fmt:formatNumber type="number" maxFractionDigits="0" value="${chargeDtolist.PPay+chargeDtolist.price}" /><!--합계  --> 
                                            </td>
                                        </tr>
                                        	</c:otherwise>
                                        </c:choose> 
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
 						<button type="button" class="btn btn_gray" onclick="history.back()">목록</button>                        <section>
                            <!-- <button type="button" class="btn btn_gray m-r-6" data-layer="cancel">취소</button>
                            <button type="button" class="btn btn_default" data-layer="complete">저장</button> -->
                        </section>
                    </section>
                    <!-- //button -->
                </div>
                <!-- //tab2-부대시설 -->
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


