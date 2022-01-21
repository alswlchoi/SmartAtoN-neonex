package com.hankook.pg.content.company.dto;

import java.io.Serializable;

import javax.validation.constraints.NotBlank;

import lombok.Builder;
import lombok.Data;

@Data
public class CompanyDto implements Serializable {
	private static final long serialVersionUID = 1L;

    @NotBlank(message = "License는 필수 항목입니다. ")
	private String compLicense;
    @NotBlank(message = "compCode는 필수 항목입니다. ")
	private String compCode; 
    @NotBlank(message = "compPhone는 필수 항목입니다. ")
	private String compPhone; 
	private String compTel; 
	private String compRegDt; 
	private String compRegUser;
	
	@Builder
    public CompanyDto(String compLicense,String compCode,String compPhone,String compTel,String compRegDt,String compRegUser) {
    	this.compLicense = compLicense;
    	this.compCode = compCode;
    	this.compPhone = compPhone;
    	this.compTel = compTel;
    	this.compRegDt = compRegDt;
    	this.compRegUser = compRegUser;
    }
}