package com.hankook.pg.content.admin.company.dto;

import javax.validation.constraints.NotBlank;

import lombok.Data;

@Data
public class CompanyDto {
    @NotBlank(message = "회사코드는 필수 항목입니다. ")
	private String compCode; 
    @NotBlank(message = "사업자번호는 필수 항목입니다. ")
	private String compLicense;
    @NotBlank(message = "전화번호는 필수 항목입니다. ")
	private String compPhone; 
	private String compLicenseFile;
    private String compFax;
    private String compKind;
    private String compAddr;
    private String compPostNo;
    private String compAddrDetail;
    private String compName;
    private String compCond;
    private String compAcctName;
    private String compAcctPhone;
    private String compAcctDept;
    private String compAcctEmail;
    private String blackList;
    private String compMemo;
    private String compRegUser;
    private String compRegDt;
    
    //할인율 관련
    private Integer dcSeq;
    private String dcCount;
    private String dcName;
    private String dcRegUser;
    private String dcRegDt;
    private String dcModUser;
    private String dcModDt;
    
	//회원 ID
	private String memId;
	//회원 이름
    private String memName;
    //회원 PWD
    private String memPwd;
    //전화번호
    private String memPhone;
    //이메일
    private String memEmail;
    //회원 유저 타입
    private String memUserType;
    //사용여부
    private String memUseYn;
    //생년월일 ex)19930113
    private String memBirth;
    //부서명
    private String memDept;
    //가입목적
    private String memPurpose;
    //회원 권한
    private String authCode;
    //회원 주소
    private String memAddr;
    //우편번호
    private String memPostNo;
    //상세주소
    private String memAddrDetail;
    //멤버승인
    private String memApproval;
    //약관동의
    private String memAgreement;
    //등록일 14
    private String memRegDt;
    //수정일 14
    private String memModDt;
    //등록자
    private String memModUser;
    //수정자
    private String memRegUser;
}
