package com.hankook.pg.content.admin.oil.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;


@RestController
@RequestMapping("/admin/oilManagement")
public class OilManagementController {
	@RequestMapping(value="",method= {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView getOilManagement() throws Exception {
		ModelAndView mv = new ModelAndView("/admin/oil/oilManagement");
		return mv;
	}
}
