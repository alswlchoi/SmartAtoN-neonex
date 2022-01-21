package com.hankook.pg.content.security.msg;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public enum SecurityMessages {

    NOTFOUND_AUTHENTICATION("ERR001","제공 하지 않는 인증 방식 입니다."),
    BLANK_ID_OR_PASSWORD("ERR002","아이디 혹은 비밀번호가 비어 있습니다."),
    ACCESS_DENIED("ERR003","접근 권한이 없습니다."),
    ERROR_ID_OR_PASSWORD("ERR004","아이디 혹은 비밀번호가 잘못 되었습니다."),
    LOCK_ID("ERR005","계정이 잠겼습니다."),
    INPUT_PASSWORD_OVER("ERR006","비밀번호 입력횟수 초과"),
    USER_UNAUTHORIZED("ERR007","사용자 인증에 실패 하였습니다."),
    BAD_PASSWORD("ERR008", "비밀번호가 잘못 되었습니다.");


    private String errorCode;
    private String errorMsg;

    SecurityMessages(String errorCode, String errorMsg) {
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
    }

}
