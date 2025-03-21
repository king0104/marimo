package com.ssafy.marimo.payment.dto;

import com.ssafy.marimo.car.domain.FuelType;
import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record PostOilPaymentRequest(
        String carId,
        int price,
        LocalDateTime paymentDate,
        String location,
        String memo,
        FuelType fuelType
) {

    public static PostOilPaymentRequest of(
            String carId,
            int price,
            LocalDateTime paymentDate,
            String location,
            String memo,
            FuelType fuelType
    ) {
        return PostOilPaymentRequest.builder()
                .carId(carId)
                .price(price)
                .paymentDate(paymentDate)
                .location(location)
                .memo(memo)
                .fuelType(fuelType)
                .build();
    }
}
