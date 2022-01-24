package com.hankook.pg.security;

import com.hankook.pg.security.msg.SecurityMessages;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 인증되지 않은 상태로 인증 필요한 페이지 접근 시 사용되는 클래스
 */
@Component
public class LoginAuthenticationEntryPoint implements AuthenticationEntryPoint {

    private final RedirectStrategy redirectStrategy = new DefaultRedirectStrategy() ;

    @Override
    public void commence(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AuthenticationException e) throws IOException, ServletException {
        if ("XMLHttpRequest".equals(httpServletRequest.getHeader("X-Requested-With"))) {
            httpServletResponse.setCharacterEncoding("UTF-8");
            httpServletResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED, SecurityMessages.USER_UNAUTHORIZED.getErrorMsg());
        } else {
        	if(httpServletRequest.getRequestURL().toString().contains("admin") || httpServletRequest.getRequestURL().toString().contains("system")) {
        		redirectStrategy.sendRedirect(httpServletRequest, httpServletResponse, "/adminLogin");
        	}else {
        		redirectStrategy.sendRedirect(httpServletRequest, httpServletResponse, "/login");
        	}
        }
    }
}
