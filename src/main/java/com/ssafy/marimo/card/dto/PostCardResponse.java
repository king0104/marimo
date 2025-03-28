package com.ssafy.marimo.card.dto;

import lombok.Builder;

@Builder
public record PostCardResponse (
        String memberCardId
) {
    public static PostCardResponse of(String memberCardId) {
        return PostCardResponse.builder()
                .memberCardId(memberCardId)
                .build();
    }
}
