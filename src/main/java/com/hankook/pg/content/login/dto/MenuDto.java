package com.hankook.pg.content.login.dto;

import lombok.*;

@Setter
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MenuDto {
	private String menuCode;
    private String mParent;
    private String mName;
    private String mUrl;
    private String authCode;
    private String mUseYn;
    private String mLevel;
    private int mSubTwo;
    private int mSubThree;
}
