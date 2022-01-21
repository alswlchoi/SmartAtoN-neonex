package com.hankook.pg.content.admin.notice.dto;
import lombok.*;

@Data
public class UpfilesDto {
	private int fSeq;
	private String fType;
	private int fGroup;
	private String fName;
	private String fUrl;
    private String fRegDt;
}