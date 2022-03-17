package com.hankook.pg.content.user.trReserve.controller;

import com.hankook.pg.content.admin.company.dto.CompanyDto;
import com.hankook.pg.content.admin.company.service.CompanyService;
import com.hankook.pg.content.admin.dayoff.dto.DayoffDto;
import com.hankook.pg.content.admin.dayoff.dto.SearchDayoffDto;
import com.hankook.pg.content.admin.dayoff.service.DayoffService;
import com.hankook.pg.content.admin.driver.dto.DriverDto;
import com.hankook.pg.content.admin.driver.dto.SearchDriverDto;
import com.hankook.pg.content.admin.driver.service.DriverService;
import com.hankook.pg.content.admin.shop.vo.ShopVo;
import com.hankook.pg.content.admin.trReserve.dto.SearchTrReserveDto;
import com.hankook.pg.content.admin.trReserve.dto.TrReserveDto;
import com.hankook.pg.content.admin.trReserve.dto.TrackDto;
import com.hankook.pg.content.admin.trReserve.service.TrReserveService;
import com.hankook.pg.content.admin.weekday.dto.WeekdayDto;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.content.member.service.MemberService;
import com.hankook.pg.content.user.myPageShop.service.MyPageShopService;
import com.hankook.pg.content.user.myPageShop.vo.MyPageShopVo;
import com.hankook.pg.content.user.trReserve.service.MyPageService;
import com.hankook.pg.content.user.trReserve.vo.MyPageVo;
import com.hankook.pg.content.user.userShop.service.UserShopService;
import com.hankook.pg.content.user.userShop.vo.UserShopVo;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.ResultCode;
import com.hankook.pg.share.Search;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

@RestController
@RequestMapping("/user/trReserve")
public class UserTrReserveController {
 
    @Autowired
    TrReserveService trReserveService;
    
    @Autowired
    MemberService memberService;
    
    @Autowired
    DriverService driverService;
    
    @Autowired
    DayoffService dayoffService;
    
    @Autowired
    UserShopService userShopService;
    
    @Autowired
    CompanyService companyService;

    @Autowired
    MyPageShopService myPageShopService;

    @Autowired
    MyPageService myPageService;
    
    @GetMapping("")
    public ModelAndView getTrReserves(ModelAndView mav, SearchDriverDto searchDriver, SearchTrReserveDto searchTrReserve) throws Exception {
    	/* 로그인 정보 가져옴 */
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	if(authentication.getPrincipal() instanceof String){
    		mav.setViewName("redirect:/adminLogin");
    	}else{
	    	MemberDto memberDto = (MemberDto)authentication.getPrincipal();
	    	
	    	memberDto = memberService.getMemberInfo(memberDto.getMemId()); 
	    	String compCode = memberDto.getCompCode();
	    	//로그인한 사용자 정보
			CompanyDto company = trReserveService.getCompanyDetail(compCode); 
	    	//트랙정보
	    	List<TrackDto> trackList = trReserveService.getTrackList("Y");
	    	//사용중인 부대시설 정보 가져옴
	    	List<UserShopVo> shopList = trReserveService.getShopList();
			searchDriver.setCompCode(compCode);	    	       
	    	searchDriver.setDApproval("Y");		//승인된 운전자만 가져옴
	    	
	    	List<DriverDto> driverList = trReserveService.getDriverList(searchDriver);
	
	    	//변수 설정	
	    	mav.addObject("driverList", driverList);
	        mav.addObject("member",memberDto);
	        mav.addObject("company",company);
	        mav.addObject("trackList",trackList);
	        mav.addObject("shopList",shopList);
	        
	        mav.setViewName("/user/trReserve/trReserve");
    	}
    	
        return mav;
    }
    
    @GetMapping("/shop-can-list")
    public Map<String, Object> getShopCanList(SearchTrReserveDto searchTrReserve) throws Exception {
    	Map<String, Object> result = new HashMap<String, Object>();
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	if(authentication.getPrincipal() instanceof String){
    		result.put("error", "notlogin");
    	}else{
	    	
	    	Map<String, Object> shopReservedList = trReserveService.getShopCanList(searchTrReserve);
	    	
			for(Entry<String, Object> elem : shopReservedList.entrySet()){
		        result.put(elem.getKey(), elem.getValue());
			//	System.out.println(elem.getKey() + " : " + elem.getValue());
			}
    	}
        
        return result;
    }

