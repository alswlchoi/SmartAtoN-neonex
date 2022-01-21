package com.hankook.pg.content.login.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@RestController
public class LoginController {

//    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    /**
     * 로그인 페이지 View 접속
     * @return ModelAndView
     */
    @GetMapping("/login")
    public ModelAndView loginForm(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mv = new ModelAndView();
//        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//        if(authentication !=null) {
//            new SecurityContextLogoutHandler().logout(request,response,authentication);
//        }
        mv.setViewName("/login/login");
        return mv;
    }
    @GetMapping("/adminLogin")
    public ModelAndView adminLogin(HttpServletRequest request, HttpServletResponse response) {
    	ModelAndView mv = new ModelAndView();
    	mv.setViewName("/login/adminLogin");
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
    @GetMapping("/adminLogout")
    public ModelAndView adminLogout(HttpServletRequest request, HttpServletResponse response) {
    	ModelAndView mv = new ModelAndView();
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	if(authentication !=null) {
    		new SecurityContextLogoutHandler().logout(request,response,authentication);
    	}
    	mv.setViewName("redirect:/adminLogin");
    	return mv;
    }

    /**
     * 권한 거절 페이지 VIEW 로 이동
     * @return
     */
    @GetMapping("/denied")
    public ModelAndView denied(@RequestParam(required = false) String exception) {
//    	System.out.println("거부");
//        ModelAndView mv = new ModelAndView();
//        mv.setViewName("redirect:/login");
    	ModelAndView mv = new ModelAndView();
        mv.setViewName("/login/denied");
        return mv;
    }

}
