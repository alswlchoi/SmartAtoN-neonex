package com.hankook.pg.content.user.myPageShop.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MyPageShopVo {
  private String compCode; // 회사코드
  private String wssStDay; // 예약시작날짜
  private String wssEdDay; // 예약끝날짜
  private String wssReservName; // 신청자명
  private String wssApproval; // 승인상태
  private String wssReservCode; // 예약코드
  private String wsCode; // 항목코드
  private long wsPrice; // 가격
  private String wssRegDt;

  private String wsName; // 항목명

  private String memId; // 접속자 아이디

  private String memDept; // 부서
  private String memPhone; // 휴대폰번호
  private String memEmail; // 신청자 이메일

  private String compName; // 회사이름
  private String compLicense; // 사업자번호
  private String compPhone; // 회사전화번호
  private String compAcctName; // 회계담당자
  private String compAcctDept; // 회계담장자부서
  private String compAcctEmail; // 회계담당자이메일
  private String compAcctPhone; // 회계담당자전화번호

  private String dcCount; // 할인률
}
