package com.hankook.pg.home;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

@RestController
public class homeController {

    @GetMapping("/")
    @ResponseStatus(HttpStatus.OK)
    public ModelAndView getMenu(HttpServletRequest req , ModelAndView mav){
        mav.setViewName("/user/main/main");
        return mav;
    }
    /**
     * 테스트용 관리자 페이지 View 접속
     * @return ModelAndView
     */
    @GetMapping("/system")
    public ModelAndView admin() {
        ModelAndView mv = new ModelAndView();
//        mv.setViewName("/admin/adminMain");
        mv.setViewName("redirect:/adminLogin");
        return mv;
    }
    @GetMapping("/admin")
    public ModelAndView adminMove() {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	ModelAndView mv = new ModelAndView();
    	if(authentication.getPrincipal() instanceof String) {
    		mv.setViewName("redirect:/adminLogin");
		}else {
			mv.setViewName("/admin/adminMain");

		}
    	return mv;
    }
}

