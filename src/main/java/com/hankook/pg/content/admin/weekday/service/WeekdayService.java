package com.hankook.pg.content.admin.weekday.service;
 
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.admin.weekday.dao.WeekdayDao;
import com.hankook.pg.content.admin.weekday.dto.SearchWeekdayDto;
import com.hankook.pg.content.admin.weekday.dto.WeekdayDto;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Results;

@Service
public class WeekdayService{
    
    @Autowired
    private WeekdayDao weekdayDao;
    
      
    public Map<String, Object> getWeekdayList(SearchWeekdayDto searchWeekday) {
    	//기간 날짜포맷 맞춤
    	String searchDay = Fn.toDateFormat(searchWeekday.getSearchDay(), "yyyyMMdd");
    	searchWeekday.setSearchDay(searchDay);

    	searchWeekday.setStartRowNum((searchWeekday.getPageNo()-1)*10);
    	List<WeekdayDto> weekdayList = weekdayDao.getWeekdayList(searchWeekday);
    	
        Paging paging = new Paging(searchWeekday, weekdayDao.findWeekdayCount(searchWeekday));
        
        return Results.grid(paging, weekdayList);
    }
    
    public Integer getDataExistCheck(Integer wkSeq){
    	return weekdayDao.getDataExistCheck(wkSeq);
    }
    
    public Integer insertWeekday(WeekdayDto weekday) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();
		
    	String wdCon = Fn.toString(weekday.getWdCon(), "1");		//들어온 값 없으면 정상 default로 설정
    	weekday.setWdCon(wdCon);
    	//기간 날짜포맷 맞춤

    	Integer result_cnt = 0;
    	Integer cnt = 0;

    	if(weekday.getWdKind().equals("t")||weekday.getWdKind().equals("b")) {
    		result_cnt = weekdayDao.getDuplCheck(weekday);
    		
    	}
    	
    	if(result_cnt>0) {
    		cnt = -3;
    	}else {
	    	//유효성 체크 (조건 미충족시 -2 return
	    	if(weekday.getWdDay().length()==0 || weekday.getWdStDt().length()==0) {	//필수값 미등록시
	    		cnt = -2;    		
	    	}
			
			String days[] = weekday.getWdStDt().split("~");	// ~ 구분자로 시작일과 마감일 분리, 형식 안 맞으면 insert 안 됨
			if(days.length==2) {
				String wdStDt = days[0];	//시작일
				String wdEdDt = days[1];	//마감일
				//형식에 맞게 처리 해 줌
				wdStDt = Fn.toDateFormat(wdStDt, "yyyyMMdd");
				wdEdDt = Fn.toDateFormat(wdEdDt, "yyyyMMdd");
	
				weekday.setWdStDt(wdStDt);
				weekday.setWdEdDt(wdEdDt);
	
		    	
				//중복된 기간의 데이터가 존재한다면 cnt값을 -1로 반환
				result_cnt = weekdayDao.getDuplCheck(weekday);
				
				if(result_cnt > 0) {
					cnt = -1;
				}else {				
			    	Date date_now = new Date(System.currentTimeMillis());
			    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
			    	weekday.setWdRegDt(currentTime);
			    	
			    	weekday.setWdRegUser(memberDto.getMemId());
			    	cnt = weekdayDao.insertWeekday(weekday);
				}
		    }
    	}
    	
		return cnt;
    }
     
    public WeekdayDto getWeekdayDetail(Integer wkSeq) {
    	return weekdayDao.getWeekdayDetail(wkSeq);
    }
     
    public Integer updateWeekday(WeekdayDto weekday) {
    	/* 로그인 정보 가져옴 */
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();

    	Integer result_cnt = 0;
    	Integer cnt = 0;

    	//유효성 체크 (조건 미충족시 -2 return
    	if(weekday.getWdDay().length()==0 || weekday.getWdStDt().length()==0) {	//필수값 미등록시
    		cnt = -2;    		
    	}
    	String days[] = weekday.getWdStDt().split("~");	// ~ 구분자로 시작일과 마감일 분리, 형식 안 맞으면 insert 안 됨

    	if(days.length==2) {
			String wdStDt = days[0];	//시작일
			String wdEdDt = days[1];	//마감일
			//형식에 맞게 처리 해 줌
			wdStDt = Fn.toDateFormat(wdStDt, "yyyyMMdd");
			wdEdDt = Fn.toDateFormat(wdEdDt, "yyyyMMdd");

			weekday.setWdStDt(wdStDt);
			weekday.setWdEdDt(wdEdDt);

	    	
			//중복된 기간의 데이터가 존재한다면 cnt값을 -1로 반환
			result_cnt = weekdayDao.getDuplCheck(weekday);
			
			if(result_cnt > 0) {
				cnt = -1;
			}else {			    	
	
		    	/* 현재 시간 설정 */
		    	Date date_now = new Date(System.currentTimeMillis());
		    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
		    	weekday.setWdModDt(currentTime);
		    	weekday.setWdModUser(memberDto.getMemId());
		    	
		    	cnt = weekdayDao.updateWeekday(weekday);
		    }
    	}
	
	
    	return cnt;
    }
       
    public boolean deleteWeekday(Integer wkSeq) {
    	int cnt = weekdayDao.deleteWeekday(wkSeq); 
    	return cnt > 0;
    }
}

