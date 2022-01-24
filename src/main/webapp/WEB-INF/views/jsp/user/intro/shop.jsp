<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<sec:csrfMetaTags/>

<script>
  $(document).ready(function() {
    getShopList();
  })

  function getShopList() {
    var param = {};
    postAjax("/before/shopList", param, "test", null, null, null)
  }

  function test(list) {
    console.log(list);
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
            <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시험주행장</span><span>부대시설 안내</span></div>
            <!-- //breadcrumb -->
            <!-- title -->
            <h2 class="title">부대시설 안내</h2>
            <!-- //title -->
            <div style="width: 100%;margin: auto;overflow: hidden">
                <div id="welcome" style="float: left;">
                    welcome
                    <br>
                    <img src="/inc/images/sample_shop_welcome.png" alt="Hankook" />
                    <br>
                </div>
                <div id="lobby" style="float: left;">
                    lobby
                    <br>
                    <img src="/inc/images/sample_shop_lobby.png" alt="Hankook" />
                    <br>
                </div>
            </div>
            <p>컨텐츠 대체할 예정</p>
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

