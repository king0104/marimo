package com.ssafy.marimo.payment.controller;

import com.ssafy.marimo.payment.dto.PostWashPaymentRequest;
import com.ssafy.marimo.payment.dto.PostWashPaymentResponse;
import com.ssafy.marimo.payment.service.WashPaymentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/payments/wash")
@RequiredArgsConstructor
public class WashPaymentController {

    private final WashPaymentService washPaymentService;

    @PostMapping()
    public ResponseEntity<PostWashPaymentResponse> postWashPayment(
            @Valid @RequestBody PostWashPaymentRequest postWashPaymentRequest
    ) {
        PostWashPaymentResponse postWashPaymentResponse = washPaymentService.postWashPayment(postWashPaymentRequest);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(postWashPaymentResponse);
    }
}