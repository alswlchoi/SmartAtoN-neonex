package com.hankook.pg.content.user.myPageCalculate.vo;

import lombok.Data;

@Data
public class CalToPay{
	private String tcReservCode;
	private String tcDay;
	private String inTime;
	private String outTime;
	private String tagId;
	private int diffTime;
	private String tId;
	private String trTrackType;
	private String trTrackCode;
	private String trTrackName;
	private String trTrackNickname;
	private int trPrice;
	private int trPriceAdd;
	private int trPriceSolo;
	private String compCode;
	private String compName;
	private String dcCount;
}
