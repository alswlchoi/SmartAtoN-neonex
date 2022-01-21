package com.hankook.pg.content.login.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.NotNull;

@Data
public class LoginDto {

    @ApiModelProperty(notes = "아이디", position = 0)
    @NotNull
    private String id;

    @ApiModelProperty(notes = "비밀번호", position = 1)
    @NotNull
    private String password;

    @ApiModelProperty(notes = "접속자IP", position = 2)
    private String ip;
}
