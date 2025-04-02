package com.ssafy.marimo.car.dto.request;

import com.ssafy.marimo.car.dto.obd2RawData;
import java.time.LocalDateTime;
import java.util.List;

public record PostObd2Request(
        LocalDateTime clientCreatedAt,
        List<obd2RawData> obd2RawDatas
) {
}
