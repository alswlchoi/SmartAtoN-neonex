<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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

  $(document).ready(function () {
    // 더미데이터
    // var reservCode = 'F210901B001';
    doFirst();
  });
  function doFirst() {
    var reservCode = getParam().reservCode;
    var param = {
      wssReservCode: reservCode,
    };
    postAjax("/user/myPageShop/detail", param, "getDetail", null, null, null);
  }

    function getDetail (list) {
    if (list.wssApproval == 'N') {
      // 승인대기
      $('#estimate').show();
      $('#approval').html('승인대기<br/><button id="cancelBtn" type="button" class="btn-line-s btn_gray" data-layer="cancel_info">예약취소</button>');
    } else if (list.wssApproval == 'Y') {
      // 승인완료
      $('#estimate').hide();
      $('#approval').html("승인완료");
    } else if (list.wssApproval == 'E') {
      // 사용완료
      $('#estimate').hide();
      $('#approval').html("사용완료");
    } else if (list.wssApproval == 'R') {
      // 승인반려
      $('#estimate').hide();
      $('#approval').html("반려 또는 예약취소<br /><button type=\"button\" class=\"btn-line-s btn_default\" data-layer=\"approval01\">사유보기</button>");
    }
      $('#reservCode').html(list.wssReservCode);
      $('#regDt').html(list.wssRegDt);
      $('#wsName').html(list.wsName);
      if (list.wssStDay == list.wssEdDay) {
        $('#reservDt').html(list.wssStDay);
      } else {
        $('#reservDt').html(list.wssStDay+" - "+list.wssEdDay);
      }
      $('#compName').html(list.compName);
      $('#compLicense').html(list.compLicense);
      $('#memName').html(list.wssReservName);
      $('#memDept').html(list.memDept);
      $('#memPhone').html(list.memPhone);
      $('#compPhone').html(list.compPhone);
      $('#memEmail').html(list.memEmail);
      $('#acctName').html(list.compAcctName);
      $('#acctDept').html(list.compAcctDept);
      $('#acctEmail').html(list.compAcctEmail);
      $('#compAcctPhone').html(list.compAcctPhone);

      $('#reservedCode').html(list.wssReservCode);
      $('#reservedDate').html(list.wssStDay + " ~ " + list.wssEdDay);
      $('#kWsName').html(list.wsName);
      var diff = moment(list.wssEdDay).diff(moment(list.wssStDay), "days");
      diff = diff + 1;
      $('#useTime').html(diff+"일");
      $('#useTime2').html(diff+"일");

      $('#kMoney').html(comma(list.wsPrice * diff));
      $('#discount').html(list.dcCount+"%");
      var test = parseInt(list.wsPrice) * diff;
      var discountMoney;
      if (list.dcCount != 0) {
        discountMoney = test-(test*(list.dcCount/100));
      } else {
        discountMoney = test;
      }

      $('#Ktotal').html(comma(discountMoney));

      var addMoney = discountMoney * 0.1;
      var total = discountMoney + addMoney;
      $('#money').html(comma(discountMoney));
      $('#addMoney').html(comma(addMoney));
      $('#total').html(comma(total));


      $('#today').html(moment().format('YYYY년 MM월 DD일'));
    }

    function cancel() {
      var reservCode = getParam().reservCode;
      var param = {
        wssReservCode: reservCode,
      };
      return;
      postAjax("/user/myPageShop/cancel", param, "cancelAlert", null, null, null);
    }
    function cancelAlert(list) {
    alert("취소되었습니다.");
    location.href = '/user/trReserve/myPage'
    }
</script>

