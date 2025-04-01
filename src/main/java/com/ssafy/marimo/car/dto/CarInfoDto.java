package com.ssafy.marimo.car.dto;
import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record CarInfoDto(
        String carId,
        String nickname,
        String brand,
        String modelName,
        String plateNumber,
        String vehicleIdentificationNumber,
        String fuelType,
        LocalDateTime lastCheckedDate,
        LocalDateTime tireCheckedDate,
        Integer totalDistance,
        Float fuelEfficiency,
        Float remainingFuel,
        String obd2Status,
        LocalDateTime lastUpdateDate
) {

    public static CarInfoDto of(
            String carId,
            String nickname,
            String brand,
            String modelName,
            String plateNumber,
            String vehicleIdentificationNumber,
            String fuelType,
            LocalDateTime lastCheckedDate,
            LocalDateTime tireCheckedDate,
            Integer totalDistance,
            Float fuelEfficiency,
            Float remainingFuel,
            String obd2Status,
            LocalDateTime lastUpdateDate
    ) {
        return CarInfoDto.builder()
                .carId(carId)
                .nickname(nickname)
                .brand(brand)
                .modelName(modelName)
                .plateNumber(plateNumber)
                .vehicleIdentificationNumber(vehicleIdentificationNumber)
                .fuelType(fuelType)
                .lastCheckedDate(lastCheckedDate)
                .tireCheckedDate(tireCheckedDate)
                .totalDistance(totalDistance)
                .fuelEfficiency(fuelEfficiency)
                .remainingFuel(remainingFuel)
                .obd2Status(obd2Status)
                .lastUpdateDate(lastUpdateDate)
                .build();
    }
}
