package com.hankook.pg.content.admin.main.dao;

import com.hankook.pg.content.admin.main.vo.MainVo;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface MainDao {

  int getCompanyCnt();
  int getDriverCnt();
  int getRegisterCnt();
  int getDayDriverCnt();

  int getNTrackCnt();
  int getNShopCnt();

  int getDayTestingCnt(MainVo mainVo);
  int getDayShopCnt(MainVo mainVo);

  MainVo getWeather();
  MainVo getRoadTemp();
}
