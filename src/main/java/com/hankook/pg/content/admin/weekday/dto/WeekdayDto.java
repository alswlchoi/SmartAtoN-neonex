package com.hankook.pg.content.admin.weekday.dto;

import javax.validation.constraints.NotBlank;

import lombok.Data;

@Data
public class WeekdayDto {

    @NotBlank(message = "일련번호는 필수 항목입니다. ")
	private int wdSeq;
    @NotBlank(message = "종류는 필수 항목입니다. ")
	private String wdKind; 							//p:한국타이어, b:B2B, h:현대자동차
    @NotBlank(message = "시작일은 필수 항목입니다. ")
	private String wdEdDt; 
    @NotBlank(message = "종료일은 필수 항목입니다. ")
	private String wdStDt; 
    @NotBlank(message = "요일정보는 필수 항목입니다. ")
	private String wdDay;
    @NotBlank(message = "실운영시작시간은 필수 항목입니다. ")
	private String wdStHour;
    private String wdStMin;
    @NotBlank(message = "실운영마감시간은 필수 항목입니다. ")
	private String wdEdHour;
    private String wdEdMin;
    @NotBlank(message = "예약가능시작시간은 필수 항목입니다. ")
	private String wdCanStHour;
    private String wdCanStMin;
    @NotBlank(message = "예약가능마감시간은 필수 항목입니다. ")
	private String wdCanEdHour;
    private String wdCanEdMin;
	private String wdRegDt; 
	private String wdRegUser;
	private String wdModDt; 
	private String wdModUser; 
	private String wdCon;		//접수상태(1:정상, 2:중단)

	private String wsName;
	private int num;
}