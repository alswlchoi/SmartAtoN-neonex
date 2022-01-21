package com.hankook.pg.content.admin.company.dto;

import lombok.Data;

@Data
public class DisCountDto {
	private String compCode; 
    private Integer dcSeq;
    private String dcCount;
    private String dcName;
    private String dcRegUser;
    private String dcRegDt;
    private String dcModUser;
    private String dcModDt;
}
