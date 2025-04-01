package com.ssafy.marimo.car.dto.request;

import com.ssafy.marimo.car.domain.FuelType;
import lombok.Builder;

@Builder
public record PatchCarRequest(
        String nickname,
        String plateNumber,
        String vehicleIdentificationNumber,
        String modelName,
        FuelType fuelType
) {
    public static PatchCarRequest of(String nickname, String plateNumber, String vehicleIdentificationNumber,
                                     String modelName, FuelType fuelType) {
        return PatchCarRequest.builder()
                .nickname(nickname)
                .plateNumber(plateNumber)
                .vehicleIdentificationNumber(vehicleIdentificationNumber)
                .modelName(modelName)
                .fuelType(fuelType)
                .build();
    }
}