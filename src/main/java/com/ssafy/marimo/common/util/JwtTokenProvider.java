package com.ssafy.marimo.common.util;

import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.UnAuthorizedException;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.List;

@Component
public class JwtTokenProvider {

    // application.yml 등에 설정된 값 주입
    @Value("${app.jwt.secret}")
    private String SECRET_KEY;
    @Value("${app.jwt.access-expiration}")
    private long ACCESS_TOKEN_EXPIRATION;    // 밀리초
    @Value("${app.jwt.refresh-expiration}")
    private long REFRESH_TOKEN_EXPIRATION;   // 밀리초

    // JWT 생성 - Access Token (권한 포함)
    public String generateAccessToken(UserDetails user) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + ACCESS_TOKEN_EXPIRATION);
        // 클레임에 username과 권한 목록 저장
        Claims claims = Jwts.claims().setSubject(user.getUsername());
        claims.put("roles", user.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority).toList());
        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(now)
                .setExpiration(expiry)
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    // JWT 생성 - Refresh Token (권한 없이 사용자 식별자만 또는 랜덤 UUID)
    public String generateRefreshToken(UserDetails user) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + REFRESH_TOKEN_EXPIRATION);
        // Refresh Token에는 권한 정보 없이 사용자식별만 또는 간단한 식별값
        return Jwts.builder()
                .setSubject(user.getUsername())
                .setIssuedAt(now)
                .setExpiration(expiry)
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
        // ※ RefreshToken을 JWT가 아닌 랜덤 문자열로 할 경우 이 메서드 대신 UUID 생성 등으로 대체
    }

    // 토큰에서 subject (username) 추출
    public String getUsernameFromToken(String token) {
        return parseClaims(token).getBody().getSubject();
    }

    // 토큰에서 권한 리스트 추출
    @SuppressWarnings("unchecked")
    public List<String> getRolesFromToken(String token) {
        Claims claims = parseClaims(token).getBody();
        return (List<String>) claims.get("roles");
    }

    // JWT 토큰의 유효성 검사 (서명 및 만료 확인)
    public boolean validateToken(String token) {
        try {
            parseClaims(token);  // 내부적으로 서명,만료 확인함
            return true;
        } catch (SecurityException | MalformedJwtException e) {
            // 잘못된 JWT 서명 또는 구조
            return false;
        } catch (ExpiredJwtException e) {
            // 만료된 JWT
            return false;
        } catch (UnsupportedJwtException e) {
            // 지원되지 않는 JWT
            return false;
        } catch (IllegalArgumentException e) {
            // 빈 토큰
            return false;
        }
    }

    // JWT Parser 획득 (Claims 반환)
    private Jws<Claims> parseClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token);
    }

    // SigningKey 객체 생성 (SECRET_KEY는 Base64 인코딩된 문자열 가정)
    private Key getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(SECRET_KEY);
        return Keys.hmacShaKeyFor(keyBytes);
    }
}
