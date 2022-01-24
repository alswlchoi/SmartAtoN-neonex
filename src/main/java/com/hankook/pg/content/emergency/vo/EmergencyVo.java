package com.hankook.pg.content.emergency.vo;

import com.hankook.pg.share.Search;

import lombok.Data;

@Data
public class EmergencyVo extends Search{
	private static final long serialVersionUID = 1L;

	private String emergencyCode;
	private String emergencyId;
	private String emergencyValue;
	private String rnum;
}
