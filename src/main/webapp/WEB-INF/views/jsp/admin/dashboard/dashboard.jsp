<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:csrfMetaTags/>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
    <title>::: [한국타이어] Technoring admin :::</title>

    <!-- 스타일 시트 -->
    <link rel="stylesheet" type="text/css" href="/inc/css/dashboarddefault.css">
    <link rel="stylesheet" type="text/css" href="/inc/admin/css/common.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/font.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/dashboardlayout.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/daterangepicker.css"><!-- daterangepicker style -->
    <link rel="stylesheet" type="text/css" href="/inc/css/jquery-ui.css"><!-- jquery-ui style -->
    <link rel="stylesheet" type="text/css" href="/inc/css/dashboard.css"><!-- dashboard style -->
    <link rel="stylesheet" type="text/css" href="/inc/css/scroll.css"><!-- scroll style -->


    <!-- 스크립트 -->
    <script type="text/javascript" src="/inc/js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="/inc/js/adminNavi.js"></script> <!-- navigation -->
    <script type="text/javascript" src="/inc/js/common.js"></script>
    <script type="text/javascript" src="/inc/js/moment.min.js"></script> <!-- daterangepicker -->
    <script type="text/javascript" src="/inc/js/daterangepicker.js"></script> <!-- daterangepicker -->
    <script type="text/javascript" src="/inc/js/jquery-ui.js"></script> <!-- jquery-ui -->
    <script type="text/javascript" src="/inc/js/navi.js"></script> <!-- navigation -->
 	<script type="text/javascript" src="/inc/js/jquery.scrollbar.js"></script> <!-- scroll -->
    <!-- 공통 추가 -->
<!--     <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script> jquery 충돌로 주석처리-->
	<script src="/inc/js/sh.js"></script>
</head>
<script type="text/javascript">
var ride = new Array();
var braking = new Array();
var vda = new Array();
var pbn = new Array();
var nvh = new Array();
var whc = new Array();
var hso = new Array();
var dhc = new Array();
var gnr = new Array();

var chipCut = new Array();//추가
var hydStraight = new Array();//추가
var hydCurve = new Array();//추가
//capa
var ridecapa = 0;
var brakingcapa = 0;
var vdacapa =  0;
var pbncapa =  0;
var nvhcapa =  0;
var whccapa =  0;
var hsocapa =  0;
var dhccapa =  0;
var gnrcapa =  0;

var chipCutcapa = 0;
var hydStraightcapa = 0;
var hydCurvecapa = 0;
//시험완료
var rideend = 0;
var brakingend = 0;
var vdaend =0;
var pbnend = 0;
var nvhend = 0;
var whcend = 0;
var hsoend = 0;
var dhcend = 0;

var chipCutend = 0;
var hydStraightend = 0;
var hydCurveend = 0;
//누적시간
var rideTime =0;
var brakingTime = 0;
var vdaTime = 0;
var pbnTime = 0;
var nvhTime = 0;
var whcTime = 0;
var hsoTime = 0;
var dhcTime = 0;

var chipCutTime = 0;
var hydStraightTime = 0;
var hydCurveTime = 0;

var MakeDateForm = function ( sec ) {
    var hours = Math.floor(sec/ 60 / 60);
    var mins = Math.floor((sec - (hours * 60)*60)/60);
	var second = Math.floor(sec - (hours*60*60) - (mins*60))
    var hourStr = (hours > 9)? hours : '0' + hours
    var minStr = (mins > 9)? mins : '0' + mins
    var secStr = (second > 9)? second : '0' + second

    return hourStr + ':' + minStr + ':' + secStr;
}

