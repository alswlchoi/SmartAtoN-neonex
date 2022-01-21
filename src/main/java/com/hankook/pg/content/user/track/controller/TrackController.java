package com.hankook.pg.content.user.track.controller;

import com.hankook.pg.content.user.userShop.service.UserShopService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@RestController
@RequestMapping("/user/track")
public class TrackController {

  @Autowired
  UserShopService userShopService;

  @RequestMapping(value = "", method = RequestMethod.GET)
  public ModelAndView track() throws Exception {
    log.info("track");
    ModelAndView mv = new ModelAndView("/user/intro/trackDetail");

    return mv;
  }
}
