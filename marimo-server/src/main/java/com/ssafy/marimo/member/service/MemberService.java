package com.ssafy.marimo.member.service;

import com.ssafy.marimo.common.util.IdEncryptionUtil;
import com.ssafy.marimo.common.util.JWTUtil;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.NotFoundException;
import com.ssafy.marimo.member.domain.Member;
import com.ssafy.marimo.member.domain.OauthProvider;
import com.ssafy.marimo.member.dto.request.PostMemberFormRequest;
import com.ssafy.marimo.member.dto.request.PostMemberLoginRequest;
import com.ssafy.marimo.member.dto.response.GetMemberNameResponse;
import com.ssafy.marimo.member.dto.response.PostMemberFormResponse;
import com.ssafy.marimo.member.dto.response.PostMemberLoginResponse;
import com.ssafy.marimo.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final IdEncryptionUtil idEncryptionUtil;

    @Transactional
    public PostMemberFormResponse postMemberForm(PostMemberFormRequest postMemberFormRequest) {

        if (memberRepository.existsByEmail(postMemberFormRequest.email())) {
            throw new IllegalArgumentException("이미 존재하는 이메일입니다.");
        }

        Member member = memberRepository.save(
                Member.create(
                        postMemberFormRequest.email(),
                        postMemberFormRequest.name(),
                        bCryptPasswordEncoder.encode(postMemberFormRequest.password()),
                        OauthProvider.FORM.name(), // DB에 "FORM"으로 저장됨
                        "",                        // 로컬 회원가입이므로 oauthId는 빈 문자열
                        10,                       // 기본 주유 기준값 (비즈니스 요구에 따라 변경)
                        true
                )
        );

        return PostMemberFormResponse.of(idEncryptionUtil.encrypt(member.getId()));
    }

    @Transactional(readOnly = true)
    public PostMemberLoginResponse postMemberLogin(PostMemberLoginRequest postMemberLoginRequest) {

        Member member = memberRepository.findByEmail(postMemberLoginRequest.email())
                .orElseThrow(() -> new NotFoundException("회원이 존재하지 않습니다."));

        if (!bCryptPasswordEncoder.matches(postMemberLoginRequest.password(), member.getPassword())) {
            throw new IllegalArgumentException("잘못된 비밀번호입니다.");
        }

        return PostMemberLoginResponse.of(idEncryptionUtil.encrypt(member.getId()));
    }

    public GetMemberNameResponse getName(Integer memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new NotFoundException(ErrorStatus.MEMBER_NOT_FOUND.getErrorCode()));

        return GetMemberNameResponse.of(
                member.getName()
        );
    }

}
