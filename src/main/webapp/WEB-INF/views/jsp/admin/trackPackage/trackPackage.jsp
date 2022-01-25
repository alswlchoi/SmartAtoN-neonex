<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">

	//화면 최초 조회
	$(document).ready(function(){
		search(1);
		//페이징 버튼
		$(document).on("click", ".pageNo", function() {
			search($(this).attr("data-page"));
		});
	})
	
	var tIndex;
	
	//팝업실행시 post
	function showTrackPackage(tpId) {
		var param = {
			tpId: tpId,
		}
		//console.log(param);
		postAjax("/admin/trackPackage/detail-trackPackage", param, "showTid" , null, null, null);
	}
	
	//팝업창 표시하기
	function showTid(list) {
		var Html = "";
		console.log(list.trackPackage);
		$("#tpName").html(list.trackPackage[0].tpName);
		tIndex = list.trackPackage.length;
		$("#tpId").val(list.trackPackage[0].tpId);
		if (list.trackPackage[0].tname != null) {	//등록트랙 있다면
			for (var i in list.trackPackage) {
			 	if(list.trackPackage[i].tName !== null)
				{
				 	var trackPackage = list.trackPackage[i];
				    Html += '<tr>';
				    Html += '<td>'+trackPackage.num+'</td>';
				    Html += '<td>'+trackPackage.tname+'</td>';
					Html += '<input type="hidden" id="tId'+i+'" class="form_control tac" value="'+trackPackage.tid+'" />';
					Html += '</td>';
				    Html += '<td>';
				    Html += '<button type="button" class="btn-line-s btn_gray m-r-6" onclick="removeButton('+trackPackage.mapSeq+')">삭제</button>';
					Html += '</td>';
					Html += '</tr>';
				}
			}
			tIndex ++;
		}
			
			Html += '<tr>';
		    Html += '<td>'+tIndex+'</td>';
		    Html += '<td>';
			Html += '<div class="form_group w_full">';
			Html += '<div class="select_group">';
			Html += '<select id="trackNameAdd" title="select" class="form_control" value="">';
			Html += '<option value="">그룹선택</option>';
			for (var i in list.trackName) {
			var trackName = list.trackName[i];
			Html += '<option value="'+trackName.tid+'">';
			Html += ''+trackName.tname+'</option>';
			}
			Html += '</select>';
			Html += '</div>';
			Html += '</div>';
			Html += '</td>';
		    Html += '<td>';
		    Html += '<button type="button" class="btn-line-s btn_default m-r-6" onclick="registerButton('+tIndex+')">등록</button>';
			Html += '</td>';
			Html += '</tr>';
			
		$("#trackPackage").html(Html);
	}
	
	//데이터삭제
	function removeButton(i) {
		var result = confirm("정보를 삭제하겠습니까?");
		var param = {
			mapSeq : i,
		}
		console.log(param);
		$("#confirmTrue").click(function(){
			console.log("삭제");
			postAjax("/admin/trackPackage/delete", param, "showdelete", null, null, null)
		});
	}
	
	//삭제 콜백
	function showdelete(data) {
		//console.log("넘어오는: " + data);
		if (data > 0) {
			alert("삭제에 성공했습니다.");
		} else {
			alert("삭제에 실패했습니다.");
			console.log("실패");
		}
	}
	
	//트랙 등록
	function registerButton(i) {
		if($("#trackNameAdd").val() == '') {
			alert3("트랙을 입력해주세요");
			return;
		}
		var param = {
			tpId : $("#tpId").val(),
			tid : $("#trackNameAdd option:selected").val(),
		};
		
		postAjax("/admin/trackPackage/insert", param,"showinsert" , null, null, null)
	}
	
	//등록 콜백
	function showinsert(data) {
		if(data == 999){
			alert("이미 등록하신 트랙입니다.");
			return;
			console.log("실패");
		}else if (data > 0) {
			alert("등록에 성공했습니다.");
			return;
		}else {
			alert("등록에 실패했습니다.");
			return;
			console.log("실패");
		}
	}
	
	//조회
	function search(page){
		var param = {
			pageNo:page
		}
		console.log(param);
		postAjax("/admin/trackPackage/search",param,"searchCallback",null,null,null);
	}
	//조회 콜백
	function searchCallback(data){
		console.log("data = ",data);
		$("#codeList").html("");
		var Html ='';
		var list = data.list;
		if(list.length>0){
			$.each(list,function(i,el){
				Html += '<tr>';
				Html += '<td>';
				Html += list[i].num;
				Html += '</td>';
				Html += '<td>';
				Html += list[i].tpId;
				Html += '  ';
				Html +=  '<button type="button" class="btn-line-s btn_gray updBtn" data-layer="tp_search" data-opt="'+ list[i].tpId +'">수정</button>';
				Html += '</td>';
				Html += '<td>';
				Html += list[i].tpName;
				Html += '</td>';
				Html += '</tr>';
			});
		}else{
			Html += '<tr class="tr_nodata">';
			Html += '<td colspan="7">등록된 정보가 없습니다.</td>';
			Html += '</tr>';
		}
		$("#codeList").prepend(Html);
		drawingPage(data.paging);
	
		//수정버튼
		$(".updBtn").on('click',function(){
	 		showTrackPackage($(this).attr("data-opt"),$(this));
		});
	}
	
	 
</script>
 <!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시스템관리</span><span>트랙 패키지 관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">트랙 패키지 관리</h2>
        <!-- //title -->
        <!-- table list -->
		<section class="tbl_wrap_list m-t-30">
			<table id="data_table" class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
				<caption>테이블</caption>
				<colgroup>
					<col width="155px" />
					<col width="294px" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">트랙 패키지ID</th>
						<th scope="col">트랙 패키지이름</th>
					</tr>
				</thead>
				<tbody id="codeList">
				<!-- 화면로딩 -->
				</tbody>
			</table>
		</section>
        <!-- Pagination -->
		<section id="pagingc" class="pagination m-t-30">
			<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
		</section>
		<!-- //Pagination -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<span id="pageNo" style="display:none"></span>
<!-- popup_l -->
<div class="ly_group">
    <article class="layer_l tp_search">
        <!-- # 타이틀 # -->
        <h1><span id="tpName"></span> 패키지 수정</h1>
        <input type="hidden" id = "tpId">
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <!-- table list -->
            <p></p>
            <section class="tbl_wrap_list m-t-30">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="80px" />
                        <col width="" />
                        <col width="" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">번호</th>
                        <th scope="col">트랙이름</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody id="trackPackage"></tbody>
                </table>
            </section>
            <!-- //table list -->
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-6">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_l -->

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>