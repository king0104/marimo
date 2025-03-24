package com.ssafy.marimo.payment.dto;

import com.ssafy.marimo.car.domain.FuelType;
import com.ssafy.marimo.navigation.WashType;
import java.time.LocalDateTime;

public record PatchWashPaymentRequest (
        Integer price,
        LocalDateTime paymentDate,
        String location,
        String memo,
        WashType washType
){
}
