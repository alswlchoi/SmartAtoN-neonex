package com.hankook.pg.content.admin.company.dao;
 
import java.math.BigDecimal;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.admin.company.dto.CompanyDto;
import com.hankook.pg.content.admin.company.dto.SearchCompanyDto;
import com.hankook.pg.content.admin.driver.dto.UpfilesDto;

@Repository
@Mapper
public interface CompanyDao {
	/* 목록*/
    List<CompanyDto> getCompanyList(SearchCompanyDto search) throws Exception;

    /* 검색결과 갯수 반환 */
    int findCompanyCount(SearchCompanyDto search) throws Exception;
        
    /* compCode 존재유무 */
    int getCompCodeduplCheck(String compCode) throws Exception;
    
    /* 가장 큰 코드의 숫자를 가져옴 */
    String getDcCount(String compCode) throws Exception;
    
    /* 등록*/
    int insertCompany(CompanyDto company) throws Exception;
    
    /* 상세보기 */
    CompanyDto getCompanyDetail(String compCode) throws Exception;

    /* 디스카운트 */
    String getMaxCompCode() throws Exception;
    
    /* 사업자 등록증 */
    UpfilesDto getFileLicense(BigDecimal license) throws Exception;
    
    /* 수정 */
    int updateCompany(CompanyDto company) throws Exception;
    
    /* 상태값 변경 */
    int changeApproval(CompanyDto company) throws Exception;
    
    /* 할인율 등록*/
    int insertDiscount(CompanyDto company) throws Exception;
    
    /* 할인율 해제*/
    int deleteDiscount(CompanyDto company) throws Exception;
    
    /* 블랙리스트 처리*/
    int companyBlackList(CompanyDto company) throws Exception;
    
    /* 삭제*/
    int deleteCompany(String compCode) throws Exception;
}