<!-- container -->
<div id="container">
    <!-- visual -->
    <div class="visual_sub mypage"></div>
    <!-- //visual -->
    <!-- content -->
    <div class="content">
        <!-- breadcrumb -->
        <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>마이페이지</span><span>예약 및 이용내역</span>
        </div>
        <!-- //breadcrumb -->
        <!-- title -->
        <h2 class="title">예약 및 이용내역</h2>
        <!-- //title -->

        <!-- 예약정보 -->
        <h3 class="stitle">예약정보
            <button id="estimate" type="button" class="btn-line btn_gray" data-layer="estimate">견적서 출력</button>
        </h3>
        <!-- table list -->
        <section class="tbl_wrap_list m-t-15">
            <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                <caption>테이블</caption>
                <colgroup>
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                </colgroup>
                <thead>
                <tr>
                    <th scope="col">예약번호</th>
                    <th scope="col">접수일자</th>
                    <th scope="col">유형</th>
                    <th scope="col">항목</th>
                    <th scope="col">예약일시</th>
                    <th scope="col">상태</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td id="reservCode"></td>
                    <td id="regDt"></td>
                    <td>부대시설</td>
                    <td id="wsName"></td>
                    <td id="reservDt"></td>
                    <td id="approval"></td>
                </tr>
                <!-- <tr class="tr_nodata">
                <td colspan="7">조회된 데이터가 없습니다.</td>
            </tr> -->
                </tbody>
            </table>
        </section>
        <!-- //table list -->
        <!-- //예약정보 -->

        <!-- 예약 신청자 및 회계 담당자 정보 -->
        <h3 class="stitle m-t-30">예약 신청자 및 회계 담당자 정보</h3>
        <!-- table_view -->
        <section class="tbl_wrap_view m-t-10">
            <table class="tbl_view01" summary="테이블입니다.">
                <caption>테이블입니다.</caption>
                <colgroup>
                    <col width="180px;" />
                    <col width="421px" />
                    <col width="180px;" />
                    <col width="421px" />
                </colgroup>
                <tr>
                    <th scope="row">회사명</th>
                    <td id="compName"><input id="compCode" type="hidden"><%=memberDto.getCompName()%></td>
                    <th>사업자등록번호</th>
                    <td id="compLicense"><%=memberDto.getCompLicense()%></td>
                </tr>
                <tr>
                    <th scope="row">신청자</th>
                    <td id="memName"><%=memberDto.getMemName()%></td>
                    <th>부서</th>
                    <td id="memDept"><%=memberDto.getMemDept()%></td>
                </tr>
                <tr>
                    <th scope="row">휴대폰 번호</th>
                    <td id="memPhone"><%=memberDto.getMemPhone()%></td>
                    <th>전화번호</th>
                    <td id="compPhone"><%=memberDto.getCompPhone()%></td>
                </tr>
                <tr>
                    <th scope="row">이메일 주소</th>
                    <td colspan="3" id="memEmail"><%=memberDto.getMemEmail()%></td>
                </tr>
                <tr>
                    <th scope="row">회계담당자</th>
                    <td id="acctName"><%=memberDto.getCompAcctName()%></td>
                    <th>부서</th>
                    <td id="acctDept"><%=memberDto.getCompAcctDept()%></td>
                </tr>
                <tr>
                    <th scope="row">이메일 주소</th>
                    <td id="acctEmail"><%=memberDto.getCompAcctEmail()%></td>
                    <th>전화번호</th>
                    <td id="compAcctPhone"><%=memberDto.getCompAcctPhone()%></td>
                </tr>
            </table>
        </section>
        <!-- //table_view -->
        <!-- //예약 신청자 및 회계 담당자 정보 -->
        <!-- button -->
        <section class="tac m-t-50">
            <button type="button" class="btn btn_gray" onclick="history.back()">목록</button>
            <!-- <button type="button" class="btn btn_default">확인</button> -->
        </section>
        <!-- //button -->
    </div>
    <!-- //content -->
</div>
<!-- //container -->

<!-- popup_Alert -->
<div class="ly_group">
    <article class="layer_Alert cancel_info">
        <!-- # 타이틀 # -->
        <!-- <h1></h1> -->
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            예약취소시 위약금이 발생합니다.<br /><br />
            <section class="tac color_red">- 7일이전 : 위약금 없음<br />- 7일 ~ 3일전 : 예약내역의 50%<br />- 2일전~ 시험당일 : 예약내역 100%</section>
            <br />예약을 취소하시겠습니까?
        </div>
        <!-- 버튼 -->
        <div class="wrap_btn01">
            <button type="button" class="btn-pop btn_gray lyClose m-r-11">취소</button>
            <button type="button" class="btn-pop btn_default lyClose" onclick="cancel()">확인</button>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_Alert -->

<!-- popup_m -->
<div class="ly_group">
    <article class="layer_m approval01">
        <!-- # 타이틀 # -->
        <h1>심사결과 안내</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <div class="info_text02">
                <p>신청하신 정보에 대해 담당자 검토 결과<br />예약 승인이 거절되었습니다.</p>
                <p>[반려사유]<br />선택하신 시험로에 대한 적합한 운전자가 없습니다.</p>
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

