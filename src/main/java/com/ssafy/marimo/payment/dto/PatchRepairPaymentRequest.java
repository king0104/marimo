package com.ssafy.marimo.payment.dto;

import com.ssafy.marimo.car.domain.FuelType;
import java.time.LocalDateTime;

public record PatchRepairPaymentRequest(
        Integer price,
        LocalDateTime paymentDate,
        String location,
        String memo,
        String repairPart
) {
}
