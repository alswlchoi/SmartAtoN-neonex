<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<sec:csrfMetaTags/>
<script>
  $(document).ready(function() {
    getTrackList();
  })

    function getTrackList() {
      var param = {};
      postAjax("/before/trackList", param, "test", null, null, null)
    }

    function test(list) {
      console.log(list);
    }

    function goHSO() {
    location.href = "/user/track?trName=HSO"
    }
  function goVDA() {
    location.href = "/user/track?trName=VDA"
  }
  function goBraking() {
    location.href = "/user/track?trName=Braking"
  }
  function goNVH() {
    location.href = "/user/track?trName=NVH"
  }
  function goPBN() {
    location.href = "/user/track?trName=PBN"
  }
  function goRide() {
    location.href = "/user/track?trName=Ride"
  }
  function goGNR() {
    location.href = "/user/track?trName=GNR"
  }
  function goHydro() {
    location.href = "/user/track?trName=Hydro"
  }
  function goDry() {
    location.href = "/user/track?trName=Dry"
  }
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
            <img src="/inc/images/sample_track_all.png" alt="Hankook" style="margin: auto"/>
            <%--<div id="clickArea" style="display: flex">
                <br>
                <button id="HSO" onclick="goHSO()" style="margin: 1%; padding: 2%;"><h3>HSO</h3></button>
                <br>
                <button id="VDA" onclick="goVDA()"style="margin: 1%; padding: 2%;"><h3>VDA</h3></button>
                <br>
                <button id="Braking" onclick="goBraking()"style="margin: 1%; padding: 2%;"><h3>Braking</h3></button>
                <br>
                <button id="NVH" onclick="goNVH()"style="margin: 1%; padding: 2%;"><h3>NVH</h3></button>
                <br>
                <button id="PBN" onclick="goPBN()"style="margin: 1%; padding: 2%;"><h3>PBN</h3></button>
                <br>
                <button id="Ride" onclick="goRide()"style="margin: 1%; padding: 2%;"><h3>Ride</h3></button>
                <br>
                <button id="GNR" onclick="goGNR()"style="margin: 1%; padding: 2%;"><h3>GNR</h3></button>
                <br>
                <button id="Hydro" onclick="goHydro()"style="margin: 1%; padding: 2%;"><h3>Hydro</h3></button>
                <br>
                <button id="Dry" onclick="goDry()"style="margin: 1%; padding: 2%;"><h3>Dry</h3></button>
                <br>
            </div>--%>
            <p>컨텐츠 대체할 예정</p>
        </div>
        <!-- //content -->
    </div>
    <!-- //container -->
    <%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>

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
