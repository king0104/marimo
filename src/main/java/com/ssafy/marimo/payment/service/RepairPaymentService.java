package com.ssafy.marimo.payment.service;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.repository.CarRepository;
import com.ssafy.marimo.common.util.IdEncryptionUtil;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.NotFoundException;
import com.ssafy.marimo.payment.domain.RepairPayment;
import com.ssafy.marimo.payment.dto.PostRepairPaymentRequest;
import com.ssafy.marimo.payment.dto.PostRepairPaymentResponse;
import com.ssafy.marimo.payment.repository.RepairPaymentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RepairPaymentService {

    private final IdEncryptionUtil idEncryptionUtil;
    private final RepairPaymentRepository repairPaymentRepository;
    private final CarRepository carRepository;

    public PostRepairPaymentResponse postRepairPayment(PostRepairPaymentRequest postRepairPaymentRequest) {
        Car car = carRepository.findById(idEncryptionUtil.decrypt(postRepairPaymentRequest.carId()))
                .orElseThrow(() -> new NotFoundException(ErrorStatus.CAR_NOT_FOUND.getErrorCode()));

        RepairPayment repairPayment = repairPaymentRepository.save(
                RepairPayment.create(
                        car,
                        postRepairPaymentRequest.price(),
                        postRepairPaymentRequest.paymentDate(),
                        postRepairPaymentRequest.location(),
                        postRepairPaymentRequest.memo(),
                        postRepairPaymentRequest.repairPart()
                )
        );

        return PostRepairPaymentResponse.of(idEncryptionUtil.encrypt(repairPayment.getId()));

    }
}
