package com.ssafy.marimo.car.controller;

import com.ssafy.marimo.car.dto.request.PostObd2Request;
import com.ssafy.marimo.car.service.Obd2Service;
import com.ssafy.marimo.common.annotation.DecryptedId;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/obd2")
public class Obd2Controller {
    private static Obd2Service obd2Service;

    @GetMapping("/{carId}")
    public ResponseEntity<Void> postObd2(@PathVariable @DecryptedId Integer carId, @Valid @RequestBody PostObd2Request postObd2Request) {
        obd2Service.postObd2(postObd2Request);
    }

}
