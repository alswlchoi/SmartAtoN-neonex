package com.hankook.pg.content.code.dao;

import com.hankook.pg.content.code.vo.CodeVo;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface ContentCodeDao {

  List<CodeVo> getCode(CodeVo codeVo);

  void insertCode(CodeVo codeVo);

  void updateCode(CodeVo codeVo);

  void deleteCode(CodeVo codeVo);
}
