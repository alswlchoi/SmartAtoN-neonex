package com.hankook.pg.content.admin.driver.service;
 
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
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
import org.springframework.web.multipart.MultipartFile;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.admin.driver.dao.DriverDao;
import com.hankook.pg.content.admin.driver.dto.DriverDto;
import com.hankook.pg.content.admin.driver.dto.DriverLevelDto;
import com.hankook.pg.content.admin.driver.dto.SearchDriverDto;
import com.hankook.pg.content.admin.driver.dto.UpfilesDto;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.share.AESCrypt;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Results;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DriverService {
	
	@Value("${file.upload.location}")
	private String location;
    
    @Autowired
    private DriverDao driverDao;

	/* 목록 */
	public Map<String, Object> getDriverList(SearchDriverDto searchDriver) throws Exception {
		//로그인 정보
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();
		
		if(memberDto.getMemUserType().equals("user")) {	//사용자라면 해당업체 운전자만 보여줌
			memberDto.setCompCode(memberDto.getCompCode());
		}
		
		if(null!=searchDriver.getStDt()) {		//등록일 조건 검색이 있을 경우
			String days[] = searchDriver.getStDt().split("~");	// ~ 구분자로 시작일과 마감일 분리, 형식 안 맞으면 insert 안 됨
			if(days.length==2) {
				String stDt = days[0].trim();	//시작일
				String edDt = days[1].trim();	//마감일
				//형식에 맞게 처리 해 줌

				stDt = Fn.toDateFormat(stDt, "yyyyMMdd")+"000000";
				edDt = Fn.toDateFormat(edDt, "yyyyMMdd")+"235959";
				
				searchDriver.setStDt(stDt);
				searchDriver.setEdDt(edDt);
			}
		}
		
		String keyword = searchDriver.getKeyword();
		String schDName = searchDriver.getDName();
		
		searchDriver.setKeyword(keyword);		//회사명, 사업자번호 Like 검색
		searchDriver.setEnckeyword(AESCrypt.encrypt(keyword));	//운전자명 암호화문자열 검색
		searchDriver.setDName(AESCrypt.encrypt(schDName));
		
		searchDriver.setStartRowNum((searchDriver.getPageNo()-1)*10);
		List<DriverDto> driverList = driverDao.getDriverList(searchDriver);
    	
		for(DriverDto driver : driverList) {
			String dName = AESCrypt.decrypt(driver.getDName());
    		String dBirth = AESCrypt.decrypt(driver.getDBirth());
    		String dEmail = AESCrypt.decrypt(driver.getDEmail());
    		String dPhone = AESCrypt.decrypt(driver.getDPhone());
    		String dPhone2 = AESCrypt.decrypt(driver.getDPhone2());
    		
    		driver.setDName(dName);
    		driver.setDBirth(dBirth);
    		driver.setDEmail(dEmail);
    		driver.setDPhone(dPhone);
    		driver.setDPhone2(dPhone2);    		
		}
        Paging paging = new Paging(searchDriver, driverDao.getDriverCount(searchDriver));
        
        return Results.grid(paging, driverList);
    }

	//검색용
	public Integer getDriverCount(SearchDriverDto searchDriver) throws Exception {
		return driverDao.getDriverCount(searchDriver);
	}
    // 데이터 유무
    public Integer getDriverCodeCount(Integer dSeq) throws Exception {
    	return driverDao.getDriverCodeCount(dSeq);
    }
    
	/* 등록 */
	public Integer insertDriver(DriverDto driver, List<MultipartFile> multipartFiles, HttpServletRequest request) throws Exception {
		//로그인 정보
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();
		
		String uploadFilePath = location+"/";
		
		/* 현재 시간 설정 */
    	Date date_now = new Date(System.currentTimeMillis());
    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
    	driver.setCompCode(memberDto.getCompCode());
    	driver.setDRegUser(memberDto.getMemId());
    	driver.setDRegDt(currentTime);
    	
    	if(driver.getDBirth().length()==10) {
    		driver.setDBirth(Fn.toDateFormat(driver.getDBirth(), "yyyyMMdd"));
    	}
    	driver.setDApproval("N");
    	driver.setDEdu("N");

		boolean fileApproval = false;
		Integer fileCnt = 0;
		int cnt = 0;
    	for(MultipartFile multipartFile : multipartFiles) {
    		long maxFileSize = 5*1024*1024;
    		fileApproval = fileWhiteListCheck(multipartFile, maxFileSize);
    		
    		if(!fileApproval) {
    			cnt = -3;
    			break;
    		}
    		fileCnt++;
    	}
    	
    	if(fileCnt >=3 && cnt==0) {
    		String dName = AESCrypt.encrypt(driver.getDName());
    		String dBirth = AESCrypt.encrypt(driver.getDBirth());
    		String dEmail = AESCrypt.encrypt(driver.getDEmail());
    		String dPhone = AESCrypt.encrypt(driver.getDPhone());
    		String dPhone2 = AESCrypt.encrypt(driver.getDPhone2());
    		
    		driver.setDName(dName);
    		driver.setDBirth(dBirth);
    		driver.setDEmail(dEmail);
    		driver.setDPhone(dPhone);
    		driver.setDPhone2(dPhone2);    		
    		
			cnt = driverDao.insertDriver(driver);
	
			if(cnt>0) {		//운전자 정보 등록에 성공했으면 파일 처리			
				//운전자 등록시 면허증 업로드
				int di = 0;
				for(MultipartFile multipartFile : multipartFiles) {
					if(!Fn.isEmpty(multipartFile.getOriginalFilename())) {
			        	String prefix = multipartFile.getOriginalFilename().substring(multipartFile.getOriginalFilename().lastIndexOf(".")+1, multipartFile.getOriginalFilename().length());
			        	String filename = UUID.randomUUID().toString() + "." + prefix;
			        	String pathname = "";
			        	String folder = "";
			        	
			        	if(di>=0 && di<=2) {
			        		folder="d";
		        		}else if(di==3){
			        		folder="a";
		        		}else if(di==4){
			        		folder="e";
		        		}
			        	
		        		pathname=uploadFilePath + folder+"/"+filename;
	
		            	File dir = new File(uploadFilePath+"editor/"+folder);
		            		            	
		            	if(!dir.exists()){
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
		            	
			        	File dest = new File(pathname);
			        	try {
			        		multipartFile.transferTo(dest);
			        		
			        		UpfilesDto upfiles = new UpfilesDto();
			        		upfiles.setFGroup(driver.getDSeq());
			        		upfiles.setFName(multipartFile.getOriginalFilename());
			        		upfiles.setFRegDt(currentTime);
			        		if(di>=0 && di<=2) {
			        			upfiles.setFType("d");
			        		}else if(di==3) {
			        			upfiles.setFType("a");
			        		}else if(di==4) {
			        			upfiles.setFType("e");
			        		}
			        		upfiles.setFUrl(filename);
			        		
			        		driverDao.insertDriverFile(upfiles);
			        	}catch (IllegalStateException | IOException e) {
			        		log.error("e", e);
			        	}
					}
					di++;
				}
			}
		}
		return cnt;
	}
	
	//운전자 등급
	public List<DriverLevelDto> driverLevel(DriverDto driver) throws Exception{
		return driverDao.driverLevel(driver);
	}
	
	/* 상세보기 */
	public DriverDto getDriverDetail(Integer dSeq) throws Exception {
		DriverDto driver = driverDao.getDriverDetail(dSeq);
		
		String dName = AESCrypt.decrypt(driver.getDName());
		String dBirth = AESCrypt.decrypt(driver.getDBirth());
		String dEmail = AESCrypt.decrypt(driver.getDEmail());
		String dPhone = AESCrypt.decrypt(driver.getDPhone());
		String dPhone2 = AESCrypt.decrypt(driver.getDPhone2());
		
		driver.setDName(dName);
		driver.setDBirth(dBirth);
		driver.setDEmail(dEmail);
		driver.setDPhone(dPhone);
		driver.setDPhone2(dPhone2);    	
		
		String dMemo = driver.getDMemo();
		dMemo = Fn.scriptFilterDec(dMemo);
		driver.setDMemo(dMemo);
		UpfilesDto upfile = new UpfilesDto();
		new ArrayList<UpfilesDto>();
		upfile.setFGroup(dSeq);
		List<UpfilesDto> upfiles = driverDao.getUpfiles(upfile);
		driver.setUpfiles(upfiles);
		return driver;
	}
	
	/* 수정 */
	public Integer updateDriver(DriverDto driver, List<MultipartFile> multipartFiles,HttpServletRequest request) throws Exception {
		//로그인 정보
		int cnt = 0;
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if(authentication.getPrincipal() instanceof String) {
			cnt = -1;
		}else {
			MemberDto memberDto = (MemberDto)authentication.getPrincipal();
	
			/* 현재 시간 설정 */
	    	Date date_now = new Date(System.currentTimeMillis());
	    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
			
	    	String dName = Fn.toString(request, "dName");
	    	String dBirth = Fn.toString(request, "dBirth");
	    	String dEmail = Fn.toString(request, "dEmail");
	    	String dPhone = Fn.toString(request, "dPhone");
	    	String dPhone2 = Fn.toString(request, "dPhone2");
	    	String dLicenseType = Fn.toString(request, "dLicenseType");
	    	Integer fileDelete2seq = Fn.toInt(request, "fileDelete2");
	    	Integer fileDelete3seq = Fn.toInt(request, "fileDelete3");
	    	Integer fSeq1 = Fn.toInt(request, "fSeq1");
	    	Integer fSeq2 = Fn.toInt(request, "fSeq2");
	    	Integer fSeq3 = Fn.toInt(request, "fSeq3");
	    	Integer fSeqA = Fn.toInt(request, "fSeqA");
	    	Integer fSeqE = Fn.toInt(request, "fSeqE");
	    	String dHistory = Fn.toString(request, "dHistory");
	    	String dBloodType = Fn.toString(request, "dBloodType");
	    	String dBloodSpecial = Fn.toString(request, "dBloodSpecial");

			if(memberDto.getMemUserType()=="user"&&!memberDto.getCompCode().equals(driver.getCompCode())) {
				cnt = -2;
			}else {
		    	boolean fileApproval = false;
				Integer fileCnt = 0;
				
		    	for(MultipartFile multipartFile : multipartFiles) {
		    		long maxFileSize = 5*1024*1024;
		    		fileApproval = fileWhiteListCheck(multipartFile, maxFileSize);
		    		
		    		if(!fileApproval) {
		    			cnt = -3;
		    			break;
		    		}
		    		fileCnt++;
		    	}
		    	
		    	if(fileCnt >=3 && cnt==0) {
			    	driver = driverDao.getDriverDetail(driver.getDSeq());

			    	dName = AESCrypt.encrypt(dName);
		    		dBirth = AESCrypt.encrypt(dBirth);
		    		dEmail = AESCrypt.encrypt(dEmail);
		    		dPhone = AESCrypt.encrypt(dPhone);
		    		dPhone2 = AESCrypt.encrypt(dPhone2);
		    		
		    		driver.setDName(dName);
		    		driver.setDBirth(dBirth);
		    		driver.setDEmail(dEmail);
		    		driver.setDPhone(dPhone);
		    		driver.setDPhone2(dPhone2);
			    	driver.setDLicenseType(dLicenseType);
			    	driver.setDHistory(dHistory);
			    	driver.setDBloodType(dBloodType);
			    	driver.setDBloodSpecial(dBloodSpecial);
			    	driver.setDModDt(currentTime);
			    	driver.setDName(dName);
					
			    	cnt = driverDao.updateDriver(driver);
		    	}
			}
			
			if(cnt>0) {
				//업로드 경로 설정
				String uploadFilePath = location+"/";
	    		
	    		//새로운 파일 업로드 요청이 들어온 경우
				int di = 0;
	
	    		if(fileDelete2seq>0) {
	    			UpfilesDto dLicense2File = driverDao.getFileDriverOnly(fileDelete2seq);
	    			File deleteFile = new File(uploadFilePath+"/d/"+dLicense2File.getFUrl());
    				deleteFile.delete();
    				
    				driverDao.deleteFile1ea(fileDelete2seq);
	    		}
	    		
	    		if(fileDelete3seq>0) {
	    			UpfilesDto dLicense3File = driverDao.getFileDriverOnly(fileDelete3seq);
	    			File deleteFile = new File(uploadFilePath+"/d/"+dLicense3File.getFUrl());
    				deleteFile.delete();
    				
    				driverDao.deleteFile1ea(fileDelete3seq);
	    		}
	    		
				for(MultipartFile multipartFile : multipartFiles) {
					if(!Fn.isEmpty(multipartFile.getOriginalFilename())) {
						
			        	String prefix = multipartFile.getOriginalFilename().substring(multipartFile.getOriginalFilename().lastIndexOf(".")+1, multipartFile.getOriginalFilename().length());
			        	String filename = UUID.randomUUID().toString() + "." + prefix;
			        	String folder = "";
			        	if(di>=0 && di<=2) {
			        		folder= "d";
		        		}else if(di==3){
		        			folder= "a";
		        		}else {
		        			folder= "e";
		        		}
	
			        	File dir = new File(uploadFilePath+"/"+folder);
			        	
			        	if(!dir.exists()){
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
			        	String pathname = uploadFilePath + "/"+folder+"/" + filename; 
			        	
			        	File dest = new File(pathname);
			        	try {
			        		//파일을 업로드 함
			        		multipartFile.transferTo(dest);
			        		
			        		UpfilesDto upfiles = new UpfilesDto();
							System.out.println("di : " + di+", fseq1 : " + fSeq1+", fseq2 : " + fSeq2+", fseq3 : " + fSeq3);

			        		upfiles.setFGroup(driver.getDSeq());
			        		upfiles.setFName(multipartFile.getOriginalFilename());
			        		upfiles.setFRegDt(currentTime);
			        		if(di>=0 && di<=2) {
			        			upfiles.setFType("d");
			        		}else if(di==3){
			        			upfiles.setFType("a");
			        		}else {
			        			upfiles.setFType("e");
			        		}
			        		upfiles.setFUrl(filename);

		        			if(di==0) {	//1번파일 수정시
		        				if(!"".equals(filename)&&fSeq1>0) {
			        				UpfilesDto destDelfile = driverDao.getFileDriverOnly(fSeq1);
			        				File deleteFile = new File(uploadFilePath+"/"+folder+"/"+destDelfile.getFUrl());
			        				deleteFile.delete();
			        				upfiles.setFSeq(fSeq1);
					        		cnt = driverDao.updateFile1ea(upfiles);
					        		System.out.println("fSeq1 : " + fSeq1);
		        				}else {
					        		System.out.println("0 : " + fSeq1);
					        		cnt = driverDao.insertDriverFile(upfiles);
			        			}
		        			}
		        			if(di==1) {	//2번파일 수정시
		        				if(!"".equals(filename)&&fSeq2>0) {
			        				UpfilesDto destDelfile = driverDao.getFileDriverOnly(fSeq2);
			        				File deleteFile = new File(uploadFilePath+"/"+folder+"/"+destDelfile.getFUrl());
			        				deleteFile.delete();
			        				upfiles.setFSeq(fSeq2);
					        		cnt = driverDao.updateFile1ea(upfiles);
					        		System.out.println("fSeq2 : " + fSeq2);
		        				}else {
					        		System.out.println("1 : " + fSeq1);
					        		cnt = driverDao.insertDriverFile(upfiles);
			        			}
		        			}
		        			if(di==2) {	//3번파일 수정시
		        				if(!"".equals(filename)&&fSeq3>0) {
			        				UpfilesDto destDelfile = driverDao.getFileDriverOnly(fSeq3);
			        				File deleteFile = new File(uploadFilePath+"/"+folder+"/"+destDelfile.getFUrl());
			        				deleteFile.delete();
			        				upfiles.setFSeq(fSeq3);
					        		cnt = driverDao.updateFile1ea(upfiles);
					        		System.out.println("fSeq3 : " + fSeq3);
		        				}else {
					        		System.out.println("2 : " + fSeq1);
					        		cnt = driverDao.insertDriverFile(upfiles);
			        			}
		        			}
		        			if(di==3) {	//동의서파일 수정시
		        				if(!"".equals(filename)&&fSeqA>0) {
			        				UpfilesDto destDelfile = driverDao.getFileDriverOnly(fSeqA);
			        				File deleteFile = new File(uploadFilePath+"/"+folder+"/"+destDelfile.getFUrl());
			        				deleteFile.delete();
			        				upfiles.setFSeq(fSeqA);
					        		cnt = driverDao.updateFile1ea(upfiles);
		        				}else {
					        		cnt = driverDao.insertDriverFile(upfiles);
			        			}
		        			}
		        			if(di==4) {	//재직증명서 수정시
		        				if(!"".equals(filename)&&fSeqE>0) {
			        				UpfilesDto destDelfile = driverDao.getFileDriverOnly(fSeqE);
			        				File deleteFile = new File(uploadFilePath+"/"+folder+"/"+destDelfile.getFUrl());
			        				deleteFile.delete();
			        				upfiles.setFSeq(fSeqE);
					        		cnt = driverDao.updateFile1ea(upfiles);
		        				}else {
					        		cnt = driverDao.insertDriverFile(upfiles);
			        			}
		        			}
			        		
			        	}catch (IllegalStateException | IOException e) {
			        		log.error("e", e);
			        	}
					}
	
					di++;
				}
			}
		}
		
		return cnt;
	}
	
	/* 상태 업데이트 */
	public boolean updateApproval(DriverDto driver) throws Exception {  
		//로그인 정보
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();
		
		int cnt = 0;
		if(memberDto.getMemUserType()=="user") {
			cnt = -1;
		}else {
			/* 현재 시간 설정 */
	    	Date date_now = new Date(System.currentTimeMillis());
	    	String dMemo = driver.getDMemo();
	    	String dEduEndDt = driver.getDEduEndDt();
	
	    	dEduEndDt = Fn.toDateFormat(dEduEndDt, "yyyyMMdd")+"235959";
			driver.setDEduEndDt(dEduEndDt);
	    	driver.setDMemo(Fn.toStringHtml(dMemo));
	    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
	    	driver.setDModDt(currentTime);
	    	driver.setDModUser(memberDto.getMemId());
			cnt = driverDao.updateApproval(driver);
		}
		return cnt > 0;
	}
	
	/* 상태 업데이트 */
	public boolean updateReturn(DriverDto driver) throws Exception {  
		//로그인 정보
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();
		
		int cnt = 0;
		if(memberDto.getMemUserType()=="user") {
			cnt = -1;
		}else {
			/* 현재 시간 설정 */
			Date date_now = new Date(System.currentTimeMillis());
			String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
			
			String dMemo = driver.getDMemo();			
			driver.setDMemo(Fn.toStringHtml(dMemo));
			driver.setDModDt(currentTime);
			driver.setDModUser(memberDto.getMemId());
			cnt = driverDao.updateReturn(driver);
		}
		return cnt > 0;
	}
	
	/* 삭제 */ 
	public boolean deleteDriver(Integer dSeq) throws Exception {
		//로그인 정보
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();

		String memUserType = memberDto.getMemUserType();
		String compCode = memberDto.getCompCode();

		DriverDto driver = driverDao.getDriverDetail(dSeq);
		
		int cnt = 0;
		
		if(!driver.getDApproval().equals("N")) {
			cnt = -1;
		}else {	
			if(memUserType.equals("user") && !compCode.equals(memberDto.getCompCode())) {	//사용자일 경우 권한 체크 맞지 않을 경우			
				cnt = -1;
			}else {
				//업로드 경로 설정
				String uploadFilePath = location+"/";
				
				UpfilesDto destDelfile = new UpfilesDto();
				destDelfile.setFGroup(dSeq);
				
				List<UpfilesDto> upfiles = driverDao.getUpfiles(destDelfile);
				int di = 0;
				for(UpfilesDto upfile : upfiles) {
					String pathname = "";
		        	if(di==0) {
		        		pathname=uploadFilePath + "d/"+upfile.getFUrl();
	        		}else {
		        		pathname=uploadFilePath + "a/"+upfile.getFUrl();
	        		}
					File deleteFile = new File(pathname);
					deleteFile.delete();
					di++;
				}
				
				cnt = driverDao.deleteUpfiles(destDelfile);	//DB record 삭제
		
				cnt = driverDao.deleteDriver(dSeq);
			}
		}
		return cnt > 0;
	}

	//211028 기존 다운로드 소스 (No converter for 에러)
	public boolean fileDownload(Integer fSeq, HttpServletRequest request, HttpServletResponse response) throws Exception {		
		UpfilesDto upfile = driverDao.getFileDriverOnly(fSeq);
		String savePath = location+"/"+upfile.getFType();
		
	    // 실제 내보낼 파일명
		String filename = upfile.getFUrl();
	    // 서버에 실제 저장된 파일명
		String orgfilename = upfile.getFName(); 
	 
	    InputStream in = null;
	    OutputStream os = null;
	    
	    File file = null;
	    boolean skip = false;
	    String client = "";
	 
	    try{
	        // 파일을 읽어 스트림에 담기
	        try{
	            file = new File(savePath, filename);

	            if(file.exists()) {
	            	in = new FileInputStream(file);
	            }else {
		            skip = true;
	            }
	            in = new FileInputStream(file);
	        }catch(FileNotFoundException fe){
	            skip = true;
	        }
	         
	        client = request.getHeader("User-Agent");
	 
	        // 파일 다운로드 헤더 지정
	        response.reset() ;
	        response.setContentType("application/octet-stream; charset=utf-8");
	        response.setHeader("Content-Description", "JSP Generated Data");
	 
	        if(!skip){
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
	 
	 
	       
	            os = response.getOutputStream();
	            
	            byte b[] = new byte[(int)file.length()];
	            int leng = 0;
	             
	            while( (leng = in.read(b)) > 0 ){
	                os.write(b,0,leng);
	            }
	        }
	        
	        if(null!=in) in.close();
	        if(null!=os) os.close();
	 
	    }catch(Exception e){
	      e.printStackTrace();
	    }

	    return !skip;
	}
	
	public boolean fileWhiteListCheck(MultipartFile file, long maxFileSize) throws Exception {
		boolean result = true;
		if (file != null) {
			long fileSize = file.getSize();
			
			if (fileSize > maxFileSize) {
				result = false;
			}else {			
				String fileName = file.getOriginalFilename().toLowerCase();
				
				if (fileName != null && !fileName.equals("")) {
					if (fileName.endsWith(".jpg") || fileName.endsWith(".png") ||
						fileName.endsWith(".jpeg") || fileName.endsWith(".bmp") || 
						fileName.endsWith(".tiff") || fileName.endsWith(".tif")||
						fileName.endsWith(".pdf")) {
	                	result = true;
	                } else {
	                	result = false;
	                }
				}
			}
		}
		return result;
	}

	//211028 새로 작성 다운로드 소스
	public void fileDownload2(Integer fSeq, HttpServletRequest request, HttpServletResponse response) throws Exception {		
		UpfilesDto upfile = driverDao.getFileDriverOnly(fSeq);
		String savePath = location+"/"+upfile.getFType(); 
	    // 실제 내보낼 파일명
		String filename = upfile.getFUrl();
	    // 서버에 실제 저장된 파일명
		String orgfilename = upfile.getFName(); 
	 
	    //InputStream in = null;
	    //OutputStream os = null;
	    BufferedInputStream in = null;
	    BufferedOutputStream os = null;
	    
	    File file = new File(savePath, filename);
	    String client = "";

        int leng = 0;
	    

        byte b[] = new byte[(int)file.length()];
	 
	    try{
	        // 파일을 읽어 스트림에 담기
	        
	        if(file.isFile()) {
		        client = request.getHeader("User-Agent");
		        
		        // 파일 다운로드 헤더 지정
		        response.reset() ;
		        response.setContentType("application/octet-stream; charset=utf-8");
		        response.setHeader("Content-Description", "JSP Generated Data");
		        
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

		            //os = response.getOutputStream();
		            os = new BufferedOutputStream(response.getOutputStream());
		            //in = new FileInputStream(file);
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
}