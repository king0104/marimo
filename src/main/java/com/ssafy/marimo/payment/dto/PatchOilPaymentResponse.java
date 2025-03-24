package com.ssafy.marimo.payment.dto;

import lombok.Builder;

@Builder
public record PatchOilPaymentResponse(
        String paymentId
) {
    public static PatchWashPaymentResponse of(String paymentId) {
        return PatchWashPaymentResponse.builder()
                .paymentId(paymentId)
                .build();
    }
}
