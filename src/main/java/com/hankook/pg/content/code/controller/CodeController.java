package com.hankook.pg.content.code.controller;

import com.hankook.pg.content.code.service.CodeService;
import com.hankook.pg.content.code.vo.CodeVo;
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
@RequestMapping("/system/code")
public class CodeController {

  @Autowired
  CodeService codeService;

  @RequestMapping(value = "", method = RequestMethod.GET)
  public ModelAndView getCode() throws Exception {
    log.info("코드");
    ModelAndView mv = new ModelAndView("/code/code");

    return mv;
  }

  @PostMapping(value = "/list")
  public List<CodeVo> codeList(@RequestBody CodeVo codeVo) throws Exception {
    System.out.println("code list");
    List<CodeVo> list = codeService.selectCodeList(codeVo);
    return list;
  }

  @RequestMapping(value = "/insert")
  public void insertCode(@RequestBody CodeVo codeVo) throws Exception {
    System.out.println("insert code");
    codeService.insertCode(codeVo);
  }

  @RequestMapping(value = "/update", method = RequestMethod.PUT)
  public void updateCode(@RequestBody CodeVo codeVo) throws Exception {
    System.out.println("update code");
    codeService.updateCode(codeVo);
  }

  @RequestMapping(value = "/delete", method = RequestMethod.DELETE)
  public void deleteCode(@RequestBody CodeVo codeVo) throws Exception {
    System.out.println("delete code");
    codeService.deleteCode(codeVo);
  }
}
