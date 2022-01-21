<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){
	search(1 , 'ready');
	
	$(document).on("click", ".pageNo", function() {
		search($(this).attr("data-page"));
	});
	
	$("input[name=dateto]").daterangepicker({
        locale: {
          separator: " ~ ",
          format: 'YYYY-MM-DD',
          applyLabel: "확인",
          cancelLabel: "취소",
          daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
          monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
        },
        timePicker: false,
        showDropdowns: true,
        autoApply: true,
        autoUpdateInput: false,
        timePicker24Hour: true,
        timePickerSeconds: true,
      });

      $("input[name=dateto]").on('cancel.daterangepicker', function(ev, picker) {
        $(this).val('');
      });
      

})

//조회
function search(page, type) {
    var stDate = null,edDate = null;
    var text = null, select = null, approval1 = null, approval2 = null;
    var orderName1="",orderKind1="";
    var orderName2="",orderKind2="";
    
    if ($("#date1").val() != '') {
        var readyDate = $("#date1").val().split(' ~ ');
        stDate = moment(readyDate[0]).format('YYYYMMDD');
        edDate = moment(readyDate[1]).format('YYYYMMDD');
      }
      // keyword
      text = $("#searchKeyword").val();
      //checkbox
      var yes = "";
      var no = "";
      
      $("input[name=cbox]:checked").each(function(){
    	 if($(this).is(":checked") == true){
    		 if($(this).val() == '3'){
    			 yes = "3";
    		 } else if($(this).val() == '2'){
    			 no = "2";
    		 }
    	 }
      })
      console.log(yes);
      console.log(no);
      // 정렬
      if($("#readyOrder1").hasClass("btn_sort_down")){
        orderName1="Y";
        orderKind1="DESC";
      }else if($("#readyOrder1").hasClass("btn_sort_up")){
        orderName1="Y";
        orderKind1="ASC";
      }
      if($("#readyOrder2").hasClass("btn_sort_down")){
        orderName2="Y";
        orderKind2="DESC";
      }else if($("#readyOrder2").hasClass("btn_sort_up")){
        orderName2="Y";
        orderKind2="ASC";
      }
      
	var param = {
 			accountcode : $("#searchKeyword").val(),
			pageNo : page,
			tcApproval : yes,
			tcApproval1 : no, 
			text: text,
			tcDay: stDate,
			tcDay2: edDate,
	        wssApproval1: approval1,
	        wssApproval2: approval2,
	        orderName1: orderName1,
	        orderName2: orderName2,
	        orderKind1: orderKind1,
	        orderKind2: orderKind2
	}
	postAjax("/admin/trReserve/accounts",param,"searchCallback",null,null,null);
	console.log(param);
}

 //조회 콜백
