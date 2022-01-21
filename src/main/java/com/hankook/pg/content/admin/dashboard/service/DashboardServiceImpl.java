package com.hankook.pg.content.admin.dashboard.service;

import java.sql.SQLIntegrityConstraintViolationException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.hankook.pg.content.admin.dashboard.dao.DashboardDao;
import com.hankook.pg.content.admin.dashboard.vo.DashboardVo;
import com.hankook.pg.content.admin.statistics.dto.StatisticsVo;
import com.hankook.pg.content.auth.dao.AuthManageDao;
import com.hankook.pg.share.AESCrypt;

import lombok.extern.slf4j.Slf4j;

@Service("DashboardService")
@Slf4j
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class DashboardServiceImpl implements DashboardService{
	@Autowired
	private DashboardDao dashboardDao;

	@Override
	public List<DashboardVo> getSearch() throws Exception {
		List<DashboardVo> list = dashboardDao.getSearch();
		for(int i=0;i<list.size();i++) {
			list.get(i).setDName(AESCrypt.decrypt(list.get(i).getDName()));
		}
		return list;
	}

	@Override
	public List<DashboardVo> capaSearch() throws Exception {
		return dashboardDao.capaSearch();
	}

	@Override
	public List<StatisticsVo> getRoadTemp() throws Exception {
		return dashboardDao.getRoadTemp();
	}

}
