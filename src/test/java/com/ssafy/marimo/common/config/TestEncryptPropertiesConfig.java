package com.ssafy.marimo.common.config;

import com.ssafy.marimo.common.properties.EncryptProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class TestEncryptPropertiesConfig {

    @Bean
    public EncryptProperties encryptProperties() {
        EncryptProperties props = new EncryptProperties();
        props.setKey("3eee1c782a80fa791af57e535541398a"); // 반드시 16바이트
        return props;
    }
}
