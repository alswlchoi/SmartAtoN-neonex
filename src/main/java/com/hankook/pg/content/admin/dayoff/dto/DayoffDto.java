package com.hankook.pg.content.admin.dayoff.dto;

import javax.validation.constraints.NotBlank;

import lombok.Data;

@Data
public class DayoffDto {
	private Integer doSeq;
    @NotBlank(message = "시작일는 필수 항목입니다. ")
    private String doStDay;
    @NotBlank(message = "마감일는 필수 항목입니다. ")
    private String doEdDay;
    private String doName;
    private String doKind;
}