package com.hankook.pg.content.admin.trReserve.dto;

import java.util.Date;

public class EaiHkDto {
	private Integer hesSeq;
	private Integer tcSeq;
	private String compName = "";
	private String compCode = "";
	private String compLicense = "";
	private String compCeo = "";
	private String compPhone = "";
	private String compCond = "";
	private String comdKind = "";
	private String compFax = "";
	private String compAddr = "";
	private String compPostNo = "";
	private String compAttrDetail = "";
	private String memName = "";
	private String memBirth = "";
	private String memPhone = "";
	private String tcDay;
	private Date inDate;
	private Date createDate;
	private String createUser = "";
	private Date updateDate;
	private String updateUser = "";
	private String ifStatus = "";
	
	public Integer getHesSeq() {
		return hesSeq;
	}
	public void setHesSeq(Integer hesSeq) {
		this.hesSeq = hesSeq;
	}
	public Integer getTcSeq() {
		return tcSeq;
	}
	public void setTcSeq(Integer tcSeq) {
		this.tcSeq = tcSeq;
	}
	public String getCompName() {
		return compName == null ? "" : compName;
	}
	public void setCompName(String compName) {
		this.compName = compName;
	}
	public String getCompCode() {
		return compCode == null ? "" : compCode;
	}
	public void setCompCode(String compCode) {
		this.compCode = compCode;
	}
	public String getCompLicense() {
		return compLicense == null ? "" : compLicense;
	}
	public void setCompLicense(String compLicense) {
		this.compLicense = compLicense;
	}
	public String getCompCeo() {
		return compCeo == null ? "" : compCeo;
	}
	public void setCompCeo(String compCeo) {
		this.compCeo = compCeo;
	}
	public String getCompPhone() {
		return compPhone == null ? "" : compPhone;
	}
	public void setCompPhone(String compPhone) {
		this.compPhone = compPhone;
	}
	public String getCompCond() {
		return compCond == null ? "" : compCond;
	}
	public void setCompCond(String compCond) {
		this.compCond = compCond;
	}
	public String getComdKind() {
		return comdKind == null ? "" : comdKind;
	}
	public void setComdKind(String comdKind) {
		this.comdKind = comdKind;
	}
	public String getCompFax() {
		return compFax == null ? "" : compFax;
	}
	public void setCompFax(String compFax) {
		this.compFax = compFax;
	}
	public String getCompAddr() {
		return compAddr == null ? "" : compAddr;
	}
	public void setCompAddr(String compAddr) {
		this.compAddr = compAddr;
	}
	public String getCompPostNo() {
		return compPostNo == null ? "" : compPostNo;
	}
	public void setCompPostNo(String compPostNo) {
		this.compPostNo = compPostNo;
	}
	public String getCompAttrDetail() {
		return compAttrDetail == null ? "" : compAttrDetail;
	}
	public void setCompAttrDetail(String compAttrDetail) {
		this.compAttrDetail = compAttrDetail;
	}
	public String getMemName() {
		return memName == null ? "" : memName;
	}
	public void setMemName(String memName) {
		this.memName = memName;
	}
	public String getMemBirth() {
		return memBirth == null ? "" : memBirth;
	}
	public void setMemBirth(String memBirth) {
		this.memBirth = memBirth;
	}
	public String getMemPhone() {
		return memPhone == null ? "" : memPhone;
	}
	public void setMemPhone(String memPhone) {
		this.memPhone = memPhone;
	}
	public String getTcDay() {
		return tcDay == null ? "" : tcDay;
	}
	public void setTcDay(String tcDay) {
		this.tcDay = tcDay;
	}
	public Date getInDate() {
		return inDate;
	}
	public void setInDate(Date inDate) {
		this.inDate = inDate;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public String getCreateUser() {
		return createUser == null ? "" : createUser;
	}
	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}
	public Date getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}
	public String getUpdateUser() {
		return updateUser == null ? "" : updateUser;
	}
	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}
	public String getIfStatus() {
		return ifStatus == null ? "" : ifStatus;
	}
	public void setIfStatus(String ifStatus) {
		this.ifStatus = ifStatus;
	}
	

}