package com.hankook.pg.security.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hankook.pg.content.login.dto.MenuDto;
import com.hankook.pg.content.memHistory.dao.MemHistoryDao;
import com.hankook.pg.content.memHistory.vo.MemHistoryVo;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.security.config.UserMenuList;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
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

    @Value("${default.password}")
    private String defaultPassword;

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
        StringBuilder sb = new StringBuilder();
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

        //아이디 저장 체크
        System.out.println("아이디 = "+memberDto);
        System.out.println("체크값 = "+memberDto.getCheckbox());
//        System.out.println("체크값 = "+request.getParameter("checkbox"));
        Cookie cookie = new Cookie("userId", memberDto.getMemId());// 일단 쿠키 생성
        if (memberDto.getCheckbox() != null) { // 체크박스 체크여부에 따라 쿠키 저장 확인
        	response.addCookie(cookie);
		} else {
			cookie.setMaxAge(0);
			response.addCookie(cookie);
		}

	      //로그인 시 초기 비밀번호일 경우 이동 url을 변경페이지로 이동(인코딩전, 세션패스워드)
//	      if(passwordEncoder.matches(defaultPassword, memberDto.getMemPwd())) {
//	    	  if(passwordEncoder.matches(memberDto.getMemPwd(), passwordEncoder.encode(defaultPassword))) {
	    	  if(passwordEncoder.matches(defaultPassword, memberDto.getMemPwd()) && !memberDto.getAuthCode().equals("A001")) {
	    		  memberDto.setAuthDefaultUrl("/member/adminPwdModify");
	    	  }
//	      }
        sb.append(memberDto.getAuthCode())
        	.append(",").append(memberDto.getMemModDt())
        	.append(",").append(memberDto.getAuthDefaultUrl())
        	.append(",").append(memberDto.getMemUseYn());
        if(memberDto.getAuthCode().equals("A000")) {
//        	authentication = SecurityContextHolder.getContext().getAuthentication();
//            if(authentication !=null) {
            new SecurityContextLogoutHandler().logout(request,response,authentication);
//            }
        }

        objectMapper.writeValue(response.getWriter(),sb.toString());

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
