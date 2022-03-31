package com.hankook.pg.content.admin.testerManage.dao;

import com.hankook.pg.content.admin.rfid.vo.RfidVo;
import com.hankook.pg.content.admin.testerManage.vo.HintTesterVo;
import com.hankook.pg.content.admin.testerManage.vo.SearchTesterVo;
import com.hankook.pg.content.admin.testerManage.vo.TestCarVo;
import com.hankook.pg.content.admin.testerManage.vo.TesterVo;
import com.hankook.pg.content.admin.wiress.vo.WiressVo;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface TesterDao {

  List<TesterVo> getTesterInfo(SearchTesterVo searchTesterVo);
  int getTesterCnt(SearchTesterVo searchTesterVo);

  List<TesterVo> getDup(SearchTesterVo searchTesterVo);

  List<TestCarVo> getTestCar(SearchTesterVo searchTesterVo);

  int updateRW(TesterVo testerVo);

  int updateR(TesterVo testerVo);
  int updateRC(TestCarVo testCarVo);
  int updateW(TesterVo testerVo);

  int returnRW(TesterVo testerVo);
  int returnR(TesterVo testerVo);
  int returnRC(TestCarVo testCarVo);
  int returnW(TesterVo testerVo);

  int changeRW(HintTesterVo hintTesterVo);

  List<TesterVo> getTcSeq(TesterVo testerVo);

  // 평가자 및 평가차량관리
  List<TesterVo> hintTesterList(SearchTesterVo searchTesterVo);
  int getHintTesterCnt(SearchTesterVo searchTesterVo);

  List<TestCarVo> hintCarList(SearchTesterVo searchTesterVo);
  int getHintTestCarCnt(SearchTesterVo searchTesterVo);

  int hintRW(HintTesterVo hintTesterVo);
  int hintUpdate(HintTesterVo hintTesterVo);
  int hintReturn(HintTesterVo hintTesterVo);

  List<HintTesterVo> stopList(SearchTesterVo searchTesterVo);
  int stopListCnt(SearchTesterVo searchTesterVo);

  RfidVo rfidChk(HintTesterVo hintTesterVo);
  WiressVo wiressChk(HintTesterVo hintTesterVo);

  int rfidInOut(HintTesterVo hintTesterVo);
  int wiressInOut(HintTesterVo hintTesterVo);

  int rfidIdChk(HintTesterVo hintTesterVo);
  int wiressIdChk(HintTesterVo hintTesterVo);

  List<TestCarVo> getAllCCode(TestCarVo testCarVo);

  int hintUpdateRsMappingDrAndWr(HintTesterVo hintTesterVo);

  int hintReturnRsMappingDrAndWr(HintTesterVo hintTesterVo);

  int hintUpdateRsMappingCar(HintTesterVo hintTesterVo);

  int hintReturnRsMappingCar(HintTesterVo hintTesterVo);

}
