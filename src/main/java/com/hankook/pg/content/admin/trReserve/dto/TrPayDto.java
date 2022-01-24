package com.hankook.pg.content.admin.trReserve.dto;

import lombok.Data;

@Data
public class TrPayDto {
//    @NotBlank(message = "정산일련번호는 필수 항목입니다. ")
	private Integer pSeq;
    private String compCode;
    private String pType;
    private String pReservCode;
    private String pDay;
    private String pReason;
    private String tId;
    private Integer pUseTime;
    private Integer pApplyTime;
    private String pDiscount;
    private Integer pProductPay;
    private String pPay;
    private String pCancelPercent;
    private String pPayType;
    private String cCode;
    private Integer carCnt;
}