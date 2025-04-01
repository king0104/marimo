package com.ssafy.marimo.car.dto;

import com.ssafy.marimo.car.domain.FuelType;
import java.time.LocalDateTime;

public record PostCarRequest(
    String nickname,
    String brand,
    String modelName,
    String plateNumber,
    String vehicleIdentificationNumber,
    FuelType fuelType,
    LocalDateTime lastCheckedDate
) {
}
