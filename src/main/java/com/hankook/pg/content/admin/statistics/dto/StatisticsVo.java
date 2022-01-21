package com.hankook.pg.content.admin.statistics.dto;

import com.hankook.pg.share.Search;
import lombok.Data;

@Data
public class StatisticsVo extends Search{
		//통계(영훈)
		private int num;//시퀀스
		private String wssStDay;//예약 시작일
		private String wssEdDay;//예약 종료일
		private String compRegDt;//등록날짜
		private String wsName;//워크샵명
		private String wsUseYn;
		private String wssReservCode;//정산관리 예약번호
		private String wssRegDt;
		private String compAcctName; //회계 이름
		private String compCode;
		private String compName;		//회사명
		private String tcReservCode; //시험로 예약번호
		private String tcRegDt; //시험로접수일자
		private String tcDay;
		private String tcDay2;
		private String pDay;	//정산테이블 사용컬럼
		private String trTrackType;
		private String trTrackName;
		private String tcApproval;
	    private String text;
	    private String cNumber;	//차 번호
	    private String carTagId;	//차량RFID
	    private String inTime;		//출입시간
	    private String outTime; 	//출입시간
	    private String tName;		//트랙이름
	    private String tDay; 		//매핑 날짜
	    private String tcSeq;		//매핑할때
	    private int pay; 		//정산금액
	    private String rmType;
	    private String hours;		//소요시간
	    private int price;		//부가세
	    private String tId;			//정산 트랙아이디
	    private String pUseTime;	//실사용시간
	    private String applyTime;	//적용시간
	    private String stDate;
	    private String edDate;
	    private int diffTime;
	    private String cType;
	    private String tNickname;
	    private String preservCode; //
	    
	    
	    private double rainDay; //일일당 누적 강우량
	    private String day; //일시
	    private double avgTa;//평균 온도
	    private double minTa;//최소 온도
	    private double maxTa;//최고 온도
	    private double avgRh;//평균 습도
	    private double avgWs;//평균 풍속
	    private double avgPa;//평균 기압
	    private double maxPa;//최고 기압
	    private double minPa;//최소 기압
	    private double dp; //이슬점
	    
	    private String roadInTime; //5분 간격 시간
	    private double roadTemp; //노면온도
	    private String regDt; //날짜
	    private String tNm; //트랙이름
	    private String statTp; //상태값 0:15분간(일별) 1:기간별(일별) 2:연도(주별)
	    private double temp; //온도
	    private String date; //param값 넘길때 사용하는
	    private String selectlist; //노면센서 리스트
	    private int wCount; //(1)주 차
	    private String oneDate; //노면온도 일별 기간 값
	    private String year; //노면온도 연별 기간 값
	    
	    private String vhclName;//차량명
	    private String vhclRgsno;//차량번호
	    private String carOil;//차량오일
	    private String pumpEnd;//최종 주유일자
	    private String qty;//주유량
	    private String stDay;
	    private String stDay2;
	    private String sumQty;
	    private String gasoline;
	    private String diesel;
	    private String approval;
	    
	    
}