function initvalue(){
	ride = new Array();
	braking = new Array();
	vda = new Array();
	pbn = new Array();
	nvh = new Array();
	whc = new Array();
	hso = new Array();
	dhc = new Array();
	gnr = new Array();
	chipCut = new Array();//추가
	hydStraight = new Array();//추가
	hydCurve = new Array();//추가
	//capa
	ridecapa = 0;
	brakingcapa = 0;
	vdacapa =  0;
	pbncapa =  0;
	nvhcapa =  0;
	whccapa =  0;
	hsocapa =  0;
	dhccapa =  0;
	gnrcapa =  0;
	chipCutcapa = 0;
	hydStraightcapa = 0;
	hydCurvecapa = 0;
	//시험완료
	rideend = 0;
	brakingend = 0;
	vdaend =0;
	pbnend = 0;
	nvhend = 0;
	whcend = 0;
	hsoend = 0;
	dhcend = 0;
	chipCutend = 0;
	hydStraightend = 0;
	hydCurveend = 0;
	//누적시간
	rideTime =0;
	brakingTime = 0;
	vdaTime = 0;
	pbnTime = 0;
	nvhTime = 0;
	whcTime = 0;
	hsoTime = 0;
	dhcTime = 0;
	chipCutTime = 0;
	hydStraightTime = 0;
	hydCurveTime = 0;
}
$(function(){
	// 스크롤
    jQuery(document).ready(function () {
        jQuery('.scrollbar-inner').scrollbar();
    });
	init();
	setInterval(function() {
		var  Now = new Date(),
		   StrNow = String(Now),
		   nowYear = String(Now.getFullYear()),
		       nowMon = String(Now.getMonth()+1),
		   nowDay = String(Now.getDate());
		if(nowMon.length == 1) {
		nowMon = "0"+nowMon;
		}

		var nowD = String(Now.getDay());
		if(nowD == "1"){
			nowD ="월";
		}else if(nowD == "2"){
			nowD ="화";
		}else if(nowD == "3"){
			nowD ="수";
		}else if(nowD == "4"){
			nowD ="목";
		}else if(nowD == "5"){
			nowD ="금";
		}else if(nowD == "6"){
			nowD ="토";
		}else{
			nowD ="일";
		}

		var nowH = String(Now.getHours());
		if(nowH.length == 1) {
			nowH = "0"+nowH;
		}
		var nowMin = String(Now.getMinutes());
		if(nowMin.length == 1) {
			nowMin = "0"+nowMin;
		}
		var nowSec = String(Now.getSeconds());
		if(nowSec.length == 1) {
			nowSec = "0"+nowSec;
		}
		var NowToday = nowYear+"."+nowMon+"."+nowDay+"("+nowD+") "+nowH+":"+nowMin+":"+nowSec+" 갱신";
// 		console.log('NowToday', NowToday);
		$("#nowtime").text(NowToday);
	},1000);
})
function search(){
	var param = {
	}
	postAjax("/admin/dashboard/search",param,"searchCallBack",null,null,null);
}
function init(){
	var  Now = new Date(),
	   StrNow = String(Now),
	   nowYear = String(Now.getFullYear()),
	       nowMon = String(Now.getMonth()+1),
	   nowDay = String(Now.getDate());
	if(nowMon.length == 1) {
		nowMon = "0"+nowMon;
	}
	var nowD = String(Now.getDay());
	if(nowD == "1"){
		nowD ="월";
	}else if(nowD == "2"){
		nowD ="화";
	}else if(nowD == "3"){
		nowD ="수";
	}else if(nowD == "4"){
		nowD ="목";
	}else if(nowD == "5"){
		nowD ="금";
	}else if(nowD == "6"){
		nowD ="토";
	}else{
		nowD ="일";
	}
	var nowH = String(Now.getHours());
	if(nowH.length == 1) {
		nowH = "0"+nowH;
	}
	var nowMin = String(Now.getMinutes());
	if(nowMin.length == 1) {
		nowMin = "0"+nowMin;
	}
	var nowSec = String(Now.getSeconds());
	if(nowSec.length == 1) {
		nowSec = "0"+nowSec;
	}
	var NowToday = nowYear+"."+nowMon+"."+nowDay+"("+nowD+") "+nowH+":"+nowMin+":"+nowSec+" 갱신";
//	console.log('NowToday', NowToday);
	$("#nowtime").text(NowToday);
	//capa 조회
	capaSearch();
	search();
	setInterval(function() {
		capaSearch();
		search();
	},60000);
}
function capaSearch(){
	initvalue();
	var param = {
	}
	postAjax("/admin/dashboard/capaSearch",param,"capaSearchCallBack",null,null,null);
}
function capaSearchCallBack(data){
	console.log(data);
	var list = data.list;
	$.each(list,function(i,el){
		if(list[i].tnickname=="RIDE"){
			ridecapa = list[i].tmax;
		}else if(list[i].tnickname=="BRAKING"){
			brakingcapa = list[i].tmax;
		}else if(list[i].tnickname=="VDA"){
			vdacapa = list[i].tmax;
		}else if(list[i].tnickname=="PBN"){
			pbncapa = list[i].tmax;
		}else if(list[i].tnickname=="NVH"){
			nvhcapa = list[i].tmax;
		}else if(list[i].tnickname=="WHC"){
			whccapa = list[i].tmax;
		}else if(list[i].tnickname=="HSO"){
			hsocapa = list[i].tmax;
		}else if(list[i].tnickname=="DHC"){
			dhccapa = list[i].tmax;
		}else if(list[i].tnickname=="Chip-Cut"){
			chipCutcapa = list[i].tmax;
		}else if(list[i].tnickname=="Hyd-Straight"){
			hydStraightcapa = list[i].tmax;
		}else if(list[i].tnickname=="Hyd-Curve"){
			hydCurvecapa = list[i].tmax;
		}else{
		}
	});
}
//var ride,braking,vda,pbn,nvh,whc,hso,dhc,gnr = new Array();
function searchCallBack(data){
	console.log(data);
	var list = data.list;

	if(list.length>0){
		$("#testing").text(list[0].totalCnt);
		$("#testhk").text(list[0].hkCnt);
		$("#testb2b").text(list[0].b2bCnt);
		$.each(list,function(i,el){
			if(list[i].tnickname=="RIDE"){
				if(list[i].trackOutTime == null){
					ride.push(list[i]);
				}else{
					gnr.push(list[i]);
					rideend += 1;
					rideTime += list[i].diffTime;
				}
			}else if(list[i].tnickname=="BRAKING"){
				if(list[i].trackOutTime == null){
					braking.push(list[i]);
				}else{
					gnr.push(list[i]);
					brakingend += 1;
					brakingTime += list[i].diffTime;
				}
			}else if(list[i].tnickname=="VDA"){
				if(list[i].trackOutTime == null){
					vda.push(list[i]);
				}else{
					gnr.push(list[i]);
					vdaend += 1;
					vdaTime += list[i].diffTime;
				}
			}else if(list[i].tnickname=="PBN"){
				if(list[i].trackOutTime == null){
					pbn.push(list[i]);
				}else{
					gnr.push(list[i]);
					pbnend += 1;
					pbnTime += list[i].diffTime;
				}
			}else if(list[i].tnickname=="NVH"){
				if(list[i].trackOutTime == null){
					nvh.push(list[i]);
				}else{
					gnr.push(list[i]);
					nvhend += 1;
					nvhTime += list[i].diffTime;
				}
			}else if(list[i].tnickname=="WHC"){
				if(list[i].trackOutTime == null){
					riwhcde.push(list[i]);
				}else{
					gnr.push(list[i]);
					whcend += 1;
					whcTime += list[i].diffTime;
				}
			}else if(list[i].tnickname=="HSO"){
				if(list[i].trackOutTime == null){
					hso.push(list[i]);
				}else{
					gnr.push(list[i]);
					hsoend += 1;
					hsoTime += list[i].diffTime;
				}
			}else if(list[i].tnickname=="DHC"){
				if(list[i].trackOutTime == null){
					dhc.push(list[i]);
				}else{
					gnr.push(list[i]);
					dhcend += 1;
					dhcTime += list[i].diffTime;
				}
			}else if(list[i].tnickname=="Chip-Cut"){
				if(list[i].trackOutTime == null){
					chipCut.push(list[i]);
				}else{
					gnr.push(list[i]);
					chipCutend += 1;
					chipCutTime += list[i].diffTime;
				}
			}else if(list[i].tnickname=="Hyd-Straight"){
				if(list[i].trackOutTime == null){
					hydStraight.push(list[i]);
				}else{
					gnr.push(list[i]);
					hydStraightend += 1;
					hydStraightTime += list[i].diffTime;
				}
			}else if(list[i].tnickname=="Hyd-Curve"){
				if(list[i].trackOutTime == null){
					hydCurve.push(list[i]);
				}else{
					gnr.push(list[i]);
					hydCurveend += 1;
					hydCurveTime += list[i].diffTime;
				}
			}else{
				gnr.push(list[i]);
			}
		});
	}else{
		$("#testing").text("0");
		$("#testhk").text("0");
		$("#testb2b").text("0");
	}
	//ride
	var rideHtml="";
	for(var i =0;i<ride.length;i++){
		rideHtml+='<tr>                 ';
		rideHtml+='    <td>'+ride[i].compName+'</td>';
		rideHtml+='    <td>'+ride[i].trackInTime.substring(8,10)+':'+ride[i].trackInTime.substring(10,12)+'</td>   ';
		rideHtml+='    <td>'+ride[i].dname+'</td>  ';
		rideHtml+='</tr>                ';
	}
	$("#ridetime").text("· 누적 평가시간 : "+MakeDateForm(rideTime));
	$("#rideend").text("· 시험완료 : "+rideend);
	$("#ridecnt").text("Ride ("+ride.length+"/"+ridecapa+")");
	$("#rideList").html(rideHtml);
	//braking
	var brakingHtml="";
	for(var i =0;i<braking.length;i++){
		brakingHtml+='<tr>                 ';
		brakingHtml+='    <td>'+braking[i].compName+'</td>';
		brakingHtml+='    <td>'+braking[i].trackInTime.substring(8,10)+':'+braking[i].trackInTime.substring(10,12)+'</td>   ';
		brakingHtml+='    <td>'+braking[i].dname+'</td>  ';
		brakingHtml+='</tr>                ';
	}
	for(var i =0;i<hydStraight.length;i++){
		brakingHtml+='<tr>                 ';
		brakingHtml+='    <td>'+hydStraight[i].compName+'</td>';
		brakingHtml+='    <td>'+hydStraight[i].trackInTime.substring(8,10)+':'+hydStraight[i].trackInTime.substring(10,12)+'</td>   ';
		brakingHtml+='    <td>'+hydStraight[i].dname+'</td>  ';
		brakingHtml+='</tr>                ';
	}
	$("#brakingtime").text("· 누적 평가시간 : "+MakeDateForm((brakingTime+hydStraightTime)));
	$("#brakingend").text("· 시험완료 : "+(brakingend+hydStraightend));
	$("#brakingcnt").text("Braking ("+(braking.length+hydStraight.length)+"/"+(brakingcapa+hydStraightcapa)+")");
	$("#brakingList").html(brakingHtml);
	//vda
	var vdaHtml="";
	for(var i =0;i<vda.length;i++){
		vdaHtml+='<tr>                 ';
		vdaHtml+='    <td>'+vda[i].compName+'</td>';
		vdaHtml+='    <td>'+vda[i].trackInTime.substring(8,10)+':'+vda[i].trackInTime.substring(10,12)+'</td>   ';
		vdaHtml+='    <td>'+vda[i].dname+'</td>  ';
		vdaHtml+='</tr>                ';
	}
	$("#vdatime").text("· 누적 평가시간 : "+MakeDateForm(vdaTime));
	$("#vdaend").text("· 시험완료 : "+vdaend);
	$("#vdacnt").text("VDA ("+vda.length+"/"+vdacapa+")");
	$("#vdaList").html(vdaHtml);
	//pbn/nvh
	var pbnnvhHtml="";
	for(var i =0;i<pbn.length;i++){
		pbnnvhHtml+='<tr>                 ';
		pbnnvhHtml+='    <td>'+pbn[i].compName+'</td>';
		pbnnvhHtml+='    <td>'+pbn[i].trackInTime.substring(8,10)+':'+pbn[i].trackInTime.substring(10,12)+'</td>   ';
		pbnnvhHtml+='    <td>'+pbn[i].dname+'</td>  ';
		pbnnvhHtml+='</tr>                ';
	}
	for(var i =0;i<nvh.length;i++){
		pbnnvhHtml+='<tr>                 ';
		pbnnvhHtml+='    <td>'+nvh[i].compName+'</td>';
		pbnnvhHtml+='    <td>'+nvh[i].trackInTime.substring(8,10)+':'+nvh[i].trackInTime.substring(10,12)+'</td>   ';
		pbnnvhHtml+='    <td>'+nvh[i].dname+'</td>  ';
		pbnnvhHtml+='</tr>                ';
	}
	var sumcnt = pbn.length +nvh.length;
	var capasumcnt = pbncapa +nvhcapa;
	var pbnnvhend = pbnend + nvhend;
	var pbnnvhTime = pbnTime + nvhTime;
	$("#pbnnvhtime").text("· 누적 평가시간 : "+MakeDateForm(pbnnvhTime));
	$("#pbnnvhend").text("· 시험완료 : "+pbnnvhend);
	$("#pbnnvhcnt").text("PBN/NVH ("+sumcnt+"/"+capasumcnt+")");
	$("#pbnnvhList").html(pbnnvhHtml);
	//whc
	var whcHtml="";
	for(var i =0;i<whc.length;i++){
		whcHtml+='<tr>                 ';
		whcHtml+='    <td>'+whc[i].compName+'</td>';
		whcHtml+='    <td>'+whc[i].trackInTime.substring(8,10)+':'+whc[i].trackInTime.substring(10,12)+'</td>   ';
		whcHtml+='    <td>'+whc[i].dname+'</td>  ';
		whcHtml+='</tr>                ';
	}
	for(var i =0;i<hydCurve.length;i++){
		whcHtml+='<tr>                 ';
		whcHtml+='    <td>'+hydCurve[i].compName+'</td>';
		whcHtml+='    <td>'+hydCurve[i].trackInTime.substring(8,10)+':'+hydCurve[i].trackInTime.substring(10,12)+'</td>   ';
		whcHtml+='    <td>'+hydCurve[i].dname+'</td>  ';
		whcHtml+='</tr>                ';
	}
	var sumcnt1 = whc.length+hydCurve.length;
	var capasumcnt1 = whccapa+hydCurvecapa;
	var endcnt1 = whcend+hydCurveend;
	var sumtime1 = whcTime+hydCurveTime;
	$("#whctime").text("· 누적 평가시간 : "+MakeDateForm(sumtime1));
	$("#whcend").text("· 시험완료 : "+ endcnt1);
	$("#whccnt").text("WHC ("+sumcnt1+"/"+capasumcnt1+")");
	$("#whcList").html(whcHtml);
	//hso
	var hsoHtml="";
	for(var i =0;i<hso.length;i++){
		hsoHtml+='<tr>                 ';
		hsoHtml+='    <td>'+hso[i].compName+'</td>';
		hsoHtml+='    <td>'+hso[i].trackInTime.substring(8,10)+':'+hso[i].trackInTime.substring(10,12)+'</td>   ';
		hsoHtml+='    <td>'+hso[i].dname+'</td>  ';
		hsoHtml+='</tr>                ';
	}
	$("#hsotime").text("· 누적 평가시간 : "+MakeDateForm(hsoTime));
	$("#hsoend").text("· 시험완료 : "+hsoend);
	$("#hsocnt").text("HSO ("+hso.length+"/"+hsocapa+")");
	$("#hsoList").html(hsoHtml);
	//dhc
	var dhcHtml="";
	for(var i =0;i<dhc.length;i++){
		dhcHtml+='<tr>                 ';
		dhcHtml+='    <td>'+dhc[i].compName+'</td>';
		dhcHtml+='    <td>'+dhc[i].trackInTime.substring(8,10)+':'+dhc[i].trackInTime.substring(10,12)+'</td>   ';
		dhcHtml+='    <td>'+dhc[i].dname+'</td>  ';
		dhcHtml+='</tr>                ';
	}
	for(var i =0;i<chipCut.length;i++){
		dhcHtml+='<tr>                 ';
		dhcHtml+='    <td>'+chipCut[i].compName+'</td>';
		dhcHtml+='    <td>'+chipCut[i].trackInTime.substring(8,10)+':'+chipCut[i].trackInTime.substring(10,12)+'</td>   ';
		dhcHtml+='    <td>'+chipCut[i].dname+'</td>  ';
		dhcHtml+='</tr>                ';
	}
	var sumcnt2 = dhc.length+chipCut.length;
	var capasumcnt2 = dhccapa+chipCutcapa;
	var endcnt2 = dhcend+chipCutend;
	var sumtime2 = dhcTime+chipCutTime;
	$("#dhctime").text("· 누적 평가시간 : "+MakeDateForm(sumtime2));
	$("#dhcend").text("· 시험완료 : "+endcnt2);
	$("#dhccnt").text("DHC ("+sumcnt2+"/"+capasumcnt2+")");
	$("#dhcList").html(dhcHtml);
	//gnr
	var gnrHtml="";
	//중복제거
	var newGnr = new Array();
	gnr.reduce(function(acc, current) {
	  if (ride.findIndex(({ carRfidId }) => carRfidId === current.carRfidId) === -1
		&&braking.findIndex(({ carRfidId }) => carRfidId === current.carRfidId) === -1
		&&vda.findIndex(({ carRfidId }) => carRfidId === current.carRfidId) === -1
		&&pbn.findIndex(({ carRfidId }) => carRfidId === current.carRfidId) === -1
		&&nvh.findIndex(({ carRfidId }) => carRfidId === current.carRfidId) === -1
		&&whc.findIndex(({ carRfidId }) => carRfidId === current.carRfidId) === -1
		&&hso.findIndex(({ carRfidId }) => carRfidId === current.carRfidId) === -1
		&&dhc.findIndex(({ carRfidId }) => carRfidId === current.carRfidId) === -1
		&&chipCut.findIndex(({ carRfidId }) => carRfidId === current.carRfidId) === -1
		&&hydStraight.findIndex(({ carRfidId }) => carRfidId === current.carRfidId) === -1
		&&hydCurve.findIndex(({ carRfidId }) => carRfidId === current.carRfidId) === -1) {
		  if (acc.findIndex(({ carRfidId }) => carRfidId === current.carRfidId) === -1) {
			newGnr.push(current);
		    acc.push(current);
		  }
	  }
	  return acc;
	}, []);
	for(var i =0;i<newGnr.length;i++){
		gnrHtml+='<tr>                 ';
	    gnrHtml+='    <td>'+newGnr[i].compName+'</td>';
	    gnrHtml+='    <td>'+newGnr[i].gnrInTime.substring(8,10)+':'+newGnr[i].gnrInTime.substring(10,12)+'</td>   ';
	    gnrHtml+='    <td>'+newGnr[i].dname+'</td>  ';
	    gnrHtml+='</tr>                ';
	}
	$("#gnrList").html(gnrHtml);
}
</script>

