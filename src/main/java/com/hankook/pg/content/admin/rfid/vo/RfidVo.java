package com.hankook.pg.content.admin.rfid.vo;

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
public class RfidVo  extends Search {

  private int num;
  private String rId;
  private String rSerial;
  private String rName;
  private String rStatus;
  private String rInOut;
  private String rLevel;
  private String rQrId;
  private String rTagId;
  private String rUseYn;
  private String rDenied;
  private String rOutCode;
  private String rReason;
}
