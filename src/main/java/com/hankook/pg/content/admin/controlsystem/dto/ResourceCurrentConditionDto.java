package com.hankook.pg.content.admin.controlsystem.dto;

import lombok.Data;

@Data
public class ResourceCurrentConditionDto { 
	private String tId;			//트랙아이디
	private Integer tcSeq;		//예약일련번호
	private String compCode;	//회사코드
	private String compName;	//약어
	private String inTime;		//입차시간
	private String tagId;		//운전자 tagId
	private String carTagId;	//차량 tagId
	private String driverInfo;	//운전자정보(운전자명, 무전기채널)
	private String carInfo;		//차량제조사와 이름
}