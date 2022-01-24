package com.hankook.pg.content.admin.controlsystem.dto;

import lombok.Data;

@Data
public class TalkDto { 
	private String[] phoneArr;		//수신번호(배열)
	private String callback;		//발신자 번호
	private String msg;				//송출메세지
}