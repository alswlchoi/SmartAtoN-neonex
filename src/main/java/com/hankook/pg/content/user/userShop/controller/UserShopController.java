package com.hankook.pg.content.user.userShop.controller;

import com.hankook.pg.content.admin.dayoff.dto.DayoffDto;
import com.hankook.pg.content.admin.dayoff.dto.SearchDayoffDto;
import com.hankook.pg.content.admin.dayoff.service.DayoffService;
import com.hankook.pg.content.admin.weekday.dto.WeekdayDto;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.content.user.userShop.service.UserShopService;
import com.hankook.pg.content.user.userShop.vo.UserShopVo;
import java.util.ArrayList;
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
@RequestMapping("/user/userShop")
public class UserShopController {

  @Autowired
  UserShopService userShopService;

  @Autowired
  DayoffService dayoffService;

  @RequestMapping(value = "", method = RequestMethod.GET)
  public ModelAndView shop() throws Exception {
    log.info("RESERVED SHOP");
    ModelAndView mv = new ModelAndView("/user/userShop/userShop");

    return mv;
  }

  @PostMapping("/list")
  public Map<String, Object> selectUserShop(@RequestBody UserShopVo userShopVo) throws Exception {
    System.out.println("RESERVED SHOP list");
    Map<String, Object> result = new HashMap<String, Object>();
    if (userShopVo.getWdKind() != null) {
      userShopVo.setWsCode(userShopVo.getWdKind());
    }
    ArrayList shop = userShopService.selectUserShop(userShopVo);
    String wdKind = userShopVo.getWdKind();
    List<WeekdayDto> weekday = userShopService.getWeekDay(wdKind);
    List<WeekdayDto> bWeek = userShopService.getBWDay();
    SearchDayoffDto searchDayoffDto = new SearchDayoffDto();
    searchDayoffDto.setDoKind(userShopVo.getDoKind());
    List<DayoffDto> dayOff = dayoffService.getDayoffList(searchDayoffDto);

    result.put("shop", shop);
    result.put("weekday", weekday);
    result.put("bWeek", bWeek);
    result.put("dayOff", dayOff);

    return result;
  }

  @PostMapping("/insert")
  public int insertUserShop(@RequestBody UserShopVo userShopVo) throws Exception {
    System.out.println("insert RESERVED SHOP");
    int result = userShopService.insertUserShop(userShopVo);

    return result;
  }

  @PostMapping("/update")
  public int updateUserShop(@RequestBody UserShopVo userShopVo) throws Exception {
    System.out.println("update RESERVED SHOP");
    int result = userShopService.updateUserShop(userShopVo);
    return result;
  }

  @PostMapping("/delete")
  public int deleteUserShop(@RequestBody UserShopVo userShopVo) throws Exception {
    System.out.println("delete RESERVED SHOP");
    int result = userShopService.deleteUserShop(userShopVo);
    return result;
  }

  @PostMapping("/getUserInfo")
  public MemberDto getUserInfo(@RequestBody MemberDto memberDto) throws Exception {
    MemberDto list = userShopService.getUserInfo(memberDto);
    return list;
  }

  @RequestMapping(value = "reserved", method = RequestMethod.GET)
  public ModelAndView reserved() throws Exception {
    log.info("RESERVED SHOP");
    ModelAndView mv = new ModelAndView("/user/userShop/reservedShop");

    return mv;
  }

  @PostMapping("/chk")
  public int chkSchedule(@RequestBody UserShopVo userShopVo) throws Exception {
    System.out.println("chk RESERVED SHOP");
    int result = userShopService.chkSchedule(userShopVo);
    return result;
  }

  @PostMapping("/getEvents")
  public List<UserShopVo> getEvents(@RequestBody UserShopVo userShopVo) throws Exception {
    List<UserShopVo> list = userShopService.getEvents(userShopVo);
    return list;
  }

  @PostMapping("/getDayoffList")
  public List<DayoffDto> getEvents(@RequestBody SearchDayoffDto searchDayoffDto) throws Exception {
    List<DayoffDto> list = dayoffService.getDayoffList(searchDayoffDto);
    return list;
  }

  @PostMapping("/getWeekDay")
  public List<WeekdayDto> getWeekDay(@RequestBody UserShopVo userShopVo) throws Exception {
    String wsCode = userShopVo.getWsCode();
    List<WeekdayDto> list = userShopService.getWeekDay(wsCode);
    return list;
  }

  @PostMapping("/getApplyDate")
  public UserShopVo getApplyDate(@RequestBody UserShopVo userShopVo) throws Exception {
    System.out.println("getApplyDate");
    UserShopVo date = userShopService.getApplyDate(userShopVo);
    return date;
  }

  @PostMapping("/reservChk")
  public int reservChk(@RequestBody UserShopVo userShopVo) throws Exception {
    System.out.println("reservChk");
    int result = userShopService.reservChk(userShopVo);
    return result;
  }
}
