package com.hankook.pg.content.user.myPageShop.dao;

import com.hankook.pg.content.user.myPageShop.vo.MyPageShopVo;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface MyPageShopDao {
  MyPageShopVo getScheduleDetail(MyPageShopVo myPageShopVo);

  int updateSchedule(MyPageShopVo myPageShopVo);

  String getDiscount(String compCode);
}
