package com.ssafy.marimo.payment.service;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.repository.CarRepository;
import com.ssafy.marimo.common.util.IdEncryptionUtil;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.NotFoundException;
import com.ssafy.marimo.payment.domain.RepairPayment;
import com.ssafy.marimo.payment.repository.OilPaymentRepository;
import com.ssafy.marimo.payment.dto.response.GetRepairPaymentResponse;
import com.ssafy.marimo.payment.dto.request.PatchRepairPaymentRequest;
import com.ssafy.marimo.payment.dto.response.PatchRepairPaymentResponse;
import com.ssafy.marimo.payment.dto.request.PostRepairPaymentRequest;
import com.ssafy.marimo.payment.dto.response.PostRepairPaymentResponse;
import com.ssafy.marimo.payment.repository.RepairPaymentRepository;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class RepairPaymentService {

    private final IdEncryptionUtil idEncryptionUtil;
    private final RepairPaymentRepository repairPaymentRepository;
    private final CarRepository carRepository;
    private final OilPaymentRepository oilPaymentRepository;

    @Transactional
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

    @Transactional
    public PatchRepairPaymentResponse patchRepairPayment(
            Integer paymentId,
            PatchRepairPaymentRequest patchRepairPaymentRequest
    ) {
        RepairPayment repairPayment = findById(paymentId);

        repairPayment.updateFromRequestDto(patchRepairPaymentRequest);

        return PatchRepairPaymentResponse.of(idEncryptionUtil.encrypt(paymentId));
    }


    @Transactional
    public void deleteRepairPayment(
            Integer paymentId
    ) {
        repairPaymentRepository.deleteById(paymentId);
    }

    public GetRepairPaymentResponse getRepairPayment(
            Integer paymentId
    ) {
        RepairPayment repairPayment = findById(paymentId);

        return GetRepairPaymentResponse.of(
                repairPayment.getPrice(),
                repairPayment.getPaymentDate(),
                repairPayment.getLocation(),
                repairPayment.getMemo(),
                repairPayment.getRepairPart()
        );
    }

    private RepairPayment findById(Integer paymentId) {
        return repairPaymentRepository.findById(paymentId)
                .orElseThrow(() -> new NotFoundException(ErrorStatus.REPAIR_PAYMENT_NOT_FOUND.getErrorCode()));
    }
}
