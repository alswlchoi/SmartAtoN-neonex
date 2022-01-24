package com.hankook.pg.content.auth.service;

import java.sql.SQLIntegrityConstraintViolationException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.hankook.pg.content.auth.dao.AuthManageDao;
import com.hankook.pg.content.auth.vo.AuthVO;
import com.hankook.pg.exception.valueRtnException;

import lombok.extern.slf4j.Slf4j;

@Service("AuthService")
@Slf4j
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class AuthServiceImpl implements AuthService{
	@Autowired
	private AuthManageDao authDao;

	@Override
	public List<AuthVO> getAuthList(AuthVO authVo) throws Exception{
		return authDao.getAuthList(authVo);
	}
	@Override
	public int insertAuth(AuthVO authVo) throws Exception{
		return authDao.insertAuth(authVo);
	}
	@Override
	public int updateAuth(AuthVO authVo) throws Exception{
		return authDao.updateAuth(authVo);
	}
	@Override
	@Transactional
	public int deleteAuth(AuthVO authVo) throws Exception{
		int cnt = 0 ;
		try {
			authDao.deleteMenuMapping(authVo);
			cnt = authDao.deleteAuth(authVo);
		}catch (SQLIntegrityConstraintViolationException e) {
			cnt = 0;
			throw new valueRtnException(cnt);
		}catch (DataIntegrityViolationException e) {
			cnt = 0;
			throw new valueRtnException(cnt);
		}
		return cnt;
	}
	@Override
	public int getAuthListCnt(AuthVO authVo) throws Exception {
		return authDao.getAuthListCnt(authVo);
	}
}
