package com.hankook.pg.content.auth.vo;

import lombok.Data;

@Data
public class AuthVO {
	private static final long serialVersionUID = 1L;

	//권한코드
	private String authCode;
	//권한명
	private String authNm;
	//순서
	private int authOrder;

	private int authLevel;
}
