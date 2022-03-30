package com.hankook.pg.content.admin.trReserve.dto;

import lombok.Data;

@Data
public class ResourceMappingDto {
	private Integer rmSeq;		//리소스일련번호
	private Integer tcSeq;		//시험일련번호
	private String tcDay;		//시험일자
	private String rmType;		//타입 (C:자동차, D:운전자
	private String dSeq;		//운전자코드
	private String cCode;		//자동차코드
	private String rId;			//운전자 RFID 
	private String rmLevel;		//운전자레벨
	private String wId;			//무전기 코드
	private String dName;		//운전자 이름
	private String dEdu;		//운전자 안전교육 여부
	private String rmInOut;		//출입여부
	private String rmRegDt;		//등록일
	private String rmRYn;		
	private String rmWYn;
	private String nDccpYn;
	private String rmRModDt;	
	private String rmWModDt;
	private String rmWCh;		//무전기채널
}