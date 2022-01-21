<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<%@taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
    <sec:csrfMetaTags/>
<script type="text/javascript">
$(document).ready(function(){
	$(document).on("click",'#listBtn' ,function(){
		history.back();
	});
	
	$(document).on("click",'#updBtn' ,function(){
		var dSeq = $("#data_table>tbody>tr:eq(0)>td:eq(0) span").text();
		
		$.ajax({
			url : "/user/driver/detail-driver",
			type : "get",
			data : {
				"dSeq":dSeq
			},
			success : function(resdata){
				$("#data_detail").hide();
				$("#data_area").show();
				$("#currentdSeq").val(undefinedChk(resdata.driver.dseq,""));
				$("#dName").val(undefinedChk(resdata.driver.dname,""));
				if(undefinedChk(resdata.driver.dbirth,"").length==8){
					var dBirth = undefinedChk(resdata.driver.dbirth,"");
					$("#dBirth").val(dBirth.substring(0,4)+'-'+dBirth.substring(4,6)+'-'+dBirth.substring(6,8));
				}
				$("#dEmail").val(undefinedChk(resdata.driver.demail,""));
				$("#dPhone").val(undefinedChk(resdata.driver.dphone,""));
				$("#dPhone2").val(undefinedChk(resdata.driver.dphone2,""));
				$("#dLicenseType").val(undefinedChk(resdata.driver.dlicenseType,"")).prop("selected", true);
				var dhistory = parseInt(undefinedChk(resdata.driver.dhistory,""));
				if(dhistory>=5){
					$("#dEduChk").prop("checked", true);
				}
				$("#dHistory").val(dhistory);
				$("#dBloodType").val(undefinedChk(resdata.driver.dbloodType,"")).prop("selected", true);
				$("#dBloodSpecial").val(undefinedChk(resdata.driver.dbloodSpecial,""));
				$("#regBtn").text("수정");
				$("#regBtn").removeClass("reg");
				$("#regBtn").addClass("upd");
			},
			error : function(e){
				console.log(e);
			}
		});
	});
	
	//데이터 삭제
	$('#delBtn').click(function(){
		var dSeq = $("#currentdSeq").val();

		$.ajax({
			url : "/user/driver/delete-driver",
			type : "get",
			data : {
				"dSeq":dSeq
			},
			success : function(resdata){
				if(resdata.code == 400){
					alert(resdata.message);
				}else{
					alert(resdata.message);
					$(document).on("click",'.btn-pop.btn_default.lyClose' ,function(){
						location.reload();
					});
				}
			},
			error : function(e){
				console.log(e);
			}
		});
	});
	//데이터 삭제 끝

	//날짜형식(YYYY-MM-DD) 체크
	var datatimeRegexp = RegExp(/^(19|20)\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$/);
	var emailCheck = RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i); 
	var phoneCheck= RegExp(/^[0-9]{11}/);
	var telCheck= RegExp(/^[0-9]{9,12}/);

	$("button[name=btnViewRreason]").click(function (e) {
		var currentRow=$(this).closest('tr');
		var dseq = currentRow.find('td:eq(0) span.seq').text();
		var rsn = $("#rsn"+dseq).html();
		$("#rsnArea").html(rsn);
        var containerH = $("#wrapper").outerHeight();
        var _target = "viewReason";
        $("." + _target).parent().removeAttr("style").addClass("on");
        // $("." + _target).parent().css({"height":containerH});
        $("." + _target).removeAttr("style").addClass("on");
        var _layerOn_length = $(".ly_group > .on").length;

        if (_layerOn_length && $("." + _target).parent().hasClass('ly_fixed')) {
            var _left = $("." + _target).outerWidth() / 2 + 213;
            var _top = $("." + _target).outerHeight() / 2;
            $("." + _target).css({
                "position": "absolute",
                "left": "50%",
                "top": "50%",
                "margin": -_top + "px 0 0 -" + _left + "px"
            });

        } else if (_layerOn_length) {
            var _left = $("." + _target).outerWidth() / 2;
            var _top = $("." + _target).outerHeight() / 2;
            $("." + _target).css({
                "position": "absolute",
                "left": "50%",
                "top": "50%",
                "margin": -_top + "px 0 0 -" + _left + "px"
            });
        }
		e.stopPropagation();
	});

	//등록/수정버튼 이벤트
	$("#regBtn").click(function(){	    
		var dEmail = $("#dEmail").val();
		var dPhone = $("#dPhone").val();
		var dPhone2 = $("#dPhone2").val();
		
		if($("#dName").val() == ""){
			$("#errdName").text("운전자 이름을 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dName").focus();
			return false;
		}
	    if (!datatimeRegexp.test($('#dBirth').val())) {
	    	$("#errdBirth").text("생년월일을 형식에 맞게 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dBirth").focus();
	        return false;
	    }
		if(!emailCheck.test(dEmail)){
			$("#errdEmail").text("이메일 주소를 형식에 맞게 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dEmail").focus();
			return false;
		}
		if(!phoneCheck.test(dPhone) || dPhone.length != 11){
			$("#errdPhone").text("휴대폰번호를 형식에 맞게 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dPhone").focus();
			return false;
		}
		if(!telCheck.test(dPhone2) || dPhone2.length < 9 || dPhone2.length > 12){
			$("#errdPhone2").text("전화번호를 숫자만 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dPhone2").focus();
			return false;
		}
		
		var didx = $("#dLicenseType1 option").index( $("#dLicenseType1 option:selected") );
		var didx2 = $("#dLicenseType2 option").index( $("#dLicenseType2 option:selected") );
		var didx3 = $("#dLicenseType3 option").index( $("#dLicenseType3 option:selected") );
		
		if(didx == 0){
			$("#errdLicenseType").text("운전면허종류을 선택해주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dLicenseType1").focus();
			return false;
		}
		
		if(didx2 == 0 && $("#dFile4").val() != ""){
			$("#errdLicenseType2").text("운전면허종류을 선택해주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dLicenseType2").focus();
			return false;
		}
		
		if(didx3 == 0 && $("#dFile5").val() != ""){
			$("#errdLicenseType3").text("운전면허종류을 선택해주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dLicenseType3").focus();
			return false;
		}
		
		if(!$(':input:checkbox[id=dEduChk]:checked').val()) {   
			$("#errdHistory").text("운전경력 5년 이상항목에 체크해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dEduChk").focus();
			return false;
		}
		
		var dHistory = $("#dHistory").val();
		
		if(dHistory == "" || isNaN(dHistory) || dHistory < 5){
			$("#errdHistory").text("5년 이상의 운전 경력을 입력해 주시기 바랍니다.");
			$("#dHistory").focus();
			return false;
		}
		if($("#dFile").val() == ""){
			$("#errdFile").text("운전면허증을 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dFile").focus();
			return false;
		}

		if($("#dFile4").val() == "" && $("#dLicenseType2").val() != ""){
			$("#errdFile4").text("운전면허증을 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dFile4").focus();
			return false;
		}
		
		if($("#dFile5").val() == "" && $("#dLicenseType3").val() != ""){
			$("#errdFile5").text("운전면허증을 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dFile5").focus();
			return false;
		}
		
		if(!$(':radio[name=dBloodType]:checked').val()) {   
			$("#errdBloodType").text("혈액형을 선택해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dBloodType").focus();
		   return false;
		}
		if($("#dFile2").val() == ""){
			$("#errdFile2").text("동의서를 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dFile2").focus();
			return false;
		}
		if($("#dFile3").val() == ""){
			$("#errdFile3").text("재직증명서를 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dFile3").focus();
			return false;
		}

		var LType = $("#dLicenseType1").val() + "," + $("#dLicenseType2").val() + "," + $("#dLicenseType3").val();
		
		$("#dLicenseType").val(LType);
				
		var form = $("form")[0];        
		var formData = new FormData(form);
		/*
		for (var key of formData.keys()) {
		  console.log(key);
		}

		for (var value of formData.values()) {
		  console.log(value);
		}
		*/
		
		
		if($(this).hasClass("reg")){
			$.ajax({
				url : "/user/driver/fileupload/insert-driver",
				type: "POST",
	   	   		enctype: "multipart/form-data",
	            processData : false,
	            contentType : false,
				data : formData,		        
				success : function(resdata){
					if(resdata.code == 400){
						alert(resdata.message);
					}else{
						alert(resdata.message);
						$(document).on("click",'.lyClose' ,function(){
							location.href="/user/driver";
						});
					}
				},
				error : function(e){
					console.log(e);
				}
			});
				
		}else if($(this).hasClass("upd")){
			var dSeq = $("#currentdSeq").val();
			formData.append("dSeq", dSeq);
	  		$.ajax({
	 			url : "/user/driver/update-driver",
				type: "POST",
	   	   		enctype: "multipart/form-data",
	            processData : false,
	            contentType : false,
				data : formData,
	 			success : function(resdata){
	 				if(resdata.code == 400){
	 					alert(resdata.message);
	 				}else{
	 					alert(resdata.message);
		 				location.reload();
	 				}
	 			},
	 			error : function(e){
	 				console.log(e);
	 			}
	 		});
		}
	});	
	
	$("div input[id^=d]").keyup(function(){
		var id = $(this).prop("id");
		var val = $(this).val();
		if(id=="dBirth"){
			if(datatimeRegexp.test(val)) {
				$("#err"+id).text("")
				.removeClass("redfont")
				.removeClass("info_ment");
			}else{
				$("#err"+id).text("생년월일을 형식에 맞게 입력해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");	
			}
		}else if(id=="dEmail"){
			if(emailCheck.test(val) && val != "") {
				$("#err"+id).text("")
				.removeClass("redfont")
				.removeClass("info_ment");
			}else{
				$("#err"+id).text("이메일 주소를 형식에 맞게 입력해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
			}
		}else if(id=="dPhone"){
			if(phoneCheck.test(val) && val.length == 11){
				$("#errdPhone").text("‘-’ 없이 입력하세요.")
				.removeClass("redfont")
			} else{
				$("#errdPhone").text("형식에 맞지 않는 번호 입니다.")
				.addClass("redfont")
				.addClass("info_ment");
			}
		}else if(id=="dPhone2"){
			if(telCheck.test(val) && val.length >= 9 && val.length <= 12) {
				$("#errdPhone2").text("‘-’ 없이 입력하세요.")
				.removeClass("redfont")
			}else{
				$("#errdPhone2").text("형식에 맞지 않는 번호 입니다.")
				.addClass("redfont")
				.addClass("info_ment");
			}
		}else if(id=="dEduChk"){
			if($(':input:checkbox[id=dEduChk]:checked').val()!="") {
				$("#errdHistory").text("")
				.removeClass("redfont")
				.removeClass("info_ment");
			}else {
				$("#errdHistory").text("운전경력은 5년이상인 자만 등록 가능합니다. 5년 이상인 경우 5년 이상에 체크해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
			}
		}else if($(this).prop("name")=="dBloodType"){
			if($(':radio[name=dBloodType]:checked').val() != "") {
				$("#errdBloodType").text("")
				.removeClass("redfont")
				.removeClass("info_ment");			
			}else {
				
			}
		}else if(id=="dHistory"){
			if(!$(':input:checkbox[id=dEduChk]:checked').val()) {   
				$("#errdHistory").text("운전경력 5년 이상항목에 체크해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
				$("#dEduChk").focus();
			}else{
				if(val != "" && !isNaN(val) && val >= 5) {
					$("#errdHistory").text("")
					.removeClass("redfont")
					.removeClass("info_ment");			
				}else {
					$("#errdHistory").text("5년 이상의 운전 경력을 입력해 주시기 바랍니다.")
					.addClass("redfont")
					.addClass("info_ment");				
				}	
			}
		}else if(id=="dName"){
			if(val != "") {
				$("#errdName").text("")
				.removeClass("redfont")
				.removeClass("info_ment");	
			}else {
				$("#errdName").text("운전자 이름을 입력해 주시기 바랍니다.")
				.addClass("redfont")
				.addClass("info_ment");
			}
		}
	});
	
	$("#dLicenseType1").change(function(){		
		var didx = $("#dLicenseType1 option").index( $("#dLicenseType1 option:selected") );
		
		if(didx == 0){
			$("#errdLicenseType").text("운전면허종류을 선택해주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dLicenseType1").focus();
		}else{
			$("#errdLicenseType").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
			$("#dLicenseType1").focus();
		}
	});

	$("#dLicenseType2").change(function(){		
		var didx = $("#dLicenseType2 option").index( $("#dLicenseType2 option:selected") );
		
		if(didx == 0 && $("#dFile4").val() != ""){
			$("#errdLicenseType2").text("운전면허종류을 선택해주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dLicenseType2").focus();
		}else{
			$("#errdLicenseType").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
			$("#dLicenseType2").focus();
		}
	});
	
	$("#dLicenseType3").change(function(){		
		var didx = $("#dLicenseType3 option").index( $("#dLicenseType3 option:selected") );
		
		if(didx == 0 && $("#dFile5").val() != ""){
			$("#errdLicenseType3").text("운전면허종류을 선택해주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dLicenseType3").focus();
		}else{
			$("#errdLicenseType3").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
			$("#dLicenseType3").focus();
		}
	});
	
	$(":radio[name=dBloodType]").click(function(){
		$("#errdBloodType").text("")
		.removeClass("redfont")
		.removeClass("info_ment");
	});
	
	$("#dFileS").change(function(){
		if($("#dFileS").val() != "") {
			$("#errdFile").text("")
			.removeClass("redfont")
			.removeClass("info_ment");	
		}else {
			$("#errdFile").text("운전면허증을 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
		}
	});

	$("#dFileS4").change(function(){
		if($("#dLicenseType2").val() != ""){
			if($("#dFileS4").val() != "") {
				$("#errdFile4").text("")
				.removeClass("redfont")
				.removeClass("info_ment");	
			}else {
				$("#errdFile4").text("운전면허증을 등록해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
			}
		}
		
	});

	$("#dFileS5").change(function(){
		if($("#dLicenseType3").val() != ""){
			if($("#dFileS5").val() != "") {
				$("#errdFile5").text("")
				.removeClass("redfont")
				.removeClass("info_ment");	
			}else {
				$("#errdFile5").text("운전면허증을 등록해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
			}
		}
		
	});
	
	$("#dFile2S").change(function(){
		if($("#dFile2S").val() != "") {
			$("#errdFile2").text("")
			.removeClass("redfont")
			.removeClass("info_ment");	
		}else {
			$("#errdFile2").text("동의서를 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
		}
	});
	
	$("#dEduChk").click(function(){
		if(!$(':input:checkbox[id=dEduChk]:checked').val()) {   
			$("#errdHistory").text("운전경력 5년 이상항목에 체크해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dEduChk").focus();
		}else{
			var val = $("#errdHistory").val();
			if(val != "" && !isNaN(val) && val >= 5) {
				$("#errdHistory").text("")
				.removeClass("redfont")
				.removeClass("info_ment");			
			}else {
				$("#errdHistory").text("5년 이상의 운전 경력을 입력해 주시기 바랍니다.")
				.addClass("redfont")
				.addClass("info_ment");				
			}	
		}
	});
	
	$(document).on("click", "button[data-layer='cancel_info']", function(){
		var currentRow=$(this).closest('tr');
		var dSeq = currentRow.find('td:eq(0) span.seq').text();
		$("#currentdSeq").val(dSeq);
		return false;
	});

	//상세보기로 이동
	$(document).on("click", "#tbody tr", function(){
		var currentRow=$(this).closest('tr');
		var pageSize = $("#pageSize").val();
		var pageNo;
		var dseq = currentRow.find('td:eq(0) span.seq').text();
		
		pageNo = $(".pageNo.active").attr("data-page");
		$("#pageNo").html(pageNo);
		
		$.ajax({
			url : "/user/driver/detail-driver",
			type : "get",
			data : {
				"pageSize":pageSize,
				"pageNo"  :pageNo,
				"dSeq":dseq
			},
			success : function(resdata){
				drawingDetailTable(resdata.driver);
			},
			error : function(e){
				console.log(e);
			}
		});
	});
});	

//페이지 버튼 클릭
$(document).on("click",".pageNo",function(){  
	$(this).siblings().removeClass("active");
	$(this).addClass("active");
	
	if($(this).attr("data-page")==1){
		$(".pg_first").hide();
		$(".pg_prev").hide();
	}else{
		$(".pg_first").show();
		$(".pg_prev").show();
	}
	search("paging");

});

//등록 이미지 등록 미리보기
function readInputFile(input) {
	if(input.files && input.files[0]) {
		var reader = new FileReader();
		reader.onload = function (e) {
			$('#preview').html("<img src="+ e.target.result +">"); 
		}
		reader.readAsDataURL(input.files[0]);
	}
}

$(".inp-img").on('click', function(){
	readInputFile(this);
});

$(document).on("change","#dFileS",function(){
// 	var fileName=e.target.files;
	$("#dFile").val($("#dFileS").val());
	//파일 명 체크
	var ext = $('#dFile').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#errdFile").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#errdFile").addClass("redfont");
		return;
	}else{
		$("#errdFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("hiddenFileType").files[0].name)){
    	$("#errdFile").text('파일명에 특수문자를 제거해주세요.');
		$("#errdFile").addClass("redfont");
		return;
    }else{
    	$("#errdFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("hiddenFileType").files[0].size;
    var maxSize = 5 * 1024 * 1024;//3MB
    if(fileSize > maxSize){
    	$("#errdFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#errdFile").addClass("redfont");
		return;
     }else{
    	$("#errdFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
 		$("#errdFile").removeClass("redfont");
     }
});

$(document).on("change","#dFileS4",function(){
// 	var fileName=e.target.files;
	$("#dFile4").val($("#dFileS4").val());
	//파일 명 체크
	var ext = $('#dFile4').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#errdFile4").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#errdFile4").addClass("redfont");
		return;
	}else{
		$("#errdFile4").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile4").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("hiddenFileType").files[0].name)){
    	$("#errdFile4").text('파일명에 특수문자를 제거해주세요.');
		$("#errdFile4").addClass("redfont");
		return;
    }else{
    	$("#errdFile4").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile4").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("hiddenFileType").files[0].size;
    var maxSize = 5 * 1024 * 1024;//3MB
    if(fileSize > maxSize){
    	$("#errdFile4").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#errdFile4").addClass("redfont");
		return;
     }else{
    	$("#errdFile4").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
 		$("#errdFile4").removeClass("redfont");
     }
});

$(document).on("change","#dFileS5",function(){
// 	var fileName=e.target.files;
	$("#dFile5").val($("#dFileS5").val());
	//파일 명 체크
	var ext = $('#dFile5').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#errdFile5").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#errdFile5").addClass("redfont");
		return;
	}else{
		$("#errdFile5").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile5").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("hiddenFileType").files[0].name)){
    	$("#errdFile5").text('파일명에 특수문자를 제거해주세요.');
		$("#errdFile5").addClass("redfont");
		return;
    }else{
    	$("#errdFile5").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile5").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("hiddenFileType").files[0].size;
    var maxSize = 5 * 1024 * 1024;//3MB
    if(fileSize > maxSize){
    	$("#errdFile5").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#errdFile5").addClass("redfont");
		return;
     }else{
    	$("#errdFile5").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
 		$("#errdFile5").removeClass("redfont");
     }
});

function search(type){
	var pageSize = $("#pageSize").val();
	var pageNo;
	var dName = $("#search").val();

	if(type=="button" && dName==""){
		alert("검색어를 입력해주세요.");
		$("#search").focus();
		return false;
	}

	if(type == "button"){//버튼 검색 
		pageNo = "1";
	}else if(type == "list") {//목록 버튼
		//pageNo = $("#pageNo").text();
		pageNo = "1";
		$("#data_detail").hide();
	}else if(type == "paging"){//페이징 검색
		pageNo = $(".pageNo.active").attr("data-page");
	}
	$("#data_list").show();
	if(parseInt(pageNo) < 1) pageNo = 1;
	$.ajax({
		url : "/user/driver/search-driver",
		type : "get",
		data : {
				"pageSize":pageSize,
				"pageNo"  :pageNo,
				"dName":dName
		},
		success : function(resdata){
			drawingTable(resdata.rows);
			drawingPage(resdata.paging);
			$("#resultCnt").html(numberWithCommas(resdata.paging.totalCount));
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
$(document).on("click","#goRegButton",function(){
	$("#data_list").hide();
	$("#data_area").show();
	
})

$(document).on("click",'#addDriverBtn' ,function(){
	if($("#dLicense2").hasClass("active")&&$("#dLicense3").hasClass("active")){
		alert("운전면허증 사본은 총 3개까지 등록가능합니다.");
	}else if($("#dLicense2").hasClass("active")&&!$("#dLicense3").hasClass("active")){
		$("#dLicense3").show();
		$("#dLicense3").addClass("active");
	}else if(!$("#dLicense2").hasClass("active")&&!$("#dLicense3").hasClass("active")){
		$("#dLicense2").show();
		$("#dLicense2").addClass("active");
	}
	return false;
});

$(document).on("click",'.btn_delete' ,function(){
	if($("#dLicense2").hasClass("active")&&$("#dLicense3").hasClass("active")){
		$("#dLicense3").hide();
		$("#dLicense3").removeClass("active");
	}else if($("#dLicense2").hasClass("active")&&!$("#dLicense3").hasClass("active")){
		$("#dLicense2").hide();
		$("#dLicense2").removeClass("active");
	}
	return false;
});

function pageMove(str){
	if(str=='tab1'){
		location.href = '/user/modify';
	}else if(str == 'tab2'){
		location.href = '/user/modifyPwd';
	}else if(str == 'tab3'){
		location.href = '/user/driver';
	}
}
</script>

<!-- container -->
<div id="container">
    <!-- visual -->
    <div class="visual_sub mypage"></div>
    <!-- //visual -->
<!-- content -->
<div class="content">
    <!-- breadcrumb -->
    <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>마이페이지</span><span>회원정보</span></div>
    <!-- //breadcrumb -->
    <!-- title -->
    <h2 class="title">회원정보</h2>
    <!-- //title -->
    <!-- tab -->
    <div class="wrap_tab w1200">
        <div class="tab">
            <button class="tablinks" onclick="pageMove('tab1')" id="defaultOpen">회원정보 변경</button>
            <button class="tablinks" onclick="pageMove('tab2')">비밀번호 변경</button>
            <button class="tablinks active" onclick="pageMove('tab3')">운전자 정보 관리</button>
        </div>
        <div class="wrap_tabcontent">
        
        
         <h3 class="stitle m-t-20">운전자 정보 관리
		 </h3>
		 <div class="tbl_wrap_view m-t-15">
			<table class="tbl_view01" id="data_table" summary="테이블입니다.">
			<caption>테이블입니다.</caption>
			<colgroup>
			    <col width="180px;" />
			    <col width="420px" />
			    <col width="180px;" />
			    <col width="420px" />
			</colgroup>
			<tr>
				<th scope="row">이름<br />(관리번호)</th>
				<td>
					${driver.DName}<br />(<span class="seq">${driver.DSeq}</span>)
				</td>					
				<th scope="row">생년월일</th>
				<td>
					<c:set var='dbirth' value='${driver.DBirth}' />
					${fn:substring(dbirth,0,4)}-${fn:substring(dbirth,4,6)}-${fn:substring(dbirth,6,8)}
				</td>
			</tr>
			<tr>
				<th>이메일 주소</th>
				<td>${driver.DEmail}</td>
				<th scope="row">휴대폰 번호/<br />전화번호</th>
				<td>
					<c:set var='dphone' value='${driver.DPhone}' />
					<c:set var='dphone2' value='${driver.DPhone2}' />
					<c:if test='${dphone2 ne "" }'>
						${fn:substring(dphone,0,3)}-${fn:substring(dphone,3,7)}-${fn:substring(dphone,7,11)} /<br />
						<c:if test='${fn:substring(dphone2,0,2) =="02" }'>
							<c:if test='${fn:length(dphone2)==10 }'>
								${fn:substring(dphone2,0,2) }-${fn:substring(dphone2,2,6) }-${fn:substring(dphone2,6,10) }
							</c:if>
							<c:if test='${fn:length(dphone2)!=10 }'>
								${fn:substring(dphone2,0,2) }-${fn:substring(dphone2,2,5) }-${fn:substring(dphone2,5,10) }
							</c:if>
						</c:if>
						<c:if test='${fn:substring(dphone2,0,3) =="010" }'>
							${fn:substring(dphone2,0,3) }-${fn:substring(dphone2,3,7) }-${fn:substring(dphone2,7,11) }
						</c:if>
						<c:if test='${fn:substring(dphone2,0,2) !="02" && fn:substring(dphone2,0,3) !="010" }'>
							<c:if test='${fn:length(dphone2)==10 }'>
								${fn:substring(dphone2,0,2) }-${fn:substring(dphone2,2,6) }-${fn:substring(dphone2,6,10) }
							</c:if>
							<c:if test='${fn:length(dphone2)==11 }'>
								${fn:substring(dphone2,0,3) }-${fn:substring(dphone2,3,7) }-${fn:substring(dphone2,7,11) }
							</c:if>
							<c:if test='${fn:length(dphone2)==12 }'>
								${fn:substring(dphone2,0,4) }-${fn:substring(dphone2,4,8) }-${fn:substring(dphone2,8,12) }
							</c:if>
						</c:if>
					</c:if>
					
			</td>
			<tr>
				<th scope="row">운전면허종류</th>
				<td>
					<c:set var='dLicenseType' value='${driver.DLicenseType }' />
			        <c:choose>
			        	<c:when test='${dLicenseType.split(",")[0] == "LT10"}'>제1종 대형면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[0] == "LT11"}'>제1종 보통면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[0] == "LT12"}'>제1종 소형면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[0] == "LT13"}'>제1종 특수면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[0] == "LT21"}'>제2종 보통면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[0] == "LT22"}'>제2종 소형면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[0] == "LT23"}'>제2종 원동기장치자전거면허</c:when>
			        </c:choose>
			        <c:choose>
			        	<c:when test='${dLicenseType.split(",")[1] == "LT10"}'><br />제1종 대형면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[1] == "LT11"}'><br />제1종 보통면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[1] == "LT12"}'><br />제1종 소형면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[1] == "LT13"}'><br />제1종 특수면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[1] == "LT21"}'><br />제2종 보통면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[1] == "LT22"}'><br />제2종 소형면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[1] == "LT23"}'><br />제2종 원동기장치자전거면허</c:when>
			        </c:choose>
			        <c:choose>
			        	<c:when test='${dLicenseType.split(",")[2] == "LT10"}'><br />제1종 대형면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[2] == "LT11"}'><br />제1종 보통면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[2] == "LT12"}'><br />제1종 소형면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[2] == "LT13"}'><br />제1종 특수면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[2] == "LT21"}'><br />제2종 보통면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[2] == "LT22"}'><br />제2종 소형면허</c:when>
			        	<c:when test='${dLicenseType.split(",")[2] == "LT23"}'><br />제2종 원동기장치자전거면허</c:when>
			        </c:choose>
				</td>
				<th scope="row">운전기간</th>
				<td>${driver.DHistory}</td>
			</tr>
		    <tr>
		        <th scope="row">혈액형</th>
		        <td colspan="3">${driver.DBloodType }형
		        <c:set var='dbloodSpecial' value='${driver.DBloodSpecial }' />
				
				<c:if test='${dbloodSpecial != "" }'>&nbsp;/&nbsp;${dbloodSpecial }</c:if>
				</td>
		    </tr>
			
		    <c:set var='infoArr' value='${driver.upfiles }' />					
			<c:choose>
				<c:when test="${fn:length(infoArr) gt 3}">
					<tr>
		    		    <th scope="row">운전면허증</th>
		        		<td>
		        			<a href="/user/driver/fileupload/download/${infoArr[0].FSeq }">${infoArr[0].FName }</a><br />
		        			<a href="/user/driver/fileupload/download/${infoArr[1].FSeq }">${infoArr[1].FName }</a><br />
		        			<a href="/user/driver/fileupload/download/${infoArr[2].FSeq }">${infoArr[2].FName }</a>
		        		</td>
		       		<th scope="row">동의서 제출여부</th>
		        		<td><a href="/user/driver/fileupload/download/${infoArr[3].FSeq }">${infoArr[3].FName }</a></td>
		    		</tr>
				</c:when>
				<c:when test="${fn:length(infoArr) gt 2}">
					<tr>
		    		    <th scope="row">운전면허증</th>
		        		<td>
		        			<a href="/user/driver/fileupload/download/${infoArr[0].FSeq }">${infoArr[0].FName }</a><br />
		        			<a href="/user/driver/fileupload/download/${infoArr[1].FSeq }">${infoArr[1].FName }</a>
		        		</td>
		       		<th scope="row">동의서 제출여부</th>
		        		<td><a href="/user/driver/fileupload/download/${infoArr[2].FSeq }">${infoArr[2].FName }</a></td>
		    		</tr>
				</c:when>
				<c:otherwise>
		    		<tr>
		    		    <th scope="row">운전면허증</th>
		        		<td><a href="/user/driver/fileupload/download/${infoArr[0].FSeq }">${infoArr[0].FName }</a></td>
		       		<th scope="row">동의서 제출여부</th>
		        		<td><a href="/user/driver/fileupload/download/${infoArr[1].FSeq }">${infoArr[1].FName }</a></td>
		    		</tr>
				</c:otherwise>
			
			</c:choose>
		</table>
	</div>
	<section class="tac m-t-50">
	   <button type="button" id="listBtn" class="btn btn_gray m-r-11">목록</button>
	</section>
		<div class="ly_group">
	        <article class="layer_Alert cancel">
	            <!-- # 타이틀 # -->
	            <!-- <h1></h1> -->
	            <!-- # 컨텐츠 # -->
	            <div class="ly_con">
	                취소하시면 처음부터 다시 진행해야 됩니다.<br />진행 하시겠습니까?
	            </div>
	            <!-- 버튼 -->
	            <div class="wrap_btn01">
	                <button type="button" class="btn-pop btn_gray m-r-11 lyClose">취소</button>
	                <button type="button" id="cancelBtn" class="btn-pop btn_default lyClose">확인</button>
	            </div>
	            <!-- # 닫기버튼 # -->
	            <button data-fn="lyClose">레이어닫기</button>
	        </article>
	    </div>
	    <!-- //popup_Alert -->
	
	    <!-- popup_Alert -->
	    <div class="ly_group">
	        <article class="layer_Alert completion">
	            <!-- # 타이틀 # -->
	            <!-- <h1></h1> -->
	            <!-- # 컨텐츠 # -->
	            <div class="ly_con">
	                변경이 완료되었습니다.
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
	    <!-- //popup_Alert -->
	
	    <!-- popup_Alert -->
	    <div class="ly_group">
	        <article class="layer_Alert cancel_info">
	            <!-- # 타이틀 # -->
	            <!-- <h1></h1> -->
	            <!-- # 컨텐츠 # -->
	            <div class="ly_con">
	                취소 시 해당 정보는 삭제됩니다.<br />등록을 취소하시겠습니까?
	            </div>
	            <!-- 버튼 -->
	            <div class="wrap_btn01">
	                <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button>
	                <button type="button" id="delBtn" class="btn-pop btn_default lyClose">확인</button>
	            </div>
	            <!-- # 닫기버튼 # -->
	            <button data-fn="lyClose">레이어닫기</button>
	        </article>
	    </div>
	    <!-- //popup_Alert -->
	
	    <!-- popup_m -->
	    <div class="ly_group">
	        <article class="layer_m viewReason">
	            <!-- # 타이틀 # -->
	            <h1>심사결과 안내</h1>
	            <!-- # 컨텐츠 # -->
	            <div class="ly_con">
	                <div class="info_text02">
	                    <p>신청하신 정보에 대해 담당자 검토 결과<br />예약 승인이 거절되었습니다.</p>
	                    <p>[반려사유]<br /><span id="rsnArea"></span></p>
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
	
	    <!-- 아코디언 -->
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
		<span id="pageNo"></span>
	
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>