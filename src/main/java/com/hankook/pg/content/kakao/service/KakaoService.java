package com.hankook.pg.content.kakao.service;

import com.hankook.pg.content.kakao.dao.KakaoDao;
import com.hankook.pg.content.kakao.vo.KakaoVo;
import com.hankook.pg.share.AESCrypt;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

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
    
    public KakaoVo insertKakao(KakaoVo kakaoVo) throws Exception{
    	String phone = null;
        List<String> kakaoList = kakaoDao.getKakaoInfo(phone);
        for(int i = 0; i < kakaoList.size(); i++) {
        	//phone = AESCrypt.decrypt(kakaoList.get(i));
        	//kakaoVo.setPhone(phone);
        	kakaoVo.setPhone(AESCrypt.decrypt(kakaoList.get(i)));
        	kakaoVo.setTmplCd("K494_0002"); // 회원가입/운전자 템플릿(변경필)
        	
        	kakaoVo.setSendMsg("[한국테크노링]\r\n"
        			+ "가변문구 테스트 입니다\r\n"
        			+  "운전자님\r\n"
        			+ kakaoVo.getMessage() + "에 \r\n"
        			+ kakaoVo.getMessage() + "예약 신청 완료되었습니다");
        	
//        	kakaoVo.setSendMsg(kakaoVo.getMessage());
        	
        	kakaoDao.insertKakao(kakaoVo);
        	//System.out.println(message);
        }
        
//        if() {
        	//실패(하나라도 insert 성공 못했을 때)면 리턴
//        }else {
        	//성공(모두 insert에 성공했을 때)이면 리턴
//        }
    	//return kakaoDao.insertKakao(kakaoVo);
        //System.out.println("+++++++++"+message);
        return kakaoVo;
    }
}
