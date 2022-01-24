<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){
	console.log("${getMenuList}");
	<c:forEach var="m" items="${getMenuList }">
	$("input[value='${m.menuCode}']").prop("checked",true);
	</c:forEach>
	$("#allChk").on("click",function(){
		if($(this).prop("checked")){
			$("input[type='checkbox']").prop("checked",true);
		}else{
			$("input[type='checkbox']").prop("checked",false);
		}
	});
	//메뉴 추가 시 해당 상위 하위 메뉴에 클래스 맞게 추가 할 것
	//시험자원관리
	$(".main1").on('click',function(){
		if($(this).prop("checked")){
			$(".sub1").prop("checked",true);
		}else{
			$(".sub1").prop("checked",false);
		}
	});
	$(".sub1").on('click',function(){
		if($(".sub1:checked").length>0){
			$(".main1").prop("checked",true);
		}else{
			$(".main1").prop("checked",false);
		}
	});
	$(".tire").on('click',function(){
		if($(this).prop("checked")){
			$(".tire1").prop("checked",true);
		}else{
			$(".tire1").prop("checked",false);
			if($(".sub1:checked").length>0){
				$(".main1").prop("checked",true);
			}else{
				$(".main1").prop("checked",false);
			}
		}
	});
	$(".tire1").on('click',function(){
		if($(".tire1:checked").length>0){
			$(".tire").prop("checked",true);
		}else{
			$(".tire").prop("checked",false);
		}
		if($(".sub1:checked").length>0){
			$(".main1").prop("checked",true);
		}else{
			$(".main1").prop("checked",false);
		}
	});
	//예약/정산관리
	$(".main2").on('click',function(){
		if($(this).prop("checked")){
			$(".sub2").prop("checked",true);
		}else{
			$(".sub2").prop("checked",false);
		}
	});
	$(".sub2").on('click',function(){
		if($(".sub2:checked").length>0){
			$(".main2").prop("checked",true);
		}else{
			$(".main2").prop("checked",false);
		}
	});
	//시험관리
	$(".main3").on('click',function(){
		if($(this).prop("checked")){
			$(".sub3").prop("checked",true);
		}else{
			$(".sub3").prop("checked",false);
		}
	});
	$(".sub3").on('click',function(){
		if($(".sub3:checked").length>0){
			$(".main3").prop("checked",true);
		}else{
			$(".main3").prop("checked",false);
		}
	});
	//회원사/자원 관리
	$(".main4").on('click',function(){
		if($(this).prop("checked")){
			$(".sub4").prop("checked",true);
		}else{
			$(".sub4").prop("checked",false);
		}
	});
	$(".sub4").on('click',function(){
		if($(".sub4:checked").length>0){
			$(".main4").prop("checked",true);
		}else{
			$(".main4").prop("checked",false);
		}
	});
	$(".member").on('click',function(){
		if($(this).prop("checked")){
			$(".member1").prop("checked",true);
		}else{
			$(".member1").prop("checked",false);
			if($(".sub4:checked").length>0){
				$(".main4").prop("checked",true);
			}else{
				$(".main4").prop("checked",false);
			}
		}
	});
	$(".member1").on('click',function(){
		if($(".member1:checked").length>0){
			$(".member").prop("checked",true);
		}else{
			$(".member").prop("checked",false);
		}
		if($(".sub4:checked").length>0){
			$(".main4").prop("checked",true);
		}else{
			$(".main4").prop("checked",false);
		}
	});
	$(".resource").on('click',function(){
		if($(this).prop("checked")){
			$(".resource1").prop("checked",true);
		}else{
			$(".resource1").prop("checked",false);
			if($(".sub4:checked").length>0){
				$(".main4").prop("checked",true);
			}else{
				$(".main4").prop("checked",false);
			}
		}
	});
	$(".resource1").on('click',function(){
		if($(".resource1:checked").length>0){
			$(".resource").prop("checked",true);
		}else{
			$(".resource").prop("checked",false);
		}
		if($(".sub4:checked").length>0){
			$(".main4").prop("checked",true);
		}else{
			$(".main4").prop("checked",false);
		}
	});

	//통계
	$(".main5").on('click',function(){
		if($(this).prop("checked")){
			$(".sub5").prop("checked",true);
		}else{
			$(".sub5").prop("checked",false);
		}
	});
	$(".sub5").on('click',function(){
		if($(".sub5:checked").length>0){
			$(".main5").prop("checked",true);
		}else{
			$(".main5").prop("checked",false);
		}
	});
	//컨텐츠관리
	$(".main6").on('click',function(){
		if($(this).prop("checked")){
			$(".sub6").prop("checked",true);
		}else{
			$(".sub6").prop("checked",false);
		}
	});
	$(".sub6").on('click',function(){
		if($(".sub6:checked").length>0){
			$(".main6").prop("checked",true);
		}else{
			$(".main6").prop("checked",false);
		}
	});
	//시스템관리
	$(".main7").on('click',function(){
		if($(this).prop("checked")){
			$(".sub7").prop("checked",true);
		}else{
			$(".sub7").prop("checked",false);
		}
	});
	$(".sub7").on('click',function(){
		if($(".sub7:checked").length>0){
			$(".main7").prop("checked",true);
		}else{
			$(".main7").prop("checked",false);
		}
	});
})
//목록버튼
function backBtn(){
	location.href="/system/auth";
}
//취소버튼
function cancel(){
	confirm("취소하시면 처음부터 다시 진행해야 됩니다.<br/>취소하시겠습니까?",successConfirm,cancelConfirm);
}
//취소 후 확인
function successConfirm(data){
	location.href="/system/auth";
}
//취소 후 취소
function cancelConfirm(data){
	$(".lyClose").click();
}
//저장버튼
function register(){
	var chkArr =[];
	$("input[type='checkbox']:checked").each(function(i,ival){
		if(ival.value != ""){
			chkArr.push(ival.value);
		}
	})
	param ={
			authCode : "${authCode}",
			chkArr : chkArr
	}
	console.log("등록 파라미터",param);
	postAjax("/system/menu/update",param,"searchCallback",null,null,null);
}
//조회콜백
function searchCallback(data){
	if(data>0){
		alert("저장에 성공했습니다.");
		$(".lyClose").click(function(){
			location.href="/system/auth";
		})
	}else{
		alert("저장에 실패했습니다.");
	}
}
// //등록콜백
// function callbackFunction(data){
// 	if(data>0){
// 		alert("성 공!");
// 		search();
// 	}else{
// 		alert("실 패!");
// 	}
// }
</script>
<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시스템관리</span><span>메뉴 및 권한관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">메뉴 및 권한관리</h2>
        <!-- //title -->

        <!-- search_wrap -->
        <section class="search_wrap">
            <div class="form_group">
                <div class="select_group">
                    <select id="" title="select" class="form_control" disabled="disabled">
                        <c:forEach var="list" items="${authList }">
							<option value="${list.authCode }" <c:if test="${list.authCode eq authCode }">selected</c:if>>${list.authNm }</option>
						</c:forEach>
                    </select>
                </div>
            </div>
        </section>
        <!-- //search_wrap -->

        <!-- row -->
        <div class="m-t-30">
            <div class="col">
                <!-- table list -->
                <section class="tbl_wrap_list">
                    <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                        <caption>테이블</caption>
                        <colgroup>
                            <col width="50px" />
                            <col width="" />
                            <col width="50px" />
                            <col width="" />
                            <col width="50px" />
                            <col width="" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col">
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" id="allChk" name="" value="">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </th>
                                <th scope="col">메인메뉴</th>
                                <th scope="col"></th>
                                <th scope="col">서브메뉴1</th>
                                <th scope="col"></th>
                                <th scope="col">서브메뉴2</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M138">
                                                <span class="check_icon"></span>
                                            </label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">메인화면(미사용)</td>
                                <td></td>
                                <td class="tal"></td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M139">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">대시보드(미사용)</td>
                                <td></td>
                                <td class="tal"></td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td rowspan="4">
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M100" class="main1">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td rowspan="4" class="border-r-1-ddd tal">시험자원관리</td>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M101" class="sub1">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">운전자 DCCP관리</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M102" class="sub1">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">시험자관리</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M103" class="sub1">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">평가자 및 평가차량 관리</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M104" class="sub1 tire">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="border-r-1-ddd tal">타이어휠 관리</td>
                                <td>
                                	<div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M105" class="sub1 tire1">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">Tire/Wheel management</td>
                            </tr>
