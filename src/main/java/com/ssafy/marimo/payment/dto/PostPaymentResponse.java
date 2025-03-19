package com.ssafy.marimo.payment.dto;


import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Builder
public record PostPaymentResponse(
        String carId,
        int price,
        LocalDateTime paymentDate,
        String location,
        String memo
) {
    public static PostPaymentResponse of(
            String carId,
            int price,
            LocalDateTime paymentDate,
            String location,
            String memo
    ) {
        return PostPaymentResponse.builder()
                .carId(carId)
                .price(price)
                .paymentDate(paymentDate)
                .location(location)
                .memo(memo)
                .build();
    }
}
