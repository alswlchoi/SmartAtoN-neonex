<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
  $(document).ready(function () {
    weather()
  });

  function weather() {
    var param = {};
    postAjax("/admin/main/weather", param, "weatherView", null, null, null);
  }

  function weatherView(list) {
    console.log(list);
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
    $("#wIcon").html(wIconHtml);
    $("#temp").html(""+weather.ta+"<small>℃</small>");
    $("#wd").html("바람 : <strong>"+weather.wdTxt+" "+nullToZero(weather.ws)+"</strong><small>m/s</small>");
    $("#road").html("노면 : <strong>"+nullToZero(weather.road)+"</strong><small>℃</small>");
    $("#hum").html("습도 : <strong>"+nullToZero(weather.rh)+"</strong><small>%</small>");
  }

  function nullToZero(data) {
    if (data == null) {
      return 0;
    } else {
      return data;
    }
  }

</script>
<div class="col01">
    <div class="w_state">
                                <span class="icon_weather" id="wIcon">
                                </span>
        <span class="t_state" id="temp"></span>
    </div>
</div>
<div class="col02">
    <ul>
        <li id="wd"></li>
        <li id="road"></li>
        <li id="hum"></li>
        <li><a href="#" title="more" onclick="moreWeather();">+ more</a></li>
    </ul>
</div>