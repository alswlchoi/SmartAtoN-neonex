<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
        <!-- container -->
        <script type="text/javascript">
		$(document).ready(function(){
			//daterangepiker start
			$("#tcDay").daterangepicker({
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
			
			$("#data_area").hide();	//페이지 로딩시 등록/수저폼 가림
			$("#search").keydown(function(key) {
				if (key.keyCode == 13) {
					search("button");
				}
			});
			
			$("#search").keydown(function(key) {
				if (key.keyCode == 13) {
					search("button");
				}
			});
		
			$(".listKind li").click(function(){
				search($(this).attr("class"));
			});
			$("#searchBtn").click(function(){
				search("button");
			});
			
			$("#initBtn").click(function(){
				search("init");
			});
			
			$(document).on("click",'#listBtn, #canBtn' ,function(){
				$("#data_detail").hide();
				search("list");
			});
			
			$(document).on("click",'.updBtn' ,function(){	//할인율, 메모 수정 처리
				if($('input:radio[id=dcy]').is(':checked')==true && ($("#dcCount").val()=="" || isNaN($("#dcCount").val()))){
					alert("할인율을 입력해 주세요.");
				}else{
					var compCode = $("#data_table>tbody>tr:eq(0)>td:eq(0)").text();
					var dcCount = $("#dcCount").val();
					var compMemo = $("#compMemo").val();
					$.ajax({
						url : "/admin/company/update-company",
						type : "get",
						data : {
							"compCode":compCode,
							"dcCount":dcCount,
							"compMemo":compMemo
						},
						success : function(resdata){
							alert("저장완료 되었습니다.");
						},
						error : function(e){
							console.log(e);
						}
					});
				}
			});
		});
		
		//페이지 버튼 클릭
		$(document).on("click","#pagingc a.pageNo",function(){
			$(this).siblings().removeClass("on");
			$(this).addClass("on");
			$("#pageNo").text($(this).attr("data-page"));
			
			search("paging");
		});
		
		function search(type){
			var pageNo;
			var compName = $("#search").val();
			var compRegStDt = $("input[name=compRegStDt]").val();
			var memApproval = "Y";
			
			if(type == "list") {	//목록 버튼
				pageNo = $("#pageNo").text();
				$("#data_detail").hide();
			}else if(type == "paging"){//페이징 검색
				pageNo = $("#pageNo").text(); 
			}else{
				pageNo = "1";
			}

			if(type == "init"){
				var compName = "";
				var compRegStDt = "";
				$("#search").val("");
				$("#tcDay").val("");
			}
			
			$("#data_list").show();
			$.ajax({
				url : "/admin/company/search-company",
				type : "get",
				data : {
						"pageNo"  :pageNo,
						"compName":compName,
						"compRegStDt":compRegStDt,
						"memApproval":memApproval
				},
				success : function(resdata){
					drawingTable(resdata.rows, resdata.paging);
					drawingPage(resdata.paging);
				},
				error : function(e){
					console.log(e);
				}
			});
		
		}
		
		//숫자 콤마 설정
		function numberWithCommas(x) {return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");}

		//조회값 undefined -> 공백 처리
		function undefinedChk(str1,str2){
			if( str1 == "" || str1 == null || typeof str1 == undefined || str1 == undefined || ( str1 != null && typeof str1 == "object" && !Object.keys(str1).length ) ){
				return str2;
			}else{
				return str1;
			}
		}
		
		//등록페이지로 이동
		$(document).on("click",".goBlacklist",function(){
			var blackList = $("#data_table tbody tr td span.blchk").text();
			var con = "";
			if(blackList=="(B/L)"){		//블랙리스트 -> 해제
				blackList = "N";
				con = confirm("블랙리스트를 해제 하시겠습니까?");	
			}else{
				blackList = "Y";
				con = confirm("블랙리스트로 등록 하시겠습니까?");
			}
			$(document).on("click","#confirmTrue",function(){
				var compCode = $("#data_table tr td:eq(0)").text();
				 console.log("blackList :"  + blackList);
				 
				$.ajax({
					url : "/admin/company/update-blacklist",
					type : "get",
					data : {
						"compCode":compCode,
						"blackList":blackList
					},
					success : function(resdata){
						if(blackList=="N"){
							alert("해제완료 되었습니다.");
							$("#data_table tbody tr td span.blchk").text("");
							$(".goBlacklist").text("블랙리스트로 등록");
						}else{
							alert("등록완료 되었습니다.");
							$("#data_table tbody tr td span.blchk").text("(B/L)");
							$(".goBlacklist").text("블랙리스트 해제");
						}
					},
					error : function(e){
						console.log(e);
					}
				});
			});
		});
		
		$(document).on("click",".goRegButton",function(){
			$("#data_list").hide();
			$("#data_area").show();
			
		})
		
		//상세보기로 이동
		$(document).on("click",".godetail",function(){
			var currentRow=$(this).closest('tr');
			var compCode = currentRow.find('td:eq(0) span').text();
			pageNo = $(".pageNo.on").attr("data-page");
			$("#pageNo").html(pageNo);
			
			location.href="/admin/company/detail-company?compCode="+compCode+"&memApproval=Y";
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
		
		//테이블 그리는 함수
		function drawingTable(rows, paging){
			var html='';
			if(rows.length==0) {
				html += '<tr>';
				html += '<td colspan="10">데이터가 존재하지 않습니다.</td>';
				html += '</tr>';
			}else{
				//console.log(paging.totalCount);
				for(var list in rows){
					html += '<tr onmouseover="this.className=\'on godetail\'" onmouseout="this.className=\'\'">';
					html += '<td><span style="display:none">'+undefinedChk(rows[list].compCode,"")+'</span>';
					html += paging.totalCount-(paging.pageNo-1)*paging.pageSize-list;
					html += '</td>';
					html += '<td>'+undefinedChk(rows[list].compName,"");
					if(undefinedChk(rows[list].blackList,"")=="Y"){
						html += '<br /><span class="color_red">B/L</span>';
					}
					html += '</td>';
					html += '<td>';
					var compLicense = undefinedChk(rows[list].compLicense,"")
					compLicense = compLicense.substring(0,3)+"-"+compLicense.substring(3,5)+"-"+compLicense.substring(5,10);
					html += compLicense +'</td>';
					html += '<td>'+undefinedChk(rows[list].memName,"")+'</td>';
					html += '<td>'+undefinedChk(rows[list].memDept,"")+'</td>';
					html += '<td>';
					var memPhone = undefinedChk(rows[list].memPhone,"")
					memPhone = memPhone.substring(0,3)+"-"+memPhone.substring(3,7)+"-"+memPhone.substring(7,11);
					html += memPhone +'</td>';
					html += '<td>';
					var compPhone = undefinedChk(rows[list].compPhone,"");
					if(compPhone!=""){
						if(compPhone.substring(0,2)=="02"||compPhone.length<10){
							if(compPhone.length==10){
								compPhone = compPhone.substring(0,2)+'-'+compPhone.substring(2,6)+'-'+compPhone.substring(6,10);
							}else{
								compPhone = compPhone.substring(0,2)+'-'+compPhone.substring(2,5)+'-'+compPhone.substring(5,10);
							}
						}else if(compPhone.substring(0,3)=="010"){
							compPhone = compPhone.substring(0,3)+'-'+compPhone.substring(3,7)+'-'+compPhone.substring(7,11);
						}else{
							if(compPhone.length==10){
								compPhone = compPhone.substring(0,3)+'-'+compPhone.substring(3,6)+'-'+compPhone.substring(6,10);
							}else if(compPhone.length==11){
								compPhone = compPhone.substring(0,3)+'-'+compPhone.substring(3,7)+'-'+compPhone.substring(7,11);
							}else if(compPhone.length==12){
								compPhone = compPhone.substring(0,4)+'-'+compPhone.substring(4,8)+'-'+compPhone.substring(8,12);					
							}
						}
						html += compPhone;
					}
					html += '</td>';					
					var compRegDt = "";
					if(rows[list].compRegDt.length==14){
						compRegDt += rows[list].compRegDt.substring(0,4);
						compRegDt += "-";
						compRegDt += rows[list].compRegDt.substring(4,6);
						compRegDt += "-";
						compRegDt += rows[list].compRegDt.substring(6,8);
						compRegDt += " ";
						compRegDt += rows[list].compRegDt.substring(8,10);
						compRegDt += ":";
						compRegDt += rows[list].compRegDt.substring(10,12);
						compRegDt += ":";
						compRegDt += rows[list].compRegDt.substring(12,14);
					}
					html += '<td>'+compRegDt+'</td>';
					html += '<td>';
					if(undefinedChk(rows[list].memApproval,"") == 'Y'){
						html += "승인완료";
					}else{
						html += "승인대기";
					}
					html += '</td>';
					html += '<td>';
					html += '</td>';
					html += '</tr>';
				}
			}
			$("#tbody").html(html);
		}

		function pageMove(str){
			if(str=='tab1'){
				location.href = '/admin/company/list';
			}else if(str == 'tab2'){
				location.href = '/admin/company/listy';
			}else if(str == 'tab3'){
				location.href = '/admin/company/listb';
			}
		}
		</script>
        <div id="container">
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>회원사/자원관리</span><span>회원사 관리</span><span>회원사 관리</span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">회원사 관리</h2>
                <!-- //title -->

                <!-- tab -->
                <div class="wrap_tab">
                    <div class="tab">
                        <button class="tablinks" onclick="pageMove('tab1')" id="defaultOpen">회원가입 신청내역</button>
                        <button class="tablinks active" onclick="pageMove('tab2')" id="secondOpen">회원가입 승인내역</button>
                        <button class="tablinks" onclick="pageMove('tab3')" id="thirdOpen">블랙리스트 내역</button>
                    </div>
                    <div class="wrap_tabcontent">
                        <!-- tab1-회원가입 신청내역 -->
                        <div id="tab2" class="tabcontent">
                           <!-- 상세보기 시작 -->
						   <section id="data_detail" class="tbl_wrap_list"></section>
						   <!-- 상세보기 끝 -->
                            <div id="data_list">
                            <!-- search_wrap -->
                            <section class="search_wrap">
                                <div class="form_group w230">
                                    <input type="text" id="tcDay" class="form_control dateicon datefromto"
                                        placeholder="신청기간 선택" name="compRegStDt" autocomplete="off" />
                                </div>
                                <div class="form_group w300">
                                    <input type="text" id="search" class="form_control" placeholder="회사명/사업자번호/담당자명 입력"
                                        name="" />
                                </div>
                                <button type="button" class="btn-s btn_default" id="searchBtn">조회</button>
                                <button type="button" class="btn-s btn_default" id="initBtn">검색초기화</button>
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
                                            <th scope="col">회사명</th>
                                            <th scope="col">사업자 번호</th>
                                            <th scope="col">담당자명</th>
                                            <th scope="col">부서명</th>
                                            <th scope="col">휴대폰 번호</th>
                                            <th scope="col">회사 전화번호</th>
                                            <th scope="col">신청일시</th>
                                            <th scope="col">상태</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tbody">
								        <c:if test="${totalCnt == 0 }">
								        <tr>
								        	<td colspan="9">데이터가 존재하지 않습니다.</td>
								        </tr>
								        </c:if>
								        <c:if test="${totalCnt > 0 }">
				       						<c:forEach var="result" items="${companyList.rows}" varStatus="status">
	                                        <tr onmouseover="this.className='on godetail'" onmouseout="this.className=''">
	                                            <td><span style="display:none">${result.compCode }</span>${totalCnt - (paging.pageNo-1)*paging.pageSize - status.index }</td>
	                                            <td>${result.compName}
								                	<c:if test="${result.blackList eq 'Y'}"><br /><span class="color_red">(B/L)</span></c:if></td>
	                                            <td>
	                                            	<c:set value="${result.compLicense}" var="compLicense" />
				                					${fn:substring(compLicense, 0, 3) }-${fn:substring(compLicense, 3, 5) }-${fn:substring(compLicense, 5, 10) }</td>
	                                            <td>${result.memName}</td>
	                                            <td>${result.memDept}</td>
	                                            <td>
		                                            <c:set var='memPhone' value='${result.memPhone }' />
	                                                ${fn:substring(memPhone,0,3) }-${fn:substring(memPhone,3,7) }-${fn:substring(memPhone,7,11) }
                                                </td>
	                                            <td>
                                                <c:set var='compPhone' value='${result.compPhone }' />
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
	                                            <td>
	                                            	<c:set var="compRegDt" value="${result.compRegDt}"/>
				                					${fn:substring(compRegDt,0,4) }-${fn:substring(compRegDt,4,6) }-${fn:substring(compRegDt,6,8) } ${fn:substring(compRegDt,8,10) }:${fn:substring(compRegDt,10,12) }:${fn:substring(compRegDt,12,14) }
				                				</td>
	                                            <td>
	                                            	<c:if test="${result.memApproval eq 'Y'}">승인완료</c:if>
				                					<c:if test="${result.memApproval ne 'Y'}">승인대기</c:if></td>
	                                        </tr>
	                                       </c:forEach>
                                        </c:if>
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
                        </div>
                        <!-- //tab1-회원가입 신청내역 -->
                    </div>
                </div>
                <!-- //tab -->
            </div>
  			<span id="pageNo" style="display:none"></span>
            <!-- //content -->
        </div>
        <!-- //container -->

    <!-- popup_Alert -->
    <div class="ly_group">
        <article class="layer_Alert complete">
            <!-- # 타이틀 # -->
            <!-- <h1></h1> -->
            <!-- # 컨텐츠 # -->
            <div class="ly_con">
                저장완료 되었습니다.
            </div>
            <!-- 버튼 -->
            <div class="wrap_btn01">
                <!-- <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button> -->
                <button type="button" class="btn-pop btn_default lyClose">확인</button>
            </div>
            <!-- # 닫기버튼 # -->
            <button data-fn="lyClose">레이어닫기</button>
        </article>
    </div>
    <!-- //popup_Alert -->

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

    <!-- popup_Alert -->
    <div class="ly_group">
        <article class="layer_Alert blacklist_cancel">
            <!-- # 타이틀 # -->
            <!-- <h1></h1> -->
            <!-- # 컨텐츠 # -->
            <div class="ly_con">
                블랙리스트 등록을 취소 하시겠습니까?
            </div>
            <!-- 버튼 -->
            <div class="wrap_btn01">
                <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button>
                <button type="button" class="btn-pop btn_default lyClose">확인</button>
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
                    <p>선택한 항목에 대해<br />[$$반려 또는 취소$$] 하시겠습니까?</p>
                    <p>[사유등록]</p>
                    <span class="info_ment_orange m-t-15 m-l-0">회원사에게 전송되는 정보이므로 등록 시 유의하시기 바랍니다.</span>
                    <div class="form_group w_full m-t-10">
                        <textarea name="rtnRsn" id="rtnRsn" cols="" rows="5" class="form_control"
                            placeholder="반려/취소 /거절 사유를 등록해 주세요." onkeyup="fnChkByte(this,'300')" style="resize: none;"></textarea>
                        <div class="count_txt"><span id="byteInfo">0</span> / 300 bytes</div>
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
    
    <!-- tab -->
    <script type="text/javascript">
		function pageMove(str){
			if(str=='tab1'){
				location.href = '/admin/company';
			}else if(str == 'tab2'){
				location.href = '/admin/company/listy';
			}else if(str == 'tab3'){
				location.href = '/admin/company/listb';
			}
		}
    </script>
    <!-- //tab -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>