<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>

<script type="text/javascript">
    $(document).ready(function(){
        $(".lodingdimm").show();
        //시험로 selectbox
        $.ajax({
            url : "/admin/trReserve/track-list",
            type : "get",
            data : {},
            success : function(resdata){
                drawTrackSelect(resdata.trackList, "");
                drawTrackSelect2(resdata.trackList, "");
            },
            error : function(e){
                console.log(e);
            }
        });


        function search(type){
            var pageNo;
            var pageSize = "100";
            var tcDay = $("#tcDay").text();

            var trTrackType = [];
            $("input[name='trTrackType']:checked").each(function(i) {
                trTrackType.push($(this).val());
            });
            var compType = [];
            $("input[name='compType']:checked").each(function(i) {
                compType.push($(this).val());
            });
            var trTrackCode = $("#trTrackCode").val();

            var tcApproval = "3"; //승인완료 전용페이지
            var tcStep = "0";		//시험전 전용페이지
            /*
            if(type == "button"){//버튼 검색
                pageNo = "1";
            }else if(type == "list") {//목록 버튼
                pageNo = $("#pageNo").text();
                $("#data_detail").hide();
            }else if(type == "paging"){//페이징 검색
                pageNo = $(".pageNo.on").attr("data-page");
            }
            */

            if(pageNo == ""){
                pageNo = "1";
            }

            var orderName1="";
            var orderKind1="";
            var orderName2="";
            var orderKind2="";
            var orderName3="";
            var orderKind3="";
            var orderName4="";
            var orderKind4="";
            var orderName5="";
            var orderKind5="";

            if($("#order1").hasClass("btn_sort_down")){
                orderName1="Y";
                orderKind1="DESC";
            }else if($("#order1").hasClass("btn_sort_up")){
                orderName1="Y";
                orderKind1="ASC";
            }
            if($("#order2").hasClass("btn_sort_down")){
                orderName2="Y";
                orderKind2="DESC";
            }else if($("#order2").hasClass("btn_sort_up")){
                orderName2="Y";
                orderKind2="ASC";
            }
            if($("#order3").hasClass("btn_sort_down")){
                orderName3="Y";
                orderKind3="DESC";
            }else if($("#order3").hasClass("btn_sort_up")){
                orderName3="Y";
                orderKind3="ASC";
            }
            if($("#order4").hasClass("btn_sort_down")){
                orderName4="Y";
                orderKind4="DESC";
            }else if($("#order4").hasClass("btn_sort_up")){
                orderName4="Y";
                orderKind4="ASC";
            }
            if($("#order5").hasClass("btn_sort_down")){
                orderName5="Y";
                orderKind5="DESC";
            }else if($("#order5").hasClass("btn_sort_up")){
                orderName5="Y";
                orderKind5="ASC";
            }

            $.ajax({
                url : "/admin/trReserve/search-trReserve",
                type : "get",
                data : {
                    "pageNo"  :pageNo,
                    "pageSize"  :pageSize,
                    "compType":compType,
                    "tcDay":tcDay,
                    "trTrackType":trTrackType,
                    "trTrackCode":trTrackCode,
                    "tcApproval":tcApproval,
                    "tcStep":tcStep,
                    "orderName1":orderName1,
                    "orderName2":orderName2,
                    "orderName3":orderName3,
                    "orderName4":orderName4,
                    "orderName5":orderName5,
                    "orderKind1":orderKind1,
                    "orderKind2":orderKind2,
                    "orderKind3":orderKind3,
                    "orderKind4":orderKind4,
                    "orderKind5":orderKind5
                },
                success : function(resdata){
                    drawingTable(resdata.rows, resdata.paging);
                },
                error : function(e){
                    console.log(e);
                }
            });

        }

        $(document).on("click","button[id^=order]",function(){
            var orderName1="";
            var orderKind1="";
            var orderName2="";
            var orderKind2="";
            var orderName3="";
            var orderKind3="";
            var orderName4="";
            var orderKind4="";
            var orderName5="";
            var orderKind5="";
            if($(this).prop("id")=="order1"){
                if(!$(this).hasClass("btn_sort_down")&&!$(this).hasClass("btn_sort_up") ){
                    orderName1="Y";
                    orderKind1="DESC";
                    $(this).addClass("btn_sort_down");
                }else if($(this).hasClass("btn_sort_down")){
                    orderName1="Y";
                    orderKind1="ASC";
                    $(this).removeClass("btn_sort_down")
                        .addClass("btn_sort_up");
                }else if($(this).hasClass("btn_sort_up")){
                    orderName1="";
                    $(this).removeClass("btn_sort_down")
                        .removeClass("btn_sort_up");
                }
            }
            if($(this).prop("id")=="order3"){
                if(!$(this).hasClass("btn_sort_down")&&!$(this).hasClass("btn_sort_up") ){
                    orderName3="Y";
                    orderKind3="DESC";
                    $(this).addClass("btn_sort_down");
                }else if($(this).hasClass("btn_sort_down")){
                    orderName3="Y";
                    orderKind3="ASC";
                    $(this).removeClass("btn_sort_down")
                        .addClass("btn_sort_up");
                }else if($(this).hasClass("btn_sort_up")){
                    orderName3="";
                    $(this).removeClass("btn_sort_down")
                        .removeClass("btn_sort_up");
                }
            }
            if($(this).prop("id")=="order4"){
                if(!$(this).hasClass("btn_sort_down")&&!$(this).hasClass("btn_sort_up") ){
                    orderName4="Y";
                    orderKind4="DESC";
                    $(this).addClass("btn_sort_down");
                }else if($(this).hasClass("btn_sort_down")){
                    orderName4="Y";
                    orderKind4="ASC";
                    $(this).removeClass("btn_sort_down")
                        .addClass("btn_sort_up");
                }else if($(this).hasClass("btn_sort_up")){
                    orderName4="";
                    $(this).removeClass("btn_sort_down")
                        .removeClass("btn_sort_up");
                }
            }
            if($(this).prop("id")=="order5"){
                if(!$(this).hasClass("btn_sort_down")&&!$(this).hasClass("btn_sort_up") ){
                    orderName5="Y";
                    orderKind5="DESC";
                    $(this).addClass("btn_sort_down");
                }else if($(this).hasClass("btn_sort_down")){
                    orderName5="Y";
                    orderKind5="ASC";
                    $(this).removeClass("btn_sort_down")
                        .addClass("btn_sort_up");
                }else if($(this).hasClass("btn_sort_up")){
                    orderName5="";
                    $(this).removeClass("btn_sort_down")
                        .removeClass("btn_sort_up");
                }
            }
            search("list");
        });

        $(document).on("click","a[id^=dt]",function(){
            var tcDay = $(this).prop("id").replace("dt","");
            $("#tcDay").text(tcDay);

            var pageSize = 100;
            var tcApproval = "3";
            var tcStep = "0";
            $.ajax({
                url : "/admin/trReserve/search-trReserve",
                type : "get",
                data : {
                    "tcDay":tcDay,
                    "pageSize":pageSize,
                    "tcApproval":tcApproval,
                    "tcStep":tcStep
                },
                success : function(resdata){
                    drawingTable(resdata.rows, resdata.paging);
                    drawPickData(resdata.rows);
                },
                error : function(e){
                    console.log(e);
                }
            });
        });

        $(document).on("click","#btnSearch",function(){
            var reqTrackType = [];
            $("input[name='reqTrackType']:checked").each(function(i) {
                reqTrackType.push($(this).val());
            });
            var reqCompType = [];
            $("input[name='reqCompType']:checked").each(function(i) {
                reqCompType.push($(this).val());
            });
            var reqTrackCode = $("#reqTrackCode").val();
            location.href=window.location.pathname+"?year="+${today_info.search_year}+"&month="+(${today_info.search_month}-1)+"&reqTrackType="+reqTrackType+"&reqCompType="+reqCompType+"&reqTrackCode="+reqTrackCode+"&tcApproval=3&tcStep=0";
        });

        $("#btnSearch2").click(function(){
            search("button");
        });
    });

    //탭 이동
    function pageMove(str){
        if(str=='tab1'){
            location.href = '/admin/trReserve/trcalendar';
        }else if(str == 'tab2'){
            location.href = '/admin/reserved/schedule';
        }
    }

    //조회값 undefined -> 공백 처리
    function undefinedChk(str1, str2){
        if( str1 == "" || str1 == null || typeof str1 == undefined || str1 == undefined || ( str1 != null && typeof str1 == "object" && !Object.keys(str1).length ) ){
            return str2;
        }else{
            return str1;
        }
    }

    //시험로 정보 selectbox 생성
    function drawTrackSelect(trackList, currentTid){
        var html='';
        var tMax='';
        html += '<select name="reqTrackCode" id="reqTrackCode" class="form_control">';
        html += '<option value="">시험로선택</option>';
        var reqTrackCode = '${reqTrackCode}';
        for(var list in trackList){
            if(parseInt(list)>0){
                html += '<option value="'+undefinedChk(trackList[list].tid,"")+'"';
                if(reqTrackCode==undefinedChk(trackList[list].tid,"")){
                    html += 'selected="selected"';
                    if(undefinedChk(trackList[list].tmax,"")!=""){
                        tMax = 'C : ' + undefinedChk(trackList[list].tmax,"");
                    }
                }
                html += '>'+undefinedChk(trackList[list].tname,"")+'</option>';
            }
        }
        html += '</select>';
        $("#track1").html(html);
        if(tMax!="")
            $("#track1Max").html(tMax);
    }

    //시험로 정보 selectbox 생성
    function drawTrackSelect2(trackList, currentTid){
        var html='';
        html += '<select name="trTrackCode" id="trTrackCode" class="form_control">';
        html += '<option value="">시험로선택</option>';
        var trTrackCode = '${trTrackCode}';
        for(var list in trackList){
            if(parseInt(list)>0){
                html += '<option value="'+undefinedChk(trackList[list].tid,"")+'"';
                if(trTrackCode==undefinedChk(trackList[list].tid,"")){
                    html += 'selected="selected"';
                }
                html += '>'+undefinedChk(trackList[list].tname,"")+'</td>';
            }
        }
        html += '</select>';
        $("#track2").html(html);
    }

    //상세보기로 이동
    $(document).on("click",".godetail",function(){
        var currentRow=$(this).closest('tr');
        var pageNo;
        var tcSeq = currentRow.find('td:eq(0) span').text();
        var tcDay = currentRow.find('td:eq(3) span').text();

        pageNo = $(".pageNo.on").attr("data-page");
        $("#pageNo").html(pageNo);
        $("#tcSeq").text(tcSeq);

        $.ajax({
            url : "/admin/trReserve/detail-reserve-info",
            type : "get",
            data : {
                "pageNo"  :pageNo,
                "tcSeq":tcSeq,
                "tcDay":tcDay
            },
            success : function(resdata){
                drawingDetailTable(resdata.trReserve, resdata.driver, resdata.company);
            },
            error : function(e){
                console.log(e);
            }
        });
    });

    //상세보기 테이블
    function drawingDetailTable(trReserve, driver, company){
        $("#data_detail").show();
        var html='';
        var trTrackType = undefinedChk(trReserve.trTrackType,"");
        html += '<div class="m-t-30">';
        html += '<section class="tbl_wrap_list">';
        html += '<table id="data_table" class="tbl_list" summary="예약 테이블입니다. 항목으로는 예약번호, 접수일자, 시험일자, 회사명, 항목, 유형, 진행상태등이 있습니다.">';
        html += '<caption>예약 테이블</caption>';
        html += '<thead>';
        html += '<tr>';
        html += '<th>예약번호</th><th>접수일자</th><th>시험일자</th><th>회사명</th><th>평가트랙</th><th>유형</th><th>진행상태</th>';
        html += '</tr>';
        html += '</thead>';
        html += '<tbody>';

        html += '<td>'
        if(trReserve.compCode == "THINT") {
            html += '<br /><span class="color_red">' +undefinedChk(trReserve.tcReservCode,"")+'</span><br>';
        }
        html += undefinedChk(trReserve.tcRequestNumber,"")+ '</td>';

        html += '<td>'+undefinedChk(trReserve.tcRequestNumber,"")+'</td>';
        var tcRegDt = undefinedChk(trReserve.tcRegDt,"");
        if(tcRegDt.length==14){
            tcRegDt = tcRegDt.substring(0,4)+ "."+ tcRegDt.substring(4,6)+ "."+ tcRegDt.substring(6,8);
        }
        html += '<td>'+tcRegDt+'</td>';
        var tcDay = undefinedChk(trReserve.tcDay,"");
        var tcDay2 = undefinedChk(trReserve.tcDay2,"");
        tcDay = tcDay.substring(0,4)+'-'+tcDay.substring(4,6)+'-'+tcDay.substring(6,8);
        tcDay2 = tcDay2.substring(0,4)+'-'+tcDay2.substring(4,6)+'-'+tcDay2.substring(6,8);
        html += '<td><div class="form_group w230">'+tcDay+' ~ '+tcDay2+'</td>';
        html += '<td>';
        var trackInfo = new Array();
        var trNickName = "";
        trackInfo = trReserve.trackInfo;

        for(var list in trackInfo) {
            if(list == 0){
                trNickName = undefinedChk(trackInfo[list].trTrackNickName,"");
            }else{
                if(trNickName.indexOf(undefinedChk(trackInfo[list].trTrackNickName,""))<0){
                    trNickName += "<br />"+undefinedChk(trackInfo[list].trTrackNickName,"");
                }
            }
            trTrackType = undefinedChk(trackInfo[list].trTrackType, "");
        }
        html += trNickName + '</td>';
        html += '<td>';
        if(trTrackType=="TYP00") {
            html += '공동';
        }else if(trTrackType=="TYP01") {
            html += '단독';
        }else if(trTrackType=="TYP02") {
            html += '시험';
        }else if(trTrackType=="TYP03") {
            html += '연습';
        }else if(trTrackType=="TYP04") {
            html += '점검';
        }else if(trTrackType=="TYP05") {
            html += '시승';
        }else if(trTrackType=="TYP06") {
            html += '사내방문';
        }else if(trTrackType=="TYP07") {
            html += '테스트';
        }else if(trTrackType=="TYP99") {
            html += '기타';
        }
        html += '</td>';
        var tcStep = undefinedChk(trReserve.tcStep,"");
        html += '<td id="appTxt">';
        if(tcStep=="00000"){
            html += '시험전';
        }else if(tcStep=="00001"){
            html += '시험중';
        }else if(tcStep=="00002"){
            html += '시험완료';
        }else if(tcStep=="00003"){
            html += '정산완료';
        }
        html += '</td>';
        html += '</tbody>';
        html += '</table>';
        html += '</section>';
        html += '</div>';

        html += '<div class="wrap_accordion2 m-t-30">';
        html += '<button class="accordion open">';
        html += '   <h3 class="stitle disib vam0">시험정보</h3>';
        html += '</button>';
        html += '<div class="accordion_panel" style="display: block;">';
        html += '<section class="tbl_wrap_view">';
        html += '<table class="tbl_view01" id="data_table1" summary="시험 정보테이블입니다. 항목으로는 운전자, 시험차종, 시험종류 및 방법등이 있습니다.">';
        html += '    <caption>시험 정보테이블</caption>';
        html += '    <colgroup>';
        html += '	     <col width="180px;" />';
        html += '	     <col width="" />';
        html += '	 </colgroup>';
        html += '<tbody>';
        html += '<tr><th scope="row">운전자</th><td>'+undefinedChk(driver,"")+'</td></tr>';
        html += '<tr><th scope="row">시험차종</th><td>';
        var carArr = new Array();
        carArr = trReserve.carInfo;
        for(var list in carArr) {
            var carInfo = carArr[list];
            html += carInfo.cvender+' '+carInfo.cname+' ('+carInfo.cnumber+' / '+carInfo.ccolor+')';
            if(carInfo.cType=="S"){
                html += '<span class="color_red"> - 특수차량</span>';
            }
            html += '<br />';
        }
        '</td></tr>';
        html += '<tr><th scope="row">시험종류 및 방법</th><td>'+undefinedChk(trReserve.tcPurpose,"")+'</td></tr>';
        html += '</tbody>';
        html += '</table>';
        html += '</section>';
        html += '</div>';
        html += '</div>';
        if(undefinedChk(trReserve.compCode,"")!="THINT"){
            html += '<div class="wrap_accordion2 m-t-30">';
            html += '<button class="accordion open">';
            html += '   <h3 class="stitle disib vam0">예약 담당자 및 회계 담당자 정보</h3>';
            html += '</button>';
            html += '<div class="accordion_panel" style="display: block;">';
            html += '<section class="tbl_wrap_view">';
            html += '<table class="tbl_view01" id="data_table1" summary="예약 담당자 및 회계 담당자 정보테이블입니다. 항목으로는 운전자, 시험차종, 시험종류 및 방법등이 있습니다.">';
            html += '   <caption>예약 담당자 및 회계 담당자 정보테이블</caption>';
            html += '   <colgroup>';
            html += '	    <col width="180px;" />';
            html += '	    <col width="" />';
            html += '	    <col width="180px;" />';
            html += '	    <col width="" />';
            html += '	</colgroup>';
            html += '	<tbody>';
            html += '		<tr>';
            html += '			<th scope="row">회사명</th><td>';
            html += undefinedChk(company.compName,"");
            if(undefinedChk(company.blackList,"")=="Y") {
                html += ' 		<span class="color_red">(B/L)</span>';
            }
            html += '			</td>';
            html += '			<th scope="row">사업자번호</th><td>';
            var compLicense = undefinedChk(company.compLicense,"")
            compLicense = compLicense.substring(0,3)+"-"+compLicense.substring(3,5)+"-"+compLicense.substring(5,10);
            html += compLicense;
            html += '			</td>';
            html += '		</tr>';
            html += '		<tr>';
            html += '			<th scope="row">예약담당자</th><td>'+undefinedChk(company.memName,"")+'</td>';
            html += '			<th scope="row">부서</th><td>'+undefinedChk(company.memDept,"")+'</td>';
            html += '		</tr>';
            html += '		<tr>';
            html += '			<th scope="row">휴대폰번호</th><td>';
            var memPhone = undefinedChk(company.memPhone,"")
            memPhone = memPhone.substring(0,3)+"-"+memPhone.substring(3,7)+"-"+memPhone.substring(7,11);
            html += memPhone;
            html += '			</td>';
            html += '			<th scope="row">전화번호</th><td>';
            var compPhone = undefinedChk(company.compPhone,"")
            if(compPhone!=""){
                if(compPhone.substring(0,2)=="02"||compPhone.length<10){
                    if(compPhone.length==10){
                        compPhone = compPhone.substring(0,2)+'-'+compPhone.substring(2,6)+'-'+compPhone.substring(6,10);
                    }else{
                        compPhone = compPhone.substring(0,2)+'-'+compPhone.substring(2,5)+'-'+compPhone.substring(5,10);
                    }
                }else if(compPhone.substring(0,3)=="010"){
                    compPhone = compPhone.substring(0,3)+'-'+compPhone.substring(3,7)+'-'+compPhone.substring(7,11);
                }else{
                    if(compPhone.length==10){
                        compPhone = compPhone.substring(0,3)+'-'+compPhone.substring(3,6)+'-'+compPhone.substring(6,10);
                    }else if(compPhone.length==11){
                        compPhone = compPhone.substring(0,3)+'-'+compPhone.substring(3,7)+'-'+compPhone.substring(7,11);
                    }else if(compPhone.length==12){
                        compPhone = compPhone.substring(0,4)+'-'+compPhone.substring(4,8)+'-'+compPhone.substring(8,12);
                    }
                }
                html += compPhone;
            }
            html += '			</td>';
            html += '		</tr>';
            html += '	</tbody>';
            html += '	</table>';
            html += '</section>';
            html += '</div>';
            html += '</div>';
        }
        html += '<div class="wrap_accordion2 m-t-30">';
        html += '<button class="accordion open">';
        html += '   <h3 class="stitle disib vam0">관리자 메모</h3>';
        html += '</button>';
        html += '<div class="accordion_panel" style="display: block;">';
        html += '<section class="tbl_wrap_view">';
        html += '<table class="tbl_view01" id="data_table1" summary="관리자 메모테이블입니다.">';
        html += '   <caption>관리자 메모</caption>';
        html += '   <colgroup>';
        html += '	    <col width="180px;" />';
        html += '	    <col width="" />';
        html += '	</colgroup>';
        html += '	<tbody>';
        html += '		<tr>';
        html += '			<th scope="row">관리자 메모</th><td>';
        html += undefinedChk(trReserve.tcMemo,"");
        html += '			</td>';
        html += '		</tr>';
        html += '	</tbody>';
        html += '</table>';
        html += '</section>';
        html += '</div>';
        html += '</div>';
        $("#data_detail").html(html);
    }

    //테이블 그리는 함수
    function drawingTable(rows, paging){

        var html='';
        if(rows.length==0){
            html += '<tr class="tr_nodata"><td colspan="8">데이터가 존재하지 않습니다.</td></tr>';
        }else{
            for(var list in rows){
                html += '<tr onmouseover="this.className=\'on godetail\'"onmouseout="this.className=\'\'">';
                html += '<td><span style="display:none">'+undefinedChk(rows[list].tcSeq,"")+'</span>';
                html += paging.totalCount-(paging.pageNo-1)*paging.pageSize-list;
                html += '</td>';
                //html += '<td>'+undefinedChk(rows[list].tcReservCode,"")+'</td>';

                html += '<td>'
                if(rows[list].compCode == "THINT") {
                    html += '<br /><span class="color_red">' +undefinedChk(rows[list].tcReservCode,"")+'</span><br>';
                }
                html += undefinedChk(rows[list].tcRequestNumber,"") ;
                +'</td>';

                var tcRegDt = "";
                if(rows[list].tcRegDt.length==14){
                    tcRegDt += rows[list].tcRegDt.substring(0,4)+ "."+ rows[list].tcRegDt.substring(4,6)+ "."+ rows[list].tcRegDt.substring(6,8);
                }
                html += '<td>'+tcRegDt+'</td>';
                var tcDay = rows[list].tcDay.substring(0,4)+ "."+ rows[list].tcDay.substring(4,6)+ "."+ rows[list].tcDay.substring(6,8);
                var tcDay2 = rows[list].tcDay2.substring(0,4)+ "."+ rows[list].tcDay2.substring(4,6)+ "."+ rows[list].tcDay2.substring(6,8);
                if(tcDay==tcDay2){
                    html += '<td><span>'+tcDay+'</span></td>';
                }else{
                    html += '<td>';
                    html += '<span>'+tcDay+'</span> ~<br />'+tcDay2;
                    html += '</td>';
                }
                html += '<td>';
                if(undefinedChk(rows[list].compCode,"")=="THINT"){
                    html += '한국타이어';
                }else{
                    html += undefinedChk(rows[list].compName,"");
                    if(undefinedChk(rows[list].blackList,"")=="Y") {
                        html += '<br /><span class="color_red">(B/L)</span>';
                    }
                }
                html += '</td>';
                html += '<td>'+undefinedChk(rows[list].trTrackNickName,"").replace(/#/g, "<br />")+'</td>';
                html += '<td>';
                var trTrackType = undefinedChk(rows[list].trTrackType,"");
                if(trTrackType=="TYP00") {
                    html += '공동';
                }else if(trTrackType=="TYP01") {
                    html += '단독';
                }else if(trTrackType=="TYP02") {
                    html += '시험';
                }else if(trTrackType=="TYP03") {
                    html += '연습';
                }else if(trTrackType=="TYP04") {
                    html += '점검';
                }else if(trTrackType=="TYP05") {
                    html += '시승';
                }else if(trTrackType=="TYP06") {
                    html += '사내방문';
                }else if(trTrackType=="TYP07") {
                    html += '테스트';
                }else if(trTrackType=="TYP99") {
                    html += '기타';
                }
                html += '</td>';
                var tcStep = undefinedChk(rows[list].tcStep,"");
                html += '<td id="appTxt">';
                if(tcStep=="00000"){
                    html += '시험전';
                }else if(tcStep=="00001"){
                    html += '시험중';
                }else if(tcStep=="00002"){
                    html += '시험완료';
                }else if(tcStep=="00003"){
                    html += '정산완료';
                }
                html += '</td>';
                html += '</tr>';
            }
        }
        html += '</table>';
        $("#tbody").html(html);
        //레이어 띄우기
        var containerH = $("#wrapper").outerHeight();
        $(".more_cal").parent().removeAttr("style").addClass("on");
        $(".more_cal").removeAttr("style").addClass("on");
        var _layerOn_length = $(".ly_group > .on").length;


        var _left = $(".more_cal").outerWidth() / 2;
        var _top = $(".more_cal").outerHeight() / 2;
        var height = "";
        if(rows.length<4){
            height = "600px";
        }

        $(".more_cal").css({
            "position": "absolute",
            "left": "50%",
            "top": "50%",
            "height" : height,
            "margin": -_top + "px 0 0 -" + _left + "px"
        });
        //레이어 띄우기

        $("#data_detail").html("");
    }

    //시험로 정보 selectbox 생성
    function drawPickData(rows){
    }

    $(document).on("click", ".accordion", function () {
        this.classList.toggle("active");
        var panel = this.nextElementSibling;
        if (panel.style.display === "block") {
            panel.style.display = "none";
        } else {
            panel.style.display = "block";
        }
    });
</script>
<!-- container -->
<div id="container">
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시험관리</span><span>스케쥴관리</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">스케쥴관리</h2>
        <!-- //title -->

        <!-- tab -->
        <div class="wrap_tab">
            <div class="tab">
                <button class="tablinks active" onclick="pageMove('tab1')">시험로</button>
                <button class="tablinks" onclick="pageMove('tab2')">부대시설</button>
            </div>
            <div class="wrap_tabcontent">
                <!-- tab1-시험로 -->
                <div id="tab1" class="tabcontent">
                    <!-- tab2 -->
                    <div class="webwidget_tab" id="webwidget_tab">
                        <div class="tabContainer">
                            <ul class="tabHead">
                                <li class="currentBtn"><a href="/admin/trReserve/trcalendar">달력으로 보기</a></li>
                                <li><a href="/admin/trReserve/trlist">목록으로 보기</a></li>
                            </ul>
                        </div>
                        <div class="tabBody">
                            <ul>
                                <!-- 달력으로 보기 -->
                                <li class="tabCot">
                                    <!-- calendar2 -->
                                    <div class="calendar_wrap2">
                                        <div class="btn_cal">
                                            <a href="/admin/trReserve/trcalendar?year=${today_info.before_year }&amp;month=${today_info.before_month }&amp;reqTrackType=${reqTrackType }&amp;reqCompType=${reqCompType }&amp;trTrackCode=${trTrackCode }&amp;tcApproval=3&amp;tcStep=0" class="prev"></a>
                                            <span>
	                                                    ${today_info.search_year}년 <c:if test="${today_info.search_month<10}">0</c:if>${today_info.search_month}월
	                                                </span>
                                            <a href="/admin/trReserve/trcalendar?year=${today_info.after_year}&amp;month=${today_info.after_month}&amp;reqTrackType=${reqTrackType }&amp;reqCompType=${reqCompType }&amp;trTrackCode=${trTrackCode }&amp;tcApproval=3&amp;tcStep=0"
                                               class="next"></a>
                                        </div>
                                        <!-- search_wrap -->
                                        <section class="search_wrap m-t-30 m-r-10">
                                            <div class="form_group">
                                                <div class="check_inline">
                                                    <span class="label">시험유형</span>
                                                    <label class="check_default">
                                                        <input type="checkbox" name="reqTrackType" value="s" <c:if test='${fn:indexOf(reqTrackType, "s")>-1}'>checked="checked"</c:if>/>
                                                        <span class="check_icon"></span>공동</label>
                                                    <label class="check_default">
                                                        <input type="checkbox" name="reqTrackType" value="m" <c:if test='${fn:indexOf(reqTrackType, "m")>-1}'>checked="checked"</c:if>/>
                                                        <span class="check_icon"></span>단독</label>
                                                </div>
                                            </div>
                                            <div class="form_group m-r-10">
                                                <div class="check_inline">
                                                    <span class="label">시험자구분</span>
                                                    <label class="check_default">
                                                        <input type="checkbox" name="reqCompType" value="h" <c:if test='${fn:indexOf(reqCompType, "h")>-1}'>checked="checked"</c:if>/>
                                                        <span class="check_icon"></span>T-HINT</label>
                                                    <label class="check_default">
                                                        <input type="checkbox" name="reqCompType" value="b" <c:if test='${fn:indexOf(reqCompType, "b")>-1}'>checked="checked"</c:if>/>
                                                        <span class="check_icon"></span>B2B회원</label>
                                                </div>
                                            </div>
                                            <div class="form_group">
                                                <!-- <label for="se1">검색선택</label> -->
                                                <div id="track1" class="select_group"></div>
                                            </div>
                                            <span id="track1Max" class="m-l-4"></span>
                                            <button type="button" id="btnSearch" class="btn-s btn_default">조회</button>
                                        </section>
                                        <!-- //search_wrap -->

                                        <div class="legend_cal">
                                            <span class="approval">승인대기중</span><span class="b2b m-l-14">B2B회원</span><span class="thint m-l-14">T-HINT</span> / [단]단독 [공] 공동
                                        </div>

                                        <!-- table list -->
                                        <section class="tbl_wrap_list_cal m-t-10">
                                            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                                                <caption>테이블</caption>
                                                <colgroup>
                                                    <col width="14.222%" />
                                                    <col width="14.222%" />
                                                    <col width="14.222%" />
                                                    <col width="14.222%" />
                                                    <col width="14.222%" />
                                                    <col width="14.222%" />
                                                    <col width="14.222%" />
                                                </colgroup>
                                                <thead>
                                                <tr>
                                                    <th scope="col">일</th>
                                                    <th scope="col">월</th>
                                                    <th scope="col">화</th>
                                                    <th scope="col">수</th>
                                                    <th scope="col">목</th>
                                                    <th scope="col">금</th>
                                                    <th scope="col">토</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:forEach var="dateList" items="${dateList}" varStatus="date_status">
                                                <c:set var="year" value="${dateList.year }" />
                                                <c:set var="month" value="${dateList.month+1 }" />
                                                <c:set var="date" value="${dateList.date }" />
                                                <c:if  test="${month < 10 }"><c:set var="month" value="0${month }" /></c:if>
                                                <c:if  test="${date < 10 }"><c:set var="date" value="0${date }" /></c:if>
                                                <c:set var="aid" value="${year }${month }${date }" />
                                                <c:if test='${dateList.value=="not_month"}'>
                                                    <td valign="top" class="next_month_txt">${dateList.date}</td>
                                                </c:if>
                                                <c:if test='${dateList.value!="not_month"}'>
                                                <c:choose>
                                                <c:when test="${date_status.index%7==6}">
                                                    <td valign="top" class="<c:if test="${dateList.value=='today'}">today_style </c:if>sat_day">
                                                            ${dateList.date}
                                                        <span class="capa">${dateList.strCnt}</span>
                                                            ${dateList.schedule_detail}
                                                        <c:if test="${dateList.schedule > 4}"><a href="#" id="dt${aid }" class="more" data-layer-top="more_cal">+ more</a></c:if></td>
                                                </c:when>
                                                <c:when test="${date_status.index%7==0}">
                                                </tr>
                                                <tr>
                                                    <td valign="top" class="<c:if test="${dateList.value=='today'}">today_style </c:if>sun_day">${dateList.date}
                                                        <span class="capa">${dateList.strCnt}</span>
                                                            ${dateList.schedule_detail}
                                                        <c:if test="${dateList.schedule > 4}"><a href="#" id="dt${aid }" class="more" data-layer-top="more_cal">+ more</a></c:if></td>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <td valign="top" class="<c:if test="${dateList.value=='today'}">today_style </c:if>normal_day">
                                                            ${dateList.date}
                                                        <span class="capa">${dateList.strCnt}</span>
                                                            ${dateList.schedule_detail}
                                                        <c:if test="${dateList.schedule > 4}"><a href="#" id="dt${aid }" class="more" data-layer-top="more_cal">+ more</a></c:if></td>
                                                    </c:otherwise>
                                                    </c:choose>
                                                    </c:if>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </section>
                                        <!-- //table list -->
                                    </div>
                                    <!-- //calendar2 -->
                                </li>
                                <!-- //달력으로 보기 -->
                            </ul>
                        </div>
                    </div>
                    <!-- //tab2 -->
                </div>
                <!-- //tab1-시험로 -->
            </div>
        </div>
        <!-- //tab -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<!-- popup_xxl -->
<div class="ly_group">
    <article class="layer_xxl more_cal">
        <!-- # 타이틀 # -->
        <h1>일자별 상세보기</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <!-- search_wrap -->
            <section class="search_wrap m-t-30 m-r-10">
                <div class="form_group">
                    <div class="check_inline">
                        <span class="label">시험유형</span>
                        <label class="check_default">
                            <input type="checkbox" name="trTrackType" value="s" <c:if test='${fn:indexOf(trTrackType, "s")>-1}'>checked="checked"</c:if>/>
                            <span class="check_icon"></span>공동</label>
                        <label class="check_default">
                            <input type="checkbox" name="trTrackType" value="m" <c:if test='${fn:indexOf(trTrackType, "m")>-1}'>checked="checked"</c:if>/>
                            <span class="check_icon"></span>단독</label>
                    </div>
                </div>
                <div class="form_group m-r-10">
                    <div class="check_inline">
                        <span class="label">시험자구분</span>
                        <label class="check_default">
                            <input type="checkbox" name="compType" value="h" <c:if test='${fn:indexOf(reqCompType, "h")>-1}'>checked="checked"</c:if>/>
                            <span class="check_icon"></span>T-HINT</label>
                        <label class="check_default">
                            <input type="checkbox" name="compType" value="b" <c:if test='${fn:indexOf(reqCompType, "b")>-1}'>checked="checked"</c:if>/>
                            <span class="check_icon"></span>B2B회원</label>
                    </div>
                </div>
                <div class="form_group">
                    <!-- <label for="se1">검색선택</label> -->
                    <div id="track2" class="select_group"></div>
                </div>
                <button type="button" id="btnSearch2" class="btn-s btn_default">조회</button>
            </section>
            <!-- //search_wrap -->
            <!-- table list -->
            <section class="tbl_wrap_list m-t-15">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="80px" />
                        <col width="" />
                        <col width="" />
                        <col width="" />
                        <col width="" />
                        <col width="" />
                        <col width="" />
                        <col width="" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">NO</th>
                        <th scope="col">예약번호</th>
                        <th scope="col"><button id="order3" class="btn_sort_down">접수일자</button></th>
                        <th scope="col"><button id="order1" class="btn_sort_down">시험일자</button></th>
                        <th scope="col">회사명</th>
                        <th scope="col">평가트랙</th>
                        <th scope="col"><button id="order5" class="btn_sort_up">유형</button></th>
                        <th scope="col">진행상태</th>
                    </tr>
                    </thead>
                    <tbody id="tbody">
                    </tbody>
                </table>
            </section>
            <!-- //table list -->
            <div id="data_detail" style="display:none">
                <!-- table list -->
                <section class="tbl_wrap_list m-t-30">
                    <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                        <caption>테이블</caption>
                        <colgroup>
                            <col width="" />
                            <col width="" />
                            <col width="" />
                            <col width="" />
                            <col width="" />
                            <col width="" />
                            <col width="" />
                        </colgroup>
                        <thead>
                        <tr>
                            <th scope="col">예약번호</th>
                            <th scope="col">접수일자</th>
                            <th scope="col">시험일자</th>
                            <th scope="col">유형</th>
                            <th scope="col">항목</th>
                            <th scope="col">회사명</th>
                            <th scope="col">진행상태</th>
                        </tr>
                        </thead>
                        <tbody id="pickList">
                        </tbody>
                    </table>
                </section>
                <!-- //table list -->

                <!-- 시험정보 -->
                <!-- accordion -->
                <div class="wrap_accordion2 m-t-30">
                    <button class="accordion">
                        <h3 class="stitle disib vam0">시험정보</h3>
                    </button>
                    <div class="accordion_panel" id="pickInfo">
                        <!-- table_view -->
                        <div class="tbl_wrap_view">
                            <table class="tbl_view01" summary="테이블입니다.">
                                <caption>테이블입니다.</caption>
                                <colgroup>
                                    <col width="180px;" />
                                    <col width="" />
                                </colgroup>
                                <tr>
                                    <th scope="row"></th>
                                    <td colspan="3"></td>
                                </tr>
                            </table>
                        </div>
                        <!-- //table_view -->
                    </div>
                </div>
                <!-- //accordion -->
                <!-- //시험정보 -->

                <!-- 예약 담당자 및 회계 담당자 정보 -->
                <!-- accordion -->
                <div class="wrap_accordion2 m-t-30">
                    <button class="accordion">
                        <h3 class="stitle disib vam0">예약 담당자 및 회계 담당자 정보</h3>
                    </button>
                    <div id="pickMember" class="accordion_panel">
                        <!-- table_view -->
                        <section class="tbl_wrap_view">
                            <table class="tbl_view01" summary="테이블입니다.">
                                <caption>테이블입니다.</caption>
                                <colgroup>
                                    <col width="180px;" />
                                    <col width="" />
                                    <col width="180px;" />
                                    <col width="" />
                                </colgroup>
                                <tr>
                                    <th scope="row">회사명</th>
                                    <td></td>
                                    <th></th>
                                    <td></td>
                                </tr>
                            </table>
                        </section>
                        <!-- //table_view -->
                    </div>
                </div>
                <!-- //accordion -->

                <!-- //예약 담당자 및 회계 담당자 정보 -->

                <!-- 관리자 메모 -->
                <h3 class="stitle m-t-30">관리자 메모</h3>
                <!-- table_view -->
                <div class="tbl_wrap_view m-t-10">
                    <table class="tbl_view01" summary="테이블입니다.">
                        <caption>테이블입니다.</caption>
                        <colgroup>
                            <col width="180px;" />
                            <col width="" />
                        </colgroup>
                        <tr>
                            <th scope="row">메모</th>
                            <td colspan="3">
                                <div class="form_group w_full">
                                    <textarea name="tcMemo" id="tcMemo" cols="" rows="5" class="form_control  h100"
                                              placeholder="메모를 입력하세요." maxlength="100"></textarea>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <!-- //table_view -->
                <!-- //관리자 메모 -->
            </div>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_xxl -->
<div id="tcDay" style="display:none"></div>
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>