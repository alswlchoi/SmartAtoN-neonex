package com.hankook.pg.content.admin.trReserve.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.admin.car.dto.CarDto;
import com.hankook.pg.content.admin.company.dto.CompanyDto;
import com.hankook.pg.content.admin.company.service.CompanyService;
import com.hankook.pg.content.admin.dayoff.dto.DayoffDto;
import com.hankook.pg.content.admin.dayoff.dto.SearchDayoffDto;
import com.hankook.pg.content.admin.dayoff.service.DayoffService;
import com.hankook.pg.content.admin.trReserve.dto.ChargeDto;
import com.hankook.pg.content.admin.trReserve.dto.ResourceMappingDto;
import com.hankook.pg.content.admin.trReserve.dto.SearchTrReserveDto;
import com.hankook.pg.content.admin.trReserve.dto.TrReserveDto;
import com.hankook.pg.content.admin.trReserve.dto.TrRfidDto;
import com.hankook.pg.content.admin.trReserve.dto.TrRfidGnrDto;
import com.hankook.pg.content.admin.trReserve.dto.TrackDto;
import com.hankook.pg.content.admin.trReserve.service.TrReserveService;
import com.hankook.pg.content.admin.weekday.dto.WeekdayDto;
import com.hankook.pg.content.user.myPageCalculate.service.CalService;
import com.hankook.pg.content.user.userShop.service.UserShopService;
import com.hankook.pg.content.user.userShop.vo.UserShopVo;
import com.hankook.pg.content.admin.trReserve.dto.Paging;
import com.hankook.pg.share.ResultCode;
import com.hankook.pg.share.Search;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/admin/trReserve")
public class TrReserveController {

	@Autowired
	TrReserveService trReserveService;

	@Autowired
	CompanyService companyService;

	@Autowired
	DayoffService dayoffService;

	@Autowired
	CalService calService;

	@Autowired
	UserShopService userShopService;

	//@Value("${environments.hes-api-uri}")
	//private String hesApiUri;
	
	/******************************************
	 *
	 * 예약내역(초기 화면)
	 *
	 * @Date : 2021. 7. 20.
	 * @Method : getTrReserves
	 * @return : ModelAndView
	 ******************************************/
	@GetMapping("")
	public ModelAndView getTrReserves(ModelAndView mav, SearchTrReserveDto searchTrReserve) throws Exception {

		searchTrReserve.setPageNo(1);
		if (null == searchTrReserve.getTcApproval() || searchTrReserve.getTcApproval() == "") {
			searchTrReserve.setTcApproval("0");
		}
		// 예약내역 조회
		Map<String, Object> trReserveList = trReserveService.getTrReserveList(searchTrReserve);

		// 트랙정보
		List<TrackDto> trackList = trReserveService.getTrackList("Y");

		// 페이징 처리
		Search search = new Search();
		search.setPageNo(1);
		search.setPageSize(searchTrReserve.getPageSize());;
		Paging paging = new Paging(search, (Integer) trReserveList.get("records"));

		// 변수 설정
		mav.addObject("paging", paging);
		mav.addObject("trReserveList", trReserveList);
		mav.addObject("trackList", trackList);
		mav.addObject("tcApproval", searchTrReserve.getTcApproval());
		mav.addObject("totalCnt", trReserveList.get("records").toString());

		mav.setViewName("/admin/trReserve/trReserve");

		return mav;
	}

	@GetMapping("/search-trReserve")
	public Map<String, Object> getSearch(SearchTrReserveDto searchTrReserve) throws Exception {
		Map<String, Object> trReserveList = trReserveService.getTrReserveList(searchTrReserve);
		// 페이징 처리
		Search search = new Search();
		search.setPageNo(searchTrReserve.getPageNo());
		search.setPageSize(searchTrReserve.getPageSize());
		Paging paging = new Paging(search, (Integer) trReserveList.get("records"));

		trReserveList.put("totalCnt", trReserveList.get("records").toString());
		trReserveList.put("paging", paging);
		return trReserveList;
	}

	@GetMapping("/trcalendar")
	public ModelAndView trCalendar(ModelAndView mav, HttpServletRequest request, DateData dateData) throws Exception {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

		if (authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		} else {
			String viewKind = Fn.toString(request, "viewKind");
			String tcApproval = "";
			if (viewKind.equals("detail")) { // 예약관리의 시험예약상세보기 요청인 경우 달력만 보여줌
				mav.setViewName("/admin/trReserve/trCalendarOnly");
			} else {
				mav.setViewName("/admin/trReserve/trCalendar");
				tcApproval = "3";
			}
			Calendar cal = Calendar.getInstance();
			DateData calendarData;
			// 검색 날짜
			if (dateData.getDate().equals("") && dateData.getMonth().equals("")) {
				dateData = new DateData(String.valueOf(cal.get(Calendar.YEAR)), String.valueOf(cal.get(Calendar.MONTH)),
						String.valueOf(cal.get(Calendar.DATE)), null, null, null, null);
			}
			// 검색 날짜 end

			Map<String, Integer> today_info = dateData.today_info(dateData);
			List<DateData> dateList = new ArrayList<DateData>();

			// 실질적인 달력 데이터 리스트에 데이터 삽입 시작.
			// 일단 시작 인덱스까지 아무것도 없는 데이터 삽입
			for (Integer i = 1; i < today_info.get("start"); i++) {
				calendarData = new DateData(null, null, null, null, null, null, null);
				dateList.add(calendarData);
			}

			SearchTrReserveDto searchTrReserve = new SearchTrReserveDto();
			String dateStr = "";

			String trTrackType = Fn.toString(request, "reqTrackType");
			String compType = Fn.toString(request, "reqCompType");
			String trTrackCode = Fn.toString(request, "reqTrackCode");
			searchTrReserve.setTcApproval(tcApproval);
			searchTrReserve.setTrTrackType(trTrackType);
			searchTrReserve.setCompType(compType);
			searchTrReserve.setTrTrackCode(trTrackCode);

			// 날짜 삽입
			for (Integer i = today_info.get("startDay"); i <= today_info.get("endDay"); i++) {

				if (i == today_info.get("today")) {
					calendarData = new DateData(String.valueOf(dateData.getYear()), String.valueOf(dateData.getMonth()),
							String.valueOf(i), "today", "", "", "");
				} else {
					calendarData = new DateData(String.valueOf(dateData.getYear()), String.valueOf(dateData.getMonth()),
							String.valueOf(i), "normal_date", null, null, null);
				}

				dateStr = calendarData.getYear() + Fn.addZero(Fn.toInt(calendarData.getMonth()) + 1)
						+ Fn.addZero(calendarData.getDate());
				searchTrReserve.setTcDay(dateStr);

				Map<String, String> result = trReserveService.selectTrCalendar(searchTrReserve);
				calendarData.setSchedule_detail(result.get("trContent"));
				calendarData.setSchedule(result.get("cnt"));
				calendarData.setStrCnt(result.get("strCnt"));

				dateList.add(calendarData);
			}

			// 달력 빈곳 빈 데이터로 삽입
			Integer index = 7 - dateList.size() % 7;

			if (dateList.size() % 7 != 0) {

				for (Integer i = 1; i <= index; i++) {
					calendarData = new DateData(String.valueOf(dateData.getYear()), String.valueOf(dateData.getMonth()),
							String.valueOf(i), "not_month", "", "", "");
					dateList.add(calendarData);
				}
			}

			// 배열에 담음
			mav.addObject("dateList", dateList); // 날짜 데이터 배열
			mav.addObject("today_info", today_info);
			mav.addObject("reqTrackType", trTrackType);
			mav.addObject("reqCompType", compType);
			mav.addObject("reqTrackCode", trTrackCode);
			mav.addObject("viewKind", viewKind);
		}
		return mav;
	}

