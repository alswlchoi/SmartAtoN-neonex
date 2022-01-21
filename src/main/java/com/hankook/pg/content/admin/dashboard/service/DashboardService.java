package com.hankook.pg.content.admin.dashboard.service;

import java.util.List;

import com.hankook.pg.content.admin.dashboard.vo.DashboardVo;
import com.hankook.pg.content.admin.statistics.dto.StatisticsVo;

public interface DashboardService {

	List<DashboardVo> getSearch() throws Exception;

	List<DashboardVo> capaSearch() throws Exception;

	List<StatisticsVo> getRoadTemp() throws Exception;

}
