package com.ssafy.marimo.member.dto.response;

import lombok.Builder;

@Builder
public record PostMemberLoginResponse(
        String accessToken
) {

    public static PostMemberLoginResponse of(String accessToken) {
        return PostMemberLoginResponse.builder()
                .accessToken(accessToken)
                .build();
    }
}
