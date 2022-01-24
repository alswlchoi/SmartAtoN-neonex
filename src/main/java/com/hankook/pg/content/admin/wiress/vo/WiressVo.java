package com.hankook.pg.content.admin.wiress.vo;

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
public class WiressVo {

  private int num;
  private String wId;
  private String wName;
  private String wStatus;
  private String wSerial;
  private String wUseYn;
  private String wInOut;
  private String wOutCode;
  private String wReason;
  private String wQrId;
}
