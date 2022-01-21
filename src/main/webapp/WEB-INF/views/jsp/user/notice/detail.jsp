<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<%@taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
    <sec:csrfMetaTags/>
<script type="text/javascript">
//숫자 콤마 설정
function numberWithCommas(x) {return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");}

//테이블 그리는 함수
function drawingFileInfo(rows){
	var html='';
	for(var list in rows){
		var fileUrl = "/user/notice/fileupload/download/"+undefinedChk(rows[list].fseq,"");
		html += undefinedChk(rows[list].fname,"")+'&nbsp;<a href="'+fileUrl+'" class="btn-line-s btn_gray"><button type="button">다운로드</button><br />';
	}
	$("#filelist").html(html);
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
                <div id="data_detail">
                
                
                <section class="tbl_wrap_view">
					<table class="tbl_view01" summary="테이블 입니다. 항목으로는 등이 있습니다">
					    <caption>테이블</caption>
						<colgroup>
							<col width="180px;" />
							<col width="620px" />
							<col width="180px;" />
							<col width="220px" />
						</colgroup>
						<tbody>
						<tr>
							<th scope="row">제목</th>
							<td>${notice.NTitle }</td>
							<th>작성일</th>
						<td>
							<c:if test='${!empty(notice.NRegDt) }'>
								${fn:substring(notice.NRegDt,0,4) }-${fn:substring(notice.NRegDt,4,6) }-${fn:substring(notice.NRegDt,6,8) }
							</c:if>
							</td>
						</tr>
						<tr class="h400">
							<th scope="row">내용</th>
							<td colspan="3" class="vat01">${notice.NContent }</td>
						</tr>
						<tr>
							<th scope="row">첨부파일</th>
							<td colspan="3" id="filelist">
							<c:if test='${!empty(file) }'>
							<c:forEach var="result" items="${file}" varStatus="status">
								<span style="display:inline-block; width:200px;padding-top:4px">${result.FName }</span><a href="/user/notice/fileupload/download/${result.FSeq}" class="btn-line-s btn_gray"><button type="button">다운로드</button></a><br />
							</c:forEach>
							</c:if>
							</td>
						</tr>
					</tbody>
				</table>
				</section>
				<section class="tac m-t-50">
				<button type="button" class="btn btn_gray m-r-11" onclick="history.back();">이전</button>
				</section>
                
                
                
                
                
                </div>
            </div>
            <!-- //content -->
        </div>
        <!-- //container -->
	<span id="pageNo" class="hidden" style="display:none;"></span>
<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>