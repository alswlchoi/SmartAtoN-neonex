package com.hankook.pg.content.memHistory.controller;

import com.hankook.pg.content.memHistory.service.MemHistoryService;
import com.hankook.pg.content.memHistory.vo.MemHistoryVo;
import java.util.List;
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
@RequestMapping("/system/memHistory")
public class MemHistoryController {

  @Autowired
  MemHistoryService memHistoryService;

  @RequestMapping(value = "", method = RequestMethod.GET)
  public ModelAndView getHistory() throws Exception {
    log.info("로그인 이력");
    ModelAndView mv = new ModelAndView("/system/memHistory/memHistory");

    return mv;
  }

  @PostMapping(value = "/list")
  public List<MemHistoryVo> historyList() throws Exception {
    System.out.println("login list");
    List<MemHistoryVo> list = memHistoryService.getHistory();
    return list;
  }

  @RequestMapping(value = "/insert")
  public void insertHistory(@RequestBody MemHistoryVo memHistoryVo) throws Exception {
    System.out.println("insert history");
    memHistoryService.insertHistory(memHistoryVo);
  }

  @RequestMapping(value = "/update", method = RequestMethod.PUT)
  public void updateHistory(@RequestBody MemHistoryVo memHistoryVo) throws Exception {
    System.out.println("update history");
    memHistoryService.updateHistory(memHistoryVo);
  }

  @RequestMapping(value = "/delete", method = RequestMethod.DELETE)
  public void deleteHistory(@RequestBody MemHistoryVo memHistoryVo) throws Exception {
    System.out.println("delete history");
    memHistoryService.deleteHistory(memHistoryVo);
  }
}
