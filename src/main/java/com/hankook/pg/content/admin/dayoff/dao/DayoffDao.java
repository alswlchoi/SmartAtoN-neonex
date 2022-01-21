package com.hankook.pg.content.admin.dayoff.dao;
 
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.admin.dayoff.dto.DayoffDto;
import com.hankook.pg.content.admin.dayoff.dto.SearchDayoffDto;

@Repository
@Mapper
public interface DayoffDao {
	/* 목록*/
	List<DayoffDto> getDayoffList(SearchDayoffDto searchDayoff) throws Exception;

    /* 검색결과 갯수 반환 */
    int getDayoffCount(SearchDayoffDto searchDayoff) throws Exception;

    /* 기간중복 여부유무 */
    int getDayoffDuplCheck(DayoffDto dayoff) throws Exception;
    
    /* 등록*/
    int insertDayoff(DayoffDto dayoff) throws Exception;
    
    /* 수정*/
    int updateDayoff(DayoffDto dayoff) throws Exception;
    
    /* 삭제*/
    int deleteDayoff(DayoffDto dayoff) throws Exception;
}