	@GetMapping("/trlist")
	public ModelAndView trList(ModelAndView mav, SearchTrReserveDto searchTrReserve) throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

		if (authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		} else {
			searchTrReserve.setPageNo(searchTrReserve.getPageNo());

			// 완료된 목록만 가져옴
			searchTrReserve.setTcApproval("3");
			searchTrReserve.setTcStep("0");

			// 예약내역 조회
			Map<String, Object> trReserveList = trReserveService.getTrReserveList(searchTrReserve);

			// 트랙정보
			List<TrackDto> trackList = trReserveService.getTrackList("Y");

			// 페이징 처리
			Search search = new Search();
			search.setPageNo(searchTrReserve.getPageNo());
			search.setPageSize(searchTrReserve.getPageSize());
			Paging paging = new Paging(search, (Integer) trReserveList.get("records"));

			// 변수 설정
			mav.addObject("paging", paging);
			mav.addObject("trReserveList", trReserveList);
			mav.addObject("trackList", trackList);
			mav.addObject("totalCnt", trReserveList.get("records").toString());

			mav.setViewName("/admin/trReserve/trList");
		}
		return mav;
	}

	@GetMapping("/accounts")
	public ModelAndView accounts(ModelAndView mav, SearchTrReserveDto searchTrReserve) throws Exception {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

		if (authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		} else {
			mav.setViewName("/admin/trReserve/accounts");
		}
		return mav;
	}

	@PostMapping("/accounts")
	public Map<String, Object> accountsList(@RequestBody SearchTrReserveDto searchTrReserve) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		System.out.println("account list");

		String order1 = searchTrReserve.getOrderKind1();
		String order2 = searchTrReserve.getOrderKind2();
		if (order1.equals("ASC") && order2.equals("ASC")) {
			String[] arrOrderCoulmn = { "tcRegDt asc", " tcDay2 asc" };
			searchTrReserve.setArrOrderColumn(arrOrderCoulmn);
		} else if (order1.equals("ASC") && order2.equals("DESC")) {
			String[] arrOrderCoulmn = { "tcRegDt asc", "tcDay2 desc" };
			searchTrReserve.setArrOrderColumn(arrOrderCoulmn);
		} else if (order1.equals("DESC") && order2.equals("ASC")) {
			String[] arrOrderCoulmn = { "tcRegDt desc", " tcDay2 asc" };
			searchTrReserve.setArrOrderColumn(arrOrderCoulmn);
		} else if (order1.equals("DESC") && order2.equals("DESC")) {
			String[] arrOrderCoulmn = { "tcRegDt desc", " tcDay2 asc" };
			searchTrReserve.setArrOrderColumn(arrOrderCoulmn);
		}
//		String[] arrOrderCoulmn = { "tcRegDt desc" };
//		searchTrReserve.setArrOrderColumn(arrOrderCoulmn);
		
