package com.hankook.pg.content.login.dao;

import com.hankook.pg.content.login.dto.MenuDto;
import org.springframework.stereotype.Repository;

import java.sql.SQLException;
import java.util.List;

@Repository
public interface LoginDao {
    List<MenuDto> getMenuList() throws SQLException;
}
