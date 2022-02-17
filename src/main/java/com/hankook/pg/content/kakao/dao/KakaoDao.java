package com.hankook.pg.content.kakao.dao;

import com.hankook.pg.content.kakao.vo.KakaoVo;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface KakaoDao {

    int insertKakao(KakaoVo kakaoVo);
}
