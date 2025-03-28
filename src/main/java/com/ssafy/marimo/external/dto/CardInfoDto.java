package com.ssafy.marimo.external.dto;
import lombok.Builder;

@Builder
public record CardInfoDto(
        String cardUniqueNo,
        String cardIssuerName,
        String cardName,
        String cardDescription,
        String baselinePerformance
) {

    public static CardInfoDto of(
        String cardUniqueNo,
        String cardIssuerName,
        String cardName,
        String cardDescription,
        String baselinePerformance
    ) {
        return CardInfoDto.builder()
                .cardUniqueNo(cardUniqueNo)
                .cardIssuerName(cardIssuerName)
                .cardName(cardName)
                .cardDescription(cardDescription)
                .baselinePerformance(baselinePerformance)
                .build();
    }


}
