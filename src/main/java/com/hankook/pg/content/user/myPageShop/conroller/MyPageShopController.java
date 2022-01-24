package com.hankook.pg.content.user.myPageShop.conroller;

import com.hankook.pg.content.user.myPageShop.service.MyPageShopService;
import com.hankook.pg.content.user.myPageShop.vo.MyPageShopVo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@RestController
@RequestMapping("/user/myPageShop")
public class MyPageShopController {

  @Autowired
  MyPageShopService myPageShopService;

  @RequestMapping(value = "reserved", method = RequestMethod.GET)
  public ModelAndView reserved() throws Exception {
    log.info("reserved");
    ModelAndView mv = new ModelAndView("/user/myPageShop/reservedShop");
    return mv;
  }

  @RequestMapping(value = "endTest", method = RequestMethod.GET)
  public ModelAndView endTest() throws Exception {
    log.info("endTest");
    ModelAndView mv = new ModelAndView("/user/myPageShop/endTestShop");

    return mv;
  }

  @RequestMapping(value = "rejected", method = RequestMethod.GET)
  public ModelAndView rejected() throws Exception {
    log.info("rejected");
    ModelAndView mv = new ModelAndView("/user/myPageShop/rejectedShop");

    return mv;
  }

  @PostMapping("/detail")
  public MyPageShopVo selectUserShop(@RequestBody MyPageShopVo myPageShopVo) throws Exception {
    System.out.println("RESERVED SHOP detail");
    MyPageShopVo list = myPageShopService.getScheduleDetail(myPageShopVo);
    return list;
  }

  @PostMapping("/cancel")
  public int deleteUserShop(@RequestBody MyPageShopVo myPageShopVo) throws Exception {
    System.out.println("delete RESERVED SHOP");
    int result = myPageShopService.updateSchedule(myPageShopVo);
    return result;
  }

  @PostMapping("/discount")
  public String getDiscount(@RequestParam String compCode) throws Exception {
    String result = myPageShopService.getDiscount(compCode);
    return result;
  }

}
