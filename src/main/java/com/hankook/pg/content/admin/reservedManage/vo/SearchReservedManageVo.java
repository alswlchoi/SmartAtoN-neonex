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
public class SearchReservedManageVo extends Search {

  private String text;
  private String stDate;
  private String edDate;
  private String select;
  private String wssApproval1;
  private String wssApproval2;

  private String orderName1;
  private String orderName2;
  private String orderKind1;
  private String orderKind2;
}
