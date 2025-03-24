package com.ssafy.marimo.payment.dto;

import lombok.Builder;

@Builder
public record PatchRepairPaymentResponse(
        String paymentId
) {
    public static PatchRepairPaymentResponse of(
            String paymentId
    ) {
        return PatchRepairPaymentResponse.builder()
                .paymentId(paymentId)
                .build();
    }
}
