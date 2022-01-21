package com.hankook.pg.content.admin.dccp.controller;

import com.hankook.pg.content.admin.dccp.service.DccpService;
import com.hankook.pg.content.admin.dccp.vo.DccpVo;
import com.hankook.pg.content.admin.dccp.vo.SearchDccpVo;
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
@RequestMapping("/admin/dccp")
public class DccpController {

  @Autowired
  DccpService dccpService;

  @RequestMapping(value = "", method = RequestMethod.GET)
  public ModelAndView nurse() throws Exception {
    log.info("Nurse");
    ModelAndView mv = new ModelAndView("/admin/testResources/dccp");

    return mv;
  }

  @PostMapping(value = "/list")
  public Map<String, Object> selectNurse(@RequestBody SearchDccpVo searchDccpVo) throws Exception {
    System.out.println("nurse list");
    Map<String, Object> result = new HashMap<String, Object>();

    String[] arrOrderCoulmn = {"num desc"};
    searchDccpVo.setArrOrderColumn(arrOrderCoulmn);
    searchDccpVo.setPageSize(20);

    List<DccpVo> list = dccpService.selectNurse(searchDccpVo);
    result.put("dccp", list);
    List<DccpVo> dup = dccpService.dccpDup(searchDccpVo);
    result.put("dup", dup);
    //토탈 카운트
    int cnt = dccpService.getDccpCnt(searchDccpVo);
    //페이징 처리
    Search search = new Search();
    search.setPageNo(searchDccpVo.getPageNo());
    search.setPageSize(20);
    Paging paging = new Paging(search,cnt);
    result.put("paging", paging);
    result.put("totalCnt", cnt);
    return result;
  }

  @RequestMapping(value = "/insert")
  public int insertNurse(@RequestBody DccpVo dccpVo) throws Exception {
    System.out.println("insert nurse");
    int result = dccpService.insertNurse(dccpVo);

    return result;
  }

  @RequestMapping(value = "/update")
  public int updateNurse(@RequestBody DccpVo dccpVo) throws Exception {
    System.out.println("update nurse");
    System.out.println(dccpVo);
    int result = dccpService.updateNurse(dccpVo);
    return result;
  }

  @RequestMapping(value = "/delete", method = RequestMethod.DELETE)
  public int deleteNurse(@RequestBody DccpVo dccpVo) throws Exception {
    System.out.println("delete nurse");
    int result = dccpService.deleteNurse(dccpVo);
    return result;
  }
}
