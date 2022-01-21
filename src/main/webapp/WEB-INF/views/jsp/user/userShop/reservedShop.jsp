<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>

<script>
  $(document).ready(function() {
    $(".lodingdimm").hide();
  })
    function goMyPage() {
      location.href='/user/trReserve/myPage';
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
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>예약</span><span>부대시설 예약</span></div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">부대시설 예약</h2>
        <!-- //title -->
        <div class="box_txt02">
            <span>부대시설 예약 신청이 완료 되었습니다.</span>
            <p class="m-t-30">마이페이지에서 견적서 출력, 신청 내용 확인이 가능합니다.<br />신청하신 정보에 대해 시험장 사정에 따라 반려 및 이용제한이 될 수 있습니다.</p>
        </div>
        <!-- button -->
        <section class="tac m-t-50">
            <!-- <button type="button" class="btn btn_gray m-r-11">이전</button> -->
            <button type="button" onclick="goMyPage()" class="btn btn_default">마이페이지로 이동</button>
        </section>
        <!-- //button -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>

<!-- tab -->
<%--<script>
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
</script>--%>
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