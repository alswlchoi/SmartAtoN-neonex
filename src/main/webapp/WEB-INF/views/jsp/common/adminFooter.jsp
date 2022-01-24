<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ page import="org.springframework.security.core.Authentication"%>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder"%>
<%@ page import="com.hankook.pg.content.member.dto.MemberDto"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hankook.pg.content.login.dto.MenuDto"%>
<!-- quickmenu -->
<%
Authentication authentication2 = SecurityContextHolder.getContext().getAuthentication();
MemberDto memberDto2 = new MemberDto();
if(authentication2.getPrincipal() instanceof String){
	System.out.println("로그인x -footer");
}else{
	System.out.println("로그인o -footer");
	memberDto2 = (MemberDto)authentication2.getPrincipal();
	System.out.println("메뉴리스트");
	System.out.println(memberDto2.getMenuList());
	pageContext.setAttribute("menuList", memberDto2.getMenuList());

}
%>
<%if(authentication2.getPrincipal() instanceof String){%>
<%}else{ %>
	<div class="quickmenu_wrap">
	    <section>
		<%for(int i=0;i<memberDto2.getMenuList().size();i++){ %>
			<%if(memberDto2.getMenuList().get(i).getMUrl() !=null){ %>
				<%if(memberDto2.getMenuList().get(i).getMUrl().equals("/admin/trReserve/trlisting")){ %>
		        	<a href="/admin/trReserve/trlisting" class="test" title="시험로 시험관리">시험로<br />시험관리</a>
				<% }else if(memberDto2.getMenuList().get(i).getMUrl().equals("/admin/dashboard")){%>
		        	<a href="/admin/dashboard" class="gate" title="게이트 제어">컨트롤<br />보드</a>
				<% }else if(memberDto2.getMenuList().get(i).getMUrl().equals("/admin/trReserve/trcalendar")
						&& (memberDto2.getMenuList().get(i).getMenuCode().equals("M111"))){%>
		        	<a href="/admin/trReserve/trcalendar" class="schedule" title="스케줄 관리">스케줄<br />관리</a>
				<% }%>
			<% }%>
		<% }%>
	    </section>
	    <a href="#" class="top" title="위로 이동"></a>
	</div>
<%}	%>
<!-- //quickmenu -->
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

<!-- popup_xxl -->
<button type="button" data-layer="popup_weather" style="display:none;"></button>
<div class="ly_group">
    <article class="layer_xxl popup_weather">
        <!-- # 타이틀 # -->
        <h1>기상세부정보</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <div class="wrap_IWeather">
                <!-- col_left -->
                <div class="col_left">
                    <!-- tab -->
                    <div class="wrap_tab">
                        <div class="tab">
                            <button class="tablinks active" onclick="openTab(event, 'tab1')" id="defaultOpen">위성(구름)</button>
                            <button class="tablinks" onclick="openTab(event, 'tab2')">레이더</button>
                            <button class="tablinks" onclick="openTab(event, 'tab3')">노면온도 센서위치</button>
                        </div>
                        <div class="wrap_tabcontent h743 p-b-0">
                            <div id="tab1" class="tabcontent">
	                            <div id="weather1" style="height:630px;width:600px;">

	                            </div>
                            </div>
                            <div id="tab2" class="tabcontent">
	                            <div id="weather2" style="height:630px;width:646px;">

	                            </div>
                            </div>
                            <div id="tab3" class="tabcontent">
	                            <div id="weather3" style="height:630px;width:600px;">

	                            </div>
                            </div>
                        </div>
                    </div>
                    <!-- //tab -->
                </div>
                <!-- //col_left -->
                <!-- col_right -->
                <div class="col_right">
                    <div class="update_time" id="weatherupdateTime">00.00(월) 00:00:00 갱신</div>
                    <div class="wrap_winfo m-t-30">
                        <%@ include file="/WEB-INF/views/jsp/common/weather2.jsp" %>
                    </div>
                    <h3 class="m-t-23">노면온도</h3>
                    <!-- table list -->
                    <section class="tbl_wrap_list m-t-10">
                        <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                            <caption>테이블</caption>
                            <colgroup>
                                <col width="50px" />
                                <col width="" />
                                <col width="113px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">No.</th>
                                    <th scope="col">구분 (명칭 및 약어)</th>
                                    <th scope="col">노면온도 (℃)</th>
                                </tr>
                            </thead>
                            <tbody id="roadTempList">
                            </tbody>
                        </table>
                    </section>
                    <!-- //table list -->
                </div>
                <!-- //col_right -->
            </div>
        </div>
        <!-- 버튼 -->
        <!-- <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-6">취소</button>
            <button type="button" class="btn-pop btn_default lyClose">확인</button>
        </div> -->
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_xxl -->

</body>
</html>
