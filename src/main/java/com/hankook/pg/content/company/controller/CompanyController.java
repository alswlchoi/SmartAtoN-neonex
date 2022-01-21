package com.hankook.pg.content.company.controller;
 
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.hankook.pg.share.ResultCode;
import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.company.dto.CompanyDto;
import com.hankook.pg.content.company.dto.SearchCompanyDto;
import com.hankook.pg.content.company.service.CompanyService;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Search;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/company")
public class CompanyController {
 
    @Autowired
    CompanyService companyService;
    
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    
    /******************************************
     * 
     * 업체 목록 조회(초기화면 조회)
     *
     * @Date   : 2020. 7. 20.
     * @Method : getCompanys
     * @return : ModelAndView
     ******************************************/
    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ModelAndView getCompanys(HttpServletRequest req , HttpServletResponse res , ModelAndView mav ,SearchCompanyDto searchCompany,HttpSession session) {

        searchCompany.setPageNo(1);
        searchCompany.setPageSize(10);
    	String[] arrOrderColumn = {"COMP_CODE DESC"};
    	searchCompany.setArrOrderColumn(arrOrderColumn);

    	//업체 조회
        Map<String, Object> companyList = companyService.getCompanyList(searchCompany);
        
        //페이징 처리
        Search search = new Search();
        search.setPageNo(1);
        search.setPageSize(10);
        Paging paging = new Paging(search, (Integer)companyList.get("records"));

        //변수 설정
        mav.addObject("paging", paging);
        mav.addObject("companyList",companyList);
        mav.addObject("totalCnt", companyList.get("records").toString());
        
        mav.setViewName("/company/list");
                
        return mav;
    }
    
    /******************************************
     * 
     * 업체 목록 조회(페이징 조회)
     *
     * @Date   : 2020. 7. 20.
     * @Method : getSearch
     * @return : Map<String,Object>
     ******************************************/
    @GetMapping(value = "/searchCompany", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public Map<String, Object> getSearch(SearchCompanyDto searchCompany) {
    	String[] order = {"COMP_CODE DESC"};
    	searchCompany.setArrOrderColumn(order);
    	//업체 조회

    	Map<String, Object> companyList = companyService.getCompanyList(searchCompany);
        
        //페이징 처리
        Search search = new Search();
        search.setPageNo(searchCompany.getPageNo());
        search.setPageSize(searchCompany.getPageSize());
        Paging paging = new Paging(search, (Integer)companyList.get("records"));
        
        companyList.put("totalCnt", companyList.get("records").toString());
        companyList.put("paging",paging);        
        
        return companyList;
    }
    
    //글쓰기 폼
    @RequestMapping(value="/company/write", method=RequestMethod.GET)
    public String companyWriteForm() {
    	return "/company/write";
    }
    
    //글쓰기 process
    @RequestMapping(value="/insertCompany", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode insertCompany(CompanyDto company,HttpServletRequest request) {
    	
    	boolean result = false;

		try {
			// 사용자 등록
	    	result = companyService.insertCompany(company, request);
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
    @RequestMapping(value="/company/{compCode}", method=RequestMethod.GET)
    public ModelAndView getCompanyDetail(@PathVariable("compCode") String compCode) {
        ModelAndView mv = new ModelAndView("/company/detail");
        
        CompanyDto company = companyService.getCompanyDetail(compCode);
        mv.addObject("company", company);
        
        return mv;
    	
    }

    //수정폼
    @RequestMapping(value="/company/modify/{compCode}", method=RequestMethod.GET)
    public ModelAndView getCompanyModifyForm(@PathVariable("compCode") String compCode) {
        ModelAndView mv = new ModelAndView("/company/modify");

        CompanyDto company = companyService.getCompanyDetail(compCode);
        mv.addObject("company", company);
        
        return mv;
    	
    }
    
    //수정 처리
    @RequestMapping(value="/updateCompany", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode getCompanyModify(CompanyDto company) {

		int cnt = companyService.getCountCompany(company.getCompCode());
		
		if (cnt == 0) return ResultCode.builder()
                .code(400)
                .message("정보가 존재하지 않습니다.")
                .build();	
  
     	boolean result = true;
    	
     	try {
     		//사용자 업데이트
     		result = companyService.updateCompany(company);
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
    @RequestMapping(value="/deleteCompany", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode getCompanyDelete(CompanyDto company,HttpServletRequest request) {

    	boolean result = true;
    	
     	try {
     		//사용자 업데이트
     		result = companyService.deleteCompany(company.getCompCode());
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