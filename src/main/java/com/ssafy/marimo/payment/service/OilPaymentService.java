package com.ssafy.marimo.payment.service;

import com.ssafy.marimo.car.repository.CarRepository;
import com.ssafy.marimo.payment.dto.PostOilPaymentResponse;
import com.ssafy.marimo.payment.dto.PostOilPaymentRequest;
import com.ssafy.marimo.payment.repository.OilPaymentRepository;
import jakarta.persistence.criteria.CriteriaBuilder;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OilPaymentService {

    private static OilPaymentRepository oilPaymentRepository;
    private static CarRepository carRepository;

    public PostOilPaymentResponse postOilPayment(PostOilPaymentRequest postOilPaymentRequest) {

        carRepository.findById(postOilPaymentRequest.carId()); // decrept 관련 코드 작성 필요

        oilPaymentRepository.save()
    }
}
