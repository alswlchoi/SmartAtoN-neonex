package com.hankook.pg.content.login.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
public class AuthMenuDto {

    @ApiModelProperty(notes = "권한", position = 0)
    private String role;

    @ApiModelProperty(notes = "메뉴 코드", position = 1)
    private String menuCode;

    @ApiModelProperty(notes = "대분류 메뉴 코드", position = 2)
    private String lclasMenuCode;

    @ApiModelProperty(notes = "대분류 메뉴 이름", position = 3)
    private String lclasMenuName;

    @ApiModelProperty(notes = "메뉴 이름", position = 4)
    private String menuName;

}
