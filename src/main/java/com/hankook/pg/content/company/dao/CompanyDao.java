package com.hankook.pg.content.company.dao;
 
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.company.dto.CompanyDto;
import com.hankook.pg.content.company.dto.SearchCompanyDto;

@Repository
@Mapper
public interface CompanyDao {
	/* 목록*/
    List<CompanyDto> getCompanyList(SearchCompanyDto search);

    /* 검색결과 갯수 반환 */
    int findCompanyCount(SearchCompanyDto search);
    
    /* 코드로 정보조회 */
    int getCountCompany(String compCode);
    
    /* compCode 존재유무 */
    int getCompCodeduplCheck(String compCode);
    
    /* 가장 큰 코드의 숫자를 가져옴 */
    String getMaxCompCode();
    /* 등록*/
    int insertCompany(CompanyDto company);
    
    /* 상세보기 */
    CompanyDto getCompanyDetail(String compCode);
        
    /* 수정*/
    int updateCompany(CompanyDto company);
    
    /* 삭제*/
    int deleteCompany(String compCode);
}