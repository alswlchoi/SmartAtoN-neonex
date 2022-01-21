<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp"%>
<sec:csrfMetaTags />
<script type="text/javascript">
	//화면 최초 조회
	$(document).ready(function() {
		search(1);
		//페이징 조회 버튼
		$(document).on("click", ".pageNo", function() {
			search($(this).attr("data-page"));
		});

		//조회버튼
		$("#searchBtn").on("click", function() {
			search(1);
		});
		//조회 엔터키 처리
		$("#searchKeyword").focus(function() {
			$(this).keydown(function(k) {
				if (k.keyCode == 13) {
					search();
				}
			});
		});

	})

	var cIndex;

	//조회 버튼
	function search(page) {
		var param = {
			ctype : $("#searchKeyword").val(),
			pageNo : page
		};
		//console.log($("#searchKeyword").val());
		postAjax("/admin/code/list", param, "searchlist", null, null, null);
		console.log(param);
	}

	//조회 버튼 콜백
	function searchlist(data) {
		console.log(data);
		var list = data.list;
		
		cIndex = list.length;
		$("#codeList").html("");
		var html = "";
		$.each(list,function(i, el) {
			var code = el;
			html += '<tr>';
			html += '<td><input type="hidden" id="cSeq'+i+'" class="form_group w_full" value="'+code.cseq+'" /> '+ code.num + ' </td>';
			html += '<td>';
			html += '<div class="form_group">';
			html += '<div class="select_group">';
			//html += '<select id="cType'+i+'" title="select" class="form_control" value="">';
			html += '<select id="cType'+ i +'" title="select" class="form_control" value=""';
			//console.log("============");
			if (list[i].corder == 0) {
				html += "disabled = true"
			}
			html += '>';
				<c:forEach var="list" items="${codeList}">
				//console.log("${list.CType}");
				html += '<option value="${list.CType}"';
				if (list[i].ctype == "${list.CType}") {
					 html += "selected";
					}
					 html += '>${list.CType}</option>';
				</c:forEach>
							//console.log("============");
							//console.log(list[i].cType);
							html += '</select>';
							html += '</div>';
							html += '</div>';
							html += '</td>';

							html += '<td>';
							html += '<div class="form_group w_full">';
							html += '<input type="text" id="cName'+i+'" class="form_control tac" value="'+code.cname+'" />';
							html += '</div>'
							html += '</td>';

							html += '<td>';
							html += '<div class="form_group w_full">';
							html += '<input type="text" id="cId'+i+'" class="form_control tac" value="'+code.cid+'" />';
							html += '</div>'
							html += '</td>';

							html += '<td>';
							html += '<div class="form_group w_full">';
							html += '<input type="text" id="cValue'+i+'" class="form_control tac" value="'+code.cvalue+'" />';
							html += '</div>'
							html += '</td>';

							html += '<td>';
							html += '<div class="form_group w_full">';
							//html += '<input type="text" id="cOrder'+i+'" class="form_control tac" value="'+code.corder+'" />';
							html += '<input type="text" value="' + code.corder + '" class="form_control tac" id="cOrder' + i + '"';
							if (list[i].corder == 0) {
								html += "disabled=true"
							}
							html += '${list.cOrder} />';

							html += '</div>'
							html += '</td>';

							html += '<td>';
							//html += '<button type="button" onclick="updateCode('+i+')" class="btn-line-s btn_default m-r-6">저장</button>';
							//PARENT NULL (삭제버튼 x)
							//PARENT NULL X (삭제버튼 생성)
							if (code.cparent == null || code.cparent == "") {
								html += '<button type="button" onclick="updateCode('
										+ i + ')" class="btn-line-s btn_default m-r-6">저장</button>';
								//html += '<button type="button" onclick="delBtn('+i+')" class="btn-line-s btn_gray">삭제</button>';
							} else {
								html += '<button type="button" onclick="updateCode('
										+ i + ')" class="btn-line-s btn_default m-r-6">저장</button>';
								html += '<button type="button" onclick="delBtn('
										+ i + ')" class="btn-line-s btn_gray">삭제</button>';
							}
							//html += '<button type="button" onclick="delBtn('+i+')" class="btn-line-s btn_gray">삭제</button>';
							html += '</td>';

							html += '<input type="hidden" id="cParent'+i+'" class="form_control tac" value="'+code.cparent+'" />';

							html += '</tr>';

						})
		$("#codeList").html(html);
		drawingPage(data.paging);
	}

	//데이터 삭제
	function delBtn(i) {
		var result = confirm("해당 내역을 삭제하시겠습니까? ");
		var param = {
			cseq : $("#cSeq" + i).val()
		};
		console.log(param);
		$(document).on("click",'#confirmTrue' ,function(){
			postAjax("/admin/code/delete", param, "showdelete", null, null, null)
		});
	}
	//삭제 콜백
	function showdelete(data) {
		//console.log("넘어오는: " + data);
		if (data > 0) {
			alert("삭제 완료");
			$(".lyClose").click(function(){	
				location.reload();
			});
		} else {
			alert("삭제 실패");
			console.log("실패");
		}
	}

	//데이터 저장
	function saveCode(cIndex) {
		var cId = $("#cId" + cIndex).val().replace(/ /gi,"");
		var cValue = $("#cValue" + cIndex).val().replace(/ /gi,"");
		
		if ($("#cType" + cIndex).val() == '') {
			alert("그룹을 입력해주세요");
			return;
		}
		
		if ($("#cName" + cIndex).val().trim() == '') {
			alert("코드명을 입력해주세요");
			return;
		}
		if ($("#cId" + cIndex).val().replace(/ /gi,"") == '') {
			alert("코드ID을 입력해주세요");
			return;
		}
		if ($("#cValue" + cIndex).val().replace(/ /gi,"") == '') {
			alert("코드값을 입력해주세요");
			return;
		}
		if ($("#cOrder" + cIndex).val() == '') {
			alert("정렬순서를 입력해주세요");
			return;
		}

		var param = {
			cparent : $("#cParent" + cIndex).val(),
			cid : cId,
			cname : $("#cName" + cIndex).val(),
			cvalue : cValue,
			ctype : $("#cType" + cIndex + " option:selected").val(),
			corder : $("#cOrder" + cIndex).val()
		//cnum : $("#num"+cIndex).val()
		};

 		postAjax("/admin/code/insert", param, "resultAlert", null, null, null);
		console.log("정보저장");
		console.log(param);
	}

	//저장 콜백
	function resultAlert(data) {
		if (data > 0) {
			alert("등록/수정 이 완료되었습니다.");
			$(".lyClose").click(function(){
				location.reload();
			});
		} else {
			alert("등록/수정 이 실패하였습니다.");
			console.log("실패");
		}
	}

	//데이터 수정
	function updateCode(i) {
		if ($("#cName" + i).val() == '') {
			alert("코드명을 입력해주세요");
			return;
		}
		if ($("#cId" + i).val() == '') {
			alert("코드ID을 입력해주세요");
			return;
		}
		if ($("#cValue" + i).val() == '') {
			alert("코드값을 입력해주세요");
			return;
		}
		if ($("#cOrder" + i).val() == '') {
			alert("정렬순서를 입력해주세요");
			return;
		}

		var param = {
			cparent : $("#cParent" + i).val(),
			cid : $("#cId" + i).val(),
			cname : $("#cName" + i).val(),
			cvalue : $("#cValue" + i).val(),
			ctype : $("#cType" + i + " option:selected").val(),
			corder : $("#cOrder" + i).val(),
			cseq : $("#cSeq" + i).val()
		};

		postAjax("/admin/code/update", param, "updateAlert", null, null, null)
		console.log("정보수정");
		console.log(param);
	}

	//수정 콜백
	function updateAlert(param) {
		if (param > 0) {
			alert("등록/수정 이 완료되었습니다.");
			$(".lyClose").click(function(){
				location.reload();
			});
		} else {
			alert("등록/수정 이 실패하였습니다.");
			console.log("실패");
		}
 	}

	//등록
	function addCode() {
		cIndex++;
		var html = "";

		html += '<tr>';
		html += '<td><input type="hidden" id="cSeq'+cIndex+'" class="form_group w_full" value="" /> </td>';

		html += '<td>';
		html += '<div class="form_group">';
		html += '<div class="select_group">';
		html += '<select id="cType'+cIndex+'" title="select" class="form_control" value="">';
		html += '<option value="">그룹선택</option>';
		<c:forEach var="list" items="${codeList }">
		html += '<option value="${list.CType}"';
		html += '>${list.CType}</option>';
		</c:forEach>
		html += '</select>';
		html += '</div>';
		html += '</div>';
		html += '</td>';

		html += '<td>'
		html += '<div class="form_group w_full">';
		html += '<input type="text" id="cName'+cIndex+'" class="form_control tac" placeholder="코드명 입력" name="" value="" />';
		html += '</div>';
		html += '</td>';

		html += '<td>'
		html += '<div class="form_group w_full">';
		html += '<input type="text" id="cId'+cIndex+'" class="form_control tac" placeholder="코드ID 입력" name="" value="" />';
		html += '</div>';
		html += '</td>';

		html += '<td>'
		html += '<div class="form_group w_full">';
		html += '<input type="text" id="cValue'+cIndex+'" class="form_control tac" placeholder="코드값 입력" name="textid" value="" />';
		html += '</div>';
		html += '</td>';

		html += '<td>'
		html += '<div class="form_group w_full">';
		html += '<input type="text" id="cOrder'+cIndex+'" class="form_control tac" placeholder="정렬순서 입력" name="textid" value="" />';
		html += '</div>';
		html += '</td>'

		html += '<td>';
		html += '<button type="button" onclick="saveCode(' + cIndex
				+ ')" class="btn-line-s btn_default m-r-6">저장</button>';
		html += '<button type="button" id="cancelBtn"(' + cIndex
				+ ')" class="btn-line-s btn_gray">취소</button>';
		html += '</td>';
		html += '</tr>';

		html += '<input type="hidden" id="cParent'+cIndex+'" class="form_control tac" value="" />';

		html += '</tr>';

		$("#codeList").prepend(html);
		$("#cancelBtn").on("click", function(){
			$(this).parents("tr").remove();
		});
		$("input[name=textid]").replacereplace(/,/gi,"");
	}
