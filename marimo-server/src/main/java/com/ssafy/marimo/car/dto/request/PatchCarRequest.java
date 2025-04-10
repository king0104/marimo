package com.ssafy.marimo.car.dto.request;

import com.ssafy.marimo.car.domain.FuelType;
import java.time.LocalDateTime;
import lombok.Builder;

@Builder
public record PatchCarRequest(
        String nickname,
        String plateNumber,
        String vehicleIdentificationNumber,
        String modelName,
        FuelType fuelType,
        LocalDateTime lastCheckedDate
) {
    public static PatchCarRequest of(
            String nickname,
            String plateNumber,
            String vehicleIdentificationNumber,
            String modelName,
            FuelType fuelType,
            LocalDateTime lastCheckedDate
    ) {
        return PatchCarRequest.builder()
                .nickname(nickname)
                .plateNumber(plateNumber)
                .vehicleIdentificationNumber(vehicleIdentificationNumber)
                .modelName(modelName)
                .fuelType(fuelType)
                .lastCheckedDate(lastCheckedDate)
                .build();
    }
}