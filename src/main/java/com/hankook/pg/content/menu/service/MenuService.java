package com.hankook.pg.content.menu.service;

import java.util.List;

import com.hankook.pg.content.menu.vo.MenuVO;

public interface MenuService {

	List<MenuVO> getMenuMappingList(MenuVO menuVo) throws Exception;
	List<MenuVO> getAllMenuList(MenuVO menuVo) throws Exception;
	int updateMenu(MenuVO menuVO) throws Exception;
	//
}
