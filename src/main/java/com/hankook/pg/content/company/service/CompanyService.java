package com.hankook.pg.content.company.service;
 
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.company.dao.CompanyDao;
import com.hankook.pg.content.company.dto.CompanyDto;
import com.hankook.pg.content.company.dto.SearchCompanyDto;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Results;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CompanyService{
    
    @Autowired
    private CompanyDao companyDao;
    
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
      
    public Map<String, Object> getCompanyList(SearchCompanyDto searchCompany) {
    	searchCompany.setStartRowNum((searchCompany.getPageNo()-1)*10);
    	List<CompanyDto> companyList = companyDao.getCompanyList(searchCompany);
    	
        Paging paging = new Paging(searchCompany, companyDao.findCompanyCount(searchCompany));
        
        return Results.grid(paging, companyList);
    }
    
    public Integer getCountCompany(String compCode){
    	return companyDao.getCountCompany(compCode);
    }
    
    public Integer getCompCodeduplCheck(String compCode){
    	return companyDao.getCompCodeduplCheck(compCode);
    }
    
    public boolean insertCompany(CompanyDto company, HttpServletRequest request) {
    	/* 현재 시간 설정 */
    	Date date_now = new Date(System.currentTimeMillis());
    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
    	company.setCompRegDt(currentTime);
    	
    	String maxCompCode = companyDao.getMaxCompCode();
    	int nextCodeNum = Fn.toInt(maxCompCode.replaceAll("C",""))+1; 
    	if(nextCodeNum<10) {
    		company.setCompCode("C00"+nextCodeNum);
    	}else {
    		company.setCompCode("C0"+nextCodeNum);
    	}
    	Integer cnt = companyDao.insertCompany(company);

		return cnt > 0;
    }
     
    public CompanyDto getCompanyDetail(String compCode) {
    	return companyDao.getCompanyDetail(compCode);
    }
     
    public boolean updateCompany(CompanyDto company) {
    	int cnt = companyDao.updateCompany(company); 
    	return cnt > 0;
    }
       
    public boolean deleteCompany(String compCode) {
    	int cnt = companyDao.deleteCompany(compCode); 
    	return cnt > 0;
    }
}

