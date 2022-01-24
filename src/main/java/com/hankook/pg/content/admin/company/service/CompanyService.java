package com.hankook.pg.content.admin.company.service;
 
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.common.util.Validity;
import com.hankook.pg.content.admin.company.dao.CompanyDao;
import com.hankook.pg.content.admin.company.dto.CompanyDto;
import com.hankook.pg.content.admin.company.dto.SearchCompanyDto;
import com.hankook.pg.content.admin.driver.dto.UpfilesDto;
import com.hankook.pg.content.admin.trReserve.dto.TrackDto;
import com.hankook.pg.content.admin.trReserve.service.TrReserveService;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.mail.entity.Email;
import com.hankook.pg.mail.service.EmailService;
import com.hankook.pg.share.AESCrypt;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Results;

@Service
@Transactional(rollbackFor = Exception.class)
public class CompanyService{
    
    @Autowired
    private CompanyDao companyDao;
    
    @Autowired
    private TrReserveService trReserveService;
    
    @Autowired
    private EmailService emailService;
    
      
    public Map<String, Object> getCompanyList(SearchCompanyDto searchCompany) throws Exception {
    	searchCompany.setStartRowNum((searchCompany.getPageNo()-1)*10);

		if(null!=searchCompany.getCompRegStDt()) {		//등록일 조건 검색이 있을 경우
			String days[] = searchCompany.getCompRegStDt().split("~");	// ~ 구분자로 시작일과 마감일 분리, 형식 안 맞으면 insert 안 됨
			if(days.length==2) {
				String regStDt = days[0].trim();	//시작일
				String regEdDt = days[1].trim();	//마감일
				//형식에 맞게 처리 해 줌

				regStDt = Fn.toDateFormat(regStDt, "yyyyMMdd")+"000000";
				regEdDt = Fn.toDateFormat(regEdDt, "yyyyMMdd")+"235959";
				
				searchCompany.setCompRegStDt(regStDt);
				searchCompany.setCompRegEdDt(regEdDt);
			}
		}
		String compName = searchCompany.getCompName();
		if(null!=compName&&!"".equals(compName)) {
			compName = compName.replaceAll("-", "");
		}
    	searchCompany.setMemApproval(searchCompany.getMemApproval());
    	searchCompany.setCompName(compName);
    	searchCompany.setMemName(AESCrypt.encrypt(compName));
    	
    	List<CompanyDto> companyList = companyDao.getCompanyList(searchCompany);
    	
    	for (int i=0; i<companyList.size(); i++) {
    		companyList.get(i).setMemName(AESCrypt.decrypt(companyList.get(i).getMemName()));
    		companyList.get(i).setMemPhone(AESCrypt.decrypt(companyList.get(i).getMemPhone()));
	    }
        Paging paging = new Paging(searchCompany, companyDao.findCompanyCount(searchCompany));

        return Results.grid(paging, companyList);
    }
    
    public Integer getCompCodeduplCheck(String compCode) throws Exception {
    	return companyDao.getCompCodeduplCheck(compCode);
    }
    
    public boolean insertCompany(CompanyDto company) throws Exception {
    	//로그인된 회원정보 가져옴
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();
		
		Integer cnt = 0;
		
		if(!memberDto.getMemUserType().equals("admin")) {
			cnt = -1;
		}else {
	    	/* 현재 시간 설정 */
	    	Date date_now = new Date(System.currentTimeMillis());
	    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
	    	company.setCompRegDt(currentTime);
	    	company.setCompRegUser(memberDto.getMemId());
	    	String maxCompCode = companyDao.getMaxCompCode();
	    	int nextCodeNum = Fn.toInt(maxCompCode.replaceAll("C",""))+1; 
	    	if(nextCodeNum<10) {
	    		company.setCompCode("C000"+nextCodeNum);
	    	}else if(nextCodeNum>=10 && nextCodeNum<100) {
	    		company.setCompCode("C00"+nextCodeNum);
	    	}else if(nextCodeNum>=100 && nextCodeNum<1000) {
	    		company.setCompCode("C0"+nextCodeNum);
	    	}else {
	    		company.setCompCode("C"+nextCodeNum);
	    	}
	    	cnt = companyDao.insertCompany(company);
		}
		return cnt > 0;
    }
     
