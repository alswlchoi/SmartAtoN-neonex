package com.hankook.pg.content.menu.dao;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.menu.vo.MenuVO;
@Repository
@Mapper
public interface MenuManageDao {

	List<MenuVO> getMenuMappingList(MenuVO menuVO) throws SQLException;
	List<MenuVO> getAllMenuList(MenuVO menuVO) throws SQLException;
	int updateMenu(MenuVO menuVO) throws SQLException;
	int deleteMenuMapping(MenuVO menuVO) throws SQLException;
	int insertMenuMapping(MenuVO menuVO) throws SQLException;

}
