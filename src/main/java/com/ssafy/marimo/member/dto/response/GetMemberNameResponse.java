package com.ssafy.marimo.member.dto.response;

import lombok.Builder;

@Builder
public record GetMemberNameResponse(
        String name
) {
    public static GetMemberNameResponse of(String name) {
        return GetMemberNameResponse.builder()
                .name(name)
                .build();
    }
}
