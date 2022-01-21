package com.hankook.pg.content.admin.rfid.controller;

import com.hankook.pg.content.admin.rfid.service.RfidService;
import com.hankook.pg.content.admin.rfid.vo.RfidVo;
import com.hankook.pg.content.admin.rfid.vo.SearchRfidVo;
import com.hankook.pg.content.admin.shop.service.ShopService;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Search;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@RestController
@RequestMapping("/admin/rfid")
public class RfidController {

  @Autowired
  RfidService rfidService;
  @Autowired
  ShopService shopService;

  @RequestMapping(value = "", method = RequestMethod.GET)
  public ModelAndView rfid() throws Exception {
    log.info("RFID");
    ModelAndView mv = new ModelAndView("/admin/resourcesManage/rfid");

    return mv;
  }

  @PostMapping(value = "/list")
  public Map<String, Object> selectRfid(@RequestBody SearchRfidVo searchRfidVo) throws Exception {
    System.out.println("RFID list");
    Map<String, Object> result = new HashMap<String, Object>();

    String[] arrOrderCoulmn = {"num desc"};
    searchRfidVo.setArrOrderColumn(arrOrderCoulmn);
    searchRfidVo.setPageSize(20);
    List<RfidVo> list = rfidService.selectRfid(searchRfidVo);
    String maxId = rfidService.getMaxId();

    result.put("rfid", list);
    result.put("maxId", maxId);
    //토탈 카운트
    int cnt = rfidService.getRfidCnt(searchRfidVo);
    //페이징 처리
    Search search = new Search();
    search.setPageNo(searchRfidVo.getPageNo());
    search.setPageSize(20);
    Paging paging = new Paging(search,cnt);
    result.put("paging", paging);
    result.put("totalCnt", cnt);
    return result;
  }

  @RequestMapping(value = "/insert")
  public Map<String, Object> insertRfid(@RequestBody RfidVo rfidVo) throws Exception {
    System.out.println("insert RFID");
    Map<String, Object> result = new HashMap<String, Object>();
    String alert = rfidService.insertRfid(rfidVo);
    result.put("alert", alert);
    return result;
  }

  @RequestMapping(value = "/update")
  public Map<String, Object> updateRfid(@RequestBody RfidVo rfidVo) throws Exception {
    System.out.println("update RFID");
    Map<String, Object> result = new HashMap<String, Object>();
    String alert = rfidService.updateRfid(rfidVo);
    result.put("alert", alert);
    return result;
  }

  @RequestMapping(value = "/delete")
  public int deleteRfid(@RequestBody RfidVo rfidVo) throws Exception {
    System.out.println("delete RFID");
    int result = rfidService.deleteRfid(rfidVo);
    return result;
  }

  @PostMapping("/chkRQr")
  public int chkRQr(@RequestBody RfidVo rfidVo) throws Exception {
    int result = rfidService.chkRQr(rfidVo);
    return result;
  }
  @PostMapping("/chkTagId")
  public int chkTagId(@RequestBody RfidVo rfidVo) throws Exception {
    int result = rfidService.chkTagId(rfidVo);
    return result;
  }
  @PostMapping("/chkRSerial")
  public int chkRSerial(@RequestBody RfidVo rfidVo) throws Exception {
    int result = rfidService.chkRSerial(rfidVo);
    return result;
  }
}
