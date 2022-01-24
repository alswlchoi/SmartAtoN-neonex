package com.hankook.pg.content.admin.trackPackage.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hankook.pg.content.admin.trackPackage.dao.TrackPackageDao;
import com.hankook.pg.content.admin.trackPackage.dto.TrackPackageDto;


@Service
public class TrackPackageService {

	 @Autowired
	  private TrackPackageDao trackPackageDao;
	 
	 //트랙 패키지 목록
	 public List<TrackPackageDto> getTrackPackageList(TrackPackageDto trackPackage) {
		 return trackPackageDao.getTrackPackageList(trackPackage);
	 }
	 
	 //상세정보
	 public  List<TrackPackageDto> getTrackPackageDetail(String tpId) {
		 return trackPackageDao.getTrackPackageDetail(tpId);
	 }
	 
	 //트랙이름
	 public List<TrackPackageDto> getTrackName() {
		 return trackPackageDao.getTrackName();
	 }
	 
	 //트랙삭제
	 public int deleteTrackPackage (TrackPackageDto trackPackageDto) {
		 return trackPackageDao.deleteTrackPackage(trackPackageDto);
	 }
	 
	 public int getEqTrackCnt (TrackPackageDto trackPackageDto) {
		 return trackPackageDao.getEqTrackCnt(trackPackageDto);
	 }
	 
	 //트랙등록
	 public int insertTrackNm (TrackPackageDto trackPackageDto) {
		TrackPackageDto trackName = new TrackPackageDto();
		TrackPackageDto tpname = trackPackageDao.getTPNm(trackPackageDto.getTpId());
		TrackPackageDto trackDetail = trackPackageDao.getTrackDetail(trackPackageDto.getTId());
		
		trackName.setTpId(trackPackageDto.getTpId());
		trackName.setTId(trackPackageDto.getTId());
		trackName.setTpName(tpname.getTpName());
		trackName.setTName(trackDetail.getTName());
		trackName.setTLevel(trackDetail.getTLevel());
		trackName.setTPrice(trackDetail.getTPrice());
		
		int cnt = 0;
		cnt = trackPackageDao.insertTrackNm(trackName);
		System.out.println("cnt" + cnt);
		return cnt;
	 }
	 
	 // 트랙 패키지이름
	 public TrackPackageDto getTPNm(String tpId) {
		 return trackPackageDao.getTPNm(tpId);
	 }
	 
	 // LEVEL PRICE 검색
	 public TrackPackageDto getTrackDetail(String tpId) {
		 return trackPackageDao.getTrackDetail(tpId);
	 }
	 
	 //토탈 카운트
	 public int getTrackCnt(TrackPackageDto trackPackageDto) {
		 return trackPackageDao.getTrackCnt(trackPackageDto);
	 }
}
