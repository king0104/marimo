package com.ssafy.marimo.car.dto;

import lombok.Builder;

@Builder
public record obd2RawData(
        String pid,
        String code
) {
    public static obd2RawData of(String pid, String code) {
        return obd2RawData.builder()
                .pid(pid)
                .code(code)
                .build();
    }
}
