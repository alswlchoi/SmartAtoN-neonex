package com.hankook.pg.content.login.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.NotNull;

@Data
public class LogoutDto {

    @ApiModelProperty(notes = "아이디", position = 0)
    @NotNull
    private String id;

}
