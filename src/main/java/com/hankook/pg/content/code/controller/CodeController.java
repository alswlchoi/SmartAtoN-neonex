package com.hankook.pg.content.code.controller;

import com.hankook.pg.content.code.service.CodeService;
import com.hankook.pg.content.code.vo.CodeContentVo;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Search;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
@RequestMapping("/admin/code")
public class CodeController {

	@Autowired
	private CodeService codeService;

	@RequestMapping(value = "", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView getCode() throws Exception {
		log.info("코드");
		ModelAndView mv = new ModelAndView("/admin/code/code");
		CodeContentVo codeContentVo = new CodeContentVo();
		List<CodeContentVo> list = codeService.selectList(codeContentVo);
		//Map<String,> map = codeService.seletList(codeContentVo);
		System.out.println("============");
		list.forEach(System.out::println);
		mv.addObject("codeList", list);
		return mv;
	}

	@PostMapping("/list")
	public Map<String, Object> codeList(@RequestBody CodeContentVo codeContentVo) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		System.out.println("code list");
		String[] arrOrderCoulmn = {"num asc"};
		codeContentVo.setArrOrderColumn(arrOrderCoulmn);
		//System.out.println(codeContentVo);
		//리스트를 10개 조회
		List<CodeContentVo> list = codeService.selectCodeList(codeContentVo);
		//토탈 카운트
		int cnt = codeService.getCodeCnt(codeContentVo);
		result.put("list", list);
		//페이징 처리
		Search search = new Search();
		search.setPageNo(codeContentVo.getPageNo());
		search.setPageSize(10);
		Paging paging = new Paging(search,cnt);
		result.put("paging", paging);
		result.put("totalCnt", cnt);
		return result;

	}

	@PostMapping("/insert")
	public int insertCode(@RequestBody CodeContentVo codeContentVo) throws Exception {
		System.out.println("insert code");
		int cnt = codeService.insertCode(codeContentVo);
		return cnt;
	}

	@PostMapping("/update")
	public int updateCode(@RequestBody CodeContentVo codeContentVo) throws Exception {
		System.out.println("update code" + codeContentVo);
		int cnt = codeService.updateCode(codeContentVo);
		return cnt;
	}

	@PostMapping("/delete")
	public int deleteCode(@RequestBody CodeContentVo codeContentVo) throws Exception {
		System.out.println("delete code");
		int cnt = codeService.deleteCode(codeContentVo);
		return cnt;
	}
}
