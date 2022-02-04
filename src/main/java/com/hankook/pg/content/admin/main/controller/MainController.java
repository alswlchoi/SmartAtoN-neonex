package com.hankook.pg.content.admin.main.controller;

import com.hankook.pg.content.admin.main.service.MainService;
import com.hankook.pg.content.admin.main.vo.MainVo;
import com.hankook.pg.content.admin.notice.dto.NoticeDto;
import com.hankook.pg.content.admin.notice.service.NoticeService;
import com.hankook.pg.mail.service.EmailService;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@RestController
@RequestMapping("/admin/main")
public class MainController {

  @Autowired
  MainService mainService;
  @Autowired
  NoticeService noticeService;
  @Autowired
  EmailService emailService;

  @RequestMapping(value = "", method = RequestMethod.GET)
  public ModelAndView main() throws Exception {
    log.info("MAIN");
	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

	ModelAndView mv = new ModelAndView();
	if (authentication.getPrincipal() instanceof String) {
		mv.setViewName("redirect:/adminLogin");
	} else {
		mv.setViewName("/admin/adminMain");
	}
    return mv;
  }

  @RequestMapping(value = "/list")
  public Map<String, Object> mainList() throws Exception {
    System.out.println("main list");
    Map<String, Object> result = new HashMap<String, Object>();

    MainVo mainVo = mainService.setMainVo();

    result.put("mainVo", mainVo);

    return result;
  }

  @RequestMapping(value = "/dayTesting")
  public Map<String, Object> dayTesting() {
    System.out.println("dayTesting");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    Calendar c1 = Calendar.getInstance();
    String strToday = sdf.format(c1.getTime());

    Map<String, Object> result = new HashMap<String, Object>();

    MainVo mainVo = new MainVo();
    mainVo.setToday(strToday);
    MainVo newVo = mainService.dayTest(mainVo);

    result.put("dayTest", newVo);
    return result;
  }

  @RequestMapping(value = "/weather")
  public Map<String, Object> weather() throws IOException, ParseException {
    System.out.println("weather");
    Map<String, Object> result = new HashMap<String, Object>();

    MainVo weather = mainService.getWeather();
    weather.setRoad(mainService.getRoadTemp().getRoad());
    JSONObject json = mainService.apiTest();
    result.put("weather", weather);
    result.put("json", json);

    return result;
  }

  @RequestMapping(value = "/notice")
  public List<NoticeDto> mainNotice(@RequestBody NoticeDto noticeDto) throws Exception {
    String nType = noticeDto.getNType();
    List<NoticeDto> list = noticeService.mainNotice(nType);
    return list;
  }

  @GetMapping("/test")
  public void test() throws Exception {
//    emailService.GoogleSenderMail();
  }

}
