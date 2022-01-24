$(document).ajaxError(function(event,jqxhr,setting,thrownError){
	$(".lodingdimm").hide();
	console.log("ERROR event = ",event);
	console.log("ERROR jqxhr = ",jqxhr);
	console.log("ERROR setting = ",setting);
	console.log("ERROR thrownError = ",thrownError);
	if(jqxhr.responseJSON !=null && jqxhr.responseJSON!="undefined"){
		if(jqxhr.responseJSON.code != null && jqxhr.responseJSON.code != "null" &&jqxhr.responseJSON.code != "undefined"){
			alert("[시스템 오류]관리자에게 문의해 주세요.");
//		alert(jqxhr.responseJSON.code+" ERROR 발생<br/>"+jqxhr.responseJSON.message);
		}else{
//		alert("[시스템 오류]관리자에게 문의해 주세요.");
			alert(jqxhr.responseJSON);
		}
	}
//	if(jqxhr.responseJSON.code == 401){
//
//	}else{
//
//	}
});
$(document).ajaxStart(function(){
	$(".lodingdimm").show();
});
$(document).ajaxSuccess(function(){
	$(".lodingdimm").hide();
});
$(document).ready(function(){
	$(".lodingdimm").hide();
});
window.onload = function () { $(".lodingdimm").hide(); }

$(document).ready(function () {
//	$(".lodingdimm").hide();
    /* -------------------------------------------------
    	lnb
    ------------------------------------------------- */

    //lnb 상단현황 영역 브라우저 사이즈에 따른 위치 이동
    lnbScroll();
    $(window).resize(function () {
        lnbScroll();
    });

    // lnb 열기/접기
    $(".gnb_wrap > .btn_gnb").click(function () {

        if ($(this).parent().hasClass("close")) {
            $(this).parent().removeClass("close");
            // $(this).text("열기");
        } else {
            $(this).parent().addClass("close");
            // $(this).text("접기");
        }

        lnbScroll();
        $(window).resize(function () {
            lnbScroll();
        });
    });

    /* -------------------------------------------------
    	레이어 팝업
    ------------------------------------------------- */
    $(document).on("click","[data-layer]",function (e) {
        var containerH = $("#wrapper").outerHeight();
        var _target = $(this).attr("data-layer");
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
			var _layerOn_length2 = $(".ly_group2 > .on").length;

			if (_layerOn_length2 && $("." + _target).parent().hasClass('ly_fixed')) {
				var _left = $("." + _target).outerWidth() / 2 + 213;
				var _top = $("." + _target).outerHeight() / 2;
				$("." + _target).css({
					"position": "absolute",
					"left": "50%",
					"top": "50%",
					"margin": -_top + "px 0 0 -" + _left + "px"
				});

			} else if (_layerOn_length2) {
				var _left = $("." + _target).outerWidth() / 2;
				var _top = $("." + _target).outerHeight() / 2;
				$("." + _target).css({
					"position": "absolute",
					"left": "50%",
					"top": "50%",
					"margin": -_top + "px 0 0 -" + _left + "px"
				});
			}

        e.preventDefault();

    });

    $("[data-fn='lyClose'], .lyClose, .closePopupBtn").click(function () {
        $("#errdriverSelect").text("").removeClass("redfont").removeClass("info_ment");
        $("#errdriverLevel").text("").removeClass("redfont").removeClass("info_ment");

        var _layerOn_length = $(".ly_group > .on, .ly_group > .on").length;
        if (_layerOn_length) {
            $(".ly_group > .on").removeClass("on")
                .parent().removeClass("on");
        } else {
            $(this).parent().removeClass("on")
                .parent().removeClass("on");
        }
    });

  $("[data-fn='lyClose2'], .lyClose2, .closePopupBtn").click(function () {

    var _layerOn_length = $(".ly_group2 > .on, .ly_group2 > .on").length;
    if (_layerOn_length) {
      $(".ly_group2 > .on").removeClass("on")
      .parent().removeClass("on");
    } else {
      $(this).parent().removeClass("on")
      .parent().removeClass("on");
    }
  });

});

