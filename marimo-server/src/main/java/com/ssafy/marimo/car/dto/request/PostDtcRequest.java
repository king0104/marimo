package com.ssafy.marimo.car.dto.request;

import java.util.List;
import lombok.Builder;

@Builder
public record PostDtcRequest (
        List<String> dtcs
) {
    public static PostDtcRequest of(List<String> dtcs) {
        return PostDtcRequest.builder()
                .dtcs(dtcs)
                .build();
    }
}
