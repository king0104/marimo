package com.ssafy.marimo.payment.service;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.repository.CarRepository;
import com.ssafy.marimo.common.util.IdEncryptionUtil;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.NotFoundException;
import com.ssafy.marimo.payment.domain.WashPayment;
import com.ssafy.marimo.payment.dto.PostWashPaymentRequest;
import com.ssafy.marimo.payment.dto.PostWashPaymentResponse;
import com.ssafy.marimo.payment.repository.WashPaymentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class WashPaymentService {


    private final IdEncryptionUtil idEncryptionUtil;
    private final WashPaymentRepository washPaymentRepository;
    private final CarRepository carRepository;

    public PostWashPaymentResponse postWashPayment(PostWashPaymentRequest postWashPaymentRequest) {
        Car car = carRepository.findById(idEncryptionUtil.decrypt(postWashPaymentRequest.carId()))
                .orElseThrow(() -> new NotFoundException(ErrorStatus.CAR_NOT_FOUND.getErrorCode()));

        WashPayment washPayment = washPaymentRepository.save(
                WashPayment.create(
                        car,
                        postWashPaymentRequest.price(),
                        postWashPaymentRequest.location(),
                        postWashPaymentRequest.memo(),
                        postWashPaymentRequest.washType()
                )
        );

        return PostWashPaymentResponse.of(
                idEncryptionUtil.encrypt(washPayment.getId()));
    }

}
