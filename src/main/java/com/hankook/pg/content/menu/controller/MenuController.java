package com.hankook.pg.content.menu.controller;

import com.hankook.pg.content.auth.service.AuthService;
import com.hankook.pg.content.auth.vo.AuthVO;
import com.hankook.pg.content.menu.service.MenuService;
import com.hankook.pg.content.menu.vo.MenuVO;
import com.hankook.pg.security.UrlFilterInvocationSecurityMetadataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/system/menu")
public class MenuController {
	@Autowired
	private MenuService menuService;
	@Autowired
	private AuthService authService;
	@Autowired
	private UrlFilterInvocationSecurityMetadataSource urlFilterInvocationSecurityMetadataSource;


	@RequestMapping(value="",method= {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView getMenu() throws Exception {
		log.debug("메뉴관리 페이지 접속");
		System.out.println("메뉴관리 페이지 접속");
		ModelAndView mv = new ModelAndView("/system/menu/menu");
		List<AuthVO> authList = authService.getAuthList(null);
		mv.addObject("authList",authList);
		List<MenuVO> menuList = menuService.getAllMenuList(null);
		mv.addObject("menuList",menuList);
		return mv;
	}
	@PostMapping("/search")
	public List<MenuVO> searchMenu(@RequestBody MenuVO menuVo) throws Exception {
		System.out.println("메뉴관리 페이지 조회"+menuVo);
		List<MenuVO> list = menuService.getMenuMappingList(menuVo);
		System.out.println("메뉴관리 페이지 조회11111111111"+list);
		return list;
	}
	@PostMapping("/update")
	public int updateMenu(@RequestBody MenuVO menuVo) throws Exception {
//		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//    	MemberDto newMemDto = (MemberDto)authentication.getPrincipal();
		int cnt = menuService.updateMenu(menuVo);
		urlFilterInvocationSecurityMetadataSource.reload();
		return cnt;
	}
}
