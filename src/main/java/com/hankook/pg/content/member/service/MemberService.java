package com.hankook.pg.content.member.service;
 
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
 
import com.hankook.pg.content.member.dao.MemberDAO;
import com.hankook.pg.content.member.dto.MemberDto;
 
@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberDAO memberDao;
    private final PasswordEncoder passwordEncoder;

    public List<MemberDto> getMmemberlist() throws Exception{
        return memberDao.getMmemberlist();
    }

    public int createMember(MemberDto memberDto) throws Exception {
        return memberDao.insertMember(MemberDto.builder()
                .memId(memberDto.getMemId())
                .memPwd(passwordEncoder.encode(memberDto.getMemPwd()))
                .memName(memberDto.getMemName())
                .memPhone(memberDto.getMemPhone())
                .memEmail(memberDto.getMemEmail())
                .memRegUser(memberDto.getMemId())
                .memUseYn("Y")
                .memRegDt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")))
                .compCode("C001")
                .authCode("A002")
                .build());
    }
}