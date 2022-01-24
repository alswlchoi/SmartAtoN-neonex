package com.hankook.pg.share.entity;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
public class AccountEntity {

    // 아이디
    private String id;

    // 이름
    private String name;

    // 비밀번호
    private String pwd;

    // 조직 코드
    private String orgnCode;

    // 조직명
    private String crprtName;

    // 휴대전화 번호
    private String phoneNum;

    // 이메일
    private String email;

    // 권한
    private String role;

    // 권한명
    private String roleName;

    // 등록 날짜
    private Date regDt;

    // 수정 날짜
    private String updDt;

    // 등록 아이디
    private String regId;

    // 수정 아이디
    private String updId;

    // 동의 여부
    private String agreYn;

    // 사용여부
    private String useYn;

    // 접속 날짜
    private Date acceDt;

    // 실패 수
    private int failCnt;

    // 비밀번호 변경 날짜
    private Date pwdChgDt;

    // 비밀번호 변경 여부
    private String pwdChgYn;

    @Builder
    public AccountEntity(String id, String name, String pwd, String orgnCode, String crprtName, String phoneNum, String email, String role, String roleName, Date regDt, String updDt, String regId, String updId, String agreYn, String useYn, Date acceDt, int failCnt, Date pwdChgDt, String pwdChgYn) {
        this.id = id;
        this.name = name;
        this.pwd = pwd;
        this.orgnCode = orgnCode;
        this.crprtName = crprtName;
        this.phoneNum = phoneNum;
        this.email = email;
        this.role = role;
        this.roleName = roleName;
        this.regDt = regDt;
        this.updDt = updDt;
        this.regId = regId;
        this.updId = updId;
        this.agreYn = agreYn;
        this.useYn = useYn;
        this.acceDt = acceDt;
        this.failCnt = failCnt;
        this.pwdChgDt = pwdChgDt;
        this.pwdChgYn = pwdChgYn;
    }
}
