package com.ssafy.marimo.car.dto.response;

import lombok.Builder;

@Builder
public record PatchCarResponse(
    String carId
) {
    public static PatchCarResponse of(String carId) {
        return PatchCarResponse.builder()
                .carId(carId)
                .build();
    }
}
