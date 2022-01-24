package com.hankook.pg.content.admin.testerManage.vo;

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
public class SearchTesterVo extends Search {

  private String text;
  private String testDate;
  private String stDate;
  private String edDate;
  private String type;
  private String enText;
}
