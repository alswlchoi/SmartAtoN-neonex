package com.hankook.pg.common.util;

import com.google.gson.JsonElement;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

public class HttpUtil {

    public static String callApi(JsonElement params, String type,String sendUrl){
    	System.out.println("params = "+params);
    	System.out.println("type = "+type);
    	System.out.println("sendUrl = "+sendUrl);
        HttpURLConnection conn = null;
//        JSONObject responseJson = null;
        String str = "";

        try {
            //URL 설정
            URL url = new URL(sendUrl);

            conn = (HttpURLConnection) url.openConnection();

            // type의 경우 POST, GET, PUT, DELETE 가능
            conn.setRequestMethod(type);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Transfer-Encoding", "chunked");
            conn.setRequestProperty("Connection", "keep-alive");
            conn.setDoOutput(true);


            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));

            bw.write(params.toString());
            bw.flush();
            bw.close();

            // 보내고 결과값 받기
            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                 BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder sb = new StringBuilder();
                String line = "";
                while ((line = br.readLine()) != null) {
                    sb.append(line);
                }
                System.out.println(sb.toString());
                str = sb.toString();

                // 응답 데이터
                System.out.println("responseJson :: " + str);
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("not JSON Format response");
            e.printStackTrace();
        }
        return str;
    }
}