</script>
<!-- container -->
<div id="container">
	<!-- content -->
	<div class="content">
		<!-- breadcrumb -->
		<div class="breadcrumb">
			<span class="breadcrumb_icon"></span><span>시스템관리</span><span>시스템
				코드관리</span>
		</div>
		<!-- //breadcrumb -->
		<!-- title -->
		<h2 class="title">시스템 코드관리</h2>
		<!-- //title -->

		<!-- search_wrap -->
		<section class="search_wrap">
			<div class="form_group">
				<div class="select_group">
					<select id="searchKeyword" title="select" class="form_control">
						<option value="">전체</option>
						<c:forEach var="list" items="${codeList}">
							<option value="${list.CType}">${list.CType}</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<button type="button" id="searchBtn" class="btn-s btn_default">조회</button>
		</section>
		<!-- //search_wrap -->

		<!-- table list -->
		<section class="tbl_wrap_list m-t-30">
			<button type="button" id="addCode" onclick="addCode()"
				class="btn btn_default posi_right_0_2">등록</button>
			<table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
				<caption>테이블</caption>
				<colgroup>
					<col width="80px" />
					<col width="155px" />
					<col width="294px" />
					<col width="157px" />
					<col width="155px" />
					<col width="189px" />
					<col width="287px" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">구분</th>
						<th scope="col">코드명</th>
						<th scope="col">코드ID</th>
						<th scope="col">코드값</th>
						<th scope="col">정렬순서</th>
						<th scope="col">비고</th>
					</tr>
				</thead>
				<tbody id="codeList">
					<!-- <tr>
                                <td>10</td>
                                <td>
                                    <div class="form_group">
                                        <div class="select_group">
                                            <select id="" title="select" class="form_control">
                                                <option value="">그룹 선택</option>
                                                <option value="">선택하세요1</option>
                                                <option value="">선택하세요2</option>
                                                <option value="">선택하세요3</option>
                                            </select>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="form_group w_full">
                                        <input type="text" id="" class="form_control tac" placeholder="코드명 입력"
                                            name="" />
                                    </div>
                                </td>
                                <td>
                                    <div class="form_group w_full">
                                        <input type="text" id="" class="form_control tac" placeholder="코드ID 입력"
                                            name="" />
                                    </div>
                                </td>
                                <td>
                                    <div class="form_group w_full">
                                        <input type="text" id="" class="form_control tac" placeholder="코드값 입력"
                                            name="" />
                                    </div>
                                </td>
                                <td>
                                    <div class="form_group w_full">
                                        <input type="text" id="" class="form_control tac" placeholder="정렬순서 입력"
                                            name="" />
                                    </div>
                                </td>
                                <td>
	                                <button type="button" class="btn-line-s btn_default m-r-6">저장</button>
	                                <button type="button" class="btn-line-s btn_gray">삭제</button>
                                </td>
                            </tr>  -->
				</tbody>
			</table>
		</section>
		<!-- //table list -->
		<!-- Pagination -->
		<section id="pagingc" class="pagination m-t-30">
			<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
		</section>
		<!-- //Pagination -->
	</div>
	<!-- //content -->
</div>
<!-- //container -->

<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp"%>