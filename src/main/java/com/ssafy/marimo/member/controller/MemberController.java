package com.ssafy.marimo.member.controller;

import com.ssafy.marimo.common.annotation.CurrentMemberId;
import com.ssafy.marimo.member.dto.request.PostMemberFormRequest;
import com.ssafy.marimo.member.dto.request.PostMemberLoginRequest;
import com.ssafy.marimo.member.dto.response.PostMemberFormResponse;
import com.ssafy.marimo.member.dto.response.PostMemberLoginResponse;
import com.ssafy.marimo.member.service.CustomUserDetails;
import com.ssafy.marimo.member.service.MemberService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;


@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/members")
public class MemberController {

    private final MemberService memberService;

    @PostMapping
    public ResponseEntity<PostMemberFormResponse> register(
            @Valid @RequestBody PostMemberFormRequest postMemberFormRequest) {

        PostMemberFormResponse postMemberFormResponse = memberService.postMemberForm(postMemberFormRequest);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(postMemberFormResponse);
    }

    @PostMapping("/form")
    public ResponseEntity<PostMemberLoginResponse> login(
            @Valid @RequestBody PostMemberLoginRequest postMemberLoginRequest) {

        PostMemberLoginResponse postMemberLoginResponsee = memberService.postMemberLogin(postMemberLoginRequest);

        return ResponseEntity.status(HttpStatus.OK)
                .body(postMemberLoginResponsee);
    }

    @GetMapping("/current")
    public ResponseEntity<Integer> getCurrentMemberId(@CurrentMemberId Integer memberId) {
        if (memberId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        return ResponseEntity.ok(memberId);
    }

    @GetMapping("/currentmember")
    public ResponseEntity<PostMemberLoginResponse> getCurrentMemberId() {
        // SecurityContextHolder에서 현재 인증된 사용자 정보를 가져옵니다.
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (!(principal instanceof CustomUserDetails)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        CustomUserDetails userDetails = (CustomUserDetails) principal;
        // CustomUserDetails에 암호화된 memberId가 저장되어 있습니다.
        String encryptedMemberId = userDetails.getEncryptedMemberId();
        return ResponseEntity.ok(PostMemberLoginResponse.of(encryptedMemberId));
    }


}
