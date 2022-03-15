package com.hankook.pg.content.admin.driver.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.admin.driver.dto.DriverDto;
import com.hankook.pg.content.admin.driver.dto.SearchDriverDto;
import com.hankook.pg.content.admin.driver.dto.UpfilesDto;

@Repository
@Mapper
public interface DriverDao {
	/* 목록*/
	List<DriverDto> getDriverList(SearchDriverDto search) throws Exception;

    /* 검색결과 갯수 반환 */
    int getDriverCount(SearchDriverDto search) throws Exception;

    /* 코드로 정보유무 */
    int getDriverCodeCount(Integer dSeq) throws Exception;

    /* 등록*/
    int insertDriver(DriverDto driver) throws Exception;

    /* 상세보기 */
    DriverDto getDriverDetail(Integer dSeq) throws Exception;

    /* 수정*/
    int updateDriver(DriverDto driver) throws Exception;
    
    /* 승인처리 */
    int updateApproval(DriverDto driver) throws Exception;

    /* 반려처리 */
    int updateReturn(DriverDto driver) throws Exception;

    /* 삭제*/
    int deleteDriver(Integer dSeq) throws Exception;

    /* 파일 정보 입력 */
    int insertDriverFile(UpfilesDto upfiles) throws Exception;

    /* 파일 정보 가져오기 */
    List<UpfilesDto> getUpfiles(UpfilesDto upFile) throws Exception;

    /* 파일 정보 삭제 */
    int deleteUpfiles(UpfilesDto delFile) throws Exception;

    /* 파일정보 (한개) */
    UpfilesDto getFileDriverOnly(Integer fSeq) throws Exception;
    
    /* 파일정보 (한개) 업데이트 */
    int updateFile1ea(UpfilesDto upFile) throws Exception;
    
    /* 파일정보 (한개) 삭제 */
    int deleteFile1ea(Integer fSeq) throws Exception;

    /* 파일 정보 수정 */
	int updateFile(UpfilesDto upfiles) throws Exception;
	
	//드라이브 등급
	List<DriverDto> driverLevel(DriverDto driver) throws Exception;
}