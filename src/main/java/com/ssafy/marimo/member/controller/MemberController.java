package com.ssafy.marimo.member.controller;

import com.ssafy.marimo.common.annotation.CurrentMemberId;
import com.ssafy.marimo.common.annotation.DecryptedId;
import com.ssafy.marimo.member.dto.request.PostMemberFormRequest;
import com.ssafy.marimo.member.dto.request.PostMemberLoginRequest;
import com.ssafy.marimo.member.dto.response.GetMemberNameResponse;
import com.ssafy.marimo.member.dto.response.PostMemberFormResponse;
import com.ssafy.marimo.member.dto.response.PostMemberLoginResponse;
import com.ssafy.marimo.member.service.CustomUserDetails;
import com.ssafy.marimo.member.service.MemberService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.Getter;
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

    @GetMapping("/name")
    public ResponseEntity<GetMemberNameResponse> getName(
            @CurrentMemberId Integer memberId
    ) {
        GetMemberNameResponse getMemberNameResponse = memberService.getName(memberId);

        return ResponseEntity.status(HttpStatus.OK)
                .body(getMemberNameResponse);
    }

}
