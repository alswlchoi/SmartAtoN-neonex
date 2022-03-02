<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:csrfMetaTags/>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
    <title>::: [한국타이어] Technoring admin :::</title>

    <!-- 스타일 시트 -->
    <link rel="stylesheet" type="text/css" href="/inc/css/dashboarddefault.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/common.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/font.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/dashboardlayout.css">
    <link rel="stylesheet" type="text/css" href="/inc/css/daterangepicker.css"><!-- daterangepicker style -->
    <link rel="stylesheet" type="text/css" href="/inc/css/jquery-ui.css"><!-- jquery-ui style -->
    <link rel="stylesheet" type="text/css" href="/inc/css/dashboard_Lobby3.css"><!-- dashboard_Lobby style -->

    <!-- 스크립트 -->
    <script type="text/javascript" src="/inc/js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="/inc/js/navi.js"></script> <!-- navigation -->
    <script type="text/javascript" src="/inc/js/common.js"></script>
    <script type="text/javascript" src="/inc/js/moment.min.js"></script> <!-- daterangepicker -->
    <script type="text/javascript" src="/inc/js/daterangepicker.js"></script> <!-- daterangepicker -->
    <script type="text/javascript" src="/inc/js/jquery-ui.js"></script> <!-- jquery-ui -->
</head>
<script type="text/javascript">
  $(document).ready(function () {
    date();
    time();
    lWeather();
    nowTest();
  });
  $(function () {
    setInterval(function () {
      time();
    }, 1000);

    setInterval(function () {
      lWeather();
      nowTest();
    }, 300000);
  })

  function time() {
    var Now = new Date();

    var nowH = String(Now.getHours());
    if (nowH.length == 1) {
      nowH = "0" + nowH;
    }
    var nowMin = String(Now.getMinutes());
    if (nowMin.length == 1) {
      nowMin = "0" + nowMin;
    }

    var time = nowH + ":" + nowMin;
    $("#time").text(time);
  }

  function date() {
    var Now = new Date(),
        nowYear = String(Now.getFullYear()),
        nowMon = String(Now.getMonth() + 1),
        nowDate = String(Now.getDate()),
        nowDay = "";

    if (nowMon.length == 1) {
      nowMon = "0" + nowMon;
    }
    if (nowDate.length == 1) {
      nowDate = "0" + nowDate;
    }

    switch (Now.getDay()) {
      case 1 :
        nowDay = "Monday";
        break;
      case 2 :
        nowDay = "Tuesday";
        break;
      case 3 :
        nowDay = "Wednesday";
        break;
      case 4 :
        nowDay = "Thursday";
        break;
      case 5 :
        nowDay = "Friday";
        break;
      case 6 :
        nowDay = "Saturday";
        break;
      case 0 :
        nowDay = "Sunday";
        break;
    }

    var date = nowYear + "." + nowMon + "." + nowDate + ", " + nowDay;
    $("#date").text(date);
  }
  var csrfHeader = $('meta[name="_csrf_header"]').attr('content');
  var csrfToken = $('meta[name="_csrf"]').attr('content');

  function lWeather() {
    $.ajax({
      url: "/admin/main/weather",
      type: "POST",
      contentType: "application/json",
      dataType: "JSON",
      beforeSend: function(xhr) {
        xhr.setRequestHeader("AJAX", true);
        xhr.setRequestHeader(csrfHeader, csrfToken);
        xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
        xhr.setRequestHeader("Content-type","application/json");
      },
      success: function (data) {
        console.log(data);
        weatherView(data);
      },
      error: function (jqXHR, textStatus) {
        console.log(jqXHR);
      }
    });

  }

  function weatherView(list) {
    console.log(list);
    var weather = list.weather;
    var api = list.json;
    // <!-- <div class="w_lightning">
    // <span>Today, Lightning</span>
    //   </div> -->
    if (api.wf == '번개') {
      $("#wWeather").attr('class', 'w_lightning');
      $("#wToday").html("Today, Lightning");
      $("#wImg").attr('src', "/inc/images/icon_weather_Lobby_lightning.png");
    } else if (api.wsIt == 3) {
      $("#wWeather").attr('class', 'w_wind');
      $("#wToday").html("Today, Wind");
      $("#wImg").attr('src', "/inc/images/icon_weather_Lobby_wind.png");
    } else if (api.rnYn == 1) {
      $("#wWeather").attr('class', 'w_rain');
      $("#wToday").html("Today, Rain");
      $("#wImg").attr('src', "/inc/images/icon_weather_Lobby_rain.png");
    } else if (api.rnYn == 3) {
      $("#wWeather").attr('class', 'w_snow');
      $("#wToday").html("Today, Snowing");
      $("#wImg").attr('src', "/inc/images/icon_weather_Lobby_snow.png");
    } else if (api.wf == "맑음") {
      $("#wWeather").attr('class', 'w_sunny');
      $("#wToday").html("Today, Sunny");
      $("#wImg").attr('src', "/inc/images/icon_weather_Lobby_sunny.png");
    } else {
      $("#wWeather").attr('class', 'w_cloud');
      $("#wToday").html("Today, Cloud");
      $("#wImg").attr('src', "/inc/images/icon_weather_Lobby_cloud.png");
    }

    $("#temp").html(parseInt(weather.ta)+ "<small>°</small></span><span>Air</span>");
    $("#road").html(parseInt(weather.road)+ "<small>°</small><span>Track</span>");
  }

  function nowTest() {
    var param = {
      today: moment().format("YYYYMMDD")
    }
    $.ajax({
      url: "/admin/main/dayTesting",
      type: "POST",
      contentType: "application/json",
      dataType: "JSON",
      data: {
        today: moment().format("YYYYMMDD")
      },
      beforeSend: function(xhr) {
        xhr.setRequestHeader("AJAX", true);
        xhr.setRequestHeader(csrfHeader, csrfToken);
        xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
        xhr.setRequestHeader("Content-type","application/json");
      },
      success: function (data) {
        nowTestView(data);
      },
      error: function (jqXHR, textStatus) {
        console.log(jqXHR);
      }
    });
  }

  function nowTestView(list) {
    var dayTest = list.dayTest;
    $("#today").html(dayTest.dayTest + "<span>Today</span>");
    $("#current").html(dayTest.testingAll + "<span>Current</span>");
  }

</script>

<body>

<!-- wrapper -->
<div id="wrapper" class="dashBoard_Lobby">

    <!-- container -->
    <div id="container">
        <!-- content -->
        <div class="content">
            <!-- col_right -->
            <div class="col_right">
                <div class="wrap_today">
                    <span class="time" id="time"></span>
                    <span class="date" id="date"></span>
                </div>
                <div class="wrap_Wicon m-t-30" id="wIcon">
                    <div class="" id="wWeather">
                        <span id="wToday"></span>
                        <span class="icon m-t-22">
                            <img id="wImg" src="" />
                        </span>
                    </div>
                </div>
                <div class="wrap_temp m-t-50">
                    <p class="">Temp.</p>
                    <div class="wrap_state">
                        <div class="col" id="temp">
                        </div>
                        <span class="line m-t-50"></span>
                        <div class="col" id="road">
                        </div>
                    </div>
                </div>
                <div class="wrap_temp m-t-33">
                    <p class="">Test</p>
                    <div class="wrap_state m-t-15">
                        <div class="col" id="today">
                        </div>
                        <span class="line"></span>
                        <div class="col" id="current">
                        </div>
                    </div>
                </div>
            </div>
            <!-- //col_right -->

        </div>
        <!-- //content -->
    </div>
    <!-- //container -->

</div>
<!-- //wrapper -->

</body>

</html>