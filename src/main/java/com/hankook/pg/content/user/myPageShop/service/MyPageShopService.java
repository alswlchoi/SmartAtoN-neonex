package com.hankook.pg.content.user.myPageShop.service;

import com.hankook.pg.content.user.myPageShop.dao.MyPageShopDao;
import com.hankook.pg.content.user.myPageShop.vo.MyPageShopVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MyPageShopService {

  @Autowired
  private MyPageShopDao myPageShopDao;

  public MyPageShopVo getScheduleDetail(MyPageShopVo myPageShopVo) {
    return myPageShopDao.getScheduleDetail(myPageShopVo);
  }

  public int updateSchedule (MyPageShopVo myPageShopVo) {
    return myPageShopDao.updateSchedule(myPageShopVo);
  }

  public String getDiscount (String compCode) {
    return myPageShopDao.getDiscount(compCode);
  }
}
