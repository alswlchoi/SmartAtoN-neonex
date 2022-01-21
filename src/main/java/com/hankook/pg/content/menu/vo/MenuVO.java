package com.hankook.pg.content.menu.vo;

import lombok.Data;

@Data
public class MenuVO {
	private static final long serialVersionUID = 1L;

	//메뉴코드
	private String menuCode;
	//메뉴이름
	private String mName;
	//상위메뉴
	private String mParent;
	//메뉴순서
	private String mOrder;
	//url
	private String mUrl;
	//메뉴레벨
	private int mLevel;
	//메뉴 사용유무
	private String mUseYn;
	//등록일
	private String mRegDt;
	//수정일
	private String mModDt;

	//권한코드
	private String authCode;
	//권한명
	private String authNm;

	//view chklist
	private String[] chkArr;
}
