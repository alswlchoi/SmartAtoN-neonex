package com.hankook.pg.content.admin.tire.controller;

import com.hankook.pg.content.admin.tire.domain.TireManagement;
import com.hankook.pg.content.admin.tire.domain.Wheel;
import com.hankook.pg.content.admin.tire.dto.InsertTireDataDto;
import com.hankook.pg.content.admin.tire.dto.InsertWheelDataDto;
import com.hankook.pg.content.admin.tire.dto.PagingAndSearchRequestDto;
import com.hankook.pg.content.admin.tire.dto.WheelPagingAndSearchRequestDto;
import com.hankook.pg.content.admin.tire.service.TireService;
import com.hankook.pg.exception.DataNotFoundException;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Search;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/tire")
public class TireController {

	private final TireService tireService;
	private static final int TIRE_PAGE_SIZE = 5;

	private static final String TODAY = "today";
	private static final String SEARCH_DAY = "SearchDay";

	private static final String TIRE_PUSH = "tirePush";
	private static final String LIFT = "lift";
	private static final String TIRE_ASSEMBLY = "tireAssembly";
	private static final String TIRE_DISASSY = "tireDisassy";
	private static final String TRWH = "TRWH";

	private static final String TYPE_NOT_FOUND = "TYPE NOT FOUND";

	/**
	 * Tire / Wheel management 페이지 이동 메서드 <br>
	 * lift 사이즈 변경 가능성있어 데이터 mav 에 담아서 리턴
	 * @return ModelAndView
	 */
	@GetMapping
	public ModelAndView getTireView() {
		ModelAndView mv = new ModelAndView("/admin/tire/tire");
		int[] arr = {1,2,3,4,5};
		mv.addObject("liftList",arr);
		return mv;
	}

