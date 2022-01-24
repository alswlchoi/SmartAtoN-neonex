<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<sec:csrfMetaTags/>
<script>
  function getParam(){
    var url = document.location.href;
    var pram;
    if (url.indexOf('#') >= 0){
      pram = url.substring(url.indexOf('?') + 1, url.indexOf('#')).split('&');
    } else {
      pram = url.substring(url.indexOf('?') + 1).split('&');
    }
    for(var i = 0, result = {}; i < pram.length; i++){
      pram[i] = pram[i].split('=');
      result[pram[i][0]] = decodeURIComponent(pram[i][1]);
    }
    return result;
  }

  $(document).ready(function() {
    console.log(getParam().trName);
    if(getParam().trName == 'HSO'){
      $("#HSO").attr('style', 'display:block');
    }
    if(getParam().trName == 'VDA'){
      $("#VDA").attr('style', 'display:block');
    }
    if(getParam().trName == 'Braking'){
      $("#Braking").attr('style', 'display:block');
    }
    if(getParam().trName == 'NVH'){
      $("#NVH").attr('style', 'display:block');
    }
    if(getParam().trName == 'PBN'){
      $("#PBN").attr('style', 'display:block');
    }
    if(getParam().trName == 'Ride'){
      $("#Ride").attr('style', 'display:block');
    }
    if(getParam().trName == 'GNR'){
      $("#GNR").attr('style', 'display:block');
    }
    if(getParam().trName == 'Hydro'){
      $("#Hydro").attr('style', 'display:block');
    }
    if(getParam().trName == 'Dry'){
      $("#Dry").attr('style', 'display:block');
    }
  });

</script>
<!-- container -->
<div id="container">
    <!-- visual -->
    <div class="visual_sub technoring"></div>
    <!-- //visual -->
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시험주행장</span><span>트랙 소개</span></div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">트랙 소개</h2>
        <!-- //title -->
        <div id="HSO" style="display: none">
            <img src="/inc/images/sample_track_HSO.png" alt="Hankook" />
        </div>
        <div id="VDA" style="display: none">
            <img src="/inc/images/sample_track_VDA.png" alt="Hankook" />
        </div>
        <div id="Braking" style="display: none">
            <img src="/inc/images/sample_track_Braking.png" alt="Hankook" />
        </div>
        <div id="NVH" style="display: none">

            <img src="/inc/images/sample_track_NVH.png" alt="Hankook" />
        </div>
        <div id="PBN" style="display: none">
            <img src="/inc/images/sample_track_PBN.png" alt="Hankook" />
        </div>
        <div id="Ride" style="display: none">
            <img src="/inc/images/sample_track_Ride.png" alt="Hankook" />
        </div>
        <div id="GNR" style="display: none">
            <img src="/inc/images/sample_track_GNB.png" alt="Hankook" />
        </div>
        <div id="Hydro" style="display: none">
            <img src="/inc/images/sample_track_Hydro.png" alt="Hankook" />
        </div>
        <div id="Dry" style="display: none">
            <img src="/inc/images/sample_track_Dry.png" alt="Hankook" />
        </div>
    </div>
    <!-- //content -->
</div>
<!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>


<!-- tab -->
<script>
  function openTab(evt, tabName) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
      tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
      tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(tabName).style.display = "block";
    evt.currentTarget.className += " active";
  }
  // Get the element with id="defaultOpen" and click on it
  document.getElementById("defaultOpen").click();
</script>
<!-- //tab -->

<!-- 팝업 아코디언 -->
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
