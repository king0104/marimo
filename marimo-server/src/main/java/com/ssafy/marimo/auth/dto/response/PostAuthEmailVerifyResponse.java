package com.ssafy.marimo.auth.dto.response;

import lombok.Builder;

@Builder
public record PostAuthEmailVerifyResponse(
        boolean valid
) {
    public static PostAuthEmailVerifyResponse of(boolean valid) {
        return PostAuthEmailVerifyResponse.builder()
                .valid(valid)
                .build();
    }
}