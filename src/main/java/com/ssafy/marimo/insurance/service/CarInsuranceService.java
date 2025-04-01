package com.ssafy.marimo.insurance.service;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.repository.CarRepository;
import com.ssafy.marimo.common.util.IdEncryptionUtil;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.NotFoundException;
import com.ssafy.marimo.insurance.domain.CarInsurance;
import com.ssafy.marimo.insurance.domain.Insurance;
import com.ssafy.marimo.insurance.dto.request.PostCarInsuranceRequest;
import com.ssafy.marimo.insurance.dto.response.PostCarInsuranceResponse;
import com.ssafy.marimo.insurance.repository.CarInsuranceRepository;
import com.ssafy.marimo.insurance.repository.InsuranceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CarInsuranceService {

    private final CarInsuranceRepository carInsuranceRepository;
    private final CarRepository carRepository;
    private final InsuranceRepository insuranceRepository;
    private final IdEncryptionUtil idEncryptionUtil;

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

}
