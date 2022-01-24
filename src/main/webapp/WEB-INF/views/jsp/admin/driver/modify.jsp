<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp"%>
<sec:csrfMetaTags />
<script type="text/javascript">
$(document).ready(function(){	
	//날짜형식(YYYY-MM-DD) 체크
	var datatimeRegexp = RegExp(/^(19|20)\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$/);
	var emailCheck = RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i); 
	var phoneCheck= RegExp(/^01(?:0|1|[6-9])(?:\d{3}|\d{4})\d{4}$/);
	var telCheck= RegExp(/^[0-9]{9,12}/);
	
	//등록/수정버튼 이벤트
	$("#btn_regi").click(function(){ 
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
		
		if($(this).hasClass("upd")){

			var didx = $("#dLicenseType1 option").index( $("#dLicenseType1 option:selected") );
			if(($("#dFile1").val()=="" && didx != 0)||($("#dFile1").val()!="" && didx == 0)){
				$("#errdFile1").text("운전면허증을 등록해 주시고 해당 운전면허증을 선택해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
				$("#dFile1").focus();
				return false;
			}
			
			if($('#dFile2')){
				var didx = $("#dLicenseType2 option").index( $("#dLicenseType2 option:selected") );
				if(($("#dFile2").val()=="" && didx != 0)||($("#dFile2").val()!="" && didx == 0)){
					$("#errdFile2").text("운전면허증을 등록해 주시고 해당 운전면허증을 선택해 주세요.")
					.addClass("redfont")
					.addClass("info_ment");
					$("#dFile2").focus();
					return false;
				}
			}
			if($('#dFile3')){
				var didx = $("#dLicenseType3 option").index( $("#dLicenseType3 option:selected") );
				if(($("#dFile3").val()=="" && didx != 0)||($("#dFile3").val()!="" && didx == 0)){
					$("#errdFile3").text("운전면허증을 등록해 주시고 해당 운전면허증을 선택해 주세요.")
					.addClass("redfont")
					.addClass("info_ment");
					$("#dFile3").focus();
					return false;
				}
			}
			if($("#dFileA").val() == ""){
				$("#errdFileA").text("동의서를 등록해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
				$("#dFileA").focus();
				return false;
			}
			if($("#dFileE").val() == ""){
				$("#errdFileE").text("재직증명서를 등록해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
				$("#dFileE").focus();
				return false;
			}
			
			if(!$(':radio[name=dBloodType]:checked').val()) {   
				$("#errdBloodType").text("혈액형을 선택해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
				$("#dBloodType").focus();
			   return false;
			}
			
			var LType = undefinedChk($("#dLicenseType1").val(),"") + "," + undefinedChk($("#dLicenseType2").val(),"") + "," + undefinedChk($("#dLicenseType3").val(),"");
					
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
			
	  		$.ajax({
	 			url : "/admin/driver/update-driver",
				type: "POST",
	   	   		enctype: "multipart/form-data",
	            processData : false,
	            contentType : false,
				data : formData,
	 			success : function(resdata){
	 				if(resdata.code != 200){
	 					alert(resdata.message);
	 				}else{
	 					alert(resdata.message);
	 					$(document).on("click",'.lyClose' ,function(){
		 					history.back();
	 					});
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
	
	$(":checkbox[id=fileDelete2]").click(function(){
		$("#dLicenseType2 option:eq(0)").prop("selected", true);
		$("#dFile2").val("");
		$("#dFileS2").val("");
	});
	
	$(":checkbox[id=fileDelete3]").click(function(){
		$("#dLicenseType3 option:eq(0)").prop("selected", true);
		$("#dFile3").val("");
		$("#dFileS3").val("");
	});
	
	$(":radio[name=dBloodType]").click(function(){
		$("#errdBloodType").text("")
		.removeClass("redfont")
		.removeClass("info_ment");
	});

	$(document).on("change",'#dFileS1, #dLicenseType1' ,function(){
		if($("#dLicenseType1").val() != ""){
			$("#errdFile1").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)")
			.removeClass("redfont");
		}else{
			$("#errdFile1").text("운전면허증을 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
		}
	});

	$(document).on("change",'#dFileS2, #dLicenseType2' ,function(){
		if($("#dLicenseType2").val() != ""){
			$("#errdFile2").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)")
			.removeClass("redfont");
		}else{
			$("#errdFile2").text("운전면허증을 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
		}
	});

	$(document).on("change",'#dFileS3, #dLicenseType3' ,function(){
		if($("#dLicenseType3").val() != ""){
			$("#errdFile3").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)")
			.removeClass("redfont");
		}else{
			$("#errdFile3").text("운전면허증을 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
		}
	});
	
	$("#dFileAS").change(function(){
		if($("#dFileAS").val() != "") {
			$("#errdFileA").text("")
			.removeClass("redfont")
			.removeClass("info_ment");	
		}else {
			$("#errdFileA").text("동의서를 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
		}
	});
	
	$("#dFileES").change(function(){
		if($("#dFileES").val() != "") {
			$("#errdFileE").text("")
			.removeClass("redfont")
			.removeClass("info_ment");	
		}else {
			$("#errdFileE").text("재직증명서를 등록해 주세요.")
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
});	

$(document).on("click",'#canBtn' ,function(){
	dSeq = $("#dSeq").val();
	var pageNo = $("#pageNo").text();
	var form = $("<form></form>");
	form.attr("action","/admin/driver/detail-driver");
	form.attr("method","post");
	form.appendTo("body");
	form.append('<input type="hidden" value='+dSeq+' name="dSeq" />');
	form.append('<input type="hidden" value='+pageNo+' name="pageNo" />');
	var inputToken = $('<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />');
	form.append(inputToken);
	form.submit();
});

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

$(document).on("click",'#btn_delete2' ,function(){
	if($("#dLicense3").hasClass("active")){		//2,3 활성화된 경우 3삭제
		alert("세번째 운전면허증 란을 우선 삭제해 주세요.");
	}else{
		$("#dLicense2").hide();
		$("#dFile2").val("");
		$("#dFileS2").val("");
		$("#dLicenseType2 option:eq(0)").prop("selected", true);
		$("#dLicense2").removeClass("active");
	}
});

$(document).on("click",'#btn_delete3' ,function(){		
	$("#dLicense3").hide();
	$("#dFile3").val("");
	$("#dFileS3").val("");
	$("#dLicenseType3 option:eq(0)").prop("selected", true);
	$("#dLicense3").removeClass("active");
});

$(document).on("click",'#regDfile1' ,function(){
	$("#dFileS1").click();	
});

$(document).on("click",'#regDfile2' ,function(){
	$("#dFileS2").click();	
});

$(document).on("click",'#regDfile3' ,function(){
	$("#dFileS3").click();	
});

$(document).on("click",'#regAfile' ,function(){
	$("#dFileAS").click();	
});

$(document).on("click",'#regEfile' ,function(){
	$("#dFileES").click();	
});

$(document).on("change","#dFileS1",function(){
// 	var fileName=e.target.files;
	$("#dFile1").val($("#dFileS1").val());
	//파일 명 체크
	var ext = $('#dFile1').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#errdFile1").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#errdFile1").addClass("info_ment").addClass("redfont");
		$('#dFileS1').val("");
		$('#dFile1').val("");
		return;
	}else{
		$("#errdFile1").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile1").addClass("info_ment").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("dFileS1").files[0].name)){
    	$("#errdFile1").text('파일명에 특수문자를 제거해주세요.');
		$("#errdFile1").addClass("info_ment").addClass("redfont");
		$('#dFileS1').val("");
		$('#dFile1').val("");
		return;
    }else{
    	$("#errdFile1").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile1").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("dFileS1").files[0].size;
    var maxSize = 5 * 1024 * 1024;//5MB
    if(fileSize > maxSize){
    	$("#errdFile1").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#errdFile1").addClass("info_ment").addClass("redfont");
		$('#dFileS1').val("");
		$('#dFile1').val("");
		return;
     }else{
    	$("#errdFile1").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
 		$("#errdFile1").removeClass("redfont");
     }
});

$(document).on("change","#dFileS2",function(){
// 	var fileName=e.target.files;
	$("#dFile2").val($("#dFileS2").val());
	//파일 명 체크
	var ext = $('#dFile2').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#errdFile2").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#errdFile2").addClass("info_ment").addClass("redfont");
		$('#dFileS2').val("");
		$('#dFile2').val("");
		return;
	}else{
		$("#errdFile2").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile2").addClass("info_ment").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("dFileS2").files[0].name)){
    	$("#errdFile2").text('파일명에 특수문자를 제거해주세요.');
		$("#errdFile2").addClass("info_ment").addClass("redfont");
		$('#dFileS2').val("");
		$('#dFile2').val("");
		return;
    }else{
    	$("#errdFile2").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile2").addClass("info_ment").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("dFileS2").files[0].size;
    var maxSize = 5 * 1024 * 1024;//5MB
    if(fileSize > maxSize){
    	$("#errdFile2").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#errdFile2").addClass("info_ment").addClass("redfont");
		$('#dFileS2').val("");
		$('#dFile2').val("");
		return;
     }else{
    	$("#errdFile2").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
 		$("#errdFile2").addClass("info_ment").removeClass("redfont");
     }
});

$(document).on("change","#dFileS3",function(){
// 	var fileName=e.target.files;
	$("#dFile3").val($("#dFileS3").val());
	//파일 명 체크
	var ext = $('#dFile3').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#errdFile3").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#errdFile3").addClass("info_ment").addClass("redfont");
		$('#dFileS3').val("");
		$('#dFile3').val("");
		return;
	}else{
		$("#errdFile3").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile3").addClass("info_ment").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("dFileS3").files[0].name)){
    	$("#errdFile3").text('파일명에 특수문자를 제거해주세요.');
		$("#errdFile3").addClass("info_ment").addClass("redfont");
		$('#dFileS3').val("");
		$('#dFile3').val("");
		return;
    }else{
    	$("#errdFile3").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile3").addClass("info_ment").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("dFileS3").files[0].size;
    var maxSize = 5 * 1024 * 1024;//5MB
    if(fileSize > maxSize){
    	$("#errdFile3").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#errdFile3").addClass("info_ment").addClass("redfont");
		$('#dFileS3').val("");
		$('#dFile3').val("");
		return;
     }else{
    	$("#errdFile3").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
 		$("#errdFile3").addClass("info_ment").removeClass("redfont");
     }
});

$(document).on("change","#dFileAS",function(){
// 	var fileName=e.target.files;
	$("#dFileA").val($("#dFileAS").val());
	//파일 명 체크
	var ext = $('#dFileA').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#errdFileA").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#errdFileA").addClass("info_ment").addClass("redfont");
		$('#dFileAS').val("");
		$('#dFileA').val("");
		return;
	}else{
		$("#errdFileA").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFileA").addClass("info_ment").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("dFileAS").files[0].name)){
    	$("#errdFileA").text('파일명에 특수문자를 제거해주세요.');
		$("#errdFileA").addClass("info_ment").addClass("redfont");
		$('#dFileAS').val("");
		$('#dFileA').val("");
		return;
    }else{
    	$("#errdFileA").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFileA").addClass("info_ment").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("dFileAS").files[0].size;
    var maxSize = 5 * 1024 * 1024;//5MB
    if(fileSize > maxSize){
    	$("#errdFileA").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#errdFileA").addClass("info_ment").addClass("redfont");
		$('#dFileAS').val("");
		$('#dFileA').val("");
		return;
     }else{
    	$("#errdFileA").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
 		$("#errdFileA").addClass("info_ment").removeClass("redfont");
     }
});

$(document).on("change","#dFileES",function(){
// 	var fileName=e.target.files;
	$("#dFileE").val($("#dFileES").val());
	//파일 명 체크
	var ext = $('#dFileE').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#errdFileE").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#errdFileE").addClass("info_ment").addClass("redfont");
		$('#dFileES').val("");
		$('#dFileE').val("");
		return;
	}else{
		$("#errdFileE").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFileE").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("dFileES").files[0].name)){
    	$("#errdFileE").text('파일명에 특수문자를 제거해주세요.');
		$("#errdFileE").addClass("info_ment").addClass("redfont");
		$('#dFileES').val("");
		$('#dFileE').val("");
		return;
    }else{
    	$("#errdFileE").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFileE").addClass("info_ment").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("dFileES").files[0].size;
    var maxSize = 5 * 1024 * 1024;//5MB
    if(fileSize > maxSize){
    	$("#errdFileE").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#errdFileE").addClass("info_ment").addClass("redfont");
		$('#dFileES').val("");
		$('#dFileE').val("");
		return;
     }else{
    	$("#errdFileE").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
 		$("#errdFileE").addClass("info_ment").removeClass("redfont");
     }
});

//조회값 undefined -> 공백 처리
function undefinedChk(str1,str2){
	if( str1 == "" || str1 == null || typeof str1 == undefined || str1 == undefined || ( str1 != null && typeof str1 == "object" && !Object.keys(str1).length ) ){
		return str2;
	}else{
		return str1;
	}
}

function succ(resdata){
	alert(resdata);
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
</script>
<!-- container -->
<div id="container">
	<!-- content -->
	<div class="content">
		<!-- breadcrumb -->
		<div class="breadcrumb">
			<span class="breadcrumb_icon"></span><span>회원사/자원관리</span><span>회원사
				관리</span><span>운전자 관리</span>
		</div>
		<!-- //breadcrumb -->
		<!-- title -->
		<h2 class="title">운전자 관리</h2>
		<!-- //title -->

		<!-- tab -->
		<div class="wrap_tab">
			<div class="tab">
				<button id="btn1" class="tablinks<c:if test='${driver.DApproval=="N"}'> active</c:if>" onclick="location.href='/admin/driver?reqcon=N'">운전자 신청내역</button>
				<button id="btn2" class="tablinks<c:if test='${driver.DApproval=="Y"}'> active</c:if>" onclick="location.href='/admin/driver?reqcon=Y'">운전자 승인내역</button>
			</div>
			<div class="wrap_tabcontent">
				<!-- tab1-운전자 신청내역 -->
				<div id="tab1" class="tabcontent">
					<!-- table_view -->
					<form name="form" id="form" method="post" action="/driver/fileupload/insert-driver" enctype="multipart/form-data">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /> <input type="hidden" id="dSeq" name="dSeq" value="${driver.DSeq }" />
					<div id="data_area" class="tbl_wrap_view m-t-15">
						<table class="tbl_view01"
							summary="운전자 등록테이블입니다. 항목으로는 운전자 이름, 생년월일, 이메일 주소, 휴대폰 번호 회사 전화번호 운전면허 종류, 운전경력 기간, 운전면허증 사본, 혈액형, 동의서 업로드등이 있습니다.">
							<caption>운전자 등록테이블입니다.</caption>
							<colgroup>
								<col width="180px;" />
								<col width="" />
							</colgroup>
							<tr>
								<th scope="row">운전자 이름<span class="required"></span></th>
								<td colspan="3">
									<div class="form_group w300">
										<input type="text" id="dName" name="dName"
											class="form_control" placeholder="운전자 이름 입력" value="${driver.DName }"
											maxlength="33" />
									</div> <span id="errdName"></span>
								</td>
							</tr>
							<tr>
								<th scope="row">생년월일<span class="required"></span></th>
								<td colspan="3">
									<div class="form_group w300">
										<input type="text" id="dBirth" name="dBirth"
											class="form_control" placeholder="생년월일 입력(yyyymmdd)"
											maxlength="8" onkeypress="numberonly();" value="${driver.DBirth }" />
									</div> <span id="errdBirth"></span>
								</td>
							</tr>
							<tr>
								<th scope="row">이메일 주소<span class="required"></span></th>
								<td colspan="3">
									<div class="form_group w300">
										<input type="text" id="dEmail" name="dEmail"
											class="form_control" placeholder="이메일 주소 입력" value="${driver.DEmail }"
											maxlength="90" />
									</div> <span id="errdEmail"></span>
								</td>
							</tr>
							<tr>
								<th scope="row">휴대폰 번호<span class="required"></span></th>
								<td colspan="3">
									<div class="form_group w300">
										<input type="text" id="dPhone" name="dPhone"
											class="form_control" placeholder="휴대폰 번호 입력" maxlength="11"
											onkeypress="numberonly();" value="${driver.DPhone }" />
									</div> <span id="errdPhone" class="info_ment">‘-’ 없이 입력하세요.</span>
								</td>
							</tr>
							<tr>
								<th scope="row">회사 전화번호<span class="required"></span></th>
								<td colspan="3">
									<div class="form_group w300">
										<input type="text" name="dPhone2" id="dPhone2"
											class="form_control" placeholder="회사 전화번호" maxlength="12"
											onkeypress="numberonly();" value="${driver.DPhone2 }" />
									</div> <span id="errdPhone2" class="info_ment">‘-’ 없이 입력하세요.</span>
								</td>
							</tr>
							<tr>
								<th scope="row">운전경력 기간<span class="required"></span></th>
								<td colspan="3">
									<div class="form_group">
										<div class="check_inline">
											<label class="check_default"> <input type="checkbox"
												name="dEduChk" id="dEduChk" value="Y" checked="checked" /> <span
												class="check_icon"></span>5년 이상
											</label>
										</div>
									</div>
									<div class="form_group w80">
										<input type="text" id="dHistory" name="dHistory"
											class="form_control" placeholder="숫자 입력" maxlength="2"
											onkeypress="numberonly();" value="${driver.DHistory }" />
									</div> 년 <span id="errdHistory" class="info_ment">운전경력은 5년이상인
										자만 등록 가능합니다. 5년 이상인 경우 5년 이상에 체크해 주시고 운전 경력을 입력해 주시기 바랍니다.</span>
								</td>
							</tr>
							<c:set var="driverI" value="1" />
	                    	<input type="hidden" id="dLicenseType" name="dLicenseType">
		        			<c:forEach var="result" items="${driver.upfiles }" varStatus="status">
		        				<c:if test='${result.FType eq "d" }'>
								<tr id="dLicense${driverI }" class="active">
									<th scope="row">운전면허증 사본${driverI }<span class="required"></span></th>
									<td colspan="3">
										<input type="hidden" id="fSeq${driverI }" name="fSeq${driverI }" value="${result.FSeq }" />
										<c:set var='dLicenseType' value='${fn:split(driver.DLicenseType,",") }' />
										<div class="w670 disib vat01">
											<c:if test="${driverI eq 1 }">
											<span class="info_ment_orange m-l-0">주민등록번호 뒷자리 7자리,
												운전면허 번호, 사진의 경우의 음영처리(masking)하여 제출 바랍니다. <br />첨부파일은 육안으로
												식별 가능해야 하며, 서류 검토 후 문제가 있을 경우 서비스 이용에 제한을 받을 수 있습니다.
											</span>
											</c:if>
											<div class="m-t-10 m-b-10">
												<div class="form_group w218">
													<input type="text" id="dFile${driverI }" class="form_control"
														placeholder="파일첨부" maxlength="80" value="${result.FName }"
														readonly="readonly" />
													<input type="file" id="dFileS${driverI }" name="dFile"
														onchange="javascript:document.getElementById('dFile${driverI }').value=this.value"
														style="display: none" />
												</div>
												<button type="button" id="regDfile${driverI }"
													class="btn-line btn_gray btnFile">파일첨부</button>
												<div class="form_group w300">
					                                <div class="select_group">
					                                    <select id="dLicenseType${driverI }" name="dLicenseType${driverI }" title="select" class="form_control">
					                                        <option value="">선택하세요</option>
					                                        <option value="LT10"<c:if test='${dLicenseType[driverI-1] eq "LT10"}'> selected="selected"</c:if>>제1종 대형면허</option>
															<option value="LT11"<c:if test='${dLicenseType[driverI-1] eq "LT11"}'> selected="selected"</c:if>>제1종 보통면허</option>
															<option value="LT12"<c:if test='${dLicenseType[driverI-1] eq "LT12"}'> selected="selected"</c:if>>제1종 소형면허</option>
															<option value="LT13"<c:if test='${dLicenseType[driverI-1] eq "LT13"}'> selected="selected"</c:if>>제1종 특수면허</option>
															<option value="LT21"<c:if test='${dLicenseType[driverI-1] eq "LT21"}'> selected="selected"</c:if>>제2종 보통면허</option>
															<option value="LT22"<c:if test='${dLicenseType[driverI-1] eq "LT22"}'> selected="selected"</c:if>>제2종 소형면허</option>
															<option value="LT23"<c:if test='${dLicenseType[driverI-1] eq "LT23"}'> selected="selected"</c:if>>제2종 원동기장치자전거면허</option>
					                                    </select>
					                                </div>
					                            </div>										
											</div>
											<span id="errdFile${driverI }" class="info_ment m-l-0">5MB 이내의
												허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif,
												pdf만 가능)
											</span>
											<c:if test="${driverI gt 1 }">
												<br /><div class="form_group" style="padding-top:10px">
													<div class="check_inline">
														<label class="check_default"> <input type="checkbox"
															name="fileDelete${driverI }" id="fileDelete${driverI }" value="${result.FSeq }" /> <span
															class="check_icon"></span><p class="redfont">기존 등록된 운전면허증 삭제</p>
														</label>
													</div>
												</div>
											</c:if>
										</div>
										<c:if test="${driverI eq 1 }">
										<div class="disib vat01">
											<img src="/inc/images/img_licence_sample.png" alt="운전면허증 사본 제출 예시" />
										</div>
			                            <div class="wrap_btn_testcar01" style="float:right;">
			                                <button type="button" id="addDriverBtn" class="btn-line btn_gray">운전 면허증 사본 +</button>
			                            </div>
			                            </c:if>
									</td>
								</tr>
		        				<c:set var="driverI" value="${driverI+1 }" />
		        				</c:if>
		        				<c:if test='${result.FType eq "a" }'>
		        					<c:set var='agreeFseq' value='${result.FSeq }' />
		        					<c:set var='agreeFName' value='${result.FName }' />
		        				</c:if>
		        				<c:if test='${result.FType eq "e" }'>
		        					<c:set var='employFseq' value='${result.FSeq }' />
		        					<c:set var='employFName' value='${result.FName }' />
		        				</c:if>
		        			</c:forEach>
		        			
		        			<c:forEach var="driverI" begin="${driverI }" end="3" step="1" varStatus="status">
		        				<tr id="dLicense${driverI }" style="display:none">
									<th scope="row">운전면허증 사본${driverI }<span class="required"></span></th>
									<td colspan="3">
										<c:set var='dLicenseType' value='${fn:split(driver.DLicenseType,",") }' />
										<div class="w670 disib vat01">
											<c:if test="${status.index eq 0 }">
											<span class="info_ment_orange m-l-0">주민등록번호 뒷자리 7자리,
												운전면허 번호, 사진의 경우의 음영처리(masking)하여 제출 바랍니다. <br />첨부파일은 육안으로
												식별 가능해야 하며, 서류 검토 후 문제가 있을 경우 서비스 이용에 제한을 받을 수 있습니다.
											</span>
											</c:if>
											<div class="m-t-10 m-b-10">
												<div class="form_group w218">
													<input type="text" id="dFile${driverI }" class="form_control"
														placeholder="파일첨부" maxlength="80" value="${result.FName }"
														readonly="readonly" />
													<input type="file" id="dFileS${driverI }" name="dFile"
														onchange="javascript:document.getElementById('dFile${driverI }').value=this.value"
														style="display: none" />
												</div>
												<button type="button" id="regDfile${driverI }"
													class="btn-line btn_gray btnFile">파일첨부</button>
												<div class="form_group w300">
					                                <div class="select_group">
					                                    <select id="dLicenseType${driverI }" name="dLicenseType${driverI }" title="select" class="form_control">
					                                        <option value="">선택하세요</option>
					                                        <option value="LT10"<c:if test='${dLicenseType[status.index] eq "LT10"}'> selected="selected"</c:if>>제1종 대형면허</option>
															<option value="LT11"<c:if test='${dLicenseType[status.index] eq "LT11"}'> selected="selected"</c:if>>제1종 보통면허</option>
															<option value="LT12"<c:if test='${dLicenseType[status.index] eq "LT12"}'> selected="selected"</c:if>>제1종 소형면허</option>
															<option value="LT13"<c:if test='${dLicenseType[status.index] eq "LT13"}'> selected="selected"</c:if>>제1종 특수면허</option>
															<option value="LT21"<c:if test='${dLicenseType[status.index] eq "LT21"}'> selected="selected"</c:if>>제2종 보통면허</option>
															<option value="LT22"<c:if test='${dLicenseType[status.index] eq "LT22"}'> selected="selected"</c:if>>제2종 소형면허</option>
															<option value="LT23"<c:if test='${dLicenseType[status.index] eq "LT23"}'> selected="selected"</c:if>>제2종 원동기장치자전거면허</option>
					                                    </select>
					                                </div>
					                            </div>	
					                            <span id="errdFile${driverI }" class="m-l-0"></span>									
											</div>
											<c:if test="${status.index gt 0 }">
												<div class="form_group" style="padding-top:10px">
													<div class="check_inline">
														<label class="check_default"> <input type="checkbox"
															name="fileDelete${driverI }" id="fileDelete${driverI }" value="${result.FSeq }" /> <span
															class="check_icon"></span>운전면허증 삭제
														</label>
													</div>
												</div>
											</c:if>
										</div>
			                            <c:if test="${driverI ne 1 }">
										<button type="button" id="btn_delete${driverI}" class="btn_delete"
												style="content:'';width:20px;height:20px;posion:absolute;left:0;top:0;background:url('/inc/images/admin_icon_set.png') -88px -40px no-repeat;margin-left: 5px"></button>
										</c:if>
									</td>
								</tr>
		        				<c:set var="driverI" value="${driverI+1 }" />
		        			</c:forEach>
							<tr>
								<th scope="row">(${driverI })혈액형<span class="required"></span></th>
								<td colspan="3">
									<div class="form_group">
										<div class="radio_inline">
											<label class="radio_default"> <input type="radio"
												id="dBloodTypeA" name="dBloodType" value="A"<c:if test='${driver.DBloodType =="A" }'> checked="checked"</c:if>/> <span
												class="radio_icon"></span>A형
											</label> <label class="radio_default"> <input type="radio"
												id="dBloodTypeB" name="dBloodType" value="B"<c:if test='${driver.DBloodType =="B" }'> checked="checked"</c:if>/> <span
												class="radio_icon"></span>B형
											</label> <label class="radio_default"> <input type="radio"
												id="dBloodTypeAB" name="dBloodType" value="AB"<c:if test='${driver.DBloodType =="AB" }'> checked="checked"</c:if>/> <span
												class="radio_icon"></span>AB형
											</label> <label class="radio_default"> <input type="radio"
												id="dBloodTypeO" name="dBloodType" value="O"<c:if test='${driver.DBloodType =="O" }'> checked="checked"</c:if>/> <span
												class="radio_icon"></span>O형
											</label>
										</div>
										<div id="errdBloodType" style="padding-top: 10px"></div>
									</div>
									<div class="form_group w280">
										<input type="text" id="dBloodSpecial" name="dBloodSpecial"
											class="form_control"
											placeholder="특이사항 이있는 경우 기재 요망 / 예) RH -" maxlength="15"
											value="" />
									</div> <span class="info_ment_orange">RH – 등의 특이사항이 있는 경우
										특이사항을 기재해 주시기 바랍니다.</span>
								</td>
							</tr>
							<tr>
								<th scope="row">동의서 업로드<span class="required"></span></th>
								<td colspan="3">
									<div class="form_group w300">
										<input type="text" id="dFileA" class="form_control"
											placeholder="파일 첨부" maxlength="80" value="${agreeFName }" readonly="readonly" /> <input
											type="file" id="dFileAS" name="dFile"
											onchange="javascript:document.getElementById('dFileA').value=this.value"
											style="display: none" />
											<input type="hidden" id="fSeqA" name="fSeqA" value="${agreeFseq }" />
									</div>
									<button type="button" id="regAfile"
										class="btn-line btn_gray btnFile">파일첨부</button> <span
									id="errdFileA" class="info_ment">동의서 다운로드 후 자필 서명한 후
										업로드 해 주시기 바랍니다.</span>
								</td>
							</tr>
							<tr>
								<th scope="row">재직증명서 업로드<span class="required"></span></th>
								<td colspan="3">
									<div class="form_group w300">
										<input type="text" id="dFileE" class="form_control"
											placeholder="파일 첨부" maxlength="80" value="${employFName }" readonly="readonly" /> <input
											type="file" id="dFileES" name="dFile"
											onchange="javascript:document.getElementById('dFileE').value=this.value"
											style="display: none" />
											<input type="hidden" id="fSeqE" name="fSeqE" value="${employFseq }" />
									</div>
									<button type="button" id="regEfile"
										class="btn-line btn_gray btnFile">파일첨부</button> <span
									id="errdFileE" class="info_ment">재직증명서는 주민등록번호 뒤 7자리를 음영처리(masking)하여 제출 바랍니다.</span>
								</td>
							</tr>
						</table>
						<!-- button -->
						<section class="tac m-t-50">
							<button type="button" id="cancelBtn" class="btn btn_gray m-r-11"
								data-layer="cancel">취소</button>
							<button type="button" id="btn_regi" class="upd btn btn_default">확인</button>
						</section>
						<!-- //button -->
					</div>
					<!-- //table_view -->
					</form>
				</div>
				<!-- //tab1-운전자 신청내역 -->
			</div>
		</div>
		<!-- //tab -->
	</div>
	<!-- //content -->
</div>

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
                    <textarea name="rtnReason" id="rtnReason" cols="" rows="5" class="form_control" 
                        placeholder="반려/취소 /거절 사유를 등록해 주세요." onKeyUp="fnChkByte(this,'500')" style="resize: none;"></textarea>
                    <div class="count_txt"><span id="byteInfo">0</span> / 500 bytes</div>
                </div>
            </div>
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" id="rtnCancel" class="btn-pop btn_gray lyClose m-r-11">취소</button>
            <button type="button" id="rtnBtn" class="btn-pop btn_default lyClose">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_m -->
   
<span id="pageNo" style="display:none">${driver.pageNo }</span>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp"%>