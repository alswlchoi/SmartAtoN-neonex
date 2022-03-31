package com.hankook.pg.content.admin.dccp.vo;

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
public class DccpVo extends Search {
  private int num;
  private String tcReservCode;
  private String compName;
  private String dSeq;
  private String dName;

  private int dcSeq;
  private String etc;
  private String temp;
  private String bloodPres;
  private String alcol;
  private String sTemp;
  private String sBloodPres;
  private String sAlcol;
  private String regUser;
  private String regDt;

  private String nDccpYn;
  private int dup;
}
