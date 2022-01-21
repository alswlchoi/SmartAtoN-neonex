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
public class SearchRfidVo extends Search {
  private String text;
  private String yes;
  private String no;
  private String lost;
  private String inOut;
}
