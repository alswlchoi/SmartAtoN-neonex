<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<%@taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
    <sec:csrfMetaTags/>
    
    <fmt:formatNumber value="${nSeq}" type="Number" var="nSeq" />
    
    <c:if test='${nSeq gt 0 }'>
	    <script type="text/javascript">
	    	var nSeq = "${nSeq}";
	    	location.href="/user/notice/${noticeList.rows[0].NType }/detail/"+nSeq;
	    </script>	    
    </c:if>
	<script type="text/javascript">
	var initSeq = '<c:out value="${nSeq}" />';
	
	$(function(){
		$("#search").keydown(function(key) {
			if (key.keyCode == 13) {
				search("button");
			}
		});
	
		$("#searchBtn").click(function(){
			search("button");
		});
	});
	
	//페이지 버튼 클릭
	$(document).on("click",".pageNo",function(){
		$(this).siblings().removeClass("on");
		$(this).addClass("on");
	
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
		var nType = '<c:out value="${nType}" />';
		var pageSize = $("#pageSize").val();
		var pageNo;
		var nTitle = $("#search").val();
	
		if(type=="button" && nTitle==""){
			alert("검색어를 입력하세요.");
			$("#search").focus();
			return false;
		}
	
		if(type == "button"){//버튼 검색
			pageNo = "1";
		}else if(type == "list") {//목록 버튼
			pageNo = $("#pageNo").text();
			$("#data_detail").hide();
		}else if(type == "paging"){//페이징 검색
			pageNo = $(".pageNo.on").attr("data-page");
		}
		$(".tbl_wrap_list").show();
		$.ajax({
			url : "/user/notice/"+nType+"/search-notice",
			type : "get",
			data : {
					"pageSize":pageSize,
					"pageNo"  :pageNo,
					"nTitle":nTitle
			},
			success : function(resdata){
				console.log("resdata",resdata);
				drawingTable(resdata.rows, resdata.paging);
				drawingPage(resdata.paging);
				$("#totCnt").html(numberWithCommas(resdata.paging.totalCount));
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
		if(typeof str1 =="undefined"){
			return str2;
		}else{
			return str1;
		}
	}
	
	//상세보기로 이동
	$(document).on("click","tr.on",function(){
		var nType = '<c:out value="${nType}" />';
		var currentRow=$(this).closest('tr');
		var pageSize = $("#pageSize").val();
		var pageNo;
		var nSeq = currentRow.find('td:eq(0) span').text();
	
		pageNo = $(".pageNo.on").attr("data-page");
		$("#pageNo").html(pageNo);
	
		location.href="/user/notice/"+nType+"/detail/"+nSeq;
	});
	
	//테이블 그리는 함수
	function drawingTable(rows, paging){
		var html='';
		for(var list in rows){
			html += '<tr onmouseover="this.className=\'on\'" onmouseout="this.className=\'\'">';
			html += '<td>';
			html += '<span style="display:none;">'+undefinedChk(rows[list].nseq,"")+'</span>';
			html += paging.totalCount-(paging.pageNo-1)*paging.pageSize-list;
			html += '</td>';
			html += '<td class="tal">'+undefinedChk(rows[list].ntitle,"")+'</td>';

			var nregDt = "";
			if(rows[list].nregDt.length==14){
				nregDt += rows[list].nregDt.substring(0,4);
				nregDt += "-";
				nregDt += rows[list].nregDt.substring(4,6);
				nregDt += "-";
				nregDt += rows[list].nregDt.substring(6,8);
			}
			html += '<td>'+nregDt+'</td>';
			html += '</tr>';
		}
		$("#tbody").html(html);
	}
	</script>
	<!-- container -->
    <div id="container">
        <!-- visual -->
        <div class="visual_sub customer"></div>
        <!-- //visual -->
        <!-- content -->
        <div class="content">
            <!-- breadcrumb -->
            <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>고객지원</span><span><c:if test="${nType eq 's' }">자료실</c:if><c:if test="${nType ne 's' }">공지사항</c:if></span></div>
            <!-- //breadcrumb -->
            <!-- title -->
            <h2 class="title"><c:if test="${nType eq 's' }">자료실</c:if><c:if test="${nType ne 's' }">공지사항</c:if></h2>
            <!-- //title -->
            <!-- table list -->
            <section class="tbl_wrap_list">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 번호, 제목, 작성일등이 있습니다">
                    <caption><c:if test="${nType eq 's' }">자료실</c:if><c:if test="${nType ne 's' }">공지사항</c:if> 테이블입니다.</caption>
                    <colgroup>
                        <col width="90px;" />
                        <col width="" />
                        <col width="200px" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">번호</th>
                            <th scope="col">제목</th>
                            <th scope="col">작성일</th>
                        </tr>
                    </thead>
                    <tbody id="tbody">
					<c:if test="${totalCnt == 0 }">
				        <tr>
				            <td colspan="3">데이터가 존재하지 않습니다.</td>
				        </tr>
					</c:if>
					<c:if test="${totalCnt > 0 }">
			        <c:forEach var="result" items="${noticeList.rows}" varStatus="status">
			            <tr onmouseover="this.className='on'" onmouseout="this.className=''">
			                <td><span style="display:none">${result.NSeq}</span>${fn:length(noticeList.rows)-status.count+1}</td>
			                <td class="tal">${result.NTitle}</td>
			                <td><c:set var="NRegDt" value="${result.NRegDt}"/>${fn:substring(NRegDt,0,4) }-${fn:substring(NRegDt,4,6) }-${fn:substring(NRegDt,6,8) }</td>
			            </tr>
			        </c:forEach>
			        </c:if>
			        </tbody>
                </table>
                <!-- Pagination -->
			    <section class="pagination m-t-30">
				    <jsp:include page="/WEB-INF/views/jsp/common/paging.jsp"/>
				</section>
                <!-- //Pagination -->
            </section>
            <!-- //table list -->
        </div>
        <!-- //content -->
    </div>
    <!-- //container -->
	<span id="pageNo" class="hidden" style="display:none;"></span>
<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>