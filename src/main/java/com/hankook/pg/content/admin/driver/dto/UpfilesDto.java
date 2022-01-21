package com.hankook.pg.content.admin.driver.dto;
import lombok.*;

@Data
public class UpfilesDto {
	private int fSeq;
	private String fType;	//n : 공지사항, s : 자료실, d : 면허증, a : 동의서, c : 사업자등록증
	private long fGroup;
	private String fName;
	private String fUrl;
    private String fRegDt;
}