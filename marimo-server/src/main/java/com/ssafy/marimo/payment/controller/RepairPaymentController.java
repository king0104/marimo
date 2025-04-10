package com.ssafy.marimo.payment.controller;

import com.ssafy.marimo.common.annotation.DecryptedId;
import com.ssafy.marimo.payment.dto.response.GetRepairPaymentResponse;
import com.ssafy.marimo.payment.dto.request.PatchRepairPaymentRequest;
import com.ssafy.marimo.payment.dto.response.PatchRepairPaymentResponse;
import com.ssafy.marimo.payment.dto.request.PostRepairPaymentRequest;
import com.ssafy.marimo.payment.dto.response.PostRepairPaymentResponse;
import com.ssafy.marimo.payment.service.RepairPaymentService;
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
@RequestMapping("/api/v1/payments/repair")
@RequiredArgsConstructor
public class RepairPaymentController {

    private final RepairPaymentService repairPaymentService;


    @PostMapping
    public ResponseEntity<PostRepairPaymentResponse> postRepairPayment(
            @Valid @RequestBody PostRepairPaymentRequest postRepairPaymentRequest
    ) {

        PostRepairPaymentResponse postRepairPaymentResponse = repairPaymentService.postRepairPayment(
                postRepairPaymentRequest);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(postRepairPaymentResponse);
    }

    @PatchMapping("{paymentId}")
    public ResponseEntity<PatchRepairPaymentResponse> patchRepairPayment(
            @PathVariable("paymentId") @DecryptedId Integer paymentId,
            @RequestBody PatchRepairPaymentRequest patchRepairPaymentRequest
    ) {
        PatchRepairPaymentResponse patchRepairPaymentResponse = repairPaymentService.patchRepairPayment(paymentId,
                patchRepairPaymentRequest);

        return ResponseEntity.status(HttpStatus.OK)
                .body(patchRepairPaymentResponse);
    }

    @DeleteMapping("/{paymentId}")
    public ResponseEntity<Void> deleteRepairPayment(
            @PathVariable("paymentId") @DecryptedId Integer paymentId
    ) {
        repairPaymentService.deleteRepairPayment(paymentId);

        return ResponseEntity.status(HttpStatus.OK)
                .build();
    }

    @GetMapping("/{paymentId}")
    public ResponseEntity<GetRepairPaymentResponse> getRepairPayment(
            @PathVariable @DecryptedId Integer paymentId
    ) {
        GetRepairPaymentResponse getRepairPaymentResponse = repairPaymentService.getRepairPayment(paymentId);

        return ResponseEntity.status(HttpStatus.OK)
                .body(getRepairPaymentResponse);
    }

}
