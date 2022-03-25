package com.hankook.pg.content.admin.testerManage.service;

import com.hankook.pg.content.admin.rfid.vo.RfidVo;
import com.hankook.pg.content.admin.testerManage.dao.TesterDao;
import com.hankook.pg.content.admin.testerManage.vo.HintTesterVo;
import com.hankook.pg.content.admin.testerManage.vo.SearchTesterVo;
import com.hankook.pg.content.admin.testerManage.vo.TestCarVo;
import com.hankook.pg.content.admin.testerManage.vo.TesterVo;
import com.hankook.pg.content.admin.wiress.vo.WiressVo;
import com.hankook.pg.exception.valueRtnException;
import com.hankook.pg.share.AESCrypt;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TesterService {

  @Autowired
  private TesterDao testerDao;

  public List<TesterVo> getTesterInfo(SearchTesterVo searchTesterVo) throws Exception {
    searchTesterVo.setEnText(AESCrypt.encrypt(searchTesterVo.getText()));
    List<TesterVo> testerVoList = testerDao.getTesterInfo(searchTesterVo);

    for (int i=0; i<testerVoList.size(); i++) {
      testerVoList.get(i).setDName(AESCrypt.decrypt(testerVoList.get(i).getDName()));
    }

    return testerVoList;
  }
  public int getTesterCnt(SearchTesterVo SearchTesterVo) {
    return testerDao.getTesterCnt(SearchTesterVo);
  }

  public List<TesterVo> getDup(SearchTesterVo searchTesterVo) {
    return testerDao.getDup(searchTesterVo);
  }

  public List<TestCarVo> getTestCar(SearchTesterVo searchTesterVo) {
    return testerDao.getTestCar(searchTesterVo);
  }

  @Transactional
  public String updateRW(TesterVo testerVo){
    // 사람 RFID&무전기
    HintTesterVo hintTesterVo = new HintTesterVo();
    hintTesterVo.setRQrId(testerVo.getRQrId());
    hintTesterVo.setWQrId(testerVo.getWQrId());
    RfidVo rfidVo = rfidChk(hintTesterVo);
    WiressVo wiressVo = wiressChk(hintTesterVo);
    if (rfidVo == null) {
      return "존재하지 않는 RFID 입니다.";
    } else if (rfidVo.getRInOut().equals("O")) {
      return "이미 사용중인 RFID 입니다.";
    } else {
      hintTesterVo.setRId(rfidVo.getRId());
      testerVo.setRId(rfidVo.getRId());
    }
    if (wiressVo == null) {

      return "존재하지 않는 무전기 입니다.";
    } else if (wiressVo.getWInOut().equals("O")) {
      return "이미 사용중인 무전기 입니다.";
    } else {
      hintTesterVo.setWId(wiressVo.getWId());
      testerVo.setWId(wiressVo.getWId());
    }
    // 차량 RFID
    System.out.println(testerVo.getCar());
    for(int i=0; i < testerVo.getCar().size(); i++) {
      TestCarVo testCarVo = new TestCarVo();
      testCarVo = testerVo.getCar().get(i);
      testCarVo.setTcDay(testerVo.getDate());

      HintTesterVo carChk = new HintTesterVo();
      carChk.setRQrId(testCarVo.getRQrId());
      RfidVo carRfidVo = rfidChk(carChk);
      if (carRfidVo == null) {
        throw new valueRtnException("존재하지 않는 RFID 입니다.("+(i+1)+"번째 차량)");
      } else if (carRfidVo.getRInOut().equals("O")) {
        throw new valueRtnException("이미 사용중인 RFID 입니다.("+(i+1)+"번째 차량)");
      } else {
        carChk.setRId(carRfidVo.getRId());
        testCarVo.setRId(carRfidVo.getRId());
      }

      List<TestCarVo> cCodes = testerDao.getAllCCode(testCarVo);
      System.out.println(cCodes);
      if (cCodes.size() != 0) {
        for (int j=0; j<cCodes.size(); j++) {
          testCarVo.setCCode(cCodes.get(j).getCCode());
          int result1 = testerDao.updateRC(testCarVo);

          if (result1 == 0) {
            throw new valueRtnException("발급에 실패했습니다.(차량)");
          } else {
            carChk.setInOut("O");
            testerDao.rfidInOut(carChk);
          }
        }
      } else {
        int result1 = testerDao.updateRC(testCarVo);

        if (result1 == 0) {
          throw new valueRtnException("발급에 실패했습니다.(차량)");
        } else {
          hintTesterVo.setInOut("O");
          testerDao.rfidInOut(hintTesterVo);
        }
      }
    }

    List<TesterVo> tcSeq = testerDao.getTcSeq(testerVo);
    for (int j=0; j < tcSeq.size(); j++) {
      System.out.println(tcSeq.get(j).getTcSeq());
      testerVo.setTcSeq(tcSeq.get(j).getTcSeq());
      int result = testerDao.updateRW(testerVo);
      if (result == 0) {
        throw new valueRtnException("발급에 실패했습니다.");
      }
    }
    hintTesterVo.setInOut("O");
    testerDao.rfidInOut(hintTesterVo);
    testerDao.wiressInOut(hintTesterVo);
    return "발급에 성공했습니다.";
  }

  public String updateRC(TestCarVo testCarVo) {
    HintTesterVo hintTesterVo = new HintTesterVo();
    hintTesterVo.setRQrId(testCarVo.getRQrId());
    RfidVo rfidVo = rfidChk(hintTesterVo);
    if (rfidVo == null) {
      return "존재하지 않는 RFID 입니다.(차량)";
    } else if (rfidVo.getRInOut().equals("O")) {
      return "이미 사용중인 RFID 입니다.(차량)";
    } else {
      hintTesterVo.setRId(rfidVo.getRId());
      testCarVo.setRId(rfidVo.getRId());
    }
    int result = testerDao.updateRC(testCarVo);
    if (result == 0) {
      return "발급에 실패했습니다.(차량)";
    } else {
      hintTesterVo.setInOut("O");
      testerDao.rfidInOut(hintTesterVo);
      return "발급에 성공했습니다.";
    }
  }

  /*사용안함*/
  public String updateR(TesterVo testerVo) {
    HintTesterVo hintTesterVo = new HintTesterVo();
    hintTesterVo.setRQrId(testerVo.getRQrId());
    RfidVo rfidVo = rfidChk(hintTesterVo);
    if (rfidVo == null) {
      return "존재하지 않는 RFID 입니다.";
    } else if (rfidVo.getRInOut().equals("O")) {
      return "이미 사용중인 RFID 입니다.";
    } else {
      hintTesterVo.setRId(rfidVo.getRId());
      testerVo.setRId(rfidVo.getRId());
    }
    int result = testerDao.updateR(testerVo);
    if (result == 0) {
      return "발급에 실패했습니다.";
    } else {
      hintTesterVo.setInOut("O");
      testerDao.rfidInOut(hintTesterVo);
      return "발급에 성공했습니다.";
    }
  }

  /*사용안함*/
  public String updateW(TesterVo testerVo) {
    HintTesterVo hintTesterVo = new HintTesterVo();
    hintTesterVo.setWQrId(testerVo.getWQrId());
    WiressVo wiressVo = wiressChk(hintTesterVo);
    if (wiressVo == null) {
      return "존재하지 않는 무전기 입니다.";
    } else if (wiressVo.getWInOut().equals("O")) {
      return "이미 사용중인 무전기 입니다.";
    } else {
      hintTesterVo.setWId(wiressVo.getWId());
      testerVo.setWId(wiressVo.getWId());
    }
    int result = testerDao.updateW(testerVo);
    if (result == 0) {
      return "발급에 실패했습니다.";
    } else {
      hintTesterVo.setInOut("O");
      testerDao.wiressInOut(hintTesterVo);
      return "발급에 성공했습니다.";
    }
  }

  @Transactional
  public String returnRW(TesterVo testerVo) {
    System.out.println(testerVo);
    System.out.println(testerVo.getCar());
    for(int i=0; i < testerVo.getCar().size(); i++) {
      TestCarVo car = testerVo.getCar().get(i);
      int result = testerDao.returnRC(car);
      if (result == 0) {
        return "반납에 실패했습니다.";
      } else {
        HintTesterVo hintTesterVo = new HintTesterVo();
        hintTesterVo.setRId(car.getRQrId());
        hintTesterVo.setInOut("I");
        testerDao.rfidInOut(hintTesterVo);
      }
    }

    List<TesterVo> tcSeq = testerDao.getTcSeq(testerVo);
    for (int j=0; j < tcSeq.size(); j++) {
      testerVo.setTcSeq(tcSeq.get(j).getTcSeq());
      int result = testerDao.returnRW(testerVo);
      if (result == 0) {
        return "반납에 실패했습니다.";
      }
    }
    HintTesterVo hintTesterVo = new HintTesterVo();
    hintTesterVo.setRId(testerVo.getRId());
    hintTesterVo.setWId(testerVo.getWId());
    hintTesterVo.setInOut("I");
    testerDao.rfidInOut(hintTesterVo);
    testerDao.wiressInOut(hintTesterVo);
    return "반납에 성공했습니다.";
  }
  /*사용안함*/
  public String returnRC(TestCarVo testCarVo) {
    int result = testerDao.returnRC(testCarVo);
    if (result == 0) {
      return "반납에 실패했습니다.";
    } else {
      HintTesterVo hintTesterVo = new HintTesterVo();
      hintTesterVo.setRId(testCarVo.getRId());
      hintTesterVo.setInOut("I");
      testerDao.rfidInOut(hintTesterVo);
      return "반납에 성공했습니다.";
    }
  }
  /*사용안함*/
  public String returnR(TesterVo testerVo) {
    int result = testerDao.returnR(testerVo);
    if (result == 0) {
      return "반납에 실패했습니다.";
    } else {
      HintTesterVo hintTesterVo = new HintTesterVo();
      hintTesterVo.setRId(testerVo.getRId());
      hintTesterVo.setWId(testerVo.getWId());
      hintTesterVo.setInOut("I");
      testerDao.rfidInOut(hintTesterVo);
      return "반납에 성공했습니다.";
    }
  }
  /*사용안함*/
  public String returnW(TesterVo testerVo) {
    int result = testerDao.returnW(testerVo);
    if (result == 0) {
      return "반납에 실패했습니다.";
    } else {
      HintTesterVo hintTesterVo = new HintTesterVo();
      hintTesterVo.setWId(testerVo.getWId());
      hintTesterVo.setInOut("I");
      testerDao.wiressInOut(hintTesterVo);
      return "반납에 성공했습니다.";
    }
  }

  @Transactional
  public String changeRW(HintTesterVo hintTesterVo){
    HintTesterVo bHint = new HintTesterVo();
    if (hintTesterVo.getRQrId() != null) {
      bHint.setRId(hintTesterVo.getBRId());
      RfidVo rfidVo = rfidChk(hintTesterVo);
      if (rfidVo == null) {
        return "등록되지 않은 RFID 입니다.";
      }
      if (rfidVo.getRInOut().equals("O")) {
        return "이미 사용중인 RFID 입니다.";
      } else {
        hintTesterVo.setRId(rfidVo.getRId());
        hintTesterVo.setWId(null);
      }
    } else {
      bHint.setWId(hintTesterVo.getBWId());
      WiressVo wiressVo = wiressChk(hintTesterVo);
      if (wiressVo == null) {
        return "등록되지 않은 무전기 입니다.";
      }
      if (wiressVo.getWInOut().equals("O")) {
        return "이미 사용중인 무전기 입니다.";
      } else {
        hintTesterVo.setRId(null);
        hintTesterVo.setWId(wiressVo.getWId());
      }
    }

    TesterVo testerVo = new TesterVo();
    testerVo.setDate(hintTesterVo.getDate());
    testerVo.setDSeq(hintTesterVo.getDSeq());
    List<TesterVo> tcSeq = testerDao.getTcSeq(testerVo);
    for (int j=0; j < tcSeq.size(); j++) {
      hintTesterVo.setTcSeq(tcSeq.get(j).getTcSeq());
      int result = testerDao.changeRW(hintTesterVo);
      if (result == 0) {
        throw new valueRtnException("발급에 실패했습니다.");
      }
    }

    int result = testerDao.changeRW(hintTesterVo);
    if (result == 0) {
      return "발급에 실패했습니다.";
    } else {
      bHint.setInOut("I");
      hintTesterVo.setInOut("O");
      if (hintTesterVo.getRQrId() != null) {
        bHint.setRId(hintTesterVo.getBRId());
        testerDao.rfidInOut(bHint);
        testerDao.rfidInOut(hintTesterVo);
      } else {
        bHint.setWId(hintTesterVo.getBWId());
        testerDao.wiressInOut(bHint);
        testerDao.wiressInOut(hintTesterVo);
      }
      return "발급에 성공했습니다.";
    }
  }

  // 평가자 및 평가차량 관리
  public List<TesterVo> hintTesterList(SearchTesterVo searchTesterVo) {
    return testerDao.hintTesterList(searchTesterVo);
  }
  public int getHintTesterCnt(SearchTesterVo SearchTesterVo) {
    return testerDao.getHintTesterCnt(SearchTesterVo);
  }

  public List<TestCarVo> hintCarList(SearchTesterVo searchTesterVo) {
    return testerDao.hintCarList(searchTesterVo);
  }
  public int getHintTestCarCnt(SearchTesterVo SearchTesterVo) {
    return testerDao.getHintTestCarCnt(SearchTesterVo);
  }

  public String  hintRW(HintTesterVo hintTesterVo) {
    RfidVo rfidVo = rfidChk(hintTesterVo);
    if (rfidVo == null) {
      return "존재하지 않는 RFID 입니다.";
    } else if (rfidVo.getRInOut().equals("O")) {
      return "이미 사용중인 RFID 입니다.";
    } else {
      hintTesterVo.setRId(rfidVo.getRId());
    }
    if (hintTesterVo.getHrType().equals("D")) {
      WiressVo wiressVo = wiressChk(hintTesterVo);
      if (wiressVo == null) {
        return "존재하지 않는 RFID 입니다.";
      } else if (wiressVo.getWInOut().equals("O")) {
        return "이미 사용중인 무전기 입니다.";
      } else {
        hintTesterVo.setWId(wiressVo.getWId());
      }
    }

    int result = testerDao.hintRW(hintTesterVo);
    if (result == 0) {
      return "발급에 실패했습니다.";
    } else {
      hintTesterVo.setInOut("O");
      testerDao.rfidInOut(hintTesterVo);
      if (hintTesterVo.getHrType().equals("D")) {
        testerDao.wiressInOut(hintTesterVo);
      }
      return "발급에 성공했습니다.";
    }
  }
  public String hintUpdate(HintTesterVo hintTesterVo) {
    HintTesterVo bHint = new HintTesterVo();
    if (hintTesterVo.getRQrId() != null) {
      bHint.setRId(hintTesterVo.getBRId());
      RfidVo rfidVo = rfidChk(hintTesterVo);
      if (rfidVo == null) {
        return "등록되지 않은 RFID 입니다.";
      }
      if (rfidVo.getRInOut().equals("O")) {
        return "이미 사용중인 RFID 입니다.";
      } else {
        hintTesterVo.setRId(rfidVo.getRId());
        hintTesterVo.setWId(null);
      }
    } else {
      bHint.setWId(hintTesterVo.getBWId());
      WiressVo wiressVo = wiressChk(hintTesterVo);
      if (wiressVo == null) {
        return "등록되지 않은 무전기 입니다.";
      }
      if (wiressVo.getWInOut().equals("O")) {
        return "이미 사용중인 무전기 입니다.";
      } else {
        hintTesterVo.setRId(null);
        hintTesterVo.setWId(wiressVo.getWId());
      }
    }
    int result = testerDao.hintUpdate(hintTesterVo);
    if (result == 0) {
      return "발급에 실패했습니다.";
    } else {
      bHint.setInOut("I");
      hintTesterVo.setInOut("O");
      if (hintTesterVo.getRQrId() != null) {
        bHint.setRId(hintTesterVo.getBRId());
        testerDao.rfidInOut(bHint);
        testerDao.rfidInOut(hintTesterVo);
        testerDao.hintUpdateRsMappingDrAndWr(hintTesterVo);
      } else {
        bHint.setWId(hintTesterVo.getBWId());
        testerDao.wiressInOut(bHint);
        testerDao.wiressInOut(hintTesterVo);
        testerDao.hintUpdateRsMappingDrAndWr(hintTesterVo);
      }
      return "발급에 성공했습니다.";
    }
  }

  public String hintReturn(HintTesterVo hintTesterVo) {   //평가자, 평가차량
    HintTesterVo bHint = new HintTesterVo();
    int result = testerDao.hintReturn(hintTesterVo);
    if (result == 0) {
      return "반납에 실패했습니다.";
    } else {
      if(hintTesterVo.getHrType().equals("R")){
        hintTesterVo.setInOut("I");
        testerDao.rfidInOut(hintTesterVo);
        testerDao.wiressInOut(hintTesterVo);
        testerDao.hintReturnRsMappingDrAndWr(hintTesterVo);
      }else if(hintTesterVo.getHrType().equals("W")){
        hintTesterVo.setInOut("I");
        testerDao.rfidInOut(hintTesterVo);
        testerDao.wiressInOut(hintTesterVo);
        testerDao.hintReturnRsMappingDrAndWr(hintTesterVo);
      }else{
        hintTesterVo.setInOut("I");
        testerDao.rfidInOut(hintTesterVo);
        testerDao.wiressInOut(hintTesterVo);
        bHint.setVhclCode(hintTesterVo.getVhclCode());
        testerDao.hintReturnRsMappingCar(hintTesterVo);
      }
      return "반납에 성공했습니다.";
    }
  }


  public List<HintTesterVo> stopList(SearchTesterVo searchTesterVo) {
    return testerDao.stopList(searchTesterVo);
  }
  public int stopListCnt(SearchTesterVo SearchTesterVo) {
    return testerDao.stopListCnt(SearchTesterVo);
  }

  public RfidVo rfidChk(HintTesterVo hintTesterVo) {
    return testerDao.rfidChk(hintTesterVo);
  }
  public WiressVo wiressChk(HintTesterVo hintTesterVo) {
    return testerDao.wiressChk(hintTesterVo);
  }

}
