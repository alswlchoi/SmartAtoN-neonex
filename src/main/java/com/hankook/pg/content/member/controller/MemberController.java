package com.hankook.pg.content.member.controller;

import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.hankook.pg.common.util.Fn;
import com.hankook.pg.common.util.HttpUtil;
import com.hankook.pg.content.auth.service.AuthService;
import com.hankook.pg.content.auth.vo.AuthVO;
import com.hankook.pg.content.member.dao.MemberDAO;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.content.member.service.MemberService;
import com.hankook.pg.exception.valueRtnException;
import com.hankook.pg.mail.entity.Email;
import com.hankook.pg.mail.service.EmailService;
import com.hankook.pg.share.AESCrypt;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Search;
import com.hankook.pg.share.Utils;
import lombok.RequiredArgsConstructor;

import org.apache.commons.lang3.RandomStringUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/member")
public class MemberController {

    private final MemberService memberService;
    private final PasswordEncoder passwordEncoder;
    private final MemberDAO memberDao;
    @Autowired
	private AuthService authService;

    @Value("${file.upload.location}")
	private String location;

    @Value("${default.password}")
    private String defaultPassword;

    @Autowired
    private EmailService emailService;
    /**
     * 멤버 페이지 View 접속
     * @return ModelAndView
     */
    @GetMapping("")
    public ModelAndView loginForm() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/member/member");
        return mv;
    }
    /**
     * 멤버 등록 페이지 View 접속
     * @return ModelAndView
     */
    @GetMapping("/register")
    public ModelAndView registerForm() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/member/register");
        return mv;
    }
    /**
     * 아이디/패스워드 찾기
     * @return ModelAndView
     */
    @GetMapping("/search")
    public ModelAndView searchPage(HttpServletRequest req) {
    	ModelAndView mv = new ModelAndView();
    	mv.addObject("tab",req.getParameter("tab"));
    	System.out.println("tab = "+req.getParameter("tab"));
    	mv.setViewName("/member/search");
    	return mv;
    }
    //아이디 찾기
    @PostMapping("/search/byid")
    public Map<String,Object> byid(@RequestBody MemberDto memberDto) throws Exception {
	  	Map<String,Object> resultMap = new HashMap<String,Object>();
	  	MemberDto result = new MemberDto();
	  	memberDto.setMemName(AESCrypt.encrypt(memberDto.getMemName()));
	  	memberDto.setMemEmail(AESCrypt.encrypt(memberDto.getMemEmail()));
	  	memberDto.setMemPhone(AESCrypt.encrypt(memberDto.getMemPhone()));
	  	
	  	result = memberService.searchId(memberDto);
	  	Utils util = new Utils();
	  	
		if(result != null && result.getMemId()!=null &&result.getMemId()!="") {
			result.setMemId(util.maskId(result.getMemId()));
		}

	  	resultMap.put("result", result);
	  	return resultMap;
    }
    //패스워드 찾기
    @PostMapping("/search/bypwd")
    public Map<String,Object> bypwd(@RequestBody MemberDto memberDto) throws Exception {
    	Map<String,Object> resultMap = new HashMap<String,Object>();
    	System.out.println("member : "+memberDto);
    	//passwordEncoder.encode(memberDto.getMemPwd())
    	MemberDto result = new MemberDto();
    	memberDto.setMemName(AESCrypt.encrypt(memberDto.getMemName()));
	  	memberDto.setMemEmail(AESCrypt.encrypt(memberDto.getMemEmail()));
	  	memberDto.setMemPhone(AESCrypt.encrypt(memberDto.getMemPhone()));
    	
    	result = memberService.searchId(memberDto);
    	if(result != null) {
    		if(result.getMemId()!=null&& !result.getMemId().equals("")) {
    			resultMap.put("result", "OK");
    		}else {
    			resultMap.put("result", "FAIL");
    		}
    	}else {
    		resultMap.put("result", "FAIL");
    	}
    	return resultMap;
    }
    //패스워드 변경
    @PostMapping("/search/modiPwd")
    public Map<String,Object> modiPwd(@RequestBody MemberDto memberDto) throws Exception {
    	Map<String,Object> resultMap = new HashMap<String,Object>();
    	memberDto.setMemPwd(passwordEncoder.encode(memberDto.getMemPwd()));
    	int result = memberService.modiPwd(memberDto);
    	resultMap.put("result", result);
    	return resultMap;
    }
    /**
     * 로그인 승인체크 페이지
     * @return ModelAndView
     */
    @GetMapping("/approval")
    public ModelAndView approval() {
    	ModelAndView mv = new ModelAndView();
    	mv.setViewName("/member/approval");
    	return mv;
    }
  //회원가입 심사결과 조회
    @PostMapping("/approval/chk")
    public Map<String,Object> chkApproval(@RequestBody MemberDto memberDto) throws Exception {
    	Map<String,Object> resultMap = new HashMap<String,Object>();
    	String authCode = memberService.chkApproval(memberDto);
    	resultMap.put("result", authCode);
    	return resultMap;
    }

    /**
     * Member 등록
     * 등록 시 password 를 암호화한 뒤 서비스로 전달 한다.
     * @param memberDto
     * @throws Exception
     */
    @RequestMapping(value = "/fileUpload/join",method = RequestMethod.POST)
    public Map<String,Object> createMember(MemberDto member,@RequestParam(value = "hiddenFileType", required = false)MultipartFile multipartFile) throws Exception {
    	Map<String,Object> resultMap = new HashMap<String,Object>();
    	int insCompany=-97;
    	try {
    		insCompany = memberService.createCompany(member,multipartFile);
    	}catch (valueRtnException e) {
    		insCompany = (int)(e.getValue());
		}
    	resultMap.put("member", member);
    	resultMap.put("result", insCompany);
    	return resultMap;
    }
    /**
     * Member 수정
     * 등록 시 password 를 암호화한 뒤 서비스로 전달 한다.
     * @param memberDto
     * @throws Exception
     */
    @PostMapping("/fileUpload/update")
    public Map<String,Object> updateMember(MemberDto member,@RequestParam(value = "hiddenFileType", required = false)MultipartFile multipartFile) throws Exception {
    	Map<String,Object> resultMap = new HashMap<String,Object>();
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	MemberDto newMemDto = (MemberDto)authentication.getPrincipal();
    	member.setMemId(newMemDto.getMemId());
    	member.setCompLicense(newMemDto.getCompLicense());
    	System.out.println("member = "+member);
    	int insCompany=-97;
    	try {
    		insCompany = memberService.updateCompany(member,multipartFile);
    	}catch (valueRtnException e) {
    		insCompany = (int)(e.getValue());
		}
//    	System.out.println(member);
//    	if(insCompany > 0) {
//    		int insMember = memberService.updateMember(member);
//    		if(insMember>0) {
//    			resultMap.put("result","OK");
//    		}else {
//    			resultMap.put("result","MEMBER_ERROR");
//    		}
//    	}else {
//    		resultMap.put("result","COMPANY_ERROR");
//    	}
    	resultMap.put("member", member);
    	resultMap.put("result", insCompany);
    	return resultMap;
    }

    @PostMapping("/idDueChk")
    public Map<String,Object> idDueChk(@RequestBody MemberDto memberDto) throws Exception{
    	Map<String,Object> resultMap = new HashMap<String, Object>();
    	System.out.println("member : "+memberDto);
    	int serchDto = memberService.chkMemId(memberDto);
    	resultMap.put("cnt", serchDto);
    	resultMap.put("memberDto", memberDto);
    	return resultMap;
    }
    @PostMapping("/emailDueChk")
    public Map<String,Object> emailDueChk(@RequestBody MemberDto memberDto) throws Exception{
    	Map<String,Object> resultMap = new HashMap<String, Object>();
    	System.out.println("member : "+memberDto);
    	memberDto.setMemEmail(AESCrypt.encrypt(memberDto.getMemEmail()));
    	int serchDto = memberService.chkMemEmail(memberDto);
    	resultMap.put("cnt", serchDto);
    	resultMap.put("memberDto", memberDto);
    	return resultMap;
    }

    @PostMapping("/companyApi")
    public Map<String,Object> companyApi(@RequestBody String b_no) throws Exception{
    	Map<String,Object> resultMap = new HashMap<String, Object>();
    	//네오넥스소프트 1138189974
    	System.out.println("param = "+b_no);
    	HttpUtil httpUtil = new HttpUtil();
    	JsonElement response = new JsonParser().parse(b_no);
    	System.out.println("response = "+response.getAsJsonObject().get("b_no"));
    	String url = "https://api.odcloud.kr/api/nts-businessman/v1/status?serviceKey=VMR4sFjdZ2i8LhE%2BpuO3lEq9JnLsKlE40YmeJ%2FPp6EIz5WXbH%2FW%2Bg7vyJ12yBVDC%2FBZii1UV0e50RuzGYneXwA%3D%3D";
    	String result = httpUtil.callApi(response, "POST",url);
    	resultMap.put("apiData", result);
    	b_no = response.getAsJsonObject().get("b_no").getAsString();
    	int searchDto = memberService.chkCompLicense(b_no);
    	resultMap.put("cnt", searchDto);
    	return resultMap;
    }
    //관리자 패스워드 찾기
    @GetMapping("/adminPwdSearch")
    public ModelAndView adminPwdSearch(HttpServletRequest req) {
    	ModelAndView mv = new ModelAndView();
    	mv.setViewName("/login/adminPwdSearch");
    	return mv;
    }
    //관리자 패스워드 변경
    @GetMapping("/adminPwdModify")
    public ModelAndView adminPwdModify(HttpServletRequest req,Authentication authentication) {
    	ModelAndView mv = new ModelAndView();
    	if(authentication==null || authentication.getPrincipal() instanceof String){
    		System.out.println("로그인xxxxx");
    		mv.setViewName("redirect:/adminLogin");
    	}else{
    		System.out.println("로그인ooooo");
    		mv.setViewName("/login/adminPwdModify");
    	}
    	return mv;
    }
    //관리자 패스워드 찾기 ajax
    @PostMapping("/adminPwdSearch/modify")
    public void adminPwdSearchModify(@RequestBody MemberDto memberDto) throws Exception {

		String modifyPassword = RandomStringUtils.randomAlphanumeric(6);

    	Map<String,Object> resultMap= new HashMap<String,Object>();
    	//변경할 패스워스
    	String newPwd = passwordEncoder.encode(modifyPassword);
		memberDto.setNewPwd(newPwd);
		memberDto.setMemName(AESCrypt.encrypt(memberDto.getMemName()));
		int infoCnt = memberService.chkMemIdName(memberDto);
		if(infoCnt > 0) {
			//변경
			int dueChk = memberService.dueChkPwd(memberDto);
			if(dueChk>0) {
				resultMap.put("result", "OK");
				//이메일
//				try {
				MemberDto mem = memberService.getMemberInfo(memberDto.getMemId());
				Email email = new Email();
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("modifyPassword", modifyPassword);
				email.setTitle("관리자 임시비밀번호 안내");
				email.setBdt(null);
				email.setRcverEmail(mem.getMemEmail());
				email.setTableMap(map);
				emailService.SenderMail(email, "E06");
//				}catch(Exception e) {
//					emailService.GoogleSenderMail();
//				}
			}else {
				resultMap.put("result", "FAIL2");
			}
		}else {
			resultMap.put("result", "NO");
		}
    	return resultMap;
    }
    //관리자 관리
    @GetMapping("/adminManagement")
    public ModelAndView adminManagement() throws Exception {
    	ModelAndView mv = new ModelAndView();
    	mv.setViewName("/system/adminManagement/adminManagement");
    	AuthVO authVO = new AuthVO();
		authVO.setPageSize(999);
		String[] arrOrderCoulmn = {"authCode"};
		authVO.setArrOrderColumn(arrOrderCoulmn);
		List<AuthVO> authList = authService.getAuthList(authVO);
		mv.addObject("authList",authList);
    	return mv;
    }
    @RequestMapping(value="/adminRegister",method= {RequestMethod.GET,RequestMethod.POST})
    public ModelAndView adminRegister(@RequestParam(required = false) String memId) throws Exception {
    	ModelAndView mv = new ModelAndView();
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	if(authentication.getPrincipal() instanceof String){
    		System.out.println("로그인xxxxx");
    		mv.setViewName("redirect:/adminLogin");
    	}else{
    		System.out.println("로그인ooooo");
    		mv.setViewName("/system/adminManagement/register");
    	}
    	mv.addObject("memId", memId);
    	AuthVO authVO = new AuthVO();
		authVO.setPageSize(999);
		String[] arrOrderCoulmn = {"authCode"};
		authVO.setArrOrderColumn(arrOrderCoulmn);
		List<AuthVO> authList = authService.getAuthList(authVO);
		mv.addObject("authList",authList);
    	return mv;
    }
    @RequestMapping(value="/adminModify",method= {RequestMethod.GET,RequestMethod.POST})
    public ModelAndView adminModify(@RequestParam String memId) throws Exception {
    	ModelAndView mv = new ModelAndView();
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	if(authentication.getPrincipal() instanceof String){
    		System.out.println("로그인xxxxx");
    		mv.setViewName("redirect:/adminLogin");
    	}else{
    		System.out.println("로그인ooooo");
    		mv.setViewName("/system/adminManagement/modify");
    	}
    	mv.addObject("memId", memId);
    	AuthVO authVO = new AuthVO();
    	authVO.setPageSize(999);
    	String[] arrOrderCoulmn = {"authCode"};
    	authVO.setArrOrderColumn(arrOrderCoulmn);
    	
    	List<AuthVO> authList = authService.getAuthList(authVO);
    	mv.addObject("authList",authList);
    	MemberDto memberInfo = memberService.getMemberInfo(memId);
    	mv.addObject("memberInfo",memberInfo);

    	return mv;
    }
    @PostMapping("/adminManagement/search")
    public Map<String,Object> adminManagementSearch(@RequestBody MemberDto memberDto) throws Exception {
	  	Map<String,Object> result = new HashMap<String,Object>();
		memberDto.setSearchKeyword(AESCrypt.encrypt(memberDto.getSearchKeyword()));
	  	//조회조건 정렬
		String[] arrOrderCoulmn = {"memRegDt desc"};
		memberDto.setArrOrderColumn(arrOrderCoulmn);
		//리스트 10개 조회
		List<MemberDto> adminList = memberService.getAdminList(memberDto);
		for(int i=0 ; i<adminList.size(); i++) {
			adminList.get(i).setMemName(AESCrypt.decrypt(adminList.get(i).getMemName()));
		}
		//토탈카운트
		int cnt = memberService.getAdminListCnt(memberDto);
		result.put("list", adminList);
		//페이징 처리
		Search search = new Search();
		search.setPageNo(memberDto.getPageNo());
		search.setPageSize(10);
		Paging paging = new Paging(search,cnt);
		result.put("paging", paging);
		result.put("totalCnt", cnt);
	  	return result;
    }
