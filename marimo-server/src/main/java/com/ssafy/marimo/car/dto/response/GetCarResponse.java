package com.ssafy.marimo.car.dto.response;


import com.ssafy.marimo.car.dto.CarInfoDto;
import java.util.List;
import lombok.Builder;

@Builder
public record GetCarResponse(
        List<CarInfoDto> carInfoDtos
) {
    public static GetCarResponse of(List<CarInfoDto> carInfoDtos) {
        return GetCarResponse.builder()
                .carInfoDtos(carInfoDtos)
                .build();
    }
}