<body>
    <!-- u_skip -->
    <div id="u_skip">
        <a href="#container">본문 바로가기</a></li>
    </div>
    <!-- //u_skip -->

    <!-- wrapper -->
    <div id="wrapper" class="dashBoard">
        <!-- header_wrap -->
        <div class="header_wrap">
            <div class="wrap_title">
                <h1 class="logo"><a href="/admin"><img src="/inc/images/BI_Technoring_white.png" alt="Technoring" /></a></h1>
                <span class="title">통합관제시스템 시험로 운영 현황</span>
            </div>
            <div class="wrap_state">
                <div class="state">
                    <span>시험중 <strong id="testing">0</strong></span>
                    <span>HK <strong id="testhk">0</strong></span>
                    <span>B2B <strong id="testb2b">0</strong></span>
                </div>
                <div class="update_time" id="nowtime"></div>
            </div>
        </div>
        <!-- //header_wrap -->
        <!-- container -->
        <div id="container">
            <!-- content -->
            <div class="content">
                <!-- Ride -->
                <div class="box_state ride">
                    <div class="wrap_header m-b-9">
                        <p id="ridecnt">Ride (0/0)</p>
                        <ul>
                            <li id="rideend">· 시험완료 : 0</li>
                            <li id="ridetime">· 누적 평가시간 : 01:05:11</li>
                        </ul>
                    </div>
                    <div class="wrap_tbl scrollbar-inner">
                        <!-- table list -->
                        <section class="tbl_wrap_list_db">
                            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                                <caption>테이블</caption>
                                <colgroup>
                                    <col width="" />
                                    <col width="" />
                                    <col width="90px" />
                                </colgroup>
                                <tbody id="rideList">