    public CompanyDto getCompanyDetail(String compCode) throws Exception {
    	CompanyDto company = companyDao.getCompanyDetail(compCode);
        
    	if(null!=company) {
	    	if(null !=company.getMemPurpose()) { 
	    		String memPurpose = company.getMemPurpose();
	    		memPurpose = Fn.scriptFilterDec(memPurpose);
	    		company.setMemPurpose(memPurpose);
	    	}
	    	if(null !=company.getCompMemo()) {
	    		String compMemo = company.getCompMemo();
	    		compMemo = Fn.scriptFilterDec(compMemo);
	    		company.setCompMemo(compMemo);
	    	}
	    	
	    	String dcCount = companyDao.getDcCount(compCode);
	    	company.setDcCount(dcCount);
	    	
	    	company.setMemName(AESCrypt.decrypt(company.getMemName()));
	    	company.setMemPhone(AESCrypt.decrypt(company.getMemPhone()));
	    	company.setMemEmail(AESCrypt.decrypt(company.getMemEmail()));
    	}    	

    	return company;
    }
    
    public CompanyDto getCompanyDetailExpression(CompanyDto company) throws Exception {
    	String compLicense = company.getCompLicense();
    	String memPhone = company.getMemPhone();
    	String compPhone = company.getCompPhone();
    	String compAcctPhone = company.getCompAcctPhone();
    	
    	compLicense = compLicense.substring(0, 3)+"-"+compLicense.substring(3, 5)+"-"+compLicense.substring(5, 10);
    	company.setCompLicense(compLicense);
    	
    	memPhone = memPhone.substring(0, 3)+"-"+memPhone.substring(3, 7)+"-"+memPhone.substring(7, 11);
    	company.setMemPhone(memPhone);
    	
    	if(!Validity.isNull(compPhone)){
			if(compPhone.substring(0,2) =="02"){
				if(compPhone.length()==10){
					compPhone = compPhone.substring(0,2)+"-"+compPhone.substring(2,6)+"-"+compPhone.substring(6,10);
				}
				if(compPhone.length()!=10){
					compPhone = compPhone.substring(0,2)+"-"+compPhone.substring(2,5)+"-"+compPhone.substring(5,10);
				}
			}
			if(compPhone.substring(0,3) =="010"){
				compPhone = compPhone.substring(0,3)+"-"+compPhone.substring(3,7)+"-"+compPhone.substring(7,11);
			}
			if(compPhone.substring(0,2) !="02" && compPhone.substring(0,3) !="010"){
				if(compPhone.length()==10){
					compPhone = compPhone.substring(0,2)+"-"+compPhone.substring(2,6)+"-"+compPhone.substring(6,10);
				}
				if(compPhone.length()==11){
					compPhone = compPhone.substring(0,3)+"-"+compPhone.substring(3,7)+"-"+compPhone.substring(7,11);
				}
				if(compPhone.length()==12){
					compPhone = compPhone.substring(0,4)+"-"+compPhone.substring(4,8)+"-"+compPhone.substring(8,12);
				}
			}
			
			company.setCompPhone(compPhone);
		}
    	
    	if(!Validity.isNull(compAcctPhone)){
			if(compAcctPhone.substring(0,2) =="02"){
				if(compAcctPhone.length()==10){
					compAcctPhone = compAcctPhone.substring(0,2)+"-"+compAcctPhone.substring(2,6)+"-"+compAcctPhone.substring(6,10);
				}
				if(compAcctPhone.length()!=10){
					compAcctPhone = compAcctPhone.substring(0,2)+"-"+compAcctPhone.substring(2,5)+"-"+compAcctPhone.substring(5,10);
				}
			}
			if(compAcctPhone.substring(0,3) =="010"){
				compAcctPhone = compAcctPhone.substring(0,3)+"-"+compAcctPhone.substring(3,7)+"-"+compAcctPhone.substring(7,11);
			}
			if(compAcctPhone.substring(0,2) !="02" && compAcctPhone.substring(0,3) !="010"){
				if(compAcctPhone.length()==10){
					compAcctPhone = compAcctPhone.substring(0,2)+"-"+compAcctPhone.substring(2,6)+"-"+compAcctPhone.substring(6,10);
				}
				if(compAcctPhone.length()==11){
					compAcctPhone = compAcctPhone.substring(0,3)+"-"+compAcctPhone.substring(3,7)+"-"+compAcctPhone.substring(7,11);
				}
				if(compAcctPhone.length()==12){
					compAcctPhone = compAcctPhone.substring(0,4)+"-"+compAcctPhone.substring(4,8)+"-"+compAcctPhone.substring(8,12);
				}
			}
			
			company.setCompAcctPhone(compAcctPhone);
		}
    	
    	return company;
    }
    public UpfilesDto getFileLicense(BigDecimal license) throws Exception {
    	return companyDao.getFileLicense(license);    	
    }
    
