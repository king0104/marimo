package com.ssafy.marimo.car.dto;
import com.ssafy.marimo.car.domain.FuelType;
import com.ssafy.marimo.car.domain.OBD2Status;
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
        FuelType fuelType,
        LocalDateTime lastCheckedDate,
        LocalDateTime tireCheckedDate,
        Integer totalDistance,
        Float fuelEfficiency,
        Float remainingFuel,
        OBD2Status obd2Status,
        LocalDateTime lastUpdateDate
) {

    public static CarInfoDto of(
            String carId,
            String nickname,
            String brand,
            String modelName,
            String plateNumber,
            String vehicleIdentificationNumber,
            FuelType fuelType,
            LocalDateTime lastCheckedDate,
            LocalDateTime tireCheckedDate,
            Integer totalDistance,
            Float fuelEfficiency,
            Float remainingFuel,
            OBD2Status obd2Status,
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
