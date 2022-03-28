package com.hankook.pg.content.admin.controlsystem.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Search;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.admin.controlsystem.dto.NowGnrDto;
import com.hankook.pg.content.admin.controlsystem.dto.ResourceCurrentConditionDto;
import com.hankook.pg.content.admin.controlsystem.dto.SearchDto;
import com.hankook.pg.content.admin.controlsystem.dto.TalkDto;
import com.hankook.pg.content.admin.controlsystem.dto.TrackDto;
import com.hankook.pg.content.admin.controlsystem.service.ControlSystemService;
import com.hankook.pg.content.emergency.service.EmergencyService;
import com.hankook.pg.content.emergency.vo.EmergencyVo;
import com.hankook.pg.share.AESCrypt;
import com.hankook.pg.share.ResultCode;

//import java.net.http.HttpResponse;
//import kong.unirest.Unirest;

@RestController

@RequestMapping("/admin/controlsystem")
public class ControlSystemController {
	
	@Autowired
	
	EmergencyService emergencyService;
	@Autowired
	ControlSystemService controlSystemService;
    
    @GetMapping("/index2")
    public ModelAndView index2() throws Exception {
    	ModelAndView mav = new ModelAndView();
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
			List<TrackDto> trackList = controlSystemService.selectTrackList();
			List<EmergencyVo> emergencyList =  emergencyService.getEmergencyList(null);
			
			for(TrackDto track : trackList) {
				String[] trackNameAndKapaInfoArr = {track.getNick(), Fn.toString(track.getCnt(), "0"), Fn.toString(track.getMax(), "0") };
				mav.addObject(track.getId(), trackNameAndKapaInfoArr);
			}
			mav.addObject("emergencyList", emergencyList);
			
			mav.setViewName("/admin/controlsystem/index_src");
		}    	
    	
