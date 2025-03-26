package com.ssafy.marimo.payment.dto.response;

import java.time.LocalDateTime;
import lombok.Builder;

@Builder
public record GetRepairPaymentResponse(
        Integer price,
        LocalDateTime paymentDate,
        String location,
        String memo,
        String repairPart
) {
    public static GetRepairPaymentResponse of(Integer price, LocalDateTime paymentDate, String location, String memo, String repairPart) {
        return GetRepairPaymentResponse.builder()
                .price(price)
                .paymentDate(paymentDate)
                .location(location)
                .memo(memo)
                .repairPart(repairPart)
                .build();
    }
}
