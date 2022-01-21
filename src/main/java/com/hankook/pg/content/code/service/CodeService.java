package com.hankook.pg.content.code.service;

import com.hankook.pg.content.code.dao.ContentCodeDao;
import com.hankook.pg.content.code.vo.CodeVo;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CodeService {

  @Autowired
  private ContentCodeDao codeDao;

  public List<CodeVo> selectCodeList(CodeVo codeVo) {
    return codeDao.getCode(codeVo);
  }

  public void insertCode (CodeVo codeVo) {
    codeDao.insertCode(codeVo);
  }

  public void updateCode (CodeVo codeVo) {
    codeDao.updateCode(codeVo);
  }

  public void deleteCode (CodeVo codeVo) {
    codeDao.deleteCode(codeVo);
  }
}