    	return mav;
    }
    
    
    @GetMapping("")
    public ModelAndView index() throws Exception {
    	ModelAndView mav = new ModelAndView();
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
			List<TrackDto> trackList = controlSystemService.selectTrackList();
			List<EmergencyVo> emergencyList =  emergencyService.getEmergencyList(null);
			
			for(TrackDto track : trackList) {
				String[] trackNameAndKapaInfoArr = {track.getNick(), Fn.toString(track.getCnt(), "0"), Fn.toString(track.getMax(), "0") };
				mav.addObject(track.getId(), trackNameAndKapaInfoArr);
			}
			mav.addObject("emergencyList", emergencyList);
			
			mav.setViewName("/admin/controlsystem/index");
		}    	
    	
    	return mav;
    }
    
    @GetMapping("/player")
    public ModelAndView player() throws Exception {
    	ModelAndView mav = new ModelAndView();    	
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
			mav.setViewName("/admin/controlsystem/player");
		}    	
    	
    	return mav;
    }

    @RequestMapping("/track-info")
    public Map<String, Object> selectTrackList() throws Exception {
    	Map<String, Object> resultMap = new HashMap<String, Object>();

		List<TrackDto> trackList = controlSystemService.selectTrackList();
		
		for(TrackDto track : trackList) {
			String[] trackNameAndKapaInfoArr = {track.getNick(), Fn.toString(track.getCnt(), "0"), Fn.toString(track.getMax(), "0") };
			resultMap.put(track.getId(), trackNameAndKapaInfoArr);
		}
	    	
    	
    	return resultMap;
    }
    
    @RequestMapping("/now-gnr")
    public Map<String, Object> selectNowGnr(@RequestBody SearchDto searchDto) throws Exception {
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	
    	NowGnrDto nowGnrDto = controlSystemService.selectNowGnr(searchDto.getTcDay());
    	Integer nowGnrCount = controlSystemService.selectCountRfidGnr(searchDto.getTcDay());
    	resultMap.put("nowGnr", nowGnrDto);
    	resultMap.put("nowGnrCount", nowGnrCount);
    	
    	return resultMap;
    }
    
    @RequestMapping("/gnr-in-open")
    public Integer gnrInOpen() throws Exception {    	
    	return controlSystemService.modifyInputIntimeLastRfidGeneral();
    }

    @RequestMapping("/resource-condition")
    public Map<String, Object> selectRfidLogList(@RequestBody SearchDto searchDto) throws Exception {
    	Map<String, Object> resultMap = new HashMap<String, Object>();

		List<ResourceCurrentConditionDto> rfidLogList = controlSystemService.resourceCondition(searchDto.gettId(), searchDto.getTcDay());
		resultMap.put("rfidLogList", rfidLogList);
    	return resultMap;
    }
    
    @RequestMapping("/gates/open/in")
    public Map<String, Object> gatesOpenIn() throws Exception {
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	
    	String[] success = {"T001-IN","T002-IN"}; 
    	String[] fail = {"T003-IN","T004-IN"}; 
    	resultMap.put("success", success);
    	resultMap.put("fail", fail);
    	
    	return resultMap;
    }
    
    @RequestMapping("/gates/open/out")
    public Map<String, Object> gatesOpenOut() throws Exception {
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	
    	String[] success = {"T001-OUT","T002-OUT"}; 
    	String[] fail = {"T003-OUT","T004-OUT"}; 
    	resultMap.put("success", success);
    	resultMap.put("fail", fail);
    	
    	return resultMap;
    }
    
    @RequestMapping("/gates/close/in")
    public Map<String, Object> gatesCloseIn() throws Exception {
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	
    	String[] success = {"T001-IN","T002-IN"}; 
    	String[] fail = {"T003-IN","T004-IN"}; 
    	resultMap.put("success", success);
    	resultMap.put("fail", fail);
    	
    	return resultMap;
    }
    
    @RequestMapping("/gates/close/out")
    public Map<String, Object> gatesCloseOut() throws Exception {
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	
    	String[] success = {"T001-OUT","T002-OUT"}; 
    	String[] fail = {"T003-OUT","T004-OUT"}; 
    	resultMap.put("success", success);
    	resultMap.put("fail", fail);
    	
    	return resultMap;
    }

	@RequestMapping("/search-driver-popup")
	public Map<String, Object> selectSearchDriverPopup(@RequestBody SearchDto searchDto) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<SearchDto> driverInfo = controlSystemService.selectSearchDriverPopup(searchDto);

		for(int i=0; i<driverInfo.size(); i++){
			driverInfo.get(i).setdName(AESCrypt.decrypt(driverInfo.get(i).getdName()));
		}

		resultMap.put("driverInfo", driverInfo);

		//토탈 카운트
		int cnt = controlSystemService.selectSearchDriverPopupCnt(searchDto);
		//페이징 처리
		Search search = new Search();
		search.setPageNo(searchDto.getPageNo());
		search.setPageSize(10);
		Paging paging = new Paging(search,cnt);
		resultMap.put("paging", paging);
		resultMap.put("totalCnt", cnt);
		return resultMap;
	}
    
    @RequestMapping("/search-driver")
    public Map<String, Object> selectSearchDriver(@RequestBody SearchDto searchDto) throws Exception {
    	Map<String, Object> resultMap = new HashMap<String, Object>();

    	NowGnrDto nowGnrDto = controlSystemService.selectSearchDriver(searchDto);

    	resultMap.put("driverInfo", nowGnrDto);
    	return resultMap;
    }
    
    @RequestMapping(value="/kakao-send", method=RequestMethod.POST)
    public ResultCode kakaoSend(@RequestBody TalkDto talkDto) throws Exception {

    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			return ResultCode.builder()
	                .code(403)
	                .message("로그인 후 이용해 주세요.")
	                .build();	
		}else {
			Integer code = 0;
			String message = "";
			
			String[] kakaoPhoneList = controlSystemService.selectKakaoPhoneList();
			String msg = talkDto.getMsg();
			
			if(msg.length()==0) {
				code = 400;
				message = "비상문구를 입력하세요.";
			}else {
				for(String phone : kakaoPhoneList) {
					System.out.println("phone : " + AESCrypt.decrypt(phone));
				}
				//TO DO 결과값 수정
				code = 200;
				message = "정상 발송되었습니다.";
			}
			return ResultCode.builder()
	                .code(code)
	                .message(message)
	                .build();	
		}
    }
    
    @GetMapping("/rfid")
    public ModelAndView rfidTest() throws Exception {
    	ModelAndView mav = new ModelAndView();
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
			List<TrackDto> trackList = controlSystemService.selectTrackList();
			List<EmergencyVo> emergencyList =  emergencyService.getEmergencyList(null);
			
			for(TrackDto track : trackList) {
				String[] trackNameAndKapaInfoArr = {track.getNick(), Fn.toString(track.getCnt(), "0"), Fn.toString(track.getMax(), "0") };
				mav.addObject(track.getId(), trackNameAndKapaInfoArr);
			}
			mav.addObject("emergencyList", emergencyList);
			
			mav.setViewName("/admin/controlsystem/rfid");
		}    	
    	
    	return mav;
    }
}
