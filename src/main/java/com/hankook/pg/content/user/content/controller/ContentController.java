package com.hankook.pg.content.user.content.controller;

import com.hankook.pg.content.admin.notice.dto.NoticeDto;
import com.hankook.pg.content.admin.notice.dto.SearchNoticeDto;
import com.hankook.pg.content.admin.notice.service.NoticeService;
import com.hankook.pg.content.admin.shop.service.ShopService;
import com.hankook.pg.content.admin.shop.vo.ShopVo;
import com.hankook.pg.content.admin.trReserve.dto.TrackDto;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Search;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@RestController
@RequestMapping("/before")
public class ContentController {

  @Autowired
  NoticeService noticeService;
  @Autowired
  ShopService shopService;

  @RequestMapping(value = "", method = RequestMethod.GET)
  public ModelAndView content() throws Exception {
    log.info("CONTENT");
    ModelAndView mv = new ModelAndView("/user/intro/technoring");

    return mv;
  }

  @RequestMapping(value = "/technoring", method = RequestMethod.GET)
  public ModelAndView technoring() throws Exception {
    log.info("TECHNORING");
    ModelAndView mv = new ModelAndView("/user/intro/technoring");

    return mv;
  }

  @RequestMapping(value = "/notice/{nType}", method = RequestMethod.GET)
  public ModelAndView getNotices(@PathVariable String nType, HttpServletRequest req , HttpServletResponse res , ModelAndView mav ,
      SearchNoticeDto searchNotice) throws Exception {
	searchNotice.setNTop("Y");  
    searchNotice.setPageNo(1);
    searchNotice.setPageSize(10);
    searchNotice.setNType(nType);
    //게시글 조회
    Map<String, Object> noticeList = noticeService.getNoticeList(searchNotice);

    //페이징 처리
    Search search = new Search();
    search.setPageNo(1);
    search.setPageSize(10);
    Paging paging = new Paging(search, (Integer)noticeList.get("records"));

    //변수 설정
    mav.addObject("paging", paging);
    mav.addObject("noticeList",noticeList);
    mav.addObject("totalCnt", noticeList.get("records").toString());

    mav.setViewName("/user/notice/notice");

    return mav;
  }

  @RequestMapping(value = "/track", method = RequestMethod.GET)
  public ModelAndView track() throws Exception {
    log.info("TRACK");
    ModelAndView mv = new ModelAndView("/user/intro/track");

    return mv;
  }

  @PostMapping("/trackList")
  public List<TrackDto> getTrackList() throws Exception {
    List<TrackDto> list = shopService.selectTrack();
    return list;
  }

  @RequestMapping(value = "/shop", method = RequestMethod.GET)
  public ModelAndView shop() throws Exception {
    log.info("SHOP");
    ModelAndView mv = new ModelAndView("/user/intro/shop");

    return mv;
  }

  @PostMapping(value = "/shopList")
  public List<ShopVo> selectShop(@RequestBody ShopVo shopVo) throws Exception {
    System.out.println("SHOP list");
    List<ShopVo> list = shopService.selectShop(shopVo);
    return list;
  }

  @PostMapping(value = "/notice")
  public List<NoticeDto> mainNotice(@RequestBody NoticeDto noticeDto) throws Exception {
    System.out.println(noticeDto);
    String nType = noticeDto.getNType();
    noticeDto.setType("U");
    List<NoticeDto> list = noticeService.mainNotice(nType);
    return list;
  }
}
