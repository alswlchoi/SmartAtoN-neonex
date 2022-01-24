package com.hankook.pg.content.admin.controlsystem.dto;

import lombok.Data;

@Data
public class TrackDto { 
	private String Id;			//트랙아이디
	private String nick;		//약어
	private Integer cnt;		//현재
	private Integer max;		//최대
	private String tId;			//시험로코드
	private String openClose;	 //개폐종류
	private String inOut;		//출입종류
}