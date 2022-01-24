package com.hankook.pg.content.admin.trPackage.controller;
 
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.hankook.pg.content.admin.trPackage.dto.SearchTrPackageDto;
import com.hankook.pg.content.admin.trPackage.dto.TrPackageDto;
import com.hankook.pg.content.admin.trPackage.service.TrPackageService;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.ResultCode;
import com.hankook.pg.share.Search;

@RestController
@RequestMapping("/trPackage")
public class TrPackageController {
 
    @Autowired
    TrPackageService trPackageService;

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ModelAndView getTrPackages(HttpServletRequest req , HttpServletResponse res , ModelAndView mav ,SearchTrPackageDto searchTrPackage,HttpSession session) {

        searchTrPackage.setPageNo(1);
        searchTrPackage.setPageSize(10);
    	String[] arrOrderColumn = {"COMP_CODE DESC"};
    	searchTrPackage.setArrOrderColumn(arrOrderColumn);

    	//업체 조회
        Map<String, Object> trPackageList = trPackageService.getTrPackageList(searchTrPackage);
        
        //페이징 처리
        Search search = new Search();
        search.setPageNo(1);
        search.setPageSize(10);
        Paging paging = new Paging(search, (Integer)trPackageList.get("records"));

        //변수 설정
        mav.addObject("paging", paging);
        mav.addObject("trPackageList",trPackageList);
        mav.addObject("totalCnt", trPackageList.get("records").toString());
        
        mav.setViewName("/trPackage/trPackage");
                
        return mav;
    }

    @GetMapping(value = "/search-trPackage", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public Map<String, Object> getSearch(SearchTrPackageDto searchTrPackage) {
    	String[] order = {"COMP_CODE DESC"};
    	searchTrPackage.setArrOrderColumn(order);
    	//업체 조회

    	Map<String, Object> trPackageList = trPackageService.getTrPackageList(searchTrPackage);
        //페이징 처리
        Search search = new Search();
        search.setPageNo(searchTrPackage.getPageNo());
        search.setPageSize(searchTrPackage.getPageSize());
        Paging paging = new Paging(search, (Integer)trPackageList.get("records"));
        
        trPackageList.put("totalCnt", trPackageList.get("records").toString());
        trPackageList.put("paging",paging);
        
        return trPackageList;
    }
    
    //글쓰기 process
    @RequestMapping(value="/insert-trPackage", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode insertTrPackage(TrPackageDto trPackage,HttpServletRequest request) {
    	
    	boolean result = false;

		try {
			// 사용자 등록
	    	result = trPackageService.insertTrPackage(trPackage, request);
		} catch (Exception e) {
			return ResultCode.builder()
                    .code(500)
                    .message("등록에 실패하였습니다.")
                    .build();
		}
		
		int code = result ? 200 : 400;
		String message = result ? "등록에 성공하였습니다." : "등록에 실패하였습니다.";
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    }
    
    //상세보기
    @GetMapping(value = "/detail-trPackage", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public Map<String, Object> getTrPackageDetail(TrPackageDto trPackage) {        
        trPackage = trPackageService.getTrPackageDetail(trPackage.getTpId());
        
        Map<String, Object> result = new HashMap<String, Object>();  
        result.put("trPackage", trPackage);
        return result;
    	
    }
    
    //수정 처리
    @RequestMapping(value="/update-trPackage", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode getTrPackageModify(TrPackageDto trPackage,HttpServletRequest request) {
		int cnt = trPackageService.getCompCodeduplCheck(trPackage.getTpId());
		
		if (cnt == 0) return ResultCode.builder()
                .code(400)
                .message("정보가 존재하지 않습니다.")
                .build();	
  
     	boolean result = true;
    	
     	try {
     		//사용자 업데이트
     		result = trPackageService.updateTrPackage(trPackage);
 		} catch (Exception e) {
 			return ResultCode.builder()
 	                .code(400)
 	                .message("수정에 실패했습니다.")
 	                .build();	
 		}
		
     	int code = result ? 200 : 400;
		String message = result ? "수정에 성공하였습니다." : "수정에 실패하였습니다.";
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    }
    
    //삭제 처리
    @RequestMapping(value="/delete-trPackage", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode getTrPackageDelete(TrPackageDto trPackage,HttpServletRequest request) {

    	boolean result = true;
    	
     	try {
     		result = trPackageService.deleteTrPackage(trPackage.getTpId());
 		} catch (Exception e) {
 			return ResultCode.builder()
 	                .code(400)
 	                .message("삭제에 실패했습니다.")
 	                .build();	
 		}
		
     	int code = result ? 200 : 400;
		String message = result ? "삭제에 성공하였습니다." : "삭제에 실패하였습니다.";
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    }
}