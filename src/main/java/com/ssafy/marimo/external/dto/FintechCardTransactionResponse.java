package com.ssafy.marimo.external.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

@Data
public class FintechCardTransactionResponse {

    @JsonProperty("Header")
    private Header header;

    @JsonProperty("REC")
    private Rec rec;

    @Data
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

    @Data
    public static class Rec {
        private String cardIssuerCode;
        private String cardIssuerName;
        private String cardName;
        private String cardNo;
        private String cvc;
        private String estimatedBalance;

        @JsonProperty("transactionList")
        private List<Transaction> transactionList;
    }

    @Data
    public static class Transaction {
        private String transactionUniqueNo;
        private String categoryId;
        private String categoryName;
        private String merchantId;
        private String merchantName;
        private String transactionDate;
        private String transactionTime;
        private String transactionBalance;
        private String cardStatus; // e.g. 승인, 취소
        private String billStatementsYn; // e.g. Y/N
        private String billStatementsStatus; // e.g. 결제, 미결제
    }
}
