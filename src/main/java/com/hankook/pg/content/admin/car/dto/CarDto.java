package com.hankook.pg.content.admin.car.dto;

import javax.validation.constraints.NotBlank;

import lombok.Data;

@Data
public class CarDto {
    @NotBlank(message = "일련번호는 필수 항목입니다. ")
	private String cCode; 
    @NotBlank(message = "차량번호는 필수 항목입니다. ")
	private String cNumber; 
    @NotBlank(message = "차량종류는 필수 항목입니다. ") 
    private String cVender;
	private String cType;		//S : 특수차량, N : 일반차량 
    private String cName; 
    private String cColor;
    private String rId;			//RFID
	private Integer tcSeq;		//예약 일련번호
    private String tcDay;		//검정일
}