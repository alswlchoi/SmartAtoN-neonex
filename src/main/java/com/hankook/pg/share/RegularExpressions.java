package com.hankook.pg.share;

/**
 * RegularExpressions
 *
 * @author Kyeongjin.Kim
 * @since 2019-06-12
 */
public final class RegularExpressions {

    /* 숫자 판별용 */
    public static final String NUMBERS_ONLY = "^[0-9]*$";
    /* 이메일 유효성 체크용 */
    public static final String EMAIL = "^[\\w-\\+]+(\\.[\\w]+)*@[\\w-]+(\\.[\\w]+)*(\\.[a-z]{2,})$";
    /* 전화번호 또는 휴대전화번호 식별용*/
    public static final String PHONE_NUMBER_FORMAT = "(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})";
    /* 사업자번호 형식 체크용 */
    public static final String BIZ_NUMBER_FORMAT = "(\\d{3})(\\d{2})(\\d{5})";
    /* 사용자 아이디 체크용 (4 ~ 20 자리 영(대, 소), 숫자 / 첫글자는 숫자 사용 불가) */
    public static final String USER_ID = "^[A-Za-z]{1}\\w{3,19}$";
    /* 패스워드 체크용 */
    public static final String PASSWORD = "^.*(?=.{8,16})(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-]).*$";

}
