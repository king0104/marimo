package com.ssafy.marimo.common.util;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Component;

@Component
public class AccessTokenUtil {

    private final JWTUtil jwtUtil;

    public AccessTokenUtil(JWTUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    /**
     * HttpServletRequest의 Authorization 헤더에서 Bearer 토큰을 추출합니다.
     */
    public String extractToken(HttpServletRequest request) {
        String authorization = request.getHeader("Authorization");
        if (authorization != null && authorization.startsWith("Bearer ")) {
            return authorization.substring(7);
        }
        return null;
    }

    /**
     * 요청 헤더의 토큰에서 암호화된 memberId 클레임을 추출합니다.
     */
    public String getEncryptedMemberId(HttpServletRequest request) {
        String token = extractToken(request);
        if (token != null) {
            return jwtUtil.getMemberId(token);
        }
        return null;
    }
}
