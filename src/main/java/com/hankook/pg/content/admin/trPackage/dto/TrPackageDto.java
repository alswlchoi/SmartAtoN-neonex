package com.hankook.pg.content.admin.trPackage.dto;

import javax.validation.constraints.NotBlank;

import lombok.Data;

@Data
public class TrPackageDto {

    @NotBlank(message = "트랙패키지아이디는 필수 항목입니다. ")
	private String tpId;
	private String tpName; 
	private String tId;
}