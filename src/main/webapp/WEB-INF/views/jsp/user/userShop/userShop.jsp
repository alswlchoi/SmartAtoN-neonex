<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<link rel="stylesheet" type="text/css" href="/inc/css/fullcalendar_main.css">
<!-- fullcalendar style -->
<script type="text/javascript" src="/inc/js/fullcalendar_main.js"></script>
<!-- fullcalendar -->
<sec:csrfMetaTags/>
<script>
// $(".fc-scrollgrid-sync-table").children("tbody").on('DOMSubtreeModified',function(e){
// 	debugger;
// // 	$(".fc-event-draggable").removeClass("fc-event-draggable");
// })
$(document).ready(function () {
  getMemInfo();
});
var csrfHeader = $('meta[name="_csrf_header"]').attr('content');
var csrfToken = $('meta[name="_csrf"]').attr('content');

var events = new Array();
var dayArray;
var dayOffArray=[];

function getMemInfo() {
  var param = {
    memId: "<%=memberDto.getMemId()%>"
  }
  postAjax("/user/userShop/getUserInfo", param, "setMemInfo", null, null, null);
}
function setMemInfo(mem) {
  $("#memPhone").val(mem.memPhone);
  $("#compPhone").val(mem.compPhone);
  $("#memEmail").val(mem.memEmail);
  $("#acctName").val(mem.compAcctName);
  $("#acctDept").val(mem.compAcctDept);
  $("#acctEmail").val(mem.compAcctEmail);
  $("#compAcctPhone").val(mem.compAcctPhone);
}

