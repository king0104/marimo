package com.ssafy.marimo.insurance.service;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.repository.CarRepository;
import com.ssafy.marimo.common.util.IdEncryptionUtil;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.NotFoundException;
import com.ssafy.marimo.insurance.domain.CarInsurance;
import com.ssafy.marimo.insurance.domain.Insurance;
import com.ssafy.marimo.insurance.domain.InsuranceDiscountRule;
import com.ssafy.marimo.insurance.dto.request.PostCarInsuranceRequest;
import com.ssafy.marimo.insurance.dto.response.GetCarInsuranceResponse;
import com.ssafy.marimo.insurance.dto.response.PostCarInsuranceResponse;
import com.ssafy.marimo.insurance.repository.CarInsuranceRepository;
import com.ssafy.marimo.insurance.repository.InsuranceDiscountRuleRepository;
import com.ssafy.marimo.insurance.repository.InsuranceRepository;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CarInsuranceService {

    private final CarInsuranceRepository carInsuranceRepository;
    private final CarRepository carRepository;
    private final InsuranceRepository insuranceRepository;
    private final IdEncryptionUtil idEncryptionUtil;
    private final InsuranceDiscountRuleRepository insuranceDiscountRuleRepository;

    public PostCarInsuranceResponse postCarInsurance(Integer carId, PostCarInsuranceRequest postCarInsuranceRequest) {
        Car car = carRepository.findById(carId)
                .orElseThrow(() -> new NotFoundException(ErrorStatus.CAR_NOT_FOUND.getErrorCode()));

        Insurance insurance = insuranceRepository.findByName(postCarInsuranceRequest.insuranceCompanyName())
                .orElseThrow(() -> new NotFoundException(ErrorStatus.INSURANCE_NOT_FOUND.getErrorCode()));

        CarInsurance carInsurance = CarInsurance.create(
                car,
                insurance,
                postCarInsuranceRequest.startDate(),
                postCarInsuranceRequest.endDate(),
                postCarInsuranceRequest.distanceRegistrationDate(),
                postCarInsuranceRequest.registeredDistance(),
                postCarInsuranceRequest.insurancePremium()
        );

        CarInsurance saved = carInsuranceRepository.save(carInsurance);

        return PostCarInsuranceResponse.of(idEncryptionUtil.encrypt(saved.getId()));
    }

    public GetCarInsuranceResponse getCarInsurance(Integer carId) {
        // 1. 현재 계산된 주행거리 구하기
        Car car = carRepository.findById(carId)
                .orElseThrow(() -> new NotFoundException(ErrorStatus.CAR_NOT_FOUND.getErrorCode()));

        // 2. 차량 ID로 보험 정보 조회
        CarInsurance carInsurance = carInsuranceRepository.findByCar(car)
                .orElseThrow(() -> new NotFoundException(ErrorStatus.CAR_INSURANCE_NOT_FOUND.getErrorCode()));
        Integer insuranceId = carInsurance.getInsurance().getId();

        // 3. 계산된 주행거리 예시 계산 / 월 평균 주행거리 게산 / 현재 날짜에 제출했을 때 예상 총 주행거리
        int calculatedDistance = car.getTotalDistance() - carInsurance.getRegisteredDistance(); // 자동차 총 주행거리 - 등록 당시

        long daysElapsed = Duration.between(carInsurance.getDistanceRegistrationDate(), LocalDateTime.now()).toDays();
        long daysRemaining = Duration.between(LocalDateTime.now(), carInsurance.getEndDate()).toDays();

        float dailyAverageDistance = Math.round((calculatedDistance / (float) daysElapsed) * 10) / 10.0f;
        float totalDistanceExpectation = calculatedDistance + Math.round((calculatedDistance / (float) daysElapsed) * daysRemaining * 10) / 10.0f;

        // 4. 현재 할인율 계산
        List<InsuranceDiscountRule> insuranceDiscountRules = insuranceDiscountRuleRepository.findByInsuranceIdOrderByDiscountFromKm(insuranceId);

        InsuranceDiscountRule currentRule = null;
        InsuranceDiscountRule nextRule = null;

        for (int i = 0; i < insuranceDiscountRules.size(); i++) {
            InsuranceDiscountRule rule = insuranceDiscountRules.get(i);
            if (calculatedDistance >= rule.getDiscountFromKm() && calculatedDistance <= rule.getDiscountToKm()) {
                currentRule = rule;
                if (i + 1 < insuranceDiscountRules.size()) {
                    nextRule = insuranceDiscountRules.get(i + 1);
                }
                break;
            }
        }

        if (currentRule == null) {
            throw new NotFoundException(ErrorStatus.DISCOUNT_RULE_NOT_FOUND.getErrorCode());
        }

        // 현재 주행거리를 제출해도 되는지 안되는지
        Boolean canSubmitDistanceNow = false;
        if (currentRule.getDiscountToKm() > totalDistanceExpectation) {
            canSubmitDistanceNow = true;
        }

        // 4. 할인 계산
        int insurancePremium = carInsurance.getInsurancePremium();

        double currentDiscountRate = currentRule.getDiscountRate();
        int currentDiscountAmount = (int) Math.round(insurancePremium * (currentDiscountRate / 100));
        int currentDiscountedPremium = insurancePremium - currentDiscountAmount;

        Integer remainingDistanceToNextDiscount = nextRule != null ? nextRule.getDiscountFromKm() - calculatedDistance : null;
        Double nextDiscountRate = nextRule != null ? (double) nextRule.getDiscountRate() : null;
        Integer nextDiscountAmount = nextRule != null
                ? (int) Math.round(insurancePremium * (nextRule.getDiscountRate() / 100))
                : null;
        Integer nextDiscountedPremium = nextRule != null
                ? insurancePremium - nextDiscountAmount
                : null;

        int discountDifferenceWithNextStage = nextRule != null ? currentDiscountAmount - nextDiscountAmount : currentDiscountAmount;


        double value = (calculatedDistance - currentRule.getDiscountFromKm()) /
                (currentRule.getDiscountToKm() - currentRule.getDiscountFromKm());

        String formatted = String.format("%.2f", value); // "0.75" 같은 문자열
        float drivingPercentage = Float.parseFloat(formatted); // float으로 변환

        // 5. 응답 객체 생성
        return GetCarInsuranceResponse.of(
                carInsurance.getInsurance().getName(),
                carInsurance.getEndDate(),
                carInsurance.getDistanceRegistrationDate(),
                carInsurance.getRegisteredDistance(),
                insurancePremium,

                calculatedDistance,
                currentDiscountRate,
                currentDiscountAmount,
                currentDiscountedPremium,

                remainingDistanceToNextDiscount,
                nextDiscountRate,
                nextDiscountAmount,
                nextDiscountedPremium,

                dailyAverageDistance,
                totalDistanceExpectation,
                discountDifferenceWithNextStage,
                canSubmitDistanceNow,
                drivingPercentage

        );

    }

}
