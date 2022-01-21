package com.hankook.pg.content.admin.shop.vo;

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
public class ShopVo {
  private String wsCode;
  private String wsUseYn;
  private Integer wsPrice;
  private String wsName;
  private Integer num;

  private String user;

}
