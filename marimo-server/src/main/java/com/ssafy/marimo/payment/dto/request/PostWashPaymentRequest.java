package com.ssafy.marimo.payment.dto.request;

import com.ssafy.marimo.navigation.WashType;
import java.time.LocalDateTime;

public record PostWashPaymentRequest(
    String carId,
    Integer price,
    LocalDateTime paymentDate,
    String location,
    String memo,
    WashType washType
) {
}