/* -------------------------------------------------
	lnb함수
------------------------------------------------- */
//lnb 상단현황 함수 절대 삭제하지 말것!
function lnbScroll() {
    // var lnbH = $(".lnb").outerHeight();
    // var h2H = $(".lnb > h2").outerHeight();
    // var navH = $(".lnb > .nav").outerHeight();
    // var area_wrapH = $(".lnb > .area_wrap").outerHeight();
    // var allH = h2H + navH + area_wrapH + 66;
    // if(lnbH >= allH){
    // 	$(".lnb > .area_wrap").addClass("bottom");
    // }else{
    // 	$(".lnb > .area_wrap").removeClass("bottom");
    // 	$(".lnb:after").css("width","10px");
    // }
}

//date picker
$(document).ready(function () {

    $(function () {
//        $('.date1').daterangepicker({
//            autoUpdateInput: false,
//            singleDatePicker: true,
//            showDropdowns: false, //년월 수동 설정 여부
//            autoApply: true, //true 확인 취소버튼을 숨기고 날짜클릭시 자동적용
//            locale: {
//                monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월",
//                    "12월"
//                ],
//                daysOfWeek: ["월", "화", "수", "목", "금", "토", "일"],
//                format: "YYYY-MM-DD",
//                cancelLabel: '취소',
//                applyLabel: "확인",
//            }
//        });
//
//        $('.date2').daterangepicker({
//            autoUpdateInput: false,
//            singleDatePicker: true,
//            showDropdowns: true, //년월 수동 설정 여부
//            autoApply: false, //true 확인 취소버튼을 숨기고 날짜클릭시 자동적용
//            locale: {
//                monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월",
//                    "12월"
//                ],
//                daysOfWeek: ["월", "화", "수", "목", "금", "토", "일"],
//                format: "YYYY-MM-DD",
//                cancelLabel: '취소',
//                applyLabel: "확인",
//            }
//        });
//
//        $('.datetime').daterangepicker({
//            timePicker: true,
//            timePicker24Hour: true,
//            timePickerSeconds: true, //초단위 노출여부
//            autoUpdateInput: false,
//            singleDatePicker: true,
//            showDropdowns: false, //년월 수동 설정 여부
//            locale: {
//                monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월",
//                    "12월"
//                ],
//                daysOfWeek: ["월", "화", "수", "목", "금", "토", "일"],
//                format: "YYYY-MM-DD hh:mm:ss A",
//                cancelLabel: '취소',
//                applyLabel: "확인",
//            }
//        });

        $('.date1, .date2').on('apply.daterangepicker', function (ev, picker) {
            $(this).val(picker.startDate.format('YYYY-MM-DD'));
        });

        $('.datetime').on('apply.daterangepicker', function (ev, picker) {
            $(this).val(picker.startDate.format('YYYY-MM-DD hh:mm:ss A'));
        });
        // $('.date').on('cancel.daterangepicker', function (ev, picker) {
        //     $(this).val('');
        // }); 취소기능대신 지우기 기능이 필요할때

//        $('.datefromto').daterangepicker({
//            autoUpdateInput: false,
//            locale: {
//                monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월",
//                    "12월"
//                ],
//                daysOfWeek: ["월", "화", "수", "목", "금", "토", "일"],
//                format: "YYYY-MM-DD",
//                cancelLabel: '취소',
//                applyLabel: "확인",
//
//            }
//        });

        $('.datefromto').on('apply.daterangepicker', function (ev, picker) {
            $(this).val(picker.startDate.format('YYYY-MM-DD') + ' ~ ' + picker.endDate.format(
                'YYYY-MM-DD'));
        });

    });

});
///////////////공통 팝업 : footer 참조/////////////
//넘버온리
//maxlength="10" onkeypress="numberonly();"
//onpaste="javascript:return false;" 붙여넣기 막기
function numberonly(){
    if((event.keyCode<48)||(event.keyCode>57)){
    	event.returnValue=false;
    }
}
function goLogin(){
	location.href="/login";
}
function goHome(){
	location.href="/";
}
function goLogout(){
	location.href="/logout";
}
//공통 alert
(function(proxied) {
	  window.alert = function(m) {
		$("#alertMessage").html(m);
		$("button[data-layer='alert_pop']").click();
//	    return proxied.apply(this, arguments);
		return;
	  };
	  window.alert2 = function(headMsg,centerMsg,btnMsg,success){
		  $("#alertText1").html(headMsg);
		  $("#alertText2").html(centerMsg);
		  $("#alertCloseCallback").text(btnMsg);
		  $("button[data-layer='alert_pop2']").click();
		  console.log(success);
		  $("#alertCloseCallback").off().click(function(){
			  if (typeof (success) == 'undefined') {
				  $("#alertCloseCallbackHidden").click();
			  }else if (typeof (success) == 'function') {
				  success();
			  }else {
				  var funcCall = success + "();";
				  if(success != null){
					  var ret = eval(funcCall);
					  ret;
				  }else{
					  $("#alertCloseCallbackHidden").click();
				  }
			  }
		  });
		  return;
	  };
  window.alert3 = function(m) {
    $("#alertMessage3").html(m);
    $("button[data-layer='alert_pop3']").click();
//	    return proxied.apply(this, arguments);
    return false;
  };
})(window.alert);


