package com.ssafy.marimo.payment.dto;

import com.ssafy.marimo.car.domain.FuelType;
import java.time.LocalDateTime;
import lombok.Builder;

public record PostRepairPaymentRequest(
        String carId,
        Integer price,
        LocalDateTime paymentDate,
        String location,
        String memo,
        String repairPart
) {
}
