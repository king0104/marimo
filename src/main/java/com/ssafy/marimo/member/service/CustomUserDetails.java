package com.ssafy.marimo.member.service;

import com.ssafy.marimo.member.domain.Member;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;

@Getter
@RequiredArgsConstructor
public class CustomUserDetails implements UserDetails {
    private final Member member;
    private final String encryptedMemberId; // 추가 필드


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        if (member.getEmail().endsWith("@admin.com")) {
            return Collections.singletonList(
                    new SimpleGrantedAuthority("ROLE_ADMIN")
            );
        }

        return Collections.singletonList(
                new SimpleGrantedAuthority("ROLE_USER") // 기본 사용자 역할
        );
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;

    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    @Override
    public String getPassword() {
        return member.getPassword();
    }

    @Override
    public String getUsername() {
        return member.getEmail();
    }
}
