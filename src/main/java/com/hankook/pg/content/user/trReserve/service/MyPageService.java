package com.hankook.pg.content.user.trReserve.service;

import com.hankook.pg.content.admin.shop.vo.ShopVo;
import com.hankook.pg.content.admin.trReserve.dto.TrackDto;
import com.hankook.pg.content.admin.weekday.dto.WeekdayDto;
import com.hankook.pg.content.user.trReserve.dao.MyPageDao;
import com.hankook.pg.content.user.trReserve.vo.MyPageVo;
import com.hankook.pg.content.user.userShop.dao.UserShopDao;
import com.hankook.pg.share.AESCrypt;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.stream.IntStream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MyPageService {

  @Autowired
  MyPageDao myPageDao;
  @Autowired
  private UserShopDao shopDao;

  public List<MyPageVo> getReserveList(MyPageVo myPageVo) {
    return myPageDao.getReserveList(myPageVo);
  }
  public int getReserveListCnt(MyPageVo myPageVo) {
    return myPageDao.getReserveListCnt(myPageVo);
  }

  public List<MyPageVo> getUseList(MyPageVo myPageVo) {
    return myPageDao.getUseList(myPageVo);
  }
  public int getUseListCnt(MyPageVo myPageVo) {
    return myPageDao.getUseListCnt(myPageVo);
  }

  public List<ShopVo> getShop() {
    return myPageDao.getShop();
  }
  public TrackDto getFee() {
    return myPageDao.getFee();
  }
  public List<TrackDto> getTrack() {
    return myPageDao.getTrack();
  }


  public MyPageVo getDetail(MyPageVo myPageVo) throws Exception{
    MyPageVo detail = new MyPageVo();
    if (myPageVo.getText().equals("T")) {
      detail = myPageDao.getTrackDetail(myPageVo.getReservCode());
    } else {
      detail = myPageDao.getShopDetail(myPageVo.getReservCode());
      int applyTime;
      String[] wssReservDay = new String[0];
      if (detail.getWssReservDay() != null) {
        wssReservDay = detail.getWssReservDay().split(",");
      }
      applyTime = wssReservDay.length;
      detail.setPApplyTime(applyTime);
    }

    detail.setMemName(AESCrypt.decrypt(detail.getMemName()));
    detail.setMemPhone(AESCrypt.decrypt(detail.getMemPhone()));
    detail.setMemEmail(AESCrypt.decrypt(detail.getMemEmail()));

    return detail;
  }

  public List<MyPageVo> getDriver(String reservedCode) throws Exception {
    List<MyPageVo> myPageVoList = myPageDao.getDriver(reservedCode);
    for (int i=0; i<myPageVoList.size(); i++) {
      myPageVoList.get(i).setDName(AESCrypt.decrypt(myPageVoList.get(i).getDName()));
    }

    return myPageVoList;
  }

  public List<MyPageVo> getCar(String reservedCode) {
    return myPageDao.getCar(reservedCode);
  }

  @Transactional
  public int cancel(MyPageVo myPageVo) {
    int done;
    String discount = myPageDao.getDiscount(myPageVo.getCompCode());
    if (myPageVo.getType().equals("T")) { // 취소할 예약이 TRACK일 경우
      MyPageVo trackPay = myPageDao.getTrackPrice(myPageVo.getReservCode());
      // 실제 금액과 적용시간 값 계산
      int wholeM = trackPay.getPProductPay() * trackPay.getRealDate();
      double afterDis = wholeM;
      if (discount != null) {
        afterDis = wholeM * (1-(Integer.parseInt(discount) / 100.0));
      }
      double cancelP = Integer.parseInt(myPageVo.getPCancel()) / 100.0;
      int pPay = (int) (afterDis * cancelP);
      int applyTime = 240 * trackPay.getRealDate();

      myPageVo.setPPay(pPay);
      myPageVo.setTrTrackType(trackPay.getTrTrackType());
      myPageVo.setTId(trackPay.getTId());
      myPageVo.setDiscount(discount);
      myPageVo.setPProductPay(trackPay.getPProductPay());
      myPageVo.setPApplyTime(applyTime);

      done = myPageDao.cancelTrack(myPageVo);
    } else { // 취소할 예약이 SHOP일 경우
      MyPageVo shopPay = myPageDao.getShopPrice(myPageVo.getReservCode());
      // 실제 금액과 적용시간 값 계산
      int applyTime;
      String[] wssReservDay = new String[0];
      if (shopPay.getWssReservDay() != null) {
        wssReservDay = shopPay.getWssReservDay().split(",");
      }
      applyTime = wssReservDay.length;
      int wholeM = shopPay.getPProductPay() * applyTime;
      double afterDis = wholeM;
      if (discount != null) {
        afterDis = wholeM * (1-(Integer.parseInt(discount) / 100.0));
      }
      double cancelP = Integer.parseInt(myPageVo.getPCancel()) / 100.0;
      int pPay = (int) (afterDis * cancelP);

      myPageVo.setPPay(pPay);
      myPageVo.setTrTrackType("C");
      myPageVo.setTId(shopPay.getTId());
      myPageVo.setDiscount(discount);
      myPageVo.setPProductPay(shopPay.getPProductPay());
      myPageVo.setPApplyTime(applyTime);

      done = myPageDao.cancelShop(myPageVo);
    }
    System.out.println(myPageVo);
    int result = 0;
    if (done != 0) {
      result = myPageDao.insertPay(myPageVo);
    } else {
      result = 0;
    }
    return result;
  }

  // 예약번호로 예약 가능일 확인
  public int getShopApplyTime(String reservedCode) {
    MyPageVo shop = myPageDao.getShopDetail(reservedCode);
    List<WeekdayDto> bWeek = shopDao.getBWDay();
    String[] day = bWeek.get(0).getWdDay().split(",");
    int[] intDay = new int[day.length];
    for (int i=0;i<day.length; i++) {
      intDay[i] = Integer.parseInt(day[i]);
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    Calendar cal = Calendar.getInstance();

    try {
      cal.setTime(sdf.parse(shop.getStDt()));
    } catch (Exception ignored) {
    }

    int count = shop.getDiff();

    ArrayList test = new ArrayList();

    for (int i = 0; i < count; i++) {
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
              test.add(sdf.format(cal.getTime()));
            }
          }
        }
      }
      cal.add(Calendar.DATE, 1);
    }
    return test.size();
  }

}
