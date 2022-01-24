package com.hankook.pg.content.admin.reservedManage.vo;

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
public class ReservedManageVo extends Search {
  private int num;

  private int wssSeq;
  private String wssReservCode;
  private String wssReservDay;
  private String wssRegDt;
  private String wssStDay;
  private String wssEdDay;
  private String compCode;
  private String compName;
  private String wsName;
  private String blackList;

  private String wssApproval;
  private String wssMemo;
  private String wssModUser;
  private String wssModDt;

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
}
