<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<!-- footer -->
        <div class="footer">
            <section>
                <span><img src="/inc/images/ci_hankook.png" alt="한국타이어" /></span>
                <p>Copyright © Hankook Tire & Technology Co.,Ltd. All Rights Reserved.</p>
            </section>
        </div>
        <!-- //footer -->
    </div>
    <!-- //wrapper -->
<!-- 알럿 공통 -->
<button type="button" data-layer="alert_pop" style="display:none;"></button>
<div class="ly_group">
    <article class="layer_Alert alert_pop">
        <!-- # 타이틀 # -->
<!--        <h1>알림</h1> -->
       <div class="ly_con" id="alertMessage">
       </div>
       <!-- 버튼 -->
       <div class="wrap_btn01">
           <button type="button" class="btn-pop btn_default lyClose">확인</button>
       </div>
       <!-- # 닫기버튼 # -->
       <button data-fn="lyClose">레이어닫기</button>
       <!-- # 컨텐츠 # -->
    </article>
</div>
<!-- //알럿 공통 -->
<!-- 알럿 버전2 -->
<button type="button" data-layer="alert_pop2" style="display:none;"></button>
<div class="ly_group">
    <article class="layer_m alert_pop2">
        <!-- # 타이틀 # -->
        <h1>안내</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <div class="info_text02">
                <p id="alertText1"></p>
                <p id="alertText2"></p>
            </div>
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <!-- <button type="button" class="btn-pop btn_gray m-r-11">취소</button> -->
            <button type="button" class="btn-pop btn_default lyClose" id="alertCloseCallbackHidden" style="display:none;">확인</button>
            <button type="button" class="btn-pop btn_default" id="alertCloseCallback">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_m -->
<!-- 알럿3 -->
<button type="button" data-layer="alert_pop3" style="display:none;"></button>
<div class="ly_group2" id="alert3">
    <article class="layer_Alert alert_pop3">
        <!-- # 타이틀 # -->
        <!--        <h1>알림</h1> -->
        <div class="ly_con" id="alertMessage3">
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_default lyClose2" id="alertCloseCallback3">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose2">레이어닫기</button>
        <!-- # 컨텐츠 # -->
    </article>
</div>
<!-- //알럿3 -->
<!-- 컨펌 공통 -->
<button type="button" data-layer="confirm_pop" style="display:none;"></button>
<div class="confirmDiv ly_group">
    <article class="layer_Alert confirm_pop">
        <div class="ly_con" id="confirmMessage"></div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray m-r-11" id="confirmFalse">취소</button>
            <button type="button" class="btn-pop btn_default" id="confirmTrue">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //컨펌 공통 -->

</body>
</html>
