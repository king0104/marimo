package com.ssafy.marimo.payment.service;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.repository.CarRepository;
import com.ssafy.marimo.common.util.IdEncryptionUtil;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.NotFoundException;
import com.ssafy.marimo.payment.domain.WashPayment;
import com.ssafy.marimo.payment.dto.response.GetWashPaymentResponse;
import com.ssafy.marimo.payment.dto.request.PatchWashPaymentRequest;
import com.ssafy.marimo.payment.dto.response.PatchWashPaymentResponse;
import com.ssafy.marimo.payment.dto.request.PostWashPaymentRequest;
import com.ssafy.marimo.payment.dto.response.PostWashPaymentResponse;
import com.ssafy.marimo.payment.repository.WashPaymentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class WashPaymentService {


    private final IdEncryptionUtil idEncryptionUtil;
    private final WashPaymentRepository washPaymentRepository;
    private final CarRepository carRepository;

    @Transactional
    public PostWashPaymentResponse postWashPayment(
            PostWashPaymentRequest postWashPaymentRequest
    ) {
        Car car = carRepository.findById(idEncryptionUtil.decrypt(postWashPaymentRequest.carId()))
                .orElseThrow(() -> new NotFoundException(ErrorStatus.CAR_NOT_FOUND.getErrorCode()));

        WashPayment washPayment = washPaymentRepository.save(
                WashPayment.create(
                        car,
                        postWashPaymentRequest.price(),
                        postWashPaymentRequest.paymentDate(),
                        postWashPaymentRequest.location(),
                        postWashPaymentRequest.memo(),
                        postWashPaymentRequest.washType()
                )
        );

        return PostWashPaymentResponse.of(
                idEncryptionUtil.encrypt(washPayment.getId()));
    }

    @Transactional
    public PatchWashPaymentResponse patchWashPayment(
            Integer paymentId,
            PatchWashPaymentRequest patchWashPaymentRequest
    ) {
        WashPayment washPayment = findById(paymentId);

        washPayment.updateFromRequestDto(patchWashPaymentRequest);

        return PatchWashPaymentResponse.of(
                idEncryptionUtil.encrypt(paymentId));
    }

    @Transactional
    public void deleteWashPayment(
            Integer paymentId
    ) {
        washPaymentRepository.deleteById(paymentId);
    }

    public GetWashPaymentResponse getWashPayment(
            Integer paymentId
    ) {
        WashPayment washPayment = findById(paymentId);

        return GetWashPaymentResponse.of(
                washPayment.getPrice(),
                washPayment.getPaymentDate(),
                washPayment.getLocation(),
                washPayment.getMemo(),
                washPayment.getWashType()
        );
    }

    private WashPayment findById(Integer paymentId) {
        return washPaymentRepository.findById(paymentId)
                .orElseThrow(() -> new NotFoundException(ErrorStatus.WASH_PAYMENT_NOT_FOUND.getErrorCode()));
    }


}
