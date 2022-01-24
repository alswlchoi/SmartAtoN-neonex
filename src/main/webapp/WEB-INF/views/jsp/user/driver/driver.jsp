<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp"%>
<%@taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<sec:csrfMetaTags />
<script type="text/javascript">
$(document).ready(function(){
	$("#data_area").hide();	//페이지 로딩시 등록/수저폼 가림
	
	$("input").on("keyup",function(key){
        if(key.keyCode==13) {
        	$("#regBtn").click();
        }
	});	

	$("#searchBtn").click(function(){
		search("button");
	});
	
	$(document).on("click",'#cancelBtn' ,function(){
		location.href="/user/driver";
	});
	
	$(document).on("click",'#listBtn' ,function(){
		$("#data_area").hide();
		search("list");
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
	
	$(document).on("click",'#regDfile' ,function(){
		$("#dFileS").click();	
	});
	
	$(document).on("click",'#regdFile2' ,function(){
		$("#dFileS2").click();	
	});
	
	$(document).on("click",'#regdFile3' ,function(){
		$("#dFileS3").click();	
	});
	
	$(document).on("click",'#regAfile' ,function(){
		$("#dFile4S").click();	
	});
	
	$(document).on("click",'#regEfile' ,function(){
		$("#dFile5S").click();	
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
	var phoneCheck = /^01(?:0|1|[6-9])(?:\d{3}|\d{4})\d{4}$/;
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
		
		if(didx2 == 0 && $("#dFile2").val() != ""){
			$("#errdLicenseType2").text("운전면허종류을 선택해주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dLicenseType2").focus();
			return false;
		}
		
		if(didx3 == 0 && $("#dFile3").val() != ""){
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

		if($("#dFile2").val() == "" && $("#dLicenseType2").val() != ""){
			$("#errdFile2").text("운전면허증을 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dFile2").focus();
			return false;
		}
		
		if($("#dFile3").val() == "" && $("#dLicenseType3").val() != ""){
			$("#errdFile3").text("운전면허증을 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dFile3").focus();
			return false;
		}
		
		if(!$(':radio[name=dBloodType]:checked').val()) {   
			$("#errdBloodType").text("혈액형을 선택해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dBloodType").focus();
		   return false;
		}
		if($("#dFile4").val() == ""){
			$("#errdFile4").text("동의서를 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dFile4").focus();
			return false;
		}
		if($("#dFile5").val() == ""){
			$("#errdFile5").text("재직증명서를 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dFile5").focus();
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
					if(resdata.code == 200){
						alert(resdata.message);
						$(document).on("click",'.lyClose' ,function(){
							location.href="/user/driver";
						});
					}else{
						console.log("resdata.code : " + resdata.code);
						alert(resdata.message);
					}
				},
				error : function(e){
					console.log(e);
				}
			});
		}else if($(this).hasClass("upd")){
			console.log("upd");
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
		 				//location.reload();
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
		
		if(didx == 0 && $("#dFile2").val() != ""){
			$("#errdLicenseType2").text("운전면허종류을 선택해주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#dLicenseType2").focus();
		}else{
			$("#errdLicenseType2").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
			$("#dLicenseType2").focus();
		}
	});
	
	$("#dLicenseType3").change(function(){		
		var didx = $("#dLicenseType3 option").index( $("#dLicenseType3 option:selected") );
		
		if(didx == 0 && $("#dFile3").val() != ""){
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

	$("#dFileS2").change(function(){
		if($("#dLicenseType2").val() != ""){
			if($("#dFileS2").val() != "") {
				$("#errdFile2").text("")
				.removeClass("redfont")
				.removeClass("info_ment");	
			}else {
				$("#errdFile2").text("운전면허증을 등록해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
			}
		}
		
	});

	$("#dFileS3").change(function(){
		if($("#dLicenseType3").val() != ""){
			if($("#dFileS3").val() != "") {
				$("#errdFile3").text("")
				.removeClass("redfont")
				.removeClass("info_ment");	
			}else {
				$("#errdFile3").text("운전면허증을 등록해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
			}
		}
	});
	
	$("#dFile4S").change(function(){
		if($("#dFile4S").val() != "") {
			$("#errdFile4").text("")
			.removeClass("redfont")
			.removeClass("info_ment");	
		}else {
			$("#errdFile4").text("동의서를 등록해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
		}
	});
	
	$("#dFile5S").change(function(){
		if($("#dFile5S").val() != "") {
			$("#errdFile5").text("")
			.removeClass("redfont")
			.removeClass("info_ment");	
		}else {
			$("#errdFile5").text("재직증명서를 등록해 주세요.")
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
		var dSeq = currentRow.find('td:eq(0) span.seq').text();
		
		if(dSeq != ""){
			var currentRow=$(this).closest('tr');
			var pageSize = $("#pageSize").val();
			var pageNo;
			
			pageNo = $(".pageNo.active").attr("data-page");
			$("#pageNo").html(pageNo);
			
			location.href="/user/driver/detail?dSeq="+dSeq;
		}
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

$(document).on("change","#dFileS",function(){
// 	var fileName=e.target.files;
	$("#dFile").val($("#dFileS").val());
	//파일 명 체크
	var ext = $('#dFile').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#errdFile").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#errdFile").addClass("redfont");
		$('#dFileS').val("");
		$('#dFile').val("");
		return;
	}else{
		$("#errdFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("dFileS").files[0].name)){
    	$("#errdFile").text('파일명에 특수문자를 제거해주세요.');
		$("#errdFile").addClass("redfont");
		$('#dFileS').val("");
		$('#dFile').val("");
		return;
    }else{
    	$("#errdFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("dFileS").files[0].size;
    var maxSize = 5 * 1024 * 1024;//5MB
    if(fileSize > maxSize){
    	$("#errdFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#errdFile").addClass("redfont");
		$('#dFileS').val("");
		$('#dFile').val("");
		return;
     }else{
    	$("#errdFile").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
 		$("#errdFile").removeClass("redfont");
     }
});

$(document).on("change","#dFileS2",function(){
// 	var fileName=e.target.files;
	$("#dFile2").val($("#dFileS2").val());
	//파일 명 체크
	var ext = $('#dFile2').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#errdFile2").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#errdFile2").addClass("redfont");
		$('#dFileS2').val("");
		$('#dFile2').val("");
		return;
	}else{
		$("#errdFile2").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile2").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("dFileS2").files[0].name)){
    	$("#errdFile2").text('파일명에 특수문자를 제거해주세요.');
		$("#errdFile2").addClass("redfont");
		$('#dFileS2').val("");
		$('#dFile2').val("");
		return;
    }else{
    	$("#errdFile2").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile2").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("dFileS2").files[0].size;
    var maxSize = 5 * 1024 * 1024;//5MB
    if(fileSize > maxSize){
    	$("#errdFile2").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#errdFile2").addClass("redfont");
		$('#dFileS2').val("");
		$('#dFile2').val("");
		return;
     }else{
    	$("#errdFile2").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
 		$("#errdFile2").removeClass("redfont");
     }
});

$(document).on("change","#dFileS3",function(){
// 	var fileName=e.target.files;
	$("#dFile3").val($("#dFileS3").val());
	//파일 명 체크
	var ext = $('#dFile3').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#errdFile3").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#errdFile3").addClass("redfont");
		$('#dFileS3').val("");
		$('#dFile3').val("");
		return;
	}else{
		$("#errdFile3").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile3").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("dFileS3").files[0].name)){
    	$("#errdFile3").text('파일명에 특수문자를 제거해주세요.');
		$("#errdFile3").addClass("redfont");
		$('#dFileS3').val("");
		$('#dFile3').val("");
		return;
    }else{
    	$("#errdFile3").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile3").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("dFileS3").files[0].size;
    var maxSize = 5 * 1024 * 1024;//5MB
    if(fileSize > maxSize){
    	$("#errdFile3").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#errdFile3").addClass("redfont");
		$('#dFileS3').val("");
		$('#dFile3').val("");
		return;
     }else{
    	$("#errdFile3").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
 		$("#errdFile3").removeClass("redfont");
     }
});

$(document).on("change","#dFile4S",function(){
// 	var fileName=e.target.files;
	$("#dFile4").val($("#dFile4S").val());
	//파일 명 체크
	var ext = $('#dFile4').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#errdFile4").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#errdFile4").addClass("redfont");
		$('#dFile4S').val("");
		$('#dFile4').val("");
		return;
	}else{
		$("#errdFile4").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile4").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("dFile4S").files[0].name)){
    	$("#errdFile4").text('파일명에 특수문자를 제거해주세요.');
		$("#errdFile4").addClass("redfont");
		$('#dFile4S').val("");
		$('#dFile4').val("");
		return;
    }else{
    	$("#errdFile4").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile4").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("dFile4S").files[0].size;
    var maxSize = 5 * 1024 * 1024;//5MB
    if(fileSize > maxSize){
    	$("#errdFile4").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#errdFile4").addClass("redfont");
		$('#dFile4S').val("");
		$('#dFile4').val("");
		return;
     }else{
    	$("#errdFile4").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
 		$("#errdFile4").removeClass("redfont");
     }
});

$(document).on("change","#dFile5S",function(){
// 	var fileName=e.target.files;
	$("#dFile5").val($("#dFile5S").val());
	//파일 명 체크
	var ext = $('#dFile5').val().split('.').pop().toLowerCase();
	if($.inArray(ext, ['png','jpg','jpeg','GIF','PNG','JPG','JPEG','bmp','tiff','tif','pdf']) == -1) {
		$("#errdFile5").text('jpg,png,jpeg,bmp,tiff,tif,pdf 파일만 업로드 할수 있습니다.');
		$("#errdFile5").addClass("redfont");
		$('#dFile5S').val("");
		$('#dFile5').val("");
		return;
	}else{
		$("#errdFile5").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile5").removeClass("redfont");
	}
	var pattern =   /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if(pattern.test(document.getElementById("dFile5S").files[0].name)){
    	$("#errdFile5").text('파일명에 특수문자를 제거해주세요.');
		$("#errdFile5").addClass("redfont");
		$('#dFile5S').val("");
		$('#dFile5').val("");
		return;
    }else{
    	$("#errdFile5").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif, pdf만 가능)");
		$("#errdFile5").removeClass("redfont");
    }
    //파일 사이즈 체크
    var fileSize = document.getElementById("dFile5S").files[0].size;
    var maxSize = 5 * 1024 * 1024;//5MB
    if(fileSize > maxSize){
    	$("#errdFile5").text("5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.");
		$("#errdFile5").addClass("redfont");
		$('#dFile5S').val("");
		$('#dFile5').val("");
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

$(document).on("click",'#btn_delete2' ,function(){
	if($("#dLicense3").hasClass("active")){		//2,3 활성화된 경우 3삭제
		alert("세번째 운전면허증 란을 우선 삭제해 주세요.");
		return false;
	}else{
		$("#dLicense2").hide();
		$("#dFile2").val("");
		$("#dFileS2").val("");
		$("#dLicenseType2 option:eq(0)").prop("selected", true);
		$("#dLicense2").removeClass("active");
		return false;
	}
});

$(document).on("click",'#downloadfile' ,function(){
	location.href="/sample/agree.doc";
});
$(document).on("click",'#btn_delete3' ,function(){		
	$("#dLicense3").hide();
	$("#dFile3").val("");
	$("#dFileS3").val("");
	$("#dLicenseType3 option:eq(0)").prop("selected", true);
	$("#dLicense3").removeClass("active");
	return false;
});

//상세보기 테이블
function drawingDetailTable(driver){
	$("#data_list").hide();
	$("#data_detail").show();
	var html='';
	html += ' <h3 class="stitle m-t-20">운전자 정보 관리';
	html += ' </h3>';
	html += ' <div class="tbl_wrap_view m-t-15">';
	html += '<table class="tbl_view01" id="data_table" summary="테이블입니다.">';
	html += '<caption>테이블입니다.</caption>';
	html += '<colgroup>';
	html += '    <col width="180px;" />';
	html += '    <col width="420px" />';
	html += '    <col width="180px;" />';
	html += '    <col width="420px" />';
	html += '</colgroup>';
	html += '<tr><th scope="row">이름<br />(관리번호)</th><td>'+undefinedChk(driver.dname,"")+'<br />(<span class="seq">'+undefinedChk(driver.dseq,"")+'</span>)</td>';
	var dbirth = undefinedChk(driver.dbirth,"");
	html += '<th scope="row">생년월일</th><td>'+dbirth.substring(0,4)+'-'+dbirth.substring(4,6)+'-'+dbirth.substring(6,8)+'</td></tr>';
	html += '<tr><th>이메일 주소</th><td>'+undefinedChk(driver.demail,"")+'</td>';
	var dphone = undefinedChk(driver.dphone,"");
	html += '<th scope="row">휴대폰 번호/<br />전화번호</th><td>'+dphone.substring(0,3)+'-'+dphone.substring(3,7)+'-'+dphone.substring(7,11);
	var dphone2 = undefinedChk(driver.dphone2,"");
	if(dphone2!=""){
		if(dphone2.substring(0,2)=="02"){
			if(dphone2.length==10){
				dphone2 = dphone2.substring(0,2)+'-'+dphone2.substring(2,6)+'-'+dphone2.substring(6,10);
			}else{
				dphone2 = dphone2.substring(0,2)+'-'+dphone2.substring(2,5)+'-'+dphone2.substring(5,10);
			}
		}else if(dphone2.substring(0,3)=="010"){
			dphone2 = dphone2.substring(0,3)+'-'+dphone2.substring(3,7)+'-'+dphone2.substring(7,11);
		}else{
			if(dphone2.length==10){
				dphone2 = dphone2.substring(0,3)+'-'+dphone2.substring(3,6)+'-'+dphone2.substring(6,10);
			}else if(dphone2.length==11){
				dphone2 = dphone2.substring(0,3)+'-'+dphone2.substring(3,7)+'-'+dphone2.substring(7,11);
			}else if(dphone2.length==12){
				dphone2 = dphone2.substring(0,4)+'-'+dphone2.substring(4,8)+'-'+dphone2.substring(8,12);					
			}
		}
		html += '<br />'+dphone2;
	}
	html += '</td>';
	var dLicenseType = undefinedChk(driver.dlicenseType,"");
	html += '<tr><th scope="row">운전면허종류</th><td>';
	
	if(dLicenseType.split(',')[0]=="LT10"){
		html += '제1종 대형면허';
	}else if(dLicenseType.split(',')[0]=="LT11"){
		html += '제1종 보통면허';
	}else if(dLicenseType.split(',')[0]=="LT12"){
		html += '제1종 소형면허';
	}else if(dLicenseType.split(',')[0]=="LT13"){
		html += '제1종 특수면허';
	}else if(dLicenseType.split(',')[0]=="LT21"){
		html += '제2종 보통면허';
	}else if(dLicenseType.split(',')[0]=="LT22"){
		html += '제2종 소형면허';
	}else if(dLicenseType.split(',')[0]=="LT23"){
		html += '제2종 원동기장치자전거면허';
	}

	if(dLicenseType.split(',')[1]=="LT10"){
		html += '<br />제1종 대형면허';
	}else if(dLicenseType.split(',')[1]=="LT11"){
		html += '<br />제1종 보통면허';
	}else if(dLicenseType.split(',')[1]=="LT12"){
		html += '<br />제1종 소형면허';
	}else if(dLicenseType.split(',')[1]=="LT13"){
		html += '<br />제1종 특수면허';
	}else if(dLicenseType.split(',')[1]=="LT21"){
		html += '<br />제2종 보통면허';
	}else if(dLicenseType.split(',')[1]=="LT22"){
		html += '<br />제2종 소형면허';
	}else if(dLicenseType.split(',')[1]=="LT23"){
		html += '<br />제2종 원동기장치자전거면허';
	}

	if(dLicenseType.split(',')[2]=="LT10"){
		html += '<br />제1종 대형면허';
	}else if(dLicenseType.split(',')[2]=="LT11"){
		html += '<br />제1종 보통면허';
	}else if(dLicenseType.split(',')[2]=="LT12"){
		html += '<br />제1종 소형면허';
	}else if(dLicenseType.split(',')[2]=="LT13"){
		html += '<br />제1종 특수면허';
	}else if(dLicenseType.split(',')[2]=="LT21"){
		html += '<br />제2종 보통면허';
	}else if(dLicenseType.split(',')[2]=="LT22"){
		html += '<br />제2종 소형면허';
	}else if(dLicenseType.split(',')[2]=="LT23"){
		html += '<br />제2종 원동기장치자전거면허';
	}
	
	html += '</td>';
	html += '<th scope="row">운전기간</th><td>'+undefinedChk(driver.dhistory,"")+'년</td></tr>';
	html += '<tr><th scope="row">혈액형</th><td colspan="3">'+undefinedChk(driver.dbloodType,"")+'형';
	var dbloodSpecial = undefinedChk(driver.dbloodSpecial,"");
	if(dbloodSpecial != ""){
		html += '&nbsp;<span class="red">('+dbloodSpecial+')</span></td></tr>';	
	}
	var infoArr = [];
	infoArr = driver.upfiles;
	if(infoArr.length>0){
		
		if(infoArr.length>3){
			var fileUrl = "/user/driver/fileupload/download/"+undefinedChk(infoArr[0].fseq,"");
			var fileUrl2 = "/user/driver/fileupload/download/"+undefinedChk(infoArr[1].fseq,"");
			var fileUrl3 = "/user/driver/fileupload/download/"+undefinedChk(infoArr[2].fseq,"");
			var fileUrl1 = "/user/driver/fileupload/download/"+undefinedChk(infoArr[3].fseq,"");
			html += '<tr><th scope="row">운전면허증</th><td>' + 
				'<a href="'+fileUrl+'"> '+undefinedChk(infoArr[0].fname,"")+'</a>' + 
				'<a href="'+fileUrl2+'"> '+undefinedChk(infoArr[1].fname,"")+'</a>' + 
				'<a href="'+fileUrl3+'"> '+undefinedChk(infoArr[2].fname,"")+'</a>' + 
			'</td>';
			html += '<th scope="row">동의서 제출 여부</th><td><a href="'+fileUrl1+'">'+undefinedChk(infoArr[3].fname,"")+'</a></td></tr>';
		}else if(infoArr.length>2){
			var fileUrl = "/user/driver/fileupload/download/"+undefinedChk(infoArr[0].fseq,"");
			var fileUrl1 = "/user/driver/fileupload/download/"+undefinedChk(infoArr[2].fseq,"");
			html += '<tr><th scope="row">운전면허증</th><td>' + 
				'<a href="'+fileUrl+'"> '+undefinedChk(infoArr[0].fname,"")+'</a>' + 
				'<a href="'+fileUrl2+'"> '+undefinedChk(infoArr[1].fname,"")+'</a>' + 
				'</td>';
			html += '<th scope="row">동의서 제출 여부</th><td><a href="'+fileUrl1+'">'+undefinedChk(infoArr[2].fname,"")+'</a></td></tr>';
		}else{
			var fileUrl = "/user/driver/fileupload/download/"+undefinedChk(infoArr[0].fseq,"");
			var fileUrl1 = "/user/driver/fileupload/download/"+undefinedChk(infoArr[1].fseq,"");
			html += '<tr><th scope="row">운전면허증</th><td><a href="'+fileUrl+'">'+undefinedChk(infoArr[0].fname,"")+'</a></td>';
			html += '<th scope="row">동의서 제출 여부</th><td><a href="'+fileUrl1+'">'+undefinedChk(infoArr[1].fname,"")+'</a></td></tr>';
		}
	}
	html += '<tr><th>운전자 레벨</th><td>';
	if(undefinedChk(driver.dapproval,"") == 'Y'){
	html += undefinedChk(driver.dlevel, "");
	}
	html += '</td>';
	html += '<th scope="row">안전교육이수여부<br />(유효기간)</th><td>';
	var dedu = undefinedChk(driver.dedu,"");
	if(dedu=="Y"){
		html += '이수';	
	}else if(dedu=="N"){
		html += '미이수';
	}
	var deduEndDt = undefinedChk(driver.deduEndDt,"");
	if(deduEndDt.length==14){
		html += '<br />~ '+deduEndDt.substring(0,4)+'-'+deduEndDt.substring(4,6)+'-'+deduEndDt.substring(6,8);
	}
	html += '</td></tr>';
	html += '<tr><th scope="row">신청일시</th><td colspan="3">';
	var dregDt = "";
	if(driver.dregDt.length==14){
		dregDt += driver.dregDt.substring(0,4);
		dregDt += "-";
		dregDt += driver.dregDt.substring(4,6);
		dregDt += "-";
		dregDt += driver.dregDt.substring(6,8);
	}
	html += dregDt+'</td>';
	html += '</table>';
	html += '</div>';
	html += '<section class="tac m-t-50">';
	html += '   <button type="button" id="listBtn" class="btn btn_gray m-r-11">목록</button>';
	html += '</section>';
	$("#data_detail").html(html);
}

//테이블 그리는 함수
function drawingTable(rows){
	var html='';
	if(rows.length==0){
		html += '<tr>';
		html += '	<td colspan="10">등록된 정보가 없습니다. </td>';
		html += '</tr>';
	}else{
		for(var list in rows){
			html += '<tr onmouseover="this.className=\'on\'" onmouseout="this.className=\'\'">';
			html += '<td style="padding:5px 17px"><span class="seq" style="display:none">'+undefinedChk(rows[list].dseq,"")+'</span>'+undefinedChk(rows[list].dname,"")+'</td>';
			var dbirth = undefinedChk(rows[list].dbirth,"");
			html += '<td style="padding:5px 17px">'+dbirth.substring(0,4)+'-'+dbirth.substring(4,6)+'-'+dbirth.substring(6,8)+'</td>';
			html += '<td style="padding:5px 17px">'+undefinedChk(rows[list].demail,"")+'</td>';
			var dphone = undefinedChk(rows[list].dphone,"");
			
			html += '<td style="padding:5px 17px">'+dphone.substring(0,3)+'-'+dphone.substring(3,7)+'-'+dphone.substring(7,11);
			
			var dphone2 = undefinedChk(rows[list].dphone2,"");
			if(dphone2!=""){
				if(dphone2.substring(0,2)=="02"){
					if(dphone2.length==10){
						dphone2 = dphone2.substring(0,2)+'-'+dphone2.substring(2,6)+'-'+dphone2.substring(6,10);
					}else{
						dphone2 = dphone2.substring(0,2)+'-'+dphone2.substring(2,5)+'-'+dphone2.substring(5,10);
					}
				}else if(dphone2.substring(0,3)=="010"){
					dphone2 = dphone2.substring(0,3)+'-'+dphone2.substring(3,7)+'-'+dphone2.substring(7,11);
				}else{
					if(dphone2.length==10){
						dphone2 = dphone2.substring(0,3)+'-'+dphone2.substring(3,6)+'-'+dphone2.substring(6,10);
					}else if(dphone2.length==11){
						dphone2 = dphone2.substring(0,3)+'-'+dphone2.substring(3,7)+'-'+dphone2.substring(7,11);
					}else if(dphone2.length==12){
						dphone2 = dphone2.substring(0,4)+'-'+dphone2.substring(4,8)+'-'+dphone2.substring(8,12);					
					}
				}
				html += '<br />'+dphone2;
			}
			html += '</td>';
			var dLicenseType = undefinedChk(rows[list].dlicenseType,"");
			html += '<td style="padding:5px 17px">';
			
			if(dLicenseType.split(',')[0]=="LT10"){
				html += '제1종 대형면허';
			}else if(dLicenseType.split(',')[0]=="LT11"){
				html += '제1종 보통면허';
			}else if(dLicenseType.split(',')[0]=="LT12"){
				html += '제1종 소형면허';
			}else if(dLicenseType.split(',')[0]=="LT13"){
				html += '제1종 특수면허';
			}else if(dLicenseType.split(',')[0]=="LT21"){
				html += '제2종 보통면허';
			}else if(dLicenseType.split(',')[0]=="LT22"){
				html += '제2종 소형면허';
			}else if(dLicenseType.split(',')[0]=="LT23"){
				html += '제2종 원동기장치자전거면허';
			}
			

			if(dLicenseType.split(',')[1]=="LT10"){
				html += '<br />제1종 대형면허';
			}else if(dLicenseType.split(',')[1]=="LT11"){
				html += '<br />제1종 보통면허';
			}else if(dLicenseType.split(',')[1]=="LT12"){
				html += '<br />제1종 소형면허';
			}else if(dLicenseType.split(',')[1]=="LT13"){
				html += '<br />제1종 특수면허';
			}else if(dLicenseType.split(',')[1]=="LT21"){
				html += '<br />제2종 보통면허';
			}else if(dLicenseType.split(',')[1]=="LT22"){
				html += '<br />제2종 소형면허';
			}else if(dLicenseType.split(',')[1]=="LT23"){
				html += '<br />제2종 원동기장치자전거면허';
			}
			

			if(dLicenseType.split(',')[2]=="LT10"){
				html += '<br />제1종 대형면허';
			}else if(dLicenseType.split(',')[2]=="LT11"){
				html += '<br />제1종 보통면허';
			}else if(dLicenseType.split(',')[2]=="LT12"){
				html += '<br />제1종 소형면허';
			}else if(dLicenseType.split(',')[2]=="LT13"){
				html += '<br />제1종 특수면허';
			}else if(dLicenseType.split(',')[2]=="LT21"){
				html += '<br />제2종 보통면허';
			}else if(dLicenseType.split(',')[2]=="LT22"){
				html += '<br />제2종 소형면허';
			}else if(dLicenseType.split(',')[2]=="LT23"){
				html += '<br />제2종 원동기장치자전거면허';
			}
			
			html += '</td>';
			html += '<td style="padding:5px 17px">'+undefinedChk(rows[list].dbloodType,"")+'형';
			var dbloodSpecial = undefinedChk(rows[list].dbloodSpecial,"");
			if(dbloodSpecial != ""){
				html += '<br /><span class="red">('+dbloodSpecial+')</span></td>';	
			}
			html += '<td style="padding:5px 17px">';
			var dapproval = undefinedChk(rows[list].dapproval,"");
			if(dapproval=="Y"){
				html += '승인완료';
			}else if(dapproval=="N"){
				html += '승인대기';
				html += '<br /><button type="button" class="btn-line-s btn_default" data-layer="cancel_info">삭제</button>';
			}else if(dapproval=="R"){
				html += '반려';
				html += '<br /><button type="button" class="btn-line-s btn_default" name="btnViewRreason">사유보기</button>';
				html += '<span id="rsn'+undefinedChk(rows[list].dseq,"")+'" style="display:none">'+undefinedChk(rows[list].dmemo,"")+'</span>';
			}	
			html += '</td>';
			html += '<td style="padding:5px 17px">제출</td>';
			html += '<td style="padding:5px 17px">';
			var dedu = undefinedChk(rows[list].dedu,"");
			if(dedu=="Y"){
				html += "이수";
			}else{
				html += "미이수";
			}
			var deduDt = "";
			if(rows[list].deduDt.length==14){
				deduDt += rows[list].deduDt.substring(0,4)+"-"+rows[list].deduDt.substring(4,6)+"-"+rows[list].deduDt.substring(6,8);
			}
			var deduEndDt = "";
			if(rows[list].deduEndDt.length==14){
				deduEndDt = rows[list].deduEndDt.substring(0,4)+"-"+rows[list].deduEndDt.substring(4,6)+"-"+rows[list].deduEndDt.substring(6,8);
				html += '<br />~ '+deduEndDt;
			}
			html += '</td>'
			html += '<td style="padding:5px 17px">'
			if(dapproval=="Y"){
				html += rows[list].dlevel;
			}
			html += '</td>';
			html += '</tr>';
		}
	}
	$("#tbody").html(html);
}

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
		<div class="breadcrumb">
			<span class="breadcrumb_icon"></span><span>마이페이지</span><span>회원정보</span>
		</div>
		<!-- //breadcrumb -->
		<!-- title -->
		<h2 class="title">회원정보</h2>
		<!-- //title -->
		<!-- tab -->
		<div class="wrap_tab w1200">
			<div class="tab">
				<button class="tablinks" onclick="pageMove('tab1')" id="defaultOpen">회원정보
					변경</button>
				<button class="tablinks" onclick="pageMove('tab2')">비밀번호 변경</button>
				<button class="tablinks active" onclick="pageMove('tab3')">운전자
					정보 관리</button>
			</div>
			<div class="wrap_tabcontent">
				<!-- 등록폼 시작 -->
				<!-- tab3 -->
				<div id="tab3" class="tabcontent" style="border: none">
					<div id="data_area">
						<h3 class="stitle m-t-20" style="margin-bottom: 20px">
							운전자 정보 관리 <span class="tar"> <span
								class="info_ment_orange m-r-11">동의서 다운로드 후 자필 서명한 후 업로드 해
									주시기 바랍니다.</span>
								<button id="downloadfile" type="button" class="btn-line btn_gray">동의서
									다운로드</button>
							</span>
						</h3>
						<!-- table_view -->
						<div class="tbl_wrap_view m-t-15">
							<form name="form" id="form" method="post"
								action="/driver/fileupload/insert-driver"
								enctype="multipart/form-data">
								<input type="hidden" name="${_csrf.parameterName}"
									value="${_csrf.token}" /> <input type="hidden"
									id="currentdSeq" name="currentdSeq" value="" />
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
													class="form_control" placeholder="운전자 이름 입력" value=""
													maxlength="33" autocomplete="off" />
											</div> <span id="errdName"></span>
										</td>
									</tr>
									<tr>
										<th scope="row">생년월일<span class="required"></span></th>
										<td colspan="3">
											<div class="form_group w300">
												<input type="text" id="dBirth" name="dBirth"
													class="form_control" placeholder="생년월일 입력(yyyymmdd)"
													maxlength="8" onkeypress="numberonly();" value=""
													autocomplete="off" />
											</div> <span id="errdBirth"></span>
										</td>
									</tr>
									<tr>
										<th scope="row">이메일 주소<span class="required"></span></th>
										<td colspan="3">
											<div class="form_group w300">
												<input type="text" id="dEmail" name="dEmail"
													class="form_control" placeholder="이메일 주소 입력" value=""
													maxlength="90" autocomplete="off" />
											</div> <span id="errdEmail"></span>
										</td>
									</tr>
									<tr>
										<th scope="row">휴대폰 번호<span class="required"></span></th>
										<td colspan="3">
											<div class="form_group w300">
												<input type="text" id="dPhone" name="dPhone"
													class="form_control" placeholder="휴대폰 번호 입력" maxlength="11"
													onkeypress="numberonly();" value="" autocomplete="off" />
											</div> <span id="errdPhone" class="info_ment">‘-’ 없이 입력하세요.</span>
										</td>
									</tr>
									<tr>
										<th scope="row">회사 전화번호<span class="required"></span></th>
										<td colspan="3">
											<div class="form_group w300">
												<input type="text" name="dPhone2" id="dPhone2"
													class="form_control" placeholder="회사 전화번호" maxlength="12"
													onkeypress="numberonly();" value="" autocomplete="off" />
											</div> <span id="errdPhone2" class="info_ment">‘-’ 없이 입력하세요.</span>
										</td>
									</tr>
									<tr>
										<th scope="row">운전경력 기간<span class="required"></span></th>
										<td colspan="3">
											<div class="form_group">
												<div class="check_inline">
													<label class="check_default"> <input
														type="checkbox" name="dEduChk" id="dEduChk" value="Y" />
														<span class="check_icon"></span>5년 이상
													</label>
												</div>
											</div>
											<div class="form_group w80">
												<input type="text" id="dHistory" name="dHistory"
													class="form_control" placeholder="숫자 입력" maxlength="2"
													onkeypress="numberonly();" value="" />
											</div> 년 <span id="errdHistory" class="info_ment">운전경력은
												5년이상인 자만 등록 가능합니다. 5년 이상인 경우 5년 이상에 체크해 주시고 운전 경력을 입력해 주시기
												바랍니다.</span>
										</td>
									</tr>
									<tr>
										<input type="hidden" id="dLicenseType" name="dLicenseType">
										<th scope="row">운전면허증 사본<span class="required"></span></th>
										<td colspan="3">
											<div class="w670 disib vat01">
												<span class="info_ment_orange m-l-0">주민등록번호 뒷자리 7자리,
													운전면허 번호, 사진의 경우의 음영처리(masking)하여 제출 바랍니다. <br />첨부파일은 육안으로
													식별 가능해야 하며, 서류 검토 후 문제가 있을 경우 서비스 이용에 제한을 받을 수 있습니다.
												</span>
												<div class="m-t-10 m-b-10">
													<div class="form_group w218">
														<input type="text" id="dFile" class="form_control"
															placeholder="파일첨부" maxlength="80" value=""
															readonly="readonly" />
														<div id="dFile"></div>
														<input type="file" id="dFileS" name="dFile"
															onchange="javascript:document.getElementById('dFile').value=this.value"
															style="display: none" />
													</div>
													<button type="button" id="regDfile"
														class="btn-line btn_gray btnFile">파일첨부</button>
													<%--<button type="button" id="regDfile" class="btn-line btn_gray btnFile">미리보기</button> --%>

													<div class="form_group w300">
														<div class="select_group">
															<select id="dLicenseType1" name="dLicenseType1"
																title="select" class="form_control">
																<option value="">선택하세요</option>
																<option value="LT10">제1종 대형면허</option>
																<option value="LT11">제1종 보통면허</option>
																<option value="LT12">제1종 소형면허</option>
																<option value="LT13">제1종 특수면허</option>
																<option value="LT21">제2종 보통면허</option>
																<option value="LT22">제2종 소형면허</option>
																<option value="LT23">제2종 원동기장치자전거면허</option>
															</select>
														</div>
													</div>
													<span id="errdLicenseType"></span>

												</div>
												<span id="errdFile" class="info_ment m-l-0">5MB 이내의
													허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif,
													pdf만 가능)</span>
											</div>
											<div class="disib vat01">
												<img src="/inc/images/img_licence_sample.png"
													alt="운전면허증 사본 제출 예시" />
											</div>
											<div class="wrap_btn_testcar01">
												<button type="button" id="addDriverBtn"
													class="btn-line btn_gray">운전 면허증 사본 +</button>
											</div>
										</td>
									</tr>
									<tr id="dLicense2" style="display: none">
										<th scope="row">운전면허증 사본</span></th>
										<td colspan="3">
											<div class="w670 disib vat01">
												<span class="info_ment_orange m-l-0">주민등록번호 뒷자리 7자리,
													운전면허 번호, 사진의 경우의 음영처리(masking)하여 제출 바랍니다. <br />첨부파일은 육안으로
													식별 가능해야 하며, 서류 검토 후 문제가 있을 경우 서비스 이용에 제한을 받을 수 있습니다.
												</span>
												<div class="m-t-10 m-b-10">
													<div class="form_group w218">
														<input type="text" id="dFile2" class="form_control"
															placeholder="파일첨부" maxlength="80" value=""
															readonly="readonly" />
														<div id="dFile2"></div>
														<input type="file" id="dFileS2" name="dFile"
															onchange="javascript:document.getElementById('dFile2').value=this.value"
															style="display: none" />
													</div>
													<button type="button" id="regdFile2"
														class="btn-line btn_gray btnFile">파일첨부</button>
													<%--<button type="button" id="regDfile" class="btn-line btn_gray btnFile">미리보기</button> --%>

													<div class="form_group w300">
														<div class="select_group">
															<select id="dLicenseType2" name="dLicenseType2"
																title="select" class="form_control">
																<option value="">선택하세요</option>
																<option value="LT10">제1종 대형면허</option>
																<option value="LT11">제1종 보통면허</option>
																<option value="LT12">제1종 소형면허</option>
																<option value="LT13">제1종 특수면허</option>
																<option value="LT21">제2종 보통면허</option>
																<option value="LT22">제2종 소형면허</option>
																<option value="LT23">제2종 원동기장치자전거면허</option>
															</select>
														</div>
													</div>
													<span id="errdLicenseType2"></span>

												</div>
												<span id="errdFile2" class="info_ment m-l-0">5MB 이내의
													허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif,
													pdf만 가능)</span>
											</div>
											<div class="disib vat01">
												<img src="/inc/images/img_licence_sample.png"
													alt="운전면허증 사본 제출 예시" />
											</div>
											<button id="btn_delete2" class="btn_delete"
												style="margin-left: 5px"></button>
										</td>
									</tr>
									<tr id="dLicense3" style="display: none">
										<th scope="row">운전면허증 사본</span></th>
										<td colspan="3">
											<div class="w670 disib vat01">
												<span class="info_ment_orange m-l-0">주민등록번호 뒷자리 7자리,
													운전면허 번호, 사진의 경우의 음영처리(masking)하여 제출 바랍니다. <br />첨부파일은 육안으로
													식별 가능해야 하며, 서류 검토 후 문제가 있을 경우 서비스 이용에 제한을 받을 수 있습니다.
												</span>
												<div class="m-t-10 m-b-10">
													<div class="form_group w218">
														<input type="text" id="dFile3" class="form_control"
															placeholder="파일첨부" maxlength="80" value=""
															readonly="readonly" />
														<div id="dFile3"></div>
														<input type="file" id="dFileS3" name="dFile"
															onchange="javascript:document.getElementById('dFile3').value=this.value"
															style="display: none" />
													</div>
													<button type="button" id="regdFile3"
														class="btn-line btn_gray btnFile">파일첨부</button>
													<%--<button type="button" id="regDfile" class="btn-line btn_gray btnFile">미리보기</button> --%>

													<div class="form_group w300">
														<div class="select_group">
															<select id="dLicenseType3" name="dLicenseType3"
																title="select" class="form_control">
																<option value="">선택하세요</option>
																<option value="LT10">제1종 대형면허</option>
																<option value="LT11">제1종 보통면허</option>
																<option value="LT12">제1종 소형면허</option>
																<option value="LT13">제1종 특수면허</option>
																<option value="LT21">제2종 보통면허</option>
																<option value="LT22">제2종 소형면허</option>
																<option value="LT23">제2종 원동기장치자전거면허</option>
															</select>
														</div>
													</div>
													<span id="errdLicenseType3"></span>

												</div>
												<span id="errdFile3" class="info_ment m-l-0">5MB 이내의
													허용된 확장자 파일만 첨부할 수 있습니다. (jpg, png, jpeg, bmp, tiff ,tif,
													pdf만 가능)</span>
											</div>
											<div class="disib vat01">
												<img src="/inc/images/img_licence_sample.png"
													alt="운전면허증 사본 제출 예시" />
											</div>
											<button id="btn_delete3" class="btn_delete"
												style="margin-left: 5px"></button>
										</td>
									</tr>
									<tr>
										<th scope="row">혈액형<span class="required"></span></th>
										<td colspan="3">
											<div class="form_group">
												<div class="radio_inline">
													<label class="radio_default"> <input type="radio"
														id="dBloodTypeA" name="dBloodType" value="A" /> <span
														class="radio_icon"></span>A형
													</label> <label class="radio_default"> <input type="radio"
														id="dBloodTypeB" name="dBloodType" value="B" /> <span
														class="radio_icon"></span>B형
													</label> <label class="radio_default"> <input type="radio"
														id="dBloodTypeAB" name="dBloodType" value="AB" /> <span
														class="radio_icon"></span>AB형
													</label> <label class="radio_default"> <input type="radio"
														id="dBloodTypeO" name="dBloodType" value="O" /> <span
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
												<input type="text" id="dFile4" class="form_control"
													placeholder="파일 첨부" maxlength="80" readonly="readonly" />
												<input type="file" id="dFile4S" name="dFile"
													onchange="javascript:document.getElementById('dFile4').value=this.value"
													style="display: none" />
											</div>
											<button type="button" id="regAfile"
												class="btn-line btn_gray btnFile">파일첨부</button> <span
											id="errdFile4" class="info_ment">동의서 다운로드 후 자필 서명한 후
												업로드 해 주시기 바랍니다.</span>
										</td>
									</tr>

									<tr>
										<th scope="row">재직증명서 업로드<span class="required"></span></th>
										<td colspan="3">
											<div class="form_group w300">
												<input type="text" id="dFile5" class="form_control"
													placeholder="파일 첨부" maxlength="80" readonly="readonly" />
												<input type="file" id="dFile5S" name="dFile"
													onchange="javascript:document.getElementById('dFile5').value=this.value"
													style="display: none" />
											</div>
											<button type="button" id="regEfile"
												class="btn-line btn_gray btnFile">파일첨부</button> <span
											id="errdFile5" class="info_ment">재직증명서 주민등록번호 뒤 7자리를
												음영처리(masking)하여 제출 바랍니다.</span>
										</td>
									</tr>

								</table>
								<!-- button -->
								<section class="tac m-t-50">
									<button type="button" class="btn btn_gray m-r-11"
										data-layer="cancel">취소</button>
									<button type="button" id="regBtn" class="reg btn btn_default">확인</button>
								</section>
								<!-- //button -->
							</form>
						</div>
						<!-- //table_view -->
					</div>
					<!-- //tab3 -->
					<!-- 등록폼 끝 -->
					<!-- 상세보기 시작 -->
					<section id="data_detail" class="tbl_wrap_view"
						style="border: none"></section>
					<!-- 상세보기 끝 -->

					<div id="data_list">
						<section class="tbl_wrap_list">
							<table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다"
								style="font-size: 13px">
								<caption>운전자목록</caption>
								<colgroup>
									<col width="">
									<col width="11%">
									<col width="">
									<col width="">
									<col width="10%">
									<col width="7%">
									<col width="">
									<col width="">
									<col width="10%">
									<col width="">
								</colgroup>
								<thead>
									<tr>
										<th scope="col" style="font-size: 13px">이름</th>
										<th scope="col" style="font-size: 13px">생년월일</th>
										<th scope="col" style="font-size: 13px">이메일주소</th>
										<th scope="col" style="font-size: 13px">휴대폰 번호<br />전화번호
										</th>
										<th scope="col" style="font-size: 13px">운전면허<br />종류
										</th>
										<th scope="col" style="font-size: 13px">혈액형</th>
										<th scope="col" style="font-size: 13px">승인상태</th>
										<th scope="col" style="font-size: 13px">동의서<br />제출여부
										</th>
										<th scope="col" style="font-size: 13px">안전교육이수여부<br />유효기간
										</th>
										<th scope="col" style="font-size: 13px">레벨</th>
									</tr>
								<tbody id="tbody">
									<c:if test="${totalCnt == 0}">
										<tr>
											<td colspan="10">등록된 정보가 없습니다.</td>
										</tr>
									</c:if>
									<c:forEach var="result" items="${driverList.rows}"
										varStatus="status">
										<tr onmouseover="this.className='on'"
											onmouseout="this.className=''">
											<td style="padding: 5px 17px"><span class="seq"
												style="display: none">${result.DSeq}</span>${result.DName}</td>
											<td style="padding: 5px 17px"><c:set
													value="${result.DBirth}" var="dBirth" /> <c:out
													value="${fn:substring(dBirth,0,4) }-${fn:substring(dBirth,4,6) }-${fn:substring(dBirth,6,8) }"></c:out>
											</td>
											<td style="padding: 5px 17px">${result.DEmail}</td>
											<td style="padding: 5px 17px"><c:set
													value="${result.DPhone}" var="dPhone" />
												${fn:substring(dPhone, 0, 3) }-${fn:substring(dPhone, 3, 7) }-${fn:substring(dPhone, 7, 11) }

												<c:set value="${result.DPhone2}" var="dPhone2" /> <c:if
													test="${dPhone2 ne '' }">
													<br />
													<c:if test="${fn:substring(dPhone2, 0, 2) eq '02' }">
														<c:if test="${fn:length(dPhone2) eq 10 }">
															${fn:substring(dPhone2,0,2) }-${fn:substring(dPhone2,2,6) }-${fn:substring(dPhone2,6,10) }
														</c:if>
														<c:if test="${fn:length(dPhone2) ne 10 }">
															${fn:substring(dPhone2,0,2) }-${fn:substring(dPhone2,2,5) }-${fn:substring(dPhone2,5,10) }
														</c:if>
													</c:if>
													<c:if test="${fn:substring(dPhone2, 0, 3) eq '010' }">
														${fn:substring(dPhone2,0,3) }-${fn:substring(dPhone2,3,7) }-${fn:substring(dPhone2,7,11) }
													</c:if>
													<c:if
														test="${fn:substring(dPhone2, 0, 2) ne '02' and fn:substring(dPhone2, 0, 3) ne '010'}">
														<c:if test="${fn:length(dPhone2) eq 10 }">
															${fn:substring(dPhone2,0,3) }-${fn:substring(dPhone2,3,6) }-${fn:substring(dPhone2,6,10) }
														</c:if>
														<c:if test="${fn:length(dPhone2) eq 11 }">
															${fn:substring(dPhone2,0,3) }-${fn:substring(dPhone2,3,7) }-${fn:substring(dPhone2,7,11) }
														</c:if>
														<c:if test="${fn:length(dPhone2) eq 12 }">
															${fn:substring(dPhone2,0,4) }-${fn:substring(dPhone2,4,8) }-${fn:substring(dPhone2,8,12) }
														</c:if>
													</c:if>
												</c:if>
											</td>
											<td style="padding: 5px 17px"><c:set
													value="${result.DLicenseType}" var="dLicenseType" /> <c:if
													test="${dLicenseType.split(',')[0] eq 'LT10' }">제1종 대형면허</c:if>
												<c:if test="${dLicenseType.split(',')[0] eq 'LT11' }">제1종 보통면허</c:if>
												<c:if test="${dLicenseType.split(',')[0] eq 'LT12' }">제1종 소형면허</c:if>
												<c:if test="${dLicenseType.split(',')[0] eq 'LT13' }">제1종 특수면허</c:if>
												<c:if test="${dLicenseType.split(',')[0] eq 'LT21' }">제2종 보통면허</c:if>
												<c:if test="${dLicenseType.split(',')[0] eq 'LT22' }">제2종 소형면허</c:if>
												<c:if test="${dLicenseType.split(',')[0] eq 'LT23' }">제2종 원동기장치자전거면허</c:if>

												<c:if test="${dLicenseType.split(',')[1] eq 'LT10' }">
													<br />제1종 대형면허</c:if> <c:if
													test="${dLicenseType.split(',')[1] eq 'LT11' }">
													<br />제1종 보통면허</c:if> <c:if
													test="${dLicenseType.split(',')[1] eq 'LT12' }">
													<br />제1종 소형면허</c:if> <c:if
													test="${dLicenseType.split(',')[1] eq 'LT13' }">
													<br />제1종 특수면허</c:if> <c:if
													test="${dLicenseType.split(',')[1] eq 'LT21' }">
													<br />제2종 보통면허</c:if> <c:if
													test="${dLicenseType.split(',')[1] eq 'LT22' }">
													<br />제2종 소형면허</c:if> <c:if
													test="${dLicenseType.split(',')[1] eq 'LT23' }">
													<br />제2종 원동기장치자전거면허</c:if> <c:if
													test="${dLicenseType.split(',')[2] eq 'LT10' }">
													<br />제1종 대형면허</c:if> <c:if
													test="${dLicenseType.split(',')[2] eq 'LT11' }">
													<br />제1종 보통면허</c:if> <c:if
													test="${dLicenseType.split(',')[2] eq 'LT12' }">
													<br />제1종 소형면허</c:if> <c:if
													test="${dLicenseType.split(',')[2] eq 'LT13' }">
													<br />제1종 특수면허</c:if> <c:if
													test="${dLicenseType.split(',')[2] eq 'LT21' }">
													<br />제2종 보통면허</c:if> <c:if
													test="${dLicenseType.split(',')[2] eq 'LT22' }">
													<br />제2종 소형면허</c:if> <c:if
													test="${dLicenseType.split(',')[2] eq 'LT23' }">
													<br />제2종 원동기장치자전거면허</c:if></td>

											<td style="padding: 5px 17px">${result.DBloodType}형<c:if
													test="${result.DBloodSpecial ne ''}">
													<br />
													<span class="red">(${result.DBloodSpecial})</span>
												</c:if></td>
											<td style="padding: 5px 17px"><c:set
													value="${result.DApproval}" var="dApproval" /> <c:if
													test="${dApproval eq 'Y' }">승인완료</c:if> <c:if
													test="${dApproval eq 'N' }">승인대기<br />
													<button type="button" class="btn-line-s btn_default"
														data-layer="cancel_info">삭제</button>
												</c:if> <c:if test="${dApproval eq 'R' }">반려<br />
													<button type="button" class="btn-line-s btn_default"
														name="btnViewRreason">사유보기</button>
													<span id="rsn${result.DSeq}" style="display: none">${result.DMemo }</span>
												</c:if></td>
											<td style="padding: 5px 17px">제출</td>
											<td style="padding: 5px 17px"><c:set
													value="${result.DEdu}" var="dedu" /> <c:if
													test="${dedu eq 'Y' }">이수</c:if> <c:if
													test="${dedu eq 'N' }">미이수</c:if> <c:set var="DEduDt"
													value="${result.DEduDt}" /> <c:set var="DEduEndDt"
													value="${result.DEduEndDt}" /> <c:if
													test="${DEduEndDt ne '' }">
													<br />~${fn:substring(DEduEndDt,0,4) }-${fn:substring(DEduEndDt,4,6) }-${fn:substring(DEduEndDt,6,8) }
							</c:if></td>
											<td style="padding: 5px 17px"><c:if
													test="${dApproval eq 'Y' }">${result.DLevel}</c:if></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<section id="pagingc" class="pagination m-t-30">
								<jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
							</section>
						</section>

						<section class="tac m-t-50">
							<button type="button" id="goRegButton"
								class="btn btn_default m-r-11">등록</button>
						</section>
					</div>
					<!-- popup_Alert -->
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
								<button type="button" id="cancelBtn"
									class="btn-pop btn_default lyClose">확인</button>
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
							<div class="ly_con">변경이 완료되었습니다.</div>
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
								<button type="button" id="delBtn"
									class="btn-pop btn_default lyClose">확인</button>
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
									<p>
										신청하신 정보에 대해 담당자 검토 결과<br />예약 승인이 거절되었습니다.
									</p>
									<p>
										[반려사유]<br />
										<span id="rsnArea"></span>
									</p>
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
		<%@ include file="/WEB-INF/views/jsp/common/footer.jsp"%>