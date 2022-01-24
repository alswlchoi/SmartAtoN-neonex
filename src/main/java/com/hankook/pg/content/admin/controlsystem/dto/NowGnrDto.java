package com.hankook.pg.content.admin.controlsystem.dto;

import lombok.Data;

@Data
public class NowGnrDto { 
	private String inTime;			//입차시간
	private String outTime;			//출차시간
	private Integer tcSeq;			//예약일련번호
	private String tcReservCode;	//예약코드
	private String tNickName;		//트랙명
	private String tagId;			//운전자 RFID
	private String carTagId;		//차량 RFID
	private String compName;		//약어
	private String dName;			//운전자명
	private String dLevel;			//운전자레벨
	private String wCh;				//무전기채널
	private String cCode;			//차량코드
	private String cVender;			//차량제조사
	private String cName;			//차량모델명
	private String cNumber;			//차량번호
	private String cColor;			//차량색상
	private String cType;			//차량타입(S-특수차량)
}