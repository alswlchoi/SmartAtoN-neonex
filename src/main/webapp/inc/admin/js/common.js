$(document).ready(function () {

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
    $("[data-layer]").click(function (e) {
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

        e.preventDefault();

    });

    $("[data-fn='lyClose'], .lyClose").click(function () {

        var _layerOn_length = $(".ly_group > .on, .ly_group > .on").length;
        if (_layerOn_length) {
            $(".ly_group > .on").removeClass("on")
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
        $('.date1').daterangepicker({
            autoUpdateInput: false,
            singleDatePicker: true,
            showDropdowns: false, //년월 수동 설정 여부
            autoApply: true, //true 확인 취소버튼을 숨기고 날짜클릭시 자동적용
            locale: {
                monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월",
                    "12월"
                ],
                daysOfWeek: ["월", "화", "수", "목", "금", "토", "일"],
                format: "YYYY-MM-DD",
                cancelLabel: '취소',
                applyLabel: "확인",
            }
        });

        $('.date2').daterangepicker({
            autoUpdateInput: false,
            singleDatePicker: true,
            showDropdowns: true, //년월 수동 설정 여부
            autoApply: false, //true 확인 취소버튼을 숨기고 날짜클릭시 자동적용
            locale: {
                monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월",
                    "12월"
                ],
                daysOfWeek: ["월", "화", "수", "목", "금", "토", "일"],
                format: "YYYY-MM-DD",
                cancelLabel: '취소',
                applyLabel: "확인",
            }
        });

        $('.datetime').daterangepicker({
            timePicker: true,
            timePicker24Hour: true,
            timePickerSeconds: true, //초단위 노출여부             
            autoUpdateInput: false,
            singleDatePicker: true,
            showDropdowns: false, //년월 수동 설정 여부
            locale: {
                monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월",
                    "12월"
                ],
                daysOfWeek: ["월", "화", "수", "목", "금", "토", "일"],
                format: "YYYY-MM-DD hh:mm:ss A",
                cancelLabel: '취소',
                applyLabel: "확인",
            }
        });

        $('.date1, .date2').on('apply.daterangepicker', function (ev, picker) {
            $(this).val(picker.startDate.format('YYYY-MM-DD'));
        });

        $('.datetime').on('apply.daterangepicker', function (ev, picker) {
            $(this).val(picker.startDate.format('YYYY-MM-DD hh:mm:ss A'));
        });
        // $('.date').on('cancel.daterangepicker', function (ev, picker) {
        //     $(this).val('');
        // }); 취소기능대신 지우기 기능이 필요할때

        $('.datefromto').daterangepicker({
            autoUpdateInput: false,
            locale: {
                monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월",
                    "12월"
                ],
                daysOfWeek: ["월", "화", "수", "목", "금", "토", "일"],
                format: "YYYY-MM-DD",
                cancelLabel: '취소',
                applyLabel: "확인",

            }
        });

        $('.datefromto').on('apply.daterangepicker', function (ev, picker) {
            $(this).val(picker.startDate.format('YYYY-MM-DD') + ' ~ ' + picker.endDate.format(
                'YYYY-MM-DD'));
        });

    });

});

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