<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>

<spring:eval var="ifserver" expression="@environment.getProperty('environments.ifserver')" />

<sec:csrfMetaTags/>
<script type="text/javascript">

    $(document).ready(function () {
        driverSearch(1);
        $(document).on("click","#pagingc>span>.pageNo",function(){
            driverSearch($(this).attr("data-page"));
        });
        $("#dName").focus(function() {
            $("#search-btn").click();
        });
    });

    var ifserver = "${ifserver}";
    $(".lodingdimm").removeClass("lodingdimm");
    var trackInfoArr = {};

    $(document).on("click","[title='more']",function(event){
        weatherApi2();
        $("button[data-layer='popup_weather']").click();
        $("#defaultOpen").addClass();
    })

    function showtime(){
        setTimeout(getTime, 1000);	//1000밀리초(1초) 마다 반복
    }

    function getTime() {
        var d = new Date();	// 현재 날짜와 시간
        var month = ("0" + (1 + d.getMonth())).slice(-2);
        var day = ("0" + d.getDate()).slice(-2);
        var hur = d.getHours();		// 시
        var min = d.getMinutes();	//분
        var sec = d.getSeconds();	//초

        var update_time = document.getElementById("update_time"); // 값이 입력될 공간

        var time = month+"."+day+" "+hur + ":" + min + ":" + sec + " 갱신";	// 형식 지정

        update_time.innerHTML = time;	// 출력

        setTimeout(getTime, 1000);	//1000밀리초(1초) 마다 반복
    }

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
        var minutes = ("0" + (1 + today.getMinutes())).slice(-2);  // 분
        var seconds = ("0" + (1 + today.getSeconds())).slice(-2);  // 초

        return getToday()+hours+minutes+seconds;
    }

    //트랙정보 3초 주기 갱신
    function initTrack(){
        var data = {};

        postAjax("/admin/controlsystem/track-info",data,"drawingTrackInfo","", null, null);
    }

    function nowGnr(){
        var data ={
            tcDay : getToday()
        };

        postAjax("/admin/controlsystem/now-gnr",data,"drawingNowGnr","", null, null);
    }

    function drawingTrackInfo(rows){
        for(var list in rows){
            trackInfoArr[list] = rows[list][0];
            if(list=="T003"){
                $("#tr"+list).html(rows["T003"][0]+' (<span class="color_bule2">'+(parseInt(rows["T003"][1])+parseInt(rows["T010"][1]))+'</span>/<span class="color_red2">'+(parseInt(rows["T003"][2])+parseInt(rows["T010"][2]))+'</span>)');
            }else if(list=="T007"){
                $("#tr"+list).html(rows["T007"][0]+' (<span class="color_bule2">'+(parseInt(rows["T007"][1])+parseInt(rows["T011"][1]))+'</span>/<span class="color_red2">'+(parseInt(rows["T007"][2])+parseInt(rows["T011"][2]))+'</span>)');
            }else if(list=="T008"){
                $("#tr"+list).html(rows["T008"][0]+' (<span class="color_bule2">'+(parseInt(rows["T008"][1])+parseInt(rows["T009"][1]))+'</span>/<span class="color_red2">'+(parseInt(rows["T008"][2])+parseInt(rows["T009"][2]))+'</span>)');
            }else if(list=="T004"){
                $("#tr"+list).html('PBN/NVH (<span class="color_bule2">'+(parseInt(rows["T004"][1])+parseInt(rows["T005"][1]))+'</span>/<span class="color_red2">'+(parseInt(rows["T004"][2])+parseInt(rows["T005"][2]))+'</span>)');
            }else if(list=="T005"){
                $("#tr"+list).html('PBN('+rows["T005"][1]+')/NVH('+rows["T004"][1]+')');
            }else if(list=="T009"||list=="T010"||list=="T011"){
                $("#tr"+list).html(rows[list][0]+' ('+rows[list][1]+')');
            }else{
                $("#tr"+list).html(rows[list][0]+' (<span class="color_bule2">'+rows[list][1]+ '</span>/<span class="color_red2">' +rows[list][2]+'</span>)');
            }
        }
    }

    function drawingNowGnr(resdata){
        var nowGnr = resdata.nowGnr;

        $(".now-gnr-count").html(resdata.nowGnrCount);
        if(nowGnr!=null&&nowGnr.tcReservCode!=null){
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
        }else{
            $("#reserve-code").html("현재 진입차량이 없습니다.");
            $("#driver-info").html("");
            $("#car-info").html("");
        }
    }

    $(document).on("click",'p[id^=trT]' ,function(){
        var tId = $(this).prop("id").replace("tr", "");

        var data ={
            tId : tId,
            tcDay : getToday()
        };

        $("#trackcnt").html($("#tr"+tId).html());
        $("#select-track").find("table").prop("id",tId);

        postAjax("/admin/controlsystem/resource-condition",data,"drawingDriverCondition","",null,null);
    });

    $(document).on("change",'#emergency-sel-msg' ,function(){
        $("#emergency-msg").val($("#emergency-sel-msg option:selected").text());
    });

    //전광판
    $(document).on("click",'#emergency-msg-send-btn' ,function(){
        var msg = $("#emergency-msg").val().trim();

        if(msg=="" && $("#emergency-sel-msg option:selected").val()!=""){
            msg = $("#emergency-sel-msg option:selected").text();
        }

        if(msg == ""){
            $("#errEmergencyMsg").text("비상문구 선택 또는 직접입력해 주세요.")
                .addClass("info_ment")
                .addClass("redfont");
        }else{
            var data ={
                message : msg
            };

            postAjax(ifserver+"/billboard/send",data,"successSendMessage","kakaoSend",null,null);
        }
    });

    //알림톡
    $(document).on("click",'#kakao-msg-send-btn' ,function(){
        var msg = $("#emergency-msg").val().trim();

        if(msg=="" && $("#emergency-sel-msg option:selected").val()!=""){
            msg = $("#emergency-sel-msg option:selected").text();
        }

        if(msg == ""){
            $("#errEmergencyMsg").text("비상문구 선택 또는 직접입력해 주세요.")
                .addClass("info_ment")
                .addClass("redfont");
        }else{
            console.log(msg);
            var data ={
                message : msg
            };
            console.log(data);
            //postAjax(ifserver+"/billboard/send",data,"successSendMessage","kakaoSend",null,null);
            postAjax("/user/userShop/test", data, "successSendMessage", "successSendMessage", null, null)
        }
    });

    function successSendMessage(resdata){
        //console.log(resdata);
        if(resdata != ""){
            $("#errEmergencyMsg").text("");
            $("#billboard-msg-result").text("비상상황 알림을 완료하였습니다.");
        }else{
            $("#billboard-msg-result").text(resdata);
        }
    }

    function kakaoSend(resdata){
        //console.log("kakao"+resdata)
        var msg = $("#emergency-msg").val().trim();
        var data ={
            message : msg
        };

        postAjax("/admin/controlsystem/kakao-send",data,"successSendMessage","failSendMessage",null,null);
    }

    function failSendMessage(resdata){
        if(resdata.msg=="OK"){
            $("#errEmergencyMsg").text("");
            $("#billboard-msg-result").text("비상상황 알림을 완료하였습니다.");
        }else{
            $("#billboard-msg-result").text(resdata.msg);
        }
    }

    //일반 시험로(in/out) open 전용
    $(document).on("click",'button.gate-open' ,function(){
        var name = $(this).parent().find("select").prop("name");
        var inOut = $(this).parent().find("select").val();
        var url = ifserver+"/gate/open/"+name+"/"+inOut+"";
        //console.log("url : " + url);

        $.ajax({
            url : url,
            type : "get",
            data : {},
            success : function(resdata){
                if(resdata.message!="OK"){
                    alert("(코드이상)정상동작할 수 없습니다.");
                }
            },
            error : function(e){
                alert("통신문제로 GATE를 제어할 수 없습니다.");
            }
        });

    });

    //선택한 시험로(in/out) 하단 Gate open 전용
    $(document).on("click",'button#detail-in, button#detail-out' ,function(){
        var name = $("#select-track").find("table").prop("id");
        var kind = $(this).prop("id").replace("detail-", "");
        var url = ifserver+"/gate/open/"+name+"/"+kind;

        if(name.length==0||(kind!="in"&&kind!="out")){
            alert("상단에서 시험로를 선택해 주세요.");
        }else{
            //console.log(url);

            $.ajax({
                url : url,
                type : "get",
                data : {},
                success : function(resdata){
                    if(resdata.message!="OK"){
                        alert("(코드이상)정상동작할 수 없습니다.");
                    }
                },
                error : function(e){
                    alert("통신문제로 GATE를 제어할 수 없습니다.");
                }
            });

        }
    });

    function controlGate(name, openClose, inOut, num){
        var url = ifserver;
        console.log("자동 제어 시작=====");
        if(inOut=="in"){
            url += "/gate/"+openClose+"/"+name+"/in";
        }else if(inOut=="out"){
            if(num=="2"){
                url += "/gate/"+openClose+"/"+name+"/out2";
            }else{
                url += "/gate/"+openClose+"/"+name+"/out";
            }
        }

        console.log(name + " : " + url);

        $.ajax({
            url : url,
            type : "get",
            data : {},
            success : function(resdata){
                if(resdata.message!="OK"){
                    alert("(코드이상)정상동작할 수 없습니다.");
                }else{
                    if(name=="T000"){
                        updateInTime();
                    }
                }
            },
            error : function(e){
                alert(e.responseJSON.errorCode)
            }
        });
    }

    function controlGatePopup(name, openClose, inOut, num, el){
        $("#msg-kind").text("").removeClass("info_ment").removeClass("redfont");
        var url = ifserver;
        var kind = $("input:radio[name=kind]:checked").val();
        if(kind=="b" && openClose=="open" && name != "T999"){		//자동 제어 시작(일반)
            console.log("자동 제어 시작(일반)=====");
            console.log("name : " + name, ", openClose : " + openClose, ", inOut : " + inOut, ", num : " + num);
            if(inOut=="in"){
                url += "/gate/"+openClose+"/"+name+"/in";
            }else if(inOut=="out"){
                if(num=="2"){
                    url += "/gate/"+openClose+"/"+name+"/out2";
                }else{
                    url += "/gate/"+openClose+"/"+name+"/out";
                }
            }
            //console.log(url);

            $.ajax({
                url : url,
                type : "get",
                data : {},
                success : function(resdata){
                    if(resdata.message!="OK"){
                        $("#msg-kind").text("(코드이상)GATE를 열 수 없습니다.").addClass("info_ment").addClass("redfont");
                    }
                },
                error : function(e){
                    $("#msg-kind").text("통신문제로 GATE를 제어할 수 없습니다.").addClass("info_ment").addClass("redfont");
                }
            });
        }else{	//한국타이어(수동)
            console.log("수동 제어 시작=====");
            console.log("name : " + name, ", openClose : " + openClose, ", inOut : " + inOut, ", num : " + num);
            data = {
                trackId : name
            }

            if(inOut=="in"){
                url += "/gate/"+openClose+"/in";
            }else if(inOut=="out"){
                if(num=="2"){
                    url += "/gate/"+openClose+"/out2";
                }else{
                    url += "/gate/"+openClose+"/out";
                }
            }

            console.log("trackId : " + name, "url : " + url);
            postAjax(url,data,"","gatePopupFail",null,null);

            if($('#control_popup').css('display') == "block"){
                if(openClose=="open"){
                    if (el.classList.contains("btn_default")) {
                        el.classList.remove("btn_default");
                        el.classList.add("btn_gray");
                    }
                }else{
                    var pre_el = el.previousElementSibling;

                    if (pre_el.classList.contains("btn_gray")) {
                        pre_el.classList.remove("btn_gray");
                        pre_el.classList.add("btn_default");
                    }
                }
            }
        }
    }

    $(document).on("click",'#btn-all-open, #btn-all-close' ,function(){
        var data = {}
        var openClose = $(this).prop("id").replace("btn-all-", "");

        postAjax(ifserver+"/gates/"+openClose+"/in",data,"drawingInGateResult", "drawingInGateFail", null, null);
        postAjax(ifserver+"/gates/"+openClose+"/out",data,"drawingOutGateResult", "drawingOutGateFail", null, null);
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
                    var driverInfo = rows[list].driverInfo.split("#div#");
                    dName = undefinedChk(driverInfo[0], "");
                    rmWCh = undefinedChk(driverInfo[1], "");
                    if(rmWCh!="")
                        rmWCh = "ch "+ rmWCh;
                }
                if(undefinedChk(rows[list].carInfo,"")!=""){
                    var carInfo = rows[list].carInfo.split("#div#");
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

    function driverSearch(page){
        var dName = $("#dName").val();
        if(dName==""){
            var data ={
                pageNo: page,
                text : dName
            };
            postAjax("/admin/controlsystem/search-driver-popup",data,"SearchDriverPopup", "", null, null);
        }
    };

    function SearchDriverPopup(resdata){
        console.log(resdata);
        console.log(resdata.paging);
        $("#indexP").html("");
        var indexHtml = "";
        if(resdata.driverInfo.length > 0){
            for(var i in resdata.driverInfo) {
                var driverInfo = resdata.driverInfo[i];
                indexHtml += '<tr>';
                indexHtml += '<td>';
                indexHtml += '<div class="form_group single">';
                indexHtml += '<div class="check_inline">';
                indexHtml += '<label class="check_default single">';
                indexHtml += '<input type="checkbox" name="indexChk" value="'+driverInfo.dName+'">';
                indexHtml += '<span class="check_icon"></span></label>';
                indexHtml += '</div>';
                indexHtml += '</div>';
                indexHtml += '</td>';
                indexHtml += '<td>'+driverInfo.dName+'</td>';
                indexHtml += '</tr>';
            }
        } else {
            indexHtml += '<tr class="tr_nodata">';
            indexHtml += '<td colspan="3">등록된 정보가 없습니다.</td>';
            indexHtml += '</tr>';
        }

        $("#indexP").html(indexHtml);
        drawingPage(resdata.paging);

        $("input:checkbox[name='indexChk']").click(function(){
            if($(this).prop("checked")){
                $("input:checkbox[name='indexChk']").prop("checked",false);
                $(this).prop("checked",true);
            }
        });
    }

    function putChk() {
        if ($("input:checkbox[name='indexChk']:checked").val() == null) {
            alert3("선택된 평가자가 없습니다.");
            return;
        }
        $("#dName").val($("input:checkbox[name='indexChk']:checked").val());
        $(".lyClose").click();

        var dName = $("#dName").val();
        var data ={
            dName : dName,
            tcDay : getToday(),
            currentTime : getNowTime(),
            tcDay : getToday()
        };
        console.log(data);
        postAjax("/admin/controlsystem/search-driver",data,"drawingSearchDriver", "", null, null);
    }

    $(document).on("keypress",'#dName' ,function(event){
        if( event.keyCode == 13 )
            $("#search-btn").click();
    });

    /*
    $(document).on("click",'input:radio[name=kind]' ,function(){
        var kind = $("input:radio[name=kind]:checked").val();
        if(kind=="b"){
            $("#msg-kind").text("한국타이어 : 자동으로 차단기 닫힘").removeClass("redfont");
        }else{
            $("#msg-kind").text("현대자동차 : 자동으로 닫히지 않음(닫힘 실행바람)").addClass("redfont");
        }
    });
    */

    function gatePopupFail(){
        if($('#control_popup').css('display') == "none"){
            alert("통신문제로 GATE를 제어할 수 없습니다.");
        }else{
            $("#msg-kind").text("통신문제로 GATE를 제어할 수 없습니다.").addClass("info_ment").addClass("redfont");
        }
    }

    function updateInTime(){
        var data = {};
        postAjax("/admin/controlsystem/gnr-in-open",data,null,"",null,null);
    }

    function drawingSearchDriver(resdata){
        var driverInfo = resdata.driverInfo;
        if(driverInfo==null){
            $("#search-driver-time").html("검색결과가 없습니다.");
            $("#search-driver-info").html("");
            $("#search-car-info").html("");
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

    function drawingInGateResult(resdata){
        var success = undefinedChk(resdata.success,"");
        var fail = undefinedChk(resdata.fail,"");
        var successTrack = "";
        var failTrack = "";

        for(var list in success){
            var trCode = success[list].replace("-IN","");
            if(trCode!=""){
                successTrack += trackInfoArr[trCode]+" ";
            }
        }

        for(var list in fail){
            var trCode = fail[list].replace("-IN","");
            if(trCode!=""){
                failTrack += trackInfoArr[trCode]+" ";
            }
        }
        var msg = "성공(IN) : " + successTrack + "<br />실패(IN)" + failTrack;
        $("#emergency-msg-in-result").html(msg);
    }

    function drawingOutGateResult(resdata){
        var success = undefinedChk(resdata.success,"");
        var fail = undefinedChk(resdata.fail,"");
        var successTrack = "";
        var failTrack = "";

        for(var list in success){
            var trCode = success[list].replace("-OUT","");
            if(trCode!=""){
                successTrack += trackInfoArr[trCode]+" ";
            }
        }

        for(var list in fail){
            var trCode = fail[list].replace("-OUT","");
            if(trCode!=""){
                failTrack += trackInfoArr[trCode]+" ";
            }
        }
        var msg = "성공(OUT) : " + successTrack + "<br />실패(OUT)" + failTrack;
        $("#emergency-msg-out-result").html(msg);
    }

    function drawingInGateFail(resdata){
        var msg = "실패(IN) : 전체 문열림에 실패하였습니다.";
        $("#emergency-msg-in-result").html(msg);
    }

    function drawingOutGateFail(resdata){
        var msg = "실패(OUT) : 전체 문열림에 실패하였습니다.";
        $("#emergency-msg-out-result").html(msg);
    }

    $(document).on("click",'#winAllGate' ,function(){
        $("input:radio[name=kind]").eq(0).prop("checked", true);
    });

    initTrack();
    nowGnr();

    setInterval(function () { initTrack();getTime(); }, 3000);
    setInterval(function () { nowGnr(); }, 1000);

    function openTab(evt, tabName) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("tabcontent");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablinks");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(tabName).style.display = "block";
        evt.currentTarget.className += " active";
    }
    // Get the element with id="defaultOpen" and click on it
    $("#defaultOpen").click();
</script>
<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>통합관제시스템</span></div>
        <!-- //breadcrumb -->
        <!-- wrap_left -->
        <div class="wrap_left">
            <!-- title -->
            <h2 class="title m-b-25">통합관제시스템<button type="button" class="btn-line btn_gray fr"
                                                    data-layer="popup_GControl">차단기 제어
                (전체)</button>
            </h2>
            <!-- //title -->

            <div class="wrap_track">
                <p>주행로별 CAPA (<span class="color_bule2">진입</span>/<span class="color_red2">MAX</span>)</p>

                <div class="box_state01 ride">
                    <p id="trT006">Ride</p>
                    <div class="row m-t-10">
                        <div class="form_group w70">
                            <div class="select_group">
                                <select name="T006" title="select" class="form_control">
                                    <option value="in">IN</option>
                                    <option value="out">OUT</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="btn-line-s btn_gray w53 gate-open">OPEN</button>
                    </div>
                    <div class="box_text m-t-7"></div>
                </div>

                <div class="box_state01 braking">
                    <p id="trT003">Braking</p>
                    <div class="row m-t-10">
                        <div class="form_group w70">
                            <div class="select_group">
                                <select name="T003" title="select" class="form_control">
                                    <option value="in">IN</option>
                                    <option value="out">OUT</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="btn-line-s btn_gray w53 gate-open">OPEN</button>
                    </div>
                    <div id="trT010" class="box_text m-t-7">Hyd-Straight (1)</div>
                </div>

                <div class="box_state01 vda">
                    <p id="trT002">VDA</p>
                    <div class="row m-t-10">
                        <div class="form_group w70">
                            <div class="select_group">
                                <select name="T002" title="select" class="form_control">
                                    <option value="in">IN</option>
                                    <option value="out">OUT</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="btn-line-s btn_gray w53 gate-open">OPEN</button>
                    </div>
                    <div class="box_text m-t-7"></div>
                </div>

                <div class="box_state01 pbn">
                    <p id="trT004">PBN/NVH</p>
                    <div class="row m-t-10">
                        <div class="form_group w70">
                            <div class="select_group">
                                <select name="T004" title="select" class="form_control">
                                    <option value="in">IN</option>
                                    <option value="out">OUT</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="btn-line-s btn_gray w53 gate-open">OPEN</button>
                    </div>
                    <div id="trT005" class="box_text m-t-7">PBN(1) / NVH(1)</div>
                </div>

                <div class="box_state01 whc">
                    <p id="trT007">WHC (<span class="color_bule2">4</span>/<span class="color_red2">12</span>)</p>
                    <div class="row m-t-10">
                        <div class="form_group w70">
                            <div class="select_group">
                                <select name="T007" title="select" class="form_control">
                                    <option value="in">IN</option>
                                    <option value="out">OUT</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="btn-line-s btn_gray w53 gate-open">OPEN</button>
                    </div>
                    <div id="trT011" class="box_text m-t-7">Hyd-Curve (1)</div>
                </div>

                <div class="box_state01 hso">
                    <p id="trT001">HSO</p>
                    <div class="row m-t-10">
                        <div class="form_group w70">
                            <div class="select_group">
                                <select name="T001" title="select" class="form_control">
                                    <option value="in">IN</option>
                                    <option value="out">OUT</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="btn-line-s btn_gray w53 gate-open">OPEN</button>
                    </div>
                    <div class="box_text m-t-7"></div>
                </div>

                <div class="box_state01 dhc">
                    <p id="trT008">DHC</p>
                    <div class="row m-t-10">
                        <div class="form_group w70">
                            <div class="select_group">
                                <select name="T008" title="select" class="form_control">
                                    <option value="in">IN</option>
                                    <option value="out">OUT</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="btn-line-s btn_gray w53 gate-open">OPEN</button>
                    </div>
                    <div id="trT009" class="box_text m-t-7">Chip-cut (1)</div>
                </div>

                <div class="box_state01 gnr" style="cursor:default">
                    <p>GNR</p>
                    <div class="row h28 m-t-10"></div>
                    <div class="box_text m-t-7">Total <span class="now-gnr-count"></span></div>
                </div>

                <div class="box_state02 emergency">
                    <p>Emergency (HSO)</p>
                    <div class="row m-t-8">
                        <button type="button" class="btn-line-s btn_gray w53" onclick="controlGatePopup('T999', 'open', 'out', '1')">OPEN</button>
                        <button type="button" class="btn-line-s btn_gray w53" onclick="controlGatePopup('T999', 'close', 'out', '1')">CLOSE</button>
                    </div>
                </div>

                <div class="box_state02 ride">
                    <p>Ride</p>
                    <div class="row m-t-8">
                        <span>OUT</span>
                        <button type="button" class="btn-line-s btn_gray w53" onclick="controlGate('T006', 'open', 'out', '2')">OPEN</button>
                    </div>
                </div>

                <div class="box_state02 braking">
                    <p>Braking</p>
                    <div class="row m-t-8">
                        <span>OUT</span>
                        <button type="button" class="btn-line-s btn_gray w53" onclick="controlGate('T003', 'open', 'out', '2')">OPEN</button>
                    </div>
                </div>

                <div class="box_state02 vda">
                    <p>VDA</p>
                    <div class="row m-t-8">
                        <span>OUT</span>
                        <button type="button" class="btn-line-s btn_gray w53" onclick="controlGate('T002', 'open', 'out', '2')">OPEN</button>
                    </div>
                </div>

                <div class="box_state02 pbn">
                    <div class="row m-t-7">
                        <p>VDA/PBN<br />분기차단기</p>
                        <button type="button" class="btn-line-s btn_gray w53" onclick="controlGate('T016', 'open', 'in', '1')">OPEN</button>
                    </div>
                </div>

                <div class="box_state02 offRoad">
                    <p>Off Road</p>
                    <div class="row m-t-8">
                        <div class="form_group w70">
                            <div class="select_group">
                                <select name="T012" title="select" class="form_control">
                                    <option value="in">IN</option>
                                    <option value="out">OUT</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="btn-line-s btn_gray w53 gate-open">OPEN</button>
                    </div>
                </div>

                <div class="box_state02 dhc">
                    <p>DHC #2</p>
                    <div class="row m-t-8">
                        <div class="form_group w70">
                            <div class="select_group">
                                <select name="T013" title="select" class="form_control">
                                    <option value="in">IN</option>
                                    <option value="out">OUT</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="btn-line-s btn_gray w53 gate-open">OPEN</button>
                    </div>
                </div>

            </div>

            <div class="track_info m-t-30">
                <!-- table list -->
                <section id="select-track" class="tbl_wrap_list">
                    <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                        <caption>테이블</caption>
                        <colgroup>
                            <col width="317px" />
                            <col width="" />
                            <col width="" />
                            <col width="" />
                            <col width="" />
                            <col width="" />
                        </colgroup>
                        <thead>
                        <tr>
                            <th scope="col" id="trackcnt"></th>
                            <th colspan="5" scope="col" class="th_btnOpen">
                                            <span>IN<button type="button" id="detail-in"
                                                            class="btn-line-s btn_gray m-l-12">OPEN</button></span>
                                <span>OUT<button type="button" id="detail-out"
                                                 class="btn-line-s btn_gray m-l-12">OPEN</button></span>
                            </th>
                        </tr>
                        </thead>
                    </table>
                </section>
                <!-- //table list -->

                <!-- table list -->
                <section class="tbl_wrap_list table_scroll_200">
                    <table class="tbl_list border-t-0" summary="테이블 입니다. 항목으로는 등이 있습니다">
                        <caption>테이블</caption>
                        <colgroup>
                            <col width="317px" />
                            <col width="202px" />
                            <col width="130px" />
                            <col width="114px" />
                            <col width="275px" />
                            <col width="" />
                        </colgroup>
                        <tbody id="drivercondition">
                        <tr>
                            <td colspan="6">상단에서 시험로를 선택해 주세요.</td>
                        </tr>
                        </tbody>
                    </table>
                </section>
                <!-- //table list -->
            </div>

        </div>
        <!-- //wrap_left -->

        <!-- wrap_right -->
        <div class="wrap_right">
            <div id="update_time" class="update_time"></div>

            <h3 class="m-t-21">기상정보</h3>
            <div class="wrap_weather m-t-10">
                <%@ include file="/WEB-INF/views/jsp/common/weather.jsp" %>
            </div>
            <h3 class="m-t-23">GNR GATE</h3>
            <div class="wrap_gnrGate m-t-10">
                <div class="wrap_hd">
                    <div class="title">Total <strong id="gnr-count" class="now-gnr-count">0</strong></div>
                    <div class="wrap_btn">
                        <button type="button" class="btn-sty2 btn_default w98 m-r-6" onclick="controlGate('T000', 'open', 'in', '1')">IN OPEN</button>
                        <button type="button" class="btn-line-bs btn_default fs14 w98" onclick="controlGate('T000', 'open', 'out', '1')">OUT OPEN</button>
                    </div>
                </div>
                <div class="wrap_state m-t-9">
                    <ul>
                        <li><strong>· 예약번호 :</strong> <span id="reserve-code">현재 진입차량이 없습니다.</span></li>
                        <li><strong>· 평가자 :</strong> <span id="driver-info"></span></li>
                        <li><strong>· 차량 :</strong> <span id="car-info"></span><span id="car-type" class="redfont"></span></li>
                    </ul>
                </div>
                <div class="wrap_cctv m-t-17">
                    <iframe src="/admin/controlsystem/player"  frameborder="0" width="378" height="215" scrolling="no"
                            marginwidth="0" marginheight="0"></iframe>
                </div>
            </div>
            <h3 class="m-t-23">평가자 검색</h3>
            <div class="wrap_tpSearch m-t-10">
                <div class="row">
                    <div class="form_group w300">
                        <input type="text" id="dName" name="dName" class="form_control" placeholder="평가자를 입력하세요" autocomplete="off" />
                    </div>
                    <button type="button" id="search-btn" class="btn-s btn_default" data-layer="popup_Driversearch">검색</button>
                </div>
                <div class="wrap_state m-t-12">
                    <ul>
                        <li><strong>· 트랙 출입 시간 :</strong> <span id="search-driver-time">검색결과가 없습니다.</span></li>
                        <li><strong>· 평가자 :</strong> <span id="search-driver-info"></span></li>
                        <li><strong>· 차량 :</strong> <span id="search-car-info"></span></li>
                    </ul>
                </div>
            </div>
            <div class="wrap_emergency m-t-23">
                <div class="row">
                    <span class="title">비상상황</span>
                    <button type="button" class="btn-sty3 btn_default" data-layer="popup_emergency">전체
                        문열림</button>
                </div>
            </div>
        </div>
        <!-- //wrap_right -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

<!-- popup_s-->
<div class="ly_group">
    <article class="layer_m popup_Driversearch">
        <!-- # 타이틀 # -->
        <h1>평가자 선택</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <!-- table list -->
            <section class="tbl_wrap_list m-t-15">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="80px" />
                        <col width="" />
                        <col width="" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">선택</th>
                        <th scope="col">운전자명</th>
                    </tr>
                    </thead>
                    <tbody id="indexP"></tbody> <%--평가자 검색시 팝업--%>
                </table>
            </section>
            <!-- //table list -->
            <!-- Pagination -->
            <section id="pagingc" class="pagination m-t-30">
                <jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
            </section>
            <!-- //Pagination -->
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-6">취소</button>
            <button type="button" class="btn-pop btn_default" onclick="putChk()">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_s-->

<!-- popup_m -->
<div class="ly_group">
    <article class="layer_m popup_emergency">
        <!-- # 타이틀 # -->
        <h1>비상상황</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <!-- table_view -->
            <div id="errEmergencyMsg"></div>
            <div class="tbl_wrap_view">
                <table class="tbl_view01" summary="테이블입니다.">
                    <caption>테이블입니다.</caption>
                    <colgroup>
                        <col width="140px" />
                        <col width="" />
                    </colgroup>
                    <tr>
                        <th scope="row">비상문구 선택</th>
                        <td>
                            <div class="form_group w_full">
                                <div class="select_group">
                                    <select id="emergency-sel-msg" name="emergency-sel-msg" title="select" class="form_control">
                                        <option value="">비상코드 선택</option>
                                        <c:forEach var="result" items="${emergencyList}" varStatus="status">
                                            <option value="${result.emergencyCode }">${result.emergencyValue }</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">직접입력</th>
                        <td>
                            <div class="form_group w_full">
                                    <textarea id="emergency-msg" name="emergency-msg" cols="" rows="3" class="form_control h60"
                                              placeholder="예) 화재발생했습니다. 어서대피하세요"></textarea>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <!-- //table_view -->
            <div class="m-t-15 tac">
                <button type="button" id="emergency-msg-send-btn" class="btn-sty1 btn_default">전광판 송출</button>
                <button type="button" id="kakao-msg-send-btn" class="btn-sty1 btn_default">알림톡 전송</button>
            </div>
        </div>
        <!-- 버튼 -->
        <div class="m-t-10">
            <p id="billboard-msg-result"></p>
            <p id="emergency-msg-in-result"></p>
            <p id="emergency-msg-out-result"></p>
        </div>

        <div class="wrap_btn01 m-t-15">
            <!-- <button type="button" class="btn-pop btn_gray m-r-11">취소</button> -->
            <button type="button" id="btn-all-open" class="btn-pop btn_default lyClose">전체 문열림</button>
            <button type="button" id="btn-all-close" class="btn-pop btn_default lyClose m-l-6">전체 문닫힘</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_m -->

<!-- popup_l -->
<div class="ly_group" id="control_popup">
    <article class="layer_l popup_GControl">
        <!-- # 타이틀 # -->
        <h1>차단기 제어 (전체)</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <span id="msg-kind" class="redfont"></span>
            <div class="tar">
                <div class="form_group">
                    <div class="radio_inline">
                        <label class="radio_default">
                            <input type="radio" name="kind" value="b" checked="checked" />
                            <span class="radio_icon"></span>한국타이어</label>
                        <label class="radio_default">
                            <input type="radio" name="kind" value="h" />
                            <span class="radio_icon"></span>현대자동차</label>
                    </div>
                </div>
            </div>
            <!-- table list -->
            <section class="tbl_wrap_list m-t-20">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="50px" />
                        <col width="" />
                        <col width="114px" />
                        <col width="114px" />
                        <col width="114px" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">No.</th>
                        <th scope="col">시험로</th>
                        <th scope="col">IN</th>
                        <th scope="col">OUT</th>
                        <th scope="col">편개</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>1</td>
                        <td class="tal">GNR</td>
                        <td>
                            <button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T000', 'open', 'in', '1', this)">열림</button>
                            <button type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T000', 'close', 'in', '1', this)">닫힘</button></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T000', 'open', 'out', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T000', 'close', 'out', '1', this)">닫힘</button></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td class="tal">DHC / Chip-Cut</td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T008', 'open', 'in', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T008', 'close', 'in', '1', this)">닫힘</button></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T008', 'open', 'out', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T008', 'close', 'out', '1', this)">닫힘</button></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td class="tal">HSO</td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T001', 'open', 'in', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T001', 'close', 'in', '1', this)">닫힘</button></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T001', 'open', 'out', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T001', 'close', 'out', '1', this)">닫힘</button></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>4</td>
                        <td class="tal">WHC / Hyd-Curve</td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T007', 'open', 'in', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T007', 'close', 'in', '1', this)">닫힘</button></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T007', 'open', 'out', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T007', 'close', 'out', '1', this)">닫힘</button></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>5</td>
                        <td class="tal">Ride</td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T006', 'open', 'in', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T006', 'close', 'in', '1', this)">닫힘</button></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T006', 'open', 'out', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T006', 'close', 'out', '1', this)">닫힘</button></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T006', 'open', 'out', '2', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T006', 'close', 'out', '2', this)">닫힘</button></td>
                    </tr>
                    <tr>
                        <td>6</td>
                        <td class="tal">Braking / Hyd-Straight</td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T003', 'open', 'in', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T003', 'close', 'in', '1', this)">닫힘</button></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T003', 'open', 'out', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T003', 'close', 'out', '1', this)">닫힘</button></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T003', 'open', 'out', '2', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T003', 'close', 'out', '2', this)">닫힘</button></td>
                    </tr>
                    <tr>
                        <td>7</td>
                        <td class="tal">VDA</td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T002', 'open', 'in', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T002', 'close', 'in', '1', this)">닫힘</button></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T002', 'open', 'out', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T002', 'close', 'out', '1', this)">닫힘</button></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T002', 'open', 'out', '2', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T002', 'close', 'out', '2', this)">닫힘</button></td>
                    </tr>
                    <tr>
                        <td>8</td>
                        <td class="tal">NVH / PBN</td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T004', 'open', 'in', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T004', 'close', 'in', '1', this)">닫힘</button></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T004', 'open', 'out', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T004', 'close', 'out', '1', this)">닫힘</button></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>9</td>
                        <td class="tal color_bule2">Off Road</td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T012', 'open', 'in', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T012', 'close', 'in', '1', this)">닫힘</button></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T012', 'open', 'out', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T012', 'close', 'out', '1', this)">닫힘</button></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>10</td>
                        <td class="tal color_bule2">DHC #2</td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T013', 'open', 'in', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T013', 'close', 'in', '1', this)">닫힘</button></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T013', 'open', 'out', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T013', 'close', 'out', '1', this)">닫힘</button></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>11</td>
                        <td class="tal">분기차단기</td>
                        <td></td>
                        <td></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T016', 'open', 'out', '2', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T016', 'close', 'out', '2', this)">닫힘</button></td>
                    </tr>
                    <tr>
                        <td>12</td>
                        <td class="tal color_red2">Emergency</td>
                        <td></td>
                        <td><button type="button" class="btn-line-s2 btn_default m-r-5" onclick="controlGatePopup('T999', 'open', 'out', '1', this)">열림</button><button
                                type="button" class="btn-line-s2 btn_gray" onclick="controlGatePopup('T999', 'close', 'out', '1', this)">닫힘</button></td>
                        <td></td>
                    </tr>
                    </tbody>
                </table>
            </section>
            <!-- //table list -->
        </div>
        <!-- 버튼 -->
        <!-- <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray m-r-11">취소</button>
            <button type="button" class="btn-pop btn_default lyClose">확인</button>
        </div> -->
        <!-- # 닫기버튼 # -->
        <button id="winAllGate" data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_l -->

<script type="text/javascript">
    var weekArr = ['일', '월', '화', '수', '목', '금', '토'];

    function getTime() {
        var d = new Date();	// 현재 날짜와 시간
        var month = ("0" + (1 + d.getMonth())).slice(-2);
        var day = ("0" + d.getDate()).slice(-2);
        var hur = ("0" + d.getHours()).slice(-2);		// 시
        var min = ("0" + d.getMinutes()).slice(-2);	//분
        var sec = ("0" + d.getSeconds()).slice(-2);	//초
        var week = d.getDay();
        var update_time = document.getElementById("update_time"); // 값이 입력될 공간

        var time = month+"."+day+"("+weekArr[week]+") "+hur + ":" + min + ":" + sec + " 갱신";	// 형식 지정

        update_time.innerHTML = time;	// 출력
    }

    getTime();
</script>
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>