package com.hankook.pg.error.controller;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class CustomErrorController implements ErrorController {
//	private String VIEW_PATH = "/errors/";
	@RequestMapping(value = "/error")
	public ModelAndView handleError(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
		System.out.println("error status==========");
		System.out.println(status);
		if(status != null){
			int statusCode = Integer.valueOf(status.toString());
			if(statusCode == HttpStatus.NOT_FOUND.value()){
				mv.addObject("exception", status);
				mv.setViewName("/errors/404");
			}else if(statusCode == HttpStatus.FORBIDDEN.value()) {
				mv.addObject("exception", status);
				mv.setViewName("/errors/403");
			}
//			if(statusCode == HttpStatus.FORBIDDEN.value()){
//				mv.addObject("exception", status);
//				mv.setViewName("/errors/500");
//			}
		}
		return mv;

	}
//	@RequestMapping(value = "/error")
//	public String handleError(HttpServletRequest request) {
//		Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
//		System.out.println("error status==========");
//		System.out.println(status);
//		if(status != null){
//			int statusCode = Integer.valueOf(status.toString());
//			if(statusCode == HttpStatus.NOT_FOUND.value()){
////				return "/inc/user/00_main.html";
//				return VIEW_PATH + "404.html";
//			}
//			if(statusCode == HttpStatus.FORBIDDEN.value()){
//				return VIEW_PATH + "500.html";
//			}
//		}
//		return "error";
//
//	}
	public String getErrorPath() {
		return null;
	}
}