<!--                                     <tr> -->
<!--                                         <td>한국타이어</td> -->
<!--                                         <td>16:43</td> -->
<!--                                         <td>홍길동</td> -->
<!--                                     </tr> -->
                                </tbody>
                            </table>
                        </section>
                        <!-- //table list -->
                    </div>
                </div>
                <!-- //Ride -->

                <!-- Braking -->
                <div class="box_state braking">
                    <div class="wrap_header m-b-9">
                        <p id="brakingcnt">Braking (0/0)</p>
                        <ul>
                            <li id="brakingend">· 시험완료 : 0</li>
                            <li id="brakingtime">· 누적 평가시간 : 00:00</li>
                        </ul>
                    </div>
                    <div class="wrap_tbl scrollbar-inner">
                        <!-- table list -->
                        <section class="tbl_wrap_list_db">
                            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                                <caption>테이블</caption>
                                <colgroup>
                                    <col width="" />
                                    <col width="" />
                                    <col width="90px" />
                                </colgroup>
                                <tbody id="brakingList">
<!--                                     <tr> -->
<!--                                         <td>한국타이어</td> -->
<!--                                         <td>16:43</td> -->
<!--                                         <td>홍길동</td> -->
<!--                                     </tr> -->
                                </tbody>
                            </table>
                        </section>
                        <!-- //table list -->
                    </div>
                </div>
                <!-- //Braking -->

                <!-- VDA -->
                <div class="box_state vda">
                    <div class="wrap_header m-b-9">
                        <p id="vdacnt">VDA (0/0)</p>
                        <ul>
                            <li id="vdaend">· 시험완료 : 0</li>
                            <li id="vdatime">· 누적 평가시간 : 00:00</li>
                        </ul>
                    </div>
                    <div class="wrap_tbl scrollbar-inner">
                        <!-- table list -->
                        <section class="tbl_wrap_list_db">
                            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                                <caption>테이블</caption>
                                <colgroup>
                                    <col width="" />
                                    <col width="" />
                                    <col width="90px" />
                                </colgroup>
                                <tbody id="vdaList">
