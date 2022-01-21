package com.hankook.pg.content.emergency.controller;

import com.hankook.pg.content.emergency.service.EmergencyService;
import com.hankook.pg.content.emergency.vo.EmergencyVo;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Search;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/admin/emergency")
public class EmergencyController {
	@Autowired
	private EmergencyService emergencyService;

	@RequestMapping(value="",method= {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView getEmergency() throws Exception {
		ModelAndView mv = new ModelAndView("/system/emergency/emergency");
		return mv;
	}
	@PostMapping("/search")
	public Map<String, Object> searchEmergency(@RequestBody EmergencyVo emergencyVo) throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		//조회조건 정렬
		String[] arrOrderCoulmn = {"emergencyCode desc"};
		emergencyVo.setArrOrderColumn(arrOrderCoulmn);
		//리스트 10개 조회
		List<EmergencyVo> list = emergencyService.getEmergencyList(emergencyVo);
		//토탈 카운트
		int cnt = emergencyService.getEmergencyListCnt(emergencyVo);
		result.put("list", list);
		//페이징 처리
		Search search = new Search();
		search.setPageNo(emergencyVo.getPageNo());
		search.setPageSize(10);
		Paging paging = new Paging(search,cnt);
		result.put("paging", paging);
		result.put("totalCnt", cnt);
		return result;
	}
	@PostMapping("/max")
	public Map<String, Object> maxSearch() throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		String emergencyCode = emergencyService.getNext();
		result.put("emergencyCode", emergencyCode);
		return result;
	}
	@PostMapping("/insert")
	public int insert(@RequestBody EmergencyVo emer) throws Exception {
		int cnt = emergencyService.insertEmergency(emer);
		return cnt;
	}
	@PostMapping("/del")
	public int del(@RequestBody EmergencyVo emer) throws Exception {
		int cnt = emergencyService.deleteEmergency(emer);
		return cnt;
	}
	@PostMapping("/upd")
	public int upd(@RequestBody EmergencyVo emer) throws Exception {
		int cnt = emergencyService.updateEmergency(emer);
		return cnt;
	}
}
