<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<%@taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
    <sec:csrfMetaTags/>
<script type="text/javascript">
$(function(){
	$("#find_id").click(function(){
		if($("#memName_id").val().trim().length==0){
			alert("담당자 이름을 입력해 주세요.");
			return;
		}
		if($("#memEmail_id").val().trim().length==0){
			alert("이메일 주소를 입력해 주세요.");
			return;
		}
		var regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		if(!regEmail.test($("#memEmail_id").val().trim())){
			alert("이메일 형식에 맞지 않습니다.");
			return;
		}
		if($("#memPhone_id").val().trim().length==0){
			alert("휴대폰 번호를 입력해 주세요.");
			return;
		}
		var regMemPhone = /^01(?:0|1|[6-9])(?:\d{3}|\d{4})\d{4}$/;
		if(!regMemPhone.test($("#memPhone_id").val().trim())){
			alert("형식에 맞지 않는 번호 입니다.");
			return;
		}
		var data ={
			memName : $("#memName_id").val(),
			memEmail : $("#memEmail_id").val(),
			memPhone : $("#memPhone_id").val()
		};

		postAjax("/member/search/byid",data,"successSearchId",null,null,null);
	});
	$("#find_pwd").click(function(){
		if($("#memId_pwd").val().trim().length==0){
			alert("아이디를 입력해 주세요.");
			return;
		}
		var regId = /^[A-Za-z0-9]{5,12}$/;
		if(!regId.test($("#memId_pwd").val().trim())){
			alert("아이디는 5~12자 영문자,숫자로 입력해 주세요.");
			return;
		}
		if($("#memName_pwd").val().trim().length==0){
			alert("담당자 이름을 입력해 주세요.");
			return;
		}
		if($("#memEmail_pwd").val().trim().length==0){
			alert("이메일 주소를 입력해 주세요.");
			return;
		}
		var regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		if(!regEmail.test($("#memEmail_pwd").val().trim())){
			alert("이메일 형식에 맞지 않습니다.");
			return;
		}
		if($("#memPhone_pwd").val().trim().length==0){
			alert("휴대폰 번호를 입력해 주세요.");
			return;
		}
		var regMemPhone = /^01(?:0|1|[6-9])(?:\d{3}|\d{4})\d{4}$/;
		if(!regMemPhone.test($("#memPhone_pwd").val().trim())){
			alert("형식에 맞지 않는 번호 입니다.");
			return;
		}
		var data ={
			memId : $("#memId_pwd").val(),
			memName : $("#memName_pwd").val(),
			memEmail : $("#memEmail_pwd").val(),
			memPhone : $("#memPhone_pwd").val()
		};

		postAjax("/member/search/bypwd",data,"successSearchPwd","failSearchPwd",null,null);
	});

	$("#cancelTab3").click(function(){
		confirm("취소하시면 처음부터 다시 진행해야 됩니다.<br/>진행하시겠습니까?",successConfirm,cancelConfirm);
	})
	$("#modiBtn").click(function(){
		if($("#modiPwd").val().length==0){
			alert("비밀번호를 입력해 주세요");
			return;
		}
		if($("#modiPwdChk").val().length==0){
			alert("비밀번호를 입력해 주세요");
			return;
		}
		var regPwd = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$/;
		if(!regPwd.test($("#modiPwd").val())){//비밀번호는 공백도 한칸 차지이므로 trim 제거
			alert("비밀번호는 8~16자 영문자,숫자 및 특수문자 조합으로 입력해주세요.");
			return;
		}
		if(!regPwd.test($("#modiPwdChk").val())){//비밀번호는 공백도 한칸 차지이므로 trim 제거
			alert("비밀번호는 8~16자 영문자,숫자 및 특수문자 조합으로 입력해주세요.");
			return;
		}
		if($("#modiPwd").val() != $("#modiPwdChk").val()){
			alert("비밀번호를 확인해 주세요.");
			return;
		}
		var data ={
			memId : $("#memId_pwd").val(),
			memPwd : $("#modiPwd").val()
		};
		postAjax("/member/search/modiPwd",data,"successModiPwd",null,null,null);
	})
})
//아이디 찾기 결과
function successSearchId(data){
	if(data.result != null){
		var memId = data.result.memId;
		$("#resultId").html(memId);
		$("#find_id_hidden").click();
	}else{
		alert("해당 정보를 찾을 수 없습니다.<br>다시 한 번 정보를 확인해 주시기 바랍니다.");
	}
}
//패드워드 정보 비교 결과
function successSearchPwd(data){
	if(data.result == "OK"){
		$("#tab2").hide();
		$("#tab3").show();
	}else{
		alert("해당 정보를 찾을 수 없습니다.<br>다시 한 번 정보를 확인해 주시기 바랍니다.");
	}
}
//취소 후 확인
function successConfirm(data){
	location.href="/";
}
//취소 후 취소
function cancelConfirm(data){
	$(".lyClose").click();
}
//패스워드 변경
function successModiPwd(data){
	if(data.result>0){
		alert("비밀번호가 변경되었습니다.");
		$(".lyClose").click(function(){
			location.href="/login";
		})
	}else{
		alert("비밀번호 변경에 실패하였습니다.");
	}
}
</script>
<!-- container -->
<div id="container">
    <!-- visual -->
	<div class="visual_sub common"></div>
	<!-- //visual -->
	<!-- content -->
	<div class="content">
	    <!-- breadcrumb -->
		<div class="breadcrumb"><span class="breadcrumb_icon"></span><span>아이디/비밀번호 찾기</span></div>
		<!-- //breadcrumb -->
		<!-- title -->
		<h2 class="title">아이디/비밀번호 찾기</h2>
		<!-- //title -->
		<!-- tab -->
		<div class="wrap_tab w1200">
		    <div class="tab">
		        <button class="tab1Btn tablinks" onclick="openTab(event, 'tab1')" <c:if test="${tab ne '2'}">id="defaultOpen"</c:if>> 아이디 찾기</button>
			   <button class="tab2Btn tablinks" onclick="openTab(event, 'tab2')" <c:if test="${tab eq '2'}">id="defaultOpen"</c:if>>비밀번호 찾기</button>
			   <button class="tab3Btn tablinks" onclick="openTab(event, 'tab3')" style="display:none;"></button>
			</div>
			<div class="wrap_tabcontent">
			    <!-- tab1 -->
			   <div id="tab1" class="tabcontent">
			       <!-- find_wrap -->
			       <div class="find_wrap m-t-33">
			           <p>회원가입시 신청 등록한 담당자 정보로 아이디를 찾을 수 있습니다.</p>
			           <div class="form_group w500 m-t-45">
			               <input type="text" id="memName_id" class="form_control_lg" placeholder="담당자 이름을 입력하세요"
			                   name="" value="" maxlength="100"/>
			               <input type="text" id="memEmail_id" class="form_control_lg m-t-10" placeholder="이메일 주소를 입력하세요"
			                   name="" value="" maxlength="100"/>
			               <input type="text" id="memPhone_id" class="form_control_lg m-t-10"
			                   placeholder="휴대폰 번호를 입력하세요 ( ‘-’ 없이 숫자만 입력 )" name="" autocomplete="new-password" value="" maxlength="11" onkeypress="numberonly();" onpaste="javascript:return false;"/>
			           </div>
			           <!-- button -->
			           <section class="tac m-t-50">
		<!-- 	               <button type="button" class="btn-b btn_gray m-r-13" id="cancel_id">취소</button> -->
		<!-- 	               <button type="button" class="btn-b btn_gray m-r-13" id="cancel_id_hidden" data-layer="no_find" style="display:none;">취소</button> -->
			               <button type="button" class="btn-b btn_default" id="find_id">확인</button>
			               <button type="button" class="btn-b btn_default" id="find_id_hidden" data-layer="id_find" style="display:none;">확인</button>
			           </section>
			           <!-- //button -->
			       </div>
			       <!-- //find_wrap -->
			   </div>
			   <!-- //tab1 -->
			   <!-- tab2 -->
			   <div id="tab2" class="tabcontent">
			       <!-- find_wrap -->
			       <div class="find_wrap m-t-33">
			           <p>회원가입시 등록한 정보와 일치하면,<br>새로운 비밀번호를 설정할 수 있습니다.</p>
			           <div class="form_group w500 m-t-45">
			               <input type="text" id="memId_pwd" class="form_control_lg" placeholder="아이디를 입력하세요"
			                   name="" value="" maxlength="12"/>
			               <input type="text" id="memName_pwd" class="form_control_lg m-t-10" placeholder="담당자 이름을 입력하세요"
			                   name="" value="" maxlength="100"/>
			               <input type="text" id="memEmail_pwd" class="form_control_lg m-t-10" placeholder="이메일 주소를 입력하세요"
			                   name="" value="" maxlength="100"/>
			               <input type="text" id="memPhone_pwd" class="form_control_lg m-t-10"
			                   placeholder="휴대폰 번호를 입력하세요 ( ‘-’ 없이 숫자만 입력 )" name="" autocomplete="new-password" value="" maxlength="11" onkeypress="numberonly();" onpaste="javascript:return false;"/>
			           </div>
			           <!-- button -->
			           <section class="tac m-t-50">
