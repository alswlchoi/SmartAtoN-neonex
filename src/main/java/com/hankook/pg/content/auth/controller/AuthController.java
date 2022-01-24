package com.hankook.pg.content.auth.controller;

import com.hankook.pg.content.auth.service.AuthService;
import com.hankook.pg.content.auth.vo.AuthVO;
import com.hankook.pg.content.menu.service.MenuService;
import com.hankook.pg.content.menu.vo.MenuVO;
import com.hankook.pg.exception.valueRtnException;
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
@RequestMapping("/system/auth")
public class AuthController {
	@Autowired
	private AuthService authService;
	@Autowired
	private MenuService menuService;
	@RequestMapping(value="",method= {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView getAuth() throws Exception {
		ModelAndView mv = new ModelAndView("/system/auth/auth");
		AuthVO authVO = new AuthVO();
		authVO.setPageSize(999);
		String[] arrOrderCoulmn = {"authCode"};
		authVO.setArrOrderColumn(arrOrderCoulmn);
		List<AuthVO> list = authService.getAuthList(authVO);
		List<MenuVO> menuList = menuService.getAllMenuList(null);
		mv.addObject("authList", list);
		mv.addObject("menuList", menuList);
		return mv;
	}
	@RequestMapping(value="/register",method= {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView register(@RequestParam(required = false) String authCode) throws Exception {
		ModelAndView mv = null;
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if(authCode==null) {
			//넘어온 파라미터가 없을 시
			mv = new ModelAndView("redirect:/adminLogin");
		}else {
			//제대로 파라미터 존재
			mv = new ModelAndView("/system/auth/register");
		}
		if(authentication.getPrincipal() instanceof String){
    		System.out.println("로그인xxxxx");
    		//세션이 종료되었을 시
    		mv= new ModelAndView("redirect:/adminLogin");
    	}else{
    		System.out.println("로그인ooooo");
    		//로그인 되어있을 시
    		mv = new ModelAndView("/system/auth/register");
    		//파라미터 권한코드
			mv.addObject("authCode",authCode);
			AuthVO authVO = new AuthVO();
			authVO.setPageSize(999);
			String[] arrOrderCoulmn = {"authCode"};
			authVO.setArrOrderColumn(arrOrderCoulmn);
			List<AuthVO> list = authService.getAuthList(authVO);
			mv.addObject("authList", list);
			//기존 선택한 메뉴 리스트
			MenuVO menuVo = new MenuVO();
			menuVo.setAuthCode(authCode);
			List<MenuVO> getMenuList = menuService.getMenuMappingList(menuVo);
			mv.addObject("getMenuList", getMenuList);
    	}
		return mv;
	}
	@PostMapping("/search")
	public Map<String, Object> searchAuth(@RequestBody AuthVO authVo) throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		System.out.println("권한관리 페이지 조회"+authVo+"/page="+authVo.getPageNo());
		//조회조건 정렬
		String[] arrOrderCoulmn = {"authCode desc"};
		authVo.setArrOrderColumn(arrOrderCoulmn);
		//리스트 10개 조회
		List<AuthVO> list = authService.getAuthList(authVo);
		//토탈 카운트
		int cnt = authService.getAuthListCnt(authVo);
		result.put("list", list);
		//페이징 처리
		Search search = new Search();
		search.setPageNo(authVo.getPageNo());
		search.setPageSize(10);
		Paging paging = new Paging(search,cnt);
		result.put("paging", paging);
		result.put("totalCnt", cnt);
		return result;
	}
	@PostMapping("/insert")
	public int insertAuth(@RequestBody AuthVO authVo) throws Exception {
		System.out.println("권한관리 등록"+authVo);
		authVo.setPageSize(9999);
		List<AuthVO> list = authService.getAuthList(authVo);
		int cnt = 0;
		if(list.size()>0) {
			cnt = 999;
		}else {
			cnt = authService.insertAuth(authVo);
		}
		return cnt;
	}
	@PostMapping("/upd")
	public int updateAuth(@RequestBody AuthVO authVo) throws Exception {
		System.out.println("권한관리 수정"+authVo);
		int cnt = authService.updateAuth(authVo);
		return cnt;
	}
	@PostMapping("/del")
	public int deleteAuth(@RequestBody AuthVO authVo) throws Exception {
		System.out.println("권한관리 삭재"+authVo);
		int cnt = 0;
		try {
			cnt=authService.deleteAuth(authVo);
		}catch (valueRtnException e) {
			cnt = 0;
		}
		return cnt;
	}
}
