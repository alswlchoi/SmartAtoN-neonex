package com.hankook.pg.content.admin.main.service;

import com.hankook.pg.content.admin.main.dao.MainDao;
import com.hankook.pg.content.admin.main.vo.MainVo;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MainService {

  @Autowired
  private MainDao mainDao;

  public MainVo setMainVo() {
    MainVo result = new MainVo();

    result.setCompany(mainDao.getCompanyCnt());
    result.setDriver(mainDao.getDriverCnt());
    result.setRegister(mainDao.getRegisterCnt());
    result.setDayDriver(mainDao.getDayDriverCnt());
    result.setNTrack(mainDao.getNTrackCnt());
    result.setNShop(mainDao.getNShopCnt());

    return result;
  }

  public MainVo dayTest(MainVo mainVo) {
    MainVo newMain = new MainVo();
    /*시험계획 수*/
    mainVo.setTcStep("N");
    newMain.setDayTest(mainDao.getDayTestingCnt(mainVo));
    /*전체 시험중 수*/
    mainVo.setTcStep("Y");
    newMain.setTestingAll(mainDao.getDayTestingCnt(mainVo));
    /*한타 시험중 수*/
    mainVo.setType("H");
    newMain.setTestingHK(mainDao.getDayTestingCnt(mainVo));
    /*외부 시험중 수*/
    mainVo.setType("B");
    newMain.setTestingB2B(mainDao.getDayTestingCnt(mainVo));
    /*당일 부대시설 수*/
    newMain.setDayShop(mainDao.getDayShopCnt(mainVo));

    return newMain;
  }

  public MainVo getWeather() {
    return mainDao.getWeather();
  }

  public MainVo getRoadTemp() {
    return mainDao.getRoadTemp();
  }

  public JSONObject apiTest() throws IOException {
    StringBuilder builder = new StringBuilder(
        "http://apis.data.go.kr/1360000/VilageFcstMsgService/getLandFcst");
    builder.append("?" + URLEncoder.encode("serviceKey", "UTF-8")
        + "=zTShMTtvBbZ1k0arMxDd0Nr%2Beh2YOBkXiHO2rRblFTQx4UnjnZcM%2FIN3avDYZZvyAk9VUrbKVU%2F0Z6oMIgLgqQ%3D%3D"); /*Service Key*/
    builder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder
        .encode("1", "UTF-8")); /*페이지번호*/
    builder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder
        .encode("10", "UTF-8")); /*한 페이지 결과 수*/
    builder.append("&" + URLEncoder.encode("dataType", "UTF-8") + "=" + URLEncoder
        .encode("JSON", "UTF-8")); /*요청자료형식(XML/JSON) Default: XML*/
    builder.append(
        "&" + URLEncoder.encode("regId", "UTF-8") + "=" + URLEncoder.encode("11C20102", "UTF-8"));

    URL url = new URL(builder.toString());
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");
    conn.setRequestProperty("Content-type", "application/json");
    System.out.println("Response code: " + conn.getResponseCode());
    BufferedReader rd;
    if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
      rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    } else {
      rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
    }

    StringBuilder sb = new StringBuilder();
    String line;
    while ((line = rd.readLine()) != null) {
      sb.append(line);
    }
    rd.close();
    conn.disconnect();
    String weather = sb.toString();
    System.out.println(weather);

    JSONParser parser = new JSONParser();
    JSONObject result = new JSONObject();
    try {
      JSONObject obj = (JSONObject) parser.parse(weather);

      JSONObject parse_response = (JSONObject) obj.get("response");
      JSONObject parse_body = (JSONObject) parse_response.get("body");
      JSONObject parse_items = (JSONObject) parse_body.get("items");

      JSONArray parse_item = (JSONArray) parse_items.get("item");
      result = (JSONObject) parse_item.get(0);
      System.out.println(result);

    } catch (Exception e) {
      apiTest();
    }

    return result;
  }

}
