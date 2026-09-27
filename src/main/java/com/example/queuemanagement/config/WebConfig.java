package com.example.queuemanagement.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns(
                        "http://localhost:*",
                        "http://192.168.0.101:*",
                        "http://192.168.0.105:*",
                        "https://frontend-djly.onrender.com"
                )             .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS");
    }
}
