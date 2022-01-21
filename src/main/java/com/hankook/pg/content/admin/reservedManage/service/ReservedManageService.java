package com.hankook.pg.content.admin.reservedManage.service;

import com.hankook.pg.content.admin.reservedManage.vo.ReservedManageVo;
import com.hankook.pg.content.admin.reservedManage.vo.SearchReservedManageVo;
import com.hankook.pg.content.admin.reservedManage.dao.ReservedManageDao;
import com.hankook.pg.content.user.trReserve.dao.MyPageDao;
import com.hankook.pg.content.user.trReserve.vo.MyPageVo;
import com.hankook.pg.mail.entity.Email;
import com.hankook.pg.mail.service.EmailService;
import com.hankook.pg.share.AESCrypt;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReservedManageService {

  @Autowired
  private ReservedManageDao reservedManageDao;
  @Autowired
  private MyPageDao myPageDao;
  @Autowired
  EmailService emailService;

  public List<ReservedManageVo> getReservedShopList (SearchReservedManageVo searchReservedManageVo) {
    return reservedManageDao.getReservedShopList(searchReservedManageVo);
  }

  public int getReservedShopListCnt(SearchReservedManageVo searchReservedManageVo) {
    return reservedManageDao.getReservedShopListCnt(searchReservedManageVo);
  }

  public ReservedManageVo getReservedShopDetail(SearchReservedManageVo searchReservedManageVo) throws Exception {
    ReservedManageVo reservedManageVo = reservedManageDao.getReservedShopDetail(searchReservedManageVo);

    reservedManageVo.setMemName(AESCrypt.decrypt(reservedManageVo.getMemName()));
    reservedManageVo.setMemPhone(AESCrypt.decrypt(reservedManageVo.getMemPhone()));
    reservedManageVo.setMemEmail(AESCrypt.decrypt(reservedManageVo.getMemEmail()));

    return reservedManageVo;
  }

  public int updateApproval(ReservedManageVo reservedManageVo) {
    int result = reservedManageDao.updateApproval(reservedManageVo);
    Email email = new Email();
    Map<String, Object> tableMap = new HashMap<>();
    MyPageVo myPageVo = myPageDao.getShopDetail(reservedManageVo.getWssReservCode());
    try {
      myPageVo.setMemName(AESCrypt.decrypt(myPageVo.getMemName()));
      myPageVo.setMemPhone(AESCrypt.decrypt(myPageVo.getMemPhone()));
      myPageVo.setMemEmail(AESCrypt.decrypt(myPageVo.getMemEmail()));
    } catch (NoSuchPaddingException e) {
      e.printStackTrace();
    } catch (NoSuchAlgorithmException e) {
      e.printStackTrace();
    } catch (InvalidAlgorithmParameterException e) {
      e.printStackTrace();
    } catch (InvalidKeyException e) {
      e.printStackTrace();
    } catch (BadPaddingException e) {
      e.printStackTrace();
    } catch (IllegalBlockSizeException e) {
      e.printStackTrace();
    }

    tableMap.put("shop", myPageVo);

    email.setTitle("부대시설 예약신청이 완료되었습니다.");
    email.setTableMap(tableMap);
    email.setBdt(null);// 내용
    email.setRcver(myPageVo.getMemName());
    email.setRcverEmail(myPageVo.getMemEmail());

    if (result == 1 && reservedManageVo.getWssApproval().equals("Y")) {
      email.setTitle("부대시설 예약신청이 승인되었습니다.");

      emailService.SenderMail(email, "E07");
//      emailService.GoogleSenderMail(email, "E07");
    } else if (result == 1 && reservedManageVo.getWssApproval().equals("R")) {
      email.setTitle("부대시설 예약신청이 반려되었습니다.");

      emailService.SenderMail(email, "E08");
//      emailService.GoogleSenderMail(email, "E08");
    }
    return result;
  }

  public int updateMemo(ReservedManageVo reservedManageVo) {
    return reservedManageDao.updateMemo(reservedManageVo);
  }

}
