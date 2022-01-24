package com.hankook.pg.share.constant;

/**
 * AccountRole
 *
 * @author Kyeongjin.Kim
 * @since 2019-08-01
 */
public enum AccountRole {

    ROLE_ADMIN("ROLE_ADMIN", "최고관리자"),
    ROLE_OP("ROLE_OP", "시스템운영자"),
    ROLE_PM("ROLE_PM", "사업PM"),
    ROLE_CP("ROLE_CP", "업무지원"),
    ROLE_BP("ROLE_BP", "운영BP"),
    ROLE_LP("ROLE_LP", "리스사");

    private String role;
    private String roleName;

    AccountRole(String role, String roleName) {
        this.role = role;
        this.roleName = roleName;
    }

    public String getRole() {
        return role;
    }

    public String getRoleName() {
        return roleName;
    }
}
