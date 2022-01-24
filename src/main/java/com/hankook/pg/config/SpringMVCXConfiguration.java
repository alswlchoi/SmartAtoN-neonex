package com.hankook.pg.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class SpringMVCXConfiguration implements WebMvcConfigurer{

	@Value("${file.upload.uri}")
	private String resourceUri;

	@Value("${file.upload.location}")
	private String resourceLocation;

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler(resourceUri)
				.addResourceLocations("file://"+resourceLocation);
	}
	
}
