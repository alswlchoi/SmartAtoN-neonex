package com.hankook.pg.content.admin.driver.controller;
 
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.admin.driver.dto.DriverDto;
import com.hankook.pg.content.admin.driver.dto.SearchDriverDto;
import com.hankook.pg.content.admin.driver.service.DriverService;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.ResultCode;
import com.hankook.pg.share.Search;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/driver")
public class DriverController {
 
    @Autowired
    DriverService driverService;

    /******************************************
     * 
     * 운전자 목록 조회(초기화면 조회)
     *
     * @Date   : 2021. 7. 19.
     * @Method : getDrivers
     * @return : ModelAndView
     ******************************************/
    @GetMapping
    public ModelAndView getDrivers(SearchDriverDto searchDriver, ModelAndView mav, HttpServletRequest request) throws Exception {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
	    	int pageNo = Fn.toInt(request, "pageNo", 1);
	        String reqcon = Fn.toString(request, "reqcon");	//상세 또는 수정페이지에서 받은 상태검색조건(dApproval)    	
	    	searchDriver.setPageNo(pageNo);
	        searchDriver.setPageSize(10);
	        
	        //조회
	        if(reqcon.equals("Y")) {
	    		searchDriver.setDApproval("Y");
	        }else if(null==searchDriver.getDApproval() || searchDriver.getDApproval().length()==0) {
	    		searchDriver.setDApproval("N,R");
	    	}
	    	
	    	Map<String, Object> driverList = driverService.getDriverList(searchDriver);
	
	    	//갯수
	    	int totalCnt = driverService.getDriverCount(searchDriver);
	    	//페이징 처리
	    	Paging paging = new Paging();
	
	        Search search = new Search();
	        search.setPageNo(pageNo);
	        search.setPageSize(10);
	        paging = new Paging(search, totalCnt);
	        
	        //변수 설정
	        mav.addObject("paging", paging);
	        mav.addObject("driverList",driverList);
	        mav.addObject("totalCnt", totalCnt);
	        mav.addObject("reqcon", reqcon);
	        
	        mav.setViewName("/admin/driver/driver");
		}
    	return mav;
    }
    
    /******************************************
     * 
     * 목록 조회(페이징 조회)
     *
     * @Date   : 2021. 7. 19.
     * @Method : getSearch
     * @return : Map<String,Object>
     ******************************************/
    @GetMapping(value = "/search-driver")
    public Map<String, Object> getSearch(SearchDriverDto searchDriver) throws Exception {
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

    /******************************************
     * 
     * 등록
     *
     * @Date   : 2021. 7. 19.
     * @Method : insertDriver
     * @return : ResultCode
     ******************************************/
    @ResponseBody
	@RequestMapping(value = "/fileupload/insert-driver", method = RequestMethod.POST)
    public ResultCode insertDriver(DriverDto driver, @RequestParam("dFile") List<MultipartFile> multipartFiles, HttpServletRequest request) {

    	Integer code = 0;
    	String message = "";
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			code = -2;
			message = "관리자 로그인 후 이용해 주세요.";
		}else {	
			try {
				// 사용자 등록
				code = driverService.insertDriver(driver, multipartFiles, request);
			} catch (Exception e) {
				return ResultCode.builder()
	                   .code(500)
	                   .message("등록에 실패하였습니다.")
	                   .build();
			}
			
			message = "등록에 실패하였습니다.";
			
			if(code<0) {
				if(code==-1) {
					message = "등록권한이 없습니다.";
				}else if(code==-2){
					message = "해당 업체의 등록권한이 없습니다.";
				}else if(code==-3){
					message = "5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.";
				}
			}else if(code==0) {
				message = "등록에 실패하였습니다.";
			}else {
				code=200;
				message = "등록에 성공하였습니다.";
			}
		}
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    }

    /******************************************
     * 
     * 상세보기
     *
     * @Date   : 2021. 7. 19.
     * @Method : getDriverDetail
     * @return : ModelAndView
     ******************************************/
    @RequestMapping(value = "/detail-driver",method= {RequestMethod.GET,RequestMethod.POST})
    public ModelAndView getDriverDetail(DriverDto driver, HttpServletRequest request) throws Exception {
    	ModelAndView mav = new ModelAndView();

    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
			int cnt = driverService.getDriverCodeCount(driver.getDSeq());
			
			if(cnt==0) {
				mav.setViewName("redirect:/admin/driver");
			}else {
		    	mav.setViewName("/admin/driver/detail");
		        driver = driverService.getDriverDetail(driver.getDSeq());
		        int pageNo = Fn.toInt(request, "pageNo");
		
		        driver.setPageNo(pageNo);
		        mav.addObject("driver", driver);
			}
		}   
        return mav;
    }

    /******************************************
     * 
     * 상세보기
     *
     * @Date   : 2021. 7. 19.
     * @Method : getDriverDetail
     * @return : ModelAndView
     ******************************************/
    @RequestMapping(value = "/modify-driver",method= {RequestMethod.GET,RequestMethod.POST})
    public ModelAndView getDriverModifyForm(DriverDto driver, HttpServletRequest request) throws Exception {
    	ModelAndView mav = new ModelAndView();
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav = new ModelAndView("redirect:/adminLogin");
		}else {
	    	mav.setViewName("/admin/driver/modify");
	        driver = driverService.getDriverDetail(driver.getDSeq());
	        int pageNo = Fn.toInt(request, "pageNo", 1);
	
	        driver.setPageNo(pageNo);
	        mav.addObject("driver", driver);
		}
        return mav;
    }

    /******************************************
     * 
     * 수정하기
     *
     * @Date   : 2021. 7. 19.
     * @Method : getDriverModify
     * @return : ResultCode
     ******************************************/    
    //수정 처리
    @ResponseBody
    @RequestMapping(value="/update-driver", method = RequestMethod.POST)
    public ResultCode updateDriver(DriverDto driver, @RequestParam("dFile") List<MultipartFile> multipartFiles, HttpServletRequest request) throws Exception {
		int cnt = driverService.getDriverCodeCount(driver.getDSeq());
		
		if (cnt == 0) return ResultCode.builder()
                .code(400)
                .message("정보가 존재하지 않습니다.")
                .build();	
  
		int code = driverService.updateDriver(driver, multipartFiles, request);

		String message = "수정에 실패하였습니다.";
		
		if(code<0) {
			if(code==-1) {
				message = "수정권한이 없습니다.";
			}else if(code==-2){
				message = "해당 업체의 수정권한이 없습니다.";
			}else if(code==-3){
				message = "5MB 이내의 허용된 확장자 파일만 첨부할 수 있습니다.";
			}
		}else if(code==0) {
			message = "수정에 실패하였습니다.";
		}else {
			code=200;
			message = "수정에 성공하였습니다.";
		}
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    	
    }

    /******************************************
     * 
     * 상태 변경
     *
     * @Date   : 2021. 7. 19.
     * @Method : updateApproval
     * @return : ResultCode
     ******************************************/
    @PostMapping("/update-approval")
    public ResultCode updateApproval(@RequestBody DriverDto driver) throws Exception {
    	int cnt = driverService.getDriverCodeCount(driver.getDSeq());
    	
    	if (cnt == 0) return ResultCode.builder()
    			.code(400)
    			.message("정보가 존재하지 않습니다.")
    			.build();	
    	
    	boolean result = true;
    	
    	try {
    		//사용자 업데이트
    		result = driverService.updateApproval(driver);
    	} catch (Exception e) {
    		return ResultCode.builder()
    				.code(400)
    				.message("수정에 실패했습니다.")
    				.build();	
    	}
    	
    	int code = result ? 200 : 400;
    	String message = result ? "수정에 성공하였습니다." : "("+result+") 수정에 실패하였습니다.";
    	
    	return ResultCode.builder()
    			.code(code)
    			.message(message)
    			.build();
    	
    }

    /******************************************
     * 
     * 반려처리
     *
     * @Date   : 2021. 7. 19.
     * @Method : updateReturn
     * @return : ResultCode
     ******************************************/
    @RequestMapping(value="/update-return")
    public ResultCode updateReturn(DriverDto driver) throws Exception {
    	int cnt = driverService.getDriverCodeCount(driver.getDSeq());
    	
    	if (cnt == 0) return ResultCode.builder()
    			.code(400)
    			.message("정보가 존재하지 않습니다.")
    			.build();	
    	
    	boolean result = true;
    	
    	try {
    		result = driverService.updateReturn(driver);
    	} catch (Exception e) {
    		return ResultCode.builder()
    				.code(400)
    				.message("수정에 실패했습니다.")
    				.build();	
    	}
    	
    	int code = result ? 200 : 400;
    	String message = result ? "수정에 성공하였습니다." : "("+result+") 수정에 실패하였습니다.";
    	
    	return ResultCode.builder()
    			.code(code)
    			.message(message)
    			.build();
    	
    }

    /******************************************
     * 
     * 삭제처리
     *
     * @Date   : 2021. 7. 19.
     * @Method : getDriverDelete
     * @return : ResultCode
     ******************************************/
    @RequestMapping(value="/delete-driver")
    public ResultCode getDriverDelete(DriverDto driver) throws Exception {

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
    
    /*
    //수정 처리
    @RequestMapping(value="/driver/{dSeq}", method=RequestMethod.PUT)
    public String getDriverModify(DriverDto driver) throws Exception {

        driverService.updateDriver(driver);
        
        return "redirect:/driver/{dSeq}";
    	
    }

    //수정폼
    @RequestMapping(value="/driver/modify/{dSeq}", method=RequestMethod.GET)
    public ModelAndView getDriverModifyForm(@PathVariable("dSeq") int dSeq) throws Exception {
        ModelAndView mv = new ModelAndView("/driver/modify");
        
        DriverDto driver = driverService.getDriverDetail(dSeq);
        mv.addObject("driver", driver);
        
        return mv;
    	
    } 
     */
    
}