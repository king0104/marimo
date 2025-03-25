package com.ssafy.marimo.payment.dto.response;

import com.ssafy.marimo.payment.dto.PaymentItemDto;
import java.util.List;
import lombok.Builder;

@Builder
public record GetMonthlyPaymentResponse(
        int totalAmount,
        int diffFromLastMonth,
        List<PaymentItemDto> payments
) {
    public static GetMonthlyPaymentResponse of(int totalAmount, int diffFromLastMonth, List<PaymentItemDto> payments) {
        return GetMonthlyPaymentResponse.builder()
                .totalAmount(totalAmount)
                .diffFromLastMonth(diffFromLastMonth)
                .payments(payments)
                .build();
    }
}
