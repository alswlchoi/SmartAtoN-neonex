package com.hankook.pg.content.admin.trReserve.dto;

import lombok.Data;

@Data
public class TrRfidGnrDto {
	private Integer prgNo;
	private Integer tcSeq;
	private String insertFlug;
	private String inTime;
	private String outTime;
	private String inOut;
	private String tcDay;
	private String tcReservCode;
	private String compName;
	private String cCode;
	private Integer dSeq;
	private String dName;
	private String dLevel;
	private String wCh;
	private String tagId;
	private String carRfidId;
}