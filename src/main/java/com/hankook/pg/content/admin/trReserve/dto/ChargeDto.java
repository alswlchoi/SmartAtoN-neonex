package com.hankook.pg.content.admin.trReserve.dto;

import com.hankook.pg.share.Search;

import lombok.Data;

@Data
public class ChargeDto extends Search{
	//정산관리(영훈)
	private int num;//시퀀스
	private String wssModDt;//취소일시
	private String wssStDay;//예약 시작일
	private String wssEdDay;//예약 종료일
	private String blackList;//블랙리스트 여부
	private String compRegDt;//등록날짜
	private String wsName;//워크샵명
	private String wsUseYn;
	private String wssReservCode;//정산관리 예약번호
	private String compLicense; //사업자 번호
	private String memName;	    //예약자 회원명
	private String memDept;		 //예약자 부서
	private String memPhone;	 //예약자 전번
	private String memEmail;	 //예약자 이메일
	private String compAcctName; //회계 이름
	private String compAcctDept; //회계 부서
	private String compAcctEmail; //회계 이메일
	private String compAcctPhone; //회계 전번
	private String compCode;
	private String compName;		//회사명
	private String tcReservCode; //시험로 예약번호
	private String tcRegDt; //시험로접수일자
	private String tcDay;
	private String tcDay2; 
	private String trTrackType;
	private String trTrackName;
	private String tcApproval;
	private String tcApproval1;
	private String tcModDt;
	private String wsPrice; //부대시설 1박가격
	private String dcCount; //할인률
	private String wssApproval;//부대시설 승인상태
	private String wssRegDt;//부대시설 접수일자
	private String orderName1;		//정렬컬럼
    private String orderKind1;		//정렬종류
    private String orderName2;
    private String orderKind2;
    private String text;
    private String cColor;		//차 색상
    private String cNumber;	//차 번호
    private String cName;		//차 종류
    private String tcPurpose;	//목적
    private String dName;		//운전자 이름
    private String carTagId;	//차량RFID
    private String inTime;		//출입시간
    private String outTime; 	//출입시간
    private String tName;		//트랙이름
    private String tDay; 		//매핑 날짜
    private String tcSeq;		//매핑할때
    private String pPay; 		//정산금액
    private String pDiscount;	//정산 할인율
    private String rmType;		//
    private String hours;		//소요시간
    private String price;		//부가세
    private String tId;			//정산 트랙아이디
    private String pUseTime;	//실사용시간
    private String pApplyTime;	//적용시간
    private int pProductPay; //트랙별요금(공급금액)
    private String pReservCode; //정산 쿼리때 사용
    private String tcStep;		//정산완료
    private String stDate;
    private String edDate;
    private String wssApproval4;
    private String wssApproval1;
    private int diffTime;
    private String cType;
    private String tNickname;
    private String day;
    private String wssReservDay;
}
