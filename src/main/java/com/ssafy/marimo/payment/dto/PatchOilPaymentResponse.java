package com.ssafy.marimo.payment.dto;

import lombok.Builder;

@Builder
public record PatchOilPaymentResponse(
        String paymentId
) {
    public static PatchOilPaymentResponse of(String paymentId) {
        return PatchOilPaymentResponse.builder()
                .paymentId(paymentId)
                .build();
    }
}
