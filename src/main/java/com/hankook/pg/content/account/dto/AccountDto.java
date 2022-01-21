package com.hankook.pg.content.account.dto;

import com.hankook.pg.share.entity.AccountEntity;
import com.hankook.pg.share.RegularExpressions;
import com.hankook.pg.share.Utils;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import java.util.List;


@Data
@NoArgsConstructor
public class AccountDto {

    @NotBlank(message = "아이디는 필수 항목입니다.")
    @Pattern(regexp = RegularExpressions.USER_ID, message = "아이디는 영문(대,소문자) 및 숫자만 사용 가능하며 첫번째 문자는 영문만 가능합니다.")
    private String id;

    @NotBlank(message = "이름은 필수 항목입니다. ")
    private String name;

    private String pwd;

    @NotBlank(message = "조직 코드는 필수 항목입니다.")
    private String orgnCode;

    private String crprtName;

    @NotBlank(message = "휴대전화번호는 필수 항목입니다.")
    //@Pattern(regexp = RegularExpressions.PHONE_NUMBER_FORMAT, message = "유효하지 않은 휴대전화번호 형식입니다.")
    private String phoneNum;

    @NotBlank(message = "이메일은 필수 항목입니다.")
    @Pattern(regexp = RegularExpressions.EMAIL, message = "유효하지 않은 이메일 형식입니다.")
    private String email;

    @NotBlank(message = "권한은 필수 항목입니다.")
    private String role;

    private List<String> notifications;

    private String roleName;

    private String agreYn;

    private String acceDt;

    private Boolean updateSelf = false;

    @Builder
    public AccountDto(String id, String name, String orgnCode, String orgnName, String phoneNum, String email, String role, String roleName, String agreYn) {
        this.id = id;
        this.name = name;
        this.orgnCode = orgnCode;
        this.crprtName = orgnName;
        this.phoneNum = phoneNum;
        this.email = email;
        this.role = role;
        this.roleName = roleName;
        this.agreYn = agreYn;
    }

    public AccountDto(AccountEntity entity) {
        this.id = entity.getId();
        this.name = entity.getName();
        this.orgnCode = entity.getOrgnCode();
        this.crprtName = entity.getCrprtName();
        this.phoneNum = entity.getPhoneNum();
        this.email = entity.getEmail();
        this.role = entity.getRole();
        this.roleName = entity.getRoleName();
        this.agreYn = entity.getAgreYn();
        this.acceDt = Utils.dateToString(entity.getAcceDt(), "yyyy-MM-dd");
    }

    public AccountEntity convertToEntity() {
        AccountEntity entity = new AccountEntity();
        entity.setId(this.id);
        entity.setName(this.name);
        entity.setPwd(this.pwd != null ? Utils.convertSha512String(this.pwd) : null);
        entity.setOrgnCode(this.orgnCode);
        entity.setCrprtName(this.crprtName);
        entity.setPhoneNum(this.phoneNum);
        entity.setEmail(this.email);
        entity.setRole(this.role);
        entity.setRoleName(this.roleName);
        entity.setAgreYn(this.agreYn);
        return entity;
    }

}
