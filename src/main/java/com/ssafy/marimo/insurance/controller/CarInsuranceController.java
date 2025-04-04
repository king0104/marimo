package com.ssafy.marimo.insurance.controller;

import com.ssafy.marimo.common.annotation.DecryptedId;
import com.ssafy.marimo.insurance.dto.request.PostCarInsuranceRequest;
import com.ssafy.marimo.insurance.dto.response.GetCarInsuranceResponse;
import com.ssafy.marimo.insurance.dto.response.PostCarInsuranceResponse;
import com.ssafy.marimo.insurance.service.CarInsuranceService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/car-insurances")
@RequiredArgsConstructor
public class CarInsuranceController {

    private final CarInsuranceService carInsuranceService;

    @PostMapping("/cars/{carId}")
    public ResponseEntity<PostCarInsuranceResponse> postCarInsurance(
            @PathVariable @DecryptedId Integer carId,
            @Valid @RequestBody PostCarInsuranceRequest postCarInsuranceRequest)
    {

        PostCarInsuranceResponse postCarInsuranceResponse = carInsuranceService.postCarInsurance(carId,
                postCarInsuranceRequest);

        return ResponseEntity.status(HttpStatus.OK)
                .body(postCarInsuranceResponse);

    }

    @GetMapping("/cars/{carId}")
    public ResponseEntity<GetCarInsuranceResponse> getCarInsurance(
            @PathVariable @DecryptedId Integer carId
    ) {
        GetCarInsuranceResponse carInsuranceResponse = carInsuranceService.getCarInsurance(carId);

        return ResponseEntity.status(HttpStatus.OK)
                .body(carInsuranceResponse);
    }

    @DeleteMapping("/cars/{carId}")
    public ResponseEntity<Void> deleteCarInsurance(
            @PathVariable @DecryptedId Integer carId
    ) {
        carInsuranceService.deleteCarInsurance(carId);

        return ResponseEntity.status(HttpStatus.OK).build();
    }

}
