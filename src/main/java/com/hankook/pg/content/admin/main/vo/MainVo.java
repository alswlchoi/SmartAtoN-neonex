package com.hankook.pg.content.admin.main.vo;

import com.hankook.pg.share.Search;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MainVo extends Search {

  private String tcStep;
  private String type;
  private String today;

  private int company; /*등록회원사 수*/
  private int driver; /*등록운전자 수*/
  private int register; /*회원가입신청자 수*/
  private int dayDriver; /*금일운전자신청 수*/
  private int nTrack; /*시험로예약승인대기 수*/
  private int nShop; /*부대시설승인대기 수*/

  /*전체현황*/
  private int dayTest; /*시험계획 수*/
  private int testing; /*시험중 수*/
  private int testingAll; /*전체 시험중 수*/
  private int testingHK; /*한타 시험중 수*/
  private int testingB2B; /*외부 시험중 수*/
  private int dayShop; /*당일 부대시설 수*/

  /*기상정보*/
  private double ta; /*온도*/
  private double pa; /*기압*/
  private double dp; /*이슬점*/
  private double ws; /*풍속*/
  private double ws10MinMax; /*10분최대풍속*/
  private double wd; /*풍향*/
  private String wdTxt; /*풍향16방위*/
  private String wd10MinMaxTxt; /*10분최대풍속시풍향*/
  private double rainHr; /*시간당누적강우량*/
  private String rainDay; /*일일당누적강우량*/
  private double battv; /*전원전압*/
  private double pTemp; /*시스템내부온도*/
  private double rh; /*습도*/

  private String tId;
  private String tNickName;
  private double road;
  private String roadInTime;
}
