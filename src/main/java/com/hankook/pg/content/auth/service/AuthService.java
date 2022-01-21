package com.hankook.pg.content.auth.service;

import java.util.List;

import com.hankook.pg.content.auth.vo.AuthVO;

public interface AuthService {

	List<AuthVO> getAuthList(AuthVO authVo) throws Exception;

	int insertAuth(AuthVO authVo) throws Exception;

	int updateAuth(AuthVO authVo) throws Exception;

	int deleteAuth(AuthVO authVo) throws Exception;

	int getAuthListCnt(AuthVO authVo) throws Exception;

}
