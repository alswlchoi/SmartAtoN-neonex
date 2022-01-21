package com.hankook.pg.content.admin.wiress.controller;

import com.hankook.pg.content.admin.wiress.service.WiressService;
import com.hankook.pg.content.admin.wiress.vo.SearchWiressVo;
import com.hankook.pg.content.admin.wiress.vo.WiressVo;
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
@RequestMapping("/admin/wiress")
public class WiressController {

  @Autowired
  WiressService wiressService;

  @RequestMapping(value = "", method = RequestMethod.GET)
  public ModelAndView wiress() throws Exception {
    log.info("무전기");
    ModelAndView mv = new ModelAndView("/admin/resourcesManage/wiress");

    return mv;
  }

  @PostMapping("/list")
  public Map<String, Object> selectWiress(@RequestBody SearchWiressVo searchWiressVo) throws Exception {
    System.out.println("wiress list");
    Map<String, Object> result = new HashMap<String, Object>();

    String[] arrOrderCoulmn = {"num desc"};
    searchWiressVo.setArrOrderColumn(arrOrderCoulmn);
    List<WiressVo> list = wiressService.selectWiress(searchWiressVo);
    String maxId = wiressService.getMaxId();

    result.put("wiress", list);
    result.put("maxId", maxId);
    //토탈 카운트
    int cnt = wiressService.getWiressCnt(searchWiressVo);
    //페이징 처리
    Search search = new Search();
    search.setPageNo(searchWiressVo.getPageNo());
    search.setPageSize(10);
    Paging paging = new Paging(search,cnt);
    result.put("paging", paging);
    result.put("totalCnt", cnt);
    return result;
  }

  @PostMapping("/insert")
  public Map<String, Object> insertHistory(@RequestBody WiressVo wiressVo) throws Exception {
    System.out.println("insert wiress");
    System.out.println(wiressVo);
    Map<String, Object> result = new HashMap<String, Object>();
    String alert = wiressService.insertWiress(wiressVo);
    result.put("alert", alert);
    return result;
  }

  @PostMapping("/update")
  public Map<String, Object> updateHistory(@RequestBody WiressVo wiressVo) throws Exception {
    System.out.println("update wiress");
    System.out.println(wiressVo);
    Map<String, Object> result = new HashMap<String, Object>();
    String alert = wiressService.updateWiress(wiressVo);
    result.put("alert", alert);
    return result;
  }

  @PostMapping("/delete")
  public int deleteHistory(@RequestBody WiressVo wiressVo) throws Exception {
    System.out.println("delete wiress");
    int result = wiressService.deleteWiress(wiressVo);
    return result;
  }
}
