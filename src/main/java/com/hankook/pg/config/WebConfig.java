package com.hankook.pg.config;

//import com.hankook.pg.interceptor.AuthInterceptor;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

//  @Autowired private AuthInterceptor authInterceptor;

  @Override
  public void addInterceptors(InterceptorRegistry registry) {
//    registry
//        .addInterceptor(authInterceptor)
//        .addPathPatterns("/**")
//        .excludePathPatterns("/login")
//        .excludePathPatterns("/accounts")
//        .excludePathPatterns("public/error");
  }
}
