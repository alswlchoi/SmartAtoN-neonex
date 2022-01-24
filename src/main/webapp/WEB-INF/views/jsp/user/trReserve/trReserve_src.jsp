<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<sec:csrfMetaTags/>

<c:if test="${empty driverList }">
	<script type="text/javascript">	
	$(document).ready(function(){
		alert("승인된 운전자가 없어 예약이 불가능합니다.\n운전자 등록 후 승인 절차를 거치신 후 예약해 주세요.");
		$(document).on("click",'.btn-pop.btn_default.lyClose' ,function(){
			location.href="/user/driver";
		});
	});
	</script>
</c:if>
<c:if test="${!empty driverList }">
<script type="text/javascript">
var datatimeRegexp = RegExp(/^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/);
var emailCheck = RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i); 
var phoneCheck= RegExp(/^[0-9]{11}/);
var telCheck= RegExp(/^[0-9]{9,12}/); 
// 가져온 날짜 형식 변경
function changeDate(str) {
  var y = str.substr(0,4);
  var m = str.substr(4,2);
  var d = str.substr(6,2);
  var date = y+'-'+m+'-'+d;
  return date;
}

function convertDateFormat(date) {
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    month = month >= 10 ? month : '0' + month;
    var day = date.getDate();
    day = day >= 10 ? day : '0' + day;
    return [year, month, day].join('-');
}

