package com.hankook.pg.content.user.notice.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.admin.notice.dto.NoticeDto;
import com.hankook.pg.content.admin.notice.dto.SearchNoticeDto;
import com.hankook.pg.content.admin.notice.dto.UpfilesDto;
import com.hankook.pg.content.admin.notice.service.NoticeService;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.ResultCode;
import com.hankook.pg.share.Search;

@RestController
@RequestMapping("/user/notice/{nType}")
public class UserNoticeController {

    @Autowired
    NoticeService noticeService;

    @GetMapping("")
    public ModelAndView getNotices(@PathVariable String nType, HttpServletRequest req , HttpServletResponse res , ModelAndView mav ,SearchNoticeDto searchNotice,HttpSession session) throws Exception {
        searchNotice.setPageNo(1);
        searchNotice.setPageSize(10);
        searchNotice.setNType(nType);
        searchNotice.setNTop("Y");	//사용자는 노출타입만 보여줌
        
        Integer nSeq = Fn.toInt(req, "nSeq");
    	//게시글 조회
        Map<String, Object> noticeList = noticeService.getNoticeList(searchNotice);

        //페이징 처리
        Search search = new Search();
        search.setPageNo(1);
        search.setPageSize(10);
        Paging paging = new Paging(search, (Integer)noticeList.get("records"));

        //변수 설정
        mav.addObject("nType", nType);
        mav.addObject("nSeq", nSeq);
        mav.addObject("paging", paging);
        mav.addObject("noticeList",noticeList);
        mav.addObject("totalCnt", noticeList.get("records").toString());

        mav.setViewName("/user/notice/notice");

        return mav;
    }

    @GetMapping("/search-notice")
    public Map<String, Object> getSearch(@PathVariable String nType, SearchNoticeDto searchNotice) throws Exception {
    	searchNotice.setNTop("Y");

    	Map<String, Object> noticeList = noticeService.getNoticeList(searchNotice);
        //페이징 처리
        Search search = new Search();
        search.setPageNo(searchNotice.getPageNo());
        search.setPageSize(searchNotice.getPageSize());
        Paging paging = new Paging(search, (Integer)noticeList.get("records"));

        noticeList.put("nType", nType);
        noticeList.put("totalCnt", noticeList.get("records").toString());
        noticeList.put("paging",paging);

        return noticeList;
    }

    @ResponseBody
	@RequestMapping(value = "/insert-notice", method = RequestMethod.POST)
    public ResultCode insertNotice (NoticeDto notice, @RequestParam("nFile") List<MultipartFile> files, HttpServletRequest request) throws Exception {

    	boolean result = false;

		int code = result ? 200 : 400;
		String message = result ? "등록에 성공하였습니다." : "등록에 실패하였습니다.";

		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    }

    @GetMapping("/detail/{nSeq}")
    public ModelAndView getNoticeDetail(@PathVariable String nSeq, HttpServletRequest request) throws Exception {
    	ModelAndView mav = new ModelAndView();
    	
    	Integer Numberseq = Fn.toInt(nSeq,0);
    	if(Numberseq == 0) {	//nSeq 잘못 들어온 경우
    		mav.setViewName("redirect:/");
    	}else {
	    	mav.setViewName("/user/notice/detail");
	    	
	        NoticeDto notice = noticeService.getNoticeDetail(Numberseq);
	
	
			List<UpfilesDto> file = noticeService.getFileinfo(notice);	//게시글에 해당되는 파일정보 가져옴
	
	        mav.addObject("nType", notice.getNType());
	        mav.addObject("notice", notice);
	        mav.addObject("file", file);
    	}
    	
        return mav;
    }

    @RequestMapping("/download/{fSeq}")
    public ResultCode doDownloadFile(@PathVariable int fSeq, HttpServletRequest request, HttpServletResponse response) {
    	boolean result = false;
    	try {
     		//사용자 업데이트
    		noticeService.fileDownload(fSeq, request, response);
 		} catch (Exception e) {
 			return ResultCode.builder()
 	                .code(400)
 	                .message("다운로드에 실패했습니다.")
 	                .build();
 		}

     	int code = result ? 200 : 400;
		String message = result ? "" : "다운로드에 실패하였습니다.";

		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    }
}