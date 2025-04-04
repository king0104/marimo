package com.ssafy.marimo.external.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class FintechCardTransactionResponse {

    @JsonProperty("Header")
    private Header header;

    // 추후 거래 내역 리스트가 추가되면 여기에 추가
    // private List<Transaction> transactions;

    @Data
    public static class Header {
        private String apiName;
        private String transmissionDate;
        private String transmissionTime;
        private String institutionCode;
        private String fintechAppNo;
        private String apiServiceCode;
        private String institutionTransactionUniqueNo;
        private String apiKey;
        private String userKey;
    }
}
