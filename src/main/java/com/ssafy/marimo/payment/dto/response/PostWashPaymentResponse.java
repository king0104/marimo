package com.ssafy.marimo.payment.dto.response;

import lombok.Builder;

@Builder
public record PostWashPaymentResponse(
        String paymentId
) {
    public static PostWashPaymentResponse of(String paymentId) {
        return PostWashPaymentResponse.builder()
                .paymentId(paymentId)
                .build();
    }
}
