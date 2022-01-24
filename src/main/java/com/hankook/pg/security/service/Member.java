package com.hankook.pg.security.service;

import com.hankook.pg.content.member.dto.MemberDto;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;

@Getter
@Setter
public class Member extends User {
    private MemberDto memberDto;

    public Member(MemberDto memberDto, Collection<? extends GrantedAuthority> authorities) {
        super(memberDto.getMemId(), memberDto.getMemPwd(), authorities);
        this.memberDto = memberDto;
    }
}
