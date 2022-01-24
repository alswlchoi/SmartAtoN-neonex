package com.hankook.pg.common.util;

//import java.util.regex.Matcher;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;


public class Validity {
	
	public static int toInt(String value){
		int to_int = 0;
		if(value!=null && value.length()>0){
			try{
				to_int = Integer.parseInt(value);
			}catch(Exception e){
				to_int = 0;
			}
		}		
		return to_int;
	}
	
	public static boolean isPattern(String regex, String input){
		if(regex==null || input==null){
			return false;
		}else{
			try{
				return Pattern.matches(regex, input);
			}catch(PatternSyntaxException pe){
				return false;
			}catch(Exception e){
				return false;
			}
		}
	}

	/*************************************************************
     * 문자열 byte 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isByte(String input, int max_byte){
		return max_byte >= (isNull(input)? 0: input.getBytes().length);
	}
	
	public static boolean isByte(String input, int max_byte,  boolean required){
		return !required&&isNull(input) || !isNull(input)&&isByte(input, max_byte);
	}
	
	/*************************************************************
     * 핸드폰번호 정규식 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isCellNo(String input){
		return isPattern("\\d{3}-\\d{3,4}-\\d{4}", input);
	}
	public static boolean isCellNo(String input, boolean required){
		return !required&&isNull(input) || !isNull(input)&&isCellNo(input);
	}
	/*************************************************************
     * 날짜 타입(yyyy-MM-dd) 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isDateType(String input){
		String cfinput = "";
		if(input!=null && input.length()>0){
			try{
				cfinput = new SimpleDateFormat("yyyy-MM-dd").format(Timestamp.valueOf(input + " 00:00:00"));
			}catch(NullPointerException npe){
				cfinput = "";
			}catch(IllegalArgumentException iae){
				cfinput = "";
			}catch(Exception e){
				cfinput = "";
			}
		}
		return !isNull(input)&& input.equals(cfinput);
	}
	public static boolean isDateType(String input, boolean required){
		return !required&&isNull(input) || !isNull(input)&&isDateType(input);
	}
	/*************************************************************
     * 이메일 정규식 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isEmail(String input){
		return isPattern("\\w+[\\w.]*@[\\w.]+\\.\\w+", input);
	}
	public static boolean isEmail(String input, boolean required){
		return !required&&isNull(input) || !isNull(input)&&isEmail(input);
	}
	/*************************************************************
     * ID type 정규식 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isIdType(String input){
		return isPattern("[a-zA-Z]{1}\\w{3,30}", input);
	}
	public static boolean isIdType(String input, boolean required){
		return !required&&isNull(input) || !isNull(input)&&isIdType(input);
	}
	
	/*************************************************************
     * 정수 정규식 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isInteger(String input){
		return isPattern("[\\-\\+]?\\d*$", input);
	}
	public static boolean isInteger(String input, boolean required){
		return !required&&isNull(input) || !isNull(input)&&isInteger(input);
	}
	/*************************************************************
     * 숫자 정규식 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isNumber(String input){
		return isPattern("^[+-]?\\d*(\\.?\\d*)$", input);
	}
	public static boolean isNumber(String input, boolean required){
		return !required&&isNull(input) || !isNull(input)&&isNumber(input);
	}
		
	/*************************************************************
     * IP 정규식 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isIPaddress(String input){
		return isPattern("(1|2)?\\d?\\d([.](1|2)?\\d?\\d){3}$", input);
	}
	public static boolean isIPaddress(String input, boolean required){
		return !required&&isNull(input) || !isNull(input)&&isIPaddress(input);
	}
	/*************************************************************
     * null 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isNull(String input){
		return input==null || input.equals("null") || input.trim().length()==0;
	}
	/*************************************************************
     * null 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isNulls(String[] input){
		boolean chk = false;
		if(input!=null && input.length>0){
			for(int i=0; i<input.length; i++){
				if(isNull(input[i])){
					chk = true;
					break;
				}
			}
		}
		return chk;
	}
	/*************************************************************
     * 단순 암호(숫자) 
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isPasswrdBasic(String pwdstr){
		// 1. 글자수 확인
		boolean isLengthOk = pwdstr.length()>=4 && pwdstr.length()<=30;
		// 2. 숫자 사용 여부 확인
		boolean isNumberOk = false;
		try{
			isNumberOk = Integer.parseInt(pwdstr)>=0;
		}catch(NumberFormatException e){isNumberOk = false;}
		return isLengthOk && isNumberOk;
	}
	public static boolean isPasswrdBasic(String input, boolean required){
		return !required&&isNull(input) || !isNull(input)&&isPasswrdBasic(input);
	}
	/*************************************************************
     * 고급 암호(영어&숫자&특수문자)
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isPasswrd(String pwdstr){
		String alphabet_str = "abcdefghijklmnopqrstuvwxyz";
		String number_str = "0123456789";
		String etc_str = "`~!@#$%^&*()-_=+\\|[]{};:'\",.<>/?";
		String pwd_chk_str = alphabet_str + number_str + etc_str;
		// 1. 글자수 확인		
		boolean isLengthOk = pwdstr.length()>=8 && pwdstr.length()<=24;
		// 2. 알파벳 사용 여부 확인
		boolean isAlphabetOk = false;
		for(int i=0; i<alphabet_str.length(); i++){
			String alphabet = alphabet_str.substring(i, i+1);
			if(pwdstr.toLowerCase().indexOf(alphabet)>-1){
				isAlphabetOk = true;
				break;
			}
		}	
		// 3. 숫자 사용 여부 확인
		boolean isNumberOk = false;
		for(int i=0; i<number_str.length(); i++){
			String number = number_str.substring(i, i+1);
			if(pwdstr.indexOf(number)>-1){
				isNumberOk = true;
				break;
			}
		}	
		// 4. 특수 문자 사용 여부 확인
		boolean isEtcOk = false;
		for(int i=0; i<etc_str.length(); i++){
			String etc = etc_str.substring(i, i+1);
			if(pwdstr.indexOf(etc)>-1){
				isEtcOk = true;
				break;
			}
		}		
		// 5. 영어&숫자&특수문자 사용 여부 확인
		boolean isPwdOk = true;
		for(int i=0; i<pwdstr.length(); i++){
			String pwd_char = pwdstr.substring(i, i+1);
			if(pwd_chk_str.indexOf(pwd_char.toLowerCase())==-1){
				isPwdOk = false;
				break;
			}
		}
		return isLengthOk && isAlphabetOk && isNumberOk && isEtcOk && isPwdOk;
	}
	/*************************************************************
     * 고급 암호(영어&숫자) 
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isPasswrdAlphabetNumber(String pwdstr){
		String alphabet_str = "abcdefghijklmnopqrstuvwxyz";
		String number_str = "0123456789";
		// 1. 글자수 확인
		boolean isLengthOk = pwdstr.length()>=6 && pwdstr.length()<=30;
		// 2. 알파벳 사용 여부 확인
		boolean isAlphabetOk = false;
		for(int i=0; i<alphabet_str.length(); i++){
			String alphabet = alphabet_str.substring(i, i+1);
			if(pwdstr.toLowerCase().indexOf(alphabet)>-1){
				isAlphabetOk = true;
				break;
			}
		}	
		// 3. 숫자 사용 여부 확인
		boolean isNumberOk = false;
		for(int i=0; i<number_str.length(); i++){
			String number = number_str.substring(i, i+1);
			if(pwdstr.indexOf(number)>-1){
				isNumberOk = true;
				break;
			}
		}			
		return isLengthOk && isAlphabetOk && isNumberOk;
	}
	/*************************************************************
     * 고급 암호(영어&숫자 + 특수문자 허용) 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isPasswrdAlphabetNumberAllowSpecial(String pwdstr){
		String alphabet_str = "abcdefghijklmnopqrstuvwxyz";
		String number_str = "0123456789";
		String etc_str = "`~!@#$%^&*()-_=+\\|[]{};:'\",.<>/?";
		String pwd_chk_str = alphabet_str + number_str + etc_str;
		// 1. 글자수 확인		
		boolean isLengthOk = pwdstr.length()>=6 && pwdstr.length()<=30;
		// 2. 알파벳 사용 여부 확인
		boolean isAlphabetOk = false;
		for(int i=0; i<alphabet_str.length(); i++){
			String alphabet = alphabet_str.substring(i, i+1);
			if(pwdstr.toLowerCase().indexOf(alphabet)>-1){
				isAlphabetOk = true;
				break;
			}
		}	
		// 3. 숫자 사용 여부 확인
		boolean isNumberOk = false;
		for(int i=0; i<number_str.length(); i++){
			String number = number_str.substring(i, i+1);
			if(pwdstr.indexOf(number)>-1){
				isNumberOk = true;
				break;
			}
		}	
		// 4. 영어&숫자&특수문자 사용 여부 확인
		boolean isPwdOk = true;
		for(int i=0; i<pwdstr.length(); i++){
			String pwd_char = pwdstr.substring(i, i+1);
			if(pwd_chk_str.indexOf(pwd_char.toLowerCase())==-1){
				isPwdOk = false;
				break;
			}
		}
		return isLengthOk && isAlphabetOk && isNumberOk && isPwdOk;
	}
	public static boolean isPasswrd(String input, boolean required){
		return !required&&isNull(input) || !isNull(input)&&isPasswrd(input);
	}
	
	/*************************************************************
     * 전화 번호 정규식 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isTelNo(String input){
		return isPattern("\\d{2,3}-\\d{3,4}-\\d{4}", input);
	}
	public static boolean isTelNo(String input, boolean required){
		return !required&&isNull(input) || !isNull(input)&&isTelNo(input);
	}
	
	/*************************************************************
     * URL 정규식 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isURL(String input){
		//return isPattern("https?://(\\w*:\\w*@)?[-\\w.]+(:\\d+)?(/([\\w/_.]*(\\?\\S+)?)?)?", input);
		return !isNull(input) && (input.indexOf("http://")==0 || input.indexOf("https://")==0) && input.indexOf(".")>-1;
	}
	public static boolean isURL(String input, boolean required){
		return !required&&isNull(input) || !isNull(input)&&isURL(input);
	}
	/*************************************************************
     * 우편번호 정규식 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isZipCode(String input){
		return isPattern("\\d{5}", input);
	}
	public static boolean isZipCode(String input, boolean required){
		return !required&&isNull(input) || !isNull(input)&&isZipCode(input);
	}
	
	/*************************************************************
     * 법인 등록 번호 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isCorpRegNo(String input){
		input = input.replaceAll("-","");
		int str_len = input.length();
		if(str_len==13){
			int no_chk = toInt(input.substring(0,1));
			no_chk += toInt(input.substring(1,2))*2;
			no_chk += toInt(input.substring(2,3));
			no_chk += toInt(input.substring(3,4))*2;
			no_chk += toInt(input.substring(4,5));
			no_chk += toInt(input.substring(5,6))*2;
			no_chk += toInt(input.substring(6,7));
			no_chk += toInt(input.substring(7,8))*2;
			no_chk += toInt(input.substring(8,9));
			no_chk += toInt(input.substring(9,10))*2;
			no_chk += toInt(input.substring(10,11));
			no_chk += toInt(input.substring(11,12))*2;
			
			int cf_chk_no = 10 - (no_chk % 10);
			if(cf_chk_no>9){
				cf_chk_no = 0;
			}
			if(cf_chk_no==toInt(input.substring(12,13))){
				return true;
			}else{
				return false; // 틀린 법인번호
			}
		}else{
			return false; //틀린 법인번호
		}		
	}
	
	/*************************************************************
     * 사업자 번호 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isBizRegNo(String input){
		input = (input+"").replaceAll(" ","");
		if(isNull(input) || !isPattern("\\d{3}-\\d{2}-\\d{5}", input)){
			return false;
		}else{
			input = (input+"").replaceAll("-","").replaceAll(" ","");			
			int sumMod = 0;
			sumMod += toInt(input.substring(0,1));
			sumMod += toInt(input.substring(1,2)) * 3 % 10;
			sumMod += toInt(input.substring(2,3)) * 7 % 10;
			sumMod += toInt(input.substring(3,4)) * 1 % 10;
			sumMod += toInt(input.substring(4,5)) * 3 % 10;
			sumMod += toInt(input.substring(5,6)) * 7 % 10;
			sumMod += toInt(input.substring(6,7)) * 1 % 10;
			sumMod += toInt(input.substring(7,8)) * 3 % 10;
			sumMod += Math.floor(toInt(input.substring(8,9)) * 5 / 10);
			sumMod += toInt(input.substring(8,9)) * 5 % 10;
			sumMod += toInt(input.substring(9,10));
			
		    if (sumMod % 10 != 0) {
		       return false;
		    }else{
		    	return true;
		    }
		}
	}
	
	/*************************************************************
     * 주민 등록 번호 확인
     * @since 1.0
     * @red919 (red919@dofnetwork.co.kr)
     *************************************************************/
	public static boolean isJuminNo(String input){
		input = input.replaceAll("-","");
		int str_len = input.length();
		if(str_len==13){
			int no_chk = toInt(input.substring(0,1))*2;
			no_chk += toInt(input.substring(1,2))*3;
			no_chk += toInt(input.substring(2,3))*4;
			no_chk += toInt(input.substring(3,4))*5;
			no_chk += toInt(input.substring(4,5))*6;
			no_chk += toInt(input.substring(5,6))*7;
			no_chk += toInt(input.substring(6,7))*8;
			no_chk += toInt(input.substring(7,8))*9;
			no_chk += toInt(input.substring(8,9))*2;
			no_chk += toInt(input.substring(9,10))*3;
			no_chk += toInt(input.substring(10,11))*4;
			no_chk += toInt(input.substring(11,12))*5;
			
			int cf_chk_no = (11 - no_chk % 11) % 10;

			int sexno = toInt(input.substring(6,7));
			
			if(cf_chk_no>9){
				cf_chk_no = 0;
			}
			if(cf_chk_no!=toInt(input.substring(12,13))){
				return false;
			}else if(sexno<1 || sexno>4) {
				return false; 
			}else{
				return true;
			}
		}else{
			return false;
		}

	}
}
