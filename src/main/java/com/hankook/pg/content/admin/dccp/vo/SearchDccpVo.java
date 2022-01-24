package com.hankook.pg.content.admin.dccp.vo;

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
public class SearchDccpVo extends Search {

  private String text;
  private String testDate;
  private String enText;
}
