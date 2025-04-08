package com.ssafy.marimo.car.controller;

import com.ssafy.marimo.car.dto.request.PatchCarRequest;
import com.ssafy.marimo.car.dto.response.GetCarResponse;
import com.ssafy.marimo.car.dto.request.PostCarRequest;
import com.ssafy.marimo.car.dto.response.PatchCarResponse;
import com.ssafy.marimo.car.dto.response.PostCarResponse;
import com.ssafy.marimo.car.service.CarService;
import com.ssafy.marimo.common.annotation.CurrentMemberId;
import com.ssafy.marimo.common.annotation.DecryptedId;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/cars")
public class CarController {

    private final CarService carService;

    @PostMapping
    public ResponseEntity<PostCarResponse> postCar(@Valid @RequestBody PostCarRequest postCarRequest, @CurrentMemberId Integer memberId) {
        PostCarResponse postCarResponse = carService.postCar(postCarRequest, memberId);

        return ResponseEntity.status(HttpStatus.OK)
                .body(postCarResponse);
    }

    @GetMapping
    public ResponseEntity<GetCarResponse> getCar(@CurrentMemberId Integer memberId) {
        GetCarResponse getCarResponse = carService.getCar(memberId);

        return ResponseEntity.status(HttpStatus.OK)
                .body(getCarResponse);
    }

    @PatchMapping("/{carId}")
    public ResponseEntity<PatchCarResponse> patchCar(
            @Valid @RequestBody PatchCarRequest patchCarRequest,
            @PathVariable("carId") @DecryptedId Integer carId
    ) {
        PatchCarResponse patchCarResponse = carService.patchCar(patchCarRequest, carId);

        return ResponseEntity.status(HttpStatus.OK)
                .body(patchCarResponse);
    }

}
