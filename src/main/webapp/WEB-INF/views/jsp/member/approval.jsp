<%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/jsp/common/header.jsp" %>
<%@taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
    <sec:csrfMetaTags/>
<script type="text/javascript">
$(function(){
	$("#approvalChk").click(function(){
		if($("#compLicense").val().trim().length==0){
			alert("사업자 등록번호는 ‘-” 없이  10자 숫자로 입력해 주세요.");
			return;
		}
		if($("#memName").val().trim().length==0){
			alert("담당자 이름을 입력해 주세요.");
			return;
		}
		if($("#memEmail").val().trim().length==0){
			alert("이메일 주소를 입력해 주세요.");
			return;
		}
		var regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		if(!regEmail.test($("#memEmail").val().trim())){
			alert("이메일 형식에 맞지 않습니다.");
			return;
		}
		var data = {
	    		//로그인정보
	    		compLicense : $("#compLicense").val().trim(),
	    		memName : $("#memName").val().trim(),
	    		memEmail : $("#memEmail").val().trim()
	    		};
		postAjax("/member/approval/chk",data,"chkApproval",null,null,null);
	});
	$("#compLicense").on("paste",function(){
	    //복사 붙여넣기 시 공백, '-' ,'.' 제거 추가 할 것
    	var self = $(this);
	    setTimeout(function(){
		    var val = self.val();
		    var regx = new RegExp(/^[0123456789]$/);
		    if (!regx.test(val)) {
		        val = val.replace(/[^0-9]/gi, '').replace(/[-+]/g, '')
		        self.val(val);
		    }
	    },100)
	});
});
function chkApproval(data){
	if(data.result != null){
		if(data.result == 'A000'){//승인 대기중인 경우
			alert2("신청하신 정보에 대해 담당자가 검토 중입니다.","담당자 검토/승인 후<br/>이메일로 알려드립니다.","확인",null);
		}else if(data.result =='A002'){//승인 완료된 경우
			alert2("회원가입이 승인 완료 되었습니다.","로그인 후 마이페이지에서<br/>사업자 등록증 사본(미첨부한 경우)과 운전자 정보를<br/>등록해주시기 바랍니다.","로그인","goLogin");
		}
	}else{
		//심사 반려된 경우
		alert2("신청하신 정보를 찾을 수 없습니다.","회원가입을 신청하신 회원사의 승인 여부 관련되어<br/>이메일로 발송해 드리오니 자세한 사항은<br/>이메일을 확인해 주시기 바랍니다.","확인",null);
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
       <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>회원가입 심사결과 조회</span></div>
       <!-- //breadcrumb -->
       <!-- title -->
       <h2 class="title">회원가입 심사결과 조회</h2>
       <!-- //title -->
       <!-- find_wrap -->
       <div class="find_wrap">
           <p>회원가입 시 신청 등록한 사업자정보와 담당자 정보를 입력해 주세요.</p>
           <div class="form_group w500 m-t-45">
               <input type="text" id="compLicense" class="form_control_lg" placeholder="사업자 등록번호를 입력하세요 ( ‘-’ 없이 숫자만 입력 )"
                   name="" value="" maxlength="12" onkeypress="numberonly();"/>
               <input type="text" id="memName" class="form_control_lg m-t-10" placeholder="담당자 이름을 입력하세요" name="" value="" maxlength="100"/>
               <input type="text" id="memEmail" class="form_control_lg m-t-10" placeholder="이메일 주소를 입력하세요" name="" value="" maxlength="100"/>
           </div>
           <!-- button -->
           <section class="tac m-t-50">
<!--                         <button type="button" class="btn-b btn_gray m-r-13">취소</button> -->
<!--                <button type="button" class="btn-b btn_default" id="approvalChkHidden" data-layer="approval01" style="display:none;">확인</button> -->
               <button type="button" class="btn-b btn_default" id="approvalChk">확인</button>
           </section>
           <!-- //button -->
       </div>
       <!-- //find_wrap -->
   </div>
   <!-- //content -->
</div>
<!-- //container -->
<!--     popup_m -->
<!--     <div class="ly_group"> -->
<!--         <article class="layer_m approval01"> -->
<!--             # 타이틀 # -->
<!--             <h1>안내</h1> -->
<!--             # 컨텐츠 # -->
<!--             <div class="ly_con"> -->
<!--                 <div class="info_text02"> -->
<!--                     <p>회원가입이 승인 완료 되었습니다.</p> -->
<!--                     <p>로그인 후 마이페이지 에서<br />사업자 등록증 사본(미첨부한 경우)과 운전자 정보를<br />등록해 주시기 바랍니다.</p> -->
<!--                 </div> -->
<!--             </div> -->
<!--             버튼 -->
<!--             <div class="wrap_btn01"> -->
<!--                 <button type="button" class="btn-pop btn_gray m-r-11">취소</button> -->
<!--                 <button type="button" class="btn-pop btn_default lyClose">로그인</button> -->
<!--             </div> -->
<!--             # 닫기버튼 # -->
<!--             <button data-fn="lyClose">레이어닫기</button> -->
<!--         </article> -->
<!--     </div> -->
<!--     //popup_m -->

<!--     popup_m -->
<!--     <div class="ly_group"> -->
<!--         <article class="layer_m approval02"> -->
<!--             # 타이틀 # -->
<!--             <h1>안내</h1> -->
<!--             # 컨텐츠 # -->
<!--             <div class="ly_con"> -->
<!--                 <div class="info_text02"> -->
<!--                     <p>신청하신 정보에 대해  담당자가 검토 중입니다.</p> -->
<!--                     <p>담당자 검토/승인 완료 후 이메일로 알려드립니다.</p> -->
<!--                 </div> -->
<!--             </div> -->
<!--             버튼 -->
<!--             <div class="wrap_btn01"> -->
<!--                 <button type="button" class="btn-pop btn_gray m-r-11">취소</button> -->
<!--                 <button type="button" class="btn-pop btn_default lyClose">확인</button> -->
<!--             </div> -->
<!--             # 닫기버튼 # -->
<!--             <button data-fn="lyClose">레이어닫기</button> -->
<!--         </article> -->
<!--     </div> -->
<!--     //popup_m -->

<!--     popup_m -->
<!--     <div class="ly_group"> -->
<!--         <article class="layer_m approval03"> -->
<!--             # 타이틀 # -->
<!--             <h1>안내</h1> -->
<!--             # 컨텐츠 # -->
<!--             <div class="ly_con"> -->
<!--                 <div class="info_text02"> -->
<!--                     <p></p> -->
<!--                     <p>신청하신 정보를 찾을 수 없습니다.<br />회원가입을 신청하신 회원사의 승인 여부 관련되어<br />이메일로 발송해 드리오니 자세한 사항은<br />이메일을 확인해 주시기 바랍니다.</p> -->
<!--                 </div> -->
<!--             </div> -->
<!--             버튼 -->
<!--             <div class="wrap_btn01"> -->
<!--                 <button type="button" class="btn-pop btn_gray m-r-11">취소</button> -->
<!--                 <button type="button" class="btn-pop btn_default lyClose">확인</button> -->
<!--             </div> -->
<!--             # 닫기버튼 # -->
<!--             <button data-fn="lyClose">레이어닫기</button> -->
<!--         </article> -->
<!--     </div> -->
<!--     //popup_m -->

<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>