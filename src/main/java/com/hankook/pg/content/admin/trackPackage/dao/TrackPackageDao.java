package com.hankook.pg.content.admin.trackPackage.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.admin.trackPackage.dto.TrackPackageDto;


@Mapper
@Repository
public interface TrackPackageDao {

	/* 목록 */
	List<TrackPackageDto> getTrackPackageList(TrackPackageDto trackPackageDto);
	
	/* 상세보기 */
	List<TrackPackageDto> getTrackPackageDetail(String tpId);
	
	/* 트랙이름 */
	List<TrackPackageDto> getTrackName();
	
	/* 트랙 중복 조회*/
	int getEqTrackCnt(TrackPackageDto trackPackageDto);
	
	/* 토탈 카운트 */
	int getTrackCnt(TrackPackageDto trackPackageDto);
	
	/* 트랙삭제 */
	int deleteTrackPackage(TrackPackageDto trackPackageDto);
	
	/* 트랙등록 */
	int insertTrackNm(TrackPackageDto trackPackageDto);
	
	/* 트랙 패키지이름 */
	TrackPackageDto getTPNm(String tpId);
	
	/* LEVEL PRICE 검색*/
	TrackPackageDto getTrackDetail(String tpId);

}
