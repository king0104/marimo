package com.ssafy.marimo.car.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.ssafy.marimo.car.dto.Obd2RawDataDto;
import java.time.LocalDateTime;
import java.util.List;

public record PostObd2Request(
        LocalDateTime clientCreatedAt,
        @JsonProperty("obd2RawDatas")
        List<Obd2RawDataDto> obd2RawDataDtos
) {
}
