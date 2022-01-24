package com.hankook.pg.content.lobby.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;


@RestController
@RequestMapping("/l")
public class LobbyController {
	// lobby 추가
	@RequestMapping(value="/lobby",method= RequestMethod.GET)
	public ModelAndView lobby() throws Exception {
		ModelAndView mv = new ModelAndView("/admin/dashboard/lobby");
		return mv;
	}
}
