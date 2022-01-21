package com.hankook.pg.content.memHistory.service;

import com.hankook.pg.content.memHistory.dao.MemHistoryDao;
import com.hankook.pg.content.memHistory.vo.MemHistoryVo;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemHistoryService {

  @Autowired
  private MemHistoryDao memHistoryDao;

  public List<MemHistoryVo> getHistory() {
    return memHistoryDao.getHistory();
  }

  public int insertHistory (MemHistoryVo memHistoryVo) {
    return memHistoryDao.insertHistory(memHistoryVo);
  }

  public int updateHistory (MemHistoryVo memHistoryVo) {
    return memHistoryDao.updateHistory(memHistoryVo);
  }

  public int deleteHistory (MemHistoryVo memHistoryVo) {
    return memHistoryDao.deleteHistory(memHistoryVo);
  }
}
