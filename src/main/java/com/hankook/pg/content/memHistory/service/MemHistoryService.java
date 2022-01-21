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

  public void insertHistory (MemHistoryVo memHistoryVo) {
    memHistoryDao.insertHistory(memHistoryVo);
  }

  public void updateHistory (MemHistoryVo memHistoryVo) {
    memHistoryDao.updateHistory(memHistoryVo);
  }

  public void deleteHistory (MemHistoryVo memHistoryVo) {
    memHistoryDao.deleteHistory(memHistoryVo);
  }
}
