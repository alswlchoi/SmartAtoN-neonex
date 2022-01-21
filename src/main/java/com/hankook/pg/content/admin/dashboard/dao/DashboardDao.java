package com.hankook.pg.content.admin.dashboard.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.admin.dashboard.vo.DashboardVo;
import com.hankook.pg.content.admin.statistics.dto.StatisticsVo;
@Repository
@Mapper
public interface DashboardDao {

	List<DashboardVo> getSearch() throws Exception;

	List<DashboardVo> capaSearch() throws Exception;

	List<StatisticsVo> getRoadTemp() throws Exception;

}