<!-- popup_xxl -->
<div class="ly_group">
    <article class="layer_xxl estimate">
        <!-- # 타이틀 # -->
        <h1>견적서 보기</h1>
        <!-- # 컨텐츠 # -->
        <div class="ly_con">
            <h2>주행 시험장 수수료 견적서<button type="button" class="btn-line btn_gray">인쇄</button></h2>
            <section class="m-t-59">
                <div class="col">
                    <h3 class="stitle">공급자 정보</h3>
                    <!-- table_view -->
                    <div class="tbl_wrap_view m-t-10">
                        <table class="tbl_view01" summary="테이블입니다.">
                            <caption>테이블입니다.</caption>
                            <colgroup>
                                <col width="140px;" />
                                <col width="" />
                            </colgroup>
                            <tr>
                                <th scope="row">상호</th>
                                <td>네오자동차</td>
                            </tr>
                            <tr>
                                <th scope="row">주소</th>
                                <td>(88989)경기도 성남시 분당구 판교로<br />255번길 한국타이어</td>
                            </tr>
                            <tr>
                                <th scope="row">담당자</th>
                                <td>김운전 대리</td>
                            </tr>
                            <tr>
                                <th scope="row">전화번호</th>
                                <td>02-1234-5678</td>
                            </tr>
                            <tr>
                                <th scope="row">휴대전화</th>
                                <td>010-1234-5678</td>
                            </tr>
                            <tr>
                                <th scope="row">팩스</th>
                                <td>02-1234-5678</td>
                            </tr>
                            <tr>
                                <th scope="row">이메일 주소</th>
                                <td>aaaaa@aaaaa.com</td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_view -->
                </div>
                <div class="col m-l-30">
                    <h3 class="stitle">이용자 정보</h3>
                    <!-- table_view -->
                    <div class="tbl_wrap_view m-t-10">
                        <table class="tbl_view01" summary="테이블입니다.">
                            <caption>테이블입니다.</caption>
                            <colgroup>
                                <col width="140px;" />
                                <col width="" />
                            </colgroup>
                            <tr>
                                <th scope="row">상호</th>
                                <td><%=memberDto.getCompName()%></td>
                            </tr>
                            <tr>
                                <th scope="row">주소</th>
                                <td><%=memberDto.getCompAddr()%><br><%=memberDto.getCompAddrDetail()%></td>
                            </tr>
                            <tr>
                                <th scope="row">담당자</th>
                                <td><%=memberDto.getMemName()%></td>
                            </tr>
                            <tr>
                                <th scope="row">전화번호</th>
                                <td><%=memberDto.getCompPhone()%></td>
                            </tr>
                            <tr>
                                <th scope="row">휴대전화</th>
                                <td><%=memberDto.getMemPhone()%></td>
                            </tr>
                            <tr>
                                <th scope="row">이메일 주소</th>
                                <td><%=memberDto.getMemEmail()%></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_view -->
                </div>
            </section>
            <h3 class="stitle m-t-30">예약 정보<span class="info_ment">부가세 10% 별도</span></h3>
            <!-- table list -->
            <section class="tbl_wrap_list m-t-10">
                <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                    <caption>테이블</caption>
                    <colgroup>
                        <col width="" />
                        <col width="" />
                        <col width="" />
                        <col width="" />
                        <col width="" />
                        <col width="" />
                        <col width="" />
                        <col width="" />
                        <col width="" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col">예약번호</th>
                        <th scope="col">예약일시</th>
                        <th scope="col">유형</th>
                        <th scope="col">항목</th>
                        <th scope="col">예약시간</th>
                        <th scope="col">적용시간</th>
                        <th scope="col">공급금액</th>
                        <th scope="col">할인율</th>
                        <th scope="col">합계</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td id="reservedCode">2020010101</td>
                        <td id="reservedDate">2021.09.02 13:00~17:00</td>
                        <td>부대시설</td>
                        <td id="kWsName">고속주회로</td>
                        <td id="useTime"></td>
                        <td id="useTime2"></td>
                        <td class="tar" id="kMoney">300,000</td>
                        <td class="tar" id="discount">0%</td>
                        <td class="tar" id="Ktotal">270,000</td>
                    </tr>
                    </tbody>
                </table>
            </section>
            <!-- //table list -->
            <section class="m-t-50 h122">
                <!-- table_view -->
                <div class="tbl_wrap_view w398 fr">
                    <table class="tbl_view01" summary="테이블입니다.">
                        <caption>테이블입니다.</caption>
                        <colgroup>
                            <col width="150px;" />
                            <col width="" />
                        </colgroup>
                        <tr>
                            <th scope="row">공급금액 합계</th>
                            <td class="tar" id="money"></td>
                        </tr>
                        <tr>
                            <th scope="row">부가세 (10%)</th>
                            <td class="tar" id="addMoney"></td>
                        </tr>
                        <tr>
                            <th scope="row">합계</th>
                            <td class="tar" id="total"></td>
                        </tr>
                    </table>
                </div>
                <!-- //table_view -->
            </section>
            <section class="text_estimate m-t-57">
                <p id="today">2021년 8월 11일</p>
                <p>상기와 같이 견적합니다.</p>
            </section>
            <section class="footer_estimate m-t-45">
                <span class="info_ment_orange m-t-6">상기 견적내용은 참고용이며, 공식문서로 사용될 수 없습니다.</span>
                <img src="/inc/images/ci_hankook_estimate.png" alt="Hankook" />
            </section>
        </div>
        <!-- # 닫기버튼 # -->
        <button data-fn="lyClose">레이어닫기</button>
    </article>
</div>
<!-- //popup_xxl -->

<%@ include file="/WEB-INF/views/jsp/common/footer.jsp" %>