$(document).on('click','.fc-button',function(){
    var initDay = ["0", "1", "2", "3", "4", "5", "6"];
    var week = ['sun', 'mon','tue','wed','thu','fri','sat'];
    var resultA = initDay.filter(function (a) {
      return dayArray.indexOf(a) === -1;
    });
    for (var i in resultA) {
      $("td.fc-day-"+week[resultA[i]]).css('background-color','rgba(215, 215, 215, 0.3)');
    }
    $(".fc-event-draggable").removeClass("fc-event-draggable");
  })
  // 가져온 날짜 형식 변경
  function changeDate(str) {
    var y = str.substr(0, 4);
    var m = str.substr(4, 2);
    var d = str.substr(6, 2);
    var date = y + '-' + m + '-' + d + ' 23:59:59';
    return date;
  }
  function changeStDate(str) {
    var y = str.substr(0, 4);
    var m = str.substr(4, 2);
    var d = str.substr(6, 2);
    var date = y + '-' + m + '-' + d ;
    return date;
  }

  // 현재 저장된 일정 가져와서 캘린더에 보여주기
  function getEvents() {
    events = new Array();
    var param = {
      // wssStDay: moment().format('YYYYMM'),
      doKind: 'F'
    };
    asyncPostAjax("/user/userShop/list", param, "makeArr", null, null, null);
    return events;
  }

  	var calanderArray = new Array();
  function makeArr(list) {
	  // console.log("lllllist = ",list);
    if (list.shop.length > 0) {
      for (var i in list.shop) {
		//변경

		//일자 별 표시
		var diffday = moment.duration(moment(list.shop[i].wssEdDay,"YYYYMMDD").diff(moment(list.shop[i].wssStDay,"YYYYMMDD"),'days'));

		outer:for(var j=0;j<=diffday;j++){
			var loopStartDay = changeStDate(moment(list.shop[i].wssStDay,"YYYYMMDD").add(j,"d").format("YYYYMMDD"));
			var loopEndDay = changeStDate(moment(list.shop[i].wssStDay,"YYYYMMDD").add(j,"d").format("YYYYMMDD"));
			var color1 = '#9a9b9c', color2 = '#ffa845', color3 = '#b75938', color4 = '#cd2f2d';
			var startDate, endDate;
			startDate = loopStartDay;
			endDate = loopEndDay;
			if (list.shop[i].wsCode == 'S001') {
				if (list.shop[i].wssApproval == 'N') {
				  events.push({
				    title: list.shop[i].wsName + "(승인대기중)",
				    start: startDate,
				    end: endDate,
				    defaultAllDay:true,
				    color: color2
				  })
				} else {
				  events.push({
				    title: list.shop[i].wsName + "(" + list.shop[i].compName + ")",
				    start: startDate,
				    end: endDate,
				    defaultAllDay:true,
				    color: color2
				  })
				}
			} else if (list.shop[i].wsCode == 'S002') {
				if (list.shop[i].wssApproval == 'N') {
				  events.push({
				    title: list.shop[i].wsName + "(승인대기중)",
				    start: startDate,
				    end: endDate,
				    defaultAllDay:true,
				    color: color3
				  })
				} else {
				  events.push({
				    title: list.shop[i].wsName + "(" + list.shop[i].compName + ")",
				    start: startDate,
				    end: endDate,
				    defaultAllDay:true,
				    color: color3
				  })
				}
			} else if (list.shop[i].wsCode == 'S003') {
				if (list.shop[i].wssApproval == 'N') {
				  events.push({
				    title: list.shop[i].wsName + "(승인대기중)",
				    start: startDate,
				    end: endDate,
				    defaultAllDay:true,
				    color: color4
				  })
				} else {
				  events.push({
				    title: list.shop[i].wsName + "(" + list.shop[i].compName + ")",
				    start: startDate,
				    end: endDate,
				    defaultAllDay:true,
				    color: color4
				  })
				}
			}

			//안쓰는 날 제거
			if(list.bWeek!=null){
				if(list.bWeek.length>0){
					if(startDate>=moment(list.bWeek[0].wdStDt,"YYYYMMDD").format("YYYY-MM-DD") && startDate<=moment(list.bWeek[0].wdEdDt,"YYYYMMDD").format("YYYY-MM-DD")){
						var bweek = list.bWeek[0].wdDay.split(",");
						if(!bweek.includes(moment(startDate).day().toString())){
							events.pop();
							continue outer;
						}
					}
				}
			}
			//dayoff 제거
			if(list.dayOff!=null){
				if(list.dayOff.length>0){
					var dayOff = list.dayOff;
					inner:for(var b=0;b<dayOff.length;b++){
						if(startDate>=moment(dayOff[b].doStDay,"YYYYMMDD").format("YYYY-MM-DD") && startDate<=moment(dayOff[b].doEdDay,"YYYYMMDD").format("YYYY-MM-DD")){
							events.pop();
							continue outer;
						}
					}
				}
			}
			//weekday 제거
			if(list.weekday != null){
				if (list.weekday.length > 0) {
					var weekday = list.weekday;
					inner2:for(var b=0;b<weekday.length;b++){
						var wdDay = weekday[b].wdDay.split(",");
						if(list.shop[i].wsName==weekday[b].wsName){
							if(startDate>=moment(weekday[b].wdStDt,"YYYYMMDD").format("YYYY-MM-DD") && startDate<=moment(weekday[b].wdEdDt,"YYYYMMDD").format("YYYY-MM-DD")){
								if(wdDay.includes(moment(startDate).day().toString())){
									events.pop();
									continue outer;
								}
							}

						}
					}
				}
			}
		}

    	  //기존
//         var data = list.shop[i];
//         var color1 = '#9a9b9c', color2 = '#ffa845', color3 = '#b75938', color4 = '#cd2f2d';
//         var startDate, endDate;
//         if (data.wssStDay == data.wssEdDay){
//           startDate = changeStDate(data.wssStDay);
//           endDate = changeStDate(data.wssEdDay);
//         } else {
//           startDate = changeDate(data.wssStDay);
//           endDate = changeDate(data.wssEdDay);
//         }
//         if (data.wsCode == 'S001') {
//           if (data.wssApproval == 'N') {
//             events.push({
//               title: data.wsName + "(승인대기중)",
//               start: startDate,
//               end: endDate,
//               defaultAllDay:true,
//               color: color2
//             })
//           } else {
//             events.push({
//               title: data.wsName + "(" + data.compName + ")",
//               start: startDate,
//               end: endDate,
//               defaultAllDay:true,
//               color: color2
//             })
//           }
//         } else if (data.wsCode == 'S002') {
//           if (data.wssApproval == 'N') {
//             events.push({
//               title: data.wsName + "(승인대기중)",
//               start: startDate,
//               end: endDate,
//               defaultAllDay:true,
//               color: color3
//             })
//           } else {
//             events.push({
//               title: data.wsName + "(" + data.compName + ")",
//               start: startDate,
//               end: endDate,
//               defaultAllDay:true,
//               color: color3
//             })
//           }
//         } else if (data.wsCode == 'S003') {
//           if (data.wssApproval == 'N') {
//             events.push({
//               title: data.wsName + "(승인대기중)",
//               start: startDate,
//               end: endDate,
//               defaultAllDay:true,
//               color: color4
//             })
//           } else {
//             events.push({
//               title: data.wsName + "(" + data.compName + ")",
//               start: startDate,
//               end: endDate,
//               defaultAllDay:true,
//               color: color4
//             })
//           }
//         }
      }
    }
    dayArray = list.bWeek[0].wdDay.split(",");
    if (list.weekday.length > 0) {
      var startDate, endDate;
      for (var i in list.weekday) {
        var data = list.weekday[i];
        if (data.wdStDt == data.wdEdDt){
          startDate = changeStDate(data.wdStDt);
          endDate = changeStDate(data.wdEdDt);
        } else {
          startDate = changeDate(data.wdStDt);
          endDate = changeDate(data.wdEdDt);
        }
        events.push({
          title: data.wsName + "(예약 불가)",
          start: startDate,
          end: endDate,
          defaultAllDay:true,
          color: color1
        })
      }
    }
    if (list.dayOff.length > 0) {
      var startDate, endDate;
      for (var i in list.dayOff) {
        var data = list.dayOff[i];
        if (data.doStDay == data.doEdDay){
          dayOffArray.push(data.doStDay);
          startDate = changeStDate(data.doStDay);
          endDate = changeStDate(data.doEdDay);
        } else {
          startDate = changeDate(data.doStDay);
          endDate = changeDate(data.doEdDay);
          var currDate = moment(startDate).startOf('day');
          var lastDate = moment(endDate).startOf('day');

          dayOffArray.push(data.doStDay);
          while(currDate.add(1, 'days').diff(lastDate) < 0) {
            dayOffArray.push(currDate.format("YYYYMMDD"));
          }
          dayOffArray.push(data.doEdDay);
        }
        events.push({
          title: data.doName + "(예약 불가)",
          start: startDate,
          end: endDate,
          defaultAllDay:true,
          color: color1
        })
      }
    }
    return events;
  }

  // FullCalender
  document.addEventListener('DOMContentLoaded', function () {
    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
      headerToolbar: {
        left: '',
        center: 'prev,title,next',
        right: ''
      },
      dateClick: function (info) {
   	  	//과거 막기
   	    if ((moment(info.date).isBefore(moment().format('YYYYMMDD')))){
   	        return;
   	    }
        if ($.inArray(moment(info.dateStr, 'YYYY-MM-DD').format('e'), dayArray) == -1) {
          calendar.unselect();
        } else if ($.inArray(moment(info.dateStr, 'YYYY-MM-DD').format('YYYYMMDD'), dayOffArray) != -1){
          calendar.unselect();
        } else {
          $("#reservBtn").click();
          $("#dateto").val(info.dateStr + " ~ " + info.dateStr);
        }
      },
      navLinks: false, // can click day/week names to navigate views
      businessHours: true, // display business hours
      editable: true,
      selectable: true,
      locale: 'ko',
      events: getEvents(),
      displayEventTime: false,
      nextDayThreshold: '00:00:00',
      eventOrder: 'title'
    });
    calendar.render();
    var initDay = ["0", "1", "2", "3", "4", "5", "6"];
    var week = ['sun', 'mon','tue','wed','thu','fri','sat'];
    var resultA = initDay.filter(function (a) {
      return dayArray.indexOf(a) === -1;
    });
    for (var i in resultA) {
        $("td.fc-day-"+week[resultA[i]]).css('background-color','rgba(215, 215, 215, 0.3)');
    }
    $(".fc-event-draggable").removeClass("fc-event-draggable");
    $(".lodingdimm").hide();

  });

  $(function () {
    $("#memPhone").on("keyup", function () {
      var regPhone = /^01(?:0|1|[6-9])(?:\d{3}|\d{4})\d{4}$/;
      if (!regPhone.test($("#memPhone").val().trim())) {
        $("#memPhoneText").css("display", "")
      } else {
        $("#memPhoneText").css("display", "none")
      }
    });
    $("#memEmail").on("keyup", function () {
      var regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
      if (!regEmail.test($("#memEmail").val().trim())) {
        $("#memEmailText").css("display", "")
      } else {
        $("#memEmailText").css("display", "none")
      }
    });
    $("#compPhone").on("keyup", function () {
      var regCompPhone = /^\d{2,3}\d{3,4}\d{4}$/;
      if (!regCompPhone.test($("#compPhone").val().trim())) {
        $("#compPhoneText").css("display", "")
      } else {
        $("#compPhoneText").css("display", "none")
      }
    });
    $("#acctName").on("keyup", function () {
      if ($(this).val().length == 0) {
        $("#acctNameText").text("담당자 이름을 입력해 주세요.");
        $("#acctNameText").addClass("redfont");
        $("#acctNameText").addClass("info_ment");
      } else {
        $("#acctNameText").text("");
        $("#acctNameText").removeClass("redfont");
        $("#acctNameText").removeClass("info_ment");
      }
    });
    $("#acctDept").on("keyup", function () {
      if ($(this).val().length == 0) {
        $("#acctDeptText").text("부서명을 입력해 주세요.");
        $("#acctDeptText").addClass("redfont");
        $("#acctDeptText").addClass("info_ment");
      } else {
        $("#acctDeptText").text("");
        $("#acctDeptText").removeClass("redfont");
        $("#acctDeptText").removeClass("info_ment");
      }
    });
    $("#acctEmail").on("keyup", function () {
      var regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
      if (!regEmail.test($("#acctEmail").val().trim())) {
        $("#acctEmailText").css("display", "")
      } else {
        $("#acctEmailText").css("display", "none")
      }
    });
    $("#compAcctPhone").on("keyup", function () {
      var regCompPhone = /^\d{2,3}\d{3,4}\d{4}$/;
      if (!regCompPhone.test($("#compAcctPhone").val().trim())) {
        $("#compAcctPhoneText").css("display", "")
      } else {
        $("#compAcctPhoneText").css("display", "none")
      }
    });
  })

  var dayOff = new Array();

  // 현재 저장된 일정 가져와서 캘린더에 보여주기
  function getDayOff() {
    var param1 = {
      doKind: 'F'
    };
    asyncPostAjax("/user/userShop/getDayoffList", param1, "makeDayOffArr", null, null, null);
    return dayOff;
  }

  function makeDayOffArr(list) {
    dayOff = new Array();
    if (list.length > 0) {
      for (var i in list) {
        var data = list[i];
        dayOff.push({
          start: changeDate(data.doStDay),
          end: changeDate(data.doEdDay),
          wsCode: data.doKind
        })
      }
    }
    return dayOff;
  }

  $(document).ready(function () {
    $(".lodingdimm").show();
    getDayOff();
    /*$('#dateto').daterangepicker({
      minDate: moment(),
      // startDate: moment($("#clickDate").val()),
      // endDate: moment($("#clickDate").val()),
      // autoApply: true,
      cancelLabel: '취소',
      applyLabel: "확인",
      locale: {
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
        yearSuffix: '년',
        separator: " ~ ",
        format: 'YYYY-MM-DD'
      }
    }, function (start, end, label) {
      if (setWeekDate.length > 0) {
        for (var i in setWeekDate) {
          if (moment(setWeekDate[i]).isBetween(moment(start), moment(end))) {
            confirm("예약 불가능한 날짜가 포함되어 있습니다.", "confirmDay", "nothing");
            return;
          } else {
            invalidDay = 0;
          }
        }
      }
      if (dayOff.length > 0) {
        for (var i in dayOff) {
          if (dayOff[i].doKind == $("#shopSelect").val()) {
            if (moment(dayOff[i]).isBetween(moment(start), moment(end))) {
              confirm("예약 불가능한 날짜가 포함되어 있습니다.", "confirmDay", "nothing");
              return;
            }
          }
        }
      }
      chk(start.format('YYYY-MM-DD'), end.format('YYYY-MM-DD'));
    });*/
    $('#dateto').attr("disabled", true);

    // 예약 팝업 실행시 부대시설명 및 이용약관 체크 초기화
    $("#reservBtn").click(function () {
      $('#etc').html("");
      $('#dateto').attr("disabled", true);
      $("#shopSelect").val("").prop("selected", true);
      $("input:checkbox[name=term]").attr("checked", false);
      <%--$('#memPhone').val("<%=memberDto.getMemPhone()%>");--%>
      $("#memPhoneText").css("display", "none")
      <%--$('#compPhone').val("<%=memberDto.getCompPhone()%>");--%>
      $("#compPhoneText").css("display", "none")
      <%--$('#memEmail').val("<%=memberDto.getMemEmail()%>");--%>
      $("#memEmailText").css("display", "none")
      <%--$('#acctName').val("<%=memberDto.getCompAcctName()%>");--%>
      <%--$('#acctDept').val("<%=memberDto.getCompAcctDept()%>");--%>
      <%--$('#acctEmail').val("<%=memberDto.getCompAcctEmail()%>");--%>
      $("#acctEmailText").css("display", "none")
      <%--$('#compAcctPhone').val("<%=memberDto.getCompAcctPhone()%>");--%>
    });
    getShop();
  });

  // 부대시설 변경 시 예약 일자 선택 가능
  function changeShop(wsCode) {
    var param = {
      wssStDay: moment().format('YYYYMM'),
      wdKind: wsCode,
      doKind: 'F'
    };
    asyncPostAjax("/user/userShop/list", param, "setDisable", null, null, null);
  }

  var setWeekDate = new Array();
  var invalidDay = 1;

  function setDisable(list) {
    var eventArr = new Array();
    if (list.shop.length > 0) {
      for (var i in list.shop) {
        var data = list.shop[i];
        eventArr.push({
          start: changeDate(data.wssStDay),
          end: changeDate(data.wssEdDay),
          wdDay: ""
        })
      }
    }
    if (list.dayOff.length > 0) {
      for (var i in list.dayOff) {
        var data = list.dayOff[i];
        eventArr.push({
          start: changeDate(data.doStDay),
          end: changeDate(data.doEdDay),
          wdDay: ""
        });
      }
    }
    if (list.weekday.length > 0) {
      for (var i in list.weekday) {
        var data = list.weekday[i];
        eventArr.push({
          start: changeDate(data.wdStDt),
          end: changeDate(data.wdEdDt),
          wdDay: data.wdDay
        })
      }
    }
    if (list.bWeek.length > 0) {
      for (var i in list.bWeek) {
        var data = list.bWeek[i];
        eventArr.push({
          start: null,
          end: null,
          wdDay: data.wdDay
        })
      }
    }

    $('#dateto').removeAttr("disabled");
    $('#dateto').daterangepicker({
      minDate: moment(),
      autoApply: true,
      cancelLabel: '취소',
      applyLabel: "확인",
      isInvalidDate: function (date) {
        return eventArr.reduce(function (bool, test) {
          if (test.wdDay != "") {
            var initDay = ["0", "1", "2", "3", "4", "5", "6"];
            var newDay = test.wdDay.split(",");

            var resultA = initDay.filter(function (a) {
              return newDay.indexOf(a) === -1;
            });
            var resit = false;
            resultA.filter(function (a) {
              if (date.day() == a) {
                setWeekDate.push(date);
                resit = true
              }
            });
            return  bool || (moment(date).format('YYYYMMDD') >= moment(test.start).format('YYYYMMDD')  && moment(date).format('YYYYMMDD') <= moment(test.end).format('YYYYMMDD')) || resit;
          } else {
            return bool || (moment(date).format('YYYYMMDD') >= moment(test.start).format('YYYYMMDD')  && moment(date).format('YYYYMMDD') <= moment(test.end).format('YYYYMMDD'));
          }
        }, false);
      },
      locale: {
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
        yearSuffix: '년',
        separator: " ~ ",
        format: 'YYYY-MM-DD'
      }
    }/*, function (start, end, label) {
      if (setWeekDate.length > 0) {
        for (var i in setWeekDate) {
          if (moment(setWeekDate[i]).isBetween(moment(start), moment(end))) {
            confirm("예약 불가능한 날짜가 포함되어 있습니다.", "confirmDay", "nothing");
            return;
          } else {
            invalidDay = 0;
          }
        }
      }
      if (dayOff.length > 0) {
        for (var i in dayOff) {
          if (dayOff[i].doKind == $("#shopSelect").val()) {
            if (moment(dayOff[i]).isBetween(moment(start), moment(end))) {
              confirm("예약 불가능한 날짜가 포함되어 있습니다.", "confirmDay", "nothing");
              return;
            }
          }
        }
      }
      chk(start.format('YYYY-MM-DD'), end.format('YYYY-MM-DD'));
    }*/
    );
    $('#dateto').on('apply.daterangepicker', function (ev, picker) {
      getApplyDate();
    })
    /*$('#dateto').on('apply.daterangepicker', function (ev, picker) {
      if (setWeekDate.length > 0) {
        for (var i in setWeekDate) {
          if (moment(setWeekDate[i]).isBetween(moment(start), moment(end))) {
            confirm("예약 불가능한 날짜가 포함되어 있습니다.", "confirmDay", "nothing");
            return;
          } else {
            invalidDay = 0;
          }
        }
      }
      if (dayOff.length > 0) {
        for (var i in dayOff) {
          if (dayOff[i].doKind == $("#shopSelect").val()) {
            if (moment(dayOff[i]).isBetween(moment(start), moment(end))) {
              confirm("예약 불가능한 날짜가 포함되어 있습니다.", "confirmDay", "nothing");
              return;
            }
          }
        }
      }
      chk(start.format('YYYY-MM-DD'), end.format('YYYY-MM-DD'));

      $(this).val(picker.startDate.format('YYYY-MM-DD') +
          ' ~ ' + picker.endDate.format('YYYY-MM-DD'));
    });*/
  }

  // 팝업에 부대시설 selectbox
  function getShop() {
    var param = {
      user: 'Y'
    };
    postAjax("/admin/shop/list", param, "shopList", null, null, null)
  }

  function shopList(list) {
    var shopHtml = "";
    if (list.shop.length > 0) {
      for (var i in list.shop) {
        var shop = list.shop[i];
        shopHtml += "<option value='"+shop.wsCode+"'>"+shop.wsName+"</option>";
      }
    }
    $("#shopSelect").append(shopHtml);
  }

  function chk(start, end) {
    var date = $("#dateto").val().split(" ~ ");
    // 예약 존재 확인
    if (date[0] != "" && date[1] != "") {
      var chkDate = {
        wsCode: $("#shopSelect").val(),
        wssStDay: moment(start).format('YYYYMMDD'),
        wssEdDay: moment(end).format('YYYYMMDD')
      };
      asyncPostAjax("/user/userShop/chk", chkDate, "chkDay", null, null, null);
    }
  }

  var chkDate = 1;

  // 예약 날짜 존재 시
  function chkDay(cnt) {
    if (cnt >= 1) {
      confirm("예약 불가능한 날짜가 포함되어 있습니다.", "openCalendar", "nothing");
      return;
    } else {
      chkDate = 0;
    }
  }

  function confirmDay() {
    return;
  }
  function openCalendar() {
    chkDate = 1;
    $("#dateto").click();
  }
  function nothing() {
    return;
  }

  function insertChk(wsCode, stDay) {
    // var date = $("#dateto").val().split(" ~ ");
    // // 예약 존재 확인
    // if (date[0] != "" && date[1] != "") {
    //   var chkDate = {
    //     wsCode: $("#shopSelect").val(),
    //     wssStDay: moment(date[0]).format('YYYYMMDD'),
    //     wssEdDay: moment(date[1]).format('YYYYMMDD')
    //   };
    //   asyncPostAjax("/user/userShop/chk", chkDate, "inChkDay", null, null, null);
    // }
    var result;
    $.ajax({
      url : "/user/userShop/reservChk",
      type: "POST",
      data : JSON.stringify({
        "wsCode": wsCode,
        "wssStDay": stDay
      }),
      contentType: "application/json",
      dataType: "JSON",
      async: false,
      beforeSend: function(xhr) {
        xhr.setRequestHeader("AJAX", true);
        xhr.setRequestHeader(csrfHeader, csrfToken);
        xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
        xhr.setRequestHeader("Content-type","application/json");
      },
      success : function(resdata){
        result = resdata;
      },
      error : function(e){
        console.log(e);
      }
    });
    return result;
  }
  function inChkDay(cnt) {
    if (cnt >= 1) {
      confirm("예약 불가능한 날짜가 포함되어 있습니다.111", "openCalendar", "nothing");
      return;
    } else {
      chkDate = 0;
      invalidDay = 0;
      insertReserv();
    }
  }
  // 예약 신청 확인버튼 클릭 시
  function insertReserv() {
    getApplyDate();
    var date = $("#dateto").val().split(" ~ ");
    if ($("#shopSelect").val() == "") {
      alert3("부대시설을 선택해주세요.");
      return;
    }
    var chk = insertChk($("#shopSelect").val(), moment(date[0]).format('YYYYMMDD'));
    if (chk > 0) {
      alert3(""+$("#shopSelect :selected").html()+"는 이미 신청된 예약이 있습니다.");
      return;
    }
    var regPhone = /^01(?:0|1|[6-9])(?:\d{3}|\d{4})\d{4}$/;
    var regCompPhone = /^\d{2,3}\d{3,4}\d{4}$/;
    if (!regPhone.test($("#memPhone").val().trim())) {
      alert3("\"형식에 맞지 않는 번호 입니다.\"");
      return;
    }
    if (!regCompPhone.test($("#compPhone").val().trim())) {
      alert3("형식에 맞지 않는 번호 입니다.");
      return;
    }
    var regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
    if (!regEmail.test($("#memEmail").val().trim())) {
      alert3("이메일 형식에 맞지 않습니다.");
      return;
    }
    if ($("#acctName").val() == '') {
      alert3("회계담당자 이름을 입력해주세요.");
      return;
    }
    if ($("#acctDept").val() == '') {
      alert3("회계담당자 이름을 입력해주세요.");
      return;
    }
    if (!regCompPhone.test($("#compAcctPhone").val().trim())) {
      alert3("형식에 맞지 않는 번호 입니다.");
      return;
    }
    if (!regEmail.test($("#acctEmail").val().trim())) {
      alert3("이메일 형식에 맞지 않습니다.");
      return;
    }
    if (!$("input:checkbox[name=term]").prop("checked")) {
      alert3("이용약관을 확인해주세요.");
      return;
    }
    /*if (chkDate != 0 || invalidDay != 0) {
      confirm("예약 불가능한 날짜가 포함되어 있습니다.222", "openCalendar", "nothing");
      return;
    }*/

    // if ($("#shopSelect").val() != "" && $("input:checkbox[name=term]").is(":checked") == true
    //     && chkDate == 0 && invalidDay == 0) {
    var applyDate = moment(date[0]).format('YYYYMMDD');
    if ($("#applyDate").val() != null) {
      applyDate = $("#applyDate").val();
    }
      var param = {
        compCode: "<%=memberDto.getCompCode()%>"
        , wssStDay: moment(date[0]).format('YYYYMMDD')
        , wssEdDay: moment(date[1]).format('YYYYMMDD')
        , wssReservName: "<%=memberDto.getMemName()%>"
        , wssApproval: "N"
        , wsCode: $("#shopSelect").val()
        , wsName: $("#shopSelect option:checked").text()
        , wssRegUser: "<%=memberDto.getMemId()%>"
        , memId: "<%=memberDto.getMemId()%>"
        , memPhone: $("#memPhone").val()
        , memEmail: $("#memEmail").val()
        , compPhone: $("#compPhone").val()
        , compAcctName: $("#acctName").val()
        , compAcctDept: $("#acctDept").val()
        , compAcctEmail: $("#acctEmail").val()
        , compAcctPhone: $("#compAcctPhone").val()
        , wssReservDay: applyDate
      };
      postAjax("/user/userShop/insert", param, "goReservedPage", null, null, null);
    // }
  }

  function goReservedPage(list) {
    if (list > 0) {
      $(".lodingdimm").show();
      location.href = '/user/userShop/reserved';
    } else {
      alert3("등록에 실패했습니다.");
    }
  }

  function getApplyDate() {
    var date = $("#dateto").val().split(" ~ ");

    var param = {
      wsCode: $("#shopSelect").val()
      ,wssStDay: moment(date[0]).format('YYYYMMDD')
      , wssEdDay: moment(date[1]).format('YYYYMMDD')
      , reservedCnt: moment(date[1]).diff(moment(date[0]), 'days')+1
    }

    postAjax("/user/userShop/getApplyDate", param, "realDay", null, null, null);
  }
  function realDay(date) {
    var etcHtml = "";
    var length = 1;
    if (date.dates.length >= 1) {
      length = date.dates.length;
    }
    etcHtml += '<input type="hidden" id="applyDate" value="'+date.dates.toString()+'">';
    etcHtml += '실 예약일 : '+length+'일';
    $("#etc").html(etcHtml);
  }
