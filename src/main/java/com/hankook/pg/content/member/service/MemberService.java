package com.hankook.pg.content.member.service;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.admin.driver.dao.DriverDao;
import com.hankook.pg.content.admin.driver.dto.UpfilesDto;
import com.hankook.pg.content.member.dao.MemberDAO;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.exception.valueRtnException;

import com.hankook.pg.share.AESCrypt;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
@Transactional(rollbackFor = Exception.class)
@RequiredArgsConstructor
public class MemberService {

    private final MemberDAO memberDao;
    private final PasswordEncoder passwordEncoder;
    private final DriverDao driverDao;
    @Value("${file.upload.location}")
	private String location;

    public List<MemberDto> getMmemberlist() throws Exception{
        return memberDao.getMmemberlist();
    }
    public int updateMember(MemberDto memberDto) throws Exception {
    	return memberDao.updateMember(MemberDto.builder()
    			.memId(memberDto.getMemId())
    			.memName(memberDto.getMemName())
    			.memDept(memberDto.getMemDept())
    			.memEmail(memberDto.getMemEmail())
    			.memPhone(memberDto.getMemPhone())
    			.memCompPhone(memberDto.getMemCompPhone())
    			.memModDt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")))
    			.memModUser("system")
    			.build());
    }
    @Transactional
    public int createCompany(MemberDto memberDto,MultipartFile file) throws Exception {
    	memberDto.setBlackList("N");
    	memberDto.setCompRegUser("system");
    	memberDto.setCompRegDt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
    	int cntC = memberDao.createCompany(memberDto);
    	System.out.println("회사 인서트 cnt = "+cntC);
    	int cnt = 0;
    	if(cntC > 0) {
    		int cntM = memberDao.insertMember(MemberDto.builder()
                    .memId(memberDto.getMemId())
                    .memPwd(passwordEncoder.encode(memberDto.getMemPwd()))
                    .memName(AESCrypt.encrypt(memberDto.getMemName()))
                    .memDept(memberDto.getMemDept())
                    .memEmail(AESCrypt.encrypt(memberDto.getMemEmail()))
                    .memPhone(AESCrypt.encrypt(memberDto.getMemPhone()))
                    .memCompPhone(memberDto.getMemCompPhone())
                    .memAgreement(memberDto.getMemAgreement())
                    .memPurpose(memberDto.getMemPurpose())
                    .kakaoSmsYn("Y")
                    .memUserType("user")
                    .memBirth(AESCrypt.encrypt("19990101"))
                    .authCode("A000")
                    .compCode(memberDto.getCompCode())
                    .memUseYn("Y")
                    .memApproval("N")
                    .memRegUser("system")
                    .memRegDt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")))
                    .memModDt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")))
                    .memModUser("system")
                    .build());
    		System.out.println("멤버인서트 cnt = "+cntM);
    		if(cntM>0) {
    			String uploadFilePath = location+"/";
    			/* 현재 시간 설정 */
    	    	Date date_now = new Date(System.currentTimeMillis());
    	    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
    			if(!Fn.isEmpty(file.getOriginalFilename())) {
    	        	String prefix = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".")+1, file.getOriginalFilename().length());
    	        	String filename = UUID.randomUUID().toString() + "." + prefix;
    	        	String pathname = "";
    	        	pathname=uploadFilePath + "c/"+filename;
    	        	File dest = new File(pathname);
    	        	try {
    	        		file.transferTo(dest);
    	        		UpfilesDto upfiles = new UpfilesDto();
    	        		upfiles.setFGroup(Long.parseLong(memberDto.getCompLicense()));
    	        		upfiles.setFName(file.getOriginalFilename());
    	        		upfiles.setFRegDt(currentTime);
    	    			upfiles.setFType("c");
    	        		upfiles.setFUrl(filename);

    	        		int cntF = driverDao.insertDriverFile(upfiles);
    	        		System.out.println("파일 업로드 cnt = "+cntF);
    	        		if(cntF > 0) {
    	        			cnt = cntF;
    	        		}else {
    	        			cnt = -97;
    	        		}
    	        	}catch (IllegalStateException | IOException e) {
    	        		cnt = -97;
    	        		e.printStackTrace();
    	        		throw new valueRtnException(cnt);
    	        	}
    			}
    		}else {
    			cnt = -98;
    		}
    	}else {
    		cnt = -99;
    	}
