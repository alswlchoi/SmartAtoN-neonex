package com.hankook.pg.content.auth.controller;

import com.hankook.pg.content.auth.service.AuthService;
import com.hankook.pg.content.auth.vo.AuthVO;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@RestController
@RequestMapping("/system/auth")
public class AuthController {
	@Autowired
	private AuthService authService;

	@RequestMapping(value="",method= {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView getAuth() throws Exception {
		log.debug("권한관리 페이지 접속");
		System.out.println("권한관리 페이지 접속");
		ModelAndView mv = new ModelAndView("/system/auth/auth");

		return mv;
	}
	@PostMapping("/search")
	public List<AuthVO> searchAuth(@RequestBody AuthVO authVo) throws Exception {
		System.out.println("권한관리 페이지 조회"+authVo);
		List<AuthVO> list = authService.getAuthList(authVo);
		return list;
	}
	@PostMapping("/insert")
	public int insertAuth(@RequestBody AuthVO authVo) throws Exception {
		System.out.println("권한관리 등록"+authVo);
		int cnt = authService.insertAuth(authVo);
		return cnt;
	}
	@PostMapping("/upd")
	public int updateAuth(@RequestBody AuthVO authVo) throws Exception {
		System.out.println("권한관리 수정"+authVo);
		int cnt = authService.updateAuth(authVo);
		return cnt;
	}
	@PostMapping("/del")
	public int deleteAuth(@RequestBody AuthVO authVo) throws Exception {
		System.out.println("권한관리 삭재"+authVo);
		int cnt = authService.deleteAuth(authVo);
		return cnt;
	}
}
