package com.hankook.pg.content.admin.reservedManage.dao;

import com.hankook.pg.content.admin.reservedManage.vo.ReservedManageVo;
import com.hankook.pg.content.admin.reservedManage.vo.SearchReservedManageVo;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface ReservedManageDao {

  List<ReservedManageVo> getReservedShopList(SearchReservedManageVo searchReservedManageVo);

  int getReservedShopListCnt(SearchReservedManageVo searchReservedManageVo);

  ReservedManageVo getReservedShopDetail(SearchReservedManageVo searchReservedManageVo);

  int updateApproval(ReservedManageVo reservedManageVo);

  int updateMemo(ReservedManageVo reservedManageVo);
}
