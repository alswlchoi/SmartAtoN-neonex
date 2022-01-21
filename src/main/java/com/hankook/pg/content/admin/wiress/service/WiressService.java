package com.hankook.pg.content.admin.wiress.service;

import com.hankook.pg.content.admin.wiress.dao.WiressDao;
import com.hankook.pg.content.admin.wiress.vo.SearchWiressVo;
import com.hankook.pg.content.admin.wiress.vo.WiressVo;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class WiressService {

  @Autowired
  private WiressDao wiressDao;

  public List<WiressVo> selectWiress(SearchWiressVo wiressVo) {
    return wiressDao.selectWiress(wiressVo);
  }

  public String insertWiress (WiressVo wiressVo) {
    int qr = wiressDao.chkWQr(wiressVo);
    if (qr > 0) {
      return "중복되는 QRcode가 존재합니다.";
    } else {
      int result = wiressDao.insertWiress(wiressVo);
      if (result == 0) {
        return "저장에 실패했습니다.";
      } else {
        return "저장에 성공했습니다.";
      }
    }
  }

  public String updateWiress (WiressVo wiressVo) {
    int result = wiressDao.updateWiress(wiressVo);
    if (result == 0) {
      return "저장에 실패했습니다.";
    } else {
      return "저장에 성공했습니다.";
    }
  }

  public int deleteWiress (WiressVo wiressVo) {
    return wiressDao.deleteWiress(wiressVo);
  }

  public String getMaxId(){
    return wiressDao.getMaxId();
  }

  public int getWiressCnt(SearchWiressVo searchWiressVo) {
    return wiressDao.getWiressCnt(searchWiressVo);
  }

}
