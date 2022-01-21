package com.hankook.pg.content.admin.shop.controller;

import com.hankook.pg.content.admin.shop.service.ShopService;
import com.hankook.pg.content.admin.shop.vo.ShopVo;
import com.hankook.pg.content.admin.trReserve.dto.TrackDto;
import com.hankook.pg.content.admin.weekday.dto.WeekdayDto;
import com.hankook.pg.content.code.service.CodeService;
import com.hankook.pg.content.code.vo.CodeContentVo;
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
@RequestMapping("/admin/shop")
public class ShopController {

  @Autowired
  ShopService shopService;
  @Autowired
  CodeService codeService;

  @RequestMapping(value = "/shop", method = RequestMethod.GET)
  public ModelAndView shop() throws Exception {
    log.info("SHOP");
    ModelAndView mv = new ModelAndView("/admin/resourcesManage/shop");

    return mv;
  }

  @RequestMapping(value = "/track", method = RequestMethod.GET)
  public ModelAndView track() throws Exception {
    log.info("TRACK");
    ModelAndView mv = new ModelAndView("/admin/resourcesManage/track");

    return mv;
  }

  @PostMapping(value = "/list")
  public Map<String, Object> selectShop(@RequestBody ShopVo shopVo) throws Exception {
    System.out.println("SHOP list");
    Map<String, Object> result = new HashMap<String, Object>();

    List<ShopVo> shop = shopService.selectShop(shopVo);
    List<TrackDto> track = shopService.selectTrack();
    CodeContentVo codeContentVo = new CodeContentVo();
    codeContentVo.setCType("LEV");
    List<CodeContentVo> level = shopService.selectCodeList(codeContentVo);

    result.put("shop", shop);
    result.put("track", track);
    result.put("level", level);
    return result;
  }

  @RequestMapping(value = "/insertShop")
  public Map<String, Object> insertShop(@RequestBody ShopVo shopVo) throws Exception {
    System.out.println("insert SHOP");
    Map<String, Object> result = new HashMap<String, Object>();

    String alert = shopService.insertShop(shopVo);

    result.put("alert", alert);
    return result;
  }

  @RequestMapping(value = "/insertTrack")
  public Map<String, Object> insertTrack(@RequestBody TrackDto trackDto) throws Exception {
    System.out.println("insert Track");
    Map<String, Object> result = new HashMap<String, Object>();

    String alert = shopService.insertTrack(trackDto);

    result.put("alert", alert);
    return result;
  }

  @RequestMapping(value = "/deleteShop")
  public Map<String, Object> deleteShop(@RequestBody ShopVo shopVo) throws Exception {
    System.out.println("delete SHOP");
    Map<String, Object> result = new HashMap<String, Object>();
    String alert = shopService.deleteShop(shopVo);
    result.put("alert", alert);
    return result;
  }

  @RequestMapping(value = "/deleteTrack")
  public Map<String, Object> deleteTrack(@RequestBody TrackDto trackDto) throws Exception {
    System.out.println("delete Track");
    Map<String, Object> result = new HashMap<String, Object>();
    String alert = shopService.deleteTrack(trackDto);
    result.put("alert", alert);
    return result;
  }

  @RequestMapping(value = "/weekDay", method = RequestMethod.GET)
  public ModelAndView weekDay() throws Exception {
    log.info("weekDay");
    ModelAndView mv = new ModelAndView("/admin/resourcesManage/weekDayShop");

    return mv;
  }

  @RequestMapping(value = "/getWeekDay", method = RequestMethod.POST)
  public Map<String, Object> getWeekDay(@RequestBody Search search) throws Exception {
    Map<String, Object> result = new HashMap<String, Object>();

    String[] arrOrderCoulmn = {"num desc"};
    search.setArrOrderColumn(arrOrderCoulmn);
    ShopVo shopVo = new ShopVo();
    List<ShopVo> shop = shopService.selectShop(shopVo);
    List<WeekdayDto> weekDay = shopService.getWeekDay();

    result.put("shop", shop);
    result.put("weekDay", weekDay);
    //토탈 카운트
    int cnt = shopService.getWeekDayCnt(search);
    //페이징 처리
    search.setPageNo(search.getPageNo());
    search.setPageSize(10);
    Paging paging = new Paging(search,cnt);
    result.put("paging", paging);
    result.put("totalCnt", cnt);
    return result;
  }

  @RequestMapping(value = "/insertWeekDay")
  public Map<String, Object> insertWeekDay(@RequestBody WeekdayDto weekdayDto) throws Exception {
    System.out.println("insert WeekDay");
    Map<String, Object> result = new HashMap<String, Object>();
    String wdDay = shopService.getWdDay(weekdayDto);
    weekdayDto.setWdDay(wdDay);
    String alert = shopService.insertWeekDay(weekdayDto);
    result.put("alert", alert);
    return result;
  }

  @RequestMapping(value = "/updateWeekDay")
  public Map<String, Object> updateWeekDay(@RequestBody WeekdayDto weekdayDto) throws Exception {
    System.out.println("update WeekDay");
    Map<String, Object> result = new HashMap<String, Object>();
    String wdDay = shopService.getWdDay(weekdayDto);
    weekdayDto.setWdDay(wdDay);
    String alert = shopService.updateWeekDay(weekdayDto);
    result.put("alert", alert);
    return result;
  }

  @RequestMapping(value = "/deleteWeekDay")
  public Map<String, Object> deleteWeekDay(@RequestBody WeekdayDto weekdayDto) throws Exception {
    System.out.println("delete WeekDay");
    Map<String, Object> result = new HashMap<String, Object>();
    String alert = shopService.deleteWeekDay(weekdayDto);
    result.put("alert", alert);
    return result;
  }
}
