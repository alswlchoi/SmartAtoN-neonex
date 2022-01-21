package com.hankook.pg.content.security.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hankook.pg.content.login.service.LoginService;
import com.hankook.pg.content.security.LoginAuthenticationEntryPoint;
import com.hankook.pg.content.security.LoginAuthenticationProvider;
import com.hankook.pg.content.security.UrlFilterInvocationSecurityMetadataSource;
import com.hankook.pg.content.security.factory.UrlResourcesMapFactory;
import com.hankook.pg.content.security.filter.LoginProcessingFilter;
import com.hankook.pg.content.security.handler.LoginAccessDeniedHandler;
import com.hankook.pg.content.security.handler.LoginAuthenticationFailureHandler;
import com.hankook.pg.content.security.handler.LoginAuthenticationSuccessHandler;
import com.hankook.pg.content.security.service.MemberDetailsService;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.autoconfigure.security.servlet.PathRequest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.access.AccessDecisionManager;
import org.springframework.security.access.AccessDecisionVoter;
import org.springframework.security.access.vote.AffirmativeBased;
import org.springframework.security.access.vote.RoleVoter;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.access.intercept.FilterSecurityInterceptor;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class HankookSecurityConfig extends WebSecurityConfigurerAdapter {

    private final LoginAuthenticationSuccessHandler loginAuthenticationSuccessHandler;
    private final LoginAuthenticationFailureHandler loginAuthenticationFailureHandler;
    private final LoginAuthenticationEntryPoint loginAuthenticationEntryPoint;
    private final LoginAccessDeniedHandler loginAccessDeniedHandler;

    private final MemberDetailsService memberDetailsService;
    private final LoginService loginService;
    private final UrlResourcesMapFactory urlResourcesMapFactory;

    private final ObjectMapper objectMapper;

    private static final String[] permitAllMatchers = {
            "/"
            ,"/api/**"
            ,"/member/register"
            ,"/login"
            ,"/logout"
            ,"/index.html"
            ,"/favicon/**"
    };

    /**
     * Authentication Manager bean 을 불러 오는 메소드 <br>
     * Authentication Manager 는 Authentication Provider 들을 관리 함 <br>
     */
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    /**
     * 커스텀한 AuthenticationProvider 를 AuthenticationManager 에 등록 해 준다. <br>
     */
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.authenticationProvider(loginAuthenticationProvider());
    }

    /**
     * 시큐리티가 걸리지 말아야 할 /js /css /static 등의 리소스들을 시큐리티에서 제외 시킨다. <br>
     */
    @Override
    public void configure(WebSecurity web) throws Exception {
        web.ignoring().requestMatchers(PathRequest.toStaticResources().atCommonLocations());
    }

    /**
     * HttpSecurity 에 Security 를 거는 Configure 메소드 <br>
     * UsernamePasswordAuthenticationFilter 가 디폴트 로그인 시 사용되는 필터 인데 <br>
     * 이 전에 커스텀한 loginProcessingFilter() 를 적용 <br>
     * FilterSecurityInterceptor 는 필터 가장 마지막에 권한 별 접근을 필터링 하기위한 필터인데 <br>
     * 이 전에 커스텀한 customFilterInterceptor() 를 적용 <br>
     * 로그인 없이 인증이 필요한 곳에 접근 시 로그인 창으로 가도록 커스텀한 EntryPoint 로 이동<br>
     * 권한에 막혀 거절 될 경우 커스텀한 accessDeniedHandler 로 이동 <br>
     *
     */
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
            .mvcMatchers(permitAllMatchers).permitAll()
            .anyRequest().authenticated()
            .and()
            .addFilterBefore(loginProcessingFilter(), UsernamePasswordAuthenticationFilter.class)
            .addFilterBefore(customFilterInterceptor(),FilterSecurityInterceptor.class)
            .exceptionHandling()
            .authenticationEntryPoint(loginAuthenticationEntryPoint)
            .accessDeniedHandler(loginAccessDeniedHandler);
    }

    /**
     * password 인코딩 시 사용되는 bean <br>
     * BCrypt 알고리즘을 이용
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * authenticationProvider 를 커스텀한 bean
     */
    @Bean
    public AuthenticationProvider loginAuthenticationProvider() {
        return new LoginAuthenticationProvider(memberDetailsService,passwordEncoder());
    }

    /**
     * UsernamePasswordAuthenticationFilter 대신 사용하려고 설정한 custom bean
     */
    @Bean
    public LoginProcessingFilter loginProcessingFilter() throws Exception {
        LoginProcessingFilter loginProcessingFilter = new LoginProcessingFilter(objectMapper);
        loginProcessingFilter.setAuthenticationManager(authenticationManagerBean());
        loginProcessingFilter.setAuthenticationSuccessHandler(loginAuthenticationSuccessHandler);
        loginProcessingFilter.setAuthenticationFailureHandler(loginAuthenticationFailureHandler);
        return loginProcessingFilter;
    }

    /**
     * FilterSecurityInterceptor 대신 사용하려고 설정한 custom bean <br>
     * 이 필터를 통해 DB 에서 권한별 항목을 조회해와서 AntiPattern 을 동적으로 설정 한다. <br>
     */
    @Bean
    public FilterSecurityInterceptor customFilterInterceptor() throws Exception {
        FilterSecurityInterceptor filterSecurityInterceptor = new FilterSecurityInterceptor();
        filterSecurityInterceptor.setSecurityMetadataSource(urlFilterInvocationSecurityMetadataSource());
        filterSecurityInterceptor.setAccessDecisionManager(affirmativeBased());
        filterSecurityInterceptor.setAuthenticationManager(authenticationManagerBean());
        return filterSecurityInterceptor;
    }

    /**
     * 해당 bean 에서 DB 조회 하여 권한별 정보를 가져 오는 역할을 한다.
     * @return
     * @throws SQLException
     */
    @Bean
    public UrlFilterInvocationSecurityMetadataSource urlFilterInvocationSecurityMetadataSource() throws SQLException {
        return new UrlFilterInvocationSecurityMetadataSource(urlResourcesMapFactory.getObject(),loginService);
    }

    /**
     * FilterSecurityInterceptor 에서 사용되는 default 전략 AccessDecisionManager 가져옴
     * @return
     */
    private AccessDecisionManager affirmativeBased() {
        return new AffirmativeBased(getAccessDecisionVoters());
    }

    /**
     *  default Voter 인 RoleVoter 가져옴, ROLE 간 하이어라키 설정 안한 상태 <br>
     * @return
     */
    private List<AccessDecisionVoter<?>> getAccessDecisionVoters() {
        return Collections.singletonList(new RoleVoter());
    }

}
