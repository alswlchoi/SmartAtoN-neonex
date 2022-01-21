package com.hankook.pg.content.admin.trPackage.service;
 
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.admin.trPackage.dao.TrPackageDao;
import com.hankook.pg.content.admin.trPackage.dto.SearchTrPackageDto;
import com.hankook.pg.content.admin.trPackage.dto.TrPackageDto;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Results;

@Service
public class TrPackageService{
    
    @Autowired
    private TrPackageDao trPackageDao;
    
    public Map<String, Object> getTrPackageList(SearchTrPackageDto searchTrPackage) {
    	searchTrPackage.setStartRowNum((searchTrPackage.getPageNo()-1)*10);
    	List<TrPackageDto> trPackageList = trPackageDao.getTrPackageList(searchTrPackage);
    	
        Paging paging = new Paging(searchTrPackage, trPackageDao.findTrPackageCount(searchTrPackage));
        
        return Results.grid(paging, trPackageList);
    }
    
    public Integer getCompCodeduplCheck(String dDay){
    	return trPackageDao.getCompCodeduplCheck(dDay);
    }
    
    public boolean insertTrPackage(TrPackageDto trPackage, HttpServletRequest request) {
    	
    	String maxCompCode = trPackageDao.getMaxCompCode();
    	int nextCodeNum = Fn.toInt(maxCompCode.replaceAll("P",""))+1; 
    	if(nextCodeNum<10) {
    		trPackage.setTpId("P00"+nextCodeNum);
    	}else {
    		trPackage.setTpId("P0"+nextCodeNum);
    	}
    	Integer cnt = trPackageDao.insertTrPackage(trPackage);

		return cnt > 0;
    }
     
    public TrPackageDto getTrPackageDetail(String compCode) {
    	return trPackageDao.getTrPackageDetail(compCode);
    }
     
    public boolean updateTrPackage(TrPackageDto trPackage) {
    	int cnt = trPackageDao.updateTrPackage(trPackage); 
    	return cnt > 0;
    }
       
    public boolean deleteTrPackage(String dDay) {
    	//휴일 날짜 형식 변경 (yyyyMMdd)
    	dDay = Fn.toDateFormat(dDay, "yyyyMMdd");
    	System.out.println(dDay);
    	int cnt = trPackageDao.deleteTrPackage(dDay); 
    	return cnt > 0;
    }
}

