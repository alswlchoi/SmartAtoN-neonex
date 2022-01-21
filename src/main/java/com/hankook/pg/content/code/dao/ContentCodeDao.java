package com.hankook.pg.content.code.dao;

import com.hankook.pg.content.code.vo.CodeContentVo;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface ContentCodeDao {

  List<CodeContentVo> getCode(CodeContentVo codeContentVo);
  
  List<CodeContentVo> postCode(CodeContentVo codeContentVo);

  int insertCode(CodeContentVo codeContentVo);

  int updateCode(CodeContentVo codeContentVo);

  int deleteCode(CodeContentVo codeContentVo);
  
  int getCodeCnt(CodeContentVo codeContentVo);
}
