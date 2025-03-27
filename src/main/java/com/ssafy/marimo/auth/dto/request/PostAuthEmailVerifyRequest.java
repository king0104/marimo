package com.ssafy.marimo.auth.dto.request;

public record PostAuthEmailVerifyRequest(String email,
                                         String authCode) {
}