    public boolean updateCompany(CompanyDto company, HttpServletRequest request) throws Exception {
		String compMemo = company.getCompMemo();
		String dcCount = company.getDcCount();
		compMemo = Fn.toStringHtml(compMemo);
    	//로그인된 회원정보 가져옴
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();

    	/* 현재 시간 설정 */
    	Date date_now = new Date(System.currentTimeMillis());
    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
    	
		company = companyDao.getCompanyDetail(company.getCompCode());
		company.setCompMemo(compMemo);
		company.setDcModDt(currentTime);
		company.setDcModUser(memberDto.getMemId());
		
    	int cnt = companyDao.updateCompany(company);

    	if(Fn.toDouble(dcCount)>0 && Fn.toDouble(dcCount)<=100) {
    		company.setDcCount(dcCount);
        	company.setDcName("회원사 할인");
        	company.setDcRegDt(currentTime);
        	company.setDcRegUser(memberDto.getMemId());

        	cnt = companyDao.insertDiscount(company);
    	}else {
        	cnt = companyDao.deleteDiscount(company);
    	}
    	
    	return cnt > 0;
    }
    
    public boolean changeCompany(CompanyDto company) throws Exception {
    	//로그인된 회원정보 가져옴
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();

		String compMemo = Fn.toStringHtml(company.getCompMemo());
		String memApporval = company.getMemApproval();
		Integer cnt = 0;
		
		if(!memberDto.getMemUserType().equals("admin")) {
			cnt = -1;
		}else {
			company = companyDao.getCompanyDetail(company.getCompCode());
			
			company.setMemApproval(memApporval);
			if(memApporval.equals("R")) {
				company.setCompMemo(compMemo);		//반려일 경우 반려 사유
				cnt = companyDao.updateCompany(company);
			}
			
			cnt = companyDao.changeApproval(company);
			
			Map<String, Object> tableMap = emailSetting(company);
			
			
			Email email = new Email();
			email.setTableMap(tableMap);
			email.setBdt(null);
			email.setRcverEmail(AESCrypt.decrypt(company.getMemEmail()));
			email.setSenderId(null);
			email.setSenderName(null);
			email.setStatusCode(null);
			email.setStatusMsg(null);
			email.setErrDt(null);
			email.setRegDt(null);
			
			if(memApporval.equals("Y")) {
				email.setTitle("회원사 가입신청이 승인되었습니다.");
				emailService.SenderMail(email, "E01");
			}else {
				email.setTitle("회원사 가입신청이 반려되었습니다.");
				emailService.SenderMail(email, "E02");
			}
		}
    	return cnt > 0;
    }
    
    public boolean companyBlackList(CompanyDto company) throws Exception {
    	int cnt = companyDao.companyBlackList(company); 
    	return cnt > 0;
    }
       
    public boolean deleteCompany(String compCode) throws Exception {
    	int cnt = companyDao.deleteCompany(compCode); 
    	return cnt > 0;
    }
    
    public Map<String, Object>  emailSetting(CompanyDto company) throws Exception {
    	/* 현재 시간 설정 */
    	Date date_now = new Date(System.currentTimeMillis());
    	String currentTime = Fn.toDateFormat(date_now, "yyyy.MM.dd HH:mm");
		List<TrackDto> trackList = trReserveService.getTrackList("Y");
        String compMemo = company.getCompMemo();
    	Integer entranceFee = trReserveService.SelectEntranceFee();
        
        if(compMemo!=null&&!"".equals(compMemo)) {
        	compMemo = compMemo.replaceAll("\r\n", "<br />").replaceAll("\r", "<br />").replaceAll("\n", "<br />");
        }
        
        String compRegDt = company.getCompRegDt();
        compRegDt = Fn.toDateFormat(compRegDt, "yyyy.MM.dd HH:mm");
        
        Map<String, Object> tableMap = new HashMap<>();
        
    	tableMap.put("compRegDt", compRegDt);
    	tableMap.put("compModDt", currentTime);
   		tableMap.put("compMemo", compMemo);
    	tableMap.put("memId", company.getMemId());
    	tableMap.put("trackList", trackList);
    	tableMap.put("entranceFee", entranceFee);
    	
    	return tableMap;
    }
}

