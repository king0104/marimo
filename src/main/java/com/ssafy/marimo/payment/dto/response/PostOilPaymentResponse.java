package com.ssafy.marimo.payment.dto.response;

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
