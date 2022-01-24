package com.hankook.pg.content.login.dao;

import com.hankook.pg.content.login.dto.AuthMenuChildDto;
import com.hankook.pg.content.login.dto.AuthMenuDto;
import com.hankook.pg.share.entity.AccountEntity;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AuthDao {
  AccountEntity findById(String id);
  void updFailCnt(String id);
  void updateRecentLoginInfo(String id);
  void insertLoginAccessLog(AccountEntity accountEntity);
  List<AuthMenuDto> selectParentMenu(String role);
  List<AuthMenuChildDto> selectChildMenu(String role);

}
