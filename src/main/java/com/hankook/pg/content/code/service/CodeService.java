package com.hankook.pg.content.code.service;

import com.hankook.pg.content.code.dao.ContentCodeDao;
import com.hankook.pg.content.code.vo.CodeContentVo;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CodeService {

  @Autowired
  private ContentCodeDao codeDao;

  public List<CodeContentVo> selectCodeList(CodeContentVo codeContentVo) {
    return codeDao.getCode(codeContentVo);
  }
  
  //구분(C_Type)리스트 불러오기
  public List<CodeContentVo> selectList(CodeContentVo codeContentVo){
	  return codeDao.postCode(codeContentVo);
  }
  
  //토탈 카운트 불러오기
  public int getCodeCnt(CodeContentVo codeContentVo) {
	  return codeDao.getCodeCnt(codeContentVo);
  }
  
  public int insertCode (CodeContentVo codeContentVo) {
    return codeDao.insertCode(codeContentVo);
  }

  public int updateCode (CodeContentVo codeContentVo) {
    return codeDao.updateCode(codeContentVo);
  }

  public int deleteCode (CodeContentVo codeContentVo) {
	return codeDao.deleteCode(codeContentVo);
  }
}
