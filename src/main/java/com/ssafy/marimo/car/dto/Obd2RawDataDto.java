package com.ssafy.marimo.car.dto;

import lombok.Builder;
import lombok.Getter;

@Builder
public record Obd2RawDataDto(
        String pid,
        String code
) {
    public static Obd2RawDataDto of(String pid, String code) {
        return Obd2RawDataDto.builder()
                .pid(pid)
                .code(code)
                .build();
    }
}
