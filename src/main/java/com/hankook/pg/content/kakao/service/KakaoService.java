package com.hankook.pg.content.kakao.service;

import com.hankook.pg.content.kakao.dao.KakaoDao;
import com.hankook.pg.content.kakao.vo.KakaoVo;

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
    
    public int insertKakao(KakaoVo kakaoVo) throws Exception{

        kakaoVo.setTmplCd("K494_0002");
        kakaoVo.setSendMsg("[한국테크노링]\r\n"
        		+ "가변문구 테스트 입니다\r\n"
        		+ kakaoVo.getName() +"님\r\n"
        		+ "에 부대시설A 예약 신청 완료되었습니다");

        return kakaoDao.insertKakao(kakaoVo);
    }
}
