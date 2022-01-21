package com.hankook.pg.content.login.service;

import com.hankook.pg.content.login.dao.LoginDao;
import com.hankook.pg.content.login.dto.MenuDto;
import com.hankook.pg.security.config.UserMenuList;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.SecurityConfig;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

@Service
@RequiredArgsConstructor
public class LoginService {

    private final LoginDao loginDao;
    private final UserMenuList totalUserMenuList;

    /**
     * 최초 애플리케이션 기동 시 , 권한정보 업데이트 시 실행 되는 메소드 <br>
     * 권한별 메뉴 항목을 조회하여 리턴 한다. <br>
     * 시큐리티에서는 리턴 타입인 LinkedHashMap 을 사용 하고 인증 성공 이후 Authentication 에 List<MenuDto>를 넣어 준다. <br>
     * @return
     * @throws SQLException
     */
    public LinkedHashMap<RequestMatcher, List<ConfigAttribute>> getMenuList() throws SQLException {
        LinkedHashMap<RequestMatcher, List<ConfigAttribute>> result = new LinkedHashMap<>();
        List<MenuDto> menuList = loginDao.getMenuList();
        totalUserMenuList.setMenuList(new ArrayList<>());
        System.out.println("메뉴"+totalUserMenuList);

        menuList.forEach(menuDto -> {
            totalUserMenuList.getMenuList().add(menuDto);
            List<ConfigAttribute> configAttributeList = new ArrayList<>();
            String roleAuthCode = "ROLE_" + menuDto.getAuthCode();
            if(menuDto.getMUrl()!=null) {
            	if(result.containsKey(new AntPathRequestMatcher(menuDto.getMUrl()))) {
            		configAttributeList.addAll(result.get(new AntPathRequestMatcher(menuDto.getMUrl())));
            		configAttributeList.add(new SecurityConfig(roleAuthCode.equals("ROLE_A000") ? "ROLE_ANONYMOUS" : "ROLE_" + menuDto.getAuthCode()));
            	}else {
            		configAttributeList.add(new SecurityConfig(roleAuthCode.equals("ROLE_A000") ? "ROLE_ANONYMOUS" : "ROLE_" + menuDto.getAuthCode()));
            	}
            	result.put(new AntPathRequestMatcher(menuDto.getMUrl()),configAttributeList);
            }
        });

        result.entrySet().forEach(System.out::println);

        return result;
    }
}
