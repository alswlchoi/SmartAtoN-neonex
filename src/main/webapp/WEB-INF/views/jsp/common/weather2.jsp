<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:csrfMetaTags/>
<script type="text/javascript">

  function weather2() {
    var param = {};
    postAjax("/admin/main/weather", param, "weatherView2", null, null, null);
  }

  function weatherView2(list) {
    var weather = list.weather;
    var api = list.json;
    var wIconHtml = "";
  // <!-- <i class="lightning" title="번개"></i> -->
    if (api.wsIt == 3) {
      wIconHtml += '<i class="wind" title="바람"></i>';
    } else if (api.rnYn == 1) {
      wIconHtml += '<i class="rain" title="비"></i>';
    } else if (api.rnYn == 3) {
      wIconHtml += '<i class="snow" title="눈"></i>';
    } else if (api.wf == "맑음") {
      wIconHtml += '<i class="sun" title="맑음"></i>';
    } else {
      wIconHtml += '<i class="cloud" title="구름"></i>';
    }
    $("#wIcon2").html(wIconHtml);
    $("#temp2").html(""+weather.ta+"<small>℃</small>");
    $("#hum2").html("습도 : <strong>"+zero(weather.rh)+"</strong><small>%</small>");
    $("#wd2").html("바람 : <strong>"+api.wd2+" "+zero(weather.ws)+"</strong><small>m/s</small>");
    $("#pa2").html("기압 : <strong>"+zero(weather.pa)+"</strong><small>hPa</small>");
    $("#rainDay2").html("1일 강우량 : <strong>"+zero(weather.rainDay)+"</strong><small>mm</small>");
    $("#rainHour2").html("1시간 강우량 : <strong>"+zero(weather.rainHr)+"</strong><small>mm</small>");
  }

  function zero(data) {
    if (data == null) {
      return 0;
    } else {
      return data;
    }
  }

</script>
    <div class="w_state">
                                <span class="icon_weather" id="wIcon2">
                                </span>
        <span class="t_state" id="temp2">- 1.9<small>℃</small></span>
    </div>
    <div class="w_state_info m-t-20">
        <ul>
            <li class="humidity" id="hum2"></li>
            <li class="wind" id="wd2"></li>
            <li class="pressure" id="pa2"></li>
        </ul>
        <ul class="m-t-8">
            <li class="rain" id="rainDay2"></li>
            <li class="rain" id="rainHour2"></li>
        </ul>
    </div>