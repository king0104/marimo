package com.ssafy.marimo.car.controller;

import com.ssafy.marimo.car.dto.request.PostDtcRequest;
import com.ssafy.marimo.car.dto.request.PostObd2Request;
import com.ssafy.marimo.car.service.DtcService;
import com.ssafy.marimo.car.service.Obd2Service;
import com.ssafy.marimo.common.annotation.DecryptedId;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/dtc")
@RequiredArgsConstructor
public class DtcController {

    private final DtcService dtcService;

    @PostMapping("/cars/{carId}")
    public ResponseEntity<Void> postDtc(@PathVariable @DecryptedId Integer carId, @Valid @RequestBody PostDtcRequest postDtcRequest) {
        dtcService.postDtc(postDtcRequest, carId);

        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

}