    @PostMapping("/insert-trReserve")
    public Map<String,Object> insertTrReserve(@RequestBody TrReserveDto trReserve) throws Exception {
    	Map<String,Object> resultMap = new HashMap<String,Object>();
    	int result = 0;
    	String message = "시험로 예약 신청이 완료 되었습니다.";
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	if(authentication.getPrincipal() instanceof String){
    		result = -100;
    		message = "재로그인 후 이용해 주세요.";
    	}else{
	    	result = trReserveService.insertTrReserve(trReserve);
	
			if(result == -10) {
				message = "시험로선택이 잘못 되었습니다. 다시 선택해 주세요.";
			}else if(result == -20) {
				message = "시간선택이 잘못 되었습니다. 다시 선택해 주세요.";
			}else if(result == -30) {
				message = "운전자 선택이 잘못 되었습니다. 다시 선택해 주세요.";
			}else if(result == -40) {
				message = "선택하신 날은 운영일이 아닙니다.";
			}else if(result == -50) {
				message = "선택하신 날은 B2B 이용일이 아닙니다.";
			}else if(result == -60) {
				message = "시험로 입장이 가능한 운전자를 선택해 주세요.";
			}else if(result == -70) {
				message = "선택하신 시간은 이미 예약되어 예약하실 수 없습니다.";
			}else if(result == -80) {
				message = "선택하신 시간은 이미 예약되어 예약하실 수 없습니다.";
			}else if(result == -90) {
				message = "선택하신 기간에 이미 예약내역이 존재합니다.";
			}else if(result < 0) {
				message = "예약에 실패했습니다. 다시 시도해 주세요.";
			}
    	}
    	
		resultMap.put("message", message);
		resultMap.put("result", result);
		
		return resultMap;
    }

    @GetMapping("/success")
    public ModelAndView success() {
    	ModelAndView mav = new ModelAndView();
    	mav.setViewName("/user/trReserve/success");
    	return mav;
    }
    
