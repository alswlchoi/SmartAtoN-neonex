package com.hankook.pg.content.admin.statistics.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.admin.statistics.dto.StatisticsVo;

@Repository
@Mapper
public interface StatisticsDao {
	//통계-시험로별 이용이력 (전체)
    List<StatisticsVo> notrackinfo(StatisticsVo statisticsVo) throws Exception;
	
    //통계-시험로별 이용이력
    List<StatisticsVo> trackinfo(StatisticsVo statisticsVo) throws Exception;
    
    //통계-시험로별 이용이력 -페이징
    int trackcnt(StatisticsVo statisticsVo) throws Exception;
    
    //통계-시험로별 이용이력 - 리스트 불러오기
    List<StatisticsVo> tracklist(StatisticsVo statisticsVo) throws Exception;
    
    //통계-회원사별 시험이력 - 시험로 (전체)
    List<StatisticsVo> nostatcompany(StatisticsVo statisticsVo) throws Exception;
    
    //통계-회원사별 시험이력 - 시험로
    List<StatisticsVo> statcompany(StatisticsVo statisticsVo) throws Exception;

    //통계-회원사별 시험이력 - 시험로 - 페이징
    int statcompanycnt(StatisticsVo statisticsVo) throws Exception;
    
    //통계-회원사별 시험이력 - 부대시설 (전체)
    List<StatisticsVo> nostatshop(StatisticsVo statisticsVo) throws Exception;
    
    //통계-회원사별 시험이력 - 부대시설
    List<StatisticsVo> statshop(StatisticsVo statisticsVo) throws Exception;
    
    //기상통계 - 노면온도 리스트
    List<StatisticsVo> templist(StatisticsVo statisticsVo) throws Exception;
    
    //통계-회원사별 시험이력 - 부대시설 - 페이징
    int statshopcnt(StatisticsVo statisticsVo) throws Exception;
    
    //일자별 출입로그 (전체)
    List<StatisticsVo> nodaylog(StatisticsVo statisticsVo) throws Exception;
    
    //일자별 출입로그 
    List<StatisticsVo> daylog(StatisticsVo statisticsVo) throws Exception;

    //일자별 출입로그 - 페이징
    int daylogcnt(StatisticsVo statisticsVo) throws Exception;
    
    //기상통계 (기온,강수량)
    List<StatisticsVo> temper(StatisticsVo statisticsVo) throws Exception;
    
    //기상통계 페이징 (기온,강수량)
    int tempercnt(StatisticsVo statisticsVo) throws Exception;
    
    //기상통계 (습도,기압)
    List<StatisticsVo> pressure(StatisticsVo statisticsVo) throws Exception;
    
    //기상통계 페이징 (습도,기압)
    int pressurecnt(StatisticsVo statisticsVo) throws Exception;	
    
    //기상통계 전체 (기온,강수량)
    List<StatisticsVo> alltemper(StatisticsVo statisticsVo) throws Exception;

    //기상통계 전체 (습도,기압)
    List<StatisticsVo> allpressure(StatisticsVo statisticsVo) throws Exception;
    
    //노면 온도 일별 (15분단위)
    List<StatisticsVo> tempday(StatisticsVo statisticsVo) throws Exception;

    //노면 온도 월별 (15분단위)
    List<StatisticsVo> tempmonth(StatisticsVo statisticsVo) throws Exception;
    
    //노면 온도 일별 (15분단위)
    List<StatisticsVo> tempyear(StatisticsVo statisticsVo) throws Exception;
    
	//노면 온도 엑셀 다운로드 (5분단위)
    List<StatisticsVo> tempexceldown(StatisticsVo statisticsVo) throws Exception;
    
    //주유 통계 차량별 조회
    List<StatisticsVo> carsection(StatisticsVo statisticsVo) throws Exception;

    //주유 오일 합계
    List<StatisticsVo> carsectionsum(StatisticsVo statisticsVo) throws Exception;
    
    //주유통계 기간별(다운로드)
    List<StatisticsVo> alloillist(StatisticsVo statisticsVo) throws Exception;

    //주유통계 기간별
    List<StatisticsVo> oillist(StatisticsVo statisticsVo) throws Exception;

    //주유통계 기간별 페이징
    int oillistcnt(StatisticsVo statisticsVo) throws Exception;
    
    //주유통계 기간별(다운로드)
    List<StatisticsVo> allmonth(StatisticsVo statisticsVo) throws Exception;
    
    //주유통계 기간별
    List<StatisticsVo> month(StatisticsVo statisticsVo) throws Exception;
    
    //주유통계 기간별 페이징
    int monthcnt(StatisticsVo statisticsVo) throws Exception;
    
    //일별 합계
    String dayg(StatisticsVo statisticsVo) throws Exception;

    //일별 합계
    String dayd(StatisticsVo statisticsVo) throws Exception;
    
    //월별 합계
    String monthg(StatisticsVo statisticsVo) throws Exception;
    
    //월별 합계
    String monthd(StatisticsVo statisticsVo) throws Exception;
}
