package com.hankook.pg.content.admin.trReserve.dto;

import java.util.List;

import javax.validation.constraints.NotBlank;

import com.hankook.pg.content.admin.car.dto.CarDto;

import lombok.Data;

@Data
public class TrReserveDto {
    @NotBlank(message = "시험일정순번은 필수 항목입니다. ")
	private Integer tcSeq;
    @NotBlank(message = "시험날짜는 필수 항목입니다. ")
	private String tcDay;			//시험일자(시작일)
    private String tcDay2;			//시험일자(마감일)
	private String beforeTcDay;		//시험일자(수정전 시작일)
    private String beforeTcDay2;	//시험일자(수정전 마감일)
    private String tempDay;			//임시날짜(기간변경시 기존데이터 삭제전 tcDay 임시저장)
	private String compCode;		//회사코드
    private String blackList;		//회사코드
	private String compName;		//회사명
    private String[] sTrackArr;		//공동신청트랙
    private String[] mTrackArr;		//단독신청트랙
    private String cCode;			//시험차량 코드
	private String[] cName;			//시험차종
	private String[] cVender;		//차량제조사
	private String[] cNumber;		//차량번호
	private String[] cType;			//특수차량여부 (S: 특수차량, N: 일반차량)
	private String[] cColor;		//차량색상
    List<CarDto> carInfo;			//시험차량정보
	private String tcPurpose;		//테스트목적
	private String tcAgreement;		//약관동의	
	private String tcApproval;		//예약승인	(0: 승인대기, 1: 승인반려, 2: 예약취소, 3: 승인완료)
	private String tcApprovalForChange;	//변경될 예약승인	(0: 승인대기, 1: 승인반려, 2: 예약취소, 3: 승인완료)
	private String tcStep;			//시험단계 (00000: 시험전, 00001: 시험중, 00002: 시험완료, 00003: 정산완료) 
	private String tcMemo;			//메모
	private String tcReservCode;	//예약번호
    @NotBlank(message = "등록자는 필수 항목입니다. ")
	private String tcRegUser;		//등록자
    @NotBlank(message = "등록일자은 필수 항목입니다. ") 
	private String tcRegDt;			//등록일시
	private String tcModUser;		//수정자
	private String tcModDt;			//수정일시
	
	//mapping table info
    @NotBlank(message = "시험순번은 필수 항목입니다. ") 
	private Integer trSeq;
    private String tcRequestNumber;				//의뢰번호
    private String trTrackType;					//시험유형(TYP00:공동, TYP01:단독, TYP02:시험, TYP03:연습, TYP04:점검, TYP05:시승, TYP06:사내방문, TYP07:테스트, TYP99:기타)
    private String trTrackName;					//트랙명
    private String trTrackNickName;				//트랙명(약어)
    private String trTrackCode;					//트랙코드
    private String trTrackCodeCopy;				//관리자트랙 추가시 복사용
    private String trLevel;						//트랙레벨
    private String trPackageName;				//시험로패키지명
    private String trPackageCode;				//시험로패키지코드
    @NotBlank(message = "트랙가격은 필수 항목입니다. ")
    private Integer trPrice;					//공동가격
    private Integer trPriceAdd;					//트랙가격(추가)
    private Integer trPriceSolo;				//단독가격
    List<TrReserveDto> trackInfo;					//트랙정보
    @NotBlank(message = "시험시작시간는 필수 항목입니다. ")
	private String trReservStHour;
    @NotBlank(message = "시험마감시간는 필수 항목입니다. ")
	private String trReservEdHour;
    private String trReservHour;				//현재 예약수 구하기 위한 dto
    
    //resource mapping
    private List<ResourceMappingDto> rmList;	//예약번호당 리소스목록
    private List<CarDto> carList;				//예약번호당 차량목록
    private Integer rsSeq;						//장비매핑일련번호
    private Integer dSeq;						//운전자일련번호
	private String[] driver;					//운잔자배열
    private String dName;						//운전자명
    private String rmType;						//분출구분 (D : 운전자, C : 시험차량)
    private String nDccpYn;						//DCCP 검사 여부
    private String rId;							//태그아이디
    private String rmLevel;						//운전자레벨
    private String wId;							//무전기아이디
    private String rmInOut;						//분출/회수
    private String rmRegDt;						//등록일
    
    //타이어 정보
	private String tmSeq;			//타이어 의뢰번호
	private String tmTireSet;		//타이어셋
	private String tmEng;			//엔지니어
	private String tmCarKind;		//차량종류
	private String tmLift;			//리프트
	private String tmAssemply;		//조립완료
	private String tmDecomposition;	//분해완료
	
	//private String shop
	private String wsCode;			//워크샵동 아이디
	private Integer shopCnt;		//예약개수
	private String[] shopReserve;	//부대시설예약코드
	private String[] shopReserveCntArr;	//예약가능일
	

	//정산관리(영훈)
	private int num;//시퀀스
	private String wssModDt;//취소일시
	private String wssStDay;//예약 시작일
	private String wssEdDay;//예약 종료일
	private String wsBlack;//블랙리스트 여부
	private String compRegDt;//등록날짜
	private String wsName;//워크샵명
	private String wsUseYn;//사용유무
	private String wssReservCode;//정산관리 예약번호
	private String compLicense; //사업자 번호
	private String memName;	    //예약자 회원명
	private String memDept;		 //예약자 부서
	private String memPhone;	 //예약자 전번
	private String compPhone;	 //회사 전화번호
	private String memEmail;	 //예약자 이메일
	private String compAcctName; //회계 이름
	private String compAcctDept; //회계 부서
	private String compAcctEmail; //회계 이메일
	private String compAcctPhone; //회계 전번

}