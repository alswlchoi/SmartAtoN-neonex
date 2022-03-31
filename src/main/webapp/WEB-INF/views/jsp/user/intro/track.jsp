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

        <div class="wrap_img01 tac"><img src="/inc/images/img_TrackInfo.png" width="100%" alt="트랙소개" /></div>

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
