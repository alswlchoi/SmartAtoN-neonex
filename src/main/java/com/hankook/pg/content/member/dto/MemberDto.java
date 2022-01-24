package com.hankook.pg.content.member.dto;


import com.hankook.pg.content.login.dto.MenuDto;
import com.hankook.pg.share.Search;

import lombok.*;

import java.util.List;

@Setter
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberDto extends Search{
	//회원 ID
	private String memId;
	//회원 이름
    private String memName;
    //회원 PWD
    private String memPwd;
    //전화번호
    private String memPhone;
    //유저 회사 전화번호
    private String memCompPhone;
    //이메일
    private String memEmail;
    //회원 유저 타입
    private String memUserType;
    //사용여부
    private String memUseYn;
    //생년월일 ex)19930113
    private String memBirth;
    //부서명
    private String memDept;
    //가입목적
    private String memPurpose;
    //회원 권한
    private String authCode;
    //회원사
    private String compCode;
    //회원 주소
    private String memAddr;
    //우편번호
    private String memPostNo;
    //상세주소
    private String memAddrDetail;
    //멤버승인
    private String memApproval;
    //약관동의
    private String memAgreement;
    //등록일 14
    private String memRegDt;
    //수정일 14
    private String memModDt;
    //등록자
    private String memModUser;
    //수정자
    private String memRegUser;

    //////////////////////////////
    //company 정보
    //회사코드
//  	private String compCode;
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
  	private String compAddrDetail;
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
  	//회계 담당다 이메일
  	private String compAcctEmail;
  	//회계 담당자 부서
  	private String compAcctDept;

  	//권한명
    private String authNm;
    //바꿀 비밀번호
    private String newPwd;
    private List<MenuDto> menuList;
    //업로드 파일
    private String fName;
    private String fileText;

    private String authDefaultUrl;

    private String searchKeyword;
    private String rNum;

    private String checkbox;
    private String kakaoSmsYn;
}