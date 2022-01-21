package com.hankook.pg.content.admin.testerManage.controller;

import com.hankook.pg.content.admin.shop.service.ShopService;
import com.hankook.pg.content.admin.testerManage.service.TesterService;
import com.hankook.pg.content.admin.testerManage.vo.HintTesterVo;
import com.hankook.pg.content.admin.testerManage.vo.SearchTesterVo;
import com.hankook.pg.content.admin.testerManage.vo.TestCarVo;
import com.hankook.pg.content.admin.testerManage.vo.TesterVo;
import com.hankook.pg.exception.valueRtnException;
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
@RequestMapping("/admin/testerManage")
public class testerManageController {

  @Autowired
  TesterService testerService;
  @Autowired
  ShopService shopService;

  @RequestMapping(value = "", method = RequestMethod.GET)
  public ModelAndView tester() throws Exception {
    log.info("Tester");
    ModelAndView mv = new ModelAndView("/admin/testResources/testerManage");

    return mv;
  }

  @RequestMapping(value = "/list")
  public Map<String, Object> selectTester(@RequestBody SearchTesterVo searchTesterVo) throws Exception {
    log.info("tester list");
    Map<String, Object> result = new HashMap<>();

    String[] arrOrderCoulmn = {"tcRegDt asc", "dSeq asc"};
    searchTesterVo.setArrOrderColumn(arrOrderCoulmn);
    searchTesterVo.setPageSize(20);

    List<TesterVo> list  = testerService.getTesterInfo(searchTesterVo);
    List<TestCarVo> car  = testerService.getTestCar(searchTesterVo);
    result.put("list", list);
    result.put("car", car);

    //토탈 카운트
    int cnt = testerService.getTesterCnt(searchTesterVo);
    //페이징 처리
    Search search = new Search();
    search.setPageNo(searchTesterVo.getPageNo());
    search.setPageSize(20);
    Paging paging = new Paging(search,cnt);
    result.put("paging", paging);
    result.put("totalCnt", cnt);
    return result;
  }

  @RequestMapping(value = "/car")
  public Map<String, Object> getCar(@RequestBody SearchTesterVo searchTesterVo) throws Exception {
    log.info("car list");
    Map<String, Object> result = new HashMap<>();

    String[] arrOrderCoulmn = {"num desc"};
    searchTesterVo.setArrOrderColumn(arrOrderCoulmn);

    List<TestCarVo> list  = testerService.getTestCar(searchTesterVo);
    result.put("list", list);
    return result;
  }

  @PostMapping(value = "/updateRW")
  public Map<String, Object> updateRW(@RequestBody TesterVo testerVo) throws Exception {
    System.out.println("updateRW");
    Map<String, Object> result = new HashMap<String, Object>();
    String update;
    try {
      update = testerService.updateRW(testerVo);
    } catch (valueRtnException e) {
      update = e.getValue().toString();
    }

    result.put("update", update);
    return result;
  }

  @PostMapping(value = "/updateR")
  public Map<String, Object> updateR(@RequestBody TesterVo testerVo) throws Exception {
    System.out.println("updateR");
    Map<String, Object> result = new HashMap<String, Object>();
    System.out.println(testerVo);
    String update = testerService.updateR(testerVo);

    result.put("update", update);
    return result;
  }
  @PostMapping(value = "/updateRC")
  public Map<String, Object> updateRC(@RequestBody TestCarVo testCarVo) throws Exception {
    System.out.println("updateRC");
    Map<String, Object> result = new HashMap<String, Object>();
    System.out.println(testCarVo);
    String update = testerService.updateRC(testCarVo);

    result.put("update", update);
    return result;
  }
  @PostMapping(value = "/updateW")
  public Map<String, Object> updateW(@RequestBody TesterVo testerVo) throws Exception {
    System.out.println("updateW");
    Map<String, Object> result = new HashMap<String, Object>();
    System.out.println(testerVo);
    String update = testerService.updateW(testerVo);

    result.put("update", update);
    return result;
  }

  @PostMapping(value = "/returnRW")
  public Map<String, Object> returnRW(@RequestBody TesterVo testerVo) throws Exception {
    System.out.println("returnRW");
    Map<String, Object> result = new HashMap<String, Object>();
    System.out.println(testerVo);
    String update = "";
    try {
      update = testerService.returnRW(testerVo);
    } catch (valueRtnException e) {
      update = e.getValue().toString();
    }

    result.put("update", update);
    return result;
  }
  @PostMapping(value = "/returnR")
  public Map<String, Object> returnR(@RequestBody TesterVo testerVo) throws Exception {
    System.out.println("returnR");
    Map<String, Object> result = new HashMap<String, Object>();
    System.out.println(testerVo);
    String update = testerService.returnR(testerVo);

    result.put("update", update);
    return result;
  }
  @PostMapping(value = "/returnRC")
  public Map<String, Object> returnRC(@RequestBody TestCarVo testCarVo) throws Exception {
    System.out.println("returnRC");
    Map<String, Object> result = new HashMap<String, Object>();
    System.out.println(testCarVo);
    String update = testerService.returnRC(testCarVo);

    result.put("update", update);
    return result;
  }
  @PostMapping(value = "/returnW")
  public Map<String, Object> returnW(@RequestBody TesterVo testerVo) throws Exception {
    System.out.println("returnW");
    Map<String, Object> result = new HashMap<String, Object>();
    System.out.println(testerVo);
    String update = testerService.returnW(testerVo);

    result.put("update", update);
    return result;
  }

