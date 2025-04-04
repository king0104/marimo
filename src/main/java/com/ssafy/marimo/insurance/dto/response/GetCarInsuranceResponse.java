package com.ssafy.marimo.insurance.dto.response;

import java.time.LocalDateTime;
import lombok.Builder;

@Builder
public record GetCarInsuranceResponse(
        String insuranceCompanyName,
        LocalDateTime endDate,
        LocalDateTime distanceRegistrationDate,
        Integer registeredDistance,
        Integer insurancePremium,

        Integer calculatedDistance,           // 계산된 주행거리
        Double currentDiscountRate,           // 현재 할인율 (%)
        Integer currentDiscountAmount,        // 현재 할인 금액 (얼마나 할인됐는지)
        Integer currentDiscountedPremium,     // 현재 할인된 보험료 (optional)

        // 다음 구간 관련
        Integer remainingDistanceToNextDiscount,        // 다음 할인 구간까지 남은 거리
        Double nextDiscountRate,              // 다음 할인율 (%)
        Integer nextDiscountAmount,           // 다음 할인 구간 예상 할인 금액
        Integer nextDiscountedPremium,         // 다음 구간 이동 시 할인된 보험료 (optional)

        Float dailyAverageDistance,
        Float totalDistanceExpectation,
        Integer discountDifferenceWithNextStage,
        Boolean canSubmitDistanceNow,
        Float drivingPercentage,

        Integer discountFromKm,
        Integer discountToKm,

        Integer totalDistance
) {
    public static GetCarInsuranceResponse of(
            String insuranceCompanyName,
            LocalDateTime endDate,
            LocalDateTime distanceRegistrationDate,
            Integer registeredDistance,
            Integer insurancePremium,
            Integer calculatedDistance,
            Double currentDiscountRate,
            Integer currentDiscountAmount,
            Integer currentDiscountedPremium,
            Integer remainingDistanceToNextDiscount,
            Double nextDiscountRate,
            Integer nextDiscountAmount,
            Integer nextDiscountedPremium,
            Float dailyAverageDistance,
            Float totalDistanceExpectation,
            Integer discountDifferenceWithNextStage,
            Boolean canSubmitDistanceNow,
            Float drivingPercentage,
            Integer discountFromKm,
            Integer discountToKm,
            Integer totalDistance
    ) {
        return GetCarInsuranceResponse.builder()
                .insuranceCompanyName(insuranceCompanyName)
                .endDate(endDate)
                .distanceRegistrationDate(distanceRegistrationDate)
                .registeredDistance(registeredDistance)
                .insurancePremium(insurancePremium)

                .calculatedDistance(calculatedDistance)
                .currentDiscountRate(currentDiscountRate)
                .currentDiscountAmount(currentDiscountAmount)
                .currentDiscountedPremium(currentDiscountedPremium)

                .remainingDistanceToNextDiscount(remainingDistanceToNextDiscount)
                .nextDiscountRate(nextDiscountRate)
                .nextDiscountAmount(nextDiscountAmount)
                .nextDiscountedPremium(nextDiscountedPremium)

                .dailyAverageDistance(dailyAverageDistance)
                .totalDistanceExpectation(totalDistanceExpectation)
                .discountDifferenceWithNextStage(discountDifferenceWithNextStage)
                .canSubmitDistanceNow(canSubmitDistanceNow)
                .drivingPercentage(drivingPercentage)
                .discountFromKm(discountFromKm)
                .discountToKm(discountToKm)
                .totalDistance(totalDistance)
                .build();
    }

}
