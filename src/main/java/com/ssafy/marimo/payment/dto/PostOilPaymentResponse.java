package com.ssafy.marimo.payment.dto;

import lombok.Builder;

@Builder
public record PostOilPaymentResponse(
        String paymentId
) {
    public static PostOilPaymentResponse of(String paymentId) {
        return PostOilPaymentResponse.builder()
                .paymentId(paymentId)
                .build();
    }
}
