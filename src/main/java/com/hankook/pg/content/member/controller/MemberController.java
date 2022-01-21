package com.hankook.pg.content.member.controller;

import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.content.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequiredArgsConstructor
@RequestMapping("/member")
public class MemberController {

    private final MemberService memberService;

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
     * Member 등록
     * 등록 시 password 를 암호화한 뒤 서비스로 전달 한다.
     * @param memberDto
     * @throws Exception
     */
    @PostMapping("/register")
    @ResponseBody
    public int createMember(@RequestBody MemberDto memberDto) throws Exception {
        return memberService.createMember(memberDto);
    }
}