package com.ssafy.marimo.common.config;

import com.nimbusds.oauth2.sdk.auth.JWTAuthentication;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JWTAuthenticationFilter jwtAuthenticationFilter;
    private final OAuth2LoginSuccessHandler oAuth2LoginSuccessHandler;
    private final CustomOAuth2UserService customOAuth2UserService;


    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        // 세션 비활성화 및 CSRF 비활성화 (REST API이므로)
        http.sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .csrf(csrf -> csrf.disable());

        // URL별 보안 설정
        http.authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/v1/**").permitAll()   // 인증 관련 엔드포인트는 공개
                .anyRequest().authenticated()                  // 기타 요청은 인증 필요
        );

        // OAuth2 로그인 설정: (구글, 카카오 등)
        http.oauth2Login(oauth -> oauth
                .authorizationEndpoint(cfg -> cfg.baseUri("/oauth2/authorize"))  // 인증 요청 URL 기본경로
                .redirectionEndpoint(cfg -> cfg.baseUri("/oauth2/callback/*"))   // 소셜 로그인 완료 후 콜백 경로
                .userInfoEndpoint(userInfo -> userInfo.userService(customOAuth2UserService))
                .successHandler(oAuth2LoginSuccessHandler)   // 커스텀 성공 핸들러
                .failureHandler((request, response, exception) -> {
                    // 실패 처리 (예: 리다이렉트 또는 에러 응답)
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                })
        );

        // 기본 폼 로그인, 로그아웃 비활성화 (REST API에서 사용하지 않음)
        http.formLogin(AbstractHttpConfigurer::disable);
        http.logout(AbstractHttpConfigurer::disable);

        // JWT 인증 필터 등록 – UsernamePasswordAuthenticationFilter 전에 실행
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

}
