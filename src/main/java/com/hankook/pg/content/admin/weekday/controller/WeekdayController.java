package com.hankook.pg.content.admin.weekday.controller;

import com.hankook.pg.content.admin.weekday.dto.SearchWeekdayDto;
import com.hankook.pg.content.admin.weekday.dto.WeekdayDto;
import com.hankook.pg.content.admin.weekday.service.WeekdayService;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.ResultCode;
import com.hankook.pg.share.Search;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/admin/weekday")
public class WeekdayController {
 
    @Autowired
    WeekdayService weekdayService;

    @GetMapping("")
    public ModelAndView getWeekdays(ModelAndView mav ,SearchWeekdayDto searchWeekday) {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
	        searchWeekday.setPageNo(1);
	        searchWeekday.setPageSize(10);
	    	String[] arrOrderColumn = {"COMP_CODE DESC"};
	    	searchWeekday.setArrOrderColumn(arrOrderColumn);
	
	    	//업체 조회
	        Map<String, Object> weekdayList = weekdayService.getWeekdayList(searchWeekday);
	        
	        //페이징 처리
	        Search search = new Search();
	        search.setPageNo(1);
	        search.setPageSize(10);
	        Paging paging = new Paging(search, (Integer)weekdayList.get("records"));
	
	        //변수 설정
	        mav.addObject("paging", paging);
	        mav.addObject("weekdayList",weekdayList);
	        mav.addObject("totalCnt", weekdayList.get("records").toString());
	        
	        mav.setViewName("/admin/weekday/weekday");
		}        
        return mav;
    }

    @GetMapping("/search-weekday")
    public Map<String, Object> getSearch(SearchWeekdayDto searchWeekday) {

    	Map<String, Object> weekdayList = weekdayService.getWeekdayList(searchWeekday);
        //페이징 처리
        Search search = new Search();
        search.setPageNo(searchWeekday.getPageNo());
        search.setPageSize(searchWeekday.getPageSize());
        Paging paging = new Paging(search, (Integer)weekdayList.get("records"));
        
        weekdayList.put("totalCnt", weekdayList.get("records").toString());
        weekdayList.put("paging",paging);

        return weekdayList;
    }
    
    //등록 process
    @RequestMapping("/insert-weekday")
    public ResultCode insertWeekday(WeekdayDto weekday) {
    	
    	Integer cnt = 0;
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
	     	int code = 403;
			String message = "관리자 권한이 없습니다.";
			return ResultCode.builder()
	                .code(code)
	                .message(message)
	                .build();
		}else {
			cnt = weekdayService.insertWeekday(weekday);
			
		
			int code = cnt>0 ? 200 : 400;
			
			String message = "등록에 성공하였습니다.";
			if(cnt==-3) {
				message = "기관당 하나의 데이터만 허용됩니다.";
			}else if(cnt == -2){
				message = "기간이 잘 못 입력되었습니다.";
			}else if(cnt <= 0){
				message = "등록에 실패하였습니다.";
			}
			
			return ResultCode.builder()
	                .code(code)
	                .message(message)
	                .build();
	    }
    }
    
    //상세보기
    @GetMapping("/detail-weekday")
    public Map<String, Object> getWeekdayDetail(WeekdayDto weekday) {        
        weekday = weekdayService.getWeekdayDetail(weekday.getWdSeq());
        
        Map<String, Object> result = new HashMap<String, Object>();  
        result.put("weekday", weekday);
        return result;
    	
    }
    
    //수정 처리
    @RequestMapping("/update-weekday")
    public ResultCode getWeekdayModify(WeekdayDto weekday,HttpServletRequest request) {
		int cnt = weekdayService.getDataExistCheck(weekday.getWdSeq());
		
		if (cnt == 0) return ResultCode.builder()
                .code(400)
                .message("정보가 존재하지 않습니다.")
                .build();		
     	cnt = 0;
    	
     	try {
     		//업데이트
     		cnt = weekdayService.updateWeekday(weekday);
 		} catch (Exception e) {
 			return ResultCode.builder()
 	                .code(400)
 	                .message("수정에 실패했습니다.")
 	                .build();	
 		}

    		int code = cnt>0 ? 200 : 400;
    		String message = "";
		
		if(cnt>0) {
			message="수정에 성공하였습니다.";
		}else if(cnt==-1) {
			message = "설정된 기간이 중복됩니다.";
		}else if(cnt==-2) {
			message = "필수값이 미등록되었습니다.";
		}else {
			message = "수정에 실패하였습니다.";
		}
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
	}
    
    //삭제 처리
    @RequestMapping("/delete-weekday")
    public ResultCode getWeekdayDelete(WeekdayDto weekday,HttpServletRequest request) {

    	boolean result = true;
    	
     	try {
     		//사용자 업데이트
     		result = weekdayService.deleteWeekday(weekday.getWdSeq());
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