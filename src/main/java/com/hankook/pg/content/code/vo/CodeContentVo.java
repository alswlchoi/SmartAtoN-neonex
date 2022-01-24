package com.hankook.pg.content.code.vo;


import com.hankook.pg.share.Search;

import lombok.Data;

@Data
public class CodeContentVo extends Search {
  private int num;
  private Long cSeq;
  private String cParent;
  private String cId;
  private String cName;
  private String cValue;
  private String cType;
  private Long cOrder;  
}
