package com.hankook.pg.content.admin.dayoff.controller;
 
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.hankook.pg.content.admin.dayoff.dto.DayoffDto;
import com.hankook.pg.content.admin.dayoff.dto.SearchDayoffDto;
import com.hankook.pg.content.admin.dayoff.service.DayoffService;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.ResultCode;
import com.hankook.pg.share.Search;

@RestController
@RequestMapping("/admin/dayoff")
public class DayoffController {
 
    @Autowired
    DayoffService dayoffService;

    

    
    /******************************************
     * 
     * 휴일 목록 조회(초기화면 조회)
     *
     * @Date   : 2021. 7. 19.
     * @Method : getDayoffs
     * @return : ModelAndView
     ******************************************/
    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ModelAndView getDayoffs(SearchDayoffDto searchDayoff, ModelAndView mav) throws Exception {
    	
    	//검색년도값 없을 경우 현재년도로 설정
    	//if(searchDayoff.getSearchYear()==null) {
    	//	searchDayoff.setSearchYear(Fn.getYear()+"");
    	//}
        //조회
    	Map<String, Object> dayoffList = dayoffService.getDayoffMap(searchDayoff);
        
        //페이징 처리
        Search search = new Search();
        search.setPageNo(1);
        search.setPageSize(10);
        Paging paging = new Paging(search, (Integer)dayoffList.get("records"));

    	//갯수
        mav.addObject("paging", paging);
        mav.addObject("dayoffList",dayoffList);
        mav.addObject("totalCnt", dayoffList.get("records").toString());
        
        mav.setViewName("/admin/dayoff/dayoff");
    	
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
    @GetMapping(value = "/search-dayoff", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public Map<String, Object> getSearch(SearchDayoffDto searchDayoff) throws Exception {

    	Map<String, Object> dayoffList = dayoffService.getDayoffMap(searchDayoff);
        
        return dayoffList;
    }

    /******************************************
     * 
     * 등록
     *
     * @Date   : 2021. 7. 19.
     * @Method : getSearch
     * @return : ResultCode
     ******************************************/
	@RequestMapping(value = "/insert-dayoff", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode insertDayoff(DayoffDto dayoff) throws Exception {

    	boolean result = false;

		try {
			// 등록
	    	result = dayoffService.insertDayoff(dayoff);
		} catch (Exception e) {
			return ResultCode.builder()
                   .code(500)
                   .message("(500) 등록에 실패하였습니다.")
                   .build();
		}
		
		int code = result ? 200 : 400;
		String message = result ? "등록에 성공하였습니다." : "("+result+") 등록에 실패하였습니다.";
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    }

    //수정 처리
	@RequestMapping(value = "/update-dayoff", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode getDayoffModify(DayoffDto dayoff) throws Exception {
     	boolean result = true;
	
    	try {
     		//업데이트
     		result = dayoffService.updateDayoff(dayoff);
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
    @RequestMapping(value="/delete-dayoff", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode getDayoffDelete(DayoffDto dayoff) {

    	boolean result = true;

    	try {
     		//삭제
     		result = dayoffService.deleteDayoff(dayoff);
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