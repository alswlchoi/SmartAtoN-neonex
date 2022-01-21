package com.hankook.pg.content.security.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hankook.pg.content.login.dto.MenuDto;
import com.hankook.pg.content.memHistory.dao.MemHistoryDao;
import com.hankook.pg.content.memHistory.vo.MemHistoryVo;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.content.security.config.UserMenuList;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Component
@RequiredArgsConstructor
public class LoginAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private final ObjectMapper objectMapper;
    private final UserMenuList userMenuList;
    private final MemHistoryDao memHistoryDao;

    /**
     *  인증 성공 시 실행 되는 메소드 <br>
     *  - 로그인 이력 DB 추가
     *  - 해당 유저의 ROLE 에 맞는 접속 가능한 페이지 목록 authentication 에 데이터 추가
     */
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException, IOException {
        MemberDto memberDto = (MemberDto) authentication.getPrincipal();

        memHistoryDao.insertHistory(MemHistoryVo.builder()
                .memId(memberDto.getMemId())
                .memName(memberDto.getMemName())
                .connectTime(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")))
                .build());

        memberDto.setMenuList(makeUserMenuList(memberDto));

        response.setStatus(HttpStatus.OK.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");
        objectMapper.writeValue(response.getWriter(),memberDto.getAuthCode());

    }

    private List<MenuDto> makeUserMenuList(MemberDto memberDto) {
        List<MenuDto> userMenuList = new ArrayList<>();
        this.userMenuList.getMenuList().forEach(res-> {
            if(res.getAuthCode().equals(memberDto.getAuthCode())) {
                userMenuList.add(res);
            }
        });
        return userMenuList;
    }
}
