package com.hankook.pg.content.admin.rfid.service;

import com.hankook.pg.content.admin.rfid.dao.RfidDao;
import com.hankook.pg.content.admin.rfid.vo.RfidVo;
import com.hankook.pg.content.admin.rfid.vo.SearchRfidVo;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RfidService {

  @Autowired
  private RfidDao rfidDao;

  public List<RfidVo> selectRfid(SearchRfidVo searchRfidVo) {
    return rfidDao.selectRfid(searchRfidVo);
  }

  public String insertRfid (RfidVo rfidVo) {
    int qr = rfidDao.chkRQr(rfidVo);
    int serial = rfidDao.chkRSerial(rfidVo);
    int tagId = rfidDao.chkTagId(rfidVo);
    if (qr > 0) {
      return "중복되는 QRcode가 존재합니다.";
    } else if (serial > 0) {
      return "중복되는 Serial NO.가 존재합니다.";
    } else if (tagId > 0) {
      return "중복되는 Tag ID가 존재합니다.";
    } else {
      int result = rfidDao.insertRfid(rfidVo);
      if (result == 0) {
        return "저장에 실패했습니다.";
      } else {
        return "저장에 성공했습니다.";
      }
    }
  }

  public String updateRfid (RfidVo rfidVo) {
    int result = rfidDao.updateRfid(rfidVo);
    if (result == 0) {
      return "저장에 실패했습니다.";
    } else {
      return "저장에 성공했습니다.";
    }
  }

  public int deleteRfid (RfidVo rfidVo) {
    return rfidDao.deleteRfid(rfidVo);
  }

  public String getMaxId(){
    return rfidDao.getMaxId();
  }

  public int getRfidCnt (SearchRfidVo searchRfidVo) {
    return rfidDao.getRfidCnt(searchRfidVo);
  }

  public int chkRQr(RfidVo rfidVo) {
    return rfidDao.chkRQr(rfidVo);
  }
  public int chkTagId(RfidVo rfidVo) {
    return rfidDao.chkTagId(rfidVo);
  }
  public int chkRSerial(RfidVo rfidVo) {
    return rfidDao.chkRSerial(rfidVo);
  }
}
