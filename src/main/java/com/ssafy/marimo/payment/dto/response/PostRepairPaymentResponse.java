package com.ssafy.marimo.payment.dto.response;

import lombok.Builder;

@Builder
public record PostRepairPaymentResponse (
        String paymentId
){
    public static PostRepairPaymentResponse of(String paymentId) {
        return PostRepairPaymentResponse.builder()
                .paymentId(paymentId)
                .build();
    }
}