//공통 confirm
window.confirm = function(msg,success,cancel){
	$("#confirmMessage").html(msg);
	$("button[data-layer='confirm_pop']").click();
	$("#confirmTrue").off().on('click',function(){
//	$(document).off().on('click',"#confirmTrue",function(e){
		console.log("확인버튼");
		var _layerOn_length = $(".confirmDiv > .on, .confirmDiv > .on").length;
		if (_layerOn_length) {
			$(".confirmDiv > .on").removeClass("on")
			.parent().removeClass("on");
		} else {
			$(this).parent().parent().removeClass("on")
			.parent().removeClass("on");
		}
//		return true;
		//성공콜백
		if (typeof (success) == 'undefined') {
        }else if (typeof (success) == 'function') {
            success();
        }else {
            var funcCall = success + "();";
            if(success != null){
                var ret = eval(funcCall);
                ret;
            }
        }
	});
	$("#confirmFalse").off().on('click',function(){
//	$(document).off().on('click',"#confirmFalse",function(e){
		console.log("취소버튼");
		var _layerOn_length = $(".confirmDiv > .on, .confirmDiv > .on").length;
		if (_layerOn_length) {
			$(".confirmDiv > .on").removeClass("on")
			.parent().removeClass("on");
		} else {
			$(this).parent().parent().removeClass("on")
			.parent().removeClass("on");
		}
//		return false;
		//실패콜백
		if (typeof (cancel) == 'undefined') {
        }else if (typeof (cancel) == 'function') {
        	cancel();
        }else {
            var funcCall = cancel + "();";
            if(cancel != null){
                var ret = eval(funcCall);
                ret;
            }
        }
	});
//	return $.when($("#confirmTrue","#confirmFalse").bind('click')).then(xx());
}


