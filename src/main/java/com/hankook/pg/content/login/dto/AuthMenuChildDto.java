package com.hankook.pg.content.login.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
public class AuthMenuChildDto {

    @ApiModelProperty(notes = "상위 메뉴 ID", position = 0)
    private String upMenuId;

    @ApiModelProperty(notes = "상위 메뉴 이름", position = 1)
    private String upMenuNm;

    @ApiModelProperty(notes = "하위 메뉴 ID", position = 2)
    private String menuId;

    @ApiModelProperty(notes = "하위 메뉴 이름", position = 3)
    private String menuNm;

    @ApiModelProperty(notes = "접속시작IP", position = 4)
    private String accessStartIp;

    @ApiModelProperty(notes = "접속종료IP", position = 5)
    private String accessEndIp;
}
