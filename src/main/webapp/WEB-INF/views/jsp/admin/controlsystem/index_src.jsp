<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
	//조회값 undefined -> 공백 처리
	function undefinedChk(str1,str2){
		if( str1 == "" || str1 == null || typeof str1 == undefined || str1 == undefined || ( str1 != null && typeof str1 == "object" && !Object.keys(str1).length ) ){
			return str2;
		}else{
			return str1;
		}
	}
	
	function getToday(){
		var today = new Date();	// 현재 날짜 및 시간
		var date = new Date(new Date().setDate(today.getDate()));	// 30일 후
	    var year = date.getFullYear();
	    var month = ("0" + (1 + date.getMonth())).slice(-2);
	    var day = ("0" + date.getDate()).slice(-2);

	    return year+month+day;
	}
	
	function getNowTime(){
		var today = new Date();
		var hours = ("0" + (1 + today.getHours())).slice(-2); // 시
		var minutes = ("0" + (1 + today.getMinutes())).slice(-2);;  // 분
		var seconds = ("0" + (1 + today.getSeconds())).slice(-2);  // 초
		
		return getToday()+hours+minutes+seconds;
	}
	
	initTrack();
	nowGnr();
	
	//setInterval(function () { initTrack(); }, 3000);
	
	//트랙정보 3초 주기 갱신
	function initTrack(){
		var data = {};
	
		postAjax("/admin/controlsystem/track-info",data,"drawingTrackInfo","", null, null);
	}
	
	//GNR 입차정보 1초 주기 갱신
	function nowGnr(){
		var data ={
			tcDay : getToday()
		};
		
		postAjax("/admin/controlsystem/now-gnr",data,"drawingNowGnr","", null, null);	
	}
	
	function drawingTrackInfo(rows){		
		for(var list in rows){
			if(list=="T003"){
				$("#tr"+list).text(rows["T003"][0]+'('+(parseInt(rows["T003"][1])+parseInt(rows["T010"][1]))+"/"+(parseInt(rows["T003"][2])+parseInt(rows["T010"][2]))+')');
			}else if(list=="T007"){
				$("#tr"+list).text(rows["T007"][0]+'('+(parseInt(rows["T007"][1])+parseInt(rows["T011"][1]))+"/"+(parseInt(rows["T007"][2])+parseInt(rows["T011"][2]))+')');
			}else if(list=="T008"){
				$("#tr"+list).text(rows["T008"][0]+'('+(parseInt(rows["T008"][1])+parseInt(rows["T009"][1]))+"/"+(parseInt(rows["T008"][2])+parseInt(rows["T009"][2]))+')');
			}else if(list=="T004"){
				$("#tr"+list).text('PBN/NVH('+(parseInt(rows["T004"][1])+parseInt(rows["T005"][1]))+"/"+(parseInt(rows["T004"][2])+parseInt(rows["T005"][2]))+')');
			}else if(list=="T005"){
				$("#tr"+list).text('PBN('+rows["T005"][1]+") / NVH("+rows["T004"][1]+')');
			}else if(list=="T009"||list=="T010"||list=="T011"){
				$("#tr"+list).text(rows[list][0]+'('+rows[list][1]+')');
			}else{
				$("#tr"+list).text(rows[list][0]+'('+rows[list][1]+ '/' +rows[list][2]+')');
			}
		}
	}
	
	function drawingNowGnr(resdata){
		var nowGnr = resdata.nowGnr;
		if(nowGnr!=null){
			$("#reserve-code").html(nowGnr.tcReservCode);
			var driverInfo = "";
			driverInfo += undefinedChk(nowGnr.compName,"")+" "+undefinedChk(nowGnr.dname,"");
			driverInfo += " (Lv "+undefinedChk(nowGnr.dlevel,"")+" / ch "+undefinedChk(nowGnr.wch,"") +")";
			$("#driver-info").html(driverInfo);
			var carInfo = "";
			carInfo += undefinedChk(nowGnr.cvender,"")+" "+undefinedChk(nowGnr.cname,"");
			carInfo += " ("+undefinedChk(nowGnr.cnumber,"")+" / "+undefinedChk(nowGnr.ccolor,"")+")";
			$("#car-info").html(carInfo);
			if(nowGnr.ctype=="S"){
				$("#car-type").html("&nbsp;특수");
			}
		}
	}
	
	$(document).on("click",'div[id^=trT]' ,function(){
		var tId = $(this).prop("id").replace("tr", "");
		
		var data ={
			tId : tId,
			tcDay : getToday()
		};
		
		$("#trackcnt").text($("#tr"+tId).text());
		$("#select-track").find("table").prop("id",tId);
		
		postAjax("/admin/controlsystem/resource-condition",data,"drawingDriverCondition","",null,null);
	});
	
	$(document).on("click",'#emergency-msg-send-btn' ,function(){
		var msg = $("#emergency-msg").val().trim();
		
		if(msg==""){
			msg = $("#emergency-sel-msg option:selected").text();
		}

		if(msg == ""){
			alert("송출할 문구를 직접입력 또는 선택해 주세요.");
		}else{			
			var data ={
					msg : msg
			};
			
			postAjax("/admin/controlsystem/kakao-send",data,"successSendMessage","",null,null);
		}
	});
	
	function successSendMessage(resdata){
		alert("비상상황 메세지 송출을 완료하였습니다.");
	}

	$(document).on("click",'button.gate-open' ,function(){
		var name = $(this).parent().find("select").prop("name");
		var kind = $(this).parent().find("select").val();

		if(name.length==0||(kind!="in"&&kind!="out")){
			alert("입력데이터가 정확하지 않아 동작할 수 없습니다.");
		}else{
		  	$.ajax({
		  		url : "/gate/open/"+name+"/"+kind+"",
		  		type : "get",
		  		data : {},
		  		success : function(resdata){
		  			if(resdata.message!="OK"){
		  				alert("(코드이상)정상동작할 수 없습니다.");
		  			}
		  		},
		  		error : function(e){
		  			console.log(e);
		  		}
		  	}); 
		}
	});

	$(document).on("click",'button#detail-in, button#detail-out' ,function(){
		var name = $("#select-track").find("table").prop("id");
		var kind = $(this).prop("id").replace("detail-", "");
		
		if(name.length==0||(kind!="in"&&kind!="out")){
			alert("입력데이터가 정확하지 않아 동작할 수 없습니다.");
		}else{
		  	$.ajax({
		  		url : "/gate/open/"+name+"/"+kind+"",
		  		type : "get",
		  		data : {},
		  		success : function(resdata){
		  			alert(resdata.message);
		  			if(resdata.message!="OK"){
		  				alert("(코드이상)정상동작할 수 없습니다.");
		  			}
		  		},
		  		error : function(e){
		  			console.log(e);
		  		}
		  	});
		}
	});
	
	//테이블 그리는 함수
	function drawingDriverCondition(resdata){
		var rows = resdata.rfidLogList;
		var html='';
		
		if(rows.length==0){
			html+='<tr><td colspan="6">데이터가 존재하지 않습니다.</td></tr>';
		}else{
			for(var list in rows){
				var dName = "";
				var rmWCh = "";
				var cName = "";
				var cColor = "";
				var carInfo = undefinedChk(rows[list].carInfo,"");
				if(undefinedChk(rows[list].driverInfo,"")!=""){
					var driverInfo = rows[list].driverInfo.split("||");
					dName = undefinedChk(driverInfo[0], "");
					rmWCh = undefinedChk(driverInfo[1], "");
					if(rmWCh!="")
						rmWCh = "ch "+ rmWCh;
				}
				if(undefinedChk(rows[list].carInfo,"")!=""){
					var carInfo = rows[list].carInfo.split("||");
					cVender = carInfo[0];
					cName = carInfo[1];
					cColor = carInfo[2];
					cType = carInfo[3];
				}
				html += '<tr>';
				var compName = undefinedChk(rows[list].compName,"");
				html += '	<td>';
				if(compName=="한국타이어"){
					html+= '<span class="redfont">한국타이어</span>'
				}else{
					html += compName;
				}
				html +='</td>';
				var inTime = undefinedChk(rows[list].inTime,"");
				if(inTime!=""){
					inTime = inTime.substring(8,10)+":"+inTime.substring(10,12)+":"+inTime.substring(12,14);
				}
				html += '	<td>'+inTime+'</td>';
				html += '	<td>'+dName+'</td>';
				html += '	<td>'+rmWCh+'</td>';
				html += '	<td>'+cVender+' '+cName;
				if(cType=="S"){
					html += '&nbsp;<span class="redfont">(특수)</span>';	
				}
				html += '</td>';
				html += '	<td>'+cColor+'</td>';
				html += '</tr>';
			}
		}
		
		$("#drivercondition").html(html);
	}
	
	$(document).on("click",'#search-btn' ,function(){
		var dName = $("#dName").val();
		
		if(dName!=""){
			var data ={
				dName : dName,
				tcDay : getToday(),
				currentTime : getNowTime()
			};
			
			postAjax("/admin/controlsystem/search-driver",data,"drawingSearchDriver", "", null, null);
		}
	});
	
	$(document).on("keypress",'#dName' ,function(event){
		 if( event.keyCode == 13 )
			 $("#search-btn").click();
	});

	function controlGate(name, kind){
		var url = "";
		if(name=="all"){	//전체문열림일 경우
			if(kind=="in" || kind=="out"){
				url = "/gates/open/"+kind;
			}else{
				alert("입력데이터가 정확하지 않아 동작할 수 없습니다.");
			}
		}else if(name.indexOf("T")==0&&name.length==4){
			if(kind=="in" || kind=="out"){
				url = "/gate/open/"+name+"/"+kind;
			}else{
				alert("입력데이터가 정확하지 않아 동작할 수 없습니다.");
			}
		}
		var data = {};
		postAjax("/admin/controlsystem/gnr-in-open",data,null,"",null,null);
	}
	
	function drawingSearchDriver(resdata){
		var driverInfo = resdata.driverInfo;
		if(driverInfo==null){			
			$("#search-driver-time").html("00시 00분");
			$("#search-driver-info").html("검색결과 없음");
			$("#search-car-info").html("검색결과 없음");
			$("#search-car-type").html("");
		}else{
			var driverTime = "";
			var inTime = undefinedChk(driverInfo.inTime, "");
			var outTime = undefinedChk(driverInfo.outTime, "");
			if(undefinedChk(driverInfo.tnickName, "")!=""){
				driverTime += "["+driverInfo.tnickName+"] / ";
			}
			if(outTime==""){
				driverTime += inTime.substring(8,10)+"시 "+inTime.substring(10,12)+"분 입차" 
			}else{
				driverTime += outTime.substring(8,10)+"시 "+outTime.substring(10,12)+"분 출차"
			}
			
			$("#search-driver-time").html(driverTime);
			$("#search-driver-info").html(undefinedChk(driverInfo.compName,"")+" "+undefinedChk(driverInfo.dname,"")+" (Lv "+undefinedChk(driverInfo.dlevel,"")+" / ch "+undefinedChk(driverInfo.wch,"") +")");
			var carInfo = "";

			if(undefinedChk(driverInfo.cnumber, "")!=""){
				carInfo += undefinedChk(driverInfo.cvender, "")+" "+ undefinedChk(driverInfo.cname, "");
				carInfo += " ("+undefinedChk(driverInfo.cnumber, "")+" / "+undefinedChk(driverInfo.ccolor, "")+")";
				$("#search-car-info").html(carInfo);
				if(undefinedChk(driverInfo.ctype, "")=="S"){
					$("#search-car-type").html("&nbsp;특수");
				}
			}
		}
	}