//    @PostMapping("/adminRegister/join")
    @RequestMapping(value = "/adminRegister/join",method = RequestMethod.POST)
    public Map<String,Object> adminManagementjoin(@RequestBody MemberDto memberDto) throws Exception {
    	Map<String,Object> result = new HashMap<String,Object>();
    	System.out.println("test ====="+memberDto);
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	MemberDto newMemDto = (MemberDto)authentication.getPrincipal();
    	int cntM = memberDao.insertMember(MemberDto.builder()
                .memId(memberDto.getMemId())
                .memPwd(passwordEncoder.encode(defaultPassword))
//                .memPwd(passwordEncoder.encode(defaultPassword))
                .memName(AESCrypt.encrypt(memberDto.getMemName())) 
                .memDept(memberDto.getMemDept())
                .memEmail(AESCrypt.encrypt(memberDto.getMemEmail())) 
                .memPhone(AESCrypt.encrypt(memberDto.getMemPhone())) //
                .memPurpose(memberDto.getMemPurpose())
                .memUserType("admin")
                .memBirth(AESCrypt.encrypt("19990101"))//
                .authCode(memberDto.getAuthCode())
                .compCode(memberDto.getCompCode())
                .memUseYn(memberDto.getMemUseYn())
                .memApproval("Y")
                .memAgreement("Y")
                .memRegUser(newMemDto.getMemId())
                .memRegDt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")))
                .memModDt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")))
                .memModUser(newMemDto.getMemId())
                .kakaoSmsYn(memberDto.getKakaoSmsYn())
                .build());
    	if(cntM>0) {
    		result.put("result", "OK");
    		MemberDto mem = memberService.getMemberInfo(memberDto.getMemId());
			Email email = new Email();
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("defaultPassword", defaultPassword);
			email.setTitle("관리자 승인 안내");
			email.setBdt(null);
			email.setRcver(mem.getMemEmail());
			email.setTableMap(map);
			emailService.SenderMail(email, "E05");
    	}else {
    		result.put("result", "MEMBER_ERROR");
    	}
    	return result;
    }
    @RequestMapping(value = "/adminRegister/modify",method = RequestMethod.POST)
    public Map<String,Object> adminManagementModify(@RequestBody MemberDto memberDto) throws Exception {
    	Map<String,Object> result = new HashMap<String,Object>();
    	System.out.println("test ====="+memberDto);
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	MemberDto newMemDto = (MemberDto)authentication.getPrincipal();
    	int cntM = memberDao.updateAdmin(MemberDto.builder()
    			.memId(memberDto.getMemId())
    			.authCode(memberDto.getAuthCode())
    			.memName(AESCrypt.encrypt(memberDto.getMemName()))
    			.memDept(memberDto.getMemDept())
    			.memPhone(AESCrypt.encrypt(memberDto.getMemPhone()))
    			.memUseYn(memberDto.getMemUseYn())
    			.memPurpose(memberDto.getMemPurpose())
    			.kakaoSmsYn(memberDto.getKakaoSmsYn())
    			.memModDt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")))
    			.memModUser(newMemDto.getMemId())
    			.build());
    	if(cntM>0) {
    		result.put("result", "OK");
    	}else {
    		result.put("result", "MEMBER_ERROR");
    	}
    	return result;
    }

    @RequestMapping(value="/encodeTest",method = RequestMethod.GET)
    public Map<String,Object> encodeTest() throws Exception{
    	Map<String,Object> result = new HashMap<String,Object>();
//    	str = "test";
//    	result.put("str", "test");
//    	String enc = AESCrypt.encrypt(str);
//    	result.put("strEnc",enc);
//    	String dec = AESCrypt.decrypt(enc);
//    	result.put("strDec",dec);
    	return result;

    }
}