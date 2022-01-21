package com.hankook.pg.content.admin.company.controller;
 
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.admin.company.dto.CompanyDto;
import com.hankook.pg.content.admin.company.dto.SearchCompanyDto;
import com.hankook.pg.content.admin.company.service.CompanyService;
import com.hankook.pg.content.admin.driver.dto.UpfilesDto;
import com.hankook.pg.content.admin.driver.service.DriverService;
import com.hankook.pg.content.admin.trReserve.dto.TrackDto;
import com.hankook.pg.content.admin.trReserve.service.TrReserveService;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.ResultCode;
import com.hankook.pg.share.Search;

@RestController
@RequestMapping("/admin/company")
public class CompanyController {
 
    @Autowired
    CompanyService companyService;
    
    @Autowired
    DriverService driverService;
    
    @Autowired
    TrReserveService trReserveService;
    
    @GetMapping("")
    public ModelAndView getCompanys(ModelAndView mav ,SearchCompanyDto searchCompany) throws Exception {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
	        searchCompany.setPageNo(1);
	        searchCompany.setPageSize(10);
	    	String[] arrOrderColumn = {"COMP_CODE DESC"};
	    	searchCompany.setArrOrderColumn(arrOrderColumn);
	
	    	//업체 조회
	    	searchCompany.setMemApproval("N");	//디폴스는 승인대기
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
	        
	        mav.setViewName("/admin/company/list");
		}
		
