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

        kakaoVo.setTmplCd("K494_0001");
        kakaoVo.setSendMsg("알림톡 테스트입니다.");

        return kakaoDao.insertKakao(kakaoVo);
    }
}