var confirmCnt = 0;
var dayOff = new Array();
var shopReserve = new Array();
$(document).ready(function () {	
	$(document).on("click",'#closeDriverBtn' ,function(){
		$("#driverTable").hide();
	});
	
	$(document).on("click",'#closeChargeBtn' ,function(){
		$("#chargeTable").hide();
	});
	
	$(document).on("click",'#confirmBtn' ,function(){	//데이터 유효성 체크
		
		$("#confirmBtn").prop("id", "confirmBtnAfter").addClass("btn_gray");		//중복클릭 방지
	
		var tcDayfromto = $("#tcDay").val().trim();
		var searchFlag = $("#searchFlag").val();
		var tcDayArr = tcDayfromto.split(" ~ ");  
		var tcDay = tcDayArr[0];
		var tcDay2 = tcDayArr[1];
		var trTrackType = "";
		var trTrackCode = "";
		var strackCodeArr = new Array();
		var mtrackCodeArr = new Array();

		for(var i=0; i<$("select[name=strackCode]").length; i++){
			if($("select[name=strackCode] option:selected").eq(i).val()!=""){
				strackCodeArr[i] = $("select[name=strackCode] option:selected").eq(i).val();
			}
		}
		for(var i=0; i<$("select[name=mtrackCode]").length; i++){
			if($("select[name=mtrackCode] option:selected").eq(i).val()!=""){
				mtrackCodeArr[i] = $("select[name=mtrackCode] option:selected").eq(i).val();
			}			
        }
		if(tcDay=="") 
			tcDay = tcDay.trim();
		if(tcDay2=="") 
			tcDay2 = tcDay2.trim();
		if(tcDay==""||tcDay2==""||searchFlag=="N"){
			alert("시험일자를 선택하신 후 조회버튼을 클릭해 주세요.");
			$("#searchBtn").focus();
			$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
			return false;
		}
		if(strackCodeArr==""&&mtrackCodeArr==""){
			alert("시험로를 선택해 주세요.");
			$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
			return false;
		}
		var driverArr = new Array();
		$('#driver li').each(function( index ) {
			var driverId = $(this).attr("id");
			if(driverId!=""){
				driverId = driverId.replace("d", "");
				driverArr[index] = driverId; 
			}
		});
		
		if(driverArr==""){
			alert("운전자를 선택해 주세요.");
			$("#driverBtn").focus();
			$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
			return false;
		}
		var cVenderArr = new Array();
		for(var i=0; i<$("input[name=cVender]").length; i++){
			cVenderArr[i] = $("input[name=cVender]").eq(i).val();
			
			if(cVenderArr[i]==""){
				$("#errcVender").text("차량제조사를 입력해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
				$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
				return false;
			}else{
				$("#errcVender").text("")
				.removeClass("redfont")
				.removeClass("info_ment");
			}
        }
		var cNameArr = new Array();
		for(var i=0; i<$("input[name=cName]").length; i++){
			cNameArr[i] = $("input[name=cName]").eq(i).val();
			
			if(cNameArr[i]==""){
				$("#errcName").text("모델명을 입력해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
				$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
				return false;
			}else{
				$("#errcName").text("")
				.removeClass("redfont")
				.removeClass("info_ment");
			}
        }
		var cNumberArr = new Array();
		for(var i=0; i<$("input[name=cNumber]").length; i++){
			cNumberArr[i] = $("input[name=cNumber]").eq(i).val();
				
			if(cNumberArr[i]==""){
				$("#errcNumber").text("차량번호를 입력해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
				$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
				return false;
			}else{
				$("#errcNumber").text("")
				.removeClass("redfont")
				.removeClass("info_ment");
			}
			
        }
		var cColorArr = new Array();
		for(var i=0; i<$("input[name=cColor]").length; i++){
			cColorArr[i] = $("input[name=cColor]").eq(i).val();
			if(cColorArr[i]==""){
				$("#errcColor").text("차량색상을 입력해 주세요.")
				.addClass("redfont")
				.addClass("info_ment");
				$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
				return false;
			}else{
				$("#errcColor").text("")
				.removeClass("redfont")
				.removeClass("info_ment");
			}
        }

		var cTypeArr = new Array();
		$("input[name=cType]").each (function (index){
        	if($(this).is(":checked") == true) {
				cTypeArr[index] = "S";
			}else{
				cTypeArr[index] = "N";
			}
        });

		var tcPurpose = $("textarea[name=tcPurpose]").val().trim();
		var memPhone = $("input[name=memPhone]").val().trim();
		var compPhone = $("input[name=compPhone]").val().trim();
		var memEmail = $("input[name=memEmail]").val().trim();
		var compAcctName = $("input[name=compAcctName]").val().trim();
		var compAcctDept = $("input[name=compAcctDept]").val().trim();
		var compAcctEmail = $("input[name=compAcctEmail]").val().trim();
		var compAcctPhone = $("input[name=compAcctPhone]").val().trim();
		var tcAgreement = $("#tcAgreement").val();
		
		var driver = '';
		//var shopReserve = Array();
		
		$("button[id^=bcnt]").each(function( index ) {
			if($(this).hasClass("plan")){
				shopReserve[index] = $(this).attr("id").replace("bcnt","");			
			}
		})
		if(tcPurpose==""){
			$("#errtcPurpose").text("시험 종류 및 방법을 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#tcPurpose").focus();
			$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
			return false;
		}
		if(!phoneCheck.test(memPhone) || memPhone==""){
			$("#errmemPhone").text("휴대폰번호를 형식에 맞게 입력해 주세요.");
			$("#errmemPhone").addClass("redfont");
			$("#errmemPhone").addClass("info_ment");
			$("#memPhone").focus();
			$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
			return false;
		}
		if(!telCheck.test(compPhone) || compPhone==""){
			$("#errcompPhone").text("회사전화번호를 형식에 맞게 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#compPhone").focus();
			$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
			return false;
		}
		if(!emailCheck.test(memEmail) || memEmail == ""){
			$("#errmemEmail").text("이메일을 형식에 맞게 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#memEmail").focus();
			$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
			return false;
		}	
		if(compAcctName == ""){
			$("#errcompAcctName").text("회계담당자를 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#compAcctName").focus();
			$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
			return false;
		}	
		if(compAcctDept == ""){
			$("#errcompAcctDept").text("부서를 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#compAcctDept").focus();
			$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
			return false;
		}	
		if(!emailCheck.test(compAcctEmail) || compAcctEmail == ""){
			$("#errcompAcctEmail").text("이메일을 형식에 맞게 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#compAcctEmail").focus();
			$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
			return false;
		}	
		if(!telCheck.test(compAcctPhone) || compAcctPhone==""){
			$("#errcompAcctPhone").text("전화번호를 형식에 맞게 입력해 주세요.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#compAcctPhone").focus();
			$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
			return false;
		}
		if($("input:checkbox[id='tcAgreement']").is(":checked") == false){
			$("#errtcAgreement").text("약관 확인 후 동의해 주셔야 합니다.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#tcAgreement").focus();
			$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
			return false;
		} 
		
		$(".search_driver").parent().hide();

		var data ={
				tcDay : tcDay,
				tcDay2 : tcDay2,
				strackArr : strackCodeArr,
				mtrackArr : mtrackCodeArr,
				driver : driverArr,
				cvender : cVenderArr,
				cname : cNameArr,
				cnumber : cNumberArr,
				ccolor : cColorArr,
				ctype : cTypeArr,
				tcPurpose : tcPurpose,
				memPhone : memPhone,
				compPhone : compPhone,
				memEmail : memEmail,
				compAcctName : compAcctName,
				compAcctDept : compAcctDept,
				compAcctEmail : compAcctEmail,
				compAcctPhone : compAcctPhone,
				shopReserve : shopReserve				
		};
		postAjax("/user/trReserve/insert-trReserve",data,"successReserve","failReserve",null,null);
		
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
	//daterangepiker start
      
    getWeekDay();
    shopPrice();
  	//시험로 selectbox
  	$.ajax({
  		url : "/admin/trReserve/track-list",
  		type : "get",
  		data : {},
  		success : function(resdata){
  			drawSTrackSelect(resdata.trackList);
  			drawMTrackSelect(resdata.trackList);
  			viewCharge(resdata.trackList);
  		},
  		error : function(e){
  			console.log(e);
  		}
  	});    
  });

	function successReserve(data){
		if(data.result > 0){
			location.href="/user/trReserve/success";
		}else{
			$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
			alert(data.message);
		}
	}
	
	function failReserve(data){
		$("#confirmBtnAfter").prop("id", "confirmBtn").removeClass("btn_gray");
		alert(data.message);
	}
	
	var strackHtml='';
	var mtrackHtml='';
	var carHtml = '';
	carHtml += '	<li>';
	carHtml += '	    <div class="form_group w180">';
	carHtml += '	        <input type="text" name="cVender" id="cVender" class="form_control" placeholder="제조사 입력 예) 현대자동차" />';
	carHtml += '	    </div>';
	carHtml += '	    <div class="form_group w180">';
	carHtml += '	        <input type="text" name="cName" id="cName" class="form_control" placeholder="모델입력 예) 제네시스 G80" />';
	carHtml += '	    </div>';
	carHtml += '	    <div class="form_group w200">';
	carHtml += '	        <input type="text" name="cNumber" id="cNumber" class="form_control" placeholder="번호입력 예) 12서1234" />';
	carHtml += '	    </div>';
	carHtml += '	    <div class="form_group w180">';
	carHtml += '	        <input type="text" name="cColor" id="cColor" class="form_control" placeholder="색상입력 예) 그레이 " />';
	carHtml += '	    </div>';
	carHtml += '	    <div class="form_group m-l-4">';
	carHtml += '	        <div class="check_inline">';
	carHtml += '	            <label class="check_default">';
	carHtml += '	                <input type="checkbox" name="cType" value="S" />';
	carHtml += '	                <span class="check_icon"></span>특수차량</label>';
	carHtml += '	        </div>';
	carHtml += '	    </div>';
	carHtml += '	    <button class="btn_delete" style="margin-left:5px"></button>';
	carHtml += '	</li>';
	$("#carul").html(carHtml);
	

	//공동시험로 정보 selectbox 생성
	function drawSTrackSelect(trackList){
		strackHtml +='<li>';
		strackHtml +='<div class="trdiv form_group w170">';
		strackHtml +='<div class="select_group">';
		strackHtml += '<select name="strackCode" id="strackCode" class="trackCode form_control">';
		strackHtml += '<option value="">시험로선택</option>';
		var trackCode = '${trackCode}';
		for(var list in trackList){
			if(parseInt(list)>0){
				strackHtml += '<option value="'+undefinedChk(trackList[list].tid,"")+'"';
				strackHtml += '>'+undefinedChk(trackList[list].tname,"")+' ('+undefinedChk(trackList[list].tlevel,"")+')</option>';
			}
		}
		strackHtml += '</select>';
		strackHtml += '</div>';
		strackHtml += '</div>';
		strackHtml += '<button class="btn_delete" style="margin-left:5px"></button>';	
		strackHtml += '</li>';
	}
	
	//단독시험로 정보 selectbox 생성
	function drawMTrackSelect(trackList){
		mtrackHtml +='<li>';
		mtrackHtml +='<div class="trdiv form_group w170">';
		mtrackHtml +='<div class="select_group">';
		mtrackHtml += '<select name="mtrackCode" id="mtrackCode" class="trackCode form_control">';
		mtrackHtml += '<option value="">시험로선택</option>';
		var trackCode = '${trackCode}';
		for(var list in trackList){
			if(parseInt(list)>0){
				mtrackHtml += '<option value="'+undefinedChk(trackList[list].tid,"")+'"';
				mtrackHtml += '>'+undefinedChk(trackList[list].tname,"")+' ('+undefinedChk(trackList[list].tlevel,"")+')</option>';
			}
		}
		mtrackHtml += '</select>';
		mtrackHtml += '</div>';
		mtrackHtml += '</div>';
		mtrackHtml += '<button class="btn_delete" style="margin-left:5px"></button>';	
		mtrackHtml += '</li>';
	}
	
	function viewCharge(trackList){
		var html = '';
		for(var list in trackList){
			if(list>0){
				html += '<tr>';
				html += '    <td>'+(parseInt(list)+1)+'</td>';
				html += '    <td>'+trackList[list].tname+'&nbsp;('+trackList[list].tnickName+')</td>';
			    html += '    <td>'+comma(undefinedChk(trackList[list].tprice,""))+'</td>';
			    html += '    <td>'+comma(undefinedChk(trackList[list].tpriceadd,""))+'</td>';
			    html += '    <td>'+comma(undefinedChk(trackList[list].tsolo,""))+'</td>';
			    html += '</tr>';
			}
		}
		$("#chargebody").html(html);
	}

	// 전용일 관리 시작 0908
   function setDisable(list){
     if (list.weekday.length > 0) {
       for (var i in list.weekday) {
         var data = list.weekday[i];
         
         var wdDayStr =  data.wdDay
         var now = new Date();
         var daysOfYear = [];
         
         var begin = new Date(changeDate(data.wdStDt));
         var end = new Date(changeDate(data.wdEdDt));

         for (;begin < end; begin.setDate(begin.getDate()+1)) {
        	 if(wdDayStr.indexOf(begin.getDay())<0){
        		 var date = convertDateFormat(begin);
        		 dayOff.push({
                   start: date,
                   end: date
                 });
        	 }
         }
       }
     }
	
     if (list.dayOff.length > 0) {
       for (var i in list.dayOff) {
         var data = list.dayOff[i];
         dayOff.push({
           start: changeDate(data.doStDay),
           end: changeDate(data.doEdDay)
         });
       }
     }
     
     //dayOff.push({
     //    start: "2021-11-12",
     //    end: "2021-11-12"
     //  });
     
     $('#tcDay').daterangepicker({
       //minDate: moment().add(+30, 'day'),
       //startDate: moment().add(+30, 'day'),
       endDate: moment(),
       autoApply: true,
	   autoUpdateInput: false,
       locale: {
           monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
           daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
           yearSuffix: '년',
           separator:" ~ ",
           format: 'YYYY-MM-DD'
         },
       isInvalidDate: function(date) {
         return dayOff.reduce(function (bool, test) {
           console.log(test.start+" | "+test.end);
           //console.log("date : " + moment(date).format('YYYY-MM-DD'));
           return bool || (date>=moment(test.start) && date<=moment(test.end));
         }, false);
       }
     });
     $('#tcDay').on('apply.daterangepicker', function (ev, picker) {
      $("#searchFlag").val("N");
    });
   }
	
	// 0908 start
	function getWeekDay() {
	var param = {
       tcDay: moment().format('YYYYMM')
     };
     asyncPostAjax("/user/trReserve/search-weekday", param,"setDisable", null, null, null);
	} 
	// 0908 end

	//조회값 undefined -> 공백 처리
	function undefinedChk(str1,str2){
		if( str1 == "" || str1 == null || typeof str1 == undefined || str1 == undefined || ( str1 != null && typeof str1 == "object" && !Object.keys(str1).length ) ){
			return str2;
		}else{
			return str1;
		}
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
	
	function getCanDay(){
		var now = new Date();	// 현재 날짜 및 시간
		var date = new Date(new Date().setDate(now.getDate() + 30));	// 30일 후
	    var year = date.getFullYear();
	    var month = ("0" + (1 + date.getMonth())).slice(-2);
	    var day = ("0" + date.getDate()).slice(-2);

	    return year+"-"+month+"-"+day;
	}
	
	$(document).on("click",'#searchBtn' ,function(){
		var tcDays = $("#tcDay").val();
		$("#searchFlag").val("Y");
		if (tcDays==""){
			alert("시험일자를 선택하시고 조회버튼을 클릭해 주세요.");
			return false;
		}else {
			var canday = getCanDay();
			var tcDayArr = tcDays.split(" ~ ");
			var compDt = tcDayArr[0];
			
			//if(canday>compDt) {		
			if(false) {		
				alert("30일 이후부터 시험로 예약이 가능합니다.");
			}else {
				$.ajax({
					url : "/user/trReserve/canday-info",
					type : "get",
					data : {
						"tcDay":tcDays
					},
					success : function(resdata){
						drawingShopTable(resdata);
					},
					error : function(e){
						console.log(e);
					}
				});
			}
		}
	});

	function drawingShopTable(shop) {
		if(undefinedChk(shop, "")!=""){
			for (const [key, value] of Object.entries(shop)) {
				if(key.indexOf("cnt")>-1){
					$("#"+key).text(value);
					if(parseInt(value)>0){
						$("#b"+key).addClass("can_reserve").attr("disabled", false).text("예약가능");
					}else{
						$("#b"+key).removeClass("can_reserve").attr("disabled", true).text("예약불가");						
					}
				}else{
					var shopArr = new Array();
					shopArr = dayOff;
					var wdStDay = "";
					var wdEdDay = "";
					var valueArr = new Array();
				     if (value.length > 0) {
				       for (var i in value) {
				         var data = value[i];
				         shopArr.push({
				           start: changeDate(data),
				           end: changeDate(data)
				         });
				       }
				     }
					if($("#tcDay").val()!=""){
						var tcDays = $("#tcDay").val().split(" ~ ");
						wdStDay = tcDays[0];
						wdEdDay = tcDays[1];
					}
								
					$("input[id="+key+"]").daterangepicker({
                        autoApply: true,
                        singleDatePicker: false,                  // 하나의 달력 사용 여부
                        autoUpdateInput: true,
                        locale: {
                            monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                            daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
                            yearSuffix: '년',
                            separator:" ~ ",
                            format: 'YYYY-MM-DD'
                        },
                        isInvalidDate: function(date) {

                            var resultVal = false;

                            value.every( ( v, i, self ) => {
                              if(v == moment(date).format('YYYYMMDD')){
                                    resultVal = true;
                                }
                                return true;
                            });

                            if(resultVal){
                                return false;
                            }
                            else{
                                return true;
                            }

                        }
                    }).on('apply.daterangepicker',function(e){
                        $(this).val($("#tcDay").val());
                    });
					//daterangepiker end
				}			
			}
		}
	}
	
	//부대시설 예약버튼 클릭시
	$(document).on('click',".can_reserve",function(){
		if(confirmCnt==0){
			alert("선택하신 워크샵동과 시험로 예약을 같이 진행됩니다.");
			confirmCnt++;
		}
		$(this).css({ background:"#6f9cfe" , color:"#fff" })
		.text("예약취소")
		.removeClass("can_reserve")
		.addClass("plan");
	});
	
	//부대시설 예약버튼 클릭시
	$(document).on('click',".plan",function(){
		$(this).css({ background:"#fff" , color:"#000" })
		.text("예약신청")
		.removeClass("plan")
		.addClass("can_reserve");
	});

	  
	function shopPrice() {
		var param = {};
		postAjax("/user/trReserve/price", param, "drawPrice", null, null, null);
	}
	  
	  function drawPrice(list) {
	    var shopHtml = "";
	    if (list.shop.length > 0) {
	      for (var i in list.shop) {
	        var shop = list.shop[i];
	        shopHtml += '<tr>';
	        shopHtml += '<td>'+shop.wsName+'</td>';
	        shopHtml += '<td>'+comma(shop.wsPrice)+'</td>';
	        shopHtml += '</tr>';
	      }
	    } else {
	      shopHtml += '<tr class="tr_nodata">';
	      shopHtml += '<td colspan="2">등록된 정보가 없습니다.</td>';
	      shopHtml += '</tr>';
	    }
	    $("#shopPrice").html(shopHtml);
	  }
  
	//테이블 그리는 함수
	function drawingDriverTable(rows){
		var html='';
		if(rows.length == 0){
			html += '<tr><td colspan="3">';
			html += '검색결과가 없습니다.<br />';
			html += '다시 검색해 주시기 바랍니다.';
			html += '</td></tr>';
		}else{
        
			for(var list in rows){
				html += '<tr onmouseover="this.className=\'on\'" onmouseout="this.className=\'\'">';
				html += '<td><span class="dipy_n" style="display:none">'+undefinedChk(rows[list].dseq,"")+'</span><span class="dn">'+undefinedChk(rows[list].dname,"")+'</span></td>';
				html += '<td>'+undefinedChk(rows[list].dlevel,"")+'</td>';
				html += '<td>'
				if(undefinedChk(rows[list].dedu,"")=="Y"){
					html += '이수';
				}else{
					html += '미이수';
				}
				html += '</td>';
				html += '</tr>';
			}
        }
		$("#driverBody").html(html);
	}

	$(document).on("click",'#dschButton' ,function(){
		var dName = $("#dName").val();
		var dApproval = "Y";

		$.ajax({
			url : "/user/driver/search-driver",
			type : "get",
			data : {
				"dName":dName,
				"dApproval":dApproval
			},
			success : function(resdata){
				drawingDriverTable(resdata.rows);
			},
			error : function(e){
				console.log(e);
			}
		});
	});
	
	$(document).on("click",'#driverBody tr.on' ,function(){	//운전자 선택시 추가
		var currentRow=$(this).closest('tr');
		if(currentRow.find('td:eq(2)').text()=="미이수"){
			$("#errdriverLevel").text("안전교육 미이수자는 등록이 불가능합니다.")
			.addClass("redfont")
			.addClass("info_ment");
			$("#errdriverSelect").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
		//}else if(currentRow.find('td:eq(3)').text()=="미승인"){
		//	alert("미승인 운전자는 등록이 불가능합니다.");			
		}else{
			var dSeq = currentRow.find('td:eq(0) span.dipy_n').text();
			var dName = currentRow.find('td:eq(0) span.dn').text();
			var html = '';
			if($("#d"+dSeq).length > 0){
				$("#errdriverSelect").text(dName+"은(는) 이미 선택하신 운전자입니다.")
				.addClass("redfont")
				.addClass("info_ment");
			}else{
				$("span#errdriverSelect").text("")
				.removeClass("redfont")
				.removeClass("info_ment");
				html += '<li id="d'+dSeq+'" style="font-weight:bold">'+dName+'<button class="dlDriver"></button></li>';
			}
			$(".attachfile_wrap").append(html);
			$("#errdriverLevel").text("")
			.removeClass("redfont")
			.removeClass("info_ment");
		}
	});

	var confirmCnt = 0;
	
	//부대시설 예약버튼 클릭시
	$(document).on('click',".canReserve",function(){
		if(confirmCnt==0){
			alert("선택하신 워크샵동과 시험로 예약을 같이 진행됩니다.");
			confirmCnt++;
		}
		$(this).css({ background:"#6f9cfe" , color:"#fff" })
		.text("예약취소")
		.removeClass("canReserve")
		.addClass("plan");
	});
	
	//부대시설 예약버튼 클릭시
	$(document).on('click',".plan",function(){
		$(this).css({ background:"#fff" , color:"#000" })
		.text("예약신청")
		.removeClass("plan")
		.addClass("canReserve");
	});
	
	$(document).on('click',"#driverBtn",function(){
        setTimeout(function(){
           $(".ly_group").css("background","rgba(0, 0, 0, 0)");
           $(".ly_group").css("position","absolute");
           $(".ly_group").css("top","1240px");
           $(".ly_group").css("left","-100px");
        },10);
     })
     
	$(document).on("click",'.btn_delete' ,function(){	//시험로 html 삭제
		$(this).parent().remove();
	});
	$(document).on("click",'#addTrSBtn' ,function(){	//공동 시험로 html 추가
		$("#strack").append(strackHtml);
	});
	$(document).on("click",'#addTrMBtn' ,function(){	//단독 시험로 html 추가
		$("#mtrack").append(mtrackHtml);
	});
	$(document).on("click",'#addCarBtn' ,function(){	//자동차 추가
		$("#carul").append(carHtml);
	});
	$(document).on("click",'.dlDriver' ,function(){	//운전자 삭제	
		$(this).parent().remove();
	});
</script>
<script type="text/javascript" src="/inc/js/trReserve/reserve.js"></script>
        <!-- container -->
        <div id="container">
            <!-- visual -->
            <div class="visual_sub reservation"></div>
            <!-- //visual -->
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>예약</span><span>시험로 예약</span></div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">시험로 예약</h2>
                <!-- //title -->
                <!-- 검색조건 -->
                <div class="row_reservation">
                    <span class="title">시험일자</span>
                    <div class="form_group w230">
                        <input type="text" id="tcDay" class="form_control dateicon datefromto"
                            placeholder="YYYY-MM-DD ~ YYYY-MM-DD" name="" autocomplete="off" readonly="readonly" />
                    </div>
                    <button type="button" id="searchBtn" class="btn-s btn_default m-l-4">조회</button>
                    <span id="errtcDay" style="padding-left:30px"></span>
                </div>
                <!-- //검색조건 -->
                <!-- 워크샵 예약가능 여부 -->
                <h3 class="stitle m-t-30">워크샵 예약가능 여부</h3>
                <!-- table list -->
		        <c:set value="${fn:length(shopList) }" var="rvCnt" />
                <section class="tbl_wrap_list m-t-10">
                    <table id="shopInfo" class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                        <caption>테이블</caption>
                        <colgroup>
	                	<c:forEach begin="1" end="${rvCnt }" varStatus="status">
		                    <col width="<fmt:formatNumber value="${100 / rvCnt }" pattern="#.##"/>" />
		                    </c:forEach>
		                </colgroup>
                        </colgroup>
                        <thead>
		                <c:set var="currentRvCnt" value="0" />
		                <tr id="wsCodes">
		                <c:forEach var="result" items="${shopList}" varStatus="status">		                	
                           <th scope="col" id="${result.wsCode }">${result.wsName }</th>
		                </c:forEach>
		                </tr>
                        </thead>
                        <tbody>
                            <tr>
                            <c:forEach var="result" items="${shopList}" varStatus="status">
                                <td>
                                    <div class="form_group">
                                        <input type="text" id="${result.wsCode }" class="form_control dateicon datefromto"
                                            name="wssStDay${status.count }" style="width:22px;height:21px;background-position:0;color:#f3f6f9" autocomplete="off" readonly="readonly" />
		                                    
                                            <input type="hidden" name="searchFlag" id="searchFlag" value="N" />
                                    </div>
                                    <div style="display:inline-block;padding:3px 0 10px 0">사용가능일 : <span id="cnt${result.wsCode }">-</span>일</div>
                                    <p><button id="bcnt${result.wsCode }" type="button" class="btn-line-s btn_gray" disabled>예약신청</button></p>
                                </td>
                            </c:forEach>
                            </tr>
                        </tbody>
                    </table>
                </section>
                <!-- //table list -->
                <!-- //워크샵 예약가능 여부 -->

                <!-- 시험유형-공동 -->
                <!-- accordion -->
                <div class="wrap_accordion2 m-t-30">
                    <button id="stbtn" class="accordion open active">
                        <h3 class="stitle disib vam0">시험유형 – 공동</h3>
                        <span class="info_ment_orange">운전자 레벨에 따라 시험로 이용에 제약이 있을 수도 있습니다.</span>
                    </button>
                    <div id="stPanel" class="accordion_panel active m-t-10" style="display: block;">
                        <!-- table_view -->
                        <div class="tbl_wrap_view">
                            <table class="tbl_view01" summary="테이블입니다.">
                                <caption>테이블입니다.</caption>
                                <colgroup>
                                    <col width="180px" />
                                    <col width="" />
                                </colgroup>
                                <tr>
                                    <th scope="row">시험로</th>
                                    <td class="p-t-0">
                                        <ul class="list_test01" id="strack">
                                        	<li>
												<div class="trdiv form_group w170">
													<div class="select_group">
													<select name="strackCode" id="strackCode" class="trackCode form_control">
													<option value="">시험로선택</option>
                                        			<c:forEach var="result" items="${trackList}" varStatus="status">
                                        				<c:if test="${status.index ne 0 }">
														<option value="${result.TId }">${result.TName } (${result.TLevel })</option>
														</c:if>
													</c:forEach>
													</select>
													</div>
												</div>
											</li>                                        	
                                        </ul>
                                        <div class="wrap_btn_test01">
                                            <button type="button" id="addTrSBtn" class="btn-line btn_gray">시험로 +</button>
                                            <button type="button" class="btn_tooltip01 tooltip">
                                                <span class="tooltiptext">
                                                    <p>시험로 추가</p>
                                                    2개 이상 시험로 예약 시 “시험로+ “를 클릭하여 추가가능하며 선택수에 제한은 없습니다. (단, 예약 Capa 한도)
                                                </span>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <!-- //table_view -->
                    </div>
                </div>
                <!-- //accordion -->
                <!-- //시험유형-공동 -->

                <!-- 시험유형-단독 -->
                <!-- accordion -->
                <div class="wrap_accordion2 m-t-30">
                    <button id="mtbtn" class="accordion open active">
                        <h3 class="stitle disib vam0">시험유형 – 단독</h3>
                        <span class="info_ment_orange">11시30분 ~ 13시30분 사이에 예약 시험로에 대해 단독 사용 가능합니다.</span>
                    </button>
                    <div id="mtPanel" class="accordion_panel m-t-10" style="display: block;">
                        <!-- table_view -->
                        <div class="tbl_wrap_view">
                            <table class="tbl_view01" summary="테이블입니다.">
                                <caption>테이블입니다.</caption>
                                <colgroup>
                                    <col width="180px" />
                                    <col width="" />
                                </colgroup>
                                <tr>
                                    <th scope="row">시험로</th>
                                    <td class="p-t-0">
                                        <ul class="list_test01" id="mtrack">
                                        	<li>
												<div class="trdiv form_group w170">
													<div class="select_group">
													<select name="mtrackCode" id="mtrackCode" class="trackCode form_control">
													<option value="">시험로선택</option>
                                        			<c:forEach var="result" items="${trackList}" varStatus="status">
                                        				<c:if test="${status.index ne 0 }">
														<option value="${result.TId }">${result.TName } (${result.TLevel })</option>
														</c:if>
													</c:forEach>
													</select>
													</div>
												</div>
											</li>                            
                                            </li>
                                        </ul>
                                        <div class="wrap_btn_test01">
                                            <button type="button" id="addTrMBtn" class="btn-line btn_gray">시험로 +</button>
                                            <button type="button" class="btn_tooltip01 tooltip">
                                                <span class="tooltiptext">
                                                    <p>시험로 추가</p>
                                                    2개 이상 시험로 예약 시 “시험로+ “를 클릭하여 추가가능하며 선택수에 제한은 없습니다. (단, 예약 Capa 한도)
                                                </span>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <span id="errtrackCode" style="padding-left:30px"></span>
                        <!-- //table_view -->
                    </div>
                </div>
                <!-- //accordion -->
                <!-- //시험유형-단독 -->

                <!-- 시험정보 -->
                <h3 class="stitle m-t-30">시험정보</h3>
                <!-- table_view -->
                <div class="tbl_wrap_view m-t-10">
                    <table class="tbl_view01" summary="시험정보 테이블입니다. 항목으로는 운전자, 시험차종, 시험 종류 및 방법이 있습니다.">
                        <caption>시험정보 테이블</caption>
                        <colgroup>
                            <col width="180px;" />
                            <col width="" />
                        </colgroup>
                        <tr>
                            <th scope="row">운전자<span class="required"></span></th>
                            <td colspan="3">
                                <!-- <div class="form_group w300">
                                    <input type="text" class="form_control" placeholder="운전자 검색" name="" />
                                </div> // -->
                                <button id="driverBtn" type="button" class="btn-line btn_gray" data-layer="search_driver">검색</button>
                                <section class="disib m-l-16">
                                    <ul id="driver" class="attachfile_wrap">
                                    </ul>
                                </section>
                       			<span id="errdriver" style="padding-left:30px"></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">시험차종<span class="required"></span></th>
                            <td colspan="3">
                                <div class="wrap_btn_testcar01">
                                    <button type="button" id="addCarBtn" class="btn-line btn_gray">시험차종 +</button>
                                    <button type="button" class="btn_tooltip01 tooltip">
                                        <span class="tooltiptext">
                                            <p>시험차종 추가</p>
                                            2대 이상 시험차종 입력 시 “시험차종+ “를 클릭하여 추가가능하며 입력 대수에 제한은 없습니다.
                                        </span>
                                    </button>
                                </div>
                                <ul class="list_testcar01 m-t-5" id="carul"><li>
                                        <div class="form_group w180">
                                            <input type="text" name="cVender" class="form_control" placeholder="제조사 입력 예) 현대자동차" />
                                        </div>
                                        <div class="form_group w180">
                                            <input type="text" name="cName" class="form_control" placeholder="모델입력 예) 제네시스 G80" />
                                        </div>
                                        <div class="form_group w200">
                                            <input type="text" name="cNumber" class="form_control" placeholder="번호입력 예) 12서1234" />
                                        </div>
                                        <div class="form_group w180">
                                            <input type="text" name="cColor" class="form_control" placeholder="색상입력 예) 그레이 " />
                                        </div>
                                        <div class="form_group m-l-4">
                                            <div class="check_inline">
                                                <label class="check_default">
                                                    <input type="checkbox" name="cType" value="S" />
                                                    <span class="check_icon"></span>특수차량</label>
                                            </div>
                                        </div>
				                        <span id="errcVender" class="info_ment m-l-0 m-t-5">시험차종의 경우 차량 정보를 입력해 주시기 바랍니다. 예) 제네시스 G80</span>
				                        <span id="errcName"></span>
				                        <span id="errcNumber"></span>
				                        <span id="errcColor"></span>
                                        <div class="wrap_btn_scar01">
                                            <button type="button" class="btn_tooltip01 tooltip">
                                                <span class="tooltiptext">
                                                    <p>특수차량?</p>
                                                    특수차량이란 특수차량이란 특수차량이란 특수차량이란 특수차량이란 특수차량이란 특수차량이란 특수차량이란.
                                                </span>
                                            </button>
                                        </div>
                                    </li>
                                </ul>

                            </td>
                        </tr>
                        <tr>
                            <th scope="row">시험 종류 및 방법<span class="required"></span></th>
                            <td colspan="3">
                                <div class="form_group w669">
                                    <textarea name="tcPurpose" id="tcPurpose" cols="" rows="3" class="form_control"
                                        placeholder="예) 브레이크 제동 시험을 위한 젖은노면에서 시험 운전" onKeyUp="fnChkByte(this,'300')" style="resize: none;"></textarea>
                                </div>
                                <div class="count_txt2"><span id="byteInfo">0</span> / 300 bytes</div>
		                        <div id="errtcPurpose" class="info_ment m-l-0 m-t-5" style="width:100%">기재한 정보를 바탕으로 예약/승인 검토가 이루어지므로, 시험종류와 방법에 대해 자세히 입력해 주시기 바랍니다.</div>
                            </td>
                        </tr>
                    </table>
                </div>
                <!-- //table_view -->
                <!-- //시험정보 -->

                <!-- 예약 신청자 및 회계 담당자 정보 -->
                <h3 class="stitle m-t-30">예약 신청자 및 회계 담당자 정보
                    <!-- <div class="form_group top0">
                        <div class="check_inline">
                            <label class="check_default">
                                <input type="checkbox" name="" value="">
                                <span class="check_icon"></span>변경사항을 회원정보 반영</label>
                        </div>
                    </div> -->
                </h3>
                <!-- table_view -->
                <section class="tbl_wrap_view m-t-10">
                    <table class="tbl_view01" summary="예약 신청자 및 회계 담당자 정보테이블입니다.">
                        <caption>예약 신청자 및 회계 담당자 정보테이블입니다.</caption>
                        <colgroup>
                            <col width="180px" />
                            <col width="421px" />
                            <col width="180px" />
                            <col width="421px" />
                        </colgroup>
                        <tr>
                            <th scope="row">회사명</th>
                            <td>${company.compName }</td>
                            <th>사업자등록번호</th>
                            <td>
						<c:set value="${member.compLicense}" var="compLicense" />
						${fn:substring(company.compLicense,0,3) }-${fn:substring(company.compLicense,3,5) }${fn:substring(company.compLicense,5,8) }</td>
                        </tr>
                        <tr>
                            <th scope="row">신청자</th>
                            <td>${member.memName }</td>
                            <th>부서</th>
                            <td>${member.memDept }</td>
                        </tr>
		                <tr>
		                    <th scope="row">휴대폰 번호</th>
		                    <td>
		                        <div class="form_group w300">
		                        <input type="text" name="memPhone" id="memPhone" class="form_control" placeholder="휴대폰 번호 입력" maxlength="11" onkeypress="numberonly();" value="${member.memPhone }" />
		                        </div>
		                        <span id="errmemPhone"></span>
		                    </td>
		                    <th>전화번호</th>
		                    <td>
		                        <div class="form_group w300">
		                        <input type="text" name="compPhone" id="compPhone" class="form_control" placeholder="전화번호 입력" maxlength="12" onkeypress="numberonly();" value="${member.compPhone }" />
		                        </div>
		                        <span id="errcompPhone"></span>
		                    </td>
		                </tr>
                        <tr>
                            <th scope="row">이메일 주소</th>
                            <td colspan="3">
		                        <div class="form_group w300">
		                            <input type="text" name="memEmail" id="memEmail" class="form_control" placeholder="이메일 주소 입력" value="${member.memEmail }" />
		                        </div>
		                        <span id="errmemEmail"></span>
                            </td>
                        </tr>
		                <tr>
		                    <th scope="row">회계담당자</th>
		                    <td>
		                        <div class="form_group w300">
		                            <input type="text" name="compAcctName" id="compAcctName" class="form_control" placeholder="회계담당자 이름 입력" value="${company.compAcctName }" />
		                        </div>
		                        <div id="errcompAcctName"></div>
		                    </td>
		                    <th>부서</th>
		                    <td>
		                        <div class="form_group w300">
		                            <input type="text" name="compAcctDept" id="compAcctDept" class="form_control" placeholder="부서 입력" value="${company.compAcctDept }" />
		                        </div>
		                        <div id="errcompAcctDept"></div>
		                    </td>
		                </tr>
		                <tr>
		                    <th scope="row">이메일 주소</th>
		                    <td>
		                        <div class="form_group w300">
		                            <input type="text" name="compAcctEmail" id="compAcctEmail" class="form_control" placeholder="이메일 주소 입력" value="${company.compAcctEmail }" />
		                        </div>
		                        <div id="errcompAcctEmail"></div>
		                    </td>
		                    <th>전화번호</th>
		                    <td>
		                        <div class="form_group w300">
		                            <input type="text" name="compAcctPhone" id="compAcctPhone" class="form_control" placeholder="전화번호 입력" maxlength="12" onkeypress="numberonly();" value="${company.compAcctPhone }" />
		                        </div>
		                        <div id="errcompAcctPhone"></div>
		                    </td>
		                </tr>
                    </table>
                </section>
                <!-- //table_view -->
                <!-- //예약 신청자 및 회계 담당자 정보 -->

                <!-- 시험로 이용약관 -->
                <h3 class="stitle m-t-30">시험로 이용약관</h3>
                <!-- accordion -->
                <div class="wrap_accordion2 m-t-10">
                    <button class="accordion">
                        <h3 class="stitle disib vam0">이용약관 보기</h3>
                    </button>
                    <div class="accordion_panel">
                        <div class="box_txt03">이용약관 내용</div>
                    </div>
                </div>
                <!-- //accordion -->
                <!-- //시험로 이용약관 -->

                <section class="m-t-20 tac">
                    <div class="line01"></div>
                    <div class="form_group top0">
                        <div class="check_inline">
                            <label class="check_default">
                                <input type="checkbox" name="tcAgreement" id="tcAgreement" value="Y" />
                                <span class="check_icon"></span>시험로 이용약관을 확인 및 동의하며 상기 주행시험장 사용을 신청합니다.</label>
                        </div>
                    </div>
                    <br />
                    <br />                    
            		<div id="errtcAgreement"></div>
                </section>
            	

                <!-- button -->
                <section class="tac m-t-50">
                    <button type="button" id="viewChargeBtn" class="btn btn_default fl" data-layer="charge">요금표 보기</button>
                    <button type="button" id="cancelBtn" class="btn btn_gray m-r-11">취소</button>
                    <button type="button" id="confirmBtn" class="btn btn_default">확인</button>
                </section>
                <!-- //button -->

            </div>
            <!-- //content -->
        </div>
        <!-- //container -->

    <!-- popup_l -->
    <div id="driverTable" class="ly_group">
        <article class="layer_l search_driver">
            <!-- # 타이틀 # -->
            <h1>운전자 검색</h1>
            <!-- # 컨텐츠 # -->
            <div class="ly_con">
                <p class="tac">운전자 이름으로 검색 선택 또는 목록에서 선택해 주세요</p>
                <section class="tac m-t-10">
                    <div class="form_group w200">
                        <input type="text" name="dName" id="dName" class="form_control" placeholder="운전자명 입력" name="" />
                    </div>
                    <button type="button" id="dschButton" class="btn-line btn_gray">검색</button>
                </section>
                <!-- table list -->
                <section class="tbl_wrap_list m-t-20">
                    <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                        <caption>테이블</caption>
                        <colgroup>
                            <col width="180px" />
                            <col width="180px" />
                            <col width="" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col">운전자명</th>
                                <th scope="col">운전자 레벨</th>
                                <th scope="col">안전교육이수여부</th>
                            </tr>
                        </thead>
                    </table>
                </section>
                <section class="tbl_wrap_list pop_scroll_250 border-t-0">
                    <table class="tbl_list" summary="운전자 테이블 입니다. 항목으로는 운전자명, 운전자 레벨, 안전교육이수여부등이 있습니다">
                        <caption>운전자 테이블 테이블</caption>
                        <colgroup>
                            <col width="180px" />
                            <col width="180px" />
                            <col width="" />
                        </colgroup>
                        <tbody id="driverBody">
					    	<c:if test="${empty driverList }">
					    	<tr>
                                <td colspan="3">검색결과가 없습니다.<br />
                                다시 검색해 주시기 바랍니다.</td>
                            </tr>
					    	</c:if>
					    	<c:if test="${!empty driverList }">
							 <c:forEach var="result" items="${driverList}" varStatus="status">
                            <tr onmouseover="this.className='on'" onmouseout="this.className=''">
                                <td><span class="dipy_n" style="display:none">${result.DSeq }</span><span class="dn">${result.DName }</span></td>
                                <td>${result.DLevel }</td>
                                <td><c:if test="${result.DEdu eq 'Y'}">이수</c:if><c:if test="${result.DEdu eq 'N'}">미이수</c:if></td>
                            </tr>
						    </c:forEach>
						   </c:if>
                        </tbody>
                    </table>
                    <span id="errdriverLevel" class="m-t-10"></span>
                    <span id="errdriverSelect" class="m-t-10"></span>
                </section>
                <!-- //table list -->
            </div>
            <!-- # 닫기버튼 # -->
            <button id="closeDriverBtn" data-fn="lyClose">레이어닫기</button>
        </article>
    </div>
    <!-- //popup_l -->

    <!-- popup_xxl -->
    <div class="ly_group">
        <article id="printarea" class="layer_xxl charge printarea">
            <!-- # 타이틀 # -->
            <h1 class="hidetag">요금표 보기</h1>
            <!-- # 컨텐츠 # -->
            <div class="ly_con">
                <h2>주행 시험장 요금표<button type="button" class="btn-line btn_gray hidetag" onclick="print()">인쇄</button></h2>

                <h3 class="stitle m-t-57">워크샵 사용료<span class="fsd fr m-t-4">(단위:원, VAT 별도)</span></h3>
                <!-- table list -->
                <section class="tbl_wrap_list m-t-10">
                    <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                        <caption>테이블</caption>
                        <colgroup>
                            <col width="770px" />
                            <col width="" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col">구분</th>
                                <th scope="col">월 임대료</th>
                            </tr>
                        </thead>
                        <tbody id="shopPrice">
                        </tbody>
                    </table>
                    <span class="info_ment m-l-0 m-t-10">상기 금액 내 시설유지관리비 및 수도광열비 포함.</span>
                </section>
                <!-- //table list -->

                <h3 class="stitle m-t-30">시험로 사용료<span class="fsd fr m-t-4">(단위:원, VAT 별도)</span></h3>
                <!-- table list -->
                <section class="tbl_wrap_list m-t-10">
                    <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                        <caption>테이블</caption>
                        <colgroup>
                            <col width="" />
                            <col width="" />
                            <col width="" />
                            <col width="" />
                            <col width="" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th rowspan="2" scope="col">번호</th>
                                <th rowspan="2" scope="col">구분 (명칭 및 약어)</th>
                                <th colspan="2" scope="col" class="border-b-1">공동 사용 (1대당)</th>
                                <th scope="col" class="border-b-1">단독사용</th>
                            </tr>
                            <tr>
                                <th scope="col" class="border-l-1">기본 4시간</th>
                                <th scope="col">추가 1시간</th>
                                <th scope="col">1시간</th>
                            </tr>
                        </thead>
                        <tbody id="chargebody">
                        </tbody>
                    </table>
                    <span class="info_ment m-l-0 m-t-10 disb">상기 금액 내 시설유지관리비 포함.</span>
                    <span class="info_ment m-l-0 m-t-5 disb">복수 시험로 사용 시 높은 단가의 시험로 요금이 적용되며 사용시간 초과시 1시간 단위로 과금되니 이용에
                        참고바랍니다.</span>
                </section>
                <!-- //table list -->
                <section class="footer_estimate m-t-45">
                    <span class="info_ment_orange m-l-0 m-t-6">상기 요금내용은 참고용이며, 공식문서로 사용될 수 없습니다.</span>
                    <img src="/inc/images/ci_hankook_estimate.png" alt="Hankook" />
                </section>

            </div>
            <!-- # 닫기버튼 # -->
            <button id="closeChargeBtn" data-fn="lyClose">레이어닫기</button>
        </article>
    </div>
    <!-- //popup_xxl -->
</c:if>

<!-- 아코디언 -->
<script type="text/javascript">
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

    //인쇄하기
    function print() {
      $(".hidetag").hide();
      var divToPrint=document.getElementById('printarea');
      var newWin=window.open('','Print-Window');
      newWin.document.open();
      newWin.document.write('<html><link rel="stylesheet" type="text/css" href="/inc/css/default.css"><link rel="stylesheet" type="text/css" href="/inc/css/common.css"><link rel="stylesheet" type="text/css" href="/inc/css/font.css"><link rel="stylesheet" type="text/css" href="/inc/css/layout.css"><link rel="stylesheet" type="text/css" href="/inc/css/daterangepicker.css"><link rel="stylesheet" type="text/css" href="/inc/css/jquery-ui.css"><body onload="setTimeout(function(){window.print();},500)" style="width:1000px;height:auto;">'+divToPrint.innerHTML+'</body></html>');
      newWin.document.close();
      setTimeout(function(){newWin.close();},1000);
      $(".hidetag").show();
    }
</script>
<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>