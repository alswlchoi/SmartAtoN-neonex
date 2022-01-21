package com.hankook.pg.content.memHistory.dao;

import com.hankook.pg.content.memHistory.vo.MemHistoryVo;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface MemHistoryDao {

  List<MemHistoryVo> getHistory();

  int insertHistory(MemHistoryVo memHistoryVo);

  int updateHistory(MemHistoryVo memHistoryVo);

  int deleteHistory(MemHistoryVo memHistoryVo);
}
