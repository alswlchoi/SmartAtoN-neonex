package com.hankook.pg.content.security.filter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hankook.pg.common.util.StringUtils;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.content.security.msg.SecurityMessages;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Login 하기 전 이용되는 필터 <br>
 * 해당 필터에서 UsernamePasswordAuthenticationToken 을 만들어 AuthenticationManager 에 Authentication 으로 등록 해 준다.
 */
public class LoginProcessingFilter extends AbstractAuthenticationProcessingFilter {

    private final ObjectMapper objectMapper;

    public LoginProcessingFilter(ObjectMapper objectMapper) {
        super(new AntPathRequestMatcher("/api/login"));
        this.objectMapper = objectMapper;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws AuthenticationException, IOException, ServletException {
        if(!isAjax(httpServletRequest)){
            throw new IllegalStateException(SecurityMessages.NOTFOUND_AUTHENTICATION.getErrorMsg());
        }

        MemberDto memberDto = objectMapper.readValue(httpServletRequest.getReader(), MemberDto.class);
        if(StringUtils.isEmpty(memberDto.getMemId()) || StringUtils.isEmpty(memberDto.getMemPwd())){
            throw new IllegalArgumentException(SecurityMessages.BLANK_ID_OR_PASSWORD.getErrorMsg());
        }

        return getAuthenticationManager().authenticate(new UsernamePasswordAuthenticationToken(memberDto.getMemId(),memberDto.getMemPwd()));
    }


    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }
}
