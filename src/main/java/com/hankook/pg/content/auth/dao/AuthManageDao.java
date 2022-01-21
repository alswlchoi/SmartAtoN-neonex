package com.hankook.pg.content.auth.dao;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.auth.vo.AuthVO;
@Repository
@Mapper
public interface AuthManageDao {

	List<AuthVO> getAuthList(AuthVO authVo) throws SQLException;

	int insertAuth(AuthVO authVo) throws SQLException;

	int updateAuth(AuthVO authVo) throws SQLException;

	int deleteAuth(AuthVO authVo) throws SQLException;

}
