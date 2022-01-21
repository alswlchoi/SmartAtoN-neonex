package com.hankook.pg.content.admin.notice.service;
 
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.common.util.Validity;
import com.hankook.pg.content.admin.notice.dao.NoticeDao;
import com.hankook.pg.content.admin.notice.dto.NoticeDto;
import com.hankook.pg.content.admin.notice.dto.SearchNoticeDto;
import com.hankook.pg.content.admin.notice.dto.UpfilesDto;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Results;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NoticeService {
	
	@Value("${file.upload.location}")
	private String location;

    @Autowired
    private NoticeDao noticeDao;
    
	/* 게시글 목록 */
	public Map<String, Object> getNoticeList(SearchNoticeDto searchNotice) throws Exception {
		if(Fn.isEmpty(searchNotice.getNType())) {
			searchNotice.setNType("n");
			
		}
		
		if(null!=searchNotice.getNTop()&&!searchNotice.getNTop().equals("N")&&!searchNotice.getNTop().equals("Y")) {
			searchNotice.setNTop(null);
		}
		
		if(null!=searchNotice.getNRegStDt()) {
			String days[] = searchNotice.getNRegStDt().split("~");	// ~ 구분자로 시작일과 마감일 분리, 형식 안 맞으면 insert 안 됨
			if(days.length==2) {			//기간이 정상적으로 들어오지 않으면 기간검색 무효화
				String nRegStDt = days[0].trim();	//시작일
				String nRegEdDt = days[1].trim();	//마감일
				//형식에 맞게 처리 해 줌

				nRegStDt = Fn.toDateFormat(nRegStDt, "yyyyMMdd")+"000000";
				nRegEdDt = Fn.toDateFormat(nRegEdDt, "yyyyMMdd")+"235959";
				
				searchNotice.setNRegStDt(nRegStDt);
				searchNotice.setNRegEdDt(nRegEdDt);
			}else {
				searchNotice.setNRegStDt(null);
				searchNotice.setNRegEdDt(null);
			}
		}
    	searchNotice.setStartRowNum((searchNotice.getPageNo()-1) * 10);
    	
    	List<NoticeDto> noticeList = noticeDao.getNoticeList(searchNotice);

        Paging paging = new Paging(searchNotice, noticeDao.findNoticeCount(searchNotice));
        
        return Results.grid(paging, noticeList);
	}
	
	/* 등록 */
	public boolean insertNotice(NoticeDto notice, List<MultipartFile> files, HttpServletRequest request) throws Exception {
    	NoticeDto dbNotice = noticeDao.getMaxNoticeOrder();	//db 데이터 가져와서 가공

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();
		
    	/* 현재 시간 설정 */
    	Date date_now = new Date(System.currentTimeMillis());
    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
    	notice.setNOrder(dbNotice.getNOrder()+1);	//Max nOrder값으로 변경
    	notice.setNRegDt(currentTime);
    	notice.setNRegUser(memberDto.getMemId());
    	//공지사항일 경우 공지글의 가장 큰 nTopOrder값을 가져온다
    	if(Validity.isNull(notice.getNTop())) {
    		notice.setNTop("Y");
    	}
    	
    	//content 특수문자 처리
    	notice.setNContent(Fn.toStringHtml(notice.getNContent()));
    	Integer cnt = noticeDao.insertNotice(notice);
    	if(cnt > 0) {
    		String uploadFilePath = location+"/"+notice.getNType()+"/";

        	File dir = new File(uploadFilePath);
        	
    		if(!dir.exists()){	//폴더 없을 경우 생성
        		try {
        			// 생성
        			boolean result = dir.mkdir();
        			
        			if(result) {
        				System.out.println("Directory is created.");
        			}else {
        				System.out.println("Failed to create directory.");		        				
        			}
        		}catch(Exception e) {
        			System.out.println("Exception occurred.");
        			e.getStackTrace();
        		}
        	}
    		
    		for(MultipartFile multiPartFile : files) {
    			if(!Fn.isEmpty(multiPartFile.getOriginalFilename())) {
		        	String prefix = multiPartFile.getOriginalFilename().substring(multiPartFile.getOriginalFilename().lastIndexOf(".")+1, multiPartFile.getOriginalFilename().length());
		        	String filename = UUID.randomUUID().toString() + "." + prefix;
		        	String pathname = uploadFilePath + filename;
		        	File dest = new File(pathname);

		        	try {
		        		multiPartFile.transferTo(dest);
		        		
		        		UpfilesDto upfiles = new UpfilesDto();
		        		upfiles.setFGroup(notice.getNSeq());
		        		upfiles.setFName(multiPartFile.getOriginalFilename());
		        		upfiles.setFRegDt(currentTime);
		        		upfiles.setFType(notice.getNType());
		        		upfiles.setFUrl(filename);
		        		
		        		noticeDao.insertNoticeFile(upfiles);
		        		
		        	}catch (IllegalStateException | IOException e) {
		        		log.error("e", e);
		        	}
    			}
    		}
    	}
    	
		return cnt > 0;
    
		
	}
	
	/* 상세보기 */
	public NoticeDto getNoticeDetail(Integer nSeq) throws Exception {		
		NoticeDto notice = noticeDao.getNoticeDetail(nSeq);
		String nContent = notice.getNContent();
		if(null!=nContent&&nContent!="") {
			nContent = Fn.scriptFilterDec(nContent);
			notice.setNContent(nContent);
		}
		
		return notice;
	}
	
	/* 파일정보 */
	public List<UpfilesDto> getFileinfo(NoticeDto notice) throws Exception {
		List<UpfilesDto> file = noticeDao.getFileinfo(notice);
		
		return file;
	}
	
	/* 조회수 증가 */
	public void updateHits(Integer nSeq) throws Exception {
		noticeDao.updateHits(nSeq);
	}
	
	/* 게시글 수정 */
	public boolean updateNotice(NoticeDto notice, @RequestParam("nFile") List<MultipartFile> files) throws Exception {
		NoticeDto dbNotice = noticeDao.getMaxNoticeOrder();	//db 데이터 가져와서 가공
		/* 현재 시간 설정 */
    	Date date_now = new Date(System.currentTimeMillis());
    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
    	notice.setNOrder(dbNotice.getNOrder()+1);	//Max nOrder값으로 변경
    	notice.setNModDt(currentTime);
    	//공지사항일 경우 공지글의 가장 큰 nTopOrder값을 가져온다
    	if(Validity.isNull(notice.getNTop())) {
    		notice.setNTop("n");
    	}else if(notice.getNTop().equals("y")) {
    		dbNotice = noticeDao.getMaxNoticeOrder();
    		notice.setNTopOrder(dbNotice.getNTopOrder()+1);
    	}
    	
    	//content 특수문자 처리
    	notice.setNContent(Fn.toStringHtml(notice.getNContent()));
    	
    	if(Validity.isNull(notice.getNTop())) {
    		notice.setNTop("n");
    	}
    	
    	Integer cnt = noticeDao.updateNotice(notice);
    	
    	if(cnt > 0) {
    		String uploadFilePath = location+"/"+notice.getNType()+"/";
    		
    		File dir = new File(uploadFilePath);
        	
    		if(!dir.exists()){	//폴더 없을 경우 생성
        		try {
        			// 생성
        			boolean result = dir.mkdir();
        			
        			if(result) {
        				System.out.println("Directory is created.");
        			}else {
        				System.out.println("Failed to create directory.");		        				
        			}
        		}catch(Exception e) {
        			System.out.println("Exception occurred.");
        			e.getStackTrace();
        		}
        	}
    		
    		for(MultipartFile multiPartFile : files) {
    			if(!Fn.isEmpty(multiPartFile.getOriginalFilename())) {
		        	String prefix = multiPartFile.getOriginalFilename().substring(multiPartFile.getOriginalFilename().lastIndexOf(".")+1, multiPartFile.getOriginalFilename().length());
		        	String filename = UUID.randomUUID().toString() + "." + prefix;
		        	String pathname = uploadFilePath + filename;    	
		        	File dest = new File(pathname);
		        	try {
		        		multiPartFile.transferTo(dest);
		        		
		        		UpfilesDto upfiles = new UpfilesDto();
		        		upfiles.setFGroup(notice.getNSeq());
		        		upfiles.setFName(multiPartFile.getOriginalFilename());
		        		upfiles.setFRegDt(currentTime);
		        		upfiles.setFType(notice.getNType());
		        		upfiles.setFUrl(filename);
		        		
		        		noticeDao.insertNoticeFile(upfiles);
		        		
		        	}catch (IllegalStateException | IOException e) {
		        		log.error("e", e);
		        	}
    			}
    		}
    	}

		return cnt > 0;
	}
	
	/* 게시글 삭제 */
	public boolean deleteNotice(Integer nSeq) throws Exception {
		NoticeDto notice = noticeDao.getNoticeDetail(nSeq);
		List<UpfilesDto> files = noticeDao.getFileinfo(notice);
		
		for(UpfilesDto file : files) {
			Integer fSeq = file.getFSeq();
			deleteFile(fSeq);
		}
		
    	int cnt = noticeDao.deleteNotice(nSeq); 
    	return cnt > 0;
	}
	
	/* 게시글 삭제 */
	public boolean deleteFile(Integer fSeq) throws Exception {
		UpfilesDto upfile = noticeDao.getFileinfoOnly(fSeq);
		String pathname = "";
		
		//업로드 경로 설정
		String uploadFilePath = location+"/";

		pathname=uploadFilePath + upfile.getFType()+"/"+upfile.getFUrl();
		
		File deleteFile = new File(pathname);
		deleteFile.delete();
    	
		int cnt = noticeDao.deleteFile(fSeq); 
    	return cnt > 0;
	}
	
	public void fileDownload(Integer fSeq, HttpServletRequest request, HttpServletResponse response) throws Exception {
		log.info("파일 다운로드 프로세스");
		
		UpfilesDto upfile = noticeDao.getFileinfoOnly(fSeq);
		String savePath = location+"/"+upfile.getFType(); 
	    // 실제 내보낼 파일명
		String filename = upfile.getFUrl();
	    // 서버에 실제 저장된 파일명
		String orgfilename = upfile.getFName(); 

	    BufferedInputStream in = null;
	    BufferedOutputStream os = null;
	    
	    File file = new File(savePath, filename);
	    String client = "";
	    
        int leng = 0;

        byte b[] = new byte[(int)file.length()];
	 
	 
	    try{
	        if(file.isFile()) {
	         
		        client = request.getHeader("User-Agent");
		 
		        // 파일 다운로드 헤더 지정
		        response.reset() ;
		        response.setContentType("application/octet-stream; charset=utf-8");
		        response.setHeader("Content-Description", "JSP Generated Data");
	
		        // IE
	            if(client.indexOf("MSIE") != -1){
	                response.setHeader ("Content-Disposition", "attachment; filename="+new String(orgfilename.getBytes("KSC5601"),"ISO8859_1"));
	 
	            }else{
	                // 한글 파일명 처리
	                orgfilename = new String(orgfilename.getBytes("utf-8"),"iso-8859-1");
	 
	                response.setHeader("Content-Disposition", "attachment; filename=\"" + orgfilename + "\"");
	                response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
	            } 
	             
	            response.setHeader ("Content-Length", ""+file.length() );
		 
	            try {
		            os = new BufferedOutputStream(response.getOutputStream());
		            in = new BufferedInputStream(new FileInputStream(file));
	
		             
		            while( (leng = in.read(b)) > 0 ){
		                os.write(b,0,leng);
		            }
	
			        in.close();
			        os.close();
	            }catch (Exception e) {
					e.printStackTrace();
					System.out.println("파일 생성 에러가 발생");
				}finally {
					if(os != null) {
						os.close();
					}
				}
	        }else {
	        	System.out.println("파일이 잘못됨");
	        }
	 
	    }catch(Exception e){
	      e.printStackTrace();
	    }
	}

	public List<NoticeDto> mainNotice(String nType) throws Exception {
		return noticeDao.mainNotice(nType);
	}
}