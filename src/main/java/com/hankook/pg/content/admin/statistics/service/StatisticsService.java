package com.hankook.pg.content.admin.statistics.service;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections4.map.HashedMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.hankook.pg.content.admin.statistics.dao.StatisticsDao;
import com.hankook.pg.content.admin.statistics.dto.StatisticsVo;


@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class StatisticsService{
	
	@Autowired
	private StatisticsDao statisticsDao;
	
	//통계-시험로별 이용이력 (전체)
    public List<StatisticsVo> notrackinfo(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.notrackinfo(statisticsVo);
    }
	
	//통계-시험로별 이용이력
    public List<StatisticsVo> trackinfo(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.trackinfo(statisticsVo);
    }
    
    //통계-시험로별 이용이력 -페이징
    public int trackcnt(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.trackcnt(statisticsVo);
    }
    
    //통계-시험로별 이용이력 - 리스트 불러오기
    public List<StatisticsVo> tracklist(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.tracklist(statisticsVo);
    }
    
    //통계-회원사별 시험이력 - 시험로(전체)
    public List<StatisticsVo> nostatcompany(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.nostatcompany(statisticsVo);
    }
    
    //통계-회원사별 시험이력 - 시험로
    public List<StatisticsVo> statcompany(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.statcompany(statisticsVo);
    }
    
    //통계-회원사별 시험이력 - 시험로 - 페이징
    public int statcompanycnt(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.statcompanycnt(statisticsVo);
    }
    
    //통계-회원사별 시험이력 - 부대시설 (전체)
    public List<StatisticsVo> nostatshop(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.nostatshop(statisticsVo);
    }
    
    //통계-회원사별 시험이력 - 부대시설
    public List<StatisticsVo> statshop(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.statshop(statisticsVo);
    }
    
    //기상통계 - 노면온도 리스트
    public List<StatisticsVo> templist(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.templist(statisticsVo);
    }
    
    //통계-회원사별 시험이력 - 부대시설 - 페이징
    public int statshopcnt(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.statshopcnt(statisticsVo);
    }
    
    //일자별 출입로그 (전체) 
    public List<StatisticsVo> nodaylog(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.nodaylog(statisticsVo);
    }

    //일자별 출입로그 
    public List<StatisticsVo> daylog(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.daylog(statisticsVo);
    }

    //일자별 출입로그 - 페이징
    public int daylogcnt(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.daylogcnt(statisticsVo);
    }
    
    //기상통계 (기온,강수량)
    public List<StatisticsVo> temper(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.temper(statisticsVo);
    }
    
    //기상통계 (기온,강수량) 페이징
    public int tempercnt(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.tempercnt(statisticsVo);
    }
    
    //기상통계 (습도,기압)
    public List<StatisticsVo> pressure(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.pressure(statisticsVo);
    }
    
    //기상통계 (습도,기압) 페이징
    public int pressurecnt(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.pressurecnt(statisticsVo);
    }
    
    //기상통계 (기온,강수량) 전체
    public List<StatisticsVo> alltemper(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.alltemper(statisticsVo);
    }
    //기상통계 (습도,기압) 전체
    public List<StatisticsVo> allpressure(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.allpressure(statisticsVo);
    }
    
        
    //노면 온도 일별 (15분단위)
    public List<StatisticsVo> tempday(StatisticsVo statisticsVo) throws Exception{
    	
    	if(statisticsVo.getDate().equals("day")) {
    		return statisticsDao.tempday(statisticsVo);
    	}else if(statisticsVo.getDate().equals("week")) {
    		System.out.println("wwwwww" + statisticsVo.getDate());
    		return statisticsDao.tempmonth(statisticsVo);
    	}else {
    		System.out.println("yyyyyyy" + statisticsVo.getDate());
    		return statisticsDao.tempyear(statisticsVo);
    	}
    }
    
	//노면 온도 엑셀 다운로드 (5분단위)
    public List<StatisticsVo> tempexceldown (StatisticsVo statisticsVo) throws Exception {
    	return statisticsDao.tempexceldown(statisticsVo);
    }
    
    //주유 통계 차량별 조회
    public List<StatisticsVo> carsection(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.carsection(statisticsVo);
    }
    
    //주유 오일 합계
    public List<StatisticsVo> carsectionsum(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.carsectionsum(statisticsVo);
    }
    
    //주유 통계 기간별
    public List<StatisticsVo> alloillist(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.alloillist(statisticsVo);
    }
    
    //주유 통계 기간별
    public List<StatisticsVo> oillist(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.oillist(statisticsVo);
    }
    
    //주유 통계 기간별 페이징
    public int oillistcnt(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.oillistcnt(statisticsVo);
    }
    
    //주유 통계 기간별
    public List<StatisticsVo> allmonth(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.allmonth(statisticsVo);
    }
    
    //주유 통계 기간별
    public List<StatisticsVo> month(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.month(statisticsVo);
    }
    
    //주유 통계 기간별 페이징
    public int monthcnt(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.monthcnt(statisticsVo);
    }
    
    //일별 합계
    public String dayg(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.dayg(statisticsVo);
    }
    
    //일별 합계
    public String dayd(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.dayd(statisticsVo);
    }
    
    //월별 합계
    public String monthg(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.monthg(statisticsVo);
    }

    //월별 합계
    public String monthd(StatisticsVo statisticsVo) throws Exception{
    	return statisticsDao.monthd(statisticsVo);
    }
}
