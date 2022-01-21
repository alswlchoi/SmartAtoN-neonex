package com.hankook.pg.common.code.dto;

public class CodeDto {

	private String code; //코드
	private String pcode; //부모코드
	private String code_nm1; //코드이름1
	private String code_nm2; //코드이름2
	private String code_nm3; //코드이름3
	private String code_nm4; //코드이름4
	private String code_nm5; //코드이름5
	//private String[] code_nms;
	private int code_lv; //코드 레벨
	private int ord; //코드 순서
	private String code_path; //코드 경로
	private String use_yn; //사용 여부
	
	// 뷰단 attribute
	private String code_path_nm1;	//코드 이름1 경로
	private String code_path_nm2;	//코드 이름2 경로
	private String code_path_nm3;	//코드 이름3 경로
	private String code_path_nm4;	//코드 이름4 경로
	private String code_path_nm5;	//코드 이름5 경로
	//private String[] code_path_nms;
	private int code_no;			//코드번호
	private String code_no_path;	//코드번호 경로
	
	public String getCode() {
		return code == null ? "" : code;
	}
	public String getPcode() {
		return pcode == null ? "" : pcode;
	}
	public String getCode_nm1() {
		return code_nm1 == null ? "" : code_nm1;
	}
	public String getCode_nm2() {
		return code_nm2 == null ? "" : code_nm2;
	}
	public String getCode_nm3() {
		return code_nm3 == null ? "" : code_nm3;
	}
	public String getCode_nm4() {
		return code_nm4 == null ? "" : code_nm4;
	}
	public String getCode_nm5() {
		return code_nm5 == null ? "" : code_nm5;
	}
	public String[] getCode_nms() {
		return new String[]{
				this.getCode_nm1(),
				this.getCode_nm2(),
				this.getCode_nm3(),
				this.getCode_nm4(),
				this.getCode_nm5()
			};
	}
	public int getCode_lv() {
		return code_lv;
	}
	public int getOrd() {
		return ord;
	}
	public String getCode_path() {
		return code_path == null ? "" : code_path;
	}
	public String getUse_yn() {
		return use_yn == null ? "" : use_yn;
	}
	public String getCode_path_nm1() {
		return code_path_nm1 == null ? "" : code_path_nm1;
	}
	public String getCode_path_nm2() {
		return code_path_nm2 == null ? "" : code_path_nm2;
	}
	public String getCode_path_nm3() {
		return code_path_nm3 == null ? "" : code_path_nm3;
	}
	public String getCode_path_nm4() {
		return code_path_nm4 == null ? "" : code_path_nm4;
	}
	public String getCode_path_nm5() {
		return code_path_nm5 == null ? "" : code_path_nm5;
	}
	public String[] getCode_path_nms() {
		return new String[]{
				this.getCode_path_nm1(),
				this.getCode_path_nm2(),
				this.getCode_path_nm3(),
				this.getCode_path_nm4(),
				this.getCode_path_nm5()
			};		
	}
	public int getCode_no() {
		return code_no;
	}
	public String getCode_no_path() {
		return code_no_path == null ? "" : code_no_path;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public void setPcode(String pcode) {
		this.pcode = pcode;
	}
	public void setCode_nm1(String code_nm1) {
		this.code_nm1 = code_nm1;
	}
	public void setCode_nm2(String code_nm2) {
		this.code_nm2 = code_nm2;
	}
	public void setCode_nm3(String code_nm3) {
		this.code_nm3 = code_nm3;
	}
	public void setCode_nm4(String code_nm4) {
		this.code_nm4 = code_nm4;
	}
	public void setCode_nm5(String code_nm5) {
		this.code_nm5 = code_nm5;
	}
	public void setCode_nms(String[] code_nms) {
		this.code_nm1 = code_nms[0];
		this.code_nm2 = code_nms[1];
		this.code_nm3 = code_nms[2];
		this.code_nm4 = code_nms[3];
		this.code_nm5 = code_nms[4];
	}
	public void setCode_lv(int code_lv) {
		this.code_lv = code_lv;
	}
	public void setOrd(int ord) {
		this.ord = ord;
	}
	public void setCode_path(String code_path) {
		this.code_path = code_path;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public void setCode_path_nm1(String code_path_nm1) {
		this.code_path_nm1 = code_path_nm1;
	}
	public void setCode_path_nm2(String code_path_nm2) {
		this.code_path_nm2 = code_path_nm2;
	}
	public void setCode_path_nm3(String code_path_nm3) {
		this.code_path_nm3 = code_path_nm3;
	}
	public void setCode_path_nm4(String code_path_nm4) {
		this.code_path_nm4 = code_path_nm4;
	}
	public void setCode_path_nm5(String code_path_nm5) {
		this.code_path_nm5 = code_path_nm5;
	}
	public void setCode_path_nms(String[] code_path_nms) {
		this.code_path_nm1 = code_path_nms[0];
		this.code_path_nm2 = code_path_nms[1];
		this.code_path_nm3 = code_path_nms[2];
		this.code_path_nm4 = code_path_nms[3];
		this.code_path_nm5 = code_path_nms[4];
	}
	public void setCode_no(int code_no) {
		this.code_no = code_no;
	}
	public void setCode_no_path(String code_no_path) {
		this.code_no_path = code_no_path;
	}
}