	/**
	 * 테스트 정보에 따른 타이어 출고|위치 , 휠 위치 , 리프트 , 조립,분해에 대한 리스트 조회
	 *
	 * @param request : 날짜 조회 시 date 변수 사용, paging 조회 시 Search 클래스 정보 사용
	 * @return Map
	 * @throws Exception
	 */
	@PostMapping
	public Map<String,Object> tireFindAll(@RequestBody PagingAndSearchRequestDto request) throws Exception {
		Map<String,Object> result = new HashMap<>();
		request.setPageSize(TIRE_PAGE_SIZE);
		request.setToday(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")));

		if(request.getDate() !=null && request.getEndDate() !=null) {
			result.put("type",SEARCH_DAY);
			result.put("dayPaging",request.getDate());
			result.put("dayPagingEnd",request.getEndDate());
		}else {
			result.put("type",TODAY);
		}

		List<TireManagement> list = tireService.findAllToday(request);
		int count = tireService.findAllTodayCount(request);

		updateTireLocation(list);

		result.put("list",list);
		result.put("paging",createPaging(request.getPageNo(),count));
		result.put("totalCnt",count);

		return result;
	}

    private void updateTireLocation(List<TireManagement> list) throws SQLException {
        List<InsertTireDataDto> updateTireLocationList = new ArrayList<>();

        list.forEach(tireManagement -> {
            if(tireManagement.getTireLocation() !=null && tireManagement.getTireLocation().equals(TRWH)) {
                tireManagement.setTmTrwhYn("Y");
                updateTireLocationList.add(InsertTireDataDto.builder()
                        .tmSeq(Integer.parseInt(tireManagement.getTmSeq()))
                        .colType("LOCATION")
                        .tmTrwhYn("Y")
                        .build());
            }
        });

        if(updateTireLocationList.size()>0) {
            for (InsertTireDataDto insertTireDataDto : updateTireLocationList) {
                tireService.insertTireLocation(insertTireDataDto);
            }
        }
    }


    /**
	 * 테스트 속성으로 리스트 조회 메서드
	 * @param request : 속성 조회 시 attr 변수 사용 , paging 조회 시 Search 클래스 정보 사용
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/find")
	public Map<String,Object> findTire(@RequestBody PagingAndSearchRequestDto request) throws Exception {
		Map<String,Object> result = new HashMap<>();

		request.setPageSize(TIRE_PAGE_SIZE);
		request.setToday(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")));

		List<TireManagement> list = tireService.findTireAttr(request);
		int count = tireService.findTireAttrCount(request);

        updateTireLocation(list);

		result.put("type",TODAY);
		result.put("list",list);
		result.put("paging",createPaging(request.getPageNo(),count));
		result.put("totalCnt",count);

		return result;
	}

	/**
	 * 타이어 출고요청 , 리프트 설정, 타이어 조립, 분해 설정 시 데이터 INSERT (실제 :  UPDATE)
	 *
	 * @param request : engineer 와 saveTime 의 경우 로그인중인 사용자 정보 와 현재 시간을 Service 에서 입력함
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/insert")
	public int insertTireData(@RequestBody @Valid InsertTireDataDto request) throws Exception {
		int count = 0;

		switch (request.getColType()) {
			case TIRE_PUSH:
				count = tireService.insertTirePush(request);
				break;
			case LIFT:
				count = tireService.insertTireLift(request);
				break;
			case TIRE_ASSEMBLY:
				count = tireService.insertAssembly(request);
				break;
			case TIRE_DISASSY:
				count = tireService.insertDisAssembly(request);
				break;
		}

		if(count >0) {
			return count;
		}else {
			throw new DataNotFoundException();
		}
	}

	/**
	 * Wheel Location Search 시 Wheel 정보 리스트 조회 하는 메서드
	 * @param request : paging 조회 시 Search 클래스 정보 사용
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/wheel/findAll")
	public Map<String,Object> wheelFindAll(@RequestBody WheelPagingAndSearchRequestDto request) throws Exception {
		Map<String,Object> result = new HashMap<>();
		List<Wheel> list = tireService.wheelFindAll(request);
		int count = tireService.wheelFindAllCount(request);
		//페이징 처리
		Search search = new Search();
		search.setPageNo(request.getPageNo());
		search.setPageSize(10);
		result.put("wheelList",list);
		result.put("paging",createWheelPaging(search.getPageNo(),count));
		result.put("totalCnt",count);

		return result;

	}

	@PostMapping("/wheel/find")
	public Map<String,Object> findWheel(@RequestBody WheelPagingAndSearchRequestDto request) throws Exception {
		Map<String,Object> result = new HashMap<>();
		List<Wheel> list = tireService.findWheelAttr(request);
		int count = tireService.findWheelAttrCount(request);
		//페이징 처리
		Search search = new Search();
		search.setPageNo(request.getPageNo());
		search.setPageSize(10);
		result.put("wheelList",list);
		result.put("paging",createWheelPaging(search.getPageNo(),count));
		result.put("totalCnt",count);
		return result;
	}


	/**
	 * Wheel Location 선택 후 저장 시 해당 테이블에 저장하는 메서드
	 * @param request : Wheel Location List 정보와 해당 row sequence
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/wheel/insert")
	public int insertWheelData(@RequestBody @Valid InsertWheelDataDto request) throws Exception {
		int result = tireService.insertWheelLocation(request);

		if(result >0) {
			return result;
		}else {
			throw new DataNotFoundException();
		}
	}



	/**
	 * 페이징 클래스 만드는 메서드 (TIRE)
	 * @param pageNo
	 * @param pageCount
	 * @return
	 */
	private Paging createPaging(int pageNo , int pageCount) {
		Search search = new Search();
		search.setPageNo(pageNo);
		search.setPageSize(TIRE_PAGE_SIZE);
		return new Paging(search,pageCount);
	}

	/**
	 * 페이징 클래스 만드는 메서드 (Wheel) <br>
	 * Search 클래스의 default size 가 10이므로 따로 설정 안함
	 * @param pageNo
	 * @param pageCount
	 * @return
	 */
	private Paging createWheelPaging(int pageNo, int pageCount) {
		Search search = new Search();
		search.setPageNo(pageNo);
		return new Paging(search,pageCount);
	}

}
