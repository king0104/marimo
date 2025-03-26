package com.ssafy.marimo.member.service;

import com.ssafy.marimo.common.util.IdEncryptionUtil;
import com.ssafy.marimo.member.domain.Member;
import com.ssafy.marimo.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final MemberRepository memberRepository;
    private final IdEncryptionUtil idEncryptionUtil; // 추가

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        Member member = memberRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Member not found with email: " + email));
        String encryptedMemberId = idEncryptionUtil.encrypt(member.getId());
        return new CustomUserDetails(member, encryptedMemberId);
    }
}
