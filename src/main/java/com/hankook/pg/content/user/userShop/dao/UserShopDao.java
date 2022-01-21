package com.hankook.pg.content.user.userShop.dao;

import com.hankook.pg.content.admin.weekday.dto.WeekdayDto;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.content.user.userShop.vo.UserShopVo;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface UserShopDao {

  List<UserShopVo> selectUserShop(UserShopVo userShopVo);

  int insertUserShop(UserShopVo shopVo);
  int updateUserShop(UserShopVo shopVo);
  int deleteUserShop(UserShopVo shopVo);

  MemberDto getUserInfo(String memId);

  String getMaxReserveCode (String wssReservCode);
  int getPrice(String wsCode);

  int updateMember(UserShopVo userShopVo);
  int updateCompany(UserShopVo userShopVo);

  // 일별 수정 이전 체크 -----> 사용 안함
  int chkSchedule (UserShopVo userShopVo);
  int chkWeekDay (UserShopVo userShopVo);
  int chkDayOff (UserShopVo userShopVo);

  List<UserShopVo> getEvents(UserShopVo userShopVo);

  List<WeekdayDto> getWeekDay(String wdKind);
  List<WeekdayDto> getBWDay();

  int reservChk(UserShopVo userShopVo);

}
