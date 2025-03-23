package com.ssafy.marimo.payment.dto;

import com.ssafy.marimo.car.domain.FuelType;
import jakarta.persistence.criteria.CriteriaBuilder.In;
import lombok.Builder;

import java.time.LocalDateTime;

public record PostOilPaymentRequest(
        String carId,
        Integer price,
        LocalDateTime paymentDate,
        String location,
        String memo,
        FuelType fuelType
) {

}