<!-- 			               <button type="button" class="btn-b btn_gray m-r-13" data-layer="cancel">취소</button> -->
			               <button type="button" class="btn-b btn_default" id="find_pwd">확인</button>
			           </section>
			           <!-- //button -->
			       </div>
			       <!-- //find_wrap -->
			   </div>
			   <!-- //tab2 -->
			   <!-- tab3 -->
			   <div id="tab3" class="tabcontent">
			       <!-- find_wrap -->
                   <div class="find_wrap m-t-33">
                       <p>등록할 비밀번호를 입력해 주세요.</p>
                       <div class="m-t-50"><span class="info_ment">8~16자 영문자, 숫자 및 특수문자 조합하여 입력</span></div>
                       <div class="form_group w500 m-t-8">
                      	   <input type="password" id="modiPwd" class="form_control_lg" placeholder="비밀번호를 입력하세요" name="" />
			               <input type="password" id="modiPwdChk" class="form_control_lg m-t-10" placeholder="비밀번호를 다시 입력하세요"
			                   name="" autocomplete="new-password"/>
                       </div>
                       <!-- button -->
                       <section class="tac m-t-50">
                           <button type="button" class="btn-b btn_gray m-r-13" id="cancelTab3">취소</button>
<!--                            <button type="button" class="btn-b btn_gray m-r-13" data-layer="cancel">취소</button> -->
                           <button type="button" class="btn-b btn_default" id="modiBtn">확인</button>
                       </section>
                       <!-- //button -->
                   </div>
                   <!-- //find_wrap -->
			   </div>
			   <!-- //tab3 -->
		    </div>
		</div>
		<!-- //tab -->
	</div>
	<!-- //content -->
</div>
<!-- //container -->
<!-- popup_m -->
<div class="ly_group">
    <article class="layer_m id_find">
        <!-- # 타이틀 # -->
        <h1>아이디 찾기</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <div class="info_text01">
                회원님의 아이디는<br /><span id="resultId"></span><br />입니다.
            </div>
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <!-- <button type="button" class="btn-pop btn_gray m-r-11">취소</button> -->
            <button type="button" class="btn-pop btn_default lyClose">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_m -->
<!-- tab -->
<script>
    function openTab(evt, tabName) {
    	$("#modiPwd").val("");
    	$("#modiPwdChk").val("");
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
    document.getElementById("defaultOpen").click();
    // Get the element with id="defaultOpen" and click on it
</script>
<!-- //tab -->
<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>