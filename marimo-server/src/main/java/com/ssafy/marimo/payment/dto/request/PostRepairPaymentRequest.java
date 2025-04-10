package com.ssafy.marimo.payment.dto.request;

import java.time.LocalDateTime;

public record PostRepairPaymentRequest(
        String carId,
        Integer price,
        LocalDateTime paymentDate,
        String location,
        String memo,
        String repairParts
) {
}
