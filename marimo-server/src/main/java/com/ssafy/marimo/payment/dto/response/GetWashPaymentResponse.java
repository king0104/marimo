package com.ssafy.marimo.payment.dto.response;

import com.ssafy.marimo.navigation.WashType;
import java.time.LocalDateTime;

import lombok.Builder;

@Builder
public record GetWashPaymentResponse(
        Integer price,
        LocalDateTime paymentDate,
        String location,
        String memo,
        WashType washType
) {
    public static GetWashPaymentResponse of(Integer price, LocalDateTime paymentDate, String location, String memo, WashType washType) {
        return GetWashPaymentResponse.builder()
                .price(price)
                .paymentDate(paymentDate)
                .location(location)
                .memo(memo)
                .washType(washType)
                .build();
    }
}
