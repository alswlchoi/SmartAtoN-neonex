package com.hankook.pg.content.admin.dashboard.vo;

import lombok.Data;

@Data
public class DashboardVo {

	private String tcReservCode;//예약번호
	private String tcDay;//사용일
	private String gnrInTime;//gnr입장시간
	private String gnrOutTime;//퇴장시간
	private String inOut;//o : b2b I : 한국타이어
	private String compName;//회사명
	private String dName;//운전자
	private String tId;//트랙ID
	private String trackInTime;//트랙 입장시간
	private String trackOutTime;//트랙 퇴장시간
	private String tName;//트랙네임
	private String tNickname;//트랙닉네임
	private int tMax;//capa
	private int diffTime;//입장 퇴장 분 차이
	private int totalCnt;//총 대수
	private int hkCnt;//hk 대수
	private int b2bCnt;//b2b 대수
	private String carRfidId;//차량 RFID
}
