<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
    var tmSeq;
    var checkDay;
    var pagingDay;
    var pagingDayEnd;
    var colType;
    var wheelInfoArr = [];
    var wheelCount;

/**
 * ----------------------------------
 *  INIT
 * ----------------------------------
 */
     
$(function(){
    searchToday(1);
    searchDay(1,moment().add(1,'day').format('YYYYMMDD'),moment().add(1,'day').format('YYYYMMDD'));
    searchWheel(1);


	$('#date-start').daterangepicker({
        startDate: moment().add(1, 'day'),
        autoApply: true,
        singleDatePicker: true,
        cancelLabel: '취소',
        applyLabel: "확인",
        isInvalidDate: function (el) {
            var currentDay = moment().format('YYYYMMDD');
            var elDay = moment(el._d).format('YYYYMMDD');
            return [elDay].indexOf(currentDay) != -1;
        },
        locale: {
            monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
            daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
            yearSuffix: '년',
            separator: " ~ ",
            format: 'YYYY-MM-DD'
        }
    });
    // },function(start, end, label) {
    //     searchDay(1,moment(start).format('YYYYMMDD'));
    // });

    $('#date-end').daterangepicker({
        startDate: moment().add(1,'day'),
        autoApply: true,
        singleDatePicker: true,
        cancelLabel: '취소',
        applyLabel: "확인",
        isInvalidDate : function(el) {
            var currentDay = moment().format('YYYYMMDD');
            var elDay = moment(el._d).format('YYYYMMDD');
            return [elDay].indexOf(currentDay) != -1;
        },
        locale: {
            monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
            daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
            yearSuffix: '년',
            separator: " ~ ",
            format: 'YYYY-MM-DD'
        }
    });
});


/**
 * ----------------------------------
 *  Click Event
 * ----------------------------------
 */

//wheel 페이징 조회 버튼
$(document).on("click",".wheelPageNo",function(){
    searchWheel($(this).attr("data-page"));
});

//today 페이징 조회 버튼
$(document).on("click",".pageNo",function(){
    searchToday($(this).attr("data-page"));
});

//selectDay 페이징 조회 버튼
$(document).on("click",".dayPageNo",function(){
    searchDay($(this).attr("data-page"),pagingDay,pagingDayEnd);
});

//Wheel 팝업에서 버튼 클릭 시 선택된 값 삭제 후 리로드
$(document).on("click",".wheel_btn",function(){
    var el = $(this).val();
    var index = wheelInfoArr.indexOf(el);
    wheelInfoArr.splice(index,1);

    var html = "";

    wheelInfoArr.forEach(function (el) {
        html += '<button type="button" class="wheel_btn btn-s btn_default" value="' + el + '">' + el + '</button>';
    });

    $("#selectWheel").html(html);
});

/**
 * ----------------------------------
 *  Today Search
 * ----------------------------------
 */

function findTireAttr() {
    var tireAttr = $("#tireAttr").val();
    if(tireAttr == "") {
        searchToday(1);
    }else {
        var param = {
            attr : tireAttr
        };
        postAjax("/admin/tire/find",param,"searchCallback",null,null,null);
    }
}

function searchToday(page){
    var param = {
        pageNo:page
    }
    asyncPostAjax("/admin/tire",param,"searchCallback",null,null,null);
}

function searchDay(page,startDate,endDate) {
    var param = {
        pageNo : page,
        date : startDate,
        endDate : endDate
    }
    asyncPostAjax("/admin/tire",param,"searchCallback",null,null,null);
    
}

