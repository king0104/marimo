package com.ssafy.marimo.member.dto.response;

import lombok.Builder;

@Builder
public record PostMemberLoginResponse(
        String memberId
) {

    public static PostMemberLoginResponse of(String memberId) {
        return PostMemberLoginResponse.builder()
                .memberId(memberId)
                .build();
    }
}
