package com.hankook.pg.content.admin.statistics.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections4.map.HashedMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import com.hankook.pg.content.admin.statistics.dto.StatisticsVo;
import com.hankook.pg.content.admin.statistics.service.StatisticsService;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Search;

import lombok.extern.slf4j.Slf4j;


@RestController
@Slf4j
@RequestMapping("/admin/statistics")
public class StatisticsController {
	
	@Autowired
	StatisticsService statisticsService;
	
	@RequestMapping(value="",method= {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView getAuth() throws Exception {
		ModelAndView mv = new ModelAndView("/admin/statistics/statistics");
		return mv;
	}
	@RequestMapping(value="/search",method= {RequestMethod.GET,RequestMethod.POST})
	public Map<String,Object> getList(@RequestBody StatisticsVo vo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		
		String[] arrOrderCoulmn = { "day desc" };
		vo.setArrOrderColumn(arrOrderCoulmn);
		
		//기상통계 (기온,강수량) 화면
		List<StatisticsVo> temper = statisticsService.temper(vo);
		
		List<StatisticsVo> alltemper = statisticsService.alltemper(vo);
		
		//기상통계 (기온,강수량) 페이징
		int cnt = statisticsService.tempercnt(vo);
				
		// 페이징 처리
		Search search = new Search();
		search.setPageSize(10);
		search.setPageNo(vo.getPageNo());
		Paging paging = new Paging(search, cnt);
		
		map.put("paging", paging);
		map.put("totalCnt", cnt);
		
		map.put("temper", temper);
		map.put("alltemper", alltemper);
		
		return map;
	}
	
	///습도 기압
	@RequestMapping(value="/pressure",method= {RequestMethod.GET,RequestMethod.POST})
	public Map<String,Object> GetList(@RequestBody StatisticsVo vo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		
		String[] arrOrderCoulmn = { "day desc" };
		vo.setArrOrderColumn(arrOrderCoulmn);
		
		//기상통계 (기온,강수량) 화면
		List<StatisticsVo> pressure = statisticsService.pressure(vo);

		List<StatisticsVo> allpressure = statisticsService.allpressure(vo);
		
		//기상통계 (기온,강수량) 페이징
		int cnt = statisticsService.pressurecnt(vo);
				
		// 페이징 처리
		Search search = new Search();
		search.setPageSize(10);
		search.setPageNo(vo.getPageNo());
		Paging paging = new Paging(search, cnt);
		
		map.put("paging", paging);
		map.put("totalCnt", cnt);
		
		map.put("pressure", pressure);
		map.put("allpressure", allpressure);
		
		return map;
	}
	
	
	
	@GetMapping(value = "/stat-company", produces = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView company(ModelAndView mav, StatisticsVo vo) throws Exception {
		System.out.println("track first");
		mav.setViewName("/admin/statistics/statCompany");
				
		return mav;
	}
	
	@PostMapping("/statcompany")
	public Map<String, Object> statcompany(ModelAndView mav,@RequestBody StatisticsVo vo) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		System.out.println("stat-track list");
		
		String[] arrOrderCoulmn = {"tcDay desc"};
		vo.setArrOrderColumn(arrOrderCoulmn);
		
		// 트랙정보
		List<StatisticsVo> List = statisticsService.statcompany(vo);
		// 트랙전체 정보
		List<StatisticsVo> allList = statisticsService.nostatcompany(vo);

		// 토탈 카운트
		int cnt = statisticsService.statcompanycnt(vo);
		
		// 페이징 처리
		Search search = new Search();
		search.setPageSize(10);
		search.setPageNo(vo.getPageNo());
		Paging paging = new Paging(search, cnt);

		result.put("paging", paging);
		result.put("totalCnt", cnt);
		result.put("list", List);
		result.put("allList", allList);
		
		return result;
	}
	
	@GetMapping(value = "/inout", produces = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView input(ModelAndView mav, StatisticsVo vo) throws Exception {
		System.out.println("input first");
		mav.setViewName("/admin/statistics/input");
		
		return mav;
	}
	
	@PostMapping("/inout")
	public Map<String, Object> inputlog(ModelAndView mav,@RequestBody StatisticsVo vo) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		System.out.println("inputlog list");
		
		String[] arrOrderCoulmn = {"tcDay desc"};
		vo.setArrOrderColumn(arrOrderCoulmn);
		
		//정보
		List<StatisticsVo> List = statisticsService.daylog(vo);

		//정보 (전체)
		List<StatisticsVo> allList = statisticsService.nodaylog(vo);
		
		//토탈 카운트
		int cnt = statisticsService.daylogcnt(vo);

		// 페이징 처리
		Search search = new Search();
		search.setPageSize(10);
		search.setPageNo(vo.getPageNo());
		Paging paging = new Paging(search, cnt);

		result.put("paging", paging);
		result.put("totalCnt", cnt);
		result.put("list", List);
		result.put("alllist", allList);

		return result;
	}

	@GetMapping(value = "/temperature", produces = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView temperature(ModelAndView mav, StatisticsVo vo) throws Exception {
		System.out.println("temperature first");
		
		List<StatisticsVo> list = statisticsService.templist(vo);
		
		mav.addObject("list",list);
		mav.setViewName("/admin/statistics/temperature");
		
		return mav;
	}
	
	@PostMapping("/temperature1")
	public Map<String, Object> temperaturelog(ModelAndView mav,@RequestBody StatisticsVo vo) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		System.out.println("temperaturelog list");
		
		//노면 온도 일별 (15분단위)(y축)(데이터)
		System.out.println(vo.getTId());
		List<StatisticsVo> List = statisticsService.tempday(vo);
		
		//노면온도 엑셀(5분단위)
		List<StatisticsVo> excel = statisticsService.tempexceldown(vo);
		
		result.put("list", List);
		result.put("excel", excel);
		
		return result;
	}
	
	@GetMapping(value = "/stat-shop", produces = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView statshop(ModelAndView mav, StatisticsVo vo) throws Exception {
		System.out.println("track first");
		mav.setViewName("/admin/statistics/statshop");
		
		return mav;
	}
	
	@PostMapping("/statshop")
	public Map<String, Object> statshops(ModelAndView mav,@RequestBody StatisticsVo vo) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		System.out.println("stat-shop list");
		System.out.println("dddd : "+vo);
		System.out.println("dddd : "+vo.getWssEdDay());

		String[] arrOrderCoulmn = {"wssStDay desc"};
		vo.setArrOrderColumn(arrOrderCoulmn);
		
		// 트랙정보
		List<StatisticsVo> trackList = statisticsService.statshop(vo);
		
		// 트랙정보 전체
		List<StatisticsVo> allList = statisticsService.nostatshop(vo);

		// 토탈 카운트
		int cnt = statisticsService.statshopcnt(vo);

		// 페이징 처리
		Search search = new Search();
		search.setPageSize(10);
		search.setPageNo(vo.getPageNo());
		Paging paging = new Paging(search, cnt);

		result.put("paging", paging);
		result.put("totalCnt", cnt);
		result.put("list", trackList);
		result.put("allist", allList);


		return result;
	}

	@GetMapping(value = "/stat-track", produces = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView stattrack(ModelAndView mav, StatisticsVo vo) throws Exception {
		System.out.println("track first");
		
		//select박스
		List<StatisticsVo> track = statisticsService.tracklist(vo);
		
		mav.addObject("track",track);
		mav.setViewName("/admin/statistics/statTrack");
		
		
		return mav;
	}
	
	
	@PostMapping(value = "/stat-track")
	public Map<String, Object> stat_track(ModelAndView mav,@RequestBody StatisticsVo vo) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		System.out.println("stat-track list");
		
		String[] arrOrderCoulmn = {"tcDay desc"};
		vo.setArrOrderColumn(arrOrderCoulmn);
		
		// 트랙정보
		List<StatisticsVo> List = statisticsService.trackinfo(vo);
		
		//트랙정보 (전체)
		List<StatisticsVo> allList = statisticsService.notrackinfo(vo);

		// 토탈 카운트
		int cnt = statisticsService.trackcnt(vo);

		// 페이징 처리
		Search search = new Search();
		search.setPageSize(10);
		search.setPageNo(vo.getPageNo());
		Paging paging = new Paging(search, cnt);

		result.put("paging", paging);
		result.put("totalCnt", cnt);
		result.put("list", List);
		result.put("alllist", allList);
		
		
		return result;
	}
	

	@GetMapping(value = "/oil", produces = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView oilday(ModelAndView mav, StatisticsVo vo) throws Exception {
		System.out.println("track first");
		mav.setViewName("/admin/statistics/oilDay");
		return mav;
	}
	
	@PostMapping(value = "/oillist", produces = MediaType.APPLICATION_JSON_VALUE)
	public Map<String, Object> oilList(@RequestBody StatisticsVo vo) throws Exception{
		Map<String, Object> result = new HashedMap<String, Object>();
		System.out.println("oillist");
		
		String[] arrOrderCoulmn = {"pumpEnd desc"};
		vo.setArrOrderColumn(arrOrderCoulmn);
		
		//일별 주유량 정보
		List<StatisticsVo> oil = statisticsService.oillist(vo);
		
		//일별 주유량 정보(전체)
		List<StatisticsVo> alloil = statisticsService.alloillist(vo);
		
		String daydtotal = statisticsService.dayd(vo);
		String daygtotal = statisticsService.dayg(vo);
		
		// 토탈 카운트
		int cnt = statisticsService.oillistcnt(vo);

		// 페이징 처리
		Search search = new Search();
		search.setPageSize(10);
		search.setPageNo(vo.getPageNo());
		Paging paging = new Paging(search, cnt);

		result.put("paging", paging);
		result.put("totalCnt", cnt);
		
		result.put("list", oil);
		result.put("alllist", alloil);
		result.put("daydtotal", daydtotal);
		result.put("daygtotal", daygtotal);
		
		return result;
	}
	
	@PostMapping(value = "/monthList", produces = MediaType.APPLICATION_JSON_VALUE)
	public Map<String, Object> monthList(@RequestBody StatisticsVo vo) throws Exception{
		Map<String, Object> result = new HashedMap<String, Object>();
		System.out.println("monthList");
		
		String[] arrOrderCoulmn = {"pumpEnd desc"};
		vo.setArrOrderColumn(arrOrderCoulmn);
		
		//월별 주유량 정보
		List<StatisticsVo> month = statisticsService.month(vo);
		
		//월별 주유량 정보(전체)
		List<StatisticsVo> allmonth = statisticsService.allmonth(vo);
		
		String monthgtotal = statisticsService.monthg(vo);
		String monthdtotal = statisticsService.monthd(vo);
		
		// 토탈 카운트
		int cnt = statisticsService.monthcnt(vo);

		// 페이징 처리
		Search search = new Search();
		search.setPageSize(10);
		search.setPageNo(vo.getPageNo());
		Paging paging = new Paging(search, cnt);

		result.put("paging", paging);
		result.put("totalCnt", cnt);
		
		result.put("list", month);
		result.put("alllist", allmonth);
		result.put("monthgtotal", monthgtotal);
		result.put("monthdtotal", monthdtotal);
		
		
		return result;
	}
	
	
	@GetMapping(value = "/carSection")
	public ModelAndView carSection(ModelAndView mav) throws Exception {
		mav.setViewName("/admin/statistics/carSection");
		return mav;
	}
	
	@PostMapping(value = "/carSectionlist", produces = MediaType.APPLICATION_JSON_VALUE)
	public Map<String, Object> carSectionlist(@RequestBody StatisticsVo vo) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		List<StatisticsVo> carsection = statisticsService.carsection(vo);
		result.put("carsection", carsection);
		return result;
	}
	
}