function searchCallback(data) {

    var html = "";
    var list = data.list;
    var type = data.type;

    if(list.length>0) {
        $.each(list, function(i) {

            if((list[i].tireLocation == 'TTST' && list[i].tirePush !=null && list[i].tireNumber !=null ) ||
                (list[i].tireLocation == 'TRWH' && list[i].tirePush !=null && list[i].tireNumber !=null) ||
                (list[i].tireLocation == null && list[i].tirePush !=null && list[i].tireNumber == null) ) {
                html += '<tr class ="bg_red2">';
            }else {
                html += '<tr>';
            }

            if(list[i].tmAssembly!=null || (list[i].tireLocation ==null && list[i].tmTrwhYn !=null && list[i].tirePush !=null)) {
                html += '<tr class ="bg_blue">';
            }

//             html += '   <td>'+ (list[i].plnDtm.replace(/^(.{4})/,"$1.")).replace(/^(.{7})/,"$1.") +'</td>';
//             html += '   <td>'+ list[i].reqNo + '</td>';
            html += '   <td>'+ (list[i].plnDtm.replace(/^(.{4})/,"$1.")).replace(/^(.{7})/,"$1.") +'</td>';
            html += '   <td class="test'+list[i].reqNo+'2  border-b-1">'+ list[i].reqNo + '</td>';
            html += '   <td class="border-l-1">'+ list[i].setSize +'</td>';
            html += '   <td>'+ list[i].tireSize.replace(',' , '</br>') + '</td>';
            html += '   <td>'+ list[i].wheelSize.replace(',', '</br>') + '</td>';

            if(list[i].engineer !=null) {
                html += '   <td>'+ list[i].engineer +'</td>';
            }else {
                html += '<td/>';
            }
            html += '   <td>'+ list[i].vhclName.replace(',' , '</br>') +'</td>';
            html += '   <td>'+ list[i].returnScrap.replace(',','</br>') +'</td>';

            if(list[i].tirePush !=null) {
                html += '   <td>Complete</td>';
            }else {
                html += '   <td><button type="button" class="btn-line-s btn_gray" data-seq="'+list[i].tmSeq+'" data-opt="tirePush" ' +
                    'data-day="'+list[i].plnDtm+'" onclick="confirmData($(this))">OK</button></td>';
            }

            if(list[i].tireLocation == 'TTST' && list[i].tirePush ==null && list[i].tireNumber !=null) {
                html += '   <td>금산창고</td>';
            }
            else if(list[i].tireLocation == 'TTST' && list[i].tirePush !=null && list[i].tireNumber !=null) {
                html += '   <td>금산창고</td>';
            }
            else if(list[i].tireLocation == null && list[i].tirePush !=null && list[i].tireNumber ==null) {
                html+= '    <td>출고완료</td>';
            }else if(list[i].tireLocation == 'TRWH' && list[i].tirePush !=null && list[i].tireNumber !=null) {
                html+= '    <td>'+ list[i].tireNumber.replace(',' , '</br>') +'</td>';
            } else {
                html+= '<td/>';
            }

            if(list[i].wheelLocation !=null) {
                var wheelList = list[i].wheelLocation.split(",");
                html += '<td>';
                wheelList.forEach(function(el) {
                    html += el.substr(0,el.indexOf("(")) + '<br>' + el.substr(el.indexOf("(")) + '<br>';
                });
                html += '</td>';
            }else {
                html += '   <td id="wheelLocation'+list[i].tmSeq+'">'
                    + '<button type="button" class="btn-line-s btn_gray" data-seq="'+list[i].tmSeq+'" data-max="'+list[i].wheelSize+'"' +
                    ' data-day="'+list[i].plnDtm+'" data-layer="search" onclick="calculateWheelSize($(this))">Search</button>' +'</td>';
            }

            html += '   <td>';
            html += '      <div class="form_group">';
            html += '         <div class="select_group">';
            html += '            <select id = "selectList'+list[i].tmSeq+'" title="select" class="form_control">';

            <c:forEach var = 'el' items="${liftList}">
                html+=              '<option value="${el}" ';
                if(list[i].lift == ${el}) {
                    html += 'selected'
                }
                html+=              '>${el}</option>';
            </c:forEach>

            html += '            </select>';
            html += '         </div>';
            html += '      </div>';
            html += '      <button type="button" class="btn-line-s btn_gray" data-seq="'+list[i].tmSeq+'" data-opt="lift" ' +
                'data-day="'+list[i].plnDtm+'" onclick="confirmData($(this))">저장</button>';
            html += '   </td>';

            if(list[i].tmAssembly !=null) {
                html += '   <td>Complete<br />(' +list[i].tmAssembly +')</td>';
            }else {
                html += '<td> <button type="button" class="btn-line-s btn_gray" data-seq="'+list[i].tmSeq+'" data-opt="tireAssembly" ' +
                    'data-day="'+list[i].plnDtm+'" data-push="'+list[i].tirePush+'" onclick="confirmData($(this))">OK</button> </td>';
            }

            if(list[i].tmDisassy !=null) {
                html += '   <td>Complete<br />('+list[i].tmDisassy+')</td>';
            }else {
                html += '<td> <button type="button" class="btn-line-s btn_gray" data-seq="'+list[i].tmSeq+'" data-opt="tireDisassy" ' +
                    'data-day="'+list[i].plnDtm+'" data-assembly="'+list[i].tmAssembly+'" onclick="confirmData($(this))">OK</button> </td>';
            }

            html += '</tr>';
        });
    }else{
        html += '<tr class="tr_nodata">';
        html += '<td colspan="14">등록된 정보가 없습니다.</td>';
        html += '</tr>';
    }
    if(type == "today") {
        $("#tireList").html(html);
        for (var i in data.list) {
            funRowspan("test"+data.list[i].reqNo+"2");
          }
        drawingPage(data.paging);
    }else {
        pagingDay = data.dayPaging;
        pagingDayEnd = data.dayPagingEnd;
        $("#tireDayList").html(html);
        drawingDayPage(data.paging);
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


function findRangeDay() {
    var startDay = $("#date-start").val().replace("-","");
    var endDay = $("#date-end").val().replace("-","");

    if(startDay>endDay) {
        alert("시작날짜가 종료날짜 보다 클 수 없습니다.");
    }else {
        searchDay(1,startDay,endDay);
    }

}

/**
 * ----------------------------------
 *  타이어 출고, Lift , Status 저장 관련 함수
 * ----------------------------------
 */

function confirmData(data) {
    tmSeq = data.attr("data-seq");
    colType = data.attr("data-opt");
    checkDay = data.attr("data-day");

    alert(tmSeq);
    alert(colType);
    alert(checkDay);


    if(colType=="tireAssembly") {
        var check = data.attr("data-push");
        if(check == "null") {
            alert("출고 요청 전에 조립할 수 없습니다.");
        }else {
            confirm("OK (저장) 처리 하시겠습니까?", "confirmTrue", "confirmFalse");
        }
    }else if(colType =="tireDisassy") {
        var check = data.attr("data-assembly");
        if(check == "null") {
            alert("조립 전에 해체 할 수 없습니다.");
        }else {
            confirm("OK (저장) 처리 하시겠습니까?", "confirmTrue", "confirmFalse");
        }
    }else {
        confirm("OK (저장) 처리 하시겠습니까?", "confirmTrue", "confirmFalse");
    }
}
function confirmTrue() {
    insertData();
}
function confirmFalse(){}

function insertData() {

    alert(colType);

    var param;

    if(colType=='lift') {
        var selectId = "selectList"+tmSeq;
        var lift = $('#'+selectId).val();

        param = {
            tmSeq : tmSeq,
            colType : colType,
            lift : lift
        };
    }else {
        param = {
            tmSeq : tmSeq,
            colType : colType
        };
    }
console.log(param);
    postAjax("/admin/tire/insert",param,"insertCallback",null,null,null);
}

function insertCallback(data) {
    var day = moment().format('YYYYMMDD');
    if(data>0) {
        if(checkDay == day) {
            searchToday($(".pageNo.on").data("page"));
        }else {
            var startDay = $("#date-start").val().replace("-","");
            var endDay = $("#date-end").val().replace("-","");
            searchDay($(".dayPageNo.on").data("page"),startDay,endDay);
            
        }
    }else {
        alert("[시스템에러] 관리자에게 문의 해 주세요.");
    }
}


/**
 * ----------------------------------
 * Wheel Search 클릭 시 Init
 * @param data
 * ----------------------------------
 */

function calculateWheelSize(data) {
    var wheelInfo = data.attr("data-max");

    tmSeq = data.attr("data-seq");
    wheelCount = wheelInfo.split(",").length;
    wheelInfoArr = [];

    $("#selectWheel").html("");
}


/**
 * ----------------------------------
 *  [POPUP]
 *  Wheel Search
 * ----------------------------------
 */

function findWheelAttr() {
    var param = {
        wheelSize : $("#wheel_search_size").val(),
        maker : $("#wheel_search_maker").val(),
        project : $("#wheel_search_project").val()
    }
    postAjax("/admin/tire/wheel/find",param,"searchWheelCallback",null,null,null);
}

function searchWheel(page) {
    var param = {
        pageNo:page
    }
    postAjax("/admin/tire/wheel/findAll",param,"searchWheelCallback",null,null,null);
}
function searchWheelCallback(data) {
    var list = data.wheelList;
    var html = "";

    if(list.length>0) {
        $.each(list, function(i) {
            html+='<tr onmouseover="this.className=\'on\'" onmouseout="this.className=\'\'" ' +
                'data-wheelsize="'+list[i].wheelSize+'" data-locaky="'+list[i].locaky+'" data-wheeloffset="'+list[i].wheelOffSet+'" onclick="addWheelData($(this))" class="" >';
            html+='     <td>' + list[i].barcodeNo + '</td>';
            html+='     <td>' + list[i].wheelSize + '</td>';
            html+='     <td>' + list[i].maker + '</td>';
            html+='     <td>' + list[i].project + '</td>';
            html+='     <td>' + list[i].pcd + '</td>';
            html+='     <td>' + list[i].wheelOffSet + '</td>';
            html+='     <td>' + list[i].hole + '</td>';
            html+='     <td>' + list[i].hub + '</td>';
            html+='     <td>' + list[i].locaky + '</td>';
            html+='     <td>' + list[i].locakyName + '</td>';
            html+='</tr>';
        });

    }else {
        html+='<tr class="tr_nodata">';
        html+='    <td colspan="11">등록된 정보가 없습니다.</td>';
        html+='</tr>';
    }

    $("#wheelList").html(html);
    drawingWheelPage(data.paging);
}


/**
 * ----------------------------------
 *  [POPUP]
 *  Add Wheel Data
 * ----------------------------------
 */

function addWheelData(data) {
    if(wheelInfoArr.length<wheelCount) {
        var wheelSize = data.attr("data-wheelsize");
        var wheelOffSet = data.attr("data-wheeloffset");
        var locaky = data.attr("data-locaky");

        var result = locaky + "(" + wheelSize + " " + wheelOffSet + ")";
        wheelInfoArr.push(result);

        var html = "";

        wheelInfoArr.forEach(function (el) {
            html += '<button type="button" class="wheel_btn btn-s btn_default" value="' + el + '">' + el + '</button>';
        });

        $("#selectWheel").html(html);
    }else {
        alert3("최대 "+ wheelCount +"개까지만 추가 가능 합니다.");
    }
}

/**
 * ----------------------------------
 *  [POPUP]
 *  Reset Wheel Search InputText
 * ----------------------------------
 */

function resetWheelLocationSearch() {
    $("#wheel_search_size").val('');
    $("#wheel_search_maker").val('');
    $("#wheel_search_project").val('');
}


</script>
<!-- container -->
        <div id="container">
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시험자원관리</span><span>타이어/휠 관리</span><span>Tire / Wheel management</span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">Tire / Wheel management</h2>
                <!-- //title -->
                <!-- search_wrap -->
                <section class="search_wrap tar">
                    <h3 class="stitle disib fl m-t-10">Today Test</h3>
                    <div class="form_group w300">
                        <input type="text" id="tireAttr" class="form_control" placeholder="Request no/engineer/vehicle"
                            name="" maxlength="30" />
                    </div>
                    <button type="button" class="btn-s btn_default" onclick="findTireAttr()">조회</button>
                </section>
                <!-- //search_wrap -->
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
                            <col width="" />
                            <col width="" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th colspan="8" scope="col" class="border-b-1">Test Information</th>
                                <th rowspan="2" scope="col">Tire 출고 요청</th>
                                <th rowspan="2" scope="col">Tire Location</th>
                                <th rowspan="2" scope="col">Wheel Location</th>
                                <th rowspan="2" scope="col">Lift</th>
                                <th colspan="2" scope="col" class="border-b-1">Status</th>
                            </tr>
                            <tr>
                                <th scope="col">Date</th>
                                <th scope="col">Request No</th>
                                <th scope="col">Set</th>
                                <th scope="col">Tire Size</th>
                                <th scope="col">Wheel Size</th>
                                <th scope="col">Engineer</th>
                                <th scope="col">Vehicle</th>
                                <th scope="col">Return/Scrap</th>
                                <th scope="col">Tire Assy</th>
                                <th scope="col">Tire Disassy</th>
                            </tr>
                        </thead>
                        <!-- writing script( fn. searchTodayCallback ) -->
                        <tbody id="tireList"></tbody>
                    </table>
                </section>
                <!-- //table list -->
                <!-- Pagination -->
                <section id="pagingc" class="pagination m-t-30">
                    <jsp:include page="/WEB-INF/views/jsp/common/paging.jsp" />
                </section>
                <!-- //Pagination -->
				<section class="search_wrap tar">
					<h3 class="stitle disib fl m-t-10">Tomorrow Test</h3>
<!-- 					<h3 class="stitle m-t-50">Tomorrow Test</h3> -->
					<div class="form_group">
		                <input type="text" style="display:inline-block" id="date-start" class="form_control date1 dateicon" placeholder="2021-04-09" name="">
		            </div>
                    <span>~</span>
                    <div class="form_group">
                        <input type="text" style="display:inline-block" id="date-end" class="form_control date1 dateicon" placeholder="2021-04-09" name="">
                    </div>
                    <button type="button" class="btn-s btn_default" onclick="findRangeDay()">조회</button>
<%--		            <button type="button" class="btn-s btn_default">조회</button>--%>
		        </section>

                <!-- table list -->
                <section class="tbl_wrap_list m-t-15">
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
                                <th colspan="8" scope="col" class="border-b-1">Test Information</th>
                                <th rowspan="2" scope="col">Tire 출고 요청</th>
                                <th rowspan="2" scope="col">Tire Location</th>
                                <th rowspan="2" scope="col">Wheel Location</th>
                                <th rowspan="2" scope="col">Lift</th>
                                <th colspan="2" scope="col" class="border-b-1">Status</th>
                            </tr>
                            <tr>
                                <th scope="col">Date</th>
                                <th scope="col">Request No</th>
                                <th scope="col">Set</th>
                                <th scope="col">Tire Size</th>
                                <th scope="col">Wheel Size</th>
                                <th scope="col">Engineer</th>
                                <th scope="col">Vehicle</th>
                                <th scope="col">Return/Scrap</th>
                                <th scope="col">Tire Assy</th>
                                <th scope="col">Tire Disassy</th>
                            </tr>
                        </thead>
                        <tbody id="tireDayList"></tbody>
                    </table>
                </section>
                <!-- //table list -->
                <!-- Pagination -->
                <section id="day-paging" class="pagination m-t-30">
                    <jsp:include page="/WEB-INF/views/jsp/admin/tire/day-paging.jsp" />
                </section>
                <!-- //Pagination -->
            </div>
            <!-- //content -->
        </div>
        <!-- //container -->
<!-- popup_xl -->
    <div class="ly_group">
        <article class="layer_xl search">
            <!-- # 타이틀 # -->
            <h1>Wheel Location Search</h1>
            <!-- # 컨텐츠 # -->
            <div class="ly_con">
                <!-- search_wrap -->
                <section class="search_wrap">
                    <div class="form_group w200">
                        <input type="text" id="wheel_search_size" class="form_control" placeholder="휠사이즈 입력" name="" maxlength="10" />
                    </div>
                    <div class="form_group w200">
                        <input type="text" id="wheel_search_maker" class="form_control" placeholder="OE Maker 입력" name="" maxlength="30" />
                    </div>
                    <div class="form_group w200">
                        <input type="text" id="wheel_search_project" class="form_control" placeholder="Project 입력" name="" maxlength="100" />
                    </div>
                    <button type="button" class="btn-s btn_gray" onclick="resetWheelLocationSearch()">Reset</button>
                    <button type="button" class="btn-s btn_default" onclick="findWheelAttr()">Search</button>
                </section>

                <section class="m-t-5" id="selectWheel"></section>

                <!-- //search_wrap -->
                <!-- table list -->
                <section class="tbl_wrap_list m-t-5">
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
                            <col width="" />
                            <col width="" />
                            <col width="" />
                            <col width="" />
                        </colgroup>
                        <thead>
                            <tr>
<%--                                <th scope="col">Select</th>--%>
                                <th scope="col">Barcode</th>
                                <th scope="col">휠 사이즈</th>
                                <th scope="col">OE Maker</th>
                                <th scope="col">Project</th>
                                <th scope="col">PCD(mm)</th>
                                <th scope="col">Offset</th>
                                <th scope="col">HOLE수(EA)</th>
                                <th scope="col">HUB경(mm)</th>
                                <th scope="col">지번</th>
                                <th scope="col">지번명</th>
                        </thead>
                        <tbody id ="wheelList"></tbody>
                    </table>
                </section>
                <!-- //table list -->
                <!-- Pagination -->
                <section id="wheel-paging" class="pagination m-t-30">
                    <jsp:include page="/WEB-INF/views/jsp/admin/tire/wheel-paging.jsp" />
                </section>
                <!-- //Pagination -->

            </div>
            <!-- 버튼 -->
            <div class="wrap_btn01 m-t-5">
                <button type="button" class="btn-pop btn_gray lyClose m-r-6">취소</button>
                <button type="button" class="btn-pop btn_default lyClose3">확인</button>
            </div>
            <!-- # 닫기버튼 # -->
            <button data-fn="lyClose">레이어닫기</button>
        </article>
    </div>

<!-- Wheel 팝업 [확인] 관련 (Wheel Data Insert) -->
<script>
    /* Wheel 전용 팝업 승인.. */
    $("[data-fn='lyClose3'], .lyClose3, .closePopupBtn").click(function () {
        if(wheelInfoArr.length==0) {
            alert3("최소 1개이상 입력하셔야 합니다.");
        }else {
            var wheelList="";
            wheelInfoArr.forEach(function (el) {
                wheelList+= el +",";
            });
            wheelList = wheelList.slice(0,-1);

            insertWheelData(tmSeq,wheelList);


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
        }
    });

    function insertWheelData(tmSeq, wheelList) {
        var param = {
            tmSeq : tmSeq,
            wheelList : wheelList
        }
        postAjax("/admin/tire/wheel/insert",param,"insertWheelDataCallback",null,null,null);
    }
    function insertWheelDataCallback(data) {
        if(data>0) {
            var wheelLocationArea = "wheelLocation" + tmSeq;
            var html = "";
            wheelInfoArr.forEach(function (el) {
                html += '<a" value="' + el + '">' + el.substr(0,el.indexOf("(")-1) + '<br>' + el.substr(el.indexOf("(")) + '</a> <br>';
            });

            $('#'+wheelLocationArea).html(html);
        }else {
            alert("Failed!! 재시도 해보고 관리자에게 문의 해 주세요");
        }
    }

</script>
    <!-- //popup_xl -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>