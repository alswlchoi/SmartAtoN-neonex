package com.hankook.pg.content.admin.tire.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

import javax.validation.constraints.NotNull;

@Getter
@AllArgsConstructor
public class InsertWheelDataDto {
    @NotNull
    private String tmSeq;
    @NotNull
    private String wheelList;
}
