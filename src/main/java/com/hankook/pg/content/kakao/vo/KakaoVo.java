package com.hankook.pg.content.kakao.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Setter
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class KakaoVo {
    private String senderKey; // Sender키
    private String phone; // 수신번호
    private String callback;
    private String tmplCd; // 템플릿코드
    private String sendMsg; // 메시지본문
    private Date reqDate; // 발송일시
    private Date sendDate;
    private String curState; // 0
    private String rsltCode;
    private Date rsltDate;
    private String rsltCodeSms;
    private String smsType; // N
    private String subJect;
    private String rsltNet;
    private String adFlag;
    private String kkoBtnType;
    private String kkoBtnInfo;
    private String imgUrl;
    private String imgLink;

    // 트랙/부대시설 정보
    private String memName;
    private String tcDay;
    private String trTrackName;
    private String pType;
}
