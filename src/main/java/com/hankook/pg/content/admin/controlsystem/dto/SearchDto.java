package com.hankook.pg.content.admin.controlsystem.dto;

import com.hankook.pg.share.Search;

public class SearchDto extends Search {
	private String tId;			//트랙아이디
	private Integer dSeq;		//운전자일련번호
	private String dName;		//운전자명
	private String tcDay;		//시험일
	private String currentTime;	//현재시간
	private Integer tcSeq;		//시험일련번호
	private String tagId;		//운전자 tagId
	private String carTagId;	//차량 tagId
	private String text;		//검색 키워드

	public String gettId() {
		return tId == null ? "" : tId;
	}
	public void settId(String tId) {
		this.tId = tId;
	}
	public Integer getdSeq() {
		return dSeq;
	}
	public void setdSeq(Integer dSeq) {
		this.dSeq = dSeq;
	}
	public String getdName() {
		return dName == null ? "" : dName;
	}
	public void setdName(String dName) {
		this.dName = dName;
	}
	public Integer getTcSeq() {
		return tcSeq;
	}
	public void setTcSeq(Integer tcSeq) {
		this.tcSeq = tcSeq;
	}
	public String getTcDay() {
		return tcDay == null ? "" : tcDay;
	}
	public void setTcDay(String tcDay) {
		this.tcDay = tcDay;
	}
	public String getCurrentTime() {
		return currentTime == null ? "" : currentTime;
	}
	public void setCurrentTime(String currentTime) {
		this.currentTime = currentTime;
	}
	public String getTagId() {
		return tagId == null ? "" : tagId;
	}
	public void setTagId(String tagId) {
		this.tagId = tagId;
	}
	public String getCarTagId() {
		return carTagId == null ? "" : carTagId;
	}
	public void setCarTagId(String carTagId) {
		this.carTagId = carTagId;
	}
	public String getText()
	{
		return text == null ? "" : text;
	}
}