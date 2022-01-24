package com.hankook.pg.share;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.util.Assert;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Utils
 *
 * @author Kyeongjin.Kim
 * @since 2019-06-12
 */
@Slf4j
public class Utils {

    /** 사용불가 아이디 목록 */
    private static final String[] ILLEGAL_USER_IDs = {"admin","administrator","manager","guest","test","scott","tomcat","root","user","operator","anonymous"};

    /**
     * 패스워드 SHA-512 암호화
     *
     * @param password 패스워드
     * @return
     */
    public static String convertSha512String(String password) {
        String salt = "skb";
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            md.update(salt.getBytes(StandardCharsets.UTF_8));
            byte[] bytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte aByte : bytes) {
                sb.append(Integer.toString((aByte & 0xff) + 0x100, 16).substring(1));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            log.error("convert sha512 exception", e);
            return null;
        }
    }

    /**
     * 사용불가 아이디 사용여부
     * @param userId 사용자 아이디
     * @return
     */
    public static boolean isIllegalUserId(String userId) {
        return Arrays.asList(ILLEGAL_USER_IDs).contains(userId);
    }

    /**
     * 문자열 내 연속된 문자 체크
     *
     * @param string		검증 대상 문자열
     * @param targetStrings 검증 시 사용될 연속된 문자열 배열
     * @param range			검증 자릿수 범위
     * @return
     */
    public static boolean containContinuousCharacters(String string, String[] targetStrings, int range) {

        int i, j;
        String x, y;
        String src, src2, pattern = "";

        for (i = 0; i < targetStrings.length; i++) {
            src = targetStrings[i];
            src2 = targetStrings[i]+targetStrings[i];
            for(j=0; j < src.length(); j++) {

                x = src.substring(j, j+1);
                y = src2.substring(j, j+range);
                pattern += "["+x+"]{"+range+",}|"; // [0]{4,}|0123|[1]{4,}|1234|...
                pattern += y+"|";
            }
        }
        pattern = pattern.substring(0, pattern.length()-1);
        Pattern continuousPtrn = Pattern.compile(pattern);
        Matcher matcher = continuousPtrn.matcher(string);

        return matcher.find();
    }

    /**
     * 임시 비밀번호 생성
     *
     * @param length    비밀번호 길이
     * @return
     */
    public static String generateTemporayPassword(int length) {
        char[] possibleChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789~`!@#$%^&*()-_=+[{]}\\|;:\'\",<.>/?".toCharArray();
        return RandomStringUtils.random(length, 0, possibleChars.length-1, false, false, possibleChars, new SecureRandom());
    }

    /**
     * 날짜를 문자열로 변환
     *
     * @param date      날짜 객체
     * @param format    형식
     * @return
     */
    public static String dateToString(Date date, String format) {
        Assert.notNull(format, "'format' is required.");

        if (date != null) {
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            return sdf.format(date);
        } else {
            return StringUtils.EMPTY;
        }
    }

    /**
     * 한달전 날짜 구하기
     *
     * @param format    형식
     * @return
     */
    public static String getMonthAgoDate(String format) {
        Calendar cal = Calendar.getInstance(new SimpleTimeZone(0x1ee6280,"KST"));
        cal.add(Calendar.MONTH , -1 );
        Date monthago = cal.getTime();
        SimpleDateFormat formatter = new SimpleDateFormat(format,Locale.getDefault());
            return formatter.format(monthago);
    }

    /**
     * 두달전 날짜 구하기
     *
     * @param format    형식
     * @return
     */
    public static String getMonth2AgoDate(String format) {
        Calendar cal = Calendar.getInstance(new SimpleTimeZone(0x1ee6280,"KST"));
        cal.add(Calendar.MONTH , -2 );
        Date monthago = cal.getTime();
        SimpleDateFormat formatter = new SimpleDateFormat(format,Locale.getDefault());
        return formatter.format(monthago);
    }

    /**
     * 문자열을 날짜로 변환
     *
     * @param dateString    날짜 문자열
     * @param format        형식
     * @return
     */
    public static Date stringToDate(String dateString, String format) {
        Assert.notNull(format, "'format' is required.");

        if (StringUtils.isNotBlank(dateString)) {
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            try {
                return sdf.parse(dateString);
            } catch (ParseException e) {
                e.printStackTrace();
                return null;
            }
        } else {
            return null;
        }
    }

    /**
     * 이름 마스킹 처리
     *
     * @param origin    이름 원본 문자열
     * @return          홍*동
     */
    public static String maskName(String origin) {
        String replaceString = origin;

        String pattern = "";
        if(origin.length() == 2) {
            pattern = "^(.)(.+)$";
        } else {
            pattern = "^(.)(.+)(.)$";
        }

        Matcher matcher = Pattern.compile(pattern).matcher(origin);

        if(matcher.matches()) {
            replaceString = "";

            for(int i=1;i<=matcher.groupCount();i++) {
                String replaceTarget = matcher.group(i);
                if(i == 2) {
                    char[] c = new char[replaceTarget.length()];
                    Arrays.fill(c, '*');

                    replaceString = replaceString + String.valueOf(c);
                } else {
                    replaceString = replaceString + replaceTarget;
                }

            }
        }

        return replaceString;
    }

    /**
     * 전화번호 마스킹
     *
     * @param origin    원본 전화번호
     * @return          010****5678
     */
    public static String maskPhoneNumber(String origin) {
        String replaceString = origin;

        Matcher matcher = Pattern.compile("^(\\d{3})-?(\\d{3,4})-?(\\d{4})$").matcher(origin);

        if(matcher.matches()) {
            replaceString = "";

            boolean isHyphen = false;
            if(origin.indexOf("-") > -1) {
                isHyphen = true;
            }

            for(int i=1;i<=matcher.groupCount();i++) {
                String replaceTarget = matcher.group(i);
                if(i == 2) {
                    char[] c = new char[replaceTarget.length()];
                    Arrays.fill(c, '*');

                    replaceString = replaceString + String.valueOf(c);
                } else {
                    replaceString = replaceString + replaceTarget;
                }

                if(isHyphen && i < matcher.groupCount()) {
                    replaceString = replaceString + "-";
                }
            }
        }

        return replaceString;
    }

    /**
     * 이메일 마스킹
     *
     * @param origin    원본 이메일 문자열
     * @return          dr*****@test.com
     */
    public static String maskEmail(String origin) {
        String replaceString = origin;

        Matcher matcher = Pattern.compile("^(..)(.*)([@]{1})(.*)$").matcher(origin);

        if(matcher.matches()) {
            replaceString = "";

            for(int i=1;i<=matcher.groupCount();i++) {
                String replaceTarget = matcher.group(i);
                if(i == 2) {
                    char[] c = new char[replaceTarget.length()];
                    Arrays.fill(c, '*');

                    replaceString = replaceString + String.valueOf(c);
                } else {
                    replaceString = replaceString + replaceTarget;
                }
            }

        }

        return replaceString;
    }


    public static final int getMonthsDifference(Date date1, Date date2) {

        Calendar calendar1 = new GregorianCalendar();
        Calendar calendar2 = new GregorianCalendar();

        calendar1.setTime(date1);
        calendar2.setTime(date2);

        int m1 = calendar1.get(Calendar.YEAR) * 12 + calendar1.get(Calendar.MONTH) + 1;
        int m2 = calendar2.get(Calendar.YEAR) * 12 + calendar2.get(Calendar.MONTH) + 1;
        return m2 - m1 + 1;
    }


    /**
     * 아이디 마스킹 처리
     *
     * @param origin    아이디 원본 문자열
     * @return          te** < test
     */
    public static String maskId(String origin) {
    	String result = origin.replaceAll("(?<=.{2}).","*");
        return result;
    }
}
