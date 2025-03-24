package com.ssafy.marimo.common.filter;

import com.ssafy.marimo.common.util.JwtTokenProvider;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;
    private final CustomUserDetailsService userDetailsService;
    private final RedisTemplate<String, Object> redisTemplate;

    public JwtAuthenticationFilter(JwtTokenProvider tokenProvider,
                                   CustomUserDetailsService userDetailsService,
                                   RedisTemplate<String, Object> redisTemplate) {
        this.jwtTokenProvider = tokenProvider;
        this.userDetailsService = userDetailsService;
        this.redisTemplate = redisTemplate;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain chain) throws ServletException, IOException {
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            // Authorization 헤더에 토큰이 없으면 그대로 다음 필터로 진행
            chain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7); // "Bearer " 이후 토큰 값
        // 1) 로그아웃된 토큰인지 체크 (Redis에 블랙리스트로 저장되었는지)
        String blacklistKey = "logoutToken:" + token;
        if (Boolean.TRUE.equals(redisTemplate.hasKey(blacklistKey))) {
            // 블랙리스트에 있는 토큰이면 인증 처리하지 않고 필터 종료
            // 응답으로 401을 보내거나, SecurityContext 없이 진행하면 최종 접근 거부됨
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid token (logged out)");
            return;
        }

        // 2) JWT 토큰 유효성 검사
        if (!jwtTokenProvider.validateToken(token)) {
            // 유효하지 않은 토큰일 경우
            chain.doFilter(request, response); // 그냥 필터 통과 (최종적으로 인증 실패로 처리됨)
            return;
        }

        // 3) 토큰이 유효한 경우, 사용자 정보 추출하여 Authentication 객체 생성
        String username = jwtTokenProvider.getUsernameFromToken(token);
        // Option 1: DB에서 사용자 정보 재조회
        UserDetails userDetails = userDetailsService.loadUserByUsername(username);
        // Option 2: 토큰에 권한 정보가 있다면 그것으로 UserDetails 생성 가능 (DB 부하 감소 위해)
        // List<GrantedAuthority> authorities = jwtTokenProvider.getRolesFromToken(token)
        //         .stream().map(SimpleGrantedAuthority::new).toList();
        // UserDetails userDetails = new User(username, "", authorities);

        UsernamePasswordAuthenticationToken auth =
                new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(auth);

        // 다음 필터로 진행
        chain.doFilter(request, response);
    }
}
