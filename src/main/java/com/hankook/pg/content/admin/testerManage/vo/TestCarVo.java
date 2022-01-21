package com.hankook.pg.content.admin.testerManage.vo;

import com.hankook.pg.share.Search;
import java.util.Date;
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
public class TestCarVo extends Search {

  private int num;

  private int rmSeq;
  private String rmType;
  private String cCode;
  private String cNumber;
  private String mngFg;
  private Date crnDtm;
  private Date udtDtm;

  private String tcReservCode;
  private String tcDay;
  private String tcDay2;

  private String rId;
  private String rmRYn;
  private String rmRModDt;

  private String rQrId;
  private String wQrId;
  private String inOut;
}
