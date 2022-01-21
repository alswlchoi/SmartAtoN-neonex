package com.hankook.pg.content.admin.shop.dao;

import com.hankook.pg.content.admin.shop.vo.ShopVo;
import com.hankook.pg.content.admin.trReserve.dto.TrackDto;
import com.hankook.pg.content.admin.weekday.dto.WeekdayDto;
import com.hankook.pg.content.code.vo.CodeContentVo;
import com.hankook.pg.share.Search;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface ShopDao {

  List<ShopVo> selectShop (ShopVo shopVo);
  List<TrackDto> selectTrack ();

  int insertShop(ShopVo shopVo);
  int insertTrack(TrackDto trackDto);
  int deleteShop(ShopVo shopVo);
  int deleteTrack(TrackDto trackDto);

  List<WeekdayDto> getWeekDay();
  String getWdDay(WeekdayDto weekdayDto);
  int insertWeekDay(WeekdayDto weekdayDto);
  int updateWeekDay(WeekdayDto weekdayDto);
  int deleteWeekDay(WeekdayDto weekdayDto);

  int getWeekDayCnt(Search search);

  List<CodeContentVo> getCode(CodeContentVo codeContentVo);
}
