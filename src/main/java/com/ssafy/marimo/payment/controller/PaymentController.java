package com.ssafy.marimo.payment.controller;

import com.ssafy.marimo.payment.dto.PostPaymentResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/v1/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;

    @PostMapping()
    public ResponseEntity<PostPaymentResponse> postPayment(@Valid @RequestBody PostPaymentRequest postPaymentRequest) {

    }
}