</script>

<!-- container -->
<div id="container">
    <!-- visual -->
    <div class="visual_sub reservation"></div>
    <!-- //visual -->
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span
                class="breadcrumb_icon"></span><span>예약</span><span>부대시설 예약</span></div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">부대시설 예약</h2>
        <!-- //title -->
        <!-- calendar -->
        <div class="calendar_wrap">
            <div class="legend_cal">
                <%--                    <span class="gray">예약불가</span>--%>
                <%--                    <span class="blue m-l-14">예약가능</span>--%>
            </div>
            <div id='calendar'></div>
        </div>
        <!-- //calendar -->
        <!-- button -->
        <section class="tac m-t-50">
            <!-- <button type="button" class="btn btn_gray m-r-11">이전</button> -->
            <button id="reservBtn" type="button" class="btn btn_default"
                    data-layer="reservation_pop" style="display: none">확인
            </button>
        </section>
        <!-- //button -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

<!-- popup_xl -->
<div class="ly_group" style="overflow-y: scroll">
    <article class="layer_xl reservation_pop" style="overflow-y: scroll;">
        <!-- # 타이틀 # -->
        <h1>부대시설 예약정보 등록</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <!-- 예약정보 -->
            <h3 class="stitle m-t-30">예약정보</h3>
            <!-- table list -->
            <section class="tbl_wrap_list m-t-10">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="20%"/>
                        <col width="60%"/>
                        <col width="20%"/>
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">부대시설명</th>
                        <th scope="col">예약일자</th>
                        <th scope="col">비고</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>
                            <select id="shopSelect" title="select" class="form_control"
                                    onchange="changeShop(this.value)">
                                <option value="">선택</option>
                            </select>
                        </td>
                        <td>
                            <div class="form_group admin datepicker">
                                <input type="text" id="dateto" name="dateto" value="" size="40"
                                       placeholder="기간을 선택하세요"
                                       class="form_control w290 dateto dateicon">
                                <input type="hidden" id="clickDate">
                            </div>
                        </td>
                        <td id="etc">
                            <%--                            <button type="button" id="addSchedule" onclick="addSchedule()" class="btn-line-s btn_gray">추가</button>--%>
                            <%--                            <button type="button" id="delSchedule" onclick="delSchedule()" class="btn-line-s btn_gray">삭제</button>--%>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </section>
            <!-- //table list -->
            <!-- //예약정보 -->
            <!-- 예약 신청자 및 회계 담당자 정보 -->
            <h3 class="stitle m-t-30">예약 신청자 및 회계 담당자 정보
                <%--<div class="form_group top0">
                    <div class="check_inline">
                        <label class="check_default">
                            <input type="checkbox" name="" value="">
                            <span class="check_icon"></span>변경사항을 회원정보 반영</label>
                    </div>
                </div>--%>
            </h3>
            <!-- table_view -->
            <section class="tbl_wrap_view m-t-10">
                <table class="tbl_view01" summary="테이블입니다.">
                    <caption>테이블입니다.</caption>
                    <colgroup>
                        <col width="220px;"/>
                        <col width="381px"/>
                        <col width="220px;"/>
                        <col width="381px"/>
                    </colgroup>
                    <tr>
                        <th scope="row">회사명</th>
                        <td id="compName"><input id="compCode" type="hidden"><%=memberDto.getCompName()%>
                        </td>
                        <th>사업자등록번호</th>
                        <td id="compLicense"><%=memberDto.getCompLicense()%>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">신청자</th>
                        <td id="memName"><%=memberDto.getMemName()%>
                        </td>
                        <th>부서</th>
                        <td id="memDept"><%=memberDto.getMemDept()%>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">휴대폰 번호</th>
                        <td>
                            <div class="form_group w300">
                                <input type="text" id="memPhone"
                                       value="" maxlength="11"
                                       onkeypress="numberonly();" onpaste="javascript:return false;"
                                       class="form_control" placeholder="휴대폰 번호 입력" name=""/>
                            </div>
                            <br>
                            <span class="info_ment redfont" id="memPhoneText" style="display: none">형식에 맞지 않는 번호 입니다.</span>
                        </td>
                        <th>전화번호</th>
                        <td>
                            <div class="form_group w218">
                                <input type="text" id="compPhone"
                                       value="" maxlength="11"
                                       onkeypress="numberonly();" onpaste="javascript:return false;"
                                       class="form_control" placeholder="전화번호 입력" name=""/>
                            </div>
                            <br>
                            <span class="info_ment redfont" id="compPhoneText"
                                  style="display: none">형식에 맞지 않는 번호 입니다.</span>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">이메일 주소</th>
                        <td colspan="3">
                            <div class="form_group w300">
                                <input type="text" id="memEmail"
                                       value="" class="form_control"
                                       placeholder="이메일 주소 입력" name=""/>
                            </div>
                            <span class="info_ment redfont" id="memEmailText" style="display: none">이메일 형식에 맞지 않습니다.</span>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">회계담당자</th>
                        <td>
                            <div class="form_group w300">
                                <input type="text" maxlength="100" id="acctName"
                                       value="" class="form_control"
                                       placeholder="회계담당자 이름 입력" name=""/>
                            </div>
                            <br>
                            <span class="" id="acctNameText"></span>
                        </td>
                        <th>부서</th>
                        <td>
                            <div class="form_group w300">
                                <input type="text" maxlength="50" id="acctDept"
                                       value="" class="form_control"
                                       placeholder="부서 입력" name=""/>
                            </div>
                            <span class="" id="acctDeptText"></span>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">이메일 주소</th>
                        <td>
                            <div class="form_group w300">
                                <input type="text" maxlength="100" id="acctEmail"
                                       value=""
                                       class="form_control" placeholder="이메일 주소 입력" name=""/>
                            </div>
                            <br>
                            <span class="info_ment redfont" id="acctEmailText"
                                  style="display: none">이메일 형식에 맞지 않습니다.</span>
                        </td>
                        <th>전화번호</th>
                        <td>
                            <div class="form_group w218">
                                <input type="text" id="compAcctPhone"
                                       value="" maxlength="11"
                                       onkeypress="numberonly();" onpaste="javascript:return false;"
                                       class="form_control" placeholder="전화번호 입력" name=""/>
                            </div>
                            <br>
                            <span class="info_ment redfont" id="compAcctPhoneText"
                                  style="display: none">형식에 맞지 않는 번호 입니다.</span>
                        </td>
                    </tr>
                </table>
            </section>
            <!-- //table_view -->
            <!-- //예약 신청자 및 회계 담당자 정보 -->

            <!-- 부대시설 이용약관 -->
            <h3 class="stitle m-t-30">부대시설 이용약관</h3>
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
            <!-- //부대시설 이용약관 -->

            <section class="m-t-20 tac">
                <div class="line01"></div>
                <div class="form_group top0">
                    <div class="check_inline">
                        <label class="check_default">
                            <input type="checkbox" name="term" value="">
                            <span class="check_icon"></span>시험로 이용약관을 확인 및 동의하며 상기 주행시험장 사용을 신청합니다.</label>
                    </div>
                </div>
            </section>
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-6">취소</button>
            <button type="button" onclick="insertReserv();" class="btn-pop btn_default">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
<!--         <button data-fn="lyClose">레이어닫기</button> -->
    </article>
</div>
<!-- //popup_xl -->
<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>
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