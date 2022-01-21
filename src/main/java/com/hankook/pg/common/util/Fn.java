package com.hankook.pg.common.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class Fn {

	private static String DEFAULT_ENCODING = "UTF-8";
	
	/*********************(형변환 : to)****************************/
	/*************************************************************
     * String -> int
     * @since 1.0
     
     *************************************************************/
	public static int toInt(String value){
		int to_int = 0;
		if(value!=null && value.length()>0){
			try{
				to_int = Integer.parseInt(replaceAll(value, ",", ""));
			}catch(NumberFormatException e){
				to_int = 0;
			}catch(Exception e){
				to_int = 0;
			}	
		}		
		return to_int;
	}
	/*************************************************************
     * Object -> int
     * @since 1.0
     
     *************************************************************/
	public static int toInt(Object value){
		return toInt(toString(value));
	}
	
	/*************************************************************
     * String[] -> int[]
     * @since 1.0
     
     *************************************************************/
	public static int[] toIntArray(String[] value_array){
		int[] revalue_array = null;
		if(value_array!=null && value_array.length>0){
			revalue_array = new int[value_array.length];
			for(int i=0; i<value_array.length; i++){
				revalue_array[i] = toInt(value_array[i]);
			}
		}else{
			revalue_array = new int[]{0};
		}
		return revalue_array;
	}
	/*************************************************************
     * String[], array_size -> int[]
     * @since 1.0
     
     *************************************************************/
	public static int[] toIntArray(String[] value_array,int array_size){
		int[] revalue_array = new int[array_size];		
		if(value_array!=null && value_array.length>0){
			for(int i=0; i<value_array.length; i++){
				if(array_size>i){
					revalue_array[i] = toInt(value_array[i]);
				}
			}			
		}else{
			revalue_array = new int[]{0};
		}
		
		
		return revalue_array;
	}
	/*************************************************************
     * Object[] -> int[]
     * @since 1.0
     
     *************************************************************/
	public static int[] toIntArray(Object[] value_array){
		int[] revalue_array = null;
		if(value_array!=null && value_array.length>0){
			revalue_array = new int[value_array.length];
			for(int i=0; i<value_array.length; i++){
				revalue_array[i] = toInt(value_array[i]);
			}
		}else{
			revalue_array = new int[]{0};
		}
		return revalue_array;
	}
	
	/*************************************************************
     * String - > int, 0이면 revalue 값 리턴
     * @since 1.0
     
     *************************************************************/
	public static int toInt(String value, int revalue){
		int temp = toInt(value);
    	return temp!=0?temp:revalue;
    }
	
	/*************************************************************
     * Integer - > int, 0이면 revalue 값 리턴
     * @since 1.0
     
     *************************************************************/	
	public static int toInt(Integer value, int revalue){
		return toInt(value+"", revalue);
    }
	
	/*************************************************************
     * Request, value = > int
     * @since 1.0
     
     *************************************************************/
	public static int toInt(HttpServletRequest request, String value){
		if(request==null || value==null){
			return 0;
		}else{
			return toInt(request.getParameter(value));			
		}
	}

	/*************************************************************
     * Request, value, revalue = > int
     * @since 1.0
     
     *************************************************************/
	public static int toInt(HttpServletRequest request, String value, int revalue){
		if(request==null || value==null){
			return 0;
		}else{
			return toInt(request.getParameter(value), revalue);
		}
	}

	/*************************************************************
     * Request, value, revalue = >  int
     * @since 1.0
     
     *************************************************************/
	public static int toInt(HttpServletRequest request, String value, String revalue, String chkvalue_str){
		return toInt(toString(request, value, revalue, chkvalue_str));
	}

	/*************************************************************
     * Session, value = > int
     * @since 1.0
     
     *************************************************************/
	public static int toInt(HttpSession session, String value){
		if(session==null || value==null){
			return 0;
		}else{
			return toInt(session.getAttribute(value)+"");
		}
	}
	/*************************************************************
     * Session, value, revalue = > int
     * @since 1.0
     
     *************************************************************/
	public static int toInt(HttpSession session, String value, int revalue){
		if(session==null || value==null){
			return 0;
		}else{
			return toInt(session.getAttribute(value)+"", revalue);
		}
	}
	
	/*************************************************************
     * Session, value, revalue = >  int
     * @since 1.0
     
     *************************************************************/
	public static int toInt(HttpSession session, String value, String revalue, String chkvalue_str){
		return toInt(toString(session, value, revalue, chkvalue_str));
	}
	
	
	/*************************************************************
     * Map<String,Object>, value = > int
     * @since 1.0
     
     *************************************************************/
	public static int toInt(Map<String,Object> map, String value){
		return map==null || value==null ? 0 : toInt(map.get(value)+"");
	}
	/*************************************************************
     * Map<String,Object>, value, revalue = > int
     * @since 1.0
     
     *************************************************************/
	public static int toInt(Map<String,Object> map, String value, int revalue){
		return map==null || value==null ? 0 : toInt(map.get(value)+"", revalue);
	}	
	public static int toInt(Map<String,Object> map, String value, String revalue, String chkvalue_str){
		return toInt(toString(map, value, revalue, chkvalue_str));
	}
	public static int toInt(Map<String,Object> map, String value, int revalue, String chkvalue_str){
		return toInt(toString(map, value, revalue+"", chkvalue_str));
	}

	
	/*************************************************************
     * String -> double
     * @since 1.0
     
     *************************************************************/
	public static double toDouble(String value){
		double to_double = 0;
		if(value!=null && value.length()>0){
			try{
				to_double = Double.parseDouble(replaceAll(value, ",", ""));
			}catch(NumberFormatException e){
				to_double = 0;
			}catch(Exception e){
				to_double = 0;
			}
		}
		return to_double;
	}
	/*************************************************************
     * Object -> double
     * @since 1.0
     
     *************************************************************/
	public static double toDouble(Object value){
		return toDouble(value+"");
	}
	/*************************************************************
     * String - > double, 0이면 revalue 값 리턴
     * @since 1.0
     
     *************************************************************/
	public static double toDouble(String value, double revalue){
		double temp = toDouble(value);
    	return temp!=0?temp:revalue;
    }
	
	/*************************************************************
     * Request, value = >  double
     * @since 1.0
     
     *************************************************************/
	public static double toDouble(HttpServletRequest request, String value){
		if(request==null || value==null){
			return 0;
		}else{
			return toDouble(request.getParameter(value));
		}
	}

	/*************************************************************
     * Request, value, revalue = >  double
     * @since 1.0
     
     *************************************************************/
	public static double toDouble(HttpServletRequest request, String value, double revalue){
		if(request==null || value==null){
			return 0;
		}else{
			return toDouble(request.getParameter(value), revalue);
		}
	}
	
	
	/*************************************************************
     * HttpSession, value = >  double
     * @since 1.0
     
     *************************************************************/
	public static double toDouble(HttpSession session, String value){
		if(session==null || value==null){
			return 0;
		}else{
			return toDouble(session.getAttribute(value));
		}
	}

	/*************************************************************
     * HttpSession, value, revalue = >  double
     * @since 1.0
     
     *************************************************************/
	public static double toDouble(HttpSession session, String value, double revalue){
		if(session==null || value==null){
			return 0;
		}else{
			return toDouble((String)session.getAttribute(value), revalue);
		}		
	}
	
	/*************************************************************
     * Map<String,Object>, value = >  double
     * @since 1.0
     
     *************************************************************/
	public static double toDouble(Map<String,Object> map, String value){
		return map==null || value==null ? 0 : toDouble(map.get(value));
	}

	/*************************************************************
     * Map<String,Object>, value, revalue = >  double
     * @since 1.0
     
     *************************************************************/
	public static double toDouble(Map<String,Object> map, String value, double revalue){
		return map==null || value==null ? revalue : toDouble((String)map.get(value), revalue);
	}

	
	/*************************************************************
     * number => Hangle
     * @since 1.0
     
     *************************************************************/
	public static String toHangle(String str){
		  String result="";
		  if(str!=null){
			  try{
				  	String[] dan1 = new String[]{"","만 ","억 ","조 ","경 ","해 ","시 ","양 ","구 ","간 ","정 " };
				  	String[] dan2 = new String[]{"","십","백","천" };
				  	String[] han = new String[]{"","일","이","삼","사","오","육","칠","팔","구"};
				  	int temp;
				  	int chk;
				   
				   for(int i=str.length()-1,i2=0;i>=0;i--,i2++){ 
					   	temp= Integer.parseInt(str.charAt(i)+"");			        
					   	chk = i2%4 == 0?i2/4:0;
					   	result =  temp==1 && i2>0 && chk==0?"":han[temp] + (temp==0?"":dan2[i2%4]) + dan1[chk] + result ;
				   } 
			  }catch(NumberFormatException e){
				  result="";
			  }catch(Exception e){
				  result="";
			  }
		  }
		  return result;
	}
	public static String toHangle(int str){
		  return toHangle(str+"");
	}
	public static String toHangle(double str){
		  return toHangle(decimal(str, "#"));
	}
	
	
	/*************************************************************
     * String - > null, 공백 채크
     * @since 1.0
     
     *************************************************************/
	public static String toString(String value){
		return value==null || value.trim().equals("") || value.equals("null")? "" : value;
	}
	public static String toStringHtml(String value){
		return htmlSpecialChars(toString(value));
	}
	public static String toStringYmd(String value){
		String cfinput = "";
		try{
			cfinput = new SimpleDateFormat("yyyy-MM-dd").format(Timestamp.valueOf(value + " 00:00:00"));
		}catch(NullPointerException npe){
			cfinput="";
		}catch(IllegalArgumentException iae){
			cfinput="";		
    	}catch(Exception e){
    		cfinput="";
    	}
		return toString(value).equals(cfinput)&&cfinput.length()>0 ? toString(value) : "";
	}

	/*************************************************************
     * Object - > String
     * @since 1.0
     
     *************************************************************/
	public static String toString(Object value){
		return toString(value+"");
	}
	public static String toStringHtml(Object value){
		return htmlSpecialChars(toString(value));
	}
	public static String toStringYmd(Object value){
		return toStringYmd(toString(value));
	}
	/*************************************************************
     * String - > null, 공백시 revalue 값 리턴
     * @since 1.0
     
     *************************************************************/
	public static String toString(String value, String revalue){
    	return toString(value).length()>0?value:revalue;
    }
	public static String toStringHtml(String value, String revalue){
    	return htmlSpecialChars(toString(value, revalue));
    }
	public static String toStringYmd(String value, String revalue){
		return toString(toStringYmd(value), revalue);
	}

	/*************************************************************
     * Object - > null, 공백시 revalue 값 리턴
     * @since 1.0
     
     *************************************************************/
	public static String toString(Object value, Object revalue){
		String value_str = toString(value+"");
		return value_str.length()>0?value_str:toString(revalue);
	}
	public static String toStringHtml(Object value, Object revalue){
		return htmlSpecialChars(toString(value, revalue));
	}
	public static String toStringYmd(Object value, Object revalue){
		return toString(toStringYmd(value), revalue);
	}
	/*************************************************************
     * Request, value = >  String
     * @since 1.0
     
     *************************************************************/
	public static String toString(HttpServletRequest request, String value){
		//return toStringMethodDivChange(request, toString(request.getParameter(value)));
		return toStringMethodDivChange(request, toParamValuesAddSymbolStr(request, value, ","));
	}
	public static String toStringHtml(HttpServletRequest request, String value){
		return htmlSpecialChars(toString(request, value));
	}
	public static String toStringYmd(HttpServletRequest request, String value){
		return toStringYmd(toString(request, value));
	}
	
	
	
	/*************************************************************
     * Request, multipart/form-data GET POST encoding
     * @since 1.0
     
     *************************************************************/
	private static String toStringMethodDivChange(HttpServletRequest request, String value){
		if(request==null || value==null){
			return "";
		}else{
			return toStringMethodDivChange(request.getContentType(), request.getMethod(), value);
		}
	}
	private static String toStringMethodDivChange(String content_type, String form_type, String value){
		if(toString(content_type).indexOf("multipart/form-data")>-1){ 	// multipart/form-data
			//return toKor(toString(value));	// Dev
			return toString(value);			// Dev
		}else if("GET".equals(form_type)){								// GET
			return toString(value);			// Dev
		}else{															// POST
			return toString(value);			// Dev
		}
	}
	
	/*************************************************************
     * Request, value, revalue = >  String
     * @since 1.0
     
     *************************************************************/
	public static String toString(HttpServletRequest request, String value, String revalue){
		return toString(toString(request, value), revalue);
	}
	public static String toStringHtml(HttpServletRequest request, String value, String revalue){
		return htmlSpecialChars(toString(request, value, revalue));
	}
	public static String toStringYmd(HttpServletRequest request, String value, String revalue){
		return toString(toStringYmd(toString(request, value)), revalue);
	}
	
	
	/*************************************************************
     * Request, value, revalue, chkvalue_str = >  String
     * @since 1.0
     
     *************************************************************/
	public static String toString(HttpServletRequest request, String value, String revalue, String chkvalue_str){
		String param_value = toString(request, value);
		return isEqualValue(chkvalue_str, ",", param_value) ? param_value : revalue;
	}
	public static String toStringHtml(HttpServletRequest request, String value, String revalue, String chkvalue_str){
		return htmlSpecialChars(toString(request, value, revalue, chkvalue_str));
	}
	public static String toStringYmdBetween(HttpServletRequest request, String value, String revalue, String schkvalue, String echkvalue){
		String ymd = toStringYmd(request, value);
		boolean chk = ymd.compareTo(toStringYmd(schkvalue))>=0 && ymd.compareTo(toStringYmd(echkvalue))<=0;
		return chk ? ymd : revalue;
	}

	/*************************************************************
     * Session, value = >  String
     * @since 1.0
     
     *************************************************************/
	public static String toString(HttpSession session, String value){
		if(session==null || value==null){
			return "";
		}else{
			return toString((String)session.getAttribute(value));
		}
	}
	public static String toStringHtml(HttpSession session, String value){
		return htmlSpecialChars(toString(session, value));
	}
	public static String toStringYmd(HttpSession session, String value){
		return toStringYmd(toString(session, value));
	}

	/*************************************************************
     * Map<String,Object>, value = >  String
     * @since 1.0
     
     *************************************************************/
	public static String toString(Map<String,Object> map, String value){
		return map==null || value==null ? "" : toParamValuesAddSymbolStr(map, value, ",");	
	}
	public static String toStringHtml(Map<String,Object> map, String value){
		return htmlSpecialChars(toString(map, value));
	}
	
	public static String toStringYmd(Map<String,Object> map, String value){
		return toStringYmd(toString(map, value));
	}
	public static String toStringYmd(Map<String,Object> map, String value, String revalue){
		return toStringYmd(toString(map, value), revalue);
	}
	
	
	/*************************************************************
     * Session, value, revalue = >  String
     * @since 1.0
     
     *************************************************************/	
	public static String toString(HttpSession session, String value, String revalue){
		if(session==null || value==null){
			return "";
		}else{
			return toString((String)session.getAttribute(value), revalue);
		}
	}
	public static String toStringHtml(HttpSession session, String value, String revalue){
		return htmlSpecialChars(toString(session, value, revalue));
	}
	public static String toStringYmd(HttpSession session, String value, String revalue){
		return toString(toStringYmd(toString(session, value)), revalue);
	}
	
	/*************************************************************
     * Session, value, revalue, chkvalue_str = >  String
     * @since 1.0
     
     *************************************************************/
	public static String toString(HttpSession session, String value, String revalue, String chkvalue_str){
		String param_value = toString(session, value);
		return isEqualValue(chkvalue_str, ",", param_value) ? param_value : revalue;
	}
	public static String toStringHtml(HttpSession session, String value, String revalue, String chkvalue_str){
		return htmlSpecialChars(toString(session, value, revalue, chkvalue_str));
	}
	public static String toStringYmdBetween(HttpSession session, String value, String revalue, String schkvalue, String echkvalue){
		String ymd = toStringYmd(session, value);
		boolean chk = ymd.compareTo(toStringYmd(schkvalue))>=0 && ymd.compareTo(toStringYmd(echkvalue))<=0;
		return chk ? ymd : revalue;
	}

	/*************************************************************
     * Map<String,Object>, value, revalue = >  String
     * @since 1.0
     
     *************************************************************/	
	public static String toString(Map<String,Object> map, String value, String revalue){
		return map==null || value==null ? "" : toString((String)map.get(value), revalue);
	}
	public static String toStringHtml(Map<String,Object> map, String value, String revalue){
		return htmlSpecialChars(toString(map, value, revalue));
	}	
	public static String toString(Map<String,Object> map, String value, String revalue, String chkvalue_str){
		String param_value = toString(map, value);
		return isEqualValue(chkvalue_str, ",", param_value) ? param_value : revalue;
	}	
	public static String toStringHtml(Map<String,Object> map, String value, String revalue, String chkvalue_str){
		return htmlSpecialChars(toString(map, value, revalue, chkvalue_str));
	}


	/*************************************************************
     *  HashMap > String
     * @since 1.0
     
     *************************************************************/	
	public static String toStringStr(HashMap<String,String> hashmap, String key_str, String key_symbol, String value_symbol){
		if(hashmap==null || key_str==null || key_symbol==null || value_symbol==null){
			return "";
		}else{
			StringBuffer str_buff = new StringBuffer();
			String[] key_array = toStr_array(key_str, key_symbol);
			for(String key : key_array){
				if(key.length()>0){
					String value = toString(hashmap.get(key));
					if(value.length()>0){
						str_buff.append(value + value_symbol);
					}
				}
			}		
			if(str_buff.toString().length()>0){
				str_buff.append(value_symbol);
				return replaceAll(str_buff.toString(), value_symbol+value_symbol, "");
			}else{
				return "";
			}
		}
	}
	/*************************************************************
     *  String[] > String
     * @since 1.0
     
     *************************************************************/	
	public static String toStringStr(String[] value_array, String value_symbol){
		if(value_array==null || value_symbol==null){
			return "";
		}else{
			StringBuffer str_buff = new StringBuffer();
			for(String value : value_array){
				if(value!=null && value.length()>0){
					str_buff.append(value + value_symbol);
				}
			}		
			str_buff.append(value_symbol);
			String return_str = replaceAll(str_buff.toString(), value_symbol+value_symbol, "");
			if(return_str.equals(value_symbol)){
				return_str = "";
			}
			return return_str;
		}
	}
	/*************************************************************
     *  List<String> String
     * @since 1.0
     
     *************************************************************/	
	public static String toStringStr(List<String> value_list, String value_symbol){
		if(value_list==null || value_symbol==null){
			return "";
		}else{
			StringBuffer str_buff = new StringBuffer();
			for(String value : value_list){
				if(value!=null && value.length()>0){
					str_buff.append(value + value_symbol);
				}
			}		
			str_buff.append(value_symbol);
			return replaceAll(str_buff.toString(), value_symbol+value_symbol, "");
		}
	}
	

	/*************************************************************
     * 문자열 추가
     * @since 1.0
     
     *************************************************************/	
	public static String toStrAdd(String org_str, String add_str){
		return toStrAdd(org_str, add_str, ",");
	}
	public static String toStrAdd(String org_str, String add_str, String add_symbol){
		String new_str = "";
		if(org_str!=null && add_str!=null && add_symbol!=null ){	
			String[] org_arr = toStr_array(org_str, add_symbol);
			List<String> strList = new ArrayList<String>();
			for(String org : org_arr){
				if(org.length()>0 && !org.equals(add_str)){
					strList.add(org);
				}
			}
			strList.add(add_str);
			if(strList.size()>0){
				for(int i=0; i<strList.size(); i++){
					new_str += strList.get(i);
					if(i<strList.size()-1){
						new_str += add_symbol;
					}
				}			
			}
		}
		return new_str;
	}
	
	/*************************************************************
     * 문자열 빼기
     * @since 1.0
     
     *************************************************************/	
	public static String toStrSub(String org_str, String sub_str){
		return toStrSub(org_str, sub_str, ",");
	}
	public static String toStrSub(String org_str, String sub_str, String add_symbol){		
		String new_str = "";	
		if(org_str!=null && sub_str!=null && add_symbol!=null ){	
			String[] org_arr = toStr_array(org_str, add_symbol);
			List<String> strList = new ArrayList<String>();
			for(String org : org_arr){
				if(org.length()>0 && !org.equals(sub_str)){
					strList.add(org);
				}
			}
			if(strList.size()>0){
				for(int i=0; i<strList.size(); i++){
					new_str += strList.get(i);
					if(i<strList.size()-1){
						new_str += add_symbol;
					}
				}			
			}
		}
		return new_str;	
	}
	
	
	
	/*************************************************************
     * value, revalue = >  HashMap<String,String>
     * @since 1.0
     
     *************************************************************/
	@SuppressWarnings("unchecked")
	public static HashMap<String,String> toHashMapStringString(Object value){
		HashMap<String,String> tohash = new HashMap<String,String>();
		if(value != null){
			tohash = (HashMap<String,String>)value;
		}
		return tohash;
	}
	@SuppressWarnings("unchecked")
	public static HashMap<String,String> toHashMapStringString(Object value, Object revalue){
		HashMap<String,String> tohash = new HashMap<String,String>();
		if(value == null){
			tohash = (HashMap<String,String>)revalue;
		}else{
			tohash = (HashMap<String,String>)value;
		}
		return tohash;
	}
	@SuppressWarnings("unchecked")
	public static HashMap<String,String> toHashMapStringString(Object value, HashMap<String,String> revalue){
		HashMap<String,String> tohash = new HashMap<String,String>();
		if(value == null){
			tohash = revalue;
		}else{
			tohash = (HashMap<String,String>)value;
		}
		return tohash;
	}
	public static HashMap<String,String> toHashMapStringString(HashMap<String,String> value, HashMap<String,String> revalue){
		if(value == null){
			return revalue;
		}else{
			return value;
		}		
	}
	
	/*************************************************************
     * value, revalue = >  HashMap<String,Integer>
     * @since 1.0
     
     *************************************************************/
	@SuppressWarnings("unchecked")
	public static HashMap<String,Integer> toHashMapStringInteger(Object value){
		HashMap<String,Integer> tohash = new HashMap<String,Integer>();
		if(value != null){
			tohash = (HashMap<String,Integer>)value;
		}
		return tohash;
	}
	@SuppressWarnings("unchecked")
	public static HashMap<String,Integer> toHashMapStringInteger(Object value, Object revalue){
		HashMap<String,Integer> tohash = new HashMap<String,Integer>();
		if(value == null){
			tohash = (HashMap<String,Integer>)revalue;
		}else{
			tohash = (HashMap<String,Integer>)value;
		}
		return tohash;
	}
	@SuppressWarnings("unchecked")
	public static HashMap<String,Integer> toHashMapStringInteger(Object value, HashMap<String,Integer> revalue){
		HashMap<String,Integer> tohash = new HashMap<String,Integer>();
		if(value == null){
			tohash = revalue;
		}else{
			tohash = (HashMap<String,Integer>)value;
		}
		return tohash;
	}
	public static HashMap<String,Integer> toHashMapStringInteger(HashMap<String,Integer> value, HashMap<String,Integer> revalue){
		if(value == null){
			return revalue;
		}else{
			return value;
		}		
	}
	
	/*************************************************************
     * value, revalue = >  HashMap<String,Double>
     * @since 1.0
     
     *************************************************************/
	@SuppressWarnings("unchecked")
	public static HashMap<String,Double> toHashMapStringDouble(Object value){
		HashMap<String,Double> tohash = new HashMap<String,Double>();
		if(value != null){
			tohash = (HashMap<String,Double>)value;
		}
		return tohash;
	}
	@SuppressWarnings("unchecked")
	public static HashMap<String,Double> toHashMapStringDouble(Object value, Object revalue){
		HashMap<String,Double> tohash = new HashMap<String,Double>();
		if(value == null){
			tohash = (HashMap<String,Double>)revalue;
		}else{
			tohash = (HashMap<String,Double>)value;
		}
		return tohash;
	}
	@SuppressWarnings("unchecked")
	public static HashMap<String,Double> toHashMapStringDouble(Object value, HashMap<String,Double> revalue){
		HashMap<String,Double> tohash = new HashMap<String,Double>();
		if(value == null){
			tohash = revalue;
		}else{
			tohash = (HashMap<String,Double>)value;
		}
		return tohash;
	}
	public static HashMap<String,Double> toHashMapStringDouble(HashMap<String,Double> value, HashMap<String,Double> revalue){
		if(value == null){
			return revalue;
		}else{
			return value;
		}		
	}
	
	
	/*************************************************************
     * value, revalue = >  HashMap<String,Object>
     * @since 1.0
     
     *************************************************************/
	@SuppressWarnings("unchecked")
	public static HashMap<String,Object> toHashMapStringObject(Object value){
		HashMap<String,Object> tohash = new HashMap<String,Object>();
		if(value != null){
			tohash = (HashMap<String,Object>)value;
		}
		return tohash;
	}
	@SuppressWarnings("unchecked")
	public static HashMap<String,Object> toHashMapStringObject(Object value, Object revalue){
		HashMap<String,Object> tohash = new HashMap<String,Object>();
		if(value == null){
			tohash = (HashMap<String,Object>)revalue;
		}else{
			tohash = (HashMap<String,Object>)value;
		}
		return tohash;
	}
	@SuppressWarnings("unchecked")
	public static HashMap<String,Object> toHashMapStringObject(Object value, HashMap<String,Object> revalue){
		HashMap<String,Object> tohash = new HashMap<String,Object>();
		if(value == null){
			tohash = revalue;
		}else{
			tohash = (HashMap<String,Object>)value;
		}
		return tohash;
	}
	public static HashMap<String,Object> toHashMapStringObject(HashMap<String,Object> value, HashMap<String,Object> revalue){
		if(value == null){
			return revalue;
		}else{
			return value;
		}		
	}
	
	/*************************************************************
	 * Request, addsymbol, names = >  String
	 * @since 1.0
	 
	 *************************************************************/	
	public static String toParamStr(HttpServletRequest request, String addSymbol, String names){
		return toParamStr(request, addSymbol, names, "&");
	}
	public static String toParamStrHtml(HttpServletRequest request, String addSymbol, String names){
		return htmlSpecialChars(toParamStr(request, addSymbol, names));
	}
	public static String toParamStr(HttpServletRequest request, String addSymbol, String names, String start_symbol){
		if(request==null || addSymbol==null || names==null || start_symbol==null){
			return "";
		}else{
			String[] name_array = names.split(",");	
			StringBuffer param = new StringBuffer();
			for(int i=0; i<name_array.length; i++){
				param.append(toString(request, name_array[i]).equals("")?"":addSymbol+name_array[i]+"="+encode(toString(request, name_array[i])));
			}
			if(!param.toString().isEmpty()){
				return start_symbol + param.toString().substring(1);
			}else{
				return "";
			}
		}	
	}
	public static String toParamStrHtml(HttpServletRequest request, String addSymbol, String names, String start_symbol){
		return htmlSpecialChars(toParamStr(request, addSymbol, names, start_symbol));
	}
	
	/*************************************************************
	 * Map<String,Object>, addsymbol, names = >  String
	 * @since 1.0
	 
	 *************************************************************/	
	public static String toParamStr(Map<String,Object> map, String addSymbol, String names){
		return toParamStr(map, addSymbol, names, "&");
	}
	public static String toParamStrHtml(Map<String,Object> map, String addSymbol, String names){
		return htmlSpecialChars(toParamStr(map, addSymbol, names));
	}
	public static String toParamStr(Map<String,Object> map, String addSymbol, String names, String start_symbol){
		if(map==null || addSymbol==null || names==null || start_symbol==null){
			return "";
		}else{
			String[] name_array = names.split(",");	
			StringBuffer param = new StringBuffer();
			for(int i=0; i<name_array.length; i++){
				param.append(toString(map, name_array[i]).equals("")?"":addSymbol+name_array[i]+"="+encode(toString(map, name_array[i])));
			}
			if(!param.toString().isEmpty()){
				return start_symbol + param.toString().substring(1);
			}else{
				return "";
			}
		}
	}
	public static String toParamStrHtml(Map<String,Object> map, String addSymbol, String names, String start_symbol){
		return htmlSpecialChars(toParamStr(map, addSymbol, names, start_symbol));
	}

	
		
	/*************************************************************
	 * Request, names = >  String
	 * @since 1.0
	 
	 *************************************************************/	
	public static String toParamHidden(HttpServletRequest request, String names){
		if(request==null || names==null){
			return "";
		}else{
			String[] param_array = names.split(",");
			StringBuffer hidden = new StringBuffer();
			for(int i=0; i<param_array.length; i++){
				if(toString(request,param_array[i]).length()>0){ 
					hidden.append("<input type=\"hidden\" name=\""+param_array[i]+"\" value=\""+htmlSpecialChars(toString(request,param_array[i]))+"\" />");
				}
			} 
			return hidden.toString();			
		}
	}
	/*************************************************************
	 * Map<String,Object>, names = >  String
	 * @since 1.0
	 
	 *************************************************************/	
	public static String toParamHidden(Map<String,Object> map, String names){
		if(map==null || names==null){
			return "";
		}else{
			String[] param_array = names.split(",");		
			StringBuffer hidden = new StringBuffer();
			for(int i=0; i<param_array.length; i++){
				if(toString(map,param_array[i]).length()>0){ 
					hidden.append("<input type=\"hidden\" name=\""+param_array[i]+"\" value=\""+htmlSpecialChars(toString(map,param_array[i]))+"\" />");
				}
			} 
			return hidden.toString();		
		}
	}
	
	
	/*************************************************************
	 * HttpServletRequest, exculde_param_names = >  String
	 * @since 1.0
	 
	 *************************************************************/	
	public static String toParamAllHidden(HttpServletRequest request, String exclude_param){
		if(request==null || exclude_param==null){
			return "";
		}else{
			StringBuffer hidden = new StringBuffer();
			@SuppressWarnings("rawtypes")
			Enumeration paramNames = request.getParameterNames();
			while(paramNames.hasMoreElements()){
				String param_nm = paramNames.nextElement().toString();
				if(!isEqualValue(exclude_param, ",", param_nm) && toString(request,param_nm).length()>0){
					hidden.append("<input type=\"hidden\" name=\""+param_nm+"\" value=\""+htmlSpecialChars(toString(request,param_nm))+"\" />\n");
				}
			}
			return hidden.toString();
		}
	}
	
	
	/*************************************************************
	 * Request, valueSymbol, names = >  String
	 * @since 1.0
	 
	 *************************************************************/	
	public static String toParamValueStr(HttpServletRequest request, String names, String valueSymbol){
		if(request==null || names==null || valueSymbol==null){
			return "";
		}else{
			String[] name_array = names.split(",");
			StringBuffer param = new StringBuffer();
			for(int i=0; i<name_array.length; i++){
				param.append(toString(request, name_array[i]).equals("")?"":encode(toString(request, name_array[i])) + valueSymbol);
			}
			return  param.toString().length()>0? param.toString().substring(0, param.toString().length()-valueSymbol.length())  : "";
		}
	}
	/*************************************************************
	 * Map<String,Object>, valueSymbol, names = >  String
	 * @since 1.0
	 
	 *************************************************************/	
	public static String toParamValueStr(Map<String,Object> map, String names, String valueSymbol){
		if(map==null || names==null || valueSymbol==null){
			return "";
		}else{
			String[] name_array = names.split(",");
	
			StringBuffer param = new StringBuffer();
			for(int i=0; i<name_array.length; i++){
				param.append(toString(map, name_array[i]).equals("")?"":encode(toString(map, name_array[i])) + valueSymbol);
			}
			return  param.toString().length()>0? param.toString().substring(0, param.toString().length()-valueSymbol.length())  : "";		
		}
	}
	

	/*************************************************************
	 * Request, names = >  tel_no ex) 032-235-8517
	 * @since 1.0
	 
	 *************************************************************/	
	public static String toParamTelNo(HttpServletRequest request, String names){
		if(request==null || names==null){
			return "";
		}else{
			String[] name_array = names.split(",");
			if(name_array.length>=3){		
				StringBuffer param = new StringBuffer();
				param.append(toParamAddSymbolStr(request, "-", name_array[0]+","+name_array[1]+","+name_array[2]));
				if(name_array.length==4){
					param.append("~" + toString(request, name_array[3]));
				}
				return param.toString();				
			}else{
				return "";
			}
		}
	}

	/*************************************************************
	 * Map<String,Object>, names = >  tel_no ex) 032-235-8517
	 * @since 1.0
	 
	 *************************************************************/	
	public static String toParamTelNo(Map<String,Object> map, String names){
		if(map==null || names==null){
			return "";
		}else{
			String[] name_array = names.split(",");
			if(name_array.length>=3){	
				StringBuffer param = new StringBuffer();
				param.append(toParamAddSymbolStr(map, "-", name_array[0]+","+name_array[1]+","+name_array[2]));
				if(name_array.length==4){
					param.append("~" + toString(map, name_array[3]));
				}
				return param.toString();			
			}else{
				return "";
			}
		}
	}
	
	
	
	/*************************************************************
	 * Request, names, symbol = >  zip_cd, email ex) 123-123, red919@nate.com
	 * @since 1.0
	 
	 *************************************************************/	
	public static String toParamAddSymbolStr(HttpServletRequest request, String symbol, String names){
		if(request==null || symbol==null || names==null){
			return "";
		}else{
			String[] name_array = names.split(",");
			if(name_array.length>1){		
				StringBuffer param = new StringBuffer();
				for(int i=0; i<name_array.length; i++){
					param.append(toString(request, name_array[i]));
					if(i<name_array.length-1){
						param.append(symbol);
					}
				}				
				return param.toString();			
			}else{
				return "";
			}
		}
	}
	
	/*************************************************************
	 * Map<String,Object>, names, symbol = >  zip_cd, email ex) 123-123, red919@nate.com
	 * @since 1.0
	 
	 *************************************************************/	
	public static String toParamAddSymbolStr(Map<String,Object> map, String symbol, String names){
		if(map==null || symbol==null || names==null){
			return "";
		}else{
			String[] name_array = names.split(",");
			if(name_array.length>1){				
				StringBuffer param = new StringBuffer();
				for(int i=0; i<name_array.length; i++){
					param.append(toString(map, name_array[i]));
					if(i<name_array.length-1){
						param.append(symbol);
					}
				}				
				return param.toString();				
			}else{
				return "";
			}
		}
	}
	
	/*************************************************************
	 * Request, addsymbol, names = >  String
	 * @since 1.0
	 
	 *************************************************************/	
	public static String toParamValuesAddSymbolStr(HttpServletRequest request, String name, String addSymbol){
		if(request==null || name==null || addSymbol==null){
			return "";
		}else{
			StringBuffer param_value_str = new StringBuffer();		
			String[] param_value_array = request.getParameterValues(name);
			String content_type = request.getContentType(); 
			String form_type = request.getMethod();
			
			if(param_value_array!=null){
				for(int i=0; i<param_value_array.length; i++){
					param_value_str.append(toStringMethodDivChange(content_type, form_type, param_value_array[i]));
					if(i < param_value_array.length-1){
						param_value_str.append(addSymbol);
					}
				}
			}			
			return param_value_str.toString();		
		}
	}
	
	public static String toParamValuesAddSymbolStr(Map<String,Object> map, String name, String addSymbol){
		if(map==null || name==null || name.length()==0 || addSymbol==null || addSymbol.length()==0){
			return "";
		}else{
			StringBuffer param_value_str = new StringBuffer();
			if(map.get(name)!=null){
				try{
					String[] param_value_array = (String[])map.get(name); 
					if(param_value_array!=null){
						for(int i=0; i<param_value_array.length; i++){
							param_value_str.append(param_value_array[i]);
							if(i < param_value_array.length-1){
								param_value_str.append(addSymbol);
							}
						}
					}					
				}catch(ClassCastException ce){
					param_value_str.append(toString(map.get(name)));
				}catch(Exception e){				
					param_value_str.append(toString(map.get(name)));
				}				
			}
			return param_value_str.toString();
		}
	}
	

	/*************************************************************
     * HttpServletReques parameterValues
     * @since 1.0
     
     *************************************************************/	
	public static String[] toParameterValues(HttpServletRequest request, String name){
		return toStr_array(toParamValuesAddSymbolStr(request, name, "##DIV##"), "##DIV##");
	}	
	/*************************************************************
	 * Request = >  HashMap<String:parameter name, String:parameter value)
	 * @since 1.0
	 
	 *************************************************************/	
	public static HashMap<String,String> toParamHash(HttpServletRequest request){
		HashMap<String,String> valuehash = new HashMap<String,String>();
		if(request!=null){
			@SuppressWarnings("rawtypes")
			Enumeration paramNames = request.getParameterNames();
			while(paramNames.hasMoreElements()){
				String param_nm = paramNames.nextElement().toString();
				String pram_value = toString(request, param_nm);
				valuehash.put(param_nm, pram_value);
			}			
		}
		return valuehash;
	}
	/*************************************************************
	 * Map = >  HashMap<String:parameter name, String:parameter value)
	 * @since 1.0
	 
	 *************************************************************/	
	public static HashMap<String,String> toParamHash(Map<String,Object> map){
		HashMap<String,String> valuehash = new HashMap<String,String>();
		if(map!=null){
			Set<String> set = map.keySet();
			Iterator<String> iter = set.iterator();
			while(iter.hasNext()){   
				String temp = (String)iter.next();
				String value = toString(map.get(temp) + "");
				if(value.length()>0){
					valuehash.put(temp, map.get(temp) + "");
				}
			}
		}
		return valuehash;
	}

	
	/*************************************************************
     * GET방식 CharacterEncoding 값 리턴 (UTF-8에서 EUC-KR로 받을때, EUC-KR에서 UTF-8등 서버간 인코딩 문제로 받기 힘들때 사용)
     * @since 1.0
     
     *************************************************************/
	public static String toStringCharSetEncodeParam(HttpServletRequest request, String value, String send_server_charset){
		String param_value = "";
		if(request!=null && value!=null && send_server_charset!=null && request.getMethod().equals("GET")){
			for(String param_temp : toString(request.getQueryString()).split("&")){
				String[] key_value = param_temp.split("=");
				if(key_value[0].equals(value)){
					try {
						param_value = URLDecoder.decode(toString(key_value[1]), send_server_charset);
					} catch (UnsupportedEncodingException uee) {
						param_value = "";
					}catch( Exception e){
						param_value = "";
					}
					break;
				}			
			}
		}
		return param_value;
	}

 	/*************************************************************
     * Date -> long
     * @since 1.0
     
     *************************************************************/
    public static long toLong(Date value){
    	if(value==null){
    		return 0;
    	}else{
    		return value.getTime();
    	}
    }
    
 	/*************************************************************
     * Timestamp -> long
     * @since 1.0
     
     *************************************************************/
    public static long toLong(Timestamp value){
    	if(value==null){
    		return 0;
    	}else{
    		return value.getTime();
    	}
    }    
    
    /*************************************************************
     * long -> Date
     * @since 1.0
     
     *************************************************************/
    public static Date toDate(long value){
    	return new Date(value);
    }
    
    /*************************************************************
     * Timestamp -> Date
     * @since 1.0
     
     *************************************************************/
    public static Date toDate (Timestamp value){
    	return value==null ? null : new Date(value.getTime());
    }
  
    /*************************************************************
     * yyyy-mm-dd hh:mm:ss 형식을 -> Date
     * @since 1.0
     
     *************************************************************/
    public static Date toDate(String value, String type) {
    	if(value==null || type==null){
    		return null;
    	}else{
			try {
				return new Date(new SimpleDateFormat(type).parse(value).getTime());
			} catch (NullPointerException npe) {
				return null;
    		} catch (IllegalArgumentException iae) { 
				return null;
			} catch (ParseException pe) {
				return null;
			}catch(Exception e){
	    		return null;
	    	}
    	}
    } 
    public static Date toDate(String value) {
		StringBuffer number = new StringBuffer();
		if(value!=null && value.length()>0){
			String patternStr = "\\d";
			Pattern pattern = Pattern.compile(patternStr);
			Matcher matcher = pattern.matcher(value);
			while(matcher.find()){
				number.append(matcher.group(0));
			}
			value = number.toString();
			
			String[] stamp_array = new String[]{
					"yyyyMMddHHmmssSSS",
					"yyyyMMddHHmmssS",
					"yyyyMMddHHmmss",
					"yyyyMMddHHmm",
					"yyyyMMddHH",
					"yyyyMMdd"
				};	
			Date date = null;
			for(int i=0; i<stamp_array.length; i++){
				if(stamp_array[i].length()==value.length()){
					date = toDate(value, stamp_array[i]);
				}
				if(date!=null){
					break;
				}		
			}
			return date;
		}else{
			return null;
		}
	}
    /*************************************************************
     * long -> Timestamp
     * @since 1.0
     
     *************************************************************/
    public static Timestamp toTimestamp (long value){
    	return new Timestamp(value);
    }
    
    /*************************************************************
     * Date -> Timestamp
     * @since 1.0
     
     *************************************************************/
    public static Timestamp toTimestamp (Date value){
    	return value==null ? null : new Timestamp(value.getTime());
    }
    
    /*************************************************************
     * String 형식을 -> Timestamp
     * @since 1.0
     
     *************************************************************/
    public static Timestamp toTimestamp(String value, String type) {
		try {
			return new Timestamp(new SimpleDateFormat(type).parse(value).getTime());
		} catch (NullPointerException npe) {
			return null;
		} catch (IllegalArgumentException iae) { 
			return null;
		} catch (ParseException pe) {
			return null;
		}catch(Exception e){
    		return null;
    	}
    } 
    public static Timestamp toTimestamp(String value){
    	String[] stamp_array = new String[]{
    			"yyyy-MM-dd HH:mm:ss.SSS",
    			"yyyy-MM-dd HH:mm:ss",
    			"yyyy-MM-dd HH:mm",
    			"yyyy-MM-dd HH",
    			"yyyy-MM-dd",  
    			"yyyy.MM.dd HH:mm:ss.SSS",
    			"yyyy.MM.dd HH:mm:ss",
    			"yyyy.MM.dd HH:mm",
    			"yyyy.MM.dd HH",
    			"yyyy.MM.dd",
				"yyyyMMddHHmmssSSS",
    			"yyyyMMddHHmmss",
    			"yyyyMMddHHmm",
    			"yyyyMMddHH",
    			"yyyyMMdd"
        	};

    	Timestamp timestamp = null;
    	if(toString(value).length()>0){
	    	for(int i=0; i<stamp_array.length; i++){	    	
	    		timestamp = toTimestamp(value, stamp_array[i]);	    	
	    		if(timestamp!=null){
	    			break;
	    		}		
	    	}
    	}
    	return timestamp;
    } 
    

    /*************************************************************
     * date_time 형식을 -> Timestamp
     * @since 1.0
     
     *************************************************************/
    public static Timestamp toTimestamp(String value, String date_split_symbol, String date_time_between_split_symbol, String time_split_symbol){
    	if(value==null){
    		return null;
    	}else{
	    	String yyyy = "";
	    	String MM = "";
	    	String dd = "";
	    	String HH = "00";
	    	String mm = "00";
	    	String ss = "00";
	    	
	    	if(date_time_between_split_symbol!=null && date_time_between_split_symbol.length()>0){
	    		String[] date_time_array = toStr_array(value, date_time_between_split_symbol, 2);
	    		if(date_split_symbol!=null && date_split_symbol.length()>0 && date_time_array[0]!=null && date_time_array[0].length()>0){
	    			String[] date_array = toStr_array(date_time_array[0], date_split_symbol, 3);
	    			yyyy = date_array[0];
	    			MM = date_array[1];
	    			dd = date_array[2];
	    		}else if(date_time_array[0]!=null && date_time_array[0].length()>0){
	    			if(date_time_array[0].length()>=4){
	    				yyyy = date_time_array[0].substring(0,4);
	    			}
	    			if(date_time_array[0].length()>=6){
	    				MM = date_time_array[0].substring(4,6);
	    			}
	    			if(date_time_array[0].length()>=7){
	    				dd = date_time_array[0].substring(6);
	    			}
	    		}
	    		if(time_split_symbol!=null && time_split_symbol.length()>0 && date_time_array[1]!=null && date_time_array[1].length()>0){
	    			String[] time_array = toStr_array(date_time_array[1], time_split_symbol, 3);
	    			HH = time_array[0];
	    			mm = time_array[1];
	    			ss = time_array[2];
	    		}else if( date_time_array[1]!=null && date_time_array[1].length()>0){
	    			if(date_time_array[1].length()>=2){
	    				HH = date_time_array[1].substring(0,2);
	    			}
	    			if(date_time_array[1].length()>=4){
	        			mm = date_time_array[1].substring(2,4);
	    			}
	    			if(date_time_array[1].length()>=5){
	         			ss = date_time_array[1].substring(4);
	    			}
	    		}
	    	}else{    		
	    		if(value.length()>=4){
					yyyy = value.substring(0,4);
				}
	    		if(value.length()>=6){
					MM = value.substring(4,6);
	    		}
	    		if(value.length()>=8){
					dd = value.substring(6,8);
				}
	    		if(value.length()>=10){
					HH = value.substring(8,10);
	    		}
	    		if(value.length()>=12){
	    			mm = value.substring(10,12);
	    		}
	    		if(value.length()>=13){
	     			ss = value.substring(12);
	    		}
	    	}
	    	return Timestamp.valueOf(yyyy + "-" + addZero(MM) + "-" + addZero(dd) + " " + addZero(HH) + ":" + addZero(mm) + ":" + addZero(ss));
    	}
    } 

    /*************************************************************
     * Date -> 형식 포멧
     * @since 1.0
     
     *************************************************************/
    public static String toDateFormat (Date value, String type){
    	try{
    		return value==null || type==null ? "" : new SimpleDateFormat(type).format(value);
    	} catch(NullPointerException npe) {
			return "";
		} catch(IllegalArgumentException iae) { 
			return "";
		} catch(Exception e){
			return "";
		}

    }

    /*************************************************************
     * Long -> 형식 포멧
     * @since 1.0
     
     *************************************************************/
    public static String toDateFormat (Long value, String type){
    	try{
    		return value==null || type==null ? "" : new SimpleDateFormat(type).format(new Date(value));
    	} catch(NullPointerException npe) {
			return "";
		} catch(IllegalArgumentException iae) { 
			return "";
		} catch(Exception e){
			return "";
		}
    }
    
    /*************************************************************
     * String(YYYY-MM-DD) -> 형식 포멧
     * @since 1.0
     
     *************************************************************/
    public static String toDateFormat (String value, String type){
    	try{
    		return value==null || type==null ? "" : new SimpleDateFormat(type).format(toDate(value));
    	} catch(NullPointerException npe) {
			return "";
		} catch(IllegalArgumentException iae) { 
			return "";
		} catch(Exception e){
			return "";
		}
    }   
   
    
	/*************************************************************
     * 한글
     * @since 1.0
     
     *************************************************************/
	public static String toKor(String value){
		String str = "";
		if(value!=null && !value.equals("")){
			try{
				str = new String(value.getBytes("ISO-8859-1"), DEFAULT_ENCODING);
				//str = new String(value.getBytes("ISO-8859-1"), "UTF-8");
			}catch(UnsupportedEncodingException uee){
				str = "";
			}catch(Exception e){
				str = "";
			}
		}
		return str;
	}
	
	/*************************************************************
     * @since 1.0
     
     *************************************************************/
	public static String toEng(String value){
		String str = "";
		if(value!=null && !value.equals("")){
			try{
				str = new String(value.getBytes("KSC5601"), "ISO-8859-1");
			}catch(UnsupportedEncodingException uee){
				str = "";
			}catch(Exception e){
				str = "";
			}
		}
		return str;
	}
	/*************************************************************
     * tel_no_format
     * @since 1.0
     
     *************************************************************/
	public static String toTel_no_format(String tel_no) {
		StringBuffer telbuffer = new StringBuffer();
		if(tel_no!=null && tel_no.length()>0){
			String patternStr = "\\d";
			Pattern pattern = Pattern.compile(patternStr);
			Matcher matcher = pattern.matcher(tel_no);
			while(matcher.find()){
				telbuffer.append(matcher.group(0));
			}
		}
		String tel_no_str = telbuffer.toString();
		if(tel_no_str.length()==11){
			tel_no_str = tel_no_str.substring(0,3)+"-"+tel_no_str.substring(3,7)+"-"+tel_no_str.substring(7); 
		}else if(tel_no_str.length()==10){
			if(tel_no_str.substring(0,2).equals("02")){
				tel_no_str = tel_no_str.substring(0,2)+"-"+tel_no_str.substring(2,6)+"-"+tel_no_str.substring(6); 
			}else{
				tel_no_str = tel_no_str.substring(0,3)+"-"+tel_no_str.substring(3,6)+"-"+tel_no_str.substring(6);
			}
		}else if(tel_no_str.length()==9){
			tel_no_str = tel_no_str.substring(0,2)+"-"+tel_no_str.substring(2,5)+"-"+tel_no_str.substring(5);			
		}
		return tel_no_str;
	}
	/*************************************************************
     * tel_no_array[]
     * @since 1.0
     
     *************************************************************/
	public static String[] toTel_no_array(String tel_no) {
		String[] tel_no_array = {"", "", "", ""};
		if(tel_no!=null){
			String[] tmp_tel_no_arr = tel_no.split("-");
			for(int i=0; i<4; i++){			
				if(i<3){
					if(tmp_tel_no_arr.length>i){
						tel_no_array[i]=tmp_tel_no_arr[i];
					}
				}else{
					String[] temp = tel_no_array[2].split("~");
					if(temp!=null && temp.length>1){
						tel_no_array[2] = temp[0];
						tel_no_array[3] = temp[1];
					}
				}				
			}
		}
		return tel_no_array;
	}
	
	/*************************************************************
     * str_array[]
     * @since 1.0
     
     *************************************************************/
	public static String[] toStr_array(String value, String split_symbol, int max_array_size) {
		String[] str_array = new String[max_array_size];
		for(int i=0; i<max_array_size; i++){
			str_array[i]="";
		}
		String[] temp_array = toStr_array(value, split_symbol);
		for(int i=0; i<temp_array.length; i++){
			if(i<str_array.length){
				str_array[i]=temp_array[i];
			}
		}
		return str_array;
	}
	
	/*************************************************************
     * str_array[]
     * @since 1.0
     
     *************************************************************/
	public static String[] toStr_array(String value, String split_symbol){
		return replaceAll(value, split_symbol, "##d##i##v##").split("##d##i##v##");
	}
	
	/*************************************************************
     * String 구분기호 두개로 된 문자열을 -> HashMap<String,String>
     * @since 1.0
     
     *************************************************************/
	public static HashMap<String,String> toHash (String value_str, String symbol_1, String symbol_2){
		HashMap<String, String> hash = new HashMap<String, String>();
		String[] str_array = toStr_array(value_str, symbol_1);
		for(String str : str_array){
			String[] strs = toStr_array(str, symbol_2, 2);
			hash.put(strs[0], strs[1]);
		}		
		return hash;
	}
	
	/**
	 * @param ymd
	 * @return
	 */
	public static String toLunar(String ymd) {
		String[] ymd_arr = Fn.toStr_array(ymd, "-", 3);
		return toLunar(toInt(ymd_arr[0]),toInt(ymd_arr[1]),toInt(ymd_arr[2]));		
	}
	
	/**
	 * @param pYear
	 * @param pMonth
	 * @param pDay
	 * @return
	 */
	public static String toLunar(int pYear, int pMonth, int pDay) {
		// 음력 테이블 2050
	    String sLunarTableString = "1212122322121-1212121221220-1121121222120-2112132122122-2112112121220-2121211212120-2212321121212-2122121121210-2122121212120-1232122121212-1212121221220-1121123221222-1121121212220-1212112121220-2121231212121-2221211212120-1221212121210-2123221212121-2121212212120-1211212232212-1211212122210-2121121212220-1212132112212-2212112112210-2212211212120-1221412121212-1212122121210-2112212122120-1231212122212-1211212122210-2121123122122-2121121122120-2212112112120-2212231212112-2122121212120-1212122121210-2132122122121-2112121222120-1211212322122-1211211221220-2121121121220-2122132112122-1221212121120-2121221212110-2122321221212-1121212212210-2112121221220-1231211221222-1211211212220-1221123121221-2221121121210-2221212112120-1221241212112-1212212212120-1121212212210-2114121212221-2112112122210-2211211412212-2211211212120-2212121121210-2212214112121-2122122121120-1212122122120-1121412122122-1121121222120-2112112122120-2231211212122-2121211212120-2212121321212-2122121121210-2122121212120-1212142121212-1211221221220-1121121221220-2114112121222-1212112121220-2121211232122-1221211212120-1221212121210-2121223212121-2121212212120-1211212212210-2121321212221-2121121212220-1212112112210-2223211211221-2212211212120-1221212321212-1212122121210-2112212122120-1211232122212-1211212122210-2121121122210-2212312112212-2212112112120-2212121232112-2122121212110-2212122121210-2112124122121-2112121221220-1211211221220-2121321122122-2121121121220-2122112112322-1221212112120-1221221212110-2122123221212-1121212212210-2112121221220-1211231212222-1211211212220-1221121121220-1223212112121-2221212112120-1221221232112-1212212122120-1121212212210-2112132212221-2112112122210-2211211212210-2221321121212-2212121121210-2212212112120-1232212122112-1212122122120-1121212322122-1121121222120-2112112122120-2211231212122-2121211212120-2122121121210-2124212112121-2122121212120-1212121223212-1211212221220-1121121221220-2112132121222-1212112121220-2121211212120-2122321121212-1221212121210-2121221212120-1232121221212-1211212212210-2121123212221-2121121212220-1212112112220-1221231211221-2212211211220-1212212121210-2123212212121-2112122122120-1211212322212-1211212122210-2121121122120-2212114112122-2212112112120-2212121211210-2212232121211-2122122121210-2112122122120-1231212122212-1211211221220-2121121321222-2121121121220-2122112112120-2122141211212-1221221212110-2121221221210-2114121221221-";
	    String[] sLunarTable = toStr_array(sLunarTableString, "-", 170);
	    
	    String[] nDay = "31-0-31-30-31-30-31-31-30-31-30-31".split("-");
	 
	    int[] nDayTable = new int[171];

	    int nLunarMonth = 0;

	    //음력 일수 셋팅
	    for(int i=0; i<170; i++){
	    	nDayTable[i]=0;
	        for(int j=0; j<13; j++){	        	
	        	nLunarMonth = toInt(sLunarTable[i].substring(j, j+1));
	        	if(nLunarMonth==1 || nLunarMonth==3){
	        		nDayTable[i] += 29;
	        	}else if(nLunarMonth==2 || nLunarMonth==4){
	        		nDayTable[i] += 30;
	        	}
	        }
	    }
	    
	    int nYear = pYear - 1;
	    int nDays1 = 1880*365 + 1880/4 - 1880/100 + 1880/400 + 30;	// 1880년 까지의 날수
	    int nDays2 = nYear*365 + nYear/4 - nYear/100 + nYear/400; 	// 1880년 이후의 날수

	    //윤년일수 설정
	    if(isLeapMonth(pYear)){
	        nDay[1] = "29";
	    }else{
	    	nDay[1] = "28";
	    }	    
	    
	    // 전달까지의 날짜를 계산
	    for(int i=0; i<pMonth-1; i++){
	        nDays2 += toInt(nDay[i]);
	    }
	    
	    nDays2 += pDay;
	    int nRetDay = nDays2 - nDays1 + 1;
	    
	    int nDays3 = nDayTable[0];    
	    
	    int idx = 0;
	    for(int i=0; i<170; i++){
	    	idx = i;
	        if(nRetDay <= nDays3){	        	
	        	break;
	        }
	        nDays3 += nDayTable[i+1];
	        
	    }	    
	    int nRetYear  = idx + 1881;
	    
	    nDays3 = nDays3 - nDayTable[idx];
	    nRetDay = nRetDay - nDays3;	    
		    
	    int nMonthCount = 11;
	    if(toInt(sLunarTable[idx].substring(12))>0 ){
	    	nMonthCount = 12;
	    } 
	    int nRetMonth = 0;
	    int nDayPerMonth = 0;
	    
	    for(int j=0; j<=nMonthCount; j++){
	        nLunarMonth = toInt(sLunarTable[idx].substring(j, j+1));
	        if(nLunarMonth > 2){
	            nDayPerMonth = nLunarMonth + 26;
	        }else{
	            nRetMonth = nRetMonth + 1;
	            nDayPerMonth = nLunarMonth + 28;
	        }
	        if(nRetDay <= nDayPerMonth){
	        	break;
	        }
	        nRetDay = nRetDay - nDayPerMonth; 
	    }

	    return  nRetYear + "-" + addZero(nRetMonth)+ "-" + addZero(nRetDay);
	}

	/**
	 * @param pYear
	 * @return
	 */
	private static boolean isLeapMonth(int pYear){		
		if(pYear%100!=0 && pYear%4==0 || pYear%400==0){
			return true;
		}else{
			return false;	
		}	
	}
	/**
	 * @param start_ymd
	 * @param end_ymd
	 * @return
	 */
	public static Map<String,String> holidayMap(String start_ymd, String end_ymd) {		
		// 양력 휴일
		Map<String,String> sunHolidayMap = new HashMap<String,String>();
		sunHolidayMap.put("01-01", "신정");
		sunHolidayMap.put("03-01", "삼일절");
		sunHolidayMap.put("05-05", "어린이날");
		sunHolidayMap.put("06-06", "현충일");
		sunHolidayMap.put("08-15", "광복절");
		sunHolidayMap.put("10-03", "개천철");
		sunHolidayMap.put("10-09", "한글날");
		sunHolidayMap.put("12-25", "성탄절");
		
		// 음력 휴일 3일
		Map<String,String> lunarHoliday3Map = new HashMap<String,String>();
		lunarHoliday3Map.put("01-01", "설날");
		lunarHoliday3Map.put("08-15", "추석");		
		
		// 음력 휴일 1일
		Map<String,String> lunarHoliday1Map = new HashMap<String,String>();
		lunarHoliday1Map.put("04-08", "석가탄신일");
		
		Map<String,String> holidayMap = new HashMap<String,String>();
		

		int subDays = getSubDays(end_ymd, start_ymd);
		for(int i=0; i<=subDays; i++){
			String sunYmd = getYmdAddDay(toDate(start_ymd), i);
			String sunYmdBefore = getYmdAddDay(toDate(sunYmd), -1);
			String sunYmdAfter = getYmdAddDay(toDate(sunYmd), 1);
			
			String weekno_before = getWeek(sunYmdBefore)+"";
			String weekno = getWeek(sunYmdBefore)+"";
			String weekno_after = getWeek(sunYmdAfter)+ "";
	
			
			String sunMd = toDateFormat(sunYmd, "MM-dd");
			
			String lunarYmd = toLunar(sunYmd);
			String[] lunarYmdArr = toStr_array(lunarYmd, "-", 3);
			String lunarMd = lunarYmdArr[1] + "-" + lunarYmdArr[2];
	
			// 1. 양력 휴일 start ----
			String holidyName = sunHolidayMap.get(sunMd);
			if(!Validity.isNull(holidyName)){
				holidayMap.put(sunYmd, holidyName);
			}
			// 1. 양력 휴일 end ----
			
			
			// 2. 어린이날 대체 휴일 start --
			if(sunMd.equals("05-05")){
				if(weekno.equals("1")){
					holidayMap.put("05-06", "-");
				}
				if(weekno.equals("7")){
					holidayMap.put("05-07", "-");
				}
			}
			// 2. 어린이날 대체 휴일 end --
						
		
			// 3. 음력 휴일 3일 start ----
			holidyName = lunarHoliday3Map.get(lunarMd);
			if(!Validity.isNull(holidyName)){
				
				holidayMap.put(sunYmdBefore, "-");
				holidayMap.put(sunYmd, holidyName);
				holidayMap.put(sunYmdAfter, "-");
				
				// 4. 대체 휴일 (설,추석)
				if(isEqualValue("1",",",weekno_before) || isEqualValue("1",",",weekno) || isEqualValue("1",",",weekno_after)){
					String sunYmdAdd = getYmdAddDay(Fn.toDate(sunYmd), 2);
					holidayMap.put(sunYmdAdd, "-");
				}
			}			
			// 3. 음력 휴일 3일 end ----
	
			
			// 5. 음력 휴일 1일 start ----
			holidyName = lunarHoliday1Map.get(lunarMd);
			if(!Validity.isNull(holidyName)){
				holidayMap.put(sunYmd, holidyName);
			}			
			// 음력 휴일 1일 start ----			
			
		}		
		return holidayMap;
	}
	
	/*************************************************************
     * Input 배열과 비교 Output 결과
     * @since 1.0
     
     *************************************************************/
	public static String changeString(String[] inputs, String[] outputs, String value){
		String result = value;
		if(inputs!=null && outputs!=null && inputs.length==outputs.length){
			HashMap<String,String> hash = new HashMap<String,String>(); 
			for(int i=0; i<inputs.length; i++){
				hash.put(inputs[i], outputs[i]);
			}
			result = changeString(hash, ",", value);
		}		
		return result;
	}
	/*************************************************************
     * Input 문자열과 비교 Output 결과
     * @since 1.0
     
     *************************************************************/
	public static String changeString(String input_str, String output_str, String value){
		return changeString(toStr_array(input_str, ","), toStr_array(output_str, ","), value);
	}
	public static String changeString(String input_str, String output_str, int value){
		return changeString(toStr_array(input_str, ","), toStr_array(output_str, ","), value+"");
	}
	public static String changeString(String input_str, String output_str, String split_symbol, String value){
		return changeString(toStr_array(input_str, split_symbol), toStr_array(output_str, split_symbol), value);
	}
	public static String changeString(String input_str, String output_str, String split_symbol, int value){
		return changeString(toStr_array(input_str, split_symbol), toStr_array(output_str, split_symbol), value+"");
	}
	public static  int changeInt(String input_str, String output_str, String value){
		return toInt(changeString(input_str, output_str, ",", value));
	}
	public static  int changeInt(String input_str, String output_str, int value){
		return toInt(changeString(input_str, output_str, ",", value));
	}
	public static  int changeInt(String input_str, String output_str, String split_symbol, String value){
		return toInt(changeString(input_str, output_str, split_symbol, value));
	}
	public static  int changeInt(String input_str, String output_str, String split_symbol, int value){
		return toInt(changeString(input_str, output_str, split_symbol, value));
	}
	public static String changeString(HashMap<String,String> hash, String split_symbol, String value){
		StringBuffer value_str = new StringBuffer();
		if(value!=null){
			if(hash != null && hash.size() > 0 && split_symbol != null && split_symbol.length() > 0){
				String[] value_str_arr = toStr_array(value, split_symbol);
				
				for(int i = 0 ; i < value_str_arr.length; i++){
					value_str.append(hash.get(value_str_arr[i]));
					if(i < value_str_arr.length-1){
						value_str.append(split_symbol);
					}
				}
			}else{
				value_str.append(value);
			}
		}
		
		return value_str.toString();
	}
	
	public static String changeString(HashMap<String,String> hash, String split_symbol, String out_symbol, String value){
		return replaceAll(changeString(hash, split_symbol, value),split_symbol,out_symbol);	
	}

	
	/*************************************************************
     * 금액 형식
     * @since 1.0
     
     *************************************************************/
	public static String amount (double value){
		String amount = "￦";
   		amount += decimal(value, "###,###");
   		return amount;
	}
	
	/*************************************************************
     * 금액 형식
     * @since 1.0
     
     *************************************************************/
   	public static String amount (int value) {
   		String amount = "￦";
   		amount += decimal(value, "###,###");
   		return amount;
   	}
   	
   	/*************************************************************
     * 소숫점 표현형식
     * @since 1.0
     
     *************************************************************/
   	public static String decimal (double value, String format){
   		if(format==null){
   			return "";
   		}else{
   			return replaceAll(new DecimalFormat(format).format(value), "-0", "0"); // format : ###,###,##;
   		}
   	}
    	
   	/*************************************************************
     * 소숫점 표현형식
     * @since 1.0
     
     *************************************************************/
   	public static String decimal(String value, String point_format){
   		if(value==null || point_format==null){
   			return "";
   		}else{
   			try{
   				String disit1 = value;
   				String disit2 = "";
   				if(value.indexOf(".")>-1){
   					disit1 = value.substring(0, value.indexOf("."));
   					disit2 = value.substring(value.indexOf("."));
   				}
   				String re_disit1 = addSymbol(disit1, ",", 3);
   				String re_disit2 = disit2;
   				if(disit2.indexOf(".")>-1){
   					re_disit2 = decimal(toDouble("0" + disit2), point_format);
   				}
   				return re_disit1 + (re_disit2.indexOf(".")>-1? re_disit2.substring(re_disit2.indexOf("0.")+1) : "");
   			}catch(StringIndexOutOfBoundsException indexe){
   				return value;
   			}catch(Exception e){
   				return value;
   			}
   		}
   	}
   	
   	/*************************************************************
     * ... 절사 하기(길이)
     * @since 1.0
     
     *************************************************************/
    public static String shortSubstring (String value, int length) {
   		return value!=null && value.length()>length ? value.substring(0,length-3) + "..." : value;
	}
    public static String shortByteString(String value, int maxbyte)throws Exception{ 
    	if(value==null||value.length()==0){ 
    		return ""; 
    	}else{ 
	    	int currentByte = value.getBytes("EUC-KR").length; // 글바의 바이트수 
	    	int len = value.length(); // 글자의 길이 
	    	if(currentByte>maxbyte){ 
		    	int count=0; // 글자 길이 카운트 
		
		    	while(count<len){ 
		    		if(value.substring(0,++count).getBytes("EUC-KR").length>maxbyte-3){ 
		    			break; 
		    		} 
		    	} 
		    	return value.substring(0,--count)+"..."; 
	    	}else{ 
	    		return value; 
	    	} 
    	} 
    }
    /*************************************************************
     * 절사 하기(Byte)
     * @since 1.0
     
     *************************************************************/
    public static String shortByteSubString(String value, int maxbyte)throws Exception{ 
    	if(value==null||value.length()==0){ 
    		return ""; 
    	}else{ 
	    	int currentByte = value.getBytes("EUC-KR").length; // 글바의 바이트수 
	    	int len = value.length(); // 글자의 길이 
	    	if(currentByte>maxbyte){ 
		    	int count=0; // 글자 길이 카운트 
		
		    	while(count<len){ 
		    		if(value.substring(0,++count).getBytes("EUC-KR").length>maxbyte){ 
		    			break; 
		    		} 
		    	} 
		    	return value.substring(0,--count); 
	    	}else{ 
	    		return value; 
	    	} 
    	} 
    } 
    /*************************************************************
     * 일정한 구분열 문자열을 오름 차순으로 정렬 order 0 오름차순 1 내림 차순
     * @since 1.0
     
     *************************************************************/
	public static String sortInteger(String value, String symbol, int order){
		if(value==null || symbol==null){
			return value;
		}else{
			String[] value_array = toString(value).split(symbol);
			
			ArrayList<Integer> arrayList = new ArrayList<Integer>();
			for(int i=0; i<value_array.length; i++){
				arrayList.add(toInt(value_array[i]));
			}
			Collections.sort(arrayList); 		
			
			String re_value= "";
			if(order==0){
				for(int i=0; i<arrayList.size(); i++){
					re_value += arrayList.get(i).toString();
					if(i<arrayList.size()-1){
						re_value += symbol;
					}
				}
			}else{
				for(int i=arrayList.size()-1; i>=0; i--){
					re_value += arrayList.get(i).toString();
					if(i>0){
						re_value += symbol;
					}
				}
			}
			return re_value;
		}
	}
	public static String sortString(String value, String symbol, int order){
		if(value==null || symbol==null){
			return value;
		}else{
			String[] value_array = toString(value).split(symbol);
			
			ArrayList<String> arrayList = new ArrayList<String>();
			for(int i=0; i<value_array.length; i++){
				arrayList.add(value_array[i]);
			}
			Collections.sort(arrayList); 		
			
			String re_value= "";
			if(order==0){
				for(int i=0; i<arrayList.size(); i++){
					re_value += arrayList.get(i);
					if(i<arrayList.size()-1){
						re_value += symbol;
					}
				}
			}else{
				for(int i=arrayList.size()-1; i>=0; i--){
					re_value += arrayList.get(i);
					if(i>0){
						re_value += symbol;
					}
				}
			}
			return re_value;
		}
	}
	
	 /*************************************************************
     * 일정한 구분열 문자열 2개 오름 차순으로 정렬 order 0 오름차순 1 내림 차순 | 결과 배열
     * @since 1.0
     
     *************************************************************/
	public static String[] sortIntegerArray(String key_str, String value_str, String symbol, int order){
		if(key_str==null || value_str==null || symbol==null){
			return new String[]{key_str, value_str};
		}else{
			HashMap<String,String> keyvalue = new HashMap<String,String>();
			String[] key = key_str.split(symbol);
			String[] value = value_str.split(symbol);
			for(int i=0; i<key.length; i++){
				keyvalue.put(key[i], value[i]);
			}
			String re_value_str = "";
			String re_key_str = sortInteger(key_str, symbol, order);
			String[] re_key_array = re_key_str.split(symbol);
			for(int i=0; i<key.length; i++){
				re_value_str += keyvalue.get(re_key_array[i]);
				if(i<key.length-1){
					re_value_str += ",";
				}
			}
			String[] re_array_value = {re_key_str, re_value_str}; 
			return re_array_value;
		}
	}
	public static String[] sortStringArray(String key_str, String value_str, String symbol, int order){
		if(key_str==null || value_str==null || symbol==null){
			return new String[]{key_str, value_str};
		}else{
			HashMap<String,String> keyvalue = new HashMap<String,String>();
			String[] key = key_str.split(symbol);
			String[] value = value_str.split(symbol);
			for(int i=0; i<key.length; i++){
				keyvalue.put(key[i], value[i]);
			}
			String re_value_str = "";
			String re_key_str = sortString(key_str, symbol, order);
			String[] re_key_array = re_key_str.split(symbol);
			for(int i=0; i<key.length; i++){
				re_value_str += keyvalue.get(re_key_array[i]);
				if(i<key.length-1){
					re_value_str += ",";
				}
			}
			String[] re_array_value = {re_key_str, re_value_str}; 
			return re_array_value;
		}
	}
    /*************************************************************
     * <br />추가(Byte)
     * @throws Exception 
     * @since 1.0
     
     *************************************************************/
    public static String limitByteAndEnterAddBrTag(String value, int maxbyte) throws Exception{
    	if(value==null||value.length()==0){
    		return "";
    	}else{
	    	int currentByte = 0;
	    	StringBuffer strbuff = new StringBuffer();
    		for(int len=0; len<value.length(); len++){
    			String temp_cahr = value.substring(len, len+1); 
    			currentByte += temp_cahr.getBytes("EUC-KR").length;    		
    			strbuff.append(temp_cahr);
    			
    			if(currentByte>=maxbyte || temp_cahr.equals("\n") ){
    				strbuff.append("#LINE#");
    				currentByte = 0;
    			}
    		}
    		String[] str_array = strbuff.toString().split("#LINE#");
    		strbuff = new StringBuffer();
    		for(int i=0; i<str_array.length; i++){
    			String line_str = str_array[i].trim();
    			if(line_str.length()>0){
    				strbuff.append(line_str+"<br />");
    			}else{
    				if(str_array[i].length()==0){
    					strbuff.append("<br />");	
    				}
    			}
    		}
    		return strbuff.toString();
    	}
	}
    /*************************************************************
     * <br />추가(Byte)
     * @throws Exception 
     * @since 1.0
     
     *************************************************************/
    public static String limitByteAddBrTag(String value, int maxbyte) throws Exception{
    	if(value==null||value.length()==0){
    		return "";
    	}else{
	    	int currentByte = 0;
	    	StringBuffer strbuff = new StringBuffer();
    		for(int len=0; len<value.length(); len++){
    			String temp_cahr = value.substring(len, len+1); 
    			currentByte += temp_cahr.getBytes("EUC-KR").length;
    			strbuff.append(temp_cahr);
    			
    			if(currentByte>=maxbyte){
    				strbuff.append("<br />");
    				currentByte = 0;
    			}
    		}
	    	return strbuff.toString();
    	}
	}
 
    /*************************************************************
     * LPAD 좌측 문자열 채우기
     * @since 1.0
     
     *************************************************************/  
    public static String lpad(String value, int len, String symbol){
    	if(value==null || symbol==null){
    		return "";
    	}else{
	    	String lpad = "";
	    	String SYMBOL = symbol.substring(0,1);
	    	if(len>value.length()){
		    	for(int i=0; i<len-value.length(); i++){
		    		lpad += SYMBOL;
		    	}
	    	}
	    	lpad += value;
	    	return lpad;
    	}
    }
    
    /*************************************************************
     * RPAD 우측 문자열 채우기
     * @since 1.0
     
     *************************************************************/  
    public static String rpad(String value, int len, String symbol){
    	if(value==null || symbol==null){
    		return "";
    	}else{
	    	String rpad = value;
	    	String SYMBOL = symbol.substring(0,1);
	    	if(len>value.length()){
		    	for(int i=0; i<len-value.length(); i++){
		    		rpad += SYMBOL;
		    	}
	    	}
	    	return rpad;
    	}
    }
    
    /*************************************************************
     * substringBefore 특정 문자 이전 문자열 추출(이전 문자열 무조건 존재)
     * @since 1.0
     
     *************************************************************/     
    public static String substringBefore(String value, String search){
    	if(value==null || search==null){
    		return "";
    	}else{
    		return value.indexOf(search)==-1 ? value : value.substring(0,value.indexOf(search));
    	}
    }
    /*************************************************************
     * substringBefore 특정 문자 이전 문자열 추출
     * @since 1.0
     
     *************************************************************/     
    public static String substringBefore2(String value, String search){
    	if(value==null || search==null){
    		return "";
    	}else{
    		return value.indexOf(search)==-1 ? "" : value.substring(0,value.indexOf(search));
    	}
    }

    /*************************************************************
     * substringAfter 특정 문자 이후 문자열 추출(이후 문자열 무조건 존재)
     * @since 1.0
     
     *************************************************************/     
    public static String substringAfter(String value, String search){
    	if(value==null || search==null){
    		return "";
    	}else{
    		return value.indexOf(search)==-1 ? value : value.substring(value.indexOf(search)+search.length());
    	}
    }
    /*************************************************************
     * substringAfter 특정 문자 이후 문자열 추출
     * @since 1.0
     
     *************************************************************/     
    public static String substringAfter2(String value, String search){
    	if(value==null || search==null){
    		return "";
    	}else{
    		return value.indexOf(search)==-1 ? "" : value.substring(value.indexOf(search)+search.length());
    	}
    } 

    /*************************************************************
     * URLEncoder
     * @since 1.0
     
     *************************************************************/
    public static String encode(String value){
    	return encode(value, DEFAULT_ENCODING);
    }
    /*************************************************************
     * URLEncoder
     * @since 1.0
     
     *************************************************************/
    public static String encode(String value, String enconding){
    	if(value==null || enconding==null){
    		return "";
    	}else{
			String result = "";		
			try {
				result = URLEncoder.encode(value, enconding);
			} catch (UnsupportedEncodingException e) {
				result = "";	
			}			
			return result;    	
    	}
    }

    /*************************************************************
     * URLDecoder
     * @since 1.0
     
     *************************************************************/
    public static String decode(String value){
    	return decode(value, DEFAULT_ENCODING);
    }       
    /*************************************************************
     * URLDecoder
     * @since 1.0
     
     *************************************************************/
    public static String decode(String value, String enconding){
    	if(value==null || enconding==null){
    		return "";
    	}else{
	    	String result = "";
			try {
				result = URLDecoder.decode(value, enconding);
			} catch (UnsupportedEncodingException e) {
				result = "";
			}
			return result;   
    	}		
    }  
    
    /*********************(추가 : add)****************************/
	
    /*************************************************************
     * 숫자 3자리 콤마 표시
     * @since 1.0
     
     *************************************************************/
	public static String addSymbol(double value) {
		return NumberFormat.getNumberInstance().format(value);
	}
    
    /*************************************************************
     * 숫자 3자리 기호 표시
     * @since 1.0
     
     *************************************************************/
	public static String addSymbol(double value, String symbol) {
		if(symbol==null){
			return addSymbol(value);
		}else{
			return NumberFormat.getNumberInstance().format(value).replaceAll(",", symbol);
		}
	}

	/*************************************************************
     * 문자열 구분 기호 표시
     * @since 1.0
     
     *************************************************************/
	public static String addSymbol(String value, String symbol, int space_cnt){
   		if(value==null){
   			return "";
   		}else{
			String re_value = "";
			int cnt = 0;
			for(int i=value.length()-1; i>=0; i--) {
				cnt++;
				if(cnt>1 && cnt%space_cnt==1){
					re_value = symbol + re_value;
				}
				re_value = value.charAt(i) + re_value ;
			}
			return re_value;
   		}
   	}
   	
    /*************************************************************
     * 1, -> 01, 2, ->02  두자리 숫자 만들기
     * @since 1.0
     
     *************************************************************/  
    public static String addZero(String value) {
    	if(value==null || value.length()==0){
    		return "00";
    	}else{
    		return value.length()==1? "0" + value : value;
    	}
    }
    
   	/*************************************************************
     * 1, -> 01, 2, ->02  두자리 숫자 만들기
     * @since 1.0
     
     *************************************************************/    
    public static String addZero(int value) {
    	return addZero(value+"");
    }


    
    /*********************(얻기 : get)****************************/
   	/*************************************************************
     * 바이트 크기
     * @since 1.0
     
     *************************************************************/
    public static int getByteLength (String value) {
        int getByte = 0;
    	try {
			getByte= value.getBytes("EUC-KR").length;
		} catch (UnsupportedEncodingException e) {
			getByte = 0;
		}
        return getByte;
    }
    
    /*************************************************************
     * 이달의 마지막일
     * @since 1.0
     
     *************************************************************/
    public static int getMaxDay(int year, int month){
    	Calendar cal = Calendar.getInstance();
    	cal.set(year, month-1, 1);
 	   	return cal.getActualMaximum(Calendar.DATE);
    }
    public static int getMaxDay(String ymd){
    	String[] ymd_array = toStr_array(ymd, "-", 3);
    	return getMaxDay(toInt(ymd_array[0]), toInt(ymd_array[1]));
    }
    
    /*************************************************************
     * 선택 년월/주차/요일 > 일
     * @since 1.0
     
     *************************************************************/
    public static int getWeekDay(String ym, int weektime, int weekno){
    	return getWeekFirstDay(ym, weektime) + weekno - 1;
    }
    public static int getWeekDay(int year, int month, int weektime, int weekno){
    	return getWeekFirstDay(year, month, weektime) + weekno - 1;
    } 
    /*************************************************************
     * 선택 년월/주차/요일 > 년월일
     * @since 1.0
     
     *************************************************************/
    public static String getWeekYmd(String ym, int weektime, int weekno) throws Exception{
    	int day = getWeekFirstDay(ym, weektime) + weekno - 1;
    	String ymd = "";
    	if(day>0){
    		ymd = ym + "-" + addZero(day);
    	}else{
    		ymd = getYmdAddDay(toDate(ym + "-01") , day-1);
    	}
    	return ymd;
    } 

    public static String getWeekYmd(int year, int month, int weektime, int weekno) throws Exception{
    	int day = getWeekFirstDay(year, month, weektime) + weekno - 1;
    	String ymd = "";
    	if(day>0){
    		ymd = year +"-" + addZero(month) + "-" + addZero(day);
    	}else{
    		ymd = getYmdAddDay(toDate(year +"-" + addZero(month) + "-01") , day-1);
    	}
    	return ymd;
    } 
    /*************************************************************
     * 해당 일의 요일 (일요일 1, 월요일 2, ... 토요일 7)
     * @since 1.0
     
     *************************************************************/
    public static int getWeek(int year, int month, int day){
    	Calendar cal = Calendar.getInstance();
    	cal.set(year, month-1, day);
    	return cal.get(Calendar.DAY_OF_WEEK);
    }
    public static int getWeek(String ymd){
    	String[] ymd_array = toStr_array(ymd, "-", 3);
    	return getWeek(toInt(ymd_array[0]), toInt(ymd_array[1]), toInt(ymd_array[2]));
    }
    /*************************************************************
     * 지정 년/월/주차의 첫 일요일 날짜
     * @since 1.0
     * @ciga1212 (ciga1212@dofnetwork.co.kr)
     *************************************************************/
    public static int getWeekFirstDay(int year, int month, int weektime){
    	return (1 - (getWeek(year,month,1) -1) ) + 7*(weektime - 1);
    }
    
    public static int getWeekFirstDay(String ym, int weektime){
    	String[] ym_array = toStr_array(ym, "-", 2);
    	return getWeekFirstDay(toInt(ym_array[0]), toInt(ym_array[1]), weektime);
    }
    
    /*************************************************************
     * 요일 한글출력
     * @since 1.0
     * @ciga1212 (ciga1212@dofnetwork.co.kr)
     *************************************************************/
    public static String getWeekKor(int year, int month, int day){
    	int week = getWeek(year, month, day);
    	String[] weekkor ={"일", "월", "화", "수", "목", "금", "토"};
    	return weekkor[week<1?0: week-1];
    }
    public static String getWeekKor(String ymd){
    	String[] ymd_array = toStr_array(ymd, "-", 3);
    	return getWeekKor(toInt(ymd_array[0]), toInt(ymd_array[1]), toInt(ymd_array[2]));
    }
    
    
    /*************************************************************
     * 현재의 년도
     * @since 1.0
     
     *************************************************************/
    public static int getYear(){
    	Calendar cal = Calendar.getInstance();
    	return cal.get(Calendar.YEAR);
    }
    
    /*************************************************************
     * 현재의 달
     * @since 1.0
     
     *************************************************************/
    public static int getMonth(){
    	Calendar cal = Calendar.getInstance();
    	return cal.get(Calendar.MONTH)+1;
    }
    
    /*************************************************************
     * 현재의 일
     * @since 1.0
     
     *************************************************************/
    public static int getDay(){
    	Calendar cal = Calendar.getInstance();
    	return cal.get(Calendar.DATE);
    }
 
    /*************************************************************
     * 오늘 날짜에서 몇일 전후 날짜
     * @since 1.0
     
     *************************************************************/
    public static Date getDateAddDay(int day){
        Date date = new Date();
    	date.setTime(date.getTime()+(long)24*(long)60*(long)60*(long)1000*(long)day); 
    	return date;
    }
    
    
    /*************************************************************
     * 오늘 날짜에서 몇일 전후 날짜 yyyy-MM-dd 형식
     * @since 1.0
     
     *************************************************************/
    public static String getYmdAddDay(int day){
    	return new SimpleDateFormat("yyyy-MM-dd").format(getDateAddDay(day));
    }
        
    /*************************************************************
     * 특정 날짜에서 몇일 전후 날짜
     * @since 1.0
     
     *************************************************************/
    public static Date getDateAddDay(Date date, int day){
    	if(date==null){
    		return null;
    	}else{
	    	Date addDate = new Date();
	    	addDate.setTime(date.getTime()+(long)24*(long)60*(long)60*(long)1000*(long)day); 
	    	return addDate;
    	}
    }

    /*************************************************************
     * 특정 날짜에서 몇일 전후 날짜 yyy-MM-dd 형식
     * @since 1.0
     
     *************************************************************/
    public static String getYmdAddDay(Date date, int day){
   		return date==null ? "" : new SimpleDateFormat("yyyy-MM-dd").format(getDateAddDay(date, day));
    }
    /*************************************************************
     * 특정 날짜에서 달계산  yyy-MM-dd 형식
     * @since 1.0
     
     *************************************************************/
    public static String getYmdAddMonth(String value_ymd, int add_month){
    	String[] s_day_ymd = toStr_array(value_ymd, "-", 3);

    	int total_month =  toInt(s_day_ymd[0]) * 12 + toInt(s_day_ymd[1]) + add_month;
    	int e_year = total_month / 12;
    	int e_month = total_month % 12;
    	
    	if(e_month==0){
    		e_month = 12;
    		e_year--;
    	}
		
		int e_day = toInt(s_day_ymd[2]);
		int e_max_day = getMaxDay(e_year, e_month);
		
		if(e_day > e_max_day){
			return e_year + "-" + addZero(e_month) + "-" + addZero(e_max_day);
		}else{
			try{
				return toDateFormat(getDateAddDay(toDate(e_year+"-"+addZero(e_month)+"-"+addZero(e_day)), -1), "yyyy-MM-dd");
			}catch(NullPointerException e){
				return "";
			}catch(Exception e){
				return "";
			}
		}	
    }
    /*************************************************************
     * 특정 날짜에서 달계산  yyy-MM 형식
     * @since 1.0
     
     *************************************************************/
    public static String getYmAddMonth(String value_ym, int add_month){
    	String[] s_day_ymd = toStr_array(value_ym, "-", 2);		

    	int total_month =  toInt(s_day_ymd[0]) * 12 + toInt(s_day_ymd[1]) + add_month;
    	int e_year = total_month / 12;
    	int e_month = total_month % 12;
    	
    	if(e_month==0){
    		e_month = 12;
    		e_year--;
    	}
    		 
    	return e_year+"-"+addZero(e_month);
    }
    /*************************************************************
     * 특정 날짜에서 달계산  yyy-MM-dd 형식
     * @since 1.0
     
     *************************************************************/
    public static String getYmdAddMonth(Date date, int add_month){
   		return date==null ? "" : getYmdAddMonth(toDateFormat(date, "yyyy-MM-dd"),  add_month);
    }
    /*************************************************************
     * 특정 날짜간 차 days
     * @since 1.0
     
     *************************************************************/
    public static int getSubDays(String ymd1, String ymd2){
    	try{
    		return toInt((toLong(toTimestamp(ymd1 + " 00:00:00")) - toLong(toTimestamp(ymd2 + " 00:00:00")))/24/60/60/1000+"");
    	}catch(NullPointerException npe){
    		return 0;
    	}catch(Exception e){
    		return 0;
    	}
    }
    public static int getSubDays(Date date1, Date date2){
    	return getSubDays(toDateFormat(date1, "yyyy-MM-dd") , toDateFormat(date2, "yyyy-MM-dd"));
    }
    public static int getSubDays(Date date1, String ymd2){
    	return getSubDays(toDateFormat(date1, "yyyy-MM-dd") , ymd2);
    }
    public static int getSubDays(String ymd1, Date date2){
    	return getSubDays(ymd1, toDateFormat(date2, "yyyy-MM-dd"));
    }
    /*************************************************************
     * 오늘 날짜와 특정일간 차 days
     * @since 1.0
     
     *************************************************************/
    public static int getSubDays(Date date){
    	return date==null ? 0 : getSubDays(toDateFormat(new Date(), "yyyy-MM-dd"), toDateFormat(date, "yyyy-MM-dd"));
    }
    public static int getSubDays(String ymd){
    	return ymd==null ? 0 : getSubDays(toDateFormat(new Date(), "yyyy-MM-dd"), ymd);
    }
    /*************************************************************
     * 특정 날짜간 차 hours
     *************************************************************/
    public static int getSubHours(Timestamp ymd1, Timestamp ymd2){
    	try{
    		return toInt((toLong(ymd1) - toLong(ymd2))/60/60/1000+"");
    	}catch(NullPointerException npe){
    		return 0;
    	}catch(Exception e){
    		return 0;
    	}
    }
    /*************************************************************
     * 특정 날짜간 차 minutes
     *************************************************************/
    public static int getSubMinutes(Timestamp ymd1, Timestamp ymd2){
    	try{
    		return toInt((toLong(ymd1) - toLong(ymd2))/60/1000+"");
    	}catch(NullPointerException npe){
    		return 0;
    	}catch(Exception e){
    		return 0;
    	}
    }	
	public static int[] getImgReSize(int img_max_wsz, int img_max_hsz, int[] img_sz) throws IOException{
		return getImgReSize(img_max_wsz, img_max_hsz, img_sz[0], img_sz[1]);
	}
	public static int[] getImgReSize(int[] img_max, int[] img_sz) throws IOException{
		return getImgReSize(img_max[0], img_max[1], img_sz[0], img_sz[1]);
	}
	public static int[] getImgReSize(int img_max_wsz, int img_max_hsz, int img_wsz, int img_hsz) throws IOException{

		double resize_w = img_wsz;
		double resize_h = img_hsz;
		double rate = 1;
		if(img_max_wsz<resize_w){
			rate = img_max_wsz / resize_w;
			resize_w = img_max_wsz;
			resize_h = resize_h * rate;
		}
		if(img_max_hsz<resize_h){
			rate = img_max_hsz / resize_h;
			resize_h = img_max_hsz;
			resize_w = resize_w * rate;
		}
		img_max_wsz = toInt(decimal(resize_w, "#"));
		img_max_hsz = toInt(decimal(resize_h, "#"));
		
		return new int[]{img_max_wsz, img_max_hsz};		
	}
	/*************************************************************
     * 파일 확장자
     * @since 1.0
     
     *************************************************************/
	public static String getFileType(String file_nm){
		return file_nm==null || file_nm.indexOf(".")==-1 ? "" : file_nm.substring(file_nm.lastIndexOf(".") + 1).toLowerCase();
	}
	/*************************************************************
     * 파일 이름
     * @since 1.0
     
     *************************************************************/
	public static String getFileName(String file_nm){
		if(file_nm==null || file_nm.indexOf(".")==-1 ){
			return "";
		}else{
			if(file_nm.lastIndexOf("/")>-1){
				return file_nm.substring(file_nm.lastIndexOf("/")+1, file_nm.lastIndexOf("."));
			}else{
				return file_nm.substring(file_nm.lastIndexOf("\\")+1, file_nm.lastIndexOf("."));
			}			
		}
	}
	
	/*************************************************************
     * 파일 이름
     * @since 1.0
     
     *************************************************************/
	public static String getFileFullName(String file_nm){
		if(file_nm==null ){
			return "";
		}else{
			if(file_nm.lastIndexOf("/")>-1){
				return file_nm.substring(file_nm.lastIndexOf("/")+1);
			}else{
				return file_nm.substring(file_nm.lastIndexOf("\\")+1);
			}			
		}
	}
	
	/*************************************************************
     * 윈도우 가로 해상도
     * @since 1.0
     
     *************************************************************/
	public static int getScreen_w_size(){
		return (int)java.awt.Toolkit.getDefaultToolkit().getScreenSize().getWidth();
	}
	
	/*************************************************************
     * 윈도우 세로 해상도
     * @since 1.0
     
     *************************************************************/	
	public static int getScreen_h_size(){
		return (int)java.awt.Toolkit.getDefaultToolkit().getScreenSize().getHeight();
	}
	
	/*************************************************************
     * URL 문서 읽기 
     * @since 1.0
     
     *************************************************************/	
	public static String getUrl_doc_read(String url){
		if(isUrlConnection(url)){
			// URL 파일 읽기
			StringBuffer textBuffer = new StringBuffer();
			try{
				InputStream fin = new URL(url).openStream();
				byte[] byte_size = new byte[4096];
				for(int n;(n=fin.read(byte_size))!=-1;){
					textBuffer.append(new String(byte_size, 0, n));
				}
			    fin.close();
			} catch (UnsupportedEncodingException uee) {
				textBuffer = new StringBuffer();
			} catch (Exception e) {
				textBuffer = new StringBuffer();
			}
			return textBuffer.toString();
		}else{
			return "";
		}
	}
	public static String getUrl_doc_read(String url, String encoding){
		if(isUrlConnection(url)){
			// URL 파일 읽기
			StringBuffer textBuffer = new StringBuffer();
			try{
				InputStream input = new URL(url).openStream();
				if(input!=null){
					InputStreamReader reader = new InputStreamReader(input, encoding);
					if(reader!=null){
						BufferedReader buffer = new BufferedReader(reader);
						if(buffer!=null){
							String inStr = "";
							while((inStr = buffer.readLine())!=null){
								textBuffer.append(inStr+"\n");
							}
							buffer.close();
						}
						reader.close();
					}
					input.close();
				}
			} catch (UnsupportedEncodingException uee) {
				textBuffer = new StringBuffer();
			} catch (Exception e) {
				textBuffer = new StringBuffer();
			}
			return textBuffer.toString();
		}else{
			return "";
		}
	}
	
	/*************************************************************
     * 브라우저 종류 찾기
     * @since 1.0
     
     *************************************************************/	
	public static String getBrowserVer(HttpServletRequest request){
		String browser_ver = "";
		if(request!=null){
			String user_agent = request.getHeader("user-agent");
			/* [user_agent 브라우저별 값 - os : windows7]
				Chrome : Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/8.0.552.215 Safari/534.10
				Opera : Opera/9.80 (Windows NT 6.1; U; ko) Presto/2.6.30 Version/10.63
				FireFox : Mozilla/5.0 (Windows; U; Windows NT 6.1; ko; rv:1.9.2.12) Gecko/20101026 Firefox/3.6.12
				IE9 : Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0) 
				IE8 : Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET CLR 1.1.4322)
				IE7 : Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET CLR 1.1.4322) 
				IE6 : Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 6.1; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET CLR 1.1.4322) 
			*/
			
			if(user_agent.indexOf("Firefox")>-1){
				browser_ver = "FIREFOX";
			}else if(user_agent.indexOf("Opera")>-1){
				browser_ver = "OPERA";
			}else if(user_agent.indexOf("Chrome")>-1){
				browser_ver = "CHROME";
			}else if(user_agent.indexOf("Safari")>-1){
				browser_ver = "SAFARI";			
			}else if(user_agent.indexOf("MSIE 10.0")>-1){
				browser_ver = "IE10.0";
			}else if(user_agent.indexOf("MSIE 9.0")>-1){
				browser_ver = "IE9.0";
			}else if(user_agent.indexOf("MSIE 8.0")>-1){
				browser_ver = "IE8.0";
			}else if(user_agent.indexOf("MSIE 7.0")>-1){
				browser_ver = "IE7.0";
			}else if(user_agent.indexOf("MSIE 6.0")>-1){
				browser_ver = "IE6.0";
			}else if(user_agent.indexOf("bingbot")>-1){
				browser_ver = "BINGBOT";
			}else if(user_agent.indexOf("NT")>-1){
				browser_ver = "IE";
			}
		}
		return browser_ver;
	}

	/*********************(boolean : is)**************************/
    /*************************************************************
     * 게시글의 new
     * @since 1.0
     
     *************************************************************/
    public static boolean isDaysNew(long value, int days){
    	return isDaysNew(toDate(value), days);
    }
    
    
    
    /*************************************************************
     * 게시글의 new
     * @since 1.0
     
     *************************************************************/
    public static boolean isDaysNew(Date value, int days){
    	if(value==null){
			return false;
		}else{
	    	Date date = new Date();
	    	String toDay = new SimpleDateFormat("yyyy.MM.dd.HH:mm:ss").format(date); // 오늘
	    	String startDay = new SimpleDateFormat("yyyy.MM.dd.HH:mm:ss").format(value); // 시작
	    	date.setTime(value.getTime()+(long)days*(long)24*(long)60*(long)60*(long)1000); // days기간 후
	    	String endDay = new SimpleDateFormat("yyyy.MM.dd.HH:mm:ss").format(date);
		
	    	if(toDay.compareTo(startDay)>=0 && toDay.compareTo(endDay)<=0){
	    		return true;
	    	}else{
	    		return false;
	    	}
		}
    }
    
    /*************************************************************
     * 두문자 비교
     * @since 1.0
     
     *************************************************************/
    public static boolean isEqual(String value1, String value2){
    	if(value1==null || value1.trim().equals("") || value1.equals("null"))
    		return false;
    	else if(value1.equals(value2))
    		return true;
    	else 
    		return false;
    }
    
    /*************************************************************
     * ID 타입의 글자 여부
     * @since 1.0
     
     *************************************************************/
    public static boolean isIDType(String value) {
    	if(value==null || value.length() == 0)
    		return false;
    	value = value.toUpperCase();
    	if(!('A' <= value.charAt(0) && value.charAt(0) <= 'Z'))
    		return false;
    	for(int i=1; i<value.length(); i++){
    		if(!('A' <= value.charAt(i) && value.charAt(i) <= 'Z'||
					'0' <= value.charAt(i) && value.charAt(i) <= '9'
					|| value.charAt(i)=='_'))
    			return false;
    	}
    	return true;
    }
    /*************************************************************
     * Null 확인
     * @since 1.0
     
     *************************************************************/
    public static boolean isEmpty(String value) {
    	return value==null || value.trim().length()==0;
    }
    /*************************************************************
     * FIREFOX 브라우저 확인
     * @since 1.0
     
     *************************************************************/
    public static boolean isFirefox(HttpServletRequest request) {
    	return getBrowserVer(request).equals("FIREFOX");
    }
    /*************************************************************
     * OPERA 브라우저 확인
     * @since 1.0
     
     *************************************************************/
    public static boolean isOpera(HttpServletRequest request) {
    	return getBrowserVer(request).equals("OPERA");
    }
    /*************************************************************
     * CHROME 브라우저 확인
     * @since 1.0
     
     *************************************************************/
    public static boolean isChrome(HttpServletRequest request) {
    	return getBrowserVer(request).equals("CHROME");
    }
    /*************************************************************
     * IE6.0 브라우저 확인
     * @since 1.0
     
     *************************************************************/
    public static boolean isIE6(HttpServletRequest request) {
    	return getBrowserVer(request).equals("IE6.0");
    }
    /*************************************************************
     * IE7.0 브라우저 확인
     * @since 1.0
     
     *************************************************************/
    public static boolean isIE7(HttpServletRequest request) {
    	return getBrowserVer(request).equals("IE7.0");
    }
    /*************************************************************
     * IE8.0 브라우저 확인
     * @since 1.0
     
     *************************************************************/
    public static boolean isIE8(HttpServletRequest request) {
    	return getBrowserVer(request).equals("IE8.0");
    }
    /*************************************************************
     * IE9.0 브라우저 확인
     * @since 1.0
     
     *************************************************************/
    public static boolean isIE9(HttpServletRequest request) {
    	return getBrowserVer(request).equals("IE9.0");
    }
    
    /*************************************************************
     * IE10.0 브라우저 확인
     * @since 1.0
     
     *************************************************************/
    public static boolean isIE10(HttpServletRequest request) {
    	return getBrowserVer(request).equals("IE10.0");
    }
    /*************************************************************
     * 문자열 확인 여부
     * @since 1.0
     
     *************************************************************/
    public static boolean isEqualValue(String value_str, String symbol, String cfvalue){
    	boolean validity = false;
    	if(value_str!=null && symbol!=null && cfvalue!=null){
	    	String[] value_str_array = value_str.split(symbol);
	    	
	    	for(String temp : value_str_array){
	    		if(temp.equals(cfvalue)){
	    			validity = true;
	    			break;
	    		}
	    	}
    	}
    	return validity;
    }
    /*************************************************************
     * 파일 이미지 확인 여부
     * @since 1.0
     
     *************************************************************/
    public static boolean isImageFile(String file_nm){
		return file_nm!=null && isEqualValue("gif,jpg,png,jpeg", ",", getFileType(file_nm));
    }
    /*************************************************************
     * 문자열 확인 여부
     * @since 1.0
     
     *************************************************************/
    public static boolean isIndexOfValue(String value_str, String symbol, String cfvalue){
    	boolean validity = false;
    	if(value_str!=null && symbol!=null && cfvalue!=null){
	    	String[] value_str_array = value_str.split(symbol);
	    	
	    	for(String temp : value_str_array){
	    		if(cfvalue.indexOf(temp)>-1){
	    			validity = true;
	    			break;
	    		}
	    	}
    	}
    	return validity;
    }
    /*************************************************************
     * 외부 URL 연동시 연결 상태 확인
     * @throws IOException 
     * @since 1.0
     
     *************************************************************/
    public static boolean isUrlConnection(String url) {
    	boolean isUrlOk = false;
    	if(url!=null){    	
	    	try{			
	    		URL urlobj = new URL(url);
	    		java.net.URLConnection con = urlobj.openConnection();
	    		con.setConnectTimeout(500); // 대기 시간 0.5초
	    		con.setReadTimeout(500); // 대기 시간 0.5초
	    		java.net.HttpURLConnection exitCode = (java.net.HttpURLConnection)con;
	    		isUrlOk = (exitCode.getResponseCode()+"").equals("200");	
	    	}catch(IOException e){
	    		isUrlOk = false;
	    	}catch(Exception e){
	    		isUrlOk = false;
	    	}
    	}
    	return isUrlOk;
    }
    
    
    /*************************************************************
     * select 선택
     * @since 1.1
     
     *************************************************************/
    public static String selected(String orgValue, String cfValue){
    	return orgValue!=null && orgValue.equals(cfValue)?"selected=\"selected\"":"";
    }
    public static String selected(int orgValue, String cfValue){
    	return selected(orgValue+"",cfValue);
    } 
    public static String selected(String orgValue, int cfValue){
    	return selected(orgValue,cfValue+"");
    }
    public static String selected(int orgValue, int cfValue){
    	return selected(orgValue+"",cfValue+"");
    }
    public static String selected(String orgValue, String symbol, String cfValue){
    	if(orgValue==null || symbol==null || cfValue==null){
    		return "";
    	}else{
    		return isEqualValue(orgValue, symbol, cfValue) ? "selected=\"selected\"":"";
    	}
    }
    public static String selected(int orgValue, String symbol, String cfValue){
    	return selected(orgValue+"", symbol, cfValue);
    }
    public static String selected(String orgValue, String symbol, int cfValue){
    	return selected(orgValue, symbol, cfValue+"");
    }
    /*************************************************************
     * checkbox 채크
     * @since 1.1
     
     *************************************************************/
    public static String checked(String orgValue, String cfValue){
    	return orgValue!=null && orgValue.equals(cfValue)?"checked=\"checked\"":"";
    }
    public static String checked(int orgValue, String cfValue){
    	return checked(orgValue+"", cfValue);
    }
    public static String checked(String orgValue, int cfValue){
    	return checked(orgValue, cfValue+"");
    }
    public static String checked(int orgValue, int cfValue){
    	return checked(orgValue+"", cfValue+"");
    }
    public static String checked(String orgValue, String symbol, String cfValue){
    	if(orgValue==null || symbol==null || cfValue==null){
    		return "";
    	}else{
    		return isEqualValue(orgValue, symbol, cfValue) ? "checked=\"checked\"":"";
    	}
    }
    public static String checked(int orgValue, String symbol, String cfValue){
    	return checked(orgValue+"", symbol, cfValue);
    }
    public static String checked(String orgValue, String symbol, int cfValue){
    	return checked(orgValue, symbol, cfValue+"");
    }
    
    /*************************************************************
     * 플래시 채크
     * @since 1.1
     
     *************************************************************/
    public static String flashWrite(String url,int w, int h, String id, String bg, String win, String title, String imagesrc){
    	return flashWrite(url, w+"", h+"", id, bg, win, title, imagesrc);
    }
    public static String flashWrite(String url,String w, String h, String id, String bg, String win, String title, String imagesrc){
    	if(toString(title).length()==0){
    		title = "비주얼 플래시 입니다.";
    	}
    	return flashWrite(url, w, h, id, bg, win, "playerMode=embedded", title, imagesrc, title);
    }
    public static String flashWrite(String url,int w, int h, String id, String bg, String win, String title, String imagesrc, String flash_text){
    	return flashWrite(url, w+"",  h+"", id, bg, win, "playerMode=embedded", title, imagesrc, flash_text);
    }
    public static String flashWrite(String url,String w, String h, String id, String bg, String win, String flash_vars, String title, String imagesrc, String flash_text){
    	if(toString(title).length()==0){
    		title = "비주얼 플래시 입니다.";
    	}
    	StringBuffer flashStr = new StringBuffer();
    	 // 클릭시 태두리 보임
    	flashStr.append("<object type=\"application/x-shockwave-flash\" data=\""+url+"\" width=\""+w+"\" height=\""+h+"\" id=\""+id+"\" align=\"middle\" title=\""+title+"\" style=\"outline:none\" > \n");  // title을 넣어도 됨.
    	flashStr.append("	<param name=\"allowScriptAccess\" value=\"always\" /> \n");
    	flashStr.append("	<param name=\"movie\" value=\""+url+"\" /> \n");
    	flashStr.append("	<param name=\"FlashVars\" value=\"" + flash_vars + "\" /> \n");
    	flashStr.append("	<param name=\"wmode\" value=\""+win+"\" /> \n");
    	flashStr.append("	<param name=\"menu\" value=\"false\" /> \n");
    	flashStr.append("	<param name=\"quality\" value=\"high\" />	\n");
    	
    	if(bg!=null && bg.length()>0){
    		flashStr.append("	<param name=\"bgcolor\" value=\""+bg+"\" /> \n");
    	}
    	flashStr.append("	"+flash_text+"\n");
    	if(imagesrc!=null && imagesrc.length()>0){
    		flashStr.append("	<img src=\""+imagesrc+"\" width=\""+w+"\" height=\""+h+"\" alt=\""+title+"\" />\n");
    		
    	}
    	 
    	flashStr.append("</object> \n");
    	return flashStr.toString();
    }
    
    /*************************************************************
     * 동영상 채크
     * @since 1.1
     
     *************************************************************/
    public static String movieWrite(HttpServletRequest request, String movie_file, int width, int height, String movie_title){
    	// defalut option
    	int AutoStart = 0;
    	int AutoSize = 0;
    	int AnimationAtStart = 1;
    	int DisplaySize = 0;
    	boolean EnableContextMenu = false;
    	int EnablePositionControls = -1;
    	int EnableFullScreenControls = 0;
    	int Mute = 0;
    	int stretchToFit = 0;
    	int ShowCaptioning = 0;
    	int ShowControls = 1;
    	int ShowAudioControls = 1;
    	int ShowDisplay = 0;
    	int ShowGotoBar = 0;
    	int ShowPositionControls = -1;
    	int ShowStatusBar = 1;
    	int ShowTracker = -1;
    	int Volume = 100;
    	int SendMouseClickEvents = -1;
    	
    	return movieWrite(request, movie_file, width, height, movie_title, AutoStart, AutoSize, AnimationAtStart, DisplaySize, EnableContextMenu, EnablePositionControls, EnableFullScreenControls, Mute, stretchToFit, ShowCaptioning, ShowControls, ShowAudioControls, ShowDisplay, ShowGotoBar, ShowPositionControls, ShowStatusBar, ShowTracker, Volume, SendMouseClickEvents);
    }
    public static String movieWrite(HttpServletRequest request, String movie_file, int width, int height, String movie_title, int AutoStart, int AutoSize, int AnimationAtStart, int DisplaySize, boolean EnableContextMenu, int EnablePositionControls, int EnableFullScreenControls, int Mute, int stretchToFit, int ShowCaptioning, int ShowControls, int ShowAudioControls, int ShowDisplay, int ShowGotoBar, int ShowPositionControls, int ShowStatusBar, int ShowTracker, int Volume, int SendMouseClickEvents){
    	if(isEqualValue("mp4,avi", ",", getFileType(movie_file))){
    		return movieWriteVideoTag(movie_file, width, height, movie_title);
    	}else{
    		return movieWriteObjectTag(request, movie_file, width, height, movie_title, AutoStart, AutoSize, AnimationAtStart, DisplaySize, EnableContextMenu, EnablePositionControls, EnableFullScreenControls, Mute, stretchToFit, ShowCaptioning, ShowControls, ShowAudioControls, ShowDisplay, ShowGotoBar, ShowPositionControls, ShowStatusBar, ShowTracker, Volume, SendMouseClickEvents);
    	}
    }
    
    private static String movieWriteObjectTag(HttpServletRequest request, String movie_file, int width, int height, String movie_title, int AutoStart, int AutoSize, int AnimationAtStart, int DisplaySize, boolean EnableContextMenu, int EnablePositionControls, int EnableFullScreenControls, int Mute, int stretchToFit, int ShowCaptioning, int ShowControls, int ShowAudioControls, int ShowDisplay, int ShowGotoBar, int ShowPositionControls, int ShowStatusBar, int ShowTracker, int Volume, int SendMouseClickEvents){
    	boolean isFireFox = isFirefox(request);
    	boolean isOpera = isOpera(request);
    	boolean isChrome = isChrome(request);
    	if(movie_file.indexOf("&amp;")==-1){
    		movie_file = movie_file.replaceAll("&", "&amp;");
    	}
    	
    	HashMap<String,String> typehash = new HashMap<String,String>();
    	/*
    	typehash.put("mpg", 	"vidio/x-ms-mpeg");
    	typehash.put("mpeg", 	"vidio/x-ms-mpeg");
    	typehash.put("avi", 	"vidio/x-ms-avi");
    	typehash.put("asf", 	"vidio/x-ms-asf");
    	typehash.put("asx", 	"vidio/x-ms-asf");
    	typehash.put("wm", 		"vidio/x-ms-wm");
    	typehash.put("wmv", 	"vidio/x-ms-wmv");
    	typehash.put("wvx", 	"vidio/x-ms-wvx");
    	typehash.put("mp3", 	"audio/x-ms-mp3");
    	typehash.put("mid",	 	"audio/x-ms-mid");
    	typehash.put("wav",	 	"audio/x-ms-wav");
    	typehash.put("wma", 	"audio/x-ms-wma");
    	typehash.put("wax", 	"audio/x-ms-wax");
    	*/
    	typehash.put("mpg", 	"application/x-mplayer2");
    	typehash.put("mpeg", 	"application/x-mplayer2");
    	typehash.put("avi", 	"application/x-mplayer2");
    	typehash.put("asf", 	"application/x-mplayer2");
    	typehash.put("asx", 	"application/x-mplayer2");
    	typehash.put("wm", 		"application/x-mplayer2");
    	typehash.put("wmv", 	"application/x-mplayer2");
    	typehash.put("wvx", 	"application/x-mplayer2");
    	typehash.put("mp3", 	"application/x-mplayer2");
    	typehash.put("mid",	 	"application/x-mplayer2");
    	typehash.put("wav",	 	"application/x-mplayer2");
    	typehash.put("wma", 	"application/x-mplayer2");
    	typehash.put("wax", 	"application/x-mplayer2");
    	typehash.put("ram", 	"application/x-mplayer2");
    	typehash.put("rm", 		"application/x-mplayer2");
    	
    	typehash.put("mov", 	"vidio/quicktime");
    	typehash.put("mp4", 	"vidio/quicktime");
    	
    	typehash.put("swf", 	"application/x-schockwave-flash");
    	typehash.put("swc", 	"application/x-schockwave-flash");
    	
    	String fileType = movie_file.substring(movie_file.lastIndexOf(".") + 1).toLowerCase();
    	String media_type = toString(typehash.get(fileType), "vidio/x-ms-wmv");
    	
     	String mms_plugin_file = "http://www.interoperabilitybridges.com/windows-media-player-firefox-plugin-download"; //"http://port25.technet.com/videos/downloads/wmpfirefoxplugin.exe";
     	String mms_menul_link = "http://support.mozilla.org/ko/kb/play-windows-media-files-in-firefox#w_euaeiiyiyi-ecio-ueia-oiyi";
    	StringBuffer movieStr = new StringBuffer();
    	
    	movieStr.append("<object "+ (isFireFox || isOpera || isChrome ? "type=\""+media_type+"\" data=\"" + movie_file +"\"" : "classid=\"CLSID:22D6f312-B0F6-11D0-94AB-0080C74C7E95\"") + " title=\""+movie_title+"\" width=\""+width+"\" height=\""+height+"\" > \n");
    	movieStr.append("	<param name=\"Filename\" value=\""+movie_file+"\" /> \n");
    	movieStr.append("	<param name=\"AutoStart\" value=\""+AutoStart+"\" /> \n");
    	movieStr.append("	<param name=\"AutoSize\" value=\""+AutoSize+"\" /> \n");
    	movieStr.append("	<param name=\"AnimationAtStart\" value=\""+AnimationAtStart+"\" /> \n");
    	movieStr.append("	<param name=\"DisplaySize\" value=\""+DisplaySize+"\" /> \n");
    	movieStr.append("	<param name=\"EnableContextMenu\" value=\""+EnableContextMenu+"\" /> \n");
    	movieStr.append("	<param name=\"EnablePositionControls\" value=\""+EnablePositionControls+"\" /> \n");
    	movieStr.append("	<param name=\"EnableFullScreenControls\" value=\""+EnableFullScreenControls+"\" /> \n");
    	movieStr.append("	<param name=\"Mute\" value=\""+Mute+"\" /> \n");
    	movieStr.append("	<param name=\"stretchToFit\"  value=\""+stretchToFit+"\" /> \n");
    	movieStr.append("	<param name=\"ShowCaptioning\" value=\""+ShowCaptioning+"\" /> \n");
    	movieStr.append("	<param name=\"ShowControls\" value=\""+ShowControls+"\" /> \n");
    	movieStr.append("	<param name=\"ShowAudioControls\" value=\""+ShowAudioControls+"\" /> \n");
    	movieStr.append("	<param name=\"ShowDisplay\" value=\""+ShowDisplay+"\" /> \n");
    	movieStr.append("	<param name=\"ShowGotoBar\" value=\""+ShowGotoBar+"\" /> \n");
    	movieStr.append("	<param name=\"ShowPositionControls\" value=\""+ShowPositionControls+"\" /> \n");
    	movieStr.append("	<param name=\"ShowStatusBar\" value=\""+ShowStatusBar+"\" /> \n");
    	movieStr.append("	<param name=\"ShowTracker\" value=\""+ShowTracker+"\" /> \n");
    	movieStr.append("	<param name=\"Volume\" value=\""+Volume+"\" /> \n");
    	movieStr.append("	<param name=\"SendMouseClickEvents\" value=\""+SendMouseClickEvents+"\" /> \n");
    	
    	movieStr.append("	"+ htmlSpecialChars(movie_title) +" \n");
    	if(isFireFox || isOpera || isChrome){
    		if(fileType.equals("wmv")){
    			/*
    			movieStr.append("<embed type=\"application/x-mplayer2\" pluginspage=\"http://www.microsoft.com/Windows/Downloads/Contents/Products/MediaPlayer/\" name=\"MediaPlayer\" src=\"" + movie_file +"\""); 
    			movieStr.append(" showcontrols=\""+ShowControls+"\"");
    			movieStr.append(" showpositioncontrols=\""+ShowPositionControls+"\"");
    			movieStr.append(" showaudiocontrols=\"" +ShowAudioControls+"\"");
    			movieStr.append(" showtracker=\""+ShowTracker+"\"");
    			movieStr.append(" showdisplay=\""+ShowDisplay+"\"");
    			movieStr.append(" showstatusbar=\""+ShowStatusBar+"\"");
    			movieStr.append(" showgotobar=\""+ShowGotoBar+"\"");
    			movieStr.append(" showcaptioning=\""+ShowCaptioning+"\"");
    			movieStr.append(" autostart=\""+AutoStart+"\"");
    			movieStr.append(" animationatstart=\""+AnimationAtStart+"\"");
    			movieStr.append(" width=\""+width+"\"");
    			movieStr.append(" height=\""+height+"\"> \n");
    			
    			movieStr.append(" 플레이어 설치 안내<br />\n");
	    		movieStr.append(" - 동영상을 재생이 되지 않을 때에는 <a href=\""+mms_plugin_file+"\" target=\"_blank\" title=\"새창\"><span style=\"color:#df0000\">mms 플러그인</span></a>을 설치 후 이용 바랍니다.<br /> \n");
	    		if(isOpera){
	    			movieStr.append(" - 플러그인 설치 후. 상단의 [메뉴(Menu)] 클릭 다음 [설정(Settings)] 다음 [환경설정(Perferences...)] 다음  [고급설정(Advanced)] 탭 선택 다음 왼쪽 [프로그램(Programs)] 선택 다음 [추가(Add..)]버튼 다음 열린 새창에서 [프로토콜(Protocol)]란에 'mms'입력후 [확인(OK)] 버튼 클릭 \n");
	    		}
    			movieStr.append("</embed>\n");
    			*/
    			movieStr.append(" <p>플레이어 설치 안내</p>\n");
	    		movieStr.append(" <ol> \n");
	    		movieStr.append(" 	<li>동영상을 재생이 되지 않을 때에는 <a href=\""+mms_plugin_file+"\" target=\"_blank\" title=\"새창\"><span style=\"color:#df0000\">mms 플러그인</span></a>을 설치 후 이용 바랍니다.</li> \n");
	    		if(isOpera){
	    			movieStr.append(" 	<li>플러그인 설치 후. 상단의 [메뉴(Menu)] 클릭 다음 [설정(Settings)] 다음 [환경설정(Perferences...)] 다음  [고급설정(Advanced)] 탭 선택 다음 왼쪽 [프로그램(Programs)] 선택 다음 [추가(Add..)]버튼 다음 열린 새창에서 [프로토콜(Protocol)]란에 'mms'입력후 [확인(OK)] 버튼 클릭 </li> \n");
	    		}else if(isChrome){
	    			movieStr.append(" 	<li>플러그인 설치 후. [설정] 클릭 / 화면 아래 [고급 설정 표시]  / [콘텐츠설정] / [개별 플러그인 사용중지...] [Windows Media Player - 버전...] 내용에서 사용 채크 / 브라우저를 닫고 새로 열면 됩니다. </li> \n");
	    		}else if(isFireFox){
	    			movieStr.append(" 	<li>설치 메뉴얼 <a href=\""+mms_menul_link+"\" target=\"_blank\" title=\"새창\">[링크]</a></li> \n");
	    		}
	    		movieStr.append(" </ol> \n");
	    	
    		}else{
    			movieStr.append("동영상 플레이를 지원하지 않습니다. <a href=\""+movie_file+"\" target=\"_blank\" title=\"새창\">동영상 다운받기</a>\n");
    		}
    	}
    	
    	
    	movieStr.append("</object> \n");
    	return movieStr.toString();
    }
    
    public static String movieWriteVideoTag(String movie_file, int width, int height, String movie_title){
    	StringBuffer videoTag = new StringBuffer(); 
    	videoTag.append("<video width=\""+ width+"\" height=\""+ height+"\" controls=\"controls\" title=\""+movie_title+"\">\n");
    	String fileType = getFileType(movie_file);
    	videoTag.append("	<source src=\""+movie_file+"\" type=\"video/"+fileType+"\" />\n");
    	videoTag.append("	동영상 플레이를 지원하지 않습니다. <a href=\""+movie_file+"\" target=\"_blank\" title=\"새창\">동영상 다운받기</a>\n");
    	videoTag.append("</video>\n");
    	return videoTag.toString();
    }
    
    /*************************************************************
     * 팝업
     * @since 1.1
     
     *************************************************************/
    public static String popupScript(String uri, String subject, int width, int height){
    	return popupScript(uri, subject, width, height, "", "");
    }
    public static String popupScript(String uri, String subject, int width, int height, String scrollbars, String resizable){
   		return "window.open("+("this.href".equals(uri)?"this.href":"\""+uri+"\"")+",\""+subject+"\",\"width="+width+",height="+height+",top=\"+((screen.height) ? (screen.height-800)/2 : 0)+\",left=\"+((screen.width) ? (screen.width-800)/2 : 0)+\",scrollbars="+(scrollbars==null || scrollbars.length()==0 ? "no": scrollbars)+",resizable="+(resizable==null || resizable.length()==0 ? "auto": resizable)+"\");";
    }
	public static String popupScript(String uri, String subject, int width, int height, int topPos, int leftPos, String scrollbars, String resizable){
    	return "window.open("+("this.href".equals(uri)?"this.href":"\""+uri+"\"")+",\""+subject+"\",\"width="+width+",height="+height+",top="+topPos+",left="+leftPos+",scrollbars="+(scrollbars==null || scrollbars.length()==0 ? "auto": scrollbars)+",resizable="+(resizable==null || resizable.length()==0 ? "no": resizable)+"\");";
	}
	
	/*************************************************************
     * 문자열 교체
     * @since 1.0
     
     *************************************************************/
	public static String replaceAll( String str, String s1){
		return replaceAll(str, s1, "");		
	}
	public static String replaceAll( String str, String s1, String s2 ){
		str = toString(str);
		if(s1!=null && s2!=null){
			StringBuffer result = new StringBuffer();
			if(s1.length()>0){				
				String s = str;
				int index1 = 0;
				int index2 = s.indexOf(s1);
		
				while(index2 >= 0) {
					result.append( str.substring(index1, index2) );
					result.append( s2 );
					index1 = index2 + s1.length();
					index2 = s.indexOf(s1, index1);
				}
				result.append( str.substring( index1 ) );
			}else{
				result.append(str);
			}
			return result.toString();
		}else{
			return str;
		}		
	}
	public static String replaceAll(String str, String[] s1_arr){
		return replaceAll(str, s1_arr, null);
	}
	public static String replaceAll(String str, String[] s1_arr, String[] s2_arr ){
		String return_str = str;
		if(s1_arr!=null && s1_arr.length>0){	
			for(int i=0; i<s1_arr.length; i++){
				if(s2_arr!=null && i<s2_arr.length){
					return_str = replaceAll(return_str, toString(s1_arr[i]), toString(s2_arr[i]));
				}else{
					return_str = replaceAll(return_str, toString(s1_arr[i]), "");
				}				
			}		
		}
		return return_str;
	}
	public static String replaceAll(String str, String s1str, String s2str, String split_symbol){
		return replaceAll(str, toStr_array(s1str, split_symbol), toStr_array(s2str, split_symbol));
	}
	/*************************************************************
	 * 문자열 교체 (소문자)
	 * @since 1.0
	 
	 *************************************************************/
	public static String replaceAllLowerCase( String str, String s1){
		return replaceAllLowerCase(str, s1, "");
	}
	public static String replaceAllLowerCase( String str, String s1, String s2 ){
		str = toString(str);
		if(s1!=null && s2!=null){
			StringBuffer result = new StringBuffer();
			if(s1.length()>0){
				
				String s = str.toLowerCase();
				s1 = s1.toLowerCase();
				s2 = s2.toLowerCase();
		
				int index1 = 0;
				int index2 = s.indexOf(s1);
		
				while(index2 >= 0) {
					result.append( str.substring(index1, index2) );
					result.append( s2 );
					index1 = index2 + s1.length();
					index2 = s.indexOf(s1, index1);
				}
				result.append( str.substring( index1 ) );
			}else{
				result.append(str);
			}
			return result.toString();
		}else{
			return str;
		}		
	}
	public static String replaceAllLowerCase(String str, String[] s1_arr){
		return replaceAllLowerCase(str, s1_arr, null);
	}
	public static String replaceAllLowerCase(String str, String[] s1_arr, String[] s2_arr ){
		String return_str = str;
		if(s1_arr!=null && s1_arr.length>0){			
			for(int i=0; i<s1_arr.length; i++){
				if(s2_arr!=null && i<s2_arr.length){
					return_str = replaceAllLowerCase(return_str, toString(s1_arr[i]), toString(s2_arr[i]));
				}else{
					return_str = replaceAllLowerCase(return_str, toString(s1_arr[i]), "");
				}				
			}		
		}
		return return_str;
	}
	
	/*************************************************************
     * 문자열 첫번재 교체
     * @since 1.0
     
     *************************************************************/
	public static String replaceOne( String str, String s1, String s2 ){
		if(str == null){
			return "";
		}else{
			String before = substringBefore(str, s1);
			String after = substringAfter2(str, s1);
			if(str.equals(before)){
				return str;
			}else{
				return before + s2 + after;
			}
		}
	}
	
	/*************************************************************
     * 지정한 Object 타입만 Map에 복사
     * @since 1.0
     
     *************************************************************/
	public static Map<String,Object> mapCopy(Map<String,Object> sorceMap, String ojbect_type_str){
		return mapCopy(sorceMap, null, ojbect_type_str);
	}
	public static Map<String,Object> mapCopy(Map<String,Object> sorceMap, Map<String,Object> returnMap, String ojbect_type_str){
		if(sorceMap==null){
			return new HashMap<String,Object>();
		}else{
			if(returnMap==null){
				returnMap = new HashMap<String,Object>();
			}
		
			if(sorceMap.size()>0){
				for(String key : sorceMap.keySet()){
					boolean isCopy = true;
					if(ojbect_type_str!=null && ojbect_type_str.length()>0&&(sorceMap.get(key)==null || !(("," + ojbect_type_str + "," ).indexOf(","+sorceMap.get(key).getClass().getCanonicalName()+",") >-1)) ){
						isCopy = false;
					}					
					if(isCopy){
						returnMap.put(key, sorceMap.get(key));
					}
		    	}
			}
			
			return returnMap;
		}
	}
	
	/*************************************************************************
	 * @제목		: select tag make | tagName:태그 이름/아이디, tagTitle:태그타이틀, tagData:태그 데이터(형식 a=1,b=a,c=4...), initValue:초기값 
     * @since 1.0
     
	 *************************************************************************/	
	public static String htmlTagSelect(String tagName, String tagTitle, String tagData, String initValue){
		return htmlTagSelect(tagName, tagTitle, tagData, ",", "=", initValue);
	}
	public static String htmlTagSelect(String tagName, String tagTitle, String tagData, String firstSymbol, String secondSymbol, String initValue){
		StringBuffer tagbuf = new StringBuffer();
		
		tagbuf.append("<select name=\""+tagName+"\" id=\""+tagName+"\" title=\"" + tagTitle + "\">\n");
		String[] data_arr = toStr_array(tagData, firstSymbol);
		tagbuf.append("	<option value=''>- " + tagTitle + " -</option>\n");
		for(String data2_str : data_arr){
			String[] data2_arr = toStr_array(data2_str, secondSymbol, 2);
			if(data2_arr[0].equals(initValue)){
				tagbuf.append("	<option value=\""+data2_arr[0]+"\" selected=\"selected\">"+data2_arr[1]+"</option>\n");
			}else{
				tagbuf.append("	<option value=\""+data2_arr[0]+"\">"+data2_arr[1]+"</option>\n");	
			}
			
		}
		tagbuf.append("</select>");
		return tagbuf.toString();
	}
	
	/*************************************************************************
	 * @제목		: radio tag make | tagName:태그 이름/아이디, tagData:태그 데이터(형식 a=1,b=a,c=4...), initValue:초기값 
     * @since 1.0
     
	 *************************************************************************/
	public static String htmlTagRadio(String tagName, String tagData, String initValue){
		return htmlTagRadio(tagName, tagData, ",", "=", initValue);
	}
	public static String htmlTagRadio(String tagName, String tagData, String firstSymbol, String secondSymbol, String initValue){
		StringBuffer tagbuf = new StringBuffer();
		String[] data_arr = toStr_array(tagData, firstSymbol);		
		for(int i=0; i<data_arr.length; i++){
			String data2_str = data_arr[i];
			String[] data2_arr = toStr_array(data2_str, secondSymbol, 2);
			if(data2_arr[0].equals(initValue)){
				tagbuf.append("<input type=\"radio\" name=\""+tagName+"\" id=\""+tagName+i+"\" value=\""+data2_arr[0]+"\" checked=\"checked\"/>");
			}else{
				tagbuf.append("<input type=\"radio\" name=\""+tagName+"\" id=\""+tagName+i+"\" value=\""+data2_arr[0]+"\"/>");
			}			
			tagbuf.append("<label for=\""+tagName+i+"\">"+data2_arr[1]+"</label>\n");
		}		
		return tagbuf.toString();
	}
	
	/*************************************************************************
	 * @제목		: checkbox tag make | tagName:태그 이름/아이디, tagData:태그 데이터(형식 a=1,b=a,c=4...), initValue:초기값 (01,02,03...) 
     * @since 1.0
     
	 *************************************************************************/
	public static String htmlTagCheckbox(String tagName, String tagData, String initValue){
		return htmlTagCheckbox(tagName, tagData, ",", "=", initValue);
	}
	public static String htmlTagCheckbox(String tagName, String tagData, String firstSymbol, String secondSymbol, String initValue){
		StringBuffer tagbuf = new StringBuffer();
		String[] data_arr = toStr_array(tagData, firstSymbol);		
		for(int i=0; i<data_arr.length; i++){
			String data2_str = data_arr[i];
			String[] data2_arr = toStr_array(data2_str, secondSymbol, 2);
			if(!Validity.isNull(initValue)&& isEqualValue(initValue, ",", data2_arr[0])){
				tagbuf.append("<input type=\"checkbox\" name=\""+tagName+"\" id=\""+tagName+i+"\" value=\""+data2_arr[0]+"\" checked=\"checked\"/>");
			}else{
				tagbuf.append("<input type=\"checkbox\" name=\""+tagName+"\" id=\""+tagName+i+"\" value=\""+data2_arr[0]+"\"/>");
			}			
			tagbuf.append("<label for=\""+tagName+i+"\">"+data2_arr[1]+"</label>\n");
		}		
		return tagbuf.toString();
	}
	
	/*************************************************************************
	 * @제목		: 스크립트 페이지 강제 이동
     * @since 1.0
     
	 *************************************************************************/	
	public static String parentLocation(String uri){
		return "<script>\n//<![CDATA[<!--\ntry{parent.window.location.href=\""+uri+"\";}catch(e){location.href=\""+uri+"\";}\n//-->]]>\n</script>";
	}
	/*************************************************************************
	 * @제목		: 스크립트 페이지 강제 이동
     * @since 1.0
     
	 *************************************************************************/	
	public static String location(String uri){
		return "<script>\n//<![CDATA[<!--\nlocation.href=\""+uri+"\";\n//-->]]>\n</script>";
	}
	/*************************************************************************
	 * @제목		: Html 태그 변환
     * @since 1.0
     
	 *************************************************************************/
	private static String htmlSpecialChars(String s){
		StringBuffer buffer = new StringBuffer();
		if(s!=null && s.length()>0){
			StringTokenizer st = new StringTokenizer(s, "&\"<>", true);
			String token;
			while(st.hasMoreTokens()) {
				token = st.nextToken();
				switch(token.charAt(0)) {
				case '&':	buffer.append("&amp;"); break;
				case '\"':	buffer.append("&quot;"); break;
				case '<':	buffer.append("&lt;"); break;
				case '>':	buffer.append("&gt;"); break;
				default:	buffer.append(token);
				}
			}
		}
		return buffer.toString();
	}

	/*************************************************************************
	* @제목		: 특수문자 역변환
	* @since	: 2021-09-25
	*************************************************************************/	
	public static String scriptFilterDec(String value) {
        if (value == null) {
            return null;
        }   
        
        String rtnVal = value.replaceAll("&amp;", "\\&").replaceAll("&amp;nbsp;", " ").replaceAll("&#35;", "\\#").replaceAll("&lt;", "\\<").replaceAll("&gt;", "\\>").replaceAll("&quot;", "\"").replaceAll("&#39;", "\\").replaceAll("&#37;", "\\%").replaceAll("&#40;", "\\(").replaceAll("&#41;", "\\)").replaceAll("&#43;", "\\+").replaceAll("&#47;", "\\/").replaceAll("&#46;", "\\.");
        return rtnVal;
    }
	
	/*************************************************************************
	* @제목		: 스마트폰 확인
	* @since	: 2017-09-04
	* @version 	: 1.0
	* @from		: afy0817@gmail.com
	*************************************************************************/
	public static boolean isMobile(HttpServletRequest request){
		boolean result = false;
		String userAgent = request.getHeader("user-agent").toLowerCase();
		String mobileAgent[] = {"iphone","ipod","symbos","iemobile","mobile","lgtelecom","android","blackberry","windows ce","lg","mot","samsung","sonyericsson","symbianos","nokia","iemobile","ppc"};
		for(int i = 0; i < mobileAgent.length; i++){
			if(userAgent.indexOf(mobileAgent[i])>-1){
				result = true;
				break;
			}
		}
		return result;
	}
}