package com.ssafy.marimo.car.dto;

import lombok.Builder;

@Builder
public record PostCarResponse (
        String carId
) {
    public static PostCarResponse of(
            String carId
    ) {
        return PostCarResponse.builder()
                .carId(carId)
                .build();
    }
}
