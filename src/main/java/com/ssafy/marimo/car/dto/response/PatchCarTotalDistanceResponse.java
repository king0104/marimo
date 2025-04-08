package com.ssafy.marimo.car.dto.response;

import lombok.Builder;

@Builder
public record PatchCarTotalDistanceResponse(
        String carId
) {
    public static PatchCarTotalDistanceResponse of(
            String carId
    ) {
        return PatchCarTotalDistanceResponse.builder()
                .carId(carId)
                .build();
    }
}