  @PostMapping(value = "/changeRW")
  public Map<String, Object> changeRW(@RequestBody HintTesterVo hintTesterVo) throws Exception {
    System.out.println("changeRW");
    Map<String, Object> result = new HashMap<String, Object>();
    String update = testerService.changeRW(hintTesterVo);

    result.put("update", update);
    return result;
  }

  //
  // 평가자 및 평가차량관리
  //

  @RequestMapping(value = "hintTester", method = RequestMethod.GET)
  public ModelAndView hintTester() throws Exception {
    log.info("hintTester");
    ModelAndView mv = new ModelAndView("/admin/testResources/hintTester");

    return mv;
  }

  // 평가자 검색 리스트
  @RequestMapping(value = "/testerList")
  public Map<String, Object> testerList(@RequestBody SearchTesterVo searchTesterVo) throws Exception {
    log.info("testerList");
    Map<String, Object> result = new HashMap<>();

    String[] arrOrderCoulmn = {"crnDtm desc"};
    searchTesterVo.setArrOrderColumn(arrOrderCoulmn);

    List<TesterVo> tester = testerService.hintTesterList(searchTesterVo);

    result.put("tester", tester);
    //토탈 카운트
    int cnt = testerService.getHintTesterCnt(searchTesterVo);
    //페이징 처리
    Search search = new Search();
    search.setPageNo(searchTesterVo.getPageNo());
    search.setPageSize(10);
    Paging paging = new Paging(search,cnt);
    result.put("paging", paging);
    result.put("totalCnt", cnt);
    return result;
  }

  @RequestMapping(value = "/hintCar", method = RequestMethod.GET)
  public ModelAndView hintCar() throws Exception {
    log.info("hintCar");
    ModelAndView mv = new ModelAndView("/admin/testResources/hintCar");

    return mv;
  }

  // 평가차량 검색 리스트
  @RequestMapping(value = "/testCarList")
  public Map<String, Object> testCarList(@RequestBody SearchTesterVo searchTesterVo) throws Exception {
    log.info("testCarList");
    Map<String, Object> result = new HashMap<>();

    String[] arrOrderCoulmn = {"crnDtm desc"};
    searchTesterVo.setArrOrderColumn(arrOrderCoulmn);

    List<TestCarVo> car = testerService.hintCarList(searchTesterVo);

    result.put("car", car);
    //토탈 카운트
    int cnt = testerService.getHintTestCarCnt(searchTesterVo);
    //페이징 처리
    Search search = new Search();
    search.setPageNo(searchTesterVo.getPageNo());
    search.setPageSize(10);
    Paging paging = new Paging(search,cnt);
    result.put("paging", paging);
    result.put("totalCnt", cnt);
    return result;
  }

  // 평가차량 RFID 및 무전기 리스트
  @RequestMapping(value = "/testCarRWList")
  public Map<String, Object> testCarRWList(@RequestBody SearchTesterVo searchTesterVo) throws Exception {
    log.info("testCarList");
    Map<String, Object> result = new HashMap<>();
    List<TestCarVo> car = testerService.hintCarList(searchTesterVo);

    result.put("car", car);
    //토탈 카운트
    int cnt = testerService.getHintTestCarCnt(searchTesterVo);
    //페이징 처리
    Search search = new Search();
    search.setPageNo(searchTesterVo.getPageNo());
    search.setPageSize(10);
    Paging paging = new Paging(search,cnt);
    result.put("paging", paging);
    result.put("totalCnt", cnt);
    return result;
  }

  @PostMapping(value = "/hintRW")
  public Map<String, Object> hintRW(@RequestBody HintTesterVo hintTesterVo) throws Exception {
    System.out.println("hintRW");
    Map<String, Object> result = new HashMap<String, Object>();
    String update = testerService.hintRW(hintTesterVo);

    result.put("update", update);
    return result;
  }

  @PostMapping(value = "/hintUpdate")
  public Map<String, Object> hintUpdate(@RequestBody HintTesterVo hintTesterVo) throws Exception {
    System.out.println("hintUpdate");
    Map<String, Object> result = new HashMap<String, Object>();
    System.out.println(hintTesterVo);
    String update = testerService.hintUpdate(hintTesterVo);

    result.put("update", update);
    return result;
  }

  @PostMapping(value = "/hintReturn")
  public Map<String, Object> hintReturn(@RequestBody HintTesterVo hintTesterVo) throws Exception {
    System.out.println("hintReturn");
    System.out.println(hintTesterVo);
    Map<String, Object> result = new HashMap<String, Object>();
    String update = testerService.hintReturn(hintTesterVo);

    result.put("update", update);
    return result;
  }

  @RequestMapping(value = "hintStop", method = RequestMethod.GET)
  public ModelAndView hintStop() throws Exception {
    log.info("hintStop");
    ModelAndView mv = new ModelAndView("/admin/testResources/hintTesterStop");

    return mv;
  }

  // 평가자 일시정지 조회
  @RequestMapping(value = "/testerStop")
  public Map<String, Object> testerStop(@RequestBody SearchTesterVo searchTesterVo) throws Exception {
    log.info("testCarList");
    Map<String, Object> result = new HashMap<>();

    String[] arrOrderCoulmn = {"tcDay desc"};
    searchTesterVo.setArrOrderColumn(arrOrderCoulmn);

    List<HintTesterVo> stop = testerService.stopList(searchTesterVo);

    result.put("stop", stop);
    //토탈 카운트
    int cnt = testerService.stopListCnt(searchTesterVo);
    //페이징 처리
    Search search = new Search();
    search.setPageNo(searchTesterVo.getPageNo());
    search.setPageSize(10);
    Paging paging = new Paging(search,cnt);
    result.put("paging", paging);
    result.put("totalCnt", cnt);
    return result;
  }
}
