package com.hankook.pg.content.admin.trReserve.dto;

import lombok.Data;

@Data
public class TrRfidDto {
	private Integer rlSeq;			//로그일련번호
	private Integer tcSeq;			//예약일련번호
	private String insertFlug;		//로그일련번호
	private String tId;				//트랙아이디
	private String tName;			//트랙명
	private String tcDay;			//입출차날짜
	private String inTime;			//입차시간
	private String outTime;			//출차시간
	private String tagId;			//RFID
	private String carTagId;		//차량 RFID
	private String type;			//입출차아이디
	private String tcReservCode;	//예약번호
	private Integer diffTime;		//사용시간
}