//		searchTrReserve.setPageSize(20);
		List<SearchTrReserveDto> list = trReserveService.accountList(searchTrReserve);
		
		// 토탈 카운트
		int cnt = trReserveService.accountCnt(searchTrReserve);
		// 페이징 처리4
		Search search = new Search();
		search.setPageSize(searchTrReserve.getPageSize());
		Paging paging = new Paging(search, cnt);

		result.put("paging", paging);
		result.put("totalCnt", cnt);
		result.put("list", list);

		return result;

	}

	@RequestMapping(value = "/accountsDetail", method = { RequestMethod.POST })
	public ModelAndView accountsDetail(@RequestParam(required = false) String tcReservCode) throws Exception {
		ModelAndView mav = null;
		System.out.println("상세 = " + tcReservCode);
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (tcReservCode == null || authentication.getPrincipal() instanceof String) {
			// 넘어온 파라미터가 없을 시
			mav = new ModelAndView("redirect:/adminLogin");
		} else {
			// 제대로 파라미터 존재
			mav = new ModelAndView("/admin/trReserve/accountsDetail");
			// 아래에 작업
		}
//		Map<String, Object> map = new HashMap<String, Object>();
		ChargeDto chargeDto = trReserveService.accountDetaillist(tcReservCode);
		List<ChargeDto> list = trReserveService.testInfo(chargeDto);
		List<ChargeDto> listt = trReserveService.test_Info(chargeDto);
		List<ChargeDto> carlist = trReserveService.carInfo(chargeDto);
		chargeDto.setPReservCode(tcReservCode);
		List<ChargeDto> chargelist = trReserveService.chargeInfo(chargeDto);
		//
		String realday = trReserveService.realday(chargeDto);
//		chargeDto.setDay(realday.get(0).getDay());

		log.debug("=====================================" + chargeDto.getPReservCode());

		mav.addObject("chargelist", chargelist);
		mav.addObject("listt", listt);
		mav.addObject("carlist", carlist);
		mav.addObject("list", list);
		mav.addObject("chargeDto", chargeDto);
		mav.addObject("realday",realday);
		log.debug("===============");
		System.out.println("++++++++++++++++++++++++++++++++++++++++++"+realday);
		mav.setViewName("/admin/trReserve/accountsDetail");

		return mav;
	}

	@GetMapping("/shop")
	public ModelAndView shop(ModelAndView mav, SearchTrReserveDto searchTrReserve) throws Exception {
		System.out.println("shop first");
		mav.setViewName("/admin/trReserve/shop");

		return mav;
	}

	@PostMapping("/shop")
	public Map<String, Object> shopList(@RequestBody ChargeDto chargeDto) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		System.out.println("shop list");

		String order1 = chargeDto.getOrderKind1();
		String order2 = chargeDto.getOrderKind2();
		if (order1.equals("ASC") && order2.equals("ASC")) {
			String[] arrOrderCoulmn = { "wssRegDt asc", " wssEdDay asc" };
			chargeDto.setArrOrderColumn(arrOrderCoulmn);
		} else if (order1.equals("ASC") && order2.equals("DESC")) {
			String[] arrOrderCoulmn = { "wssRegDt asc", "wssEdDay desc" };
			chargeDto.setArrOrderColumn(arrOrderCoulmn);
		} else if (order1.equals("DESC") && order2.equals("ASC")) {
			String[] arrOrderCoulmn = { "wssRegDt desc", " wssEdDay asc" };
			chargeDto.setArrOrderColumn(arrOrderCoulmn);
		} else if (order1.equals("DESC") && order2.equals("DESC")) {
			String[] arrOrderCoulmn = { "wssRegDt desc", " wssEdDay asc" };
			chargeDto.setArrOrderColumn(arrOrderCoulmn);
		}

		System.out.println("++++++++++++" + order1);
		System.out.println("++++++++++++" + order2);

