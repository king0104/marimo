package com.ssafy.marimo.member.controller;

import com.ssafy.marimo.member.dto.request.PostMemberFormRequest;
import com.ssafy.marimo.member.dto.request.PostMemberLoginRequest;
import com.ssafy.marimo.member.dto.response.PostMemberFormResponse;
import com.ssafy.marimo.member.dto.response.PostMemberLoginResponse;
import com.ssafy.marimo.member.service.MemberService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/members")
public class MemberController {

    private final MemberService memberService;
    @PostMapping
    public ResponseEntity<PostMemberFormResponse> register(
            @Valid @RequestBody PostMemberFormRequest request) {
        PostMemberFormResponse response = memberService.postMemberForm(request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/form")
    public ResponseEntity<PostMemberLoginResponse> login(
            @Valid @RequestBody PostMemberLoginRequest request) {
        PostMemberLoginResponse response = memberService.postMemberLogin(request);
        return ResponseEntity.ok(response);
    }

}
