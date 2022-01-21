package com.hankook.pg.content.admin.trPackage.dao;
 
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.admin.trPackage.dto.TrPackageDto;
import com.hankook.pg.content.admin.trPackage.dto.SearchTrPackageDto;

@Repository
@Mapper
public interface TrPackageDao {
	/* 목록*/
    List<TrPackageDto> getTrPackageList(SearchTrPackageDto search);

    /* 검색결과 갯수 반환 */
    int findTrPackageCount(SearchTrPackageDto search);
        
    /* tId 존재유무 */
    int getCompCodeduplCheck(String tpId);
    
    /* 가장 큰 코드의 숫자를 가져옴 */
    String getMaxCompCode();
    /* 등록*/
    int insertTrPackage(TrPackageDto trPackage);
    
    /* 상세보기 */
    TrPackageDto getTrPackageDetail(String tpId);
        
    /* 수정*/
    int updateTrPackage(TrPackageDto trPackage);
    
    /* 삭제*/
    int deleteTrPackage(String tpId);
}