        return mav;
    }
    
    @GetMapping("/listy")
    public ModelAndView getListY(ModelAndView mav ,SearchCompanyDto searchCompany) throws Exception {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
	        searchCompany.setPageNo(1);
	        searchCompany.setPageSize(10);
	    	String[] arrOrderColumn = {"COMP_CODE DESC"};
	    	searchCompany.setArrOrderColumn(arrOrderColumn);
	
	    	//업체 조회
	    	searchCompany.setMemApproval("Y");	//승인완료 목록
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
	        
	        mav.setViewName("/admin/company/listy");
		}
		
        return mav;
    }

    @GetMapping("/listb")
    public ModelAndView getListB(ModelAndView mav ,SearchCompanyDto searchCompany) throws Exception {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
	        searchCompany.setPageNo(1);
	        searchCompany.setPageSize(10);
	    	String[] arrOrderColumn = {"COMP_CODE DESC"};
	    	searchCompany.setArrOrderColumn(arrOrderColumn);
	
	    	//업체 조회
	    	searchCompany.setBlackList("B");	//승인완료 목록
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
	        
	        mav.setViewName("/admin/company/listb");
		}
		
        return mav;
    }
    
    @GetMapping("/search-company")
    public Map<String, Object> getSearch(SearchCompanyDto searchCompany) throws Exception {
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
    
    @RequestMapping("/insert-company")
    public ResultCode insertCompany(CompanyDto company) throws Exception {
    	
    	boolean result = false;

		try {
			// 사용자 등록
	    	result = companyService.insertCompany(company);
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
    @RequestMapping(value="/detail-company", method= {RequestMethod.GET})
    public ModelAndView getCompanyDetail(CompanyDto company, HttpServletRequest request) throws Exception {
    	ModelAndView mav = new ModelAndView();
    	
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
	    	if(null!=company.getBlackList()&&company.getBlackList().equals("B")){
	        	mav.setViewName("/admin/company/detailb");
	    	}else {
		    	if(company.getMemApproval().equals("N")) {
		        	mav.setViewName("/admin/company/detail");
		    	}else if(company.getMemApproval().equals("Y")) {
		        	mav.setViewName("/admin/company/detaily");
		    	}
	    	}
	
	    	Integer pageNo = Fn.toInt(request, "pageNo");
	    	Integer fseq = 0;
	    	String fname = "";
	    	
	        company = companyService.getCompanyDetail(company.getCompCode());
	    	
	    	BigDecimal number = new BigDecimal(company.getCompLicense());
	    	
	    	UpfilesDto licenseFile = companyService.getFileLicense(number);
	
	    	if(null!=licenseFile) {
	        	fseq = licenseFile.getFSeq();
	        	fname = licenseFile.getFName();
	    	}
	    	
	        mav.addObject("pageNo", pageNo);
	        mav.addObject("company", company);
	        mav.addObject("fname", fname);
	        mav.addObject("fseq", fseq);
		}
		
        return mav;
    	
    }
    
    //블랙리스트 처리
    @RequestMapping(value="/update-blacklist", method= {RequestMethod.POST})
    public ResultCode companyBlackList(@RequestBody CompanyDto company) throws Exception {
		int cnt = companyService.getCompCodeduplCheck(company.getCompCode());
		if (cnt == 0) return ResultCode.builder()
                .code(400)
                .message("정보가 존재하지 않습니다.")
                .build();	
  
     	boolean result = true;
    	
     	try {
     		result = companyService.companyBlackList(company);
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
    
    //수정 처리
    @RequestMapping(value="/update-company", method= {RequestMethod.POST})
    public ResultCode getCompanyModify(@RequestBody CompanyDto company, HttpServletRequest request) throws Exception {
		int cnt = companyService.getCompCodeduplCheck(company.getCompCode());
		if (cnt == 0) return ResultCode.builder()
                .code(400)
                .message("정보가 존재하지 않습니다.")
                .build();	
  
     	boolean result = true;
    	
    	try {
     		//사용자 업데이트
     		result = companyService.updateCompany(company, request);
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
    @RequestMapping("/delete-company")
    public ResultCode getCompanyDelete(CompanyDto company) throws Exception {

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
    
    //반려 처리
    @RequestMapping("/change-company")
    public ResultCode changeCompany(CompanyDto company) throws Exception {

    	boolean result = true;
    	
    	String msgKind = "";
    	
    	if(company.getMemApproval().equals("Y")) {
    		msgKind = "승인완료";
    	}else {
    		msgKind = "승인반려";
    	}
     	try {
     		//사용자 업데이트
     		result = companyService.changeCompany(company);
 		} catch (Exception e) {
 			return ResultCode.builder()
 	                .code(400)
 	                .message("변경에 실패했습니다.")
 	                .build();	
 		}
     	
     	int code = result ? 200 : 400;
		String message = result ? msgKind+" 되었습니다." : "변경에 실패하였습니다.";
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    	
    }
    
    @RequestMapping("/fileupload/download/{fSeq}")
    public ResultCode doDownloadFile(@PathVariable int fSeq, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	boolean result = false;

		result = driverService.fileDownload(fSeq, request, response);
		
     	int code = result ? 200 : 400;
		String message = result ? "다운로드에 성공하였습니다." : "다운로드에 실패하였습니다.";
		
		if(code==200) {
			return null;
		}else {
			return ResultCode.builder()
	                .code(code)
	                .message(message)
	                .build();
		}
    }
	
	@GetMapping("/email-approve")
	public ModelAndView emailSetting() throws Exception {
		ModelAndView mav = new ModelAndView();
		
        CompanyDto company = companyService.getCompanyDetail("C2061");
    	Integer entranceFee = trReserveService.SelectEntranceFee();

		/* 현재 시간 설정 */
    	Date date_now = new Date(System.currentTimeMillis());
    	String currentTime = Fn.toDateFormat(date_now, "yyyy.MM.dd HH:mm");
		List<TrackDto> trackList = trReserveService.getTrackList("Y");
        String compMemo = company.getCompMemo();
        
        if(compMemo!=null&&!"".equals(compMemo)) {
        	compMemo = compMemo.replaceAll("\r\n", "<br />").replaceAll("\r", "<br />").replaceAll("\n", "<br />");
        }
        
        String compRegDt = company.getCompRegDt();
        compRegDt = Fn.toDateFormat(compRegDt, "yyyy.MM.dd HH:mm");
    	mav.addObject("compRegDt", compRegDt);
    	mav.addObject("compModDt", currentTime);
   		mav.addObject("compMemo", compMemo);
    	mav.addObject("memId", company.getMemId());
    	mav.addObject("trackList", trackList);
    	mav.addObject("entranceFee", entranceFee);
    	
		mav.setViewName("/thymeleaf/memberApprove");

		return mav;
	}
}