<!--                                     <tr> -->
<!--                                         <td>한국타이어</td> -->
<!--                                         <td>16:43</td> -->
<!--                                         <td>홍길동</td> -->
<!--                                     </tr> -->
                                </tbody>
                            </table>
                        </section>
                        <!-- //table list -->
                    </div>
                </div>
                <!-- //VDA -->

                <!-- PBN -->
                <div class="box_state pbn">
                    <div class="wrap_header m-b-9">
                        <p id="pbnnvhcnt">PBN/NVH (0/0)</p>
                        <ul>
                            <li id="pbnnvhend">· 시험완료 : 0</li>
                            <li id="pbnnvhtime">· 누적 평가시간 : 00:00</li>
                        </ul>
                    </div>
                    <div class="wrap_tbl scrollbar-inner">
                        <!-- table list -->
                        <section class="tbl_wrap_list_db">
                            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                                <caption>테이블</caption>
                                <colgroup>
                                    <col width="" />
                                    <col width="" />
                                    <col width="90px" />
                                </colgroup>
                                <tbody id="pbnnvhList">
<!--                                     <tr> -->
<!--                                         <td>한국타이어</td> -->
<!--                                         <td>16:43</td> -->
<!--                                         <td>홍길동</td> -->
<!--                                     </tr> -->
                                </tbody>
                            </table>
                        </section>
                        <!-- //table list -->
                    </div>
                </div>
                <!-- //PBN -->

                <!-- WHC -->
                <div class="box_state whc">
                    <div class="wrap_header m-b-9">
                        <p id="whccnt">WHC (0/0)</p>
                        <ul>
                            <li id="whcend">· 시험완료 : 0</li>
                            <li id="whctime">· 누적 평가시간 : 00:00</li>
                        </ul>
                    </div>
                    <div class="wrap_tbl scrollbar-inner">
                        <!-- table list -->
                        <section class="tbl_wrap_list_db">
                            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                                <caption>테이블</caption>
                                <colgroup>
                                    <col width="" />
                                    <col width="" />
                                    <col width="90px" />
                                </colgroup>
                                <tbody id="whcList">
