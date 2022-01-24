package com.hankook.pg.content.user.userShop.vo;

import java.util.ArrayList;
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
public class UserShopVo {
  private String wssSeq;
  private String compCode;
  private String wssStDay;
  private String wssEdDay;
  private String wssReservDay;
  private String wssReservName;
  private String wssApproval;
  private String wssMemo;
  private String wssReservCode;
  private String wsCode;
  private long wsPrice;
  private String wssRegUser;
  private String wssRegDt;

  private String wsName;

  private String memId;
  private String memNm;

  private String memPhone;
  private String memEmail;

  private String compName;
  private String compPhone;
  private String compAcctName;
  private String compAcctDept;
  private String compAcctEmail;
  private String compAcctPhone;

  private String doKind;
  private String wdKind;

  private String applyDate;
  private ArrayList dates;
  private int applyCnt;
  private int reservedCnt;

}
