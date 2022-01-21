package com.hankook.pg.content.login.controller;

import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.content.security.service.Member;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@RestController
public class LoginController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * 로그인 페이지 View 접속
     * @return ModelAndView
     */
    @GetMapping("/login")
    public ModelAndView loginForm() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/login/login");
        return mv;
    }

    /**
     * 로그아웃 처리 및 메인 View 로 리다이렉트
     * @param request
     * @param response
     * @return ModelAndView
     */
    @GetMapping("/logout")
    public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mv = new ModelAndView();
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if(authentication !=null) {
            new SecurityContextLogoutHandler().logout(request,response,authentication);
        }
        mv.setViewName("redirect:/");
        return mv;
    }

    /**
     * 권한 거절 페이지 VIEW 로 이동
     * @return
     */
    @GetMapping("/denied")
    public ModelAndView denied() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/login/denied");
        return mv;
    }


    /**
     * 테스트용 관리자 페이지 View 접속
     * TODO: 내용 삭제
     * @return ModelAndView
     */
    @GetMapping("/system")
    public ModelAndView admin() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/system/system");
        return mv;
    }
}
