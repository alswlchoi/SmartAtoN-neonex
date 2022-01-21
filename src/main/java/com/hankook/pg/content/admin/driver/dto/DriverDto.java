package com.hankook.pg.content.admin.driver.dto;

import java.util.List;

import lombok.Data;

@Data
public class DriverDto {
	private int dSeq;						//일련번호
	private String tcDay = "";				//시험일자
	private String compCode = "";			//회사코드
	private String compName = "";			//회사명
	private String compLicense = "";		//회사사업자등록번호
	private String blacklist = "";			//회사블랙리스트여부
	private String dName = "";				//운전자명
	private String dBirth;					//생년월일
	private String dEmail;					//이메일
	private String dPhone;					//휴대폰
	private String dPhone2;					//일반전화
	private String dHistory;				//운전경력
	private String dBloodType;				//혈액형
	private String dBloodSpecial;			//혈액형특이사항
	private String dLicenseType = "";		//면허종류
	private String dLevel;					//운전자레벨
	private String dApproval;				//승인여부 (N:미승인, Y:승인)
	private String dMemo;					//메모
	private String dEdu = "";				//운전자이수여부 (N:미이수, Y:이수)
	private String dEduDt = "";				//운전자교육
	private String dEduEndDt = "";			//운전자교육 만료일
	private String dRegDt = "";				//등록일
	private String dRegUser = "";			//등록자
	private String dModDt = "";				//수정일
	private String dModUser = "";			//수정자
	private int pageNo;						//페이지번호
	private List<UpfilesDto> upfiles;		//저장파일정보
}