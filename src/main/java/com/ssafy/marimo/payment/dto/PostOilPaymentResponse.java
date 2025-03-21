package com.ssafy.marimo.payment.dto;

import lombok.Builder;

@Builder
public record PostOilPaymentResponse(
        Integer paymentId
) {
    public static PostOilPaymentResponse of(Integer paymentId) {
        return PostOilPaymentResponse.builder()
                .paymentId(paymentId)
                .build();
    }
}
