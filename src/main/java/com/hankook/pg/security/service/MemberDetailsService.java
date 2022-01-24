package com.hankook.pg.security.service;

import com.hankook.pg.content.member.dao.MemberDAO;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.share.AESCrypt;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 실제 DB 에서 값을 조회 하여 UserDetails 타입 리턴 하는 서비스
 */
@Service
@RequiredArgsConstructor
public class MemberDetailsService implements UserDetailsService {

    private final MemberDAO memberDAO;


    @Override
    public UserDetails loadUserByUsername(String memId) throws UsernameNotFoundException {
        MemberDto memberDto = null;
        try {
            memberDto = memberDAO.getMemberinfo(memId);
            memberDto.setMemName(AESCrypt.decrypt(memberDto.getMemName()));
            memberDto.setMemBirth(AESCrypt.decrypt(memberDto.getMemBirth()));
            memberDto.setMemPhone(AESCrypt.decrypt(memberDto.getMemPhone()));
            memberDto.setMemEmail(AESCrypt.decrypt(memberDto.getMemEmail()));
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (InvalidKeyException e) {
            e.printStackTrace();
        } catch (InvalidAlgorithmParameterException e) {
            e.printStackTrace();
        } catch (NoSuchPaddingException e) {
            e.printStackTrace();
        } catch (BadPaddingException e) {
            e.printStackTrace();
        } catch (IllegalBlockSizeException e) {
            e.printStackTrace();
        }

        if(memberDto == null) {
                throw new UsernameNotFoundException("아이디:"+memId+"를 찾을 수 없습니다.");
        }

        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_"+memberDto.getAuthCode()));

        return new Member(memberDto,authorities);
    }

}
