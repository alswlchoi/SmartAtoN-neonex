package com.hankook.pg.security.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hankook.pg.security.msg.SecurityMessages;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;

/**
 * 인증 후 권한 확인에서 거절 되었을 경우 사용되는 handler
 */
@Component
@RequiredArgsConstructor
public class LoginAccessDeniedHandler implements AccessDeniedHandler {

    private final ObjectMapper objectMapper;
    private final RedirectStrategy redirectStrategy = new DefaultRedirectStrategy() ;

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException) throws IOException, ServletException {

        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            response.setContentType(MediaType.APPLICATION_JSON_VALUE);
            response.sendError(HttpServletResponse.SC_FORBIDDEN, SecurityMessages.ACCESS_DENIED.getErrorMsg());
        } else {
        	response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        	System.out.println("권한 없음");
//        	response.sendError(HttpServletResponse.SC_FORBIDDEN, SecurityMessages.ACCESS_DENIED.getErrorMsg());
            String deniedUrl = "/denied?exception="+ URLEncoder.encode(SecurityMessages.ACCESS_DENIED.getErrorMsg(), "UTF-8");
            redirectStrategy.sendRedirect(request, response, deniedUrl);

        }
    }
}
