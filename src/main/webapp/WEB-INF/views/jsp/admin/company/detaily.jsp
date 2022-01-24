<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
        <!-- container -->
        <script type="text/javascript">
		$(document).ready(function(){			
			$("#data_area").hide();	//페이지 로딩시 등록/수저폼 가림
			$("#search").keydown(function(key) {
				if (key.keyCode == 13) {
					search("button");
				}
			});
			
			$(document).on("click",'#appBtn' ,function(){
				var compCode = $("#data_table>tbody>tr:eq(0)>td:eq(0)").text();
				var memApproval = "Y";
				$.ajax({
					url : "/admin/company/change-company",
					type : "get",
					data : {
						"compCode":compCode,
						"memApproval":memApproval
					},
					success : function(resdata){
						alert2(resdata.message);
						$(".condition").html("승인완료");
						$("#approvalBtn").hide();
					},
					error : function(e){
						console.log(e);
					}
				});
			});
			
			$(document).on("click",'#rtnBtn' ,function(){
				var compCode = $("#data_table>tbody>tr:eq(0)>td:eq(0)").text();
				var rtnRsn = $("#rtnRsn").val();
				var memApproval = "R";
				$.ajax({
					url : "/admin/company/change-company",
					type : "get",
					data : {
						"compCode":compCode,
						"memApproval":memApproval,
						"compMemo":rtnRsn
					},
					success : function(resdata){
						alert2(resdata.message);
						$(".condition").html('<span class="color_red">승인반려</span><br /><button type="button" class="btn-line-s btn_gray" data-layer="reason_result">사유보기</button>');
						$("#compMemo").val(rtnRsn);
						$("#approvalBtn").hide();
					},
					error : function(e){
						console.log(e);
					}
				});
			});
			
			$(document).on("click",'.updBtn' ,function(){	//할인율, 메모 수정 처리
				if($('input:radio[id=dcy]').is(':checked')==true && ($("#dcCount").val()=="" || isNaN($("#dcCount").val()))){
					alert("할인율을 입력해 주세요.");
				}else{
					var compCode = $("#data_table>tbody>tr:eq(0)>td:eq(0)").text();
					var dcCount = $("#dcCount").val();
					var compMemo = $("#compMemo").val();
					
					var data ={
							compCode : compCode,
							dcCount : dcCount,
							compMemo : compMemo
					};
					
					postAjax("/admin/company/update-company",data,"successUpdate","",null,null);
				}
			});
		});

		function successUpdate(data){
			if(data.code > 0){
				alert(data.message);
				$(document).on("click",'.lyClose' ,function(){
					location.href="/admin/company/listy";
				});
			}else{
				alert(data.message);
			}
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
		
		$(document).on("click","span[id^=fn]",function(){
			var fseq = $(this).prop("id").replace("fn", "");
			var url = "/admin/company/fileupload/download/"+fseq;
			
		    $.ajax({
		        method:"GET",
		        url : url,
		        success : function(data) {
		        	console.log("code : " + data.code);
		            if(data.code!=200){
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
				 
				var data ={
					compCode : compCode,
					blackList : blackList
				};
				
				postAjax("/admin/company/update-blacklist",data,"successBlackList","",null,null);
			});	
		});
		
		$(document).on("click","span[id^=fn]",function(){
			var fseq = $(this).prop("id").replace("fn", "");
			var url = "/admin/company/fileupload/download/"+fseq;
			
			$.ajax({
		        method:"GET",
		        url : url,
		        success : function(data) {
		        	console.log("code : " + data);
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

		function successBlackList(data){
			if(data.code > 0){
				var blackList = $("#data_table tbody tr td span.blchk").text();
				var message = "블랙리스트로 등록되었습니다.";
				if(blackList=="(B/L)"){		//블랙리스트 -> 해제
					message = "블랙리스트에서 해제되었습니다.";
				}
				alert(message);
				$(document).on("click",'.lyClose' ,function(){
					location.href="/admin/company/listy";
				});
			}else{
				alert(data.message);
			}
		}
		
		function replaceBrTag(str) {
            str = str.replace(/\r\n/ig, '\n');
            str = str.replace(/\\n/ig, '\n');
            str = str.replace(/\n/ig, '\n');
            return str;
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
		
		function dcZero(){
			$("#dcCount").val("");
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
                        <div id="tab1" class="tabcontent">                         
							   <!-- 상세보기 시작 -->
							   <section id="data_detail" class="tbl_wrap_list">	
							   <button type="button" class="btn-line-s btn_gray posi_right_0 goBlacklist" data-layer="blacklist"><c:if test="${company.blackList eq 'Y' }">블랙리스트 해제</c:if><c:if test="${company.blackList eq 'N' }">블랙리스트 등록</c:if></button>		
								<table id="data_table" class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
								<caption>회원사 상세 정보</caption>
								<colgroup><col width="" /><col width="" /><col width="" /><col width="" /><col width="" /><col width="" /></colgroup>
								<thead><tr><th scope="col">관리번호</th><th scope="col">회사명</th><th scope="col">사업자 번호</th><th scope="col">신청일시</th><th scope="col">상태</th></tr></thead>
								<tbody>
								<tr>
								<td>${company.compCode }</td>
								<td>${company.compName }
								<c:if test="${company.blackList eq 'Y' }">
									<br /><span class="blchk color_red">(B/L)</span></td>
								</c:if>
								<c:if test="${company.blackList ne 'Y' }">
									<br /><span class="blchk red"></span></td>
								</c:if>
								<td>
									<c:set value="${company.compLicense}" var="compLicense" />
									${fn:substring(compLicense, 0, 3) }-${fn:substring(compLicense, 3, 5) }-${fn:substring(compLicense, 5, 10) }
                				</td>
								<td>
					            	<c:set var="compRegDt" value="${company.compRegDt}"/>
									${fn:substring(compRegDt,0,4) }-${fn:substring(compRegDt,4,6) }-${fn:substring(compRegDt,6,8) } ${fn:substring(compRegDt,8,10) }:${fn:substring(compRegDt,10,12) }:${fn:substring(compRegDt,12,14) }
								</td>
								<td class="condition">
								<c:if test="${company.memApproval eq 'Y' }">승인완료</c:if>
								<c:if test="${company.memApproval eq 'N' }">승인대기</c:if>
								<c:if test="${company.memApproval eq 'R' }"><span class="color_red">승인반려</span><br /><button type="button" class="btn-line-s btn_gray" data-layer="reason_result">사유보기</button></c:if>
								</td>
								</tr>
								</tbody>
								</table>
								<h3 class="stitle m-t-30">사업자 및 담당자 정보</h3>
								<section class="tbl_wrap_view m-t-10">			
								<table class="tbl_view01" summary="테이블입니다.">
								<caption>사업자 및 담당자 정보</caption>
								<colgroup><col width="200px" /><col width="" /><col width="200px" /><col width="" /></colgroup>
								<tbody>
								<tr>
								<th scope="row">회사주소</th>
								<td colspan="3">(${company.compPostNo }) ${company.compAddr } ${company.compAddrDetail }
								</td>
								</tr>
								<tr>
								<th scope="row">사업자등록사본</th>
								<td>
									<c:if test="${fseq ne '' and fname ne ''}">
										<span id="fn${fseq }" style="cursor:pointer;text-decoration:underline">${fname }</span>
									</c:if>
								</td>
								<th scope="row">할인적용여부 / 할인율</th>
								<td>
								    <div class="form_group">
								        <div class="radio_inline">
								            <label class="radio_default">
								                <input type="radio" name="dcyn" id="dcn" value="N"<c:if test="${empty company.dcCount}"> checked="checked"</c:if> onclick="dcZero()" />
								                <span class="radio_icon"></span>미적용
								            </label>
								            <label class="radio_default">
								                <input type="radio" name="dcyn" id="dcy" value="Y"<c:if test="${!empty company.dcCount}"> checked="checked"</c:if> />
								                <span class="radio_icon"></span>적용
								            </label>
								            <div>
								                <input type="text" name="dcCount" id="dcCount" placeholder="할인율" style="width:60px;display: inline;" class="form_control" maxlength="5" value="${company.dcCount }" />
								                <span>%</span>
								            </div>
								        </div>
								    </div>
								</td>
								</tr>
								<tr>
								<th scope="row">담당자명</th>
								<td>${company.memName }</td>
								<th scope="row">부서명</th>
								<td>${company.memDept }</td>
								</tr>
								<tr>
								<th scope="row">이메일주소</th>
								<td colspan="3">${company.memEmail }</td>
								</tr>
								<tr>
								<th scope="row">회사전화번호</th>
								<td>
                               		<c:set var='compPhone' value='${company.compPhone }' />
                                    <c:if test='${compPhone != "" }'>
										<c:if test='${fn:substring(compPhone,0,2) =="02" }'>
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
								<th scope="row">휴대전화번호</th>
								<td>
									<c:set var='memPhone' value='${company.memPhone }' />
									${fn:substring(memPhone,0,3) }-${fn:substring(memPhone,3,7) }-${fn:substring(memPhone,7,11) }
                                </td>
								</tr>
								</tbody>
								</table>
								</section>
								
								<h3 class="stitle m-t-30">회계 담당자 정보</h3>
								<section class="tbl_wrap_view m-t-10">
								<table class="tbl_view01">
								<caption>회계 담당자 정보</caption>
								<colgroup><col width="180px;" /><col width="40%" /><col width="180px;" /><col width="" /></colgroup>
								<tbody>
								<tr>
								<th scope="row">담당자명</th>
								<td>${company.compAcctName }</td>
								<th>부서명</th>
								<td>${company.compAcctDept }</td>
								</tr>
								<tr>
								<th scope="row">이메일주소</th>
								<td>${company.compAcctEmail }</td>
								<th>회사전화번호</th>
								<td>
                               		<c:set var='compAcctPhone' value='${company.compAcctPhone }' />
                                    <c:if test='${compAcctPhone != "" }'>
										<c:if test='${fn:substring(compAcctPhone,0,2) =="02" }'>
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
								
								<h3 class="stitle m-t-30">서비스 및 시설 이용 관련 정보</h3>
								<div class="tbl_wrap_view m-t-10">
								<table class="tbl_view01" summary="서비스 및 시설 이용 관련 정보 테이블입니다.">
								<caption>서비스 및 시설 이용 관련 정보</caption>
								<colgroup><col width="180px;" /><col width="" /></colgroup>
								<tbody>
								<tr>
								<th scope="row">가입 목적</th>
								<td>${company.memPurpose }</td>
								</tr>
								</tbody>
								</table>
								</div>
								
								<h3 class="stitle m-t-30">관리자 메모</h3>
								<div class="tbl_wrap_view m-t-10">
								<table class="tbl_view01" summary="관리자 메모 테이블입니다.">
								<caption>관리자 메모</caption>
								<colgroup><col width="180px;" /><col width="" /></colgroup>
								<tbody>
								<tr>
								<th scope="row">메모</th>
								<td colspan="3"><div class="form_group w_full"><textarea name="compMemo" id="compMemo" cols="" rows="5" class="form_control  h100" placeholder="메모를 입력하세요." style="resize: none;">${company.compMemo }</textarea></div></td>
								</tr>
								</tbody>
								</table>
								</div>
								
								<section class="btn_wrap m-t-50">
									<button type="button" id="listBtn" class="btn btn_gray" onclick="location.href='/admin/company/listy'">목록</button>
									<section>
								    <button type="button" class="btn btn_gray m-r-6" data-layer="cancel">취소</button>
								    <button type="button" class="btn btn_default updBtn" data-layer="complete">저장</button>
									</section>
								</section>
							   </section>
							   <!-- 상세보기 끝 -->
						</div>
                        <!-- //tab1-회원가입 신청내역 -->
                    </div>
                </div>
                <!-- //tab -->
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