    @RequestMapping("/update-cancelInfo")
    public ResultCode updateCancelInfo(TrReserveDto trReserve, HttpServletRequest request) throws Exception {
		int cnt = trReserveService.getCompCodeduplCheck(trReserve.getTcSeq());
		
		if (cnt == 0) return ResultCode.builder()
                .code(400)
                .message("정보가 존재하지 않습니다.")
                .build();	
  
     	boolean result = true;
    	
     	try {
     		//사용자 업데이트
     		cnt = trReserveService.updateCancelInfo(trReserve, request);
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
    
    @GetMapping("/detail-trReserve")
    public Map<String, Object> getTrReserveDetail(SearchTrReserveDto searchTrReserve) throws Exception {    	
    	/* 로그인 정보 가져옴 */
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	MemberDto memberDto = (MemberDto)authentication.getPrincipal();
    	CompanyDto company = companyService.getCompanyDetail(memberDto.getCompCode());
    	Integer tcSeq = searchTrReserve.getTcSeq();
    	TrReserveDto trReserve = trReserveService.getTestScheduleEqualsTcSeq1Row(tcSeq);
		Map<String, Object> driverInfo = trReserveService.getDriverInfo(searchTrReserve);

		String driverStr = (String)driverInfo.get("driverStr");
		String wiressStr = (String)driverInfo.get("wiressStr");
		//String[] resourceArr = (String[])driverInfo.get("resourceArr");
    	
    	Map<String, Object> result = new HashMap<String, Object>();  
    	result.put("trReserve", trReserve);
    	result.put("driverStr", driverStr);
    	result.put("wiressStr", wiressStr);
    	result.put("company", company);
    	result.put("member", memberDto);
    	return result;
    	
    }
    
    @RequestMapping("/update-trReserve")
    public ResultCode getTrReserveModify(TrReserveDto trReserve, HttpServletRequest request) throws Exception {
		int cnt = trReserveService.getCompCodeduplCheck(trReserve.getTcSeq());
		
		if (cnt == 0) return ResultCode.builder()
                .code(400)
                .message("정보가 존재하지 않습니다.")
                .build();	
  
     	boolean result = true;
    	
     	try {
     		cnt = trReserveService.updateTrReserve(trReserve);
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

    @RequestMapping("/delete-trReserve")
    public ResultCode getTrReserveDelete(TrReserveDto trReserve) throws Exception {

    	Integer cnt = 0;
    	
     	try {
     		cnt = trReserveService.deleteTrReserve(trReserve);
 		} catch (Exception e) {
 			return ResultCode.builder()
 	               .code(400)
 	               .message("취소에 실패했습니다.")
 	               .build();	
 		}
		
     	String message = "";
		
     	if(cnt > 0) {
     		message = "취소가 완료되었습니다."; 
     	}else if(cnt == -10) {
     		message = "승인대기 상태인 경우만 취소가능합니다.";
     	}else if(cnt == -20) {
     		message = "취소 권한이 없습니다.";
     	}else {
     		message = "취소가 정상적으로 처리되지 않았습니다.\n다시 시도해 주세요";
     	}

     	int code = cnt > 0 ? 200 : 400;
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    }

    @PostMapping("/search-weekday")
    public Map<String, Object> selectUserShop(@RequestBody SearchTrReserveDto searchTrReserve) throws Exception {
      Map<String, Object> result = new HashMap<String, Object>();
      UserShopVo userShopVo = new UserShopVo();      
      
      List<UserShopVo> shop = userShopService.selectUserShop(userShopVo);
      List<WeekdayDto> weekday = trReserveService.getWeekdayList(searchTrReserve);
      SearchDayoffDto searchDayoffDto = new SearchDayoffDto();
      searchDayoffDto.setDoKind("F");		//공통으로 사용하기로 변경됨으로써 부대시설 코드로 사용함;
      List<DayoffDto> dayOff = dayoffService.getDayoffList(searchDayoffDto);

      System.out.println("weekday :" + weekday);
      
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

    // 부대시설 화면 이동 및 디테일 가져오기
    @RequestMapping(value = "reserved", method = RequestMethod.GET)
    public ModelAndView reserved() throws Exception {
      ModelAndView mv = new ModelAndView("/user/myPageShop/reservedShop");
      return mv;
    }

    @PostMapping("/shopDetail")
    public MyPageShopVo selectUserShop(@RequestBody MyPageShopVo myPageShopVo) throws Exception {
      MyPageShopVo list = myPageShopService.getScheduleDetail(myPageShopVo);
      return list;
    }

    @PostMapping("/cancelShop")
    public int updateSchedule(@RequestBody MyPageShopVo myPageShopVo) throws Exception {
      int result = myPageShopService.updateSchedule(myPageShopVo);
      return result;
    }

    /**
     *
     * 마이페이지 새로 수정 ver.
     * @Date   : 2021. 11. 04.
     * @Written : 최민지
     *
     */
    @RequestMapping(value = "/myPage", method = RequestMethod.GET)
    public ModelAndView myPage() throws Exception {
      ModelAndView mv = new ModelAndView("/user/trReserve/myPage");

      return mv;
    }

    @PostMapping(value = "/reservList")
    public Map<String, Object> getReserveList(@RequestBody MyPageVo myPageVo) throws Exception {
      Map<String, Object> result = new HashMap<>();

      String[] arrOrderCoulmn = {"regDt desc"};
      myPageVo.setArrOrderColumn(arrOrderCoulmn);

      List<MyPageVo> reserved = myPageService.getReserveList(myPageVo);
      //토탈 카운트
      int cnt = myPageService.getReserveListCnt(myPageVo);

      result.put("reserved", reserved);
      //페이징 처리
      Search search = new Search();
      search.setPageNo(myPageVo.getPageNo());
      search.setPageSize(10);
      Paging paging = new Paging(search,cnt);
      result.put("paging", paging);
      result.put("totalCnt", cnt);

      return result;
    }

  @PostMapping(value = "/useList")
  public Map<String, Object> useList(@RequestBody MyPageVo myPageVo) throws Exception {
    Map<String, Object> result = new HashMap<>();

    String[] arrOrderCoulmn = {"regDt desc"};
    myPageVo.setArrOrderColumn(arrOrderCoulmn);

    List<MyPageVo> use = myPageService.getUseList(myPageVo);
    //토탈 카운트
    int cnt = myPageService.getUseListCnt(myPageVo);

    result.put("use", use);
    //페이징 처리
    Search search = new Search();
    search.setPageNo(myPageVo.getPageNo());
    search.setPageSize(10);
    Paging paging = new Paging(search,cnt);
    result.put("paging", paging);
    result.put("totalCnt", cnt);

    return result;
  }

    @PostMapping("/price")
    public Map<String, Object> getPrice() throws Exception {
      Map<String, Object> result = new HashMap<>();
      List<ShopVo> shop = myPageService.getShop();
      TrackDto fee = myPageService.getFee();
      List<TrackDto> track = myPageService.getTrack();

      result.put("shop", shop);
      result.put("fee", fee);
      result.put("track", track);

      return result;
    }

  @RequestMapping(value = "/myPageDetail", method = RequestMethod.GET)
  public ModelAndView myPageDetail(ModelAndView mav) throws Exception {
	  /* 로그인 정보 가져옴 */
  	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
  	if(authentication.getPrincipal() instanceof String){
  		mav.setViewName("redirect:/adminLogin");
  	}else{
  		mav.setViewName("/user/trReserve/myPageDetail");
  	}
    return mav;
  }

  @PostMapping("/detail")
  public Map<String, Object> detail(@RequestBody MyPageVo myPageVo) throws Exception {
    Map<String, Object> result = new HashMap<>();

    MyPageVo detail = myPageService.getDetail(myPageVo);
//    detail.setPApplyTime(myPageService.getShopApplyTime(myPageVo.getReservCode()));
    result.put("detail", detail);
    if (myPageVo.getText().equals("T")) {
      List<MyPageVo> driver = myPageService.getDriver(myPageVo.getReservCode());
      List<MyPageVo> car = myPageService.getCar(myPageVo.getReservCode());

      result.put("driver", driver);
      result.put("car", car);
    }

    return result;
  }

  @PostMapping("/cancel")
  public int cancel(@RequestBody MyPageVo myPageVo) throws Exception {

    int result = myPageService.cancel(myPageVo);

    return result;
  }
}