//		String[] arrOrderCoulmn = { "wssRegDt desc" };
//		chargeDto.setArrOrderColumn(arrOrderCoulmn);

		List<ChargeDto> list = trReserveService.selectList(chargeDto);

		// 토탈 카운트
		int cnt = trReserveService.selectListCnt(chargeDto);

		// 페이징 처리
		Search search = new Search();
		search.setPageSize(20);
		search.setPageNo(chargeDto.getPageNo());
		Paging paging = new Paging(search, cnt);

		result.put("paging", paging);
		result.put("totalCnt", cnt);
		result.put("list", list);

		return result;

	}

	@RequestMapping(value = "/shopDetail", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView shopDetail(@RequestParam(required = false) String wssReservCode) throws Exception {
		ModelAndView mav = null;
		System.out.println("상세 = " + wssReservCode);
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

		if (wssReservCode == null || authentication.getPrincipal() instanceof String) {
			// 넘어온 파라미터가 없을 시
			mav = new ModelAndView("redirect:/adminLogin");
		} else {
			// 제대로 파라미터 존재
			mav = new ModelAndView("/admin/trReserve/shopDetail");
		}
		if (authentication.getPrincipal() instanceof String) {
			System.out.println("로그인xxxxx");
			// 세션이 종료되었을 시
			mav = new ModelAndView("redirect:/adminLogin");
		} else {
			System.out.println("로그인ooooo");
			// 로그인 되어있을 시
			mav = new ModelAndView("/admin/trReserve/shopDetail");
			// 파라미터 권한코드
			mav.addObject("wssReservCode", wssReservCode);

			ChargeDto chargeDto = new ChargeDto();
			chargeDto.setWssReservCode(wssReservCode);

			ChargeDto chargeDtolist = new ChargeDto();
			chargeDtolist.setWssReservCode(wssReservCode);

			chargeDto = trReserveService.detailList(chargeDto);
			chargeDtolist = trReserveService.shopInfo(chargeDto);
			
			String realdate = trReserveService.realdate(chargeDto);
			
			System.out.println(chargeDtolist);
			System.out.println("++++++++++++++++++++++++"+realdate);
			mav.addObject("chargeDto", chargeDto);
			mav.addObject("chargeDtolist", chargeDtolist);
			mav.addObject("realdate", realdate);

		}
		return mav;
	}

	@GetMapping("/trlisting")
	public ModelAndView trListing(ModelAndView mav, SearchTrReserveDto searchTrReserve, HttpServletRequest requst)
			throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

		if (authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		} else {
			Integer pageNo = Fn.toInt(requst, "pageNo", 1);
			String tcStep = Fn.toString(requst, "tcStep", "1");
			searchTrReserve.setPageNo(pageNo);

			// 완료된 목록만 가져옴
			searchTrReserve.setTcApproval("3");
			searchTrReserve.setTcStep(tcStep);

			// 예약내역 조회
			Map<String, Object> trReserveList = trReserveService.getTrReserveList(searchTrReserve);

			// 트랙정보
			List<TrackDto> trackList = trReserveService.getTrackList("Y");

			// 페이징 처리
			Search search = new Search();
			search.setPageNo(pageNo);
			search.setPageSize(searchTrReserve.getPageSize());
			Paging paging = new Paging(search, (Integer) trReserveList.get("records"));

			// 변수 설정
			mav.addObject("paging", paging);
			mav.addObject("tcStep", tcStep);
			mav.addObject("trReserveList", trReserveList);
			mav.addObject("trackList", trackList);
			mav.addObject("totalCnt", trReserveList.get("records").toString());

			mav.setViewName("/admin/trReserve/trListing");
		}
		return mav;
	}

	// 상세보기
	@RequestMapping("/tr-detail")
	public ModelAndView trDetail(SearchTrReserveDto searchTrReserve, HttpServletRequest request) throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		ModelAndView mav = new ModelAndView();

		if (authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		} else {
			Integer pageNo = Fn.toInt(request, "pageNo", 1);
			String tcStep = Fn.toString(request, "tcStep", "1");
			TrReserveDto trReserve = trReserveService.getTrReserveDetail(searchTrReserve);
			List<TrRfidDto> rfidLog = trReserveService.getTrRfidLog(trReserve.getTcReservCode());
			List<ResourceMappingDto> rmInfo = trReserveService.getHintDriverInfo(searchTrReserve);
			Map<String, Object> driverInfo = trReserveService.getDriverInfo(searchTrReserve);

			String driverStr = (String) driverInfo.get("driverStr");
			String wiressStr = (String) driverInfo.get("wiressStr");
			String[] resourceArr = (String[]) driverInfo.get("resourceArr");

			CompanyDto company = new CompanyDto();
			if (null != trReserve && null != trReserve.getCompCode()) {
				company = companyService.getCompanyDetail(trReserve.getCompCode());
			}

			Integer payCnt = trReserveService.getAccountYn(trReserve.getTcReservCode());

			mav.addObject("pageNo", pageNo);
			mav.addObject("tcStep", tcStep);
			mav.addObject("trReserve", trReserve);
			mav.addObject("rmInfo", rmInfo);
			mav.addObject("rfidLog", rfidLog);
			mav.addObject("driver", driverStr);
			mav.addObject("wiress", wiressStr);
			mav.addObject("resourceArr", resourceArr);
			mav.addObject("company", company);
			mav.addObject("payCnt", payCnt);

			mav.setViewName("/admin/trReserve/trDetail");
		}
		return mav;

	}

	// 상세보기
	@RequestMapping("/tring-detail")
	public ModelAndView tringDetail(SearchTrReserveDto searchTrReserve, HttpServletRequest request) throws Exception {

		ModelAndView mav = new ModelAndView();
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

		if (authentication.getPrincipal() instanceof String) {
			mav = new ModelAndView("redirect:/adminLogin");
		} else {
			Integer pageNo = Fn.toInt(request, "pageNo", 1);
			String tcStep = Fn.toString(request, "tcStep", "1");
			String tcDay = searchTrReserve.getTcDay();
			tcDay = tcDay.replace(".","");
			searchTrReserve.setTcDay(tcDay);
			TrReserveDto trReserve = trReserveService.getTrReserveDetail(searchTrReserve);
			List<TrRfidGnrDto> rfidGnrLog = trReserveService.getTrRfidGeneralLog(trReserve.getTcReservCode());
			List<TrRfidDto> rfidLog = trReserveService.getTrRfidLog(trReserve.getTcReservCode());

			Map<String, Object> driverInfo = trReserveService.getDriverInfo(searchTrReserve);

			String driverStr = (String) driverInfo.get("driverStr");
			String wiressStr = (String) driverInfo.get("wiressStr");
			String[] resourceArr = (String[]) driverInfo.get("resourceArr");
			CompanyDto company = new CompanyDto();
			if (null != trReserve && null != trReserve.getCompCode()) {
				company = companyService.getCompanyDetail(trReserve.getCompCode());
			}

			Integer payCnt = trReserveService.getAccountYn(trReserve.getTcReservCode());

			mav.addObject("pageNo", pageNo);
			mav.addObject("tcStep", tcStep);
			mav.addObject("trReserve", trReserve);
			mav.addObject("rfidGnrLog", rfidGnrLog);
			mav.addObject("rfidLog", rfidLog);
			mav.addObject("driver", driverStr);
			mav.addObject("wiress", wiressStr);
			mav.addObject("resourceArr", resourceArr);
			mav.addObject("company", company);
			mav.addObject("payCnt", payCnt);

			mav.setViewName("/admin/trReserve/trIngDetail");
		}
		return mav;

	}

	/******************************************
	 *
	 * 목록 조회(페이징 조회)
	 *
	 * @Date : 2021. 7. 20.
	 * @Method : getReserveInfo
	 * @return : Map<String,Object>
	 ******************************************/
	@GetMapping("/track-list")
	public Map<String, Object> getReserveInfo(SearchTrReserveDto searchTrReserve) throws Exception {
		// 트랙정보
		List<TrackDto> trackList = trReserveService.getTrackList("Y");

    	Integer entranceFee = trReserveService.SelectEntranceFee();
    	
		WeekdayDto weekday = trReserveService.getWeekday(searchTrReserve);
		Map<String, Object> reserveInfo = new HashMap<String, Object>();

		reserveInfo.put("trackList", trackList);
		reserveInfo.put("tcDay", searchTrReserve.getTcDay());
		reserveInfo.put("weekday", weekday);
		reserveInfo.put("entranceFee", entranceFee);

		return reserveInfo;
	}

	// process
	@RequestMapping("/insert-trReserve")
	public ResultCode insertTrReserve(TrReserveDto trReserve) throws Exception {

		Integer result;

		try {
			// 사용자 등록
			result = trReserveService.insertTrReserve(trReserve);
		} catch (Exception e) {
			return ResultCode.builder().code(-1).message("등록에 실패하였습니다.").build();
		}

		String message = "시험로 예약 신청이 완료 되었습니다.";

		if (result == -10) {
			message = "단독이나 공동중 한가지만 예약 가능합니다.";
		} else if (result == -20) {
			message = "시간선택이 잘못 되었씁니다. 다시 선택해 주세요.";
		} else if (result == -30) {
			message = "운전자 선택이 잘못 되었습니다. 다시 선택해 주세요.";
		} else if (result == -40) {
			message = "선택하신 날은 운영일이 아닙니다.";
		} else if (result == -50) {
			message = "선택하신 날은 B2B 이용일이 아닙니다.";
		} else if (result == -60) {
			message = "트랙에 맞는 운전자를 선택해 주세요.";
		} else if (result == -70) {
			message = "선택하신 시간은 이미 예약된 시간입니다.";
		} else if (result == -80) {
			message = "선택하신 시간은 예약이 완료되었습니다.";
		} else if (result == -90) {
			message = "약관 확인 후 동의해 주셔야 합니다.";
		} else if (result == -100) {
			message = "에러발생으로 예약이 실패했습니다.";
		}
		return ResultCode.builder().code(result).message(message).build();
	}

	@RequestMapping(value = "/add-trackinfo", method = { RequestMethod.POST })
	public ResultCode addtrackInfoToReservedInfo(@RequestBody SearchTrReserveDto searchTrReserve) throws Exception {

		Integer result;
		String message = "";
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (authentication.getPrincipal() instanceof String) {
			result = 403;
			message = "수정권한이 없습니다.";
		} else {
			try {
				// 사용자 등록
				result = trReserveService.addtrackInfoToReservedInfo(searchTrReserve);

				if (result == -10) {
					result = 400;
					message = "이미 예약된 시험로입니다.";
				} else if (result == -20) {
					message = "승인대기, 승인완료된 경우만 가능합니다.";
				} else if (result == -30) {
					message = "정산완료후 시험로 추가는 불가능합니다.";
				} else if (result == 0) {
					message = "시험로가 추가되지 않았습니다.";
				} else if (result <= 0) {
					message = "시험로 추가에 실패하였습니다.";
				} else {
					result = 200;
					message = "시험로 추가가 완료 되었습니다.";
				}
			} catch (Exception e) {
				result = 400;
				message = "시험로 추가에 실패하였습니다.";
			}
		}

		return ResultCode.builder().code(result).message(message).build();
	}

	@RequestMapping(value = "/add-rfid-log", method = { RequestMethod.POST })
	public ResultCode addRfidLog(@RequestBody TrRfidDto rfidLog) throws Exception {

		Integer result;
		String message = "";
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (authentication.getPrincipal() instanceof String) {
			result = 403;
			message = "수정권한이 없습니다.";
		} else {
			// try {
			// 사용자 등록
			result = trReserveService.addRfidLog(rfidLog);

			if (result == -10) {
				message = "기존 RFID 로그와 중복되는 시간입니다.";
			} else if (result == -20) {
				message = "페이지 상단에서 시험로를 우선 추가해 주세요.";
			} else if (result == -30) {
				message = "예약된 시험일자만 추가 가능합니다.";
			} else if (result == -40) {
				message = "등록된 차량 RFID카드만 추가 가능합니다.";
			} else if (result == -50) {
				message = "입력하실 시간이 정확하지 않습니다.";
			} else if (result == -60) {
				message = "등록된 운전자 RFID카드만 추가 가능합니다.";
			} else if (result == 0) {
				message = "RFID 로그가 추가되지 않았습니다.";
			} else if (result <= 0) {
				message = "RFID 로그추가에 실패하였습니다.";
			} else {
				result = 200;
				message = "RFID 로그추가가 완료 되었습니다.";
			}
			// } catch (Exception e) {
			// result = 400;
			// message = "RFID 로그추가에 실패하였습니다.";
			// }
		}

		return ResultCode.builder().code(result).message(message).build();
	}
	
	@RequestMapping(value = "/update-rfid-gnr-log", method = { RequestMethod.POST })
	public ResultCode updateRfidGnrLog(@RequestBody TrRfidGnrDto rfidGnrLog) throws Exception {
		
		Integer result;
		String message = "";
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (authentication.getPrincipal() instanceof String) {
			result = 403;
			message = "수정권한이 없습니다.";
		} else {
			try {
				// 사용자 등록
				result = trReserveService.updateRfidGnrLog(rfidGnrLog);
				
				if (result == -10) {
					message = "기존 RFID 로그와 중복되는 시간입니다.";
				} else if (result == -50) {
					message = "수정하실 시간이 정확하지 않습니다.";
				} else if (result <= 0) {
					message = "RFID 로그수정에 실패하였습니다.";
				} else {
					result = 200;
					message = "RFID 로그수정에 완료 되었습니다.";
				}
			} catch (Exception e) {
				result = 400;
				message = "RFID 로그수정에 실패하였습니다.";
			}
		}
		
		return ResultCode.builder().code(result).message(message).build();
	}

	@RequestMapping(value = "/update-rfid-log", method = { RequestMethod.POST })
	public ResultCode updateRfidLog(@RequestBody TrRfidDto rfidLog) throws Exception {

		Integer result;
		String message = "";
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (authentication.getPrincipal() instanceof String) {
			result = 403;
			message = "수정권한이 없습니다.";
		} else {
			try {
				// 사용자 등록
				result = trReserveService.updateRfidLog(rfidLog);

				if (result == -10) {
					message = "기존 RFID 로그와 중복되는 시간입니다.";
				} else if (result == -50) {
					message = "수정하실 시간이 정확하지 않습니다.";
				} else if (result <= 0) {
					message = "RFID 로그수정에 실패하였습니다.";
				} else {
					result = 200;
					message = "RFID 로그수정에 완료 되었습니다.";
				}
			} catch (Exception e) {
				result = 400;
				message = "RFID 로그수정에 실패하였습니다.";
			}
		}

		return ResultCode.builder().code(result).message(message).build();
	}

	// 상세보기
	@GetMapping("/detail-trReserve")
	public ModelAndView getTrReserveDetail(SearchTrReserveDto searchTrReserve) throws Exception {
		ModelAndView mav = new ModelAndView();

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

		if (authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		} else {
			mav.setViewName("/admin/trReserve/trReserveDetail");
			TrReserveDto trReserve = trReserveService.getTrReserveDetail(searchTrReserve);
			Map<String, Object> driverInfo = trReserveService.getDriverInfo(searchTrReserve);

			CompanyDto company = new CompanyDto();
			if (null != trReserve && null != trReserve.getCompCode() && !"THINT".equals(trReserve.getCompCode())) {
				company = companyService.getCompanyDetail(trReserve.getCompCode());
			}

			String driverStr = (String) driverInfo.get("driverStr");
			String wiressStr = (String) driverInfo.get("wiressStr");
			String[] resourceArr = (String[]) driverInfo.get("resourceArr");

			mav.addObject("trReserve", trReserve);
			mav.addObject("driver", driverStr);
			mav.addObject("wiress", wiressStr);
			mav.addObject("resourceArr", resourceArr);
			mav.addObject("company", company);
		}
		return mav;

	}

	// 상세보기
	@GetMapping("/detail-reserve-info")
	public Map<String, Object> getTrReserveInfo(SearchTrReserveDto searchTrReserve) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		TrReserveDto trReserve = trReserveService.getTrReserveDetail(searchTrReserve);
		Map<String, Object> driverInfo = trReserveService.getDriverInfo(searchTrReserve);

		CompanyDto company = new CompanyDto();
		if (null != trReserve && null != trReserve.getCompCode() && !"THINT".equals(trReserve.getCompCode())) {
			company = companyService.getCompanyDetail(trReserve.getCompCode());
		}

		String driverStr = (String) driverInfo.get("driverStr");
		String wiressStr = (String) driverInfo.get("wiressStr");
		String[] resourceArr = (String[]) driverInfo.get("resourceArr");

		result.put("trReserve", trReserve);
		result.put("driver", driverStr);
		result.put("wiress", wiressStr);
		result.put("resourceArr", resourceArr);
		result.put("company", company);

		return result;

	}

	// 수정 처리
	@RequestMapping(value = "/update-trReserve", method = { RequestMethod.POST })
	public ResultCode updateTrReserve(@RequestBody TrReserveDto trReserve) throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

		if (authentication.getPrincipal() instanceof String) {
			return ResultCode.builder().code(403).message("수정권한이 없습니다.").build();
		} else {
			Integer cnt = trReserveService.getCompCodeduplCheck(trReserve.getTcSeq());

			if (cnt == 0) {
				return ResultCode.builder().code(400).message("정보가 존재하지 않습니다.").build();
			}
			
			String tcDayToChange = trReserve.getTcDay();
			String tcMemoToChange = trReserve.getTcMemo();
			String days[] = new String[2];
			
			days = tcDayToChange.split("~");	// 수정하고자 하는 기간. ~ 구분자로 시작일과 마감일 분리, 형식 안 맞으면 insert 안 됨
			
			String tcStDt = days[0].trim();				//변경 후 기간(시작)
			String tcEdDt = days[1].trim();				//변경 후 기간(시작)
	    	tcStDt = Fn.toDateFormat(tcStDt, "yyyyMMdd");
	    	tcEdDt = Fn.toDateFormat(tcEdDt, "yyyyMMdd");

	    	SearchTrReserveDto searchTrTreserve = new SearchTrReserveDto();
	    	searchTrTreserve.setTcSeq(trReserve.getTcSeq());
	    	trReserve = trReserveService.getTrReserveDetail(searchTrTreserve);
			String tcStep = trReserve.getTcStep();
			if(null!=tcMemoToChange && !"".equals(tcMemoToChange)) {
				trReserve.setTcMemo(tcMemoToChange);
			}
			
			String beforeTcDay = trReserve.getTcDay();		//변경 전 기간(시작)
			String beforeTcDay2 = trReserve.getTcDay2();	//변경 전 기간(마감)
			
			JSONArray req_array = new JSONArray();
			
			if(trReserve.getTcApproval().equals("3") && tcStep.equals("00000")&&null!=days[0]&&null!= days[1] &&
		    		(!tcStDt.equals(beforeTcDay) || !tcEdDt.equals(beforeTcDay2))) {			//기간이 정상적으로 들어오지 않으면 기간수정 무효화
		    	trReserve.setTcApprovalForChange("2");
				trReserve.setTcDay(beforeTcDay);
				trReserve.setTcDay2(beforeTcDay2);
				
		    	req_array = trReserveService.makeJsonCancelEaiHk(trReserve.getTcSeq());
			}
			
			trReserve.setTcDay(tcDayToChange);
			cnt = trReserveService.updateTrReserve(trReserve);
			
			if(cnt>0) {
				if(null!=req_array) {
					String url = "http://hes.hankooktech.com/external/externalResIf.do";
					HttpHeaders headers = new HttpHeaders();
					headers.setContentType(MediaType.APPLICATION_JSON);
					HttpEntity param= new HttpEntity(req_array, headers);
					RestTemplate restTemplate = new RestTemplate();
					
					System.out.println("HES 연동(수정중 취소) :  " + req_array);
					String result = restTemplate.postForObject(url, param, String.class);
				    log.info("HES result : " + result);
				}
				
			    if(trReserve.getTcApproval().equals("3") && tcStep.equals("00000")&&null!=days[0]&&null!= days[1] &&
			    		(!tcStDt.equals(beforeTcDay) || !tcEdDt.equals(beforeTcDay2))) {			//기간이 정상적으로 들어오지 않으면 기간수정 무효화
			    	
					/* 기간변경일 경우 이후(변경되는 기간) 기간은 취소데이터로 api 호출되도록 시작 */ 
			    	trReserve.setTcApprovalForChange("3");
					trReserve.setTcDay(tcStDt);
					trReserve.setTcDay2(tcEdDt);
	
					req_array = trReserveService.makeJsonApprovalEaiHk(trReserve.getTcSeq());
					
					String url = "http://hes.hankooktech.com/external/externalResIf.do";
					HttpHeaders headers = new HttpHeaders();
					headers.setContentType(MediaType.APPLICATION_JSON);
					HttpEntity param= new HttpEntity(req_array, headers);
					RestTemplate restTemplate = new RestTemplate();
	
					System.out.println("HES 연동(수정중 등록) :  " + req_array);
					String result = restTemplate.postForObject(url, param, String.class);
				    log.info("HES result : " + result);
					/* 기간변경일 경우 이전 기간은 취소데이터로 api 호출되도록 시작 */
			    }
			}
			
			Integer code = cnt > 0 ? 200 : 400;
			String message = "수정완료되었습니다.";
			if(cnt==-1) {
				message = "선택하신 기간에 이미 예약내역이 존재합니다.";
			}else if(cnt < 0) {
				message = "수정에 실패하였습니다.";
			}
			
			return ResultCode.builder().code(code).message(message).build();
		}

	}

	// 상태 변경
	@RequestMapping(value = "/update-approval", method = { RequestMethod.POST })
	public ResultCode updateApproval(@RequestBody TrReserveDto trReserve) throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

		if (authentication.getPrincipal() instanceof String) {
			return ResultCode.builder().code(403).message("수정권한이 없습니다.").build();
		} else {
			Integer cnt = trReserveService.getCompCodeduplCheck(trReserve.getTcSeq());
			String reqTcStep = Fn.toString(trReserve.getTcStep());
			if (cnt == 0) {
				return ResultCode.builder()
						.code(400)
						.message("정보가 존재하지 않습니다.")
						.build();
			}
			
			cnt = trReserveService.updateApproval(trReserve);
			
			String message = "";
			if (reqTcStep.equals("00002")) {
				if (cnt>0) {
					message = "시험완료처리 되었습니다.";
				} else if(cnt==-1) {
					message = "시험로 입/출차기록을 우선 입력한 후에 시험완료처리가 가능합니다.";
				} else if(cnt==-2) {
					message = "GNR GATE 입/출차시간을 우선 입력한 후에 시험완료처리가 가능합니다.";
				}
			} else {
				if (cnt>0) {
					message = "저장완료 되었습니다.";
				} else {
					message = "저장완료에 실패했습니다.";
				}
			}

			return ResultCode.builder().code(cnt).message(message).build();
		}
	}

	// 상태 변경(승인)
	@RequestMapping(value = "/update-approval-suc", method = { RequestMethod.POST })
	public ResultCode updateApprovalSuccess(@RequestBody TrReserveDto trReserve) throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if (authentication.getPrincipal() instanceof String) {
			resultMap.put("error", "수정권한이 없습니다.");
			
			return ResultCode.builder().code(403).message("수정권한이 없습니다.").build();
		} else {
			Integer cnt = trReserveService.getCompCodeduplCheck(trReserve.getTcSeq());
			trReserve.setTcApproval("3");
			
			if (cnt == 0) {
				resultMap.put("error", "정보가 존재하지 않습니다.");
				
				return ResultCode.builder().code(400).message("정보가 존재하지 않습니다.").build();
			}else{				
				JSONArray req_array = trReserveService.makeJsonApprovalEaiHk(trReserve.getTcSeq());
				
				String url = "http://hes.hankooktech.com/external/externalResIf.do";
				HttpHeaders headers = new HttpHeaders();
				headers.setContentType(MediaType.APPLICATION_JSON);
				HttpEntity param= new HttpEntity(req_array, headers);
				RestTemplate restTemplate = new RestTemplate();

				log.info("HES 연동(승인) :  " + req_array);
				String result = restTemplate.postForObject(url, param, String.class);
			    log.info("HES result : " + result);
				
				cnt = trReserveService.updateApproval(trReserve);
				
				String message = "";
				if (cnt>0) {
					message = "승인완료처리 되었습니다.";
				} else {
					message = "승인완료처리에 실패했습니다.";
				}
				
				resultMap.put("message", message);
				
				return ResultCode.builder().code(cnt).message(message).build();
			}			
		}
		
	}
	
	// 상태 변경(승인)
	@RequestMapping(value = "/update-approval-return", method = { RequestMethod.POST })
	public ResultCode updateApprovalReturn(@RequestBody TrReserveDto trReserve) throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if (authentication.getPrincipal() instanceof String) {
			resultMap.put("error", "취소권한이 없습니다.");
			
			return ResultCode.builder().code(403).message("취소권한이 없습니다.").build();
		} else {
			Integer cnt = trReserveService.getCompCodeduplCheck(trReserve.getTcSeq());
			trReserve.setTcApproval("2");
			
			if (cnt == 0) {
				resultMap.put("error", "정보가 존재하지 않습니다.");
				
				return ResultCode.builder().code(400).message("정보가 존재하지 않습니다.").build();
			}else{
				cnt = trReserveService.updateApproval(trReserve);
				
				String message = "";
				if (cnt>0) {
					message = "취소처리 되었습니다.";
				} else {
					message = "취소처리에 실패했습니다.";
				}
				
				resultMap.put("message", message);
				
				JSONArray req_array = trReserveService.makeJsonCancelEaiHk(trReserve.getTcSeq());
				
				String url = "http://hes.hankooktech.com/external/externalResIf.do";
				HttpHeaders headers = new HttpHeaders();
				headers.setContentType(MediaType.APPLICATION_JSON);
				HttpEntity param= new HttpEntity(req_array, headers);
				RestTemplate restTemplate = new RestTemplate();

				log.info("HES 연동(취소) :  " + req_array);
				String result = restTemplate.postForObject(url, param, String.class);
				log.info("HES result : " + result);
				
				return ResultCode.builder().code(cnt).message(message).build();
			}			
		}
		
	}
	
	// 상태 변경
	@PostMapping("/insert-accounts")
	public ResultCode insertAccounts(@RequestBody TrReserveDto trReserve) throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

		if (authentication.getPrincipal() instanceof String) {
			return ResultCode.builder().code(403).message("수정권한이 없습니다.").build();
		} else {
			Integer cnt = trReserveService.getCompCodeduplCheck(trReserve.getTcSeq());
			Integer code;
			if (cnt == 0) {
				code = -1;
				return ResultCode.builder().code(code).message("정보가 존재하지 않습니다.").build();
			} else {
				cnt = trReserveService.getAccountYn(trReserve.getTcReservCode());
				if (cnt > 0) {
					code = -2;
					return ResultCode.builder().code(code).message("정산서 생성이 완료된 건입니다.").build();
				} else {
					// result = trReserveService.insertAccounts(trReserve);
					cnt = calService.insertPay(trReserve.getTcReservCode());
					if (cnt > 0) {
						trReserve.setTcStep("00003");
						trReserveService.updateApproval(trReserve);
						code = 200;
					} else {
						code = -3;
					}
				}
			}
			
			String message = "정산서 생성에 실패하였습니다.";
			if (code == -1) {
				message = "정보가 존재하지 않습니다.";
			} else if (code == -2) {
				message = "정산서 생성이 완료된 건입니다.";
			} else if (code == -3) {
				message = "정산서 생성할 데이터가 존재하지 않습니다.";
			} else if (code == 200) {
				message = "정산서 생성이 완료되었습니다.";
			} else {
				message = "정산서 생성에 실패하였습니다.";
			}

			return ResultCode.builder().code(code).message(message).build();
		}
	}

	@RequestMapping("/delete-trReserve")
	public ResultCode getTrReserveDelete(TrReserveDto trReserve) throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

		if (authentication.getPrincipal() instanceof String) {
			return ResultCode.builder().code(403).message("수정권한이 없습니다.").build();
		} else {

			Integer cnt = 0;

			try {
				cnt = trReserveService.deleteTrReserve(trReserve);
			} catch (Exception e) {
				return ResultCode.builder().code(400).message("취소에 실패했습니다.").build();
			}

			String message = "";

			if (cnt == -10) {
				message = "승인대기 상태인 경우만 취소가능합니다.";
			} else if (cnt == -20) {
				message = "취소 권한이 없습니다.";
			}

			Integer code = cnt > 0 ? 200 : 400;

			return ResultCode.builder().code(code).message(message).build();
		}
	}

	/* 달력 예약 불가능 표시 기능 부분 시작 */
	@PostMapping("/search-weekday")
	public Map<String, Object> selectUserShop(@RequestBody SearchTrReserveDto searchTrReserve) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		UserShopVo userShopVo = new UserShopVo();
		/* 현재 시간 설정 */
		// Date date_now = new Date(System.currentTimeMillis());
		// String currentTime = Fn.toDateFormat(date_now, "yyyyMMdd");

		// userShopVo.setWssStDay(currentTime);
		// String wsCode = userShopVo.getWsCode();

		List<UserShopVo> shop = userShopService.selectUserShop(userShopVo);
		List<WeekdayDto> weekday = trReserveService.getWeekdayList(searchTrReserve);
		SearchDayoffDto searchDayoffDto = new SearchDayoffDto();
		searchDayoffDto.setDoKind("F"); // 공통으로 사용하기로 변경됨으로써 부대시설 코드로 사용함
		List<DayoffDto> dayOff = dayoffService.getDayoffList(searchDayoffDto);

		result.put("shop", shop);
		result.put("weekday", weekday);
		result.put("dayOff", dayOff);
		return result;
	}

	@PostMapping("/chk")
	public int chkSchedule(@RequestBody UserShopVo userShopVo) throws Exception {
		int result = trReserveService.chkSchedule(userShopVo);
		return result;
	}
	
	@GetMapping("/email-approve")
	public ModelAndView emailSetting() throws Exception {
		System.out.println("/email-approve");
		ModelAndView mav = new ModelAndView();
		SearchTrReserveDto searchTrReserve = new SearchTrReserveDto();
		
		TrReserveDto trReserve = trReserveService.getTestScheduleEqualsTcSeq1Row(1442);
		
		String tcDay = trReserve.getTcDay();
		if(tcDay.indexOf("#")>-1) {
			tcDay = tcDay.substring(0, tcDay.indexOf("#"));
		}
		trReserve = trReserveService.getTrReserveExpression(trReserve);
		String tcPurpose = trReserve.getTcPurpose();
		tcPurpose = tcPurpose.replace("\n", "<br />");
		trReserve.setTcPurpose(tcPurpose);

		List<CarDto> carList = trReserve.getCarInfo();
		String carStr = "";
		for(int i=0; i<carList.size(); i++) {
			CarDto car = carList.get(i);
			if(i>0) {
				carStr += "<br />";
			}
			carStr += car.getCVender()+" "+car.getCName()+" / "+car.getCColor()+" / "+car.getCNumber();
		}
		searchTrReserve.setTcSeq(trReserve.getTcSeq());
		searchTrReserve.setTcDay(tcDay);
		searchTrReserve.setCompCode(trReserve.getCompCode());
    	
		Map<String, Object> driverInfo = trReserveService.getDriverInfo(searchTrReserve);

		CompanyDto company = new CompanyDto();
		company = trReserveService.getCompanyDetail(trReserve.getCompCode());
		company = companyService.getCompanyDetailExpression(company);

		String driverStr = (String) driverInfo.get("driverStr");
		String driverOnlyNameStr = (String) driverInfo.get("driverOnlyNameStr");
		String wiressStr = (String) driverInfo.get("wiressStr");
		String[] resourceArr = (String[]) driverInfo.get("resourceArr");
		
		String resource = "";
		
		for(int i=0; i<resourceArr.length; i++) {
			resource += resourceArr[i];
		}

		mav.addObject("trReserve", trReserve);
		System.out.println("trReserve : " + trReserve);
		mav.addObject("driver", driverStr);
		mav.addObject("driverOnlyName", driverOnlyNameStr);
		mav.addObject("car", carStr);
		mav.addObject("wiress", wiressStr);
		mav.addObject("resource", resource);
		mav.addObject("company", company);
		
		mav.setViewName("/thymeleaf/trackReservApprove");

		return mav;
	}
}