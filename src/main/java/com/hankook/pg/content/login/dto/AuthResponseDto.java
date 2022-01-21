package com.hankook.pg.content.login.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Builder;
import lombok.Data;

import java.util.Date;

@Data
@Builder
public class AuthResponseDto {

    @ApiModelProperty(notes = "아이디", position = 0)
    private String id;

    @ApiModelProperty(notes = "이름", position = 1)
    private String name;

    @ApiModelProperty(notes = "인증토큰", position = 2)
    private String accesstoken;

    @ApiModelProperty(notes = "조직코드", position = 3)
    private String orgnCode;

    @ApiModelProperty(notes = "조직명", position = 4)
    private String crprtName;

    @ApiModelProperty(notes = "휴대전화번호", position = 5)
    private String phoneNum;

    @ApiModelProperty(notes = "이메일", position = 6)
    private String email;

    @ApiModelProperty(notes = "권한", position = 7)
    private String role;

    @ApiModelProperty(notes = "등록일짜", position = 8)
    private Date regDt;

    @ApiModelProperty(notes = "수정날짜", position = 9)
    private String updDt;

    @ApiModelProperty(notes = "등록아이디", position = 10)
    private String regId;

    @ApiModelProperty(notes = "수정아이디", position = 11)
    private String updId;

    @ApiModelProperty(notes = "동의여부", position = 12)
    private String agreYn;

    @ApiModelProperty(notes = " 사용상태", position = 13)
    private String useYn;

    @ApiModelProperty(notes = "접속날짜", position = 14)
    private Date acceDt;

    @ApiModelProperty(notes = "실패수", position = 15)
    private int failCnt;

    @ApiModelProperty(notes = "비밀번호변경날짜", position = 16)
    private Date pwdChgDt;

    @ApiModelProperty(notes = "비밀번호변경여부", position = 17)
    private String pwdChgYn;

    @ApiModelProperty(notes = "메뉴정보", position = 18)
    private Object menuInfo;

    @ApiModelProperty(notes = "결과코드", position = 19)
    private String code;

    @ApiModelProperty(notes = "결과메시지", position = 20)
    private String message;

}
