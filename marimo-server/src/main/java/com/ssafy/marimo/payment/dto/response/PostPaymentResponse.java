package com.ssafy.marimo.payment.dto.response;


import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record PostPaymentResponse(
        String carId,
        Integer price,
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
