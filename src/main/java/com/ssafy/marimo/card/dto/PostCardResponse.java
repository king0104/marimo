package com.ssafy.marimo.card.dto;

import lombok.Builder;

@Builder
public record PostCardResponse (
        String cardId
) {
    public static PostCardResponse of(String cardId) {
        return PostCardResponse.builder()
                .cardId(cardId)
                .build();
    }
}
