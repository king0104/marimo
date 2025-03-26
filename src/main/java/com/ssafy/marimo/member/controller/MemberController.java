package com.ssafy.marimo.member.controller;

import com.ssafy.marimo.common.util.AccessTokenUtil;
import com.ssafy.marimo.member.dto.request.PostMemberFormRequest;
import com.ssafy.marimo.member.dto.request.PostMemberLoginRequest;
import com.ssafy.marimo.member.dto.response.PostMemberFormResponse;
import com.ssafy.marimo.member.dto.response.PostMemberLoginResponse;
import com.ssafy.marimo.member.service.MemberService;
import jakarta.servlet.http.HttpServletRequest;
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
    private final AccessTokenUtil accessTokenUtil;

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

    @PostMapping("/admin")
    public String admin() {
        return "admin";
    }

    @GetMapping
    public String mainP() {
        String name = SecurityContextHolder.getContext().getAuthentication().getName();
        return "Main Page " + name;
    }

    // 테스트용 엔드포인트: 현재 요청의 accessToken에서 암호화된 memberId를 추출해서 반환
    @GetMapping("/memberid")
    public ResponseEntity<String> getMemberId(HttpServletRequest request) {
        String encryptedMemberId = accessTokenUtil.getEncryptedMemberId(request);
        if (encryptedMemberId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("No token provided or token invalid");
        }
        return ResponseEntity.ok(encryptedMemberId);
    }

}
