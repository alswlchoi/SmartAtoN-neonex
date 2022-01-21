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
public class HintTesterVo extends Search {

  private int num;
  private int rmSeq;

  /**
   * HINT 평가자 관련
   */
  private String employeeNo;
  private String deptName;
  private String name;
  private String dName;

  /**
   * HINT 평가차량 관련
   */
  private String vhclCode;
  private String vhclRgsno;
  private String vhclMaker;

  /**
   * HINT 공통
   */
  private int hrSeq;
  private Date crnDtm;
  private String hrType; // RFID/무전기 구분
  private String bRId; // 교체 이전 RFID ID
  private String rId;
  private String rQrId;
  private String bWId; // 교체 이전 무전기 ID
  private String wId;
  private String wCh;
  private String wQrId;
  private String rReturn;
  private String wReturn;
  private String inOut; // 발급 여부
  private String car; // RFID DENIED 때문에 차/운전자 구분 필요

  private String tcDay;

  private int tcSeq;
  private String dSeq;
  private String date;

}
