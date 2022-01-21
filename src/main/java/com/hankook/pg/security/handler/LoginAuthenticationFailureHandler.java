package com.hankook.pg.security.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hankook.pg.security.msg.SecurityMessages;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.CredentialsExpiredException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 로그인 인증에 실패 시 exception 을 확인 하고 그에 맞는 메시지를 리턴 해 준다.
 */
@Component
@RequiredArgsConstructor
public class LoginAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {

    private final ObjectMapper objectMapper;

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {

        String errorMessage = SecurityMessages.ERROR_ID_OR_PASSWORD.getErrorMsg();

        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpStatus.UNAUTHORIZED.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);

        if(exception instanceof BadCredentialsException) {
            errorMessage = SecurityMessages.ERROR_ID_OR_PASSWORD.getErrorMsg();
        } else if(exception instanceof DisabledException) {
            errorMessage = SecurityMessages.LOCK_ID.getErrorMsg();
        } else if(exception instanceof CredentialsExpiredException) {
            errorMessage = SecurityMessages.INPUT_PASSWORD_OVER.getErrorMsg();
        }

        objectMapper.writeValue(response.getWriter(), errorMessage);
    }
}
