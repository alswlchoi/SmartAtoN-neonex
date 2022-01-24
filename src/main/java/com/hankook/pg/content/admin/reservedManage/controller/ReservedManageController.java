package com.hankook.pg.content.admin.reservedManage.controller;

import com.hankook.pg.content.admin.reservedManage.service.ReservedManageService;
import com.hankook.pg.content.admin.reservedManage.vo.ReservedManageVo;
import com.hankook.pg.content.admin.reservedManage.vo.SearchReservedManageVo;
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
@RequestMapping("/admin/reserved")
public class ReservedManageController {

  @Autowired
  ReservedManageService reservedManageService;

  @RequestMapping(value = "shop", method = RequestMethod.GET)
  public ModelAndView shop() throws Exception {
    log.info("Reserved Shop");
    ModelAndView mv = new ModelAndView("/admin/reservedManage/shopReserved");

    return mv;
  }

  @PostMapping(value = "/list")
  public Map<String, Object> getReservedShopList(@RequestBody SearchReservedManageVo searchReservedManageVo) throws Exception {
    System.out.println("reserved list");
    Map<String, Object> result = new HashMap<String, Object>();

    String order1 = searchReservedManageVo.getOrderKind1();
    String order2 = searchReservedManageVo.getOrderKind2();
    if (order1.equals("ASC") && order2.equals("ASC")) {
      String[] arrOrderCoulmn = {"wssRegDt asc", " wssEdDay asc"};
      searchReservedManageVo.setArrOrderColumn(arrOrderCoulmn);
    } else if (order1.equals("ASC")  && order2.equals("DESC")) {
      String[] arrOrderCoulmn = {"wssRegDt asc", "wssEdDay desc"};
      searchReservedManageVo.setArrOrderColumn(arrOrderCoulmn);
    } else if (order1.equals("DESC")  && order2.equals("ASC")) {
      String[] arrOrderCoulmn = {"wssRegDt desc", " wssEdDay asc"};
      searchReservedManageVo.setArrOrderColumn(arrOrderCoulmn);
    } else if (order1.equals("DESC")  && order2.equals("DESC")) {
      String[] arrOrderCoulmn = {"wssRegDt desc", " wssEdDay asc"};
      searchReservedManageVo.setArrOrderColumn(arrOrderCoulmn);
    }

    searchReservedManageVo.setPageSize(20);
    List<ReservedManageVo> list = reservedManageService.getReservedShopList(searchReservedManageVo);
    result.put("list", list);
    //토탈 카운트
    int cnt = reservedManageService.getReservedShopListCnt(searchReservedManageVo);
    //페이징 처리
    Search search = new Search();
    search.setPageNo(searchReservedManageVo.getPageNo());
    search.setPageSize(20);
    Paging paging = new Paging(search,cnt);
    result.put("paging", paging);
    result.put("totalCnt", cnt);
    return result;
  }

  @RequestMapping(value = "detail", method = RequestMethod.GET)
  public ModelAndView detail() throws Exception {
    log.info("Reserved Shop Detail");
    ModelAndView mv = new ModelAndView("/admin/reservedManage/shopReservedDetail");

    return mv;
  }

  @PostMapping(value = "/detailInfo")
  public Map<String, Object> getReservedShopDetail(@RequestBody SearchReservedManageVo searchReservedManageVo) throws Exception {
    System.out.println("reserved detail");
    Map<String, Object> result = new HashMap<String, Object>();

    ReservedManageVo reservedShop = reservedManageService.getReservedShopDetail(searchReservedManageVo);
    result.put("list", reservedShop);
    return result;
  }

  @PostMapping(value = "/update")
  public int updateApproval(@RequestBody ReservedManageVo reservedManageVo) throws Exception {
    System.out.println("update approval");
    int result = reservedManageService.updateApproval(reservedManageVo);
    return result;
  }

  @PostMapping(value = "/memo")
  public int updateMemo(@RequestBody ReservedManageVo reservedManageVo) throws Exception {
    System.out.println("update memo");

    int result = reservedManageService.updateMemo(reservedManageVo);

    return result;
  }

  // Schedule
  @RequestMapping(value = "schedule", method = RequestMethod.GET)
  public ModelAndView schedule() throws Exception {
    log.info("schedule Shop");
    ModelAndView mv = new ModelAndView("/admin/scheduleManage/shopSchedule");

    return mv;
  }

  @RequestMapping(value = "scheduleDetail", method = RequestMethod.GET)
  public ModelAndView scheduleDetail() throws Exception {
    log.info("schedule Shop Detail");
    ModelAndView mv = new ModelAndView("/admin/scheduleManage/shopScheduleDetail");

    return mv;
  }
}
