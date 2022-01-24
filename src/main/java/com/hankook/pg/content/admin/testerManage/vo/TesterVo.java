package com.hankook.pg.content.admin.testerManage.vo;

import com.hankook.pg.share.Search;
import java.util.Date;
import java.util.List;
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
public class TesterVo extends Search {

  private int num;
  private String tcRegDt;

  private String tcReservCode;
  private String trTrackType;
  private int tcSeq;
  private String tcDay;
  private String tcDay2;
  private String trTrackName;
  private String compName;
  private String dName;
  private String nDccpYN;
  private String dEdu;
  private String dEduEndDt;
  private String dLevel;
  private String rId;
  private String wId;
  private String rmWCh;
  private String rmType;

  private String dSeq;
  private String employeeNo;
  private Date crnDtm;
  private String rReturn;
  private String wReturn;

  private String rmRYn;
  private String rmWYn;
  private String rmRModDt;
  private String rmWModDt;

  private int dup;

  private String rQrId;
  private String wQrId;
  private String inOut;
  private String date;
  private List<TestCarVo> car;

  private String bRfid;
  private String bWiress;

}
