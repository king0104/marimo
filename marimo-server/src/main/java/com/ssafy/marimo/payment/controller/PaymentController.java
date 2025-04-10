package com.ssafy.marimo.payment.controller;

import com.ssafy.marimo.common.annotation.DecryptedId;
import com.ssafy.marimo.payment.dto.response.GetMonthlyPaymentResponse;
import com.ssafy.marimo.payment.service.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/payments")
public class PaymentController {

    private final PaymentService paymentService;

    @GetMapping("/cars/{carId}")
    public ResponseEntity<GetMonthlyPaymentResponse> getMonthlyHistory(
            @PathVariable("carId") @DecryptedId Integer carId,
            @RequestParam(value = "year", required = false) Integer year,
            @RequestParam(value = "month", required = false) Integer month
    ) {
        GetMonthlyPaymentResponse response = paymentService.getMonthlyHistory(carId, year, month);

        return ResponseEntity.status(HttpStatus.OK)
                .body(response);
    }

}
