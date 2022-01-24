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