function comma(x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

//quickmenu
$(document).ready(function () {
    var currentPosition = parseInt($(".quickmenu_wrap").css("top"));
    $(window).scroll(function () {
        var position = $(window).scrollTop();
        $(".quickmenu_wrap").stop().animate({
            "top": position + currentPosition + "px"
        }, 1000);
    });
});

// tab2
(function(a){
    a.fn.webwidget_tab=function(p){
        var p=p||{};
        var s_w_p=p&&p.window_padding?p.window_padding:"5";
        var s_h_t_c=p&&p.head_text_color?p.head_text_color:"blue";
        var s_h_c_t_c=p&&p.head_current_text_color?p.head_current_text_color:"black";
        var dom=a(this);
        s_w_p += "px";

        if(dom.find("ul").length==0||dom.find("li").length==0){
            dom.append("Require content");
            return null;
        }
        begin();
        function begin(){
			dom.children(".tabBody").children("ul").children("li").children("p").css("padding",s_w_p);
			dom.children(".tabBody2").children("ul").children("li").children("p").css("padding",s_w_p);
			dom.children(".tabBody3").children("ul").children("li").children("p").css("padding",s_w_p);
			dom.children(".tabContainer").children(".tabHead").children("li").children("a").css("color",s_h_t_c);
			dom.children(".tabContainer2").children(".tabHead2").children("li").children("a").css("color",s_h_t_c);
			dom.children(".tabContainer3").children(".tabHead2").children("li").children("a").css("color",s_h_t_c);
            dom.children(".tabBody").children("ul").children("li").hide();
			dom.children(".tabBody").children("ul").children("li").eq(0).show();
			dom.children(".tabBody2").children("ul").children("li").hide();
			dom.children(".tabBody2").children("ul").children("li").eq(0).show();
			dom.children(".tabBody3").children("ul").children("li").hide();
            dom.children(".tabBody3").children("ul").children("li").eq(0).show();
            dom.children(".tabContainer").children(".tabHead").children("li").children("a").click(function(){
                var current = dom.children(".tabContainer").children(".tabHead").children("li").index($(this).parent());
                dom.children(".tabContainer").children(".tabHead").children("li").children("a").css("color",s_h_t_c);
                dom.children(".tabContainer").children(".tabHead").children("li").removeClass("currentBtn")
                dom.children(".tabContainer").children(".tabHead").children("li").eq(current).children("a").css("color",s_h_c_t_c);
                dom.children(".tabContainer").children(".tabHead").children("li").eq(current).addClass("currentBtn");
                dom.children(".tabBody").children("ul").children("li").hide();
                dom.children(".tabBody").children("ul").children("li").eq(current).show();
			});
			dom.children(".tabContainer2").children(".tabHead2").children("li").children("a").click(function(){
                var current = dom.children(".tabContainer2").children(".tabHead2").children("li").index($(this).parent());
                dom.children(".tabContainer2").children(".tabHead2").children("li").children("a").css("color",s_h_t_c);
                dom.children(".tabContainer2").children(".tabHead2").children("li").removeClass("currentBtn2")
                dom.children(".tabContainer2").children(".tabHead2").children("li").eq(current).children("a").css("color",s_h_c_t_c);
                dom.children(".tabContainer2").children(".tabHead2").children("li").eq(current).addClass("currentBtn2");
                dom.children(".tabBody2").children("ul").children("li").hide();
                dom.children(".tabBody2").children("ul").children("li").eq(current).show();
			});
			dom.children(".tabContainer3").children(".tabHead3").children("li").children("a").click(function(){
                var current = dom.children(".tabContainer3").children(".tabHead3").children("li").index($(this).parent());
                dom.children(".tabContainer3").children(".tabHead3").children("li").children("a").css("color",s_h_t_c);
                dom.children(".tabContainer3").children(".tabHead3").children("li").removeClass("currentBtn3")
                dom.children(".tabContainer3").children(".tabHead3").children("li").eq(current).children("a").css("color",s_h_c_t_c);
                dom.children(".tabContainer3").children(".tabHead3").children("li").eq(current).addClass("currentBtn3");
                dom.children(".tabBody3").children("ul").children("li").hide();
                dom.children(".tabBody3").children("ul").children("li").eq(current).show();
            });
        }
    }
})(jQuery);


//jquery 날짜 포맷 변경 함수
function changeDateFormat(str){
	if(str == null){
		return "";
	}else{
		return str.substring(0,4)+"."+str.substring(4,6)+"."+str.substring(6,8)+" "+str.substring(8,10)+":"+str.substring(10,12)+":"+str.substring(12,14);
	}
}

function funRowspan(className){
	$("."+className).each(function(){
		var rows = $("."+className);
		if(rows.length > 1){
			rows.eq(0).attr("rowspan", rows.length);//중복되는 첫번째 td에 rowspan값 세팅
			rows.not(":eq(0)").remove();//중복되는 td를 삭제 } }); }
		}
	});
}


//쿠키 설정
function setCookie(cookieName, value, exdays){
	var exdate = new Date();

	exdate.setDate(exdate.getDate() + exdays);

	var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());

	document.cookie = cookieName + "=" + cookieValue;
}


//쿠키 삭제
function deleteCookie(cookieName){
	var expireDate = new Date();

	expireDate.setDate(expireDate.getDate() - 1);

	document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
}


