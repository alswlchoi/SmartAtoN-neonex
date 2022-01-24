package com.hankook.pg.content.user.trReserve.vo;

import com.hankook.pg.share.Search;
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
public class MyPageVo extends Search {
  // 검색시 사용
  private String text;
  private String sApproval; // shop approval
  private String tApproval; // track approval
  private String stDate;
  private String edDate;

  private int seq;
  private String reservCode;
  private String regDt;
  private String type;
  private String wsCode;
  private String name;
  private String approval;
  private String step;
  private String stDt;
  private String edDt;
  private String reason;

  private String purpose;
  private int diff;

  private String regUser;

  // userInfo
  private String compCode;
  private String compName;
  private String blackList;
  private String compLicense;
  private String memName;
  private String memDept;
  private String memPhone;
  private String memCompPhone;
  private String memEmail;
  private String compAcctName;
  private String compAcctDept;
  private String compAcctEmail;
  private String compAcctPhone;

  // getDriver
  private String dSeq;
  private String dName;
  private String dLevel;
  // getCar
  private String cCode;
  private String cName;
  private String cColor;
  private String cNumber;

  // 취소
  private int pPay;
  private String tId;
  private String trTrackType;
  private int pApplyTime;
  private int pProductPay;
  private String pCancel;
  private int realDate;
  private String discount;

  private String chkDt;
  private String wssReservDay;

}
