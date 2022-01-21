$(document).ready(function(){
	//var datatimeRegexp = RegExp(/^(19|20)\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$/);
	var datatimeRegexp = RegExp(/^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/);
	var emailCheck = RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i); 
	var phoneCheck= RegExp(/^[0-9]{11}/);
	var telCheck= RegExp(/^[0-9]{9,12}/); 
	
//	$(document).on("click",'#confirmBtn' ,function(){	//데이터 유효성 체크
//		var tcDayfromto = $("#tcDay").val().trim();
//		var searchFlag = $("#searchFlag").val();
//		var tcDayArr = tcDayfromto.split(" ~ ");  
//		var tcDay = tcDayArr[0];
//		var tcDay2 = tcDayArr[1];
//		var trTrackType = "";
//		var trTrackCode = "";
//		
//		if($("#stPanel").hasClass("active")){	//공동 트랙이 활성화되 있는 경우
//			$trackCode = $("#strack").find("select[name=trackCode]");
//			$trackCode.each (function (el, index){
//				if(trTrackCode.length==0){
//					trTrackCode = $(this).val();
//				}else{
//					trTrackCode += ","+$(this).val();
//				}
//			});
//			trTrackType = "S";
//		}else{		//단독 트랙이 활성화 되어 있는 경우	//공동 트랙이 활성화되 있는 경우
//			$trackCode = $("#mtrack").find("select[name=trackCode]");
//			$trackCode.each (function (el, index){
//				if(trTrackCode.length==0){
//					trTrackCode = $(this).val();
//				}else{
//					trTrackCode += ","+$(this).val();
//				}
//			});
//			trTrackType = "M";		
//		}
//		
//		if(tcDay=="") 
//			tcDay = tcDay.trim();
//		if(tcDay2=="") 
//			tcDay2 = tcDay2.trim();
//		if(tcDay==""||tcDay2==""||searchFlag=="N"){
//			alert("시험일자를 선택하신 후 조회버튼을 클릭해 주세요.");
//			$("#searchBtn").focus();
//			return false;
//		}
//		if(trTrackCode==""){
//			alert("공동/단독 중 원하시는 시험로를 선택해 주세요.");
//			$("#searchBtn").focus();
//			return false;
//		}
//		if(driver==""){
//			alert("운전자를 선택해 주세요.");
//			$("#driverBtn").focus();
//			return false;
//		}
//		var cVenderArr = new Array();
//		for(var i=0; i<$("input[name=cVender]").length; i++){
//			cVenderArr[i] = $("input[name=cVender]").eq(i).val();
//			
//			if(cVenderArr[i]==""){
//				$("#errcVender").text("차량제조사를 입력해 주세요.")
//				.addClass("redfont")
//				.addClass("info_ment");
//				return false;
//			}else{
//				$("#errcVender").text("")
//				.removeClass("redfont")
//				.removeClass("info_ment");
//			}
//        }
//		var cNameArr = new Array();
//		for(var i=0; i<$("input[name=cName]").length; i++){
//			cNameArr[i] = $("input[name=cName]").eq(i).val();
//			
//			if(cNameArr[i]==""){
//				$("#errcName").text("모델명을 입력해 주세요.")
//				.addClass("redfont")
//				.addClass("info_ment");
//				return false;
//			}else{
//				$("#errcName").text("")
//				.removeClass("redfont")
//				.removeClass("info_ment");
//			}
//        }
//		var cNumberArr = new Array();
//		for(var i=0; i<$("input[name=cNumber]").length; i++){
//			cNumberArr[i] = $("input[name=cNumber]").eq(i).val();
//				
//			if(cNumberArr[i]==""){
//				$("#errcNumber").text("차량번호을 입력해 주세요.")
//				.addClass("redfont")
//				.addClass("info_ment");
//				return false;
//			}else{
//				$("#errcNumber").text("")
//				.removeClass("redfont")
//				.removeClass("info_ment");
//			}
//			
//        }
//		var cColorArr = new Array();
//		for(var i=0; i<$("input[name=cColor]").length; i++){
//			cColorArr[i] = $("input[name=cColor]").eq(i).val();
//			if(cColorArr[i]==""){
//				$("#errcColor").text("차량색상을 입력해 주세요.")
//				.addClass("redfont")
//				.addClass("info_ment");
//				return false;
//			}else{
//				$("#errcColor").text("")
//				.removeClass("redfont")
//				.removeClass("info_ment");
//			}
//        }
//
//		var cTypeArr = new Array();
//		$("input[name=cType]").each (function (index){
//        	if($(this).is(":checked") == true) {
//				cTypeArr[index] = "S";
//			}
//        });
//
//		var tcPurpose = $("textarea[name=tcPurpose]").val().trim();
//		var memPhone = $("input[name=memPhone]").val().trim();
//		var compPhone = $("input[name=compPhone]").val().trim();
//		var memEmail = $("input[name=memEmail]").val().trim();
//		var compAcctName = $("input[name=compAcctName]").val().trim();
//		var compAcctDept = $("input[name=compAcctDept]").val().trim();
//		var compAcctEmail = $("input[name=compAcctEmail]").val().trim();
//		var compAcctPhone = $("input[name=compAcctPhone]").val().trim();
//		var tcAgreement = $("#tcAgreement").val();
//		
//		var driver = '';
//		var shopReserve = '';
//		
//		$("button[id^=bcnt]").each(function( index ) {
//			if($(this).hasClass("plan")){
//				if(index==0){
//					shopReserve = $(this).attr("id").replace("bcnt","");
//				}else{
//					shopReserve += ","+$(this).attr("id").replace("bcnt","");
//				}			
//			}
//		})
//		
//		var driverArr = new Array();
//		$('#driver li').each(function( index ) {
//			var driverId = $(this).attr("id");
//			if(driverId!=""){
//				driverId = driverId.replace("d", "");
//				driverArr[index] = driverId; 
//			}
//		});
//		if(tcPurpose==""){
//			$("#errtcPurpose").text("시험 종류 및 방법을 입력해 주세요.")
//			.addClass("redfont")
//			.addClass("info_ment");
//			$("#tcPurpose").focus();
//			return false;
//		}
//		if(!phoneCheck.test(memPhone) || memPhone==""){
//			$("#errmemPhone").text("휴대폰번호를 형식에 맞게 입력해 주세요.");
//			$("#errmemPhone").addClass("redfont");
//			$("#errmemPhone").addClass("info_ment");
//			$("#memPhone").focus();
//			return false;
//		}
//		if(!telCheck.test(compPhone) || compPhone==""){
//			$("#errcompPhone").text("회사전화번호를 형식에 맞게 입력해 주세요.")
//			.addClass("redfont")
//			.addClass("info_ment");
//			$("#compPhone").focus();
//			return false;
//		}
//		if(!emailCheck.test(memEmail) || memEmail == ""){
//			$("#errmemEmail").text("이메일을 형식에 맞게 입력해 주세요.")
//			.addClass("redfont")
//			.addClass("info_ment");
//			$("#memEmail").focus();
//			return false;
//		}	
//		if(compAcctName == ""){
//			$("#errcompAcctName").text("회계담당자를 입력해 주세요.")
//			.addClass("redfont")
//			.addClass("info_ment");
//			$("#compAcctName").focus();
//			return false;
//		}	
//		if(compAcctDept == ""){
//			$("#errcompAcctDept").text("부서를 입력해 주세요.")
//			.addClass("redfont")
//			.addClass("info_ment");
//			$("#compAcctDept").focus();
//			return false;
//		}	
//		if(!emailCheck.test(compAcctEmail) || compAcctEmail == ""){
//			$("#errcompAcctEmail").text("이메일을 형식에 맞게 입력해 주세요.")
//			.addClass("redfont")
//			.addClass("info_ment");
//			$("#compAcctEmail").focus();
//			return false;
//		}	
//		if(!telCheck.test(compAcctPhone) || compAcctPhone==""){
//			$("#errcompAcctPhone").text("전화번호를 형식에 맞게 입력해 주세요.")
//			.addClass("redfont")
//			.addClass("info_ment");
//			$("#compAcctPhone").focus();
//			return false;
//		}
//		if($("input:checkbox[id='tcAgreement']").is(":checked") == false){
//			$("#errtcAgreement").text("약관 확인 후 동의해 주셔야 합니다.")
//			.addClass("redfont")
//			.addClass("info_ment");
//			$("#tcAgreement").focus();
//			return false;
//		} 
//		
//		$(".search_driver").parent().hide();
//		
//		var form = $("<form></form>");
//		form.attr("action","/user/trReserve/insert-trReserve");
//		form.attr("method","post");
//		form.appendTo("body");
//		form.append('<input type="hidden" value='+tcDay+' name="tcDay" />');
//		form.append('<input type="hidden" value='+tcDay2+' name="tcDay2" />');
//		form.append('<input type="hidden" value='+trTrackType+' name="trTrackType" />');
//		form.append('<input type="hidden" value='+trTrackCode+' name="trTrackCode" />');
//		form.append('<input type="hidden" value='+driverArr+' name="driver" />');
//		form.append('<input type="hidden" value='+cVenderArr+' name="cVender" />');
//		form.append('<input type="hidden" value='+cNameArr+' name="cName" />');
//		form.append('<input type="hidden" value='+cNumberArr+' name="cNumber" />');
//		form.append('<input type="hidden" value='+cColorArr+' name="cColor" />');
//		form.append('<input type="hidden" value='+cTypeArr+' name="cType" />');
//		form.append('<input type="hidden" value='+tcPurpose+' name="tcPurpose" />');
//		form.append('<input type="hidden" value='+memPhone+' name="memPhone" />');
//		form.append('<input type="hidden" value='+compPhone+' name="compPhone" />');
//		form.append('<input type="hidden" value='+memEmail+' name="memEmail" />');
//		form.append('<input type="hidden" value='+compAcctName+' name="compAcctName" />');
//		form.append('<input type="hidden" value='+compAcctDept+' name="compAcctDept" />');
//		form.append('<input type="hidden" value='+compAcctEmail+' name="compAcctEmail" />');
//		form.append('<input type="hidden" value='+compAcctPhone+' name="compAcctPhone" />');
//		var inputToken = $('<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />');
//		form.append(inputToken);
//		
//		form.submit();
//		/*
//		console.log("tcDay : |" +tcDay+"|" );
//		console.log("tcDay2 : |" +tcDay2+"|" );
//		console.log("trTrackType : " + trTrackType);
//		console.log("trTrackCode : " + trTrackCode);
//		console.log("driver : " + driverArr);
//		console.log("cVender : " + cVenderArr);
//		console.log("cName : " + cNameArr);
//		console.log("cNumber : " + cNumberArr);
//		console.log("cColor : " +cColorArr );
//		console.log("cType : " + cTypeArr);
//		console.log("tcPurpose : " + tcPurpose);
//		console.log("memPhone : " + memPhone);
//		console.log("compPhone : " +compPhone );
//		console.log("memEmail : " + memEmail);
//		console.log("compAcctName : " + compAcctName);
//		console.log("compAcctDept : " +compAcctDept );
//		console.log("compAcctEmail : " +compAcctEmail );
//		console.log(" compAcctPhone: " + compAcctPhone);
//		console.log(" shopReserve: " + shopReserve);
//		*/
//	});
	
	$("#driverBody tr.on").click(function(){
		if(driver!=""){
			$("#errdriver").text();
		}
	});
	
	$("input[name=cVender]").keyup(function(){
		if($("input[name=cVender]").val()!=""){
			$("#errcVender").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
		}else{
			$("#errcVender").text("차량제조사를 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");;
		}
	});
		
	$("input[name=cName]").keyup(function(){
		/*
		if($("input[name=cVender]").val()!=""){
			$("#errcVender").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
		}else{
			$("#errcVender").text("차량제조사를 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");;
		}
		*/
		if($("input[name=cName]").val()!=""){
			$("#errcVender").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
		}else{
			$("#errcVender").text("모델명을 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");;
		}
	});
	
	$("input[name=cNumber]").keyup(function(){
		/*
		if($("input[name=cVender]").val()!=""){
			$("#errcVender").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
		}else{
			$("#errcVender").text("차량제조사를 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");;
		}
		if($("input[name=cName]").val()!=""){
			$("#errcVender").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
		}else{
			$("#errcVender").text("모델명을 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");;
		}
		*/
		if($("input[name=cNumber]").val()!=""){
			$("#errcVender").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
		}else{
			$("#errcVender").text("차량번호을 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
		}
	});
	
	$("input[name=cColor]").keyup(function(){
		/*
		if($("input[name=cVender]").val()!=""){
			$("#errcVender").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
		}else{
			$("#errcVender").text("차량제조사를 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");;
		}
		if($("input[name=cName]").val()!=""){
			$("#errcVender").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
		}else{
			$("#errcVender").text("모델명을 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");;
		}
		if($("input[name=cNumber]").val()!=""){
			$("#errcVender").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
		}else{
			$("#errcVender").text("차량번호을 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
		}
		*/
		if($("input[name=cColor]").val()!=""){
			$("#errcVender").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
		}else{
			$("#errcVender").text("차량색상을 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
		}
	});
	
	$("#tcPurpose").keyup(function(){
		if($("#tcPurpose").val()!=""){
			$("#errtcPurpose").text("기재한 정보를 바탕으로 예약/승인 검토가 이루어지므로, 시험종류와 방법에 대해 자세히 입력해 주시기 바랍니다.")
			.removeClass("redfont")
		}else{
			$("#errtcPurpose").text("시험 종류 및 방법을 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
		}
	});
	
	$("#memPhone").keyup(function(){
		if(!isNaN($("#memPhone").val()) && $("#memPhone").val().length==11){
			$("#errmemPhone").text();
			$("#errmemPhone").removeClass("redfont");
			$("#errmemPhone").removeClass("info_ment");
		}else{
			$("#errmemPhone").text("휴대폰번호를 형식에 맞게 입력해 주세요.");
			$("#errmemPhone").addClass("redfont");
			$("#errmemPhone").addClass("info_ment");
		}
	});
	$("#compPhone").keyup(function(){
		//alert(telCheck.test($("#compPhone").val()));
		if(telCheck.test($("#compPhone").val()) && $("#compPhone").val().length>= 9 && $("#compPhone").val().length <= 12){
			$("#errcompPhone").text();
			$("#errcompPhone").removeClass("redfont");
			$("#errcompPhone").removeClass("info_ment");
		}else{
			$("#errcompPhone").text("전화번호를 형식에 맞게 입력해 주세요.");
			$("#errcompPhone").addClass("redfont");
			$("#errcompPhone").addClass("info_ment");
		}
	});
	$("#memEmail").keyup(function(){
		if(emailCheck.test($("#memEmail").val()) && $("#memEmail").val() != ""){
			$("#errmemEmail").text("");
			$("#errmemEmail").removeClass("redfont");
			$("#errmemEmail").removeClass("info_ment");
		}else{
			$("#errmemEmail").text("이메일 주소를 형식에 맞게 입력해 주세요.");
			$("#errmemEmail").addClass("redfont");
			$("#errmemEmail").addClass("info_ment");
		}
	});	
	$("#compAcctName").keyup(function(){
		if($("#compAcctName").val()!=""){
			$("#errcompAcctName").text("");
			$("#errcompAcctName").removeClass("redfont");
			$("#errcompAcctName").removeClass("info_ment");
		}else{
			$("#errcompAcctName").text("회계담당자를 입력해 주세요.");
			$("#errcompAcctName").addClass("redfont");
			$("#errcompAcctName").addClass("info_ment");
		}
	});	
	$("#compAcctDept").keyup(function(){
		if($("#compAcctDept").val()!=""){
			$("#errcompAcctDept").text("");
			$("#errcompAcctDept").removeClass("redfont");
			$("#errcompAcctDept").removeClass("info_ment");
		}else{
			$("#errcompAcctDept").text("부서를 입력해 주세요.");
			$("#errcompAcctDept").addClass("redfont");
			$("#errcompAcctDept").addClass("info_ment");
		}
	});	
	$("#compAcctEmail").keyup(function(){
		if(emailCheck.test($("#compAcctEmail").val()) && $("#compAcctEmail").val() != ""){
			$("#errcompAcctEmail").text("");
			$("#errcompAcctEmail").removeClass("redfont");
			$("#errcompAcctEmail").removeClass("info_ment");
		}else{
			$("#errcompAcctEmail").text("이메일을 형식에 맞게 입력해 주세요.");
			$("#errcompAcctEmail").addClass("redfont");
			$("#errcompAcctEmail").addClass("info_ment");
		}
	});
	$("#compAcctPhone").keyup(function(){
		if(telCheck.test($("#compAcctPhone").val()) && $("#compAcctPhone").val()!=""){
			$("#errcompAcctPhone").text("");
			$("#errcompAcctPhone").removeClass("redfont");
			$("#errcompAcctPhone").removeClass("info_ment");
		}else{
			$("#errcompAcctPhone").text("전화번호를 형식에 맞게 입력해 주세요.");
			$("#errcompAcctPhone").addClass("redfont");
			$("#errcompAcctPhone").addClass("info_ment");
		}
	});
	$("#tcAgreement").click(function(){
		if($(':checkbox[name=errtcAgreement]:checked').val() != ""){
			$("#errtcAgreement").text("");
			$("#errtcAgreement").removeClass("redfont");
			$("#errtcAgreement").removeClass("info_ment");
		}else{
			$("#errtcAgreement").text("약관 확인 후 동의해 주셔야 합니다.");
			$("#errtcAgreement").addClass("redfont");
			$("#errtcAgreement").addClass("info_ment");
		}
	});
});