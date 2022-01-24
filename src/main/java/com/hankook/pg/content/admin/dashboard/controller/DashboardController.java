package com.hankook.pg.content.admin.dashboard.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.tomcat.util.json.JSONParser;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.hankook.pg.content.admin.dashboard.service.DashboardService;
import com.hankook.pg.content.admin.dashboard.vo.DashboardVo;
import com.hankook.pg.content.admin.statistics.dto.StatisticsVo;
import com.hankook.pg.content.auth.vo.AuthVO;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Search;


@RestController
@RequestMapping("/admin/dashboard")
public class DashboardController {
	@Autowired
	private DashboardService dashboardService;

	@RequestMapping(value="",method= {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView dashboard() throws Exception {
		ModelAndView mv = new ModelAndView("/admin/dashboard/dashboard");
		return mv;
	}

	@PostMapping("/search")
	public Map<String, Object> searchDashboard(@RequestBody DashboardVo dashboardVo) throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		List<DashboardVo> list = dashboardService.getSearch();
		result.put("list", list);
		return result;
	}
	@PostMapping("/capaSearch")
	public Map<String, Object> capaSearch(@RequestBody DashboardVo dashboardVo) throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		List<DashboardVo> list = dashboardService.capaSearch();
		result.put("list", list);
		return result;
	}

	//공공데이터 사용 https://www.data.go.kr/iim/api/selectAPIAcountView.do
	//참고 http://datasvc.nmsc.kma.go.kr/datasvc/html/base/cmm/selectPage.do?page=static.openApi2
	@PostMapping("/cloud")
	public Map<String, Object> test() throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		SimpleDateFormat format1 = new SimpleDateFormat ( "yyyyMMdd");
		Date today = new Date();
		String time = format1.format(today);

		//기상청13_위성영상_조회서비스_오픈API활용가이드v2.docx
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1360000/SatlitImgInfoService/getInsightSatlit"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=VMR4sFjdZ2i8LhE%2BpuO3lEq9JnLsKlE40YmeJ%2FPp6EIz5WXbH%2FW%2Bg7vyJ12yBVDC%2FBZii1UV0e50RuzGYneXwA%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호 Default: 1*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode("JSON", "UTF-8")); /*요청자료형식(XML/JSON) Default: XML*/
        urlBuilder.append("&" + URLEncoder.encode("sat","UTF-8") + "=" + URLEncoder.encode("G2", "UTF-8")); /*위성구분 -G2: 천리안위성 2A호*/
        urlBuilder.append("&" + URLEncoder.encode("data","UTF-8") + "=" + URLEncoder.encode("ir105", "UTF-8")); /*영상구분 -적외영상(ir105) -가시영상(vi006) -수증기영상(wv069) -단파적외영상(sw038) -RGB 컬러(rgbt) -RGB 주야간합성(rgbdn)*/
        urlBuilder.append("&" + URLEncoder.encode("area","UTF-8") + "=" + URLEncoder.encode("ko", "UTF-8")); /*지역구분 -전구(fd) -동아시아(ea) -한반도(ko)*/
        urlBuilder.append("&" + URLEncoder.encode("time","UTF-8") + "=" + URLEncoder.encode(time, "UTF-8")); /*년월일(YYYYMMDD)*/
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
//        System.out.println("Response code: " + conn.getResponseCode());
        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
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

        JSONObject data = new JSONObject(sb.toString());
//        System.out.println("data"+data.toString());

        JSONObject response = data.getJSONObject("response");
//        System.out.println("response"+response.toString());

        JSONObject body = response.getJSONObject("body");
//        System.out.println("body"+body.toString());

        JSONObject items = body.getJSONObject("items");
//        System.out.println("items"+items.toString());

        JSONArray item = items.getJSONArray("item");
//        System.out.println("array"+item.toString());

        JSONObject files= item.getJSONObject(0);
//        System.out.println("files"+files.toString());

        String file1 = files.toString().split("\\[")[1];
        String file2 = file1.split("\\]")[0];
        String[] file = file2.split(", ");
        result.put("sb", sb.toString());
        result.put("files", files.toString());
        result.put("file", file);
        return result;
	}

	//웹 크롤링 사용 https://www.weatheri.co.kr/satellite/satellite01.php
	@PostMapping("/radar")
	public Map<String, Object> test2() throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		//기상청13_위성영상_조회서비스_오픈API활용가이드v2.docx
		StringBuilder urlBuilder = new StringBuilder("https://www.weatheri.co.kr/satellite/satellite01.php"); /*URL*/
		URL url = new URL(urlBuilder.toString());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
//		System.out.println("Response code: " + conn.getResponseCode());
		BufferedReader rd;
		if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
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

//		System.out.println(sb.toString());
		result.put("sbStr", sb.toString());
		String str1 = sb.toString().split("target=\"radar\"><img src=\\\"")[1];
		String str2 = str1.split("\" width=")[0];
		result.put("sb", str2);
		return result;
	}

	@PostMapping("/roadTemp")
	public Map<String, Object> roadTemp() throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		List<StatisticsVo> list = dashboardService.getRoadTemp();
		result.put("list", list);
		return result;
	}
}
