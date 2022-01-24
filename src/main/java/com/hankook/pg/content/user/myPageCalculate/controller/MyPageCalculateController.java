package com.hankook.pg.content.user.myPageCalculate.controller;

import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.content.user.myPageCalculate.service.CalService;
import com.hankook.pg.content.user.myPageCalculate.vo.CalToPay;
import com.hankook.pg.content.user.myPageCalculate.vo.CalVo;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Search;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/user/myPageCal")
public class MyPageCalculateController {
	@Autowired
	private CalService calService;

	@RequestMapping(value = "", method = RequestMethod.GET)
	public ModelAndView calculate() throws Exception {
	    log.info("calculate");
	    ModelAndView mv = new ModelAndView("/user/myPageShop/calculate");
	    return mv;
	}
  	@PostMapping("/search")
	public Map<String, Object> searchList(@RequestBody CalVo calVo) throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto member = (MemberDto)authentication.getPrincipal();
		calVo.setRegUser(member.getMemId());
		//리스트 30개 조회
		calVo.setPageSize(30);
		List<CalVo> list = calService.searchList(calVo);
		//토탈 카운트
		int cnt = calService.searchListCnt(calVo);
		result.put("list", list);
		//페이징 처리
		Search search = new Search();
		search.setPageNo(calVo.getPageNo());
		search.setPageSize(30);
		Paging paging = new Paging(search,cnt);
		result.put("paging", paging);
		result.put("totalCnt", cnt);
		return result;
	}

  	@PostMapping("/popSearch")
  	public Map<String,Object> popSearch(@RequestParam(value="codeArr[]") String[] codeArr) throws Exception{
  		Map<String,Object> result = new HashMap<String,Object>();
  		System.out.println("codeArr ===========");
  		for(int i=0;i<codeArr.length;i++) {
  			System.out.println(codeArr[i]);
  		}
  		List<CalVo> list = calService.getOne(codeArr);
  		List<CalVo> inoutList = calService.getRfidLogList(codeArr);
  		List<CalToPay> payList = calService.getPayList(codeArr);
  		result.put("calVo", list);
  		result.put("inoutList", inoutList);
  		result.put("payList", payList);
  		return result;
  	}

//  	@GetMapping("/test")
//  	public Map<String,Object> test() throws Exception{
//  		Map<String,Object> map = new HashMap<String,Object>();
//  		try {
//  		int a = calService.insertPay("T211228B008");
//  		}catch (Exception e) {
//			e.printStackTrace();
//		}
//  		return map;
//  	}
}
