package com.hankook.pg.content.user.info.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.content.member.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserInfoController {
	private final PasswordEncoder passwordEncoder;
	private final MemberService memberService;
	/**
     * 회원정보 관리 페이지
     * @return ModelAndView
     */
    @GetMapping("/modify")
    public ModelAndView modify() {
    	ModelAndView mv = new ModelAndView();

    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	MemberDto input = (MemberDto)authentication.getPrincipal();
    	MemberDto memberDto = new MemberDto();
    	try {
			memberDto = memberService.getMemberInfo(input.getMemId());
		} catch (Exception e) {
			memberDto = new MemberDto();
		}
    	mv.addObject("memberDto", memberDto);
    	mv.setViewName("/member/modify");
    	return mv;
    }
    /**
     * 회원정보 관리 페이지
     * @return ModelAndView
     */
    @GetMapping("/modifyPwd")
    public ModelAndView modifyPwd() {
    	ModelAndView mv = new ModelAndView();
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	System.out.println("authentication = "+authentication);
    	if(authentication.getPrincipal() instanceof String){
    		mv.setViewName("redirect:/login");
    	}else {
    		mv.setViewName("/member/modifyPwd");
    	}
    	return mv;
    }
  //패스워드 변경
    @PostMapping("/modifyPwd/modiPwd")
    public Map<String,Object> modiPwd(@RequestBody MemberDto memberDto) throws Exception {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	Map<String,Object> resultMap = new HashMap<String,Object>();
    	memberDto.setMemId(((MemberDto)authentication.getPrincipal()).getMemId());
    	//현재 패스워드
    	String memPwd = ((MemberDto)authentication.getPrincipal()).getMemPwd();
    	//변경할 패스워스
    	String newPwd = passwordEncoder.encode(memberDto.getNewPwd());
    	//입력받은 패스워드(인코딩 전),세션에 들어있는 패스워드 ->
    	if(passwordEncoder.matches(memberDto.getMemPwd(), memPwd)) {
    		memberDto.setNewPwd(newPwd);
	    	int dueChk = memberService.dueChkPwd(memberDto);
	    	if(dueChk>0) {
	    		resultMap.put("result", "OK");
	    	}else {
	    		resultMap.put("result", "FAIL2");
	    	}
	    	resultMap.put("cnt", dueChk);
    	}else {
    		resultMap.put("result", "FAIL");
    	}
//    	memberDto.setNewPwd(passwordEncoder.encode(memberDto.getNewPwd()));
//    	int result = memberService.modiPwd(memberDto);
//    	resultMap.put("result", result);
    	return resultMap;
    }
    //관리자패스워드 변경
    @PostMapping("/adminPwdModify/modiPwd")
    public Map<String,Object> adminPwdModify(@RequestBody MemberDto memberDto) throws Exception {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	Map<String,Object> resultMap = new HashMap<String,Object>();
    	memberDto.setMemId(((MemberDto)authentication.getPrincipal()).getMemId());
    	//변경할 패스워스
    	String newPwd = passwordEncoder.encode(memberDto.getNewPwd());
		memberDto.setNewPwd(newPwd);
		int dueChk = memberService.dueChkPwd(memberDto);
		if(dueChk>0) {
			resultMap.put("result", "OK");
		}else {
			resultMap.put("result", "FAIL2");
		}
		resultMap.put("cnt", dueChk);
    	return resultMap;
    }
}
