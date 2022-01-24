package com.hankook.pg.content.account.dto;


import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * ResetPwdDto
 *
 * @author Kyeongjin.Kim
 * @since 2019-06-13
 */
@Data
public class ResetPwdDto {

    @NotBlank(message = "휴대전화번호는 필수 항목입니다.")
    private String phoneNum;

    @NotBlank(message = "이메일은 필수 항목입니다.")
    private String email;

}