function searchCallback(data){
	console.log(data);
	var list = data.list;
	var index = 1;
	
	if(list.length == 0){
		html += '<tr class="tr_nodata"><td colspan="9">데이터가 존재하지 않습니다.</td></tr>';
	}else{
		$("#accountlist").html("");
		var html = "";
		$.each(list,function(i,el){
			var list = el;
	        html += '<tr onmouseover="this.className=\'on\'" onmouseout="this.className=\'\'" onclick="accountsDetail(\''+list.tcReservCode+'\', '+i+')">';
			
			html += '<td>';
			html += index;
			html += '</td>';
	
			html += '<td>';
			html += list.tcReservCode; 
			html += '</td>';
			
			html += '<td>';
			html += changeDateFormat(list.tcRegDt);
			html += '</td>';
					
			html += '<td>'+moment(list.tcDay, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+'~'+moment(list.tcDay2,"YYYYMMDDhhmmss").format("YYYY.MM.DD")+'</td>'; //이용일자
	
			html += '<td>';
			if(list.trTrackType=="TYP01") {
				html += '단독';
			}else if(list.trTrackType=="TYP00"){
				html += '공동';
			}else{
				html +='';
			}
			html += '</td>';			
			
			html += '<td>';
			html += list.trTrackName;
			html += '</td>';
			
			html += '<td>';
			if(list.compName == null || list.compName == ""){
				html += "널값일때";		
			}else{			
				html += list.compName;
				if(list.blackList == "Y"){
					html += '<span class="color_red">';
					html += "(B/L)";
					html == '<span>';
				}
			}
			html += '</td>';			
			
			html += '<td>';
			if(list.tcApproval =="3"){
				if(list.tcStep == "00003"){
					html += '정산완료';
					html += '</td>';
					html += '<td>';
					html += "-";	
				}
			}else {
				html += '예약취소';
				html += '</td>';
				html += '<td>'+moment(list.tcModDt, "YYYYMMDDhhmmss").format("YYYY.MM.DD")+''; //취소일자	
			}
			html += '</td>';
			html += '</tr>';
			
			index++
	
		})
	}
	
	$("#accountlist").html(html);
	drawingPage(data.paging);
}

$(function(){
	$("#date1").daterangepicker({
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
})
//탭 이동
function pageMove(str){
	if(str=='tab1'){
		location.href = '/admin/trReserve/accounts';
	}else if(str == 'tab2'){
		location.href = '/admin/trReserve/shop';
	}
}


//정렬버튼 이미지 변경
function sort(column, type) {
  if (column == 1) { // 컬럼 구분
    search(1);
    if ($("#readyOrder1").hasClass("btn_sort_down")){
      $("#readyOrder1").attr("class","btn_sort_up")
    } else if ($("#readyOrder1").hasClass("btn_sort_up")){
      $("#readyOrder1").attr("class","btn_sort_down")
    }
  } else if (column == 2) {
    search(1);
    if ($("#readyOrder2").hasClass("btn_sort_down")){
      $("#readyOrder2").attr("class","btn_sort_up")
    } else if ($("#readyOrder2").hasClass("btn_sort_up")){
      $("#readyOrder2").attr("class","btn_sort_down")
    }
  }
}


//상세이동
function accountsDetail(tcReservCode){
	var form = $("<form></form>");
	form.attr("action","/admin/trReserve/accountsDetail");
	form.attr("method","post");
	form.appendTo("body");
	var inputAuthCode = $('<input type="hidden" value='+tcReservCode+' name="tcReservCode">');
	form.append(inputAuthCode);
	var inputToken = $('<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">');
	form.append(inputToken);
	form.submit();
}

//초기화
function resetbtn(){
	$("#date1").val("");
	$("#searchKeyword").val("");
	$("input[name=cbox]").prop('checked',false);
	
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
                <button class="tablinks active" onclick="pageMove('tab1')" id="defaultOpen">시험로</button>
                <button class="tablinks" onclick="pageMove('tab2')">부대시설</button>
            </div>
            <div class="wrap_tabcontent">
                <!-- tab1-시험로 -->
                <div id="tab1" class="tabcontent">
                    <!-- search_wrap -->
                    <section class="search_wrap">
                        <div class="form_group w230">
                            <input type="text" id="date1" autocomplete='off' class="form_control dateicon datefromto"
                                placeholder="이용기간 선택" name="">
                        </div>
                        <div class="form_group w300">
                            <input type="text" autocomplete='off' id="searchKeyword" class="form_control" 
                            placeholder="예약번호/사업자번호/회사명 입력" name="" />
                        </div>
                        <div class="form_group">
                            <div class="check_inline">
                                <span class="label">상태</span>
                                <label class="check_default">
                                    <input type="checkbox" name="cbox" value="3">
                                    <span class="check_icon"></span>정산완료</label>
                                <label class="check_default">
                                    <input type="checkbox" name="cbox" value="2">
                                    <span class="check_icon"></span>예약취소</label>
                            </div>
                        </div>
                        <button type="button" onclick="search(1, 'ready')" class="btn-s btn_default">조회</button>
                        <button type="button" onclick="resetbtn()" class="btn-s btn_default">검색초기화</button>
                    </section>
                    <!-- //search_wrap -->
                    <!-- table list -->
                    <section class="tbl_wrap_list m-t-30">
                        <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="80px" />
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
                                    <th scope="col">번호</th>
                                    <th scope="col">예약번호</th>
                                    <th scope="col">접수일자
                                        <!-- <button class="btn_sort"></button> -->
                                        <button id="readyOrder1" onclick="sort(1, 'ready')" class="btn_sort_down"></button>
                                    </th>
                                    <th scope="col">이용일자
                                        <!-- <button class="btn_sort"></button> -->
                                        <button id="readyOrder2" onclick="sort(2, 'ready')" class="btn_sort_down"></button>
                                    </th>
                                    <th scope="col">유형</th>
                                    <th scope="col">항목</th>
                                    <th scope="col">회사명</th>
                                    <th scope="col">상태</th>
                                    <th scope="col">취소일시</th>
                                </tr>
                            </thead>
                            <tbody id="accountlist">
<!--                                 <tr onmouseover="this.className='on'" onmouseout="this.className=''" -->
<!--                                     onclick="detailPage('test')"> -->
<!--                                     <td>10</td> -->
<!--                                     <td>2020010101</td> -->
<!--                                     <td>2021.08.01</td> -->
<!--                                     <td>2021.01.01</td> -->
<!--                                     <td>공동</td> -->
<!--                                     <td>고속주회로</td> -->
<!--                                     <td>원투연구소<span class="color_red">(B/L)</span></td> -->
<!--                                     <td>이용완료</td> -->
<!--                                     <td></td> -->
<!--                                 </tr> -->
<!--                                 <tr onmouseover="this.className='on'" onmouseout="this.className=''" -->
<!--                                     onclick="location.href='#';"> -->
<!--                                     <td>10</td> -->
<!--                                     <td>2020010101</td> -->
<!--                                     <td>2021.08.01</td> -->
<!--                                     <td>2021.01.01</td> -->
<!--                                     <td>공동</td> -->
<!--                                     <td>고속주회로</td> -->
<!--                                     <td>원투연구소</td> -->
<!--                                     <td>이용완료</td> -->
<!--                                     <td>2021.09.02 13:00:00</td> -->
<!--                                 </tr> -->
                                <!-- <tr class="tr_nodata">
    <td colspan="9">등록된 정보가 없습니다.</td>
</tr> -->
                            </tbody>
                        </table>
                    </section>
                    <!-- //table list -->
                    <!-- Pagination -->
                   <section id="pagingc" class="pagination m-t-30">
						<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp"/>
					</section>
                    <!-- //Pagination -->
                </div>
                <!-- //tab1-시험로 -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>