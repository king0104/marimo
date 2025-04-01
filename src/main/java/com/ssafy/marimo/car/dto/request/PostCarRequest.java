package com.ssafy.marimo.car.dto.request;

import com.ssafy.marimo.car.domain.FuelType;

public record PostCarRequest(
    String nickname,
    String brand,
    String modelName,
    String plateNumber,
    String vehicleIdentificationNumber,
    FuelType fuelType
) {
}