//쿠키 호출
function getCookie(cookieName) {

	cookieName = cookieName + '=';

	var cookieData = document.cookie;
	var start = cookieData.indexOf(cookieName);
	var cookieValue = '';

	if(start != -1){
		start += cookieName.length;

		var end = cookieData.indexOf(';', start);

		if(end == -1)end = cookieData.length;

		cookieValue = cookieData.substring(start, end);
	}
	return unescape(cookieValue);
}
//날씨
function weatherApi(){

	var xhr = new XMLHttpRequest();
	var url = 'http://apis.data.go.kr/1360000/WthrSatlitInfoService/getGk2aIrAll'; /*URL*/
	var queryParams = '?' + encodeURIComponent('serviceKey') + '='+'VMR4sFjdZ2i8LhE%2BpuO3lEq9JnLsKlE40YmeJ%2FPp6EIz5WXbH%2FW%2Bg7vyJ12yBVDC%2FBZii1UV0e50RuzGYneXwA%3D%3D'; /*Service Key*/
	queryParams += '&' + encodeURIComponent('pageNo') + '=' + encodeURIComponent('1'); /**/
	queryParams += '&' + encodeURIComponent('numOfRows') + '=' + encodeURIComponent('10'); /**/
	queryParams += '&' + encodeURIComponent('dataType') + '=' + encodeURIComponent('JSON'); /**/
	queryParams += '&' + encodeURIComponent('dateTime') + '=' + encodeURIComponent('201911120300'); /**/
	queryParams += '&' + encodeURIComponent('waveType') + '=' + encodeURIComponent('087'); /**/
	queryParams += '&' + encodeURIComponent('unitType') + '=' + encodeURIComponent('R'); /**/
	xhr.open('GET', url + queryParams);
	xhr.onreadystatechange = function () {
	    if (this.readyState == 4) {
	        console.log('Status: '+this.status+'nHeaders: '+JSON.stringify(this.getAllResponseHeaders())+'nBody: '+this.responseText);
	    }
	};

	xhr.send('');
}
//위성(구름)
function weatherApi2(){
	var param ={};
	postAjax("/admin/dashboard/cloud",param,"weatherCallback",null,null,null);
}
function weatherCallback(data){
	$("#weather1").css("background-image",'url("'+data.file[data.file.length-1]+'")');
	var interval = setInterval(function(){
		clearInterval(interval);
		weatherApi2();
	},60000*5);
	$("[data-fn='lyClose']").click(function(){
		clearInterval(interval);
	});
}
//레이더
function weatherApi3(){
	var param ={};
	postAjax("/admin/dashboard/radar",param,"weatherCallback2",null,null,null);
}
function weatherCallback2(data){
	var index=0;
	$("#weather2").css("background-image",'url("https://www.weatheri.co.kr'+data.sb+'")');
}
//갱신날짜
function updatedate(tagId){
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
	$("#"+tagId).text(NowToday);
}
//노면온도
function roadTemp(){
	var param ={};
	postAjax("/admin/dashboard/roadTemp",param,"roadTempCallback",null,null,null);
}
function roadTempCallback(data){
	var tempHtml ="";
	var list = data.list;
	$.each(list,function(i,el){
		tempHtml +='<tr>';
		tempHtml += '<td>'+list[i].num+'</td>';
		tempHtml += '<td>'+list[i].tnickname+'</td>';
		tempHtml += '<td>'+list[i].roadTemp+'</td>';
		tempHtml +='</tr>';
	});
	$("#roadTempList").html(tempHtml);
}
function moreWeather(){
	updatedate("weatherupdateTime");
	//위성(구름)
	weatherApi2();
	//레이더
	weatherApi3();
	//노면온도 센서위치

	//노면온도
	roadTemp();

	weather2();

	$("button[data-layer='popup_weather']").click();
	$("#defaultOpen").addClass();
	$("#tab2").hide();
	$("#tab3").hide();
	var interval1 = setInterval(function(){
		clearInterval(interval1);
		weatherApi2();
		weatherApi3();
		weather2();
		roadTemp();
		updatedate("weatherupdateTime");
	},60000*5);
	$("[data-fn='lyClose']").click(function(){
		clearInterval(interval1);
	});
}

function encodeTest(str){
	var param ={
			str : str
	};
	postAjax("/member/encodeTest",param,"encodeCallback",null,null,null);
}
function encodeCallback(data){
	console.log(data);
}