package com.ssafy.marimo.external.dto;


import lombok.Builder;

import java.util.List;

@Builder
public record GetCardsWithBenefitResponse(
        List<CardInfoDto> cards
) {

    public static GetCardsWithBenefitResponse of(List<CardInfoDto> cardInfoDtos) {
        return GetCardsWithBenefitResponse.builder()
                .cards(cardInfoDtos)
                .build();
    }
}
