package com.hankook.pg.content.kakao.dao;

import com.hankook.pg.content.kakao.vo.KakaoVo;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface KakaoDao {

    int insertKakao(KakaoVo kakaoVo);

    //KakaoVo getTrackInfo (String phone);
    List<String> getKakaoInfo(String message) throws Exception;
}
