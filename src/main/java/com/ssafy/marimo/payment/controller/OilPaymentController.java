package com.ssafy.marimo.payment.controller;

import com.ssafy.marimo.payment.dto.PostOilPaymentResponse;
import com.ssafy.marimo.payment.dto.PostOilPaymentRequest;
import com.ssafy.marimo.payment.service.OilPaymentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/v1/payments/oils/")
@RequiredArgsConstructor
public class OilPaymentController {

    private final OilPaymentService oilPaymentService;

    @PostMapping()
    public ResponseEntity<PostOilPaymentRequest> postPayment(@Valid @RequestBody PostOilPaymentResponse postOilPaymentResponse) {

    }
}
