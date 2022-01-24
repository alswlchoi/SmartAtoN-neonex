package com.hankook.pg.content.admin.shop.service;

import com.hankook.pg.content.admin.shop.dao.ShopDao;
import com.hankook.pg.content.admin.shop.vo.ShopVo;
import com.hankook.pg.content.admin.trReserve.dto.TrackDto;
import com.hankook.pg.content.admin.weekday.dto.WeekdayDto;
import com.hankook.pg.content.code.vo.CodeContentVo;
import com.hankook.pg.share.Search;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ShopService {

  @Autowired
  private ShopDao shopDao;

  public List<ShopVo> selectShop(ShopVo shopVo) {
    return shopDao.selectShop(shopVo);
  }
  public List<TrackDto> selectTrack() {
    return shopDao.selectTrack();
  }

  public String insertShop (ShopVo shopVo) {
    int result = shopDao.insertShop(shopVo);
    if (result == 0) {
      return "저장에 실패했습니다.";
    } else {
      return "저장에 성공했습니다.";
    }
  }

  public String insertTrack (TrackDto trackDto) {
    int result = shopDao.insertTrack(trackDto);
    if (result == 0) {
      return "저장에 실패했습니다.";
    } else {
      return "저장에 성공했습니다.";
    }
  }

  public String deleteShop (ShopVo shopVo) {
    int result = shopDao.deleteShop(shopVo);
    if (result == 0) {
      return "삭제에 실패했습니다.";
    } else {
      return "삭제에 성공했습니다.";
    }
  }

  public String deleteTrack (TrackDto trackDto) {
    int result = shopDao.deleteTrack(trackDto);
    if (result == 0) {
      return "삭제에 실패했습니다.";
    } else {
      return "삭제에 성공했습니다.";
    }
  }

  public List<WeekdayDto> getWeekDay() {
    return shopDao.getWeekDay();
  }

  public String getWdDay(WeekdayDto weekdayDto) {
    return shopDao.getWdDay(weekdayDto);
  }

  public String insertWeekDay(WeekdayDto weekdayDto) {
    int result = shopDao.insertWeekDay(weekdayDto);
    if (result == 0) {
      return "저장에 실패했습니다.";
    } else {
      return "저장에 성공했습니다.";
    }
  }

  public String updateWeekDay(WeekdayDto weekdayDto) {
    int result = shopDao.updateWeekDay(weekdayDto);
    if (result == 0) {
      return "저장에 실패했습니다.";
    } else {
      return "저장에 성공했습니다.";
    }
  }

  public String deleteWeekDay(WeekdayDto weekdayDto) {
    int result = shopDao.deleteWeekDay(weekdayDto);
    if (result == 0) {
      return "삭제에 실패했습니다.";
    } else {
      return "삭제에 성공했습니다.";
    }
  }

  public int getWeekDayCnt(Search search) {
    return shopDao.getWeekDayCnt(search);
  }

  public List<CodeContentVo> selectCodeList(CodeContentVo codeContentVo) {
    return shopDao.getCode(codeContentVo);
  }

}
