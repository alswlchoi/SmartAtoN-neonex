package com.hankook.pg.content.member.dto;

import lombok.*;

@Setter
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CompanyDto {
	//회사코드
	private String compCode;
	//사업자번호
	private String compLicense;
	//대표전화
	private String compPhone;
	//팩스번호
	private String compFax;
	//업종
	private String compKind;
	//회사 주소
	private String compAddr;
	//회사 우편번호
	private String compPostNo;
	//회사 상세주소
	private String compAddrDetatil;
	//회사명
	private String compName;
	//업종형태
	private String compCond;
	//회계담당자
	private String compAcctName;
	//회계담당자번호
	private String compAcctPhone;
	//블랙리스트여부
	private String blackList;
	//메모
	private String compMemo;
	//등록자
	private String compRegUser;
	//등록날자
	private String compRegDt;
}