//    	System.out.println("서비스단 인서트 후 member"+memberDto.toString());
    	return cnt;
    }
    public int updateCompany(MemberDto memberDto,MultipartFile file) throws Exception {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	MemberDto sessionDto = (MemberDto)authentication.getPrincipal();
    	memberDto.setBlackList("N");
    	memberDto.setCompRegUser("system");
    	memberDto.setCompRegDt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
    	int cntC = memberDao.updateCompany(memberDto);
//    	return cnt;
    	System.out.println("넘어온 파일명 = "+memberDto.getFileText());
    	System.out.println("세션 파일명 = "+sessionDto.getFName());
    	System.out.println("회사 업데이트 cnt = "+cntC);
    	int cnt = 0;
    	if(cntC > 0) {//회사 업데이트 성공
    		int cntM = memberDao.updateMember(MemberDto.builder()
        			.memId(memberDto.getMemId())
        			.memName(AESCrypt.encrypt(memberDto.getMemName()))
        			.memDept(memberDto.getMemDept())
        			.memEmail(AESCrypt.encrypt(memberDto.getMemEmail()))
        			.memPhone(AESCrypt.encrypt(memberDto.getMemPhone()))
        			.memCompPhone(memberDto.getMemCompPhone())
        			.memModDt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")))
        			.memModUser("system")
        			.build());
    		System.out.println("멤버 업데이트 cnt = "+cntM);
    		if(cntM>0) {//멤버 업데이트 성공
    			if(!memberDto.getFileText().equals(sessionDto.getFName())) {//파일이름이 같으면 업로드와 파일 업데이트
    				String uploadFilePath = location+"/";
    				/* 현재 시간 설정 */
    				Date date_now = new Date(System.currentTimeMillis());
    				String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
    				if(!Fn.isEmpty(file.getOriginalFilename())) {
    					String prefix = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".")+1, file.getOriginalFilename().length());
    					String filename = UUID.randomUUID().toString() + "." + prefix;
    					String pathname = "";
    					pathname=uploadFilePath + "c/"+filename;
    					File dest = new File(pathname);
    					try {
    						file.transferTo(dest);
    						UpfilesDto upfiles = new UpfilesDto();
    						upfiles.setFGroup(Long.parseLong(memberDto.getCompLicense()));
    						upfiles.setFName(file.getOriginalFilename());
    						upfiles.setFRegDt(currentTime);
    						upfiles.setFType("c");
    						upfiles.setFUrl(filename);

    						int cntF = driverDao.updateFile(upfiles);
    						System.out.println("파일 업로드 cnt = "+cntF);
    						if(cntF > 0) {
    							cnt = cntF;
    						}else {
    							cnt = -97;
    						}
    					}catch (IllegalStateException | IOException e) {
    						cnt = -97;
    						e.printStackTrace();
    						throw new valueRtnException(cnt);
    					}
    				}
    			}else {
    				cnt = cntM;
    			}
    		}else {//멤버 업데이트 실패
    			cnt = -98;
    		}
    	}else {//회사 업데이트 실패
    		cnt = -99;
    	}
//    	System.out.println("서비스단 인서트 후 member"+memberDto.toString());
    	return cnt;
    }

    public int chkMemId(MemberDto memberDto) throws Exception{
    	return memberDao.chkMemId(memberDto);
    }

	public int chkCompLicense(String b_no) throws Exception {
		return memberDao.chkCompLicense(b_no);
	}

	public MemberDto searchId(MemberDto memberDto) throws Exception {
		return memberDao.searchId(memberDto);
	}

	public int modiPwd(MemberDto memberDto) throws Exception{
		return memberDao.modiPwd(memberDto);
	}

	public String chkApproval(MemberDto memberDto) throws Exception {
		String memEmail = memberDto.getMemEmail();
		String memName = memberDto.getMemName();
		
		memEmail = AESCrypt.encrypt(memEmail);
		memName = AESCrypt.encrypt(memName);
		
		memberDto.setMemEmail(memEmail);
		memberDto.setMemName(memName);
		
		return memberDao.chkApproval(memberDto);
	}

	public int dueChkPwd(MemberDto memberDto) throws Exception {
		return memberDao.dueChkPwd(memberDto);
	}
	public int chkMemEmail(MemberDto memberDto) throws Exception {
		return memberDao.chkMemEmail(memberDto);
	}
	public List<MemberDto> getAdminList(MemberDto memberDto) throws Exception {
		List<MemberDto> memberDtoList = memberDao.getAdminList(memberDto);
		for (int i=0; i < memberDtoList.size(); i++) {
			memberDtoList.get(i).setMemName(memberDtoList.get(i).getMemName());
		}
		return memberDtoList;
	}
	public int getAdminListCnt(MemberDto memberDto) throws Exception {
		return memberDao.getAdminListCnt(memberDto);
	}
	public int chkMemIdName(MemberDto memberDto) throws Exception {
		return memberDao.chkMemIdName(memberDto);
	}
	public MemberDto getMemberInfo(String memId) throws Exception{
    	MemberDto memberDto = memberDao.getMemberinfo(memId);
    	memberDto.setMemName(AESCrypt.decrypt(memberDto.getMemName()));
    	memberDto.setMemBirth(AESCrypt.decrypt(memberDto.getMemBirth()));
    	memberDto.setMemPhone(AESCrypt.decrypt(memberDto.getMemPhone()));
    	memberDto.setMemEmail(AESCrypt.decrypt(memberDto.getMemEmail()));
		return memberDto;
	}
}