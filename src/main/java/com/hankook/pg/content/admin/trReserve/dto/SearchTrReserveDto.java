package com.hankook.pg.content.admin.trReserve.dto;

import com.hankook.pg.share.Search;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
public class SearchTrReserveDto extends Search {

    private Integer trSeq;
    private Integer tcSeq;
    private String searchKind;		//검색종류 : C: 예약내역, L: 이용내역등에 사용
    private String rmType;			//분출구분 : D : 운전자, C : 시험차량
    private String compType;		//회원사 구분(T:한국타이어, B:B2B, H:현대자동차)
    private String tcDay;			//시험일
    private String tcStDt;			//시험일 시작(기간검색)
    private String tcEdDt;			//시험일 마감(기간검색)
    private String compCode;		//업체코드
    private String compName;		//업체명
    private String compLicense;		//사업자번호
    private String tcReservCode;	//예약번호(11자리)
    private String trTrackCode;		//트랙코드
    private String trTrackType;		//시험유형(TYP00:공동, TYP01:단독, TYP02:시험, TYP03:연습, TYP04:점검, TYP05:시승, TYP06:사내방문, TYP07:테스트, TYP99:기타)
    private String tcApproval;		//0: 승인대기, 1: 승인반려, 2: 예약취소, 3: 승인완료
	private String tcStep;			//시험단계 (00000: 시험전, 00001: 시험중, 00002: 시험완료, 00003: 정산완료) 
    private String trReservHour;				//현재 예약수 구하기 위한 dto
    private String orderName1;		//정렬컬럼
    private String orderKind1;		//정렬종류
    private String orderName2;
    private String orderKind2;
    private String orderName3;
    private String orderKind3;
    private String orderName4;
    private String orderKind4;
    private String orderName5;
    private String orderKind5;
    private String text;		//영훈 - 택스트
    private String tcDay2;		//영훈
    private String tcApproval1; //영훈
    private String blackList; //영훈 -블랙리스트 여부
    private String tcRegDt;
    
    @ApiModelProperty(value = "페이지번호")
    private Integer pageNo = 1;
    
    @ApiModelProperty(value = "한페이지 사이즈")
    private Integer pageSize = 20;

    @ApiModelProperty(value = "시작페이지")
    private Integer startPage = 1;
    
    @ApiModelProperty(value = "끝페이지")
    private Integer endPage = 10;
    
    @ApiModelProperty(value = "시작 Limit 번호")
    private Integer startRowNum = 0;
}


