package com.hankook.pg.mail.entity;

import lombok.Data;

import java.util.Map;

@Data
public class Email {
  private String seqNum;
  private String title;
  private Map<String,Object> tableMap;
  private String bdt; // 내용
  private String rcver;
  private String rcverEmail;
  private String senderId;
  private String senderName;
  private String statusCode;
  private String statusMsg;
  private String errDt;
  private String regDt;

}
