<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
    <!-- container -->
    <div id="container">
        <!-- visual -->
        <div class="visual_sub technoring"></div>
        <!-- //visual -->
        <!-- content -->
        <div class="content">
            <!-- breadcrumb -->
            <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시험주행장</span><span>테크노링 소개</span></div>
            <!-- //breadcrumb -->
            <!-- title -->
            <h2 class="title">테크노링 소개</h2>
            <!-- //title -->
            <img src="/inc/images/BI_Technoring.png" alt="Hankook" />
            <div id="introduce">
                <br>
                <p>아시아 최대 규모 타이어 주행시험장 '테크노링(Technoring)' 등 주요 자산의 형상을 숫자 '80'과 함께 시각화한 것이 특징이다.</p>
            </div>
            <br>
            <div id="sample">
                <p>한국타이어 테크노링은 총 사업비 2000억여 원을 투자해 건설하는 타이어 성능 시험장이다. <br>국내 최대 규모인 약 38만 평으로 조성하는 테크노링은 순수한 타이어 테스트를 위한 주행시험장 및 연구개발 시설이다.</p>
                <br>
                <p>연구개발센터인 테크노돔에서 개발한 원천 기술의 필드테스트(고속주행, 원선회, 브레이킹, 수막시험 등)를 담당할 전망이다.<br>
                    250km/h 고속주행을 체험할 수 있는 고속 주행로 등 11개의 시험로를 포함해 사무동과 워크숍 공간 등 부대시설을 갖출 계획이다.
                </p>
                <br>
                <p>특히 방문객을 대상으로 △초고성능 타이어 △런플랫 타이어 △슈퍼카용 타이어 등을 직접 체험해 볼 수 있도록 '드라이빙 센터'를 마련해 고객과의 접점을 확대할 예정이다.
                </p>
            </div>
            <br>
            <br>
            <br>
            <br>
            <p>컨텐츠 대체할 예정</p>
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
