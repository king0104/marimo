package com.ssafy.marimo.payment.controller;

import com.ssafy.marimo.payment.dto.PostRepairPaymentRequest;
import com.ssafy.marimo.payment.dto.PostRepairPaymentResponse;
import com.ssafy.marimo.payment.service.RepairPaymentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.apache.coyote.Response;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/payments/repair")
@RequiredArgsConstructor
public class RepairPaymentController {

    private final RepairPaymentService repairPaymentService;


    @PostMapping()
    public ResponseEntity<PostRepairPaymentResponse> postRepairPayment(
            @Valid @RequestBody PostRepairPaymentRequest postRepairPaymentRequest
    ) {

        PostRepairPaymentResponse postRepairPaymentResponse = repairPaymentService.postRepairPayment(
                postRepairPaymentRequest);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(postRepairPaymentResponse);
    }

}
