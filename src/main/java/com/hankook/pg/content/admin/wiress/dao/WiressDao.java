package com.hankook.pg.content.admin.wiress.dao;

import com.hankook.pg.content.admin.wiress.vo.SearchWiressVo;
import com.hankook.pg.content.admin.wiress.vo.WiressVo;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface WiressDao {

  List<WiressVo> selectWiress(SearchWiressVo wiressVo);

  int insertWiress(WiressVo wiressVo);

  int updateWiress(WiressVo wiressVo);

  int deleteWiress(WiressVo wiressVo);

  String getMaxId();

  int getWiressCnt(SearchWiressVo searchWiressVo);

  int chkWQr(WiressVo wiressVo);
}
