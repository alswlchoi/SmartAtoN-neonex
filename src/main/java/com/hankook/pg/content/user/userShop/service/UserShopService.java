package com.hankook.pg.content.user.userShop.service;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.admin.weekday.dto.WeekdayDto;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.content.user.trReserve.dao.MyPageDao;
import com.hankook.pg.content.user.trReserve.vo.MyPageVo;
import com.hankook.pg.content.user.userShop.dao.UserShopDao;
import com.hankook.pg.content.user.userShop.vo.UserShopVo;
import com.hankook.pg.mail.entity.Email;
import com.hankook.pg.mail.service.EmailService;
import com.hankook.pg.share.AESCrypt;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserShopService {

  @Autowired
  private UserShopDao shopDao;
  @Autowired
  private MyPageDao myPageDao;
  @Autowired
  private EmailService emailService;

  public ArrayList selectUserShop(UserShopVo userShopVo) {
    // 가져온 리스트 저장
    List<UserShopVo> getList = shopDao.selectUserShop(userShopVo);
    // 새로 만들 리스트
    ArrayList newList = new ArrayList();

    // 가져온 리스트 WSS_RESERV_DAY 분리
    for (UserShopVo shopVo : getList) {
      if (shopVo.getWssReservDay() != null) {
        String[] wssReservDay = shopVo.getWssReservDay().split(",");
        if (wssReservDay.length > 0) {
          for (int i=0; i<wssReservDay.length; i++) {
            UserShopVo newUserShopVo = new UserShopVo();
            newUserShopVo.setWssStDay(wssReservDay[i]);
            newUserShopVo.setWssEdDay(wssReservDay[i]);
            newUserShopVo.setWssApproval(shopVo.getWssApproval());
            newUserShopVo.setWsCode(shopVo.getWsCode());
            newUserShopVo.setWsName(shopVo.getWsName());
            newUserShopVo.setCompName(shopVo.getCompName());

            newList.add(newUserShopVo);
          }
        }
      }
    }

    return newList;
  }

  public int insertUserShop (UserShopVo userShopVo) throws Exception {
    /* 현재 시간 설정 */
    Date date_now = new Date(System.currentTimeMillis());
    String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");

    String compType = "B";
    String tFType = "F";
    /* 예약번호 생성 (YYMMDD_xx)		_자리 : B2B는 B, 한국타이어는 T, 현대자동차는 H */
    String compareCode = tFType+Fn.toDateFormat(currentTime, "yyMMdd")+compType;
    String maxWssReservCode = shopDao.getMaxReserveCode(compareCode);		//오늘 날짜로 가장 큰 예약번호를 가져옴
    Integer codeNum;
    String wssServCode = "";
    if(maxWssReservCode.equals("")) {		//해당일 예약건이 없으면
      codeNum = 1;
    }else {		//해당일 예약건이 있으면 숫자추출해서 +1 해줌
      String[] codeArr = maxWssReservCode.split(compType);
      codeNum = Fn.toInt(codeArr[1])+1;
    }

    if(codeNum<10) {
      wssServCode = compareCode+"00"+codeNum;
    }else if(codeNum<100){
      wssServCode = compareCode+"0"+codeNum;
    }else {
      wssServCode = compareCode+codeNum;
    }
    String wsCode = userShopVo.getWsCode();
    Integer price = shopDao.getPrice(wsCode);

    userShopVo.setWssReservCode(wssServCode);
    userShopVo.setWsPrice(price);
    userShopVo.setWssRegDt(currentTime);

    userShopVo.setMemPhone(AESCrypt.encrypt(userShopVo.getMemPhone()));
    userShopVo.setMemEmail(AESCrypt.encrypt(userShopVo.getMemEmail()));
    shopDao.updateMember(userShopVo);
    shopDao.updateCompany(userShopVo);

    int result = shopDao.insertUserShop(userShopVo);
    Map<String, Object> tableMap = new HashMap<>();
    if (result == 1) {
      Email email = new Email();
      MyPageVo myPageVo = myPageDao.getShopDetail(userShopVo.getWssReservCode());
      myPageVo.setMemName(AESCrypt.decrypt(myPageVo.getMemName()));
      myPageVo.setMemPhone(AESCrypt.decrypt(myPageVo.getMemPhone()));
      myPageVo.setMemEmail(AESCrypt.decrypt(myPageVo.getMemEmail()));
      tableMap.put("shop", myPageVo);

      email.setTitle("부대시설 예약신청이 완료되었습니다.");
      email.setTableMap(tableMap);
      email.setBdt(null);// 내용
      email.setRcver(myPageVo.getMemName());
      email.setRcverEmail(userShopVo.getMemEmail());

      emailService.SenderMail(email, "E07");
//      emailService.GoogleSenderMail(email, "E07");
    }

    return result;
  }

  public int updateUserShop (UserShopVo userShopVo) {
    return shopDao.updateUserShop(userShopVo);
  }

  public int deleteUserShop (UserShopVo userShopVo) {
    return shopDao.deleteUserShop(userShopVo);
  }

  public MemberDto getUserInfo(MemberDto memberDto) throws Exception {
    String memId = memberDto.getMemId();
    MemberDto getMem = shopDao.getUserInfo(memId);
    getMem.setMemName(AESCrypt.decrypt(getMem.getMemName()));
    getMem.setMemBirth(AESCrypt.decrypt(getMem.getMemBirth()));
    getMem.setMemPhone(AESCrypt.decrypt(getMem.getMemPhone()));
    getMem.setMemEmail(AESCrypt.decrypt(getMem.getMemEmail()));
    return getMem;
  }

  public int chkSchedule (UserShopVo userShopVo){
    int shop = shopDao.chkSchedule(userShopVo);
    int dayoff = shopDao.chkDayOff(userShopVo);
    int weekDay = shopDao.chkWeekDay(userShopVo);
    return shop+dayoff+weekDay;
  }

  public List<UserShopVo> getEvents(UserShopVo userShopVo) {
    return shopDao.getEvents(userShopVo);
  }

  public List<WeekdayDto> getWeekDay(String wdKind) {
    return shopDao.getWeekDay(wdKind);
  }
  public List<WeekdayDto> getBWDay() {
    return shopDao.getBWDay();
  }

  // 날짜 사이에 가능 일 가져오기
  public UserShopVo getApplyDate(UserShopVo userShopVo) {
    UserShopVo date = new UserShopVo();
    String stDt = userShopVo.getWssStDay();

    List<WeekdayDto> bWeek = shopDao.getBWDay();
    String[] day = bWeek.get(0).getWdDay().split(",");
    int[] intDay = new int[day.length];
    for (int i=0;i<day.length; i++) {
      intDay[i] = Integer.parseInt(day[i]);
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    Calendar cal = Calendar.getInstance();

    try {
      cal.setTime(sdf.parse(stDt));
    } catch (Exception ignored) {
    }

    int count = userShopVo.getReservedCnt();
    ArrayList dates = new ArrayList();

    MyPageVo shop = new MyPageVo();
    shop.setWsCode(userShopVo.getWsCode());
    for (int i=0; i < count; i++) {
      // 예약 불가능한 요일 체크
      if (IntStream.of(intDay).anyMatch(x -> x == cal.get(Calendar.DAY_OF_WEEK)-1)) {
        shop.setChkDt(sdf.format(cal.getTime()));
        // 예약 불가능한 날짜 체크
        int schedul = myPageDao.chkSchedule(shop);
        if (schedul == 0) {
          int dayOff = myPageDao.chkDayOff(shop.getChkDt());
          if (dayOff == 0) {
            int weekDay = myPageDao.chkWeekDay(shop);
            if (weekDay == 0) {
              dates.add(sdf.format(cal.getTime()));
            }
          }
        }
      }
      cal.add(Calendar.DATE, 1);
    }
    date.setDates(dates);
    return date;
  }

  public int reservChk(UserShopVo userShopVo) throws Exception {
    return shopDao.reservChk(userShopVo);
  }
}
