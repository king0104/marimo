package com.ssafy.marimo.member.dto.response;

import lombok.Builder;

@Builder
public record PostMemberFormResponse(
        String memberId
) {
    public static PostMemberFormResponse of(String memberId) {
        return PostMemberFormResponse.builder()
                .memberId(memberId)
                .build();
    }
}

