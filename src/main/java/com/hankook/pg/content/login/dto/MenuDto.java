package com.hankook.pg.content.login.dto;

import lombok.*;

import java.util.HashMap;
import java.util.Set;

@Setter
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MenuDto {
    private String mParent;
    private String mName;
    private String mUrl;
    private String authCode;
    private String mUseYn;
}