<!--                             <tr> -->
<!--                                 <td> -->
<!--                                 	<div class="form_group single"> -->
<!--                                         <div class="check_inline"> -->
<!--                                             <label class="check_default single"> -->
<!--                                                 <input type="checkbox" name="" value="M106" class="sub1 tire1"> -->
<!--                                                 <span class="check_icon"></span></label> -->
<!--                                         </div> -->
<!--                                     </div> -->
<!--                                 </td> -->
<!--                                 <td class="tal">Wheel date update</td> -->
<!--                             </tr> -->
                            <tr>
                                <td rowspan="2">
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M107" class="main2">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td rowspan="2" class="tal">예약/정산관리</td>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M108" class="sub2">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">예약관리</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td class="border-l-1-ddd">
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M109" class="sub2">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">정산관리</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td rowspan="2">
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M110" class="main3">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td rowspan="2" class="tal">시험관리</td>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M111" class="sub3">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">스케줄관리</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td class="border-l-1-ddd">
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M112" class="sub3">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">시험로 시험관리</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td rowspan="8">
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M113" class="main4">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td rowspan="8" class="tal">회원사/자원 관리</td>
                                <td rowspan="2" class="border-l-1-ddd">
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M114" class="sub4 member">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td rowspan="2" class="border-l-1-ddd tal">회원사관리</td>
                                <td>
                                	<div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M115" class="sub4 member1">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="border-l-1-ddd tal">회원사관리</td>
                            </tr>

                            <tr>
                            	<td class="border-l-1-ddd">
                                	<div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M116" class="sub4 member1">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">운전자관리</td>
                            </tr>
                            <tr>
                            	<td rowspan="6" class="border-l-1-ddd">
                            		<div class="form_group single">
	                            		<div class="check_inline">
	                                        <label class="check_default single">
	                                            <input type="checkbox" name="" value="M117" class="sub4 resource">
	                                            <span class="check_icon"></span></label>
	                                    </div>
                                    </div>
                            	</td>
                            	<td rowspan="6" class="border-l-1-ddd tal">
                            		자원관리
                            	</td>
                            	<td class="border-l-1-ddd">
                                	<div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M118" class="sub4 resource1">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="border-l-1-ddd tal">무전기 자산관리</td>
                            </tr>
                            <tr>
                            	<td class="border-l-1-ddd">
                                	<div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M119" class="sub4 resource1">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">RFID 자산관리</td>
                            </tr>
                            <tr>
                            	<td class="border-l-1-ddd">
                                	<div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M120" class="sub4 resource1">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">시설물 관리</td>
                            </tr>
                            <tr>
                            	<td class="border-l-1-ddd">
                                	<div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M121" class="sub4 resource1">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">휴일 관리</td>
                            </tr>
                            <tr>
                            	<td class="border-l-1-ddd">
                                	<div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M122" class="sub4 resource1">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">전용운영일 관리</td>
                            </tr>
                            <tr>
                            	<td class="border-l-1-ddd">
                                	<div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M123" class="sub4 resource1">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">부대시설전용 점검일 관리</td>
                            </tr>

                            <tr>
                                <td rowspan="5">
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M125" class="main5">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td rowspan="5" class="border-r-1-ddd tal">통계</td>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M126" class="sub5">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">회원사별 시험이력</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M127" class="sub5">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">시험로별</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M128" class="sub5">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">기상노면현황</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
							<tr>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M129" class="sub5">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">일자별 입출로그</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M129" class="sub5">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">주유통계</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td rowspan="2" class="border-b-1">
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M130" class="main6">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td rowspan="2" class="border-b-1 tal">컨텐츠관리</td>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M131" class="sub6">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">공지사항</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td class="border-l-1-ddd">
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M132" class="sub6">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">자료실</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>


                            <tr>
                                <td rowspan="5">
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M133" class="main7">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td rowspan="5" class="border-r-1-ddd tal">시스템관리</td>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M134" class="sub7">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">메뉴 및 권한관리</td>
                                <td></td>
                                <td class="tal"> </td> </tr> <tr>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M135" class="sub7">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">관리자관리</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M136" class="sub7">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">비상상황코드 관리</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M137" class="sub7">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">시스템 코드 관리</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="form_group single">
                                        <div class="check_inline">
                                            <label class="check_default single">
                                                <input type="checkbox" name="" value="M140" class="sub7">
                                                <span class="check_icon"></span></label>
                                        </div>
                                    </div>
                                </td>
                                <td class="tal">트랙 패키지 관리</td>
                                <td></td>
                                <td class="tal"></td>
                            </tr>
                        </tbody>
                    </table>
                </section>
                <!-- //table list -->
            </div>
        </div>
        <!-- //row -->

        <!-- button -->
        <section class="btn_wrap m-t-50">
            <button type="button" class="btn btn_gray" onclick="backBtn();">목록</button>
            <section>
                <button type="button" class="btn btn_gray m-r-6" onclick="cancel();">취소</button>
                <button type="button" class="btn btn_default" onclick="register();">저장</button>
            </section>
        </section>
        <!-- //button -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>