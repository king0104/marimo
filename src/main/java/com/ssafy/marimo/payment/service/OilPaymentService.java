package com.ssafy.marimo.payment.service;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.repository.CarRepository;
import com.ssafy.marimo.common.util.IdEncryptionUtil;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.NotFoundException;
import com.ssafy.marimo.payment.domain.OilPayment;
import com.ssafy.marimo.payment.dto.response.GetOilPaymentResponse;
import com.ssafy.marimo.payment.dto.request.PatchOilPaymentRequest;
import com.ssafy.marimo.payment.dto.response.PatchWashPaymentResponse;
import com.ssafy.marimo.payment.dto.response.PostOilPaymentResponse;
import com.ssafy.marimo.payment.dto.request.PostOilPaymentRequest;
import com.ssafy.marimo.payment.repository.OilPaymentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class OilPaymentService {

    private final OilPaymentRepository oilPaymentRepository;
    private final CarRepository carRepository;
    private final IdEncryptionUtil idEncryptionUtil;

    @Transactional
    public PostOilPaymentResponse postOilPayment(PostOilPaymentRequest postOilPaymentRequest) {

        Car car = carRepository.findById(idEncryptionUtil.decrypt(postOilPaymentRequest.carId()))
                .orElseThrow(() -> new NotFoundException(ErrorStatus.CAR_NOT_FOUND.getErrorCode()));

        OilPayment oilPayment = oilPaymentRepository.save(
                OilPayment.create(
                        car,
                        postOilPaymentRequest.price(),
                        postOilPaymentRequest.paymentDate(),
                        postOilPaymentRequest.location(),
                        postOilPaymentRequest.memo(),
                        postOilPaymentRequest.fuelType()
                )
        );

        return PostOilPaymentResponse.of(
                idEncryptionUtil.encrypt(oilPayment.getId()));
    }

    @Transactional
    public PatchWashPaymentResponse patchOilPayment(Integer paymentId, PatchOilPaymentRequest patchOilPaymentRequest) {
        OilPayment oilPayment = oilPaymentRepository.findById(paymentId)
                .orElseThrow(() -> new NotFoundException(ErrorStatus.OIL_PAYMENT_NOT_FOUND.getErrorCode()));

        oilPayment.updateFromRequestDto(patchOilPaymentRequest);

        return PatchWashPaymentResponse.of(
                idEncryptionUtil.encrypt(paymentId));

    }

    @Transactional
    public void deleteOilPayment(Integer paymentId) {
        oilPaymentRepository.deleteById(paymentId);
    }

    public GetOilPaymentResponse getOilPayment(Integer paymentId) {
        OilPayment oilPayment = oilPaymentRepository.findById(paymentId)
                .orElseThrow(() -> new NotFoundException(ErrorStatus.OIL_PAYMENT_NOT_FOUND.getErrorCode()));

        return GetOilPaymentResponse.of(
                oilPayment.getPrice(),
                oilPayment.getPaymentDate(),
                oilPayment.getLocation(),
                oilPayment.getMemo(),
                oilPayment.getFuelType()
        );


    }

}
