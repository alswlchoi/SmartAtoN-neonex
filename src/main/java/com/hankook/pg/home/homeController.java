package com.hankook.pg.home;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

@Controller
public class homeController {

    @RequestMapping("/")
    @ResponseStatus(HttpStatus.OK)
    public ModelAndView getMenu(HttpServletRequest req , ModelAndView mav){
        mav.setViewName("/index");
        return mav;
    }
}

