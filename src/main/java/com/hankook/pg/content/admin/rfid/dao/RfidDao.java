package com.hankook.pg.content.admin.rfid.dao;

import com.hankook.pg.content.admin.rfid.vo.RfidVo;
import com.hankook.pg.content.admin.rfid.vo.SearchRfidVo;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface RfidDao {

  List<RfidVo> selectRfid(SearchRfidVo searchRfidVo);

  int insertRfid(RfidVo rfidVo);

  int updateRfid(RfidVo rfidVo);

  int deleteRfid(RfidVo rfidVo);

  String getMaxId();

  int getRfidCnt(SearchRfidVo searchRfidVo);

  int chkRQr(RfidVo rfidVo);
  int chkTagId(RfidVo rfidVo);
  int chkRSerial(RfidVo rfidVo);
}
