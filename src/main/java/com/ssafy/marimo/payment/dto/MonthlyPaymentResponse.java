package com.ssafy.marimo.payment.dto;

import java.util.List;
import lombok.Builder;

@Builder
public record MonthlyPaymentResponse(
        int totalAmount,
        int diffFromLastMonth,
        List<PaymentItemDto> payments
) {
    public static MonthlyPaymentResponse of(int totalAmount, int diffFromLastMonth, List<PaymentItemDto> payments) {
        return MonthlyPaymentResponse.builder()
                .totalAmount(totalAmount)
                .diffFromLastMonth(diffFromLastMonth)
                .payments(payments)
                .build();
    }
}
