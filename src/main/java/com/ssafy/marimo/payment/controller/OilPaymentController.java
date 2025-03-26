package com.ssafy.marimo.payment.controller;

import com.ssafy.marimo.common.annotation.DecryptedId;
import com.ssafy.marimo.payment.dto.response.GetOilPaymentResponse;
import com.ssafy.marimo.payment.dto.request.PatchOilPaymentRequest;
import com.ssafy.marimo.payment.dto.response.PatchWashPaymentResponse;
import com.ssafy.marimo.payment.dto.response.PostOilPaymentResponse;
import com.ssafy.marimo.payment.dto.request.PostOilPaymentRequest;
import com.ssafy.marimo.payment.service.OilPaymentService;
import jakarta.persistence.criteria.CriteriaBuilder.In;
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
@RequestMapping("/api/v1/payments/oil")
@RequiredArgsConstructor
public class OilPaymentController {

    private final OilPaymentService oilPaymentService;

    @PostMapping
    public ResponseEntity<PostOilPaymentResponse> postOilPayment(
            @Valid @RequestBody PostOilPaymentRequest postOilPaymentRequest
    ) {
        PostOilPaymentResponse postOilPaymentResponse = oilPaymentService.postOilPayment(postOilPaymentRequest);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(postOilPaymentResponse);
    }

    @PatchMapping("/{paymentId}")
    public ResponseEntity<PatchWashPaymentResponse> patchOilPayment(
            @PathVariable("paymentId") @DecryptedId Integer paymentId,
            @Valid @RequestBody PatchOilPaymentRequest patchOilPaymentRequest
    ) {
        PatchWashPaymentResponse patchOilPaymentResponse = oilPaymentService.patchOilPayment(paymentId, patchOilPaymentRequest);

        return ResponseEntity.status(HttpStatus.OK)
                .body(patchOilPaymentResponse);
    }

    @DeleteMapping("/{paymentId}")
    public ResponseEntity<Void> deleteOilPayment(
            @PathVariable("paymentId") @DecryptedId Integer paymentId
    ) {
        oilPaymentService.deleteOilPayment(paymentId);

        return ResponseEntity.status(HttpStatus.OK).build();
    }

    @GetMapping("/{paymentId}")
    public ResponseEntity<GetOilPaymentResponse> getOilPayment(
            @PathVariable @DecryptedId Integer paymentId
    ) {
        GetOilPaymentResponse getOilPaymentResponse = oilPaymentService.getOilPayment(paymentId);

        return ResponseEntity.status(HttpStatus.OK)
                .body(getOilPaymentResponse);
    }
}