<!--                                     <tr> -->
<!--                                         <td>한국타이어</td> -->
<!--                                         <td>16:43</td> -->
<!--                                         <td>홍길동</td> -->
<!--                                     </tr> -->
                                </tbody>
                            </table>
                        </section>
                        <!-- //table list -->
                    </div>
                </div>
                <!-- //WHC -->

                <!-- HSO -->
                <div class="box_state hso">
                    <div class="wrap_header m-b-9">
                        <p id="hsocnt">HSO (0/0)</p>
                        <ul>
                            <li id="hsoend">· 시험완료 : 0</li>
                            <li id="hsotime">· 누적 평가시간 : 00:00</li>
                        </ul>
                    </div>
                    <div class="wrap_tbl scrollbar-inner">
                        <!-- table list -->
                        <section class="tbl_wrap_list_db">
                            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                                <caption>테이블</caption>
                                <colgroup>
                                    <col width="" />
                                    <col width="" />
                                    <col width="90px" />
                                </colgroup>
                                <tbody id="hsoList">
<!--                                     <tr> -->
<!--                                         <td>한국타이어</td> -->
<!--                                         <td>16:43</td> -->
<!--                                         <td>홍길동</td> -->
<!--                                     </tr> -->
                                </tbody>
                            </table>
                        </section>
                        <!-- //table list -->
                    </div>
                </div>
                <!-- //HSO -->

                <!-- DHC -->
                <div class="box_state dhc">
                    <div class="wrap_header m-b-9">
                        <p id="dhccnt">DHC (0/0)</p>
                        <ul>
                            <li id="dhcend">· 시험완료 : 0</li>
                            <li id="dhctime">· 누적 평가시간 : 00:00</li>
                        </ul>
                    </div>
                    <div class="wrap_tbl scrollbar-inner">
                        <!-- table list -->
                        <section class="tbl_wrap_list_db">
                            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                                <caption>테이블</caption>
                                <colgroup>
                                    <col width="" />
                                    <col width="" />
                                    <col width="90px" />
                                </colgroup>
                                <tbody id="dhcList">
