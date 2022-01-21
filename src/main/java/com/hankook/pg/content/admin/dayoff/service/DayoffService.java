package com.hankook.pg.content.admin.dayoff.service;
 
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.admin.dayoff.dao.DayoffDao;
import com.hankook.pg.content.admin.dayoff.dto.DayoffDto;
import com.hankook.pg.content.admin.dayoff.dto.SearchDayoffDto;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Results;

@Service
public class DayoffService {
    
    @Autowired
    private DayoffDao dayoffDao;
    
	/* 목록 */
	public List<DayoffDto> getDayoffList(SearchDayoffDto searchDayoff) throws Exception {
		List<DayoffDto> dayoffList = dayoffDao.getDayoffList(searchDayoff);
    	        
        return dayoffList;
    }
    
	/* 목록 */
	public Map<String, Object> getDayoffMap(SearchDayoffDto searchDayoff) throws Exception {
		List<DayoffDto> dayoffList = dayoffDao.getDayoffList(searchDayoff);
    	
        Paging paging = new Paging(searchDayoff, dayoffDao.getDayoffCount(searchDayoff));

        return Results.grid(paging, dayoffList);
    }

	//검색용
	public Integer getDayoffCount(SearchDayoffDto searchDayoff) throws Exception {
		return dayoffDao.getDayoffCount(searchDayoff);
	}
	
    /* 등록 */
	public boolean insertDayoff(DayoffDto dayoff) throws Exception {
		
		Integer cnt = 0;
		
		if(null!=dayoff.getDoStDay()) {	//null일경우 처리 불가 
			String days[] = dayoff.getDoStDay().split("~");	// ~ 구분자로 시작일과 마감일 분리
			if(days.length==2 || dayoff.getDoName().length()>0) {
				String doStDay = days[0];	//시작일
				String doEdDay = days[1];	//마감일
				//형식에 맞게 처리 해 줌
				doStDay = Fn.toDateFormat(doStDay, "yyyyMMdd");
				doEdDay = Fn.toDateFormat(doEdDay, "yyyyMMdd");
				dayoff.setDoStDay(doStDay);
				dayoff.setDoEdDay(doEdDay);
				

		    	//기간 중복여부 판단
		    	Integer duplCnt = dayoffDao.getDayoffDuplCheck(dayoff);
		    	if (duplCnt > 0) {		//중복된 기간의 데이터가 존재한다면 cnt값을 -1로 반환
		    		cnt = -1;
		    	} else {
		    		cnt = dayoffDao.insertDayoff(dayoff);
		    	}
			}
		}
		return cnt > 0;
	}
	
	/* 수정 */
	public boolean updateDayoff(DayoffDto dayoff) throws Exception {
		String days[] = dayoff.getDoStDay().split("~");	// ~ 구분자로 시작일과 마감일 분리
		
		int cnt = 0;
		if(days.length==2 && dayoff.getDoName().length()>0) {
			String doStDay = days[0];	//시작일
			String doEdDay = days[1];	//마감일
			//형식에 맞게 처리 해 줌
			doStDay = Fn.toDateFormat(doStDay, "yyyyMMdd");
			doEdDay = Fn.toDateFormat(doEdDay, "yyyyMMdd");
			dayoff.setDoStDay(doStDay);
			dayoff.setDoEdDay(doEdDay);

			cnt = dayoffDao.updateDayoff(dayoff);
		}
		return cnt > 0;
	}
	
	/* 삭제 */
	public boolean deleteDayoff(DayoffDto dayoff) throws Exception {		
		int cnt = dayoffDao.deleteDayoff(dayoff);		
		return cnt > 0;
	}
}