package com.hankook.pg.content.user.trReserve.dao;

import com.hankook.pg.content.admin.shop.vo.ShopVo;
import com.hankook.pg.content.admin.trReserve.dto.TrackDto;
import com.hankook.pg.content.user.trReserve.vo.MyPageVo;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface MyPageDao {

  List<MyPageVo> getReserveList(MyPageVo myPageVo);
  int getReserveListCnt(MyPageVo myPageVo);

  List<MyPageVo> getUseList(MyPageVo myPageVo);
  int getUseListCnt(MyPageVo myPageVo);

  List<ShopVo> getShop();
  TrackDto getFee();
  List<TrackDto> getTrack();

  MyPageVo getTrackDetail(String reservedCode);
  MyPageVo getShopDetail(String reservedCode);

  List<MyPageVo> getDriver(String reservedCode);
  List<MyPageVo> getCar(String reservedCode);

  int cancelTrack (MyPageVo myPageVo);
  int cancelShop (MyPageVo myPageVo);

  MyPageVo getTrackPrice(String reservedCode);
  MyPageVo getShopPrice(String reservedCode);
  String getDiscount(String compCode);

  int insertPay (MyPageVo myPageVo);

  // 일별 수정 이후 체크 -----> 사용!!
  int chkWeekDay(MyPageVo myPageVo);
  int chkDayOff(String chkDt);
  int chkSchedule (MyPageVo myPageVo);

}
