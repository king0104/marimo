package com.ssafy.marimo.external.dto;


import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
public class FintechCardListResponse {

    @JsonProperty("Header")
    private Header header;

    @JsonProperty("REC")
    private List<CardInfo> rec;

    @Getter
    @NoArgsConstructor
    public static class Header {
        private String responseCode;
        private String responseMessage;
        private String apiName;
        private String transmissionDate;
        private String transmissionTime;
        private String institutionCode;
        private String apiKey;
        private String apiServiceCode;
        private String institutionTransactionUniqueNo;
    }

    @Getter
    @NoArgsConstructor
    public static class CardInfo {
        private String cardNo;
        private String cardUniqueNo;
        private String cardIssuerCode;
        private String cardIssuerName;
        private String cardName;
        private String baselinePerformance;
        private String maxBenefitLimit;
        private String cardDescription;
        private String cardExpiryDate;
        private String withdrawalAccountNo;
        private String withdrawalDate;
    }
}
