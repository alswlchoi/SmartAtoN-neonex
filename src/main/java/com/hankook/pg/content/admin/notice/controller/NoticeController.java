package com.hankook.pg.content.admin.notice.controller;
 
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
@RequestMapping("/admin/notice")
public class NoticeController {
	 
    @Autowired
    NoticeService noticeService;
    
    /******************************************
     * 
     * 게시글 목록 조회(초기화면 조회)
     *
     * @Date   : 2021. 7. 20.
     * @Method : getNotices
     * @return : ModelAndView
     ******************************************/
    @GetMapping("")
    public ModelAndView getNotices(ModelAndView mav ,SearchNoticeDto searchNotice, HttpServletRequest request) throws Exception {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
	    	int pageNo = Fn.toInt(request, "pageNo", 1);
	        String nType = Fn.toString(request, "nType", "n");    	
	        String schTop = Fn.toString(request, "schTop");    	
	        
	        searchNotice.setPageNo(pageNo);
	        searchNotice.setPageSize(10);
	        searchNotice.setNType(nType);
	        searchNotice.setNTop(schTop);
	
	    	//업체 조회
	        Map<String, Object> noticeList = noticeService.getNoticeList(searchNotice);
	        
	        //페이징 처리
	        Search search = new Search();
	        search.setPageNo(pageNo);
	        search.setPageSize(10);
	        Paging paging = new Paging(search, (Integer)noticeList.get("records"));
	
	        //변수 설정
	        mav.addObject("paging", paging);
	        mav.addObject("noticeList",noticeList);
	        mav.addObject("totalCnt", noticeList.get("records").toString());
	        mav.addObject("nType", nType);
	        mav.addObject("schTop", schTop);
	        
	        mav.setViewName("/admin/notice/notice");
		}
        return mav;
    }

    @GetMapping("/search-notice")
    public Map<String, Object> getSearch(SearchNoticeDto searchNotice, HttpServletRequest request) throws Exception {
    	//조회
    	Map<String, Object> noticeList = noticeService.getNoticeList(searchNotice);
        //페이징 처리
        Search search = new Search();
        search.setPageNo(searchNotice.getPageNo());
        search.setPageSize(searchNotice.getPageSize());
        Paging paging = new Paging(search, (Integer)noticeList.get("records"));
        
        noticeList.put("totalCnt", noticeList.get("records").toString());
        noticeList.put("paging",paging);        
        
        return noticeList;
    }

    @RequestMapping(value = "/regform", method=RequestMethod.GET)
    public ModelAndView regForm(HttpServletRequest request) throws Exception {
    	ModelAndView mav = new ModelAndView();
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
	    	String nType = Fn.toString(request, "nType");
	    	
	    	mav.setViewName("/admin/notice/regForm");
	    	
	    	mav.addObject("nType", nType);
	    	mav.addObject("nType", nType);
		}
        return mav;
    }

    @ResponseBody
	@RequestMapping(value = "/fileupload/insert-notice", method = RequestMethod.POST)
    public ResultCode insertNotice (NoticeDto notice, @RequestParam("nFile") List<MultipartFile> files, HttpServletRequest request) throws Exception {
    	
    	boolean result = false;

		try {
			// 공지사항 등록
	    	result = noticeService.insertNotice(notice, files, request);
		} catch (Exception e) {
			return ResultCode.builder()
                    .code(500)
                    .message("등록에 실패하였습니다.")
                    .build();
		}
		
		int code = result ? 200 : 400;
		String message = result ? "등록에 성공하였습니다." : "등록에 실패하였습니다.";
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    }

    @ResponseBody
	@RequestMapping(value = "/fileupload/update-notice", method = RequestMethod.POST)
    public ResultCode updateNotice (NoticeDto notice, @RequestParam("nFile") List<MultipartFile> files) throws Exception {
    	
    	boolean result = false;

		try {
			// 사용자 등록
	    	result = noticeService.updateNotice(notice, files);
		} catch (Exception e) {
			return ResultCode.builder()
                    .code(500)
                    .message("수정에 실패하였습니다.")
                    .build();
		}
		
		int code = result ? 200 : 400;
		String message = result ? "수정에 성공하였습니다." : "수정에 실패하였습니다.";
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    }

    @GetMapping(value = "/detail-notice", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> getNoticeDetail(NoticeDto notice) throws Exception {
        notice = noticeService.getNoticeDetail(notice.getNSeq());        

		List<UpfilesDto> file = noticeService.getFileinfo(notice);	//게시글에 해당되는 파일정보 가져옴
		
        Map<String, Object> result = new HashMap<String, Object>();  
        result.put("notice", notice);
        result.put("file", file);
        return result;
    	
    }

    @RequestMapping(value = "/update-form", method={RequestMethod.GET,RequestMethod.POST})
    public ModelAndView updateForm(NoticeDto notice, HttpServletRequest request) throws Exception {
    	ModelAndView mav = new ModelAndView();
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
			mav.setViewName("redirect:/adminLogin");
		}else {
	    	mav.setViewName("/admin/notice/updateForm");
	        notice = noticeService.getNoticeDetail(notice.getNSeq());        
	
			List<UpfilesDto> file = noticeService.getFileinfo(notice);	//게시글에 해당되는 파일정보 가져옴
			
	        int pageNo = Fn.toInt(request, "pageNo", 1);
	        String nType = Fn.toString(request, "nType", "n");
			
	        mav.addObject("notice", notice);
	        mav.addObject("file", file);
	        mav.addObject("nType", nType);
	        mav.addObject("pageNo", pageNo);
		}    
        return mav;
    	
    }

    @RequestMapping(value = "/delete-notice", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResultCode getNoticeDelete(NoticeDto notice) throws Exception {
    	boolean result = true;
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	
		if(authentication.getPrincipal() instanceof String) {
	     	int code = 403;
			String message = "삭제 권한이 없습니다.";
			return ResultCode.builder()
	                .code(code)
	                .message(message)
	                .build();
		}else {
     		result = noticeService.deleteNotice(notice.getNSeq());
		
	     	int code = result ? 200 : 400;
			String message = result ? "삭제에 성공하였습니다." : "삭제에 실패하였습니다.";
			
			return ResultCode.builder()
	                .code(code)
	                .message(message)
	                .build();
		}
    	
    }

    @RequestMapping(value = "/delete-file", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResultCode deleteFile(Integer fSeq) throws Exception {
    	boolean result = true;

        try {
     		//사용자 업데이트
     		result = noticeService.deleteFile(fSeq);
 		} catch (Exception e) {
 			return ResultCode.builder()
 	                .code(400)
 	                .message("삭제에 실패했습니다.")
 	                .build();	
 		}
		
     	int code = result ? 200 : 400;
		String message = result ? "삭제에 성공하였습니다." : "삭제에 실패하였습니다.";
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    	
    }

    @RequestMapping(value = "/fileupload/download/{fSeq}", produces = MediaType.APPLICATION_JSON_VALUE)
    public void doDownloadFile(@PathVariable int fSeq, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	noticeService.fileDownload(fSeq, request, response);
    }
}