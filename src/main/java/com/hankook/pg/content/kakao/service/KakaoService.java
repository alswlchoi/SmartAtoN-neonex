package com.hankook.pg.content.kakao.service;

import com.hankook.pg.content.kakao.dao.KakaoDao;
import com.hankook.pg.content.kakao.vo.KakaoVo;
import com.hankook.pg.share.AESCrypt;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class KakaoService {

    @Autowired
    private KakaoDao kakaoDao;

    // phone에는 복호화된 수신자번호
    // type에는 회원가입 R, 운전자등록 D, 시험로예약 T, 부대시설 S
    // reservCode에는 예약 번호 -- 만약 회원가입/운전자등록에서 사용시 이름 넣기
    public int insertKakao(String phone, String type, String reservCode) throws Exception{
        KakaoVo kakaoVo = new KakaoVo();
        kakaoVo.setPhone(phone);
        if (type.equals("T") || type.equals("S")) {
            kakaoVo.setTmplCd("K494_0001"); // 예약템플릿(변경필)
            if (type.equals("T")) {
                kakaoVo = kakaoDao.getTrackInfo(reservCode);
            }else {
                kakaoVo = kakaoDao.getShopInfo(reservCode);
            }

            kakaoVo.setSendMsg(
                "[한국테크노링]"
                + AESCrypt.decrypt(kakaoVo.getMemName())+"님"
                +kakaoVo.getTcDay()+"에"
                +kakaoVo.getTrTrackName()+"예약이 "+kakaoVo.getPType()+"되었습니다."
            );
        }else {
            kakaoVo.setTmplCd("K494_0002"); // 회원가입/운전자 템플릿(변경필)
            // reservCode에 이름 전달
            // type으로 회원가입 신청/승인/반려, 운전자 신청/승인/반려 구분
            String serviceName = "회원가입"; // 회원가입/운전자등록
            String approval = "완료"; // 신청/승인/반려
            switch (type) {
                case "Rapp":
                    approval = "승인";
                    break;
                case "Rrej":
                    approval = "반려";
                    break;
                case "Dreg":
                    serviceName = "운전자 등록";
                    break;
                case "Dapp":
                    serviceName = "운전자 등록";
                    approval = "승인";
                    break;
                case "Drej":
                    serviceName = "운전자 등록";
                    approval = "반려";
                    break;
            }
            kakaoVo.setSendMsg("[한국테크노링]\n"
                + reservCode + "님 \n"
                + serviceName+"이 "+approval+"되었습니다.");
        }

        return kakaoDao.insertKakao(kakaoVo);
    }
}
