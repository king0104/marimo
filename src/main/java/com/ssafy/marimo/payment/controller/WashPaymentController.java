package com.ssafy.marimo.payment.controller;

import com.ssafy.marimo.common.annotation.DecryptedId;
import com.ssafy.marimo.payment.dto.response.GetWashPaymentResponse;
import com.ssafy.marimo.payment.dto.request.PatchWashPaymentRequest;
import com.ssafy.marimo.payment.dto.response.PatchWashPaymentResponse;
import com.ssafy.marimo.payment.dto.request.PostWashPaymentRequest;
import com.ssafy.marimo.payment.dto.response.PostWashPaymentResponse;
import com.ssafy.marimo.payment.service.WashPaymentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
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

    @PatchMapping("/{paymentId}")
    public ResponseEntity<PatchWashPaymentResponse> patchWashPayment(
            @PathVariable("paymentId") @DecryptedId Integer paymentId,
            @RequestBody PatchWashPaymentRequest patchWashPaymentRequest
    ) {
        PatchWashPaymentResponse patchWashPaymentResponse = washPaymentService.patchWashPayment(paymentId,
                patchWashPaymentRequest);

        return ResponseEntity.status(HttpStatus.OK)
                .body(patchWashPaymentResponse);
    }

    @DeleteMapping("/{paymentId}")
    public ResponseEntity<Void> deleteWashPayment(
            @PathVariable("paymentId") @DecryptedId Integer paymentId
    ) {
        washPaymentService.deleteWashPayment(paymentId);

        return ResponseEntity.status(HttpStatus.OK)
                .build();
    }

    @GetMapping("/{paymentId}")
    public ResponseEntity<GetWashPaymentResponse> getWashPayment(
            @PathVariable("paymentId") @DecryptedId Integer paymentId
    ) {
        GetWashPaymentResponse getWashPaymentResponse = washPaymentService.getWashPayment(paymentId);

        return ResponseEntity.status(HttpStatus.OK)
                .body(getWashPaymentResponse);
    }
}