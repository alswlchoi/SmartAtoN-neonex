package com.hankook.pg.content.menu.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.hankook.pg.content.menu.dao.MenuManageDao;
import com.hankook.pg.content.menu.vo.MenuVO;

import lombok.extern.slf4j.Slf4j;

@Service("MenuService")
@Slf4j
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class MenuServiceImpl implements MenuService{
	@Autowired
	private MenuManageDao menuDao;

	@Override
	public List<MenuVO> getMenuMappingList(MenuVO menuVo) throws Exception{
		return menuDao.getMenuMappingList(menuVo);
	}
	@Override
	public List<MenuVO> getAllMenuList(MenuVO menuVo) throws Exception{
		return menuDao.getAllMenuList(menuVo);
	}
	@Override
	public int updateMenu(MenuVO menuVo) throws Exception{
//		return menuDao.updateMenu(menuVo);
		menuDao.deleteMenuMapping(menuVo);
		if(menuVo.getChkArr().length>0) {
			int cnt = 0;
			for(int i=0;i<menuVo.getChkArr().length;i++) {
				cnt++;
				menuVo.setMenuCode(menuVo.getChkArr()[i]);
				menuDao.insertMenuMapping(menuVo);
			}
			return cnt;
		}else {
			System.out.println("등록 없이 삭제만");
			return 1;
		}
	}
}
