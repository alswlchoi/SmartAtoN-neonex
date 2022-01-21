package com.hankook.pg.security.factory;

import com.hankook.pg.content.login.service.LoginService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.stereotype.Component;

import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;

@Component
@RequiredArgsConstructor
public class UrlResourcesMapFactory implements FactoryBean<LinkedHashMap<RequestMatcher, List<ConfigAttribute>>> {

    private final LoginService loginService;
    private LinkedHashMap<RequestMatcher,List<ConfigAttribute>> resourceMap;

    /**
     * DB 에서 전체 권한에 따른 접속 URL 을 가져와서 LinkedHashMap 에 등록 한뒤 해당 resourceMap 리턴
     */
    @Override
    public LinkedHashMap<RequestMatcher, List<ConfigAttribute>> getObject() throws SQLException {
        if(resourceMap == null) {
            resourceMap = loginService.getMenuList();
        }
        return resourceMap;
    }

    @Override
    public Class<?> getObjectType() {
        return null;
    }

    @Override
    public boolean isSingleton() {
        return FactoryBean.super.isSingleton();
    }
}
