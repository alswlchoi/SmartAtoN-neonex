package com.hankook.pg.content.code.vo;

import lombok.Data;

@Data
public class CodeVo {

  private Long cSeq;
  private String cParent;
  private String cId;
  private String cName;
  private String cValue;
  private String cType;
  private Long cOrder;
}
