package com.hankook.pg.content.admin.dccp.dao;

import com.hankook.pg.content.admin.dccp.vo.DccpVo;
import com.hankook.pg.content.admin.dccp.vo.SearchDccpVo;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface DccpDao {

  List<DccpVo> selectNurse(SearchDccpVo searchDccpVo);

  int insertNurse(DccpVo dccpVo);

  int updateNurse(DccpVo dccpVo);

  int deleteNurse(DccpVo dccpVo);

  int getDccpCnt(SearchDccpVo dccpVo);

  List<DccpVo> dccpDup(SearchDccpVo searchDccpVo);

  int updateDccpYn(DccpVo dccpVo);
}
