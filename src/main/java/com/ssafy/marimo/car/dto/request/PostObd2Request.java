package com.ssafy.marimo.car.dto.request;

import com.ssafy.marimo.car.dto.Obd2RawDataDto;
import java.time.LocalDateTime;
import java.util.List;

public record PostObd2Request(
        LocalDateTime clientCreatedAt,
        List<Obd2RawDataDto> Obd2RawDataDto
) {
}
