package com.hankook.pg;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class HankookPgApplication extends SpringBootServletInitializer {

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application
				.sources(HankookPgApplication.class)
				.properties("spring_config_additional-location");
	}
	public static void main(String[] args) {
		SpringApplication.run(HankookPgApplication.class, args);
	}

}
