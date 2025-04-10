package com.ssafy.marimo.payment.dto;

import com.ssafy.marimo.payment.domain.Payment;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.Builder;

@Builder
public record PaymentItemDto(
        String paymentId,
        String type,
        Integer price,
        LocalDateTime paymentDate
) {
    public static PaymentItemDto of(String paymentId, String type, Integer price, LocalDateTime paymentDate) {
        return PaymentItemDto.builder()
                .paymentId(paymentId)
                .type(type)
                .price(price)
                .paymentDate(paymentDate)
                .build();
    }


}