package com.hankook.pg.content.admin.trReserve.dto;

import javax.validation.constraints.NotBlank;

import lombok.Data;

@Data
public class TrackDto {

    @NotBlank(message = "트랙아이디는 필수 항목입니다. ") 
	private String tId;			//트랙아이디
	private String tType;		//트랙타입(예약정보 담을 때 사용(공동, 단독)
	private String tName;		//트랙명
	private Integer tMax;		//트랙케파
	private String tLevel;		//트랙레벨
	private Integer tPrice;		//트랙 가격
	private String ip;			//트랙 IP
	private Integer tPriceAdd;	//트랙 추가요금
	private Integer tSolo;		//단독요금
	private String tUseYn;		// 사용여부
	private Integer num;
	private String tNickName;	//약어
	
	private String tcDay;		//시험일자
	private Integer trSeq;		//일련번호
	private String tcRequestNumber;		//의뢰번호
}