</script>
        <div id="container">
            <!-- content -->
            <div class="content">
            	<div id="updateTime"></div>
            	
            	<div id="gateT001" name="gateT001">
		            <select name="T001">
			            <option value="in">IN</option>
			            <option value="out">OUT</option>
		            </select>&nbsp;<button type="button" class="gate-open">OPEN</button>
		            <div id="trT001"></div>
		        </div>
	            <br />------------<br />
	            2 - <div id="trT002"></div>
	            <br />------------<br />
	            3(+) - <div id="trT003"></div>
	            <br />------------<br />
	            4(+) - <div id="trT004"></div>
	            <br />------------<br />
	            5(-3) - <div id="trT005"></div>
	            <br />------------<br />
	            6 - <div id="trT006"></div>
	            <br />------------<br />
	            7 - <div id="trT007"></div>
	            <br />------------<br />
	            8(+) - <div id="trT008"></div>
	            <br />------------<br />
	            9(-8) - <div id="trT009"></div>
	            <br />------------<br />
	            10(-3) - <div id="trT010"></div>
	            <br />------------<br />
	            11 - <div id="trT011"></div>
	            <br />------------<br />
	            12 - <div id="trT012"></div>
	            <br />------------<br />
	            13 - <div id="trT013"></div>
	            <br />------------<br />
	            14 - <div id="trT014"></div>
	            <br />------------<br />
	            15 - <div id="trT015"></div>
	            <br />------------<br />
            </div>
	            <br />------------<br />
            <div id="select-track">
            	<table border="1">
            		<tr>
            			<td id="trackcnt"></td>
            			<td colspan="3">in<button id="detail-in">in open</button></td>
            			<td colspan="2">out<button id="detail-out">out open</button></td>
            		</tr>
            		<tbody id="drivercondition">
            		</tbody>
            	</table>
            </div>
	            <br />------------<br />
	        <div id="nowInput">
	        
	        <button id="gnr-in-open">in open</button>&nbsp;<button id="gnr-out-open">out open</button>
	        예약번호 : <span id="reserve-code"></span><br />
	        평가자 :  <span id="driver-info"></span><br />
	        차량 :  <span id="car-info"></span><span id="car-type" class="redfont"></span>
	        </div>
	            <br />------------<br />
	           <div> 
	            평가자 검색<br />
	            <input type="text" id="dName" name="dName" placeholder="평가자를 입력하세요." autocomplete="off" /><button type="button" id="search-btn">조회</button><br />
	            트랙 출입 시간 : <span id="search-driver-time"></span><br />
	            평가자 : <span id="search-driver-info"></span><br />
	            차량 : <span id="search-car-info"></span><span id="search-car-type" class="redfont"></span>
	           </div>
	            
            <!-- //content -->
        </div>
        
        <frame id="iframe" src="/admin/controlsystem/player" frameborder="0" width="500px" height="500px" scrolling="no"
											marginwidth="0" marginheight="0"></iframe>

	            <br />------------<br />
	            
	    <div>
	    	비상상황<br />
	    	<select id="emergency-sel-msg" name="emergency-sel-msg">
	    		<option value="">비상코드 선택</option>
	    		<c:forEach var="result" items="${emergencyList}" varStatus="status">
	    			<option value="${result.emergencyCode }">${result.emergencyValue }</option>
	    		</c:forEach>
	    	</select>
	    	<br />
	    	<input type="text" id="emergency-msg" name="emergency-msg" placeholder="직접입력 예 화재발생했습니다. 어서대피하세요." /><br />
	    	<button type="button" id="emergency-msg-send-btn">전광판 송출</button><br />
	    	<button type="button" onclick="controlGate('all', 'open')">전체 문열림</button>
	    	<button type="button" onclick="controlGate('all', 'close')">전체 문닫힘</button> 
	    </div>
        <!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>