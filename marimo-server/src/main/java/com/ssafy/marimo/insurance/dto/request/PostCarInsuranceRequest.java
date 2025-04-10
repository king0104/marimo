package com.ssafy.marimo.insurance.dto.request;

import java.time.LocalDateTime;
import lombok.Builder;

@Builder
public record PostCarInsuranceRequest (
        String insuranceCompanyName,
        LocalDateTime startDate,
        LocalDateTime endDate,
        LocalDateTime distanceRegistrationDate,
        Integer registeredDistance,
        Integer insurancePremium
) {
    public static PostCarInsuranceRequest of(
            String insuranceCompanyName,
            LocalDateTime startDate,
            LocalDateTime endDate,
            LocalDateTime distanceRegistrationDate,
            Integer registeredDistance,
            Integer insurancePremium
    ) {
        return PostCarInsuranceRequest.builder()
                .insuranceCompanyName(insuranceCompanyName)
                .startDate(startDate)
                .endDate(endDate)
                .distanceRegistrationDate(distanceRegistrationDate)
                .registeredDistance(registeredDistance)
                .insurancePremium(insurancePremium)
                .build();
    }
}
