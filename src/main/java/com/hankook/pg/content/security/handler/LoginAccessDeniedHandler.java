package com.hankook.pg.content.security.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hankook.pg.content.security.msg.SecurityMessages;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

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
            String deniedUrl = "/denied?exception="+ SecurityMessages.ACCESS_DENIED.getErrorMsg();
            redirectStrategy.sendRedirect(request, response, deniedUrl);
        }
    }
}
