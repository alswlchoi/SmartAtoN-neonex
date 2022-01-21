package com.hankook.pg.content.user.myPageCalculate.vo;

import com.hankook.pg.share.Search;

import lombok.Data;

@Data
public class CalVo extends Search{
	private String reservCode;
	private String regDt;
	private String trackType;
	private String track;
	private String startDate;
	private String endDate;
	private String status;
	private String memo;
	private String regUser;

	//입출차내역
	private String inTime;
	private String outTime;
	private String tagId;
	private int diffTime;
	//트랙정보
	private String tId;
	private String tPrice;
	private String tPriceAdd;
	private String tSolo;
}
