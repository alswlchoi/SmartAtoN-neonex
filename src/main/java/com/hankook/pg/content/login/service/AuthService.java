package com.hankook.pg.content.login.service;

import com.google.common.collect.Lists;
import com.hankook.pg.content.login.dao.AuthDao;
import com.hankook.pg.content.login.dto.AuthMenuFormatDto;
import com.hankook.pg.content.login.dto.AuthResponseDto;
import com.hankook.pg.content.login.dto.LoginDto;
import com.hankook.pg.content.login.dto.LogoutDto;
import com.hankook.pg.exception.AuthException;
import com.hankook.pg.share.JWTUtil;
import com.hankook.pg.share.Utils;
import com.hankook.pg.share.entity.AccountEntity;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.UnsupportedEncodingException;
import java.util.List;

@Component
@Slf4j
public class AuthService {

  private final static String OK_CODE = "000"; //성공
  private final static String NOT_FOUND_USER = "001"; //계정정보 없음
  private final static String ACCOUNT_PWD_ERR_CODE = "002"; //패스워드오류
  private final static String BLOCK_ACCOUNT_ERR_CODE = "003"; //계정잠김
//  private final static String SLEEP_ACCOUNT_ERR_CODE = "004"; //휴먼계정
//  private final static String ACCOUNT_ERR_CODE = "005";
  private final static String APROVAL_ERR_CODE = "006";
//  private final static String INVALID_IP_ERR_CODE = "007";
//  private final static String INVALID_ROLE_ERR_CODE = "008";

  @Autowired private AuthDao authDao;

  /* 로그인 */
  public AuthResponseDto login(LoginDto loginDto) throws AuthException, UnsupportedEncodingException {

      AccountEntity accountEntity = authDao.findById(loginDto.getId());
      if (accountEntity == null) {
          return AuthResponseDto.builder()
                  .code(NOT_FOUND_USER)
                  .message("계정이 존재하지 않거나, 계정 또는 비밀번호 정보가 틀립니다.")
                  .build();
      }

      if(Integer.toString(accountEntity.getFailCnt()) != null && accountEntity.getFailCnt() > 4){
          return AuthResponseDto.builder()
                  .code(BLOCK_ACCOUNT_ERR_CODE)
                  .message("로그인을 5회 실패하여 계정 접속이 차단 되었습니다.")
                  .build();
      }

      if (!StringUtils.equals(accountEntity.getPwd(), Utils.convertSha512String(loginDto.getPassword()))) {
          authDao.updFailCnt(loginDto.getId());
          return AuthResponseDto.builder()
                  .code(ACCOUNT_PWD_ERR_CODE)
                  .message("계정이 존재하지 않거나, 계정 또는 비밀번호 정보가 틀립니다.")
                  .build();
      }

      if (accountEntity.getAgreYn() == null || StringUtils.isEmpty(accountEntity.getAgreYn())) {
          authDao.updFailCnt(loginDto.getId());
          return AuthResponseDto.builder()
                  .code(APROVAL_ERR_CODE)
                  .message("관리자 승인 후 로그인이 가능합니다.")
                  .build();
      }

      if (StringUtils.isNotEmpty(accountEntity.getAgreYn()) && accountEntity.getAgreYn().equals("N")) {
          authDao.updFailCnt(loginDto.getId());
          return AuthResponseDto.builder()
                  .code(BLOCK_ACCOUNT_ERR_CODE)
                  .message("관리자의해 계정 사용이 중지되었습니다.")
                  .build();
      }

      // 최종 로그인 정보 갱신
      authDao.updateRecentLoginInfo(loginDto.getId());
      // 접속 이력 등록
      //authDao.insertLoginAccessLog(accountEntity);

      return AuthResponseDto.builder()
              .id(accountEntity.getId())
              .name(accountEntity.getName())
              .accesstoken(JWTUtil.createAccesstoken(accountEntity))
              .orgnCode(accountEntity.getOrgnCode())
              .crprtName(accountEntity.getCrprtName())
              .phoneNum(accountEntity.getPhoneNum())
              .email(accountEntity.getEmail())
              .role(accountEntity.getRole())
              //.regDt(accountEntity.getRegDt())
              .updDt(accountEntity.getUpdDt())
              .regId(accountEntity.getRegId())
              .updId(accountEntity.getUpdId())
              .agreYn(accountEntity.getAgreYn())
              .useYn(accountEntity.getUseYn())
              //.acceDt(accountEntity.getAcceDt())
              .failCnt(accountEntity.getFailCnt())
              .pwdChgDt(accountEntity.getPwdChgDt())
              .pwdChgYn(accountEntity.getPwdChgYn())
              .menuInfo(getMenuList(accountEntity.getRole(), loginDto.getIp())) //메뉴정보
              .code(OK_CODE)
              .message("SUCCESS")
              .build();
  }

  /* 로그아웃 */
  public AuthResponseDto logout(LogoutDto logoutDto) {

      //authDao.removeToken(logoutDto.getId());

      return AuthResponseDto.builder()
              .code(OK_CODE)
              .message("SUCCESS")
              .build();
   }

  /* 권한별 메뉴 조회 */
  public List<AuthMenuFormatDto> getMenuList(String role, String userIp) {

      List<AuthMenuFormatDto> menuFormat = Lists.newArrayList();
//
//      List<AuthMenuDto> parentMenu = authDao.selectParentMenu(role); //대분류 메뉴 조회
//      List<AuthMenuChildDto> childMenu = authDao.selectChildMenu(role); //소분류 메뉴 조회
//
//      for(AuthMenuDto parent : parentMenu){
//          AuthMenuFormatDto menuList = new AuthMenuFormatDto();
//          menuList.setChildren(Lists.<AuthMenuChildDto>newArrayList());
//
//          for(AuthMenuChildDto child : childMenu){
//              if(child.getUpMenuId() != null && StringUtils.equals(parent.getLclasMenuCode(), child.getUpMenuId())){
//                  if(!userIp.equals("0:0:0:0:0:0:0:1") && child.getUpMenuId().equals("SYS")){ //로컬인경우 제외
//                      if(!invalidIp(userIp, child)){ //접속 대역 확인
//                          menuList.setMenuId(parent.getLclasMenuCode());
//                          menuList.setMenuNm(parent.getLclasMenuName());
//                          menuList.getChildren().add(child);
//                      }
//                  }else{
//                      menuList.setMenuId(parent.getLclasMenuCode());
//                      menuList.setMenuNm(parent.getLclasMenuName());
//                      menuList.getChildren().add(child);
//                  }
//              }
//          }
//          menuFormat.add(menuList);
//      }
      return menuFormat;
  }

//    private boolean invalidIp(String ip, AuthMenuChildDto child) {
//        return !CheckIpRange.isValidRange(child.getAccessStartIp(), child.getAccessEndIp(), ip);
//    }
}
