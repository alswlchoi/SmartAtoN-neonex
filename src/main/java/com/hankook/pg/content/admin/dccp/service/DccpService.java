package com.hankook.pg.content.admin.dccp.service;

import com.hankook.pg.content.admin.dccp.dao.DccpDao;
import com.hankook.pg.content.admin.dccp.vo.DccpVo;
import com.hankook.pg.content.admin.dccp.vo.SearchDccpVo;
import com.hankook.pg.share.AESCrypt;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DccpService {

  @Autowired
  private DccpDao dccpDao;

  public List<DccpVo> selectNurse (SearchDccpVo searchDccpVo) throws Exception {
    searchDccpVo.setEnText(AESCrypt.encrypt(searchDccpVo.getText()));
    List<DccpVo> dccpList = dccpDao.selectNurse(searchDccpVo);

    for (int i=0; i<dccpList.size(); i++) {
      dccpList.get(i).setDName(AESCrypt.decrypt(dccpList.get(i).getDName()));
    }

    return dccpList;
  }

  public int insertNurse (DccpVo dccpVo) {
    dccpDao.updateDccpYn(dccpVo);
    return dccpDao.insertNurse(dccpVo);
  }

  public int updateNurse (DccpVo dccpVo) {
    dccpDao.updateDccpYn(dccpVo);
    return dccpDao.updateNurse(dccpVo);
  }

  public int deleteNurse (DccpVo dccpVo) {
    return dccpDao.deleteNurse(dccpVo);
  }

  public int getDccpCnt(SearchDccpVo dccpVo) {
    return dccpDao.getDccpCnt(dccpVo);
  }

  public List<DccpVo> dccpDup(SearchDccpVo searchDccpVo) {
    return dccpDao.dccpDup(searchDccpVo);
  }
}
