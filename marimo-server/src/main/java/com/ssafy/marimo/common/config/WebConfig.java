package com.ssafy.marimo.common.config;

import com.ssafy.marimo.common.converter.CurrentMemberIdArgumentResolver;
import com.ssafy.marimo.common.util.IdEncryptionUtil;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.List;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final IdEncryptionUtil idEncryptionUtil;

    public WebConfig(IdEncryptionUtil idEncryptionUtil) {
        this.idEncryptionUtil = idEncryptionUtil;
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(new CurrentMemberIdArgumentResolver(idEncryptionUtil));
    }
}