<!--                                     <tr> -->
<!--                                         <td>한국타이어</td> -->
<!--                                         <td>16:43</td> -->
<!--                                         <td>홍길동</td> -->
<!--                                     </tr> -->
                                </tbody>
                            </table>
                        </section>
                        <!-- //table list -->
                    </div>
                </div>
                <!-- //DHC -->

                <!-- GNR -->
                <div class="box_state2 gnr">
                    <div class="wrap_header m-b-9">
                        <p>GNR</p>
                    </div>
                    <div class="wrap_tbl scrollbar-inner">
                        <!-- table list -->
                        <section class="tbl_wrap_list_db">
                            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                                <caption>테이블</caption>
                                <colgroup>
                                    <col width="" />
                                    <col width="" />
                                    <col width="90px" />
                                </colgroup>
                                <tbody id="gnrList">
<!--                                     <tr> -->
<!--                                         <td>한국타이어</td> -->
<!--                                         <td>16:43</td> -->
<!--                                         <td>홍길동</td> -->
<!--                                     </tr> -->
                                </tbody>
                            </table>
                        </section>
                        <!-- //table list -->
                    </div>
                </div>
                <!-- //GNR -->

            </div>
            <!-- //content -->
        </div>
        <!-- //wrapper -->

</body>

</html>
