package com.hankook.pg.content.admin.weekday.dao;
 
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.admin.weekday.dto.WeekdayDto;
import com.hankook.pg.content.admin.weekday.dto.SearchWeekdayDto;

@Repository
@Mapper
public interface WeekdayDao {
	/* 목록*/
    List<WeekdayDto> getWeekdayList(SearchWeekdayDto search);

    /* 검색결과 갯수 반환 */
    int findWeekdayCount(SearchWeekdayDto search);
        
    /* 기간중복 여부유무 */
    int getDataExistCheck(Integer wkSeq);
    
    /* 기간중복 여부유무 */
    int getDuplCheck(WeekdayDto weekday);
        
    /* 등록*/
    int insertWeekday(WeekdayDto weekday);
    
    /* 상세보기 */
    WeekdayDto getWeekdayDetail(Integer wkSeq);
        
    /* 수정*/
    int updateWeekday(WeekdayDto weekday);
    
    /* 삭제*/
    int deleteWeekday(Integer wkSeq);
}