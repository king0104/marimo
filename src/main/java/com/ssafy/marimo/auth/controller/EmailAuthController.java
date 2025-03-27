package com.ssafy.marimo.auth.controller;

import com.ssafy.marimo.auth.dto.request.PostAuthEmailSendRequest;
import com.ssafy.marimo.auth.dto.request.PostAuthEmailVerifyRequest;
import com.ssafy.marimo.auth.dto.response.PostAuthEmailSendResponse;
import com.ssafy.marimo.auth.dto.response.PostAuthEmailVerifyResponse;
import com.ssafy.marimo.auth.service.EmailAuthService;
import jakarta.mail.MessagingException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/auth/email")
public class EmailAuthController {

    private final EmailAuthService emailAuthService;

    @PostMapping("/send")
    public ResponseEntity<PostAuthEmailSendResponse> sendAuthCode(@RequestBody PostAuthEmailSendRequest request) {
        try {
            emailAuthService.sendSimpleMessage(request.email());
            return ResponseEntity.ok(PostAuthEmailSendResponse.of());
        } catch (MessagingException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/verify")
    public ResponseEntity<PostAuthEmailVerifyResponse> verifyAuthCode(@RequestBody PostAuthEmailVerifyRequest request) {
        boolean valid = emailAuthService.verifyAuthCode(request.email(), request.authCode());
        if (valid) {
            return ResponseEntity.ok(PostAuthEmailVerifyResponse.of(true));
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(PostAuthEmailVerifyResponse.of(false));
        }
    }
}
