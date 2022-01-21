package com.hankook.pg.content.member.dto;


import com.hankook.pg.content.login.dto.MenuDto;
import lombok.*;

import java.util.List;

@Setter
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberDto {
    private String memId;
    private String memPwd;
    private String memName;
    private String authCode;
    private String compCode;
    private String memPhone;
    private String groupCode;
    private String memUserType;
    private String memUseYn;
    private String memRegDt;
    private String memModDt;
    private String memEmail;
    private String memModUser;
    private String memRegUser;

    private String authNm;

    private List<MenuDto> menuList;
}