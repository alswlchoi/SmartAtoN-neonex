package com.hankook.pg.content.security;

import com.hankook.pg.content.security.msg.SecurityMessages;
import com.hankook.pg.content.security.service.Member;
import com.hankook.pg.content.security.service.MemberDetailsService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 *
 * Authentication Manager 에 있는 Authentication 에 대한 인증을 하는 Provider <br>
 *  실제로 DB 에 데이터를 조회하여 인증 한다.
 */
@RequiredArgsConstructor
public class LoginAuthenticationProvider implements AuthenticationProvider {
    private final MemberDetailsService memberDetailsService;
    private final PasswordEncoder passwordEncoder;

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {

        String userId = authentication.getName();
        String password = (String) authentication.getCredentials();

        Member member = (Member) memberDetailsService.loadUserByUsername(userId);

        if(!passwordEncoder.matches(password,member.getMemberDto().getMemPwd())) {
            throw new BadCredentialsException(SecurityMessages.BAD_PASSWORD.getErrorMsg());
        }

        if(member.getMemberDto().getMemUseYn().equals("N")) {
            throw new DisabledException(SecurityMessages.LOCK_ID.getErrorMsg());
        }


        return new UsernamePasswordAuthenticationToken(member.getMemberDto(),null,member.getAuthorities());

    }

    @Override
    public boolean supports(Class<?> authentication) {
        return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
    }
}
