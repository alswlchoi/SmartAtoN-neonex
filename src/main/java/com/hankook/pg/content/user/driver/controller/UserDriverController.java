package com.hankook.pg.content.user.driver.controller;
 
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.hankook.pg.content.admin.driver.dto.DriverDto;
import com.hankook.pg.content.admin.driver.dto.SearchDriverDto;
import com.hankook.pg.content.admin.driver.service.DriverService;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.ResultCode;
import com.hankook.pg.share.Search;

@RestController
@RequestMapping("/user/driver")
public class UserDriverController {
 
    @Autowired
    DriverService driverService;

    @GetMapping("")
    public ModelAndView getDrivers(SearchDriverDto searchDriver, ModelAndView mav) throws Exception {
    	/* 로그인 정보 가져옴 */
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	if("anonymousUser".equals(authentication.getName())) {
    		 mav.setViewName("redirect:/login");
    	}else {
        	MemberDto memberDto = (MemberDto)authentication.getPrincipal();
	    	searchDriver.setCompCode(memberDto.getCompCode());
	    	
	    	searchDriver.setPageNo(1);
	        searchDriver.setPageSize(10);
	    	String[] arrOrderColumn = {"D_SEQ DESC"};
	    	searchDriver.setArrOrderColumn(arrOrderColumn);
	
	        //조회
	    	Map<String, Object> driverList = driverService.getDriverList(searchDriver);
	
	    	//갯수
	    	int totalCnt = driverService.getDriverCount(searchDriver);
	    	//페이징 처리
	    	Paging paging = new Paging();
	
	        Search search = new Search();
	        search.setPageNo(1);
	        search.setPageSize(10);
	        paging = new Paging(search, totalCnt);
		
	        //변수 설정
	        mav.addObject("paging", paging);
	        mav.addObject("driverList",driverList);
	        mav.addObject("totalCnt", totalCnt);
	        
	        mav.setViewName("/user/driver/driver");
    	}
    	return mav;
    }

    @GetMapping(value = "/search-driver", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public Map<String, Object> getSearch(SearchDriverDto searchDriver) throws Exception {

    	String[] order = {"D_SEQ DESC"};
    	searchDriver.setArrOrderColumn(order);

    	/* 로그인 정보 가져옴 */
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	MemberDto memberDto = (MemberDto)authentication.getPrincipal();
    	
    	//운전자 조회
    	searchDriver.setCompCode(memberDto.getCompCode());
    	Map<String, Object> driverList = driverService.getDriverList(searchDriver);
        
        //페이징 처리
        Search search = new Search();
        search.setPageNo(searchDriver.getPageNo());
        search.setPageSize(searchDriver.getPageSize());
        Paging paging = new Paging(search, (Integer)driverList.get("records"));
        
        driverList.put("totalCnt", driverList.get("records").toString());
        driverList.put("paging",paging);        
        
        return driverList;
    }

    @ResponseBody
	@RequestMapping(value = "/fileupload/insert-driver", method = RequestMethod.POST)
    public ResultCode insertDriver(DriverDto driver, @RequestParam("dFile") List<MultipartFile> multipartFiles, HttpServletRequest request) {

    	Integer code = 0;
    	
    	try {
			// 사용자 등록
			code = driverService.insertDriver(driver, multipartFiles, request);
		} catch (Exception e) {
			return ResultCode.builder()
                   .code(500)
                   .message("승인신청에 실패하였습니다.")
                   .build();
		}
		
		String message = "승인신청에 실패하였습니다.";
		
		if(code<0) {
			message = "5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.";
		}else if(code==0) {
			message = "승인신청에 실패하였습니다.";
		}else {
			code=200;
			message = "승인신청에 성공하였습니다.";
		}
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    }

    @GetMapping(value = "/detail")
    public ModelAndView getDriverDetail(DriverDto driver) throws Exception {
    	ModelAndView mav = new ModelAndView();
    	
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	if("anonymousUser".equals(authentication.getName())) {
            mav.setViewName("redirect:/login");
    	}else {
	    	MemberDto memberDto = (MemberDto)authentication.getPrincipal();

	        driver = driverService.getDriverDetail(driver.getDSeq());
	        
	    	if(!memberDto.getCompCode().equals(driver.getCompCode())) {
	            mav.setViewName("redirect:/");
	    	}else {
	        	mav.setViewName("/user/driver/detail");
	            mav.addObject("driver", driver);	    		
	    	}
    	}
        return mav;
    }
    
    //삭제 처리
    @RequestMapping("/delete-driver")
    public ResultCode getDriverDelete(DriverDto driver,HttpServletRequest request) {

    	boolean result = true;
    	
     	try {
     		//삭제
     		result = driverService.deleteDriver(driver.getDSeq());
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

    @RequestMapping("/fileupload/download/{fSeq}")
    public void doDownloadFile(@PathVariable int fSeq, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	try {
    		
    		driverService.fileDownload2(fSeq, request, response);	//211028 새로 작성 소스
 		} catch (Exception e) {
 			System.out.println("파일 다운로드 실패");
 		}    	
    }
}