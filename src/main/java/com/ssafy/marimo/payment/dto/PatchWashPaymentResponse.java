package com.ssafy.marimo.payment.dto;

import lombok.Builder;

@Builder
public record PatchWashPaymentResponse(
        String paymentId
) {
    public static PatchWashPaymentResponse of(String paymentId) {
        return PatchWashPaymentResponse.builder()
                .paymentId(paymentId)
                .build();
    }
}