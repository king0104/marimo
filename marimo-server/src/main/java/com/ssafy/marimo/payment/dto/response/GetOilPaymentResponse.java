package com.ssafy.marimo.payment.dto.response;

import com.ssafy.marimo.car.domain.FuelType;
import java.time.LocalDateTime;
import lombok.Builder;

@Builder
public record GetOilPaymentResponse(
        Integer price,
        LocalDateTime paymentDate,
        String location,
        String memo,
        FuelType fuelType
) {
    public static GetOilPaymentResponse of(Integer price, LocalDateTime paymentDate, String location, String memo, FuelType fuelType) {
        return GetOilPaymentResponse.builder()
                .price(price)
                .paymentDate(paymentDate)
                .location(location)
                .memo(memo)
                .fuelType(fuelType)
                .build();
    }
}
