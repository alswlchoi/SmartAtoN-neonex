package com.hankook.pg.content.memHistory.vo;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MemHistoryVo {

  private Long hSeq;
  private String memId;
  private String memName;
  private String connectTime;
}
