package com.hankook.pg.content.login.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class AuthMenuFormatDto {

    @ApiModelProperty(notes = "메뉴 ID", position = 0)
    private String menuId;

    @ApiModelProperty(notes = "메뉴 이름", position = 1)
    private String menuNm;

    @ApiModelProperty(notes = "하위메뉴", position = 2)
    private List<AuthMenuChildDto> children